/**
 * 解析 Charles 新版 .chlz（ZIP 压缩包）并转成 APIAuto Document + TestRecord 记录，
 * 输出格式与 Charles.js 的 charlesSessionToDocuments 完全一致：{ groupName, list: [{ Document, TestRecord }] }。
 *
 * .chlz 结构（Charles 4.x+，对应 Charles 内部 TransactionJSONWriter）：
 *   N-meta.json      事务元数据，结构同 .chlsj：method/scheme/host/actualPort/path/query/times/request/response
 *                    request/response 含 header: { firstLine, headers: [{ name, value }] }、body 信息
 *   N-req.<ext>      请求 Body（已按 Content-Encoding 解码）
 *   N-req-enc.dat    请求 Body 原始字节（可能仍是 gzip 等压缩态）
 *   N-res.<ext>      响应 Body（已解码）
 *   N-res-enc.dat    响应 Body 原始字节
 * 也兼容 .chlsj（未压缩的 JSON 数组，Body 内联在 JSON 里）。
 *
 * 不依赖 JSZip / pako，内置 ZIP 读取 + inflate，因此和 Charles.js 一样是同步调用，不引入全局变量以外的冲突：
 * 所有辅助函数都在闭包内，仅暴露 parseCharlesNewSession / charlesNewSessionToDocuments。
 */
(function (global) {
  var CHARLES_NEW_SESSION_FILE = 'Charles_apijson_session.chlz'

  // ---------------------------------------------------------------- inflate (RFC1951，参考 zlib puff.c)

  var LEN_BASE = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258]
  var LEN_EXTRA = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0]
  var DIST_BASE = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577]
  var DIST_EXTRA = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13]
  var CL_ORDER = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]
  var fixedTables = null

  function buildHuffman(lengths, n) {
    var count = new Uint16Array(16)
    var offs = new Uint16Array(16)
    var symbol = new Uint16Array(n)
    var i
    for (i = 0; i < n; i++) {
      count[lengths[i]]++
    }
    for (i = 1; i < 15; i++) {
      offs[i + 1] = offs[i] + count[i]
    }
    for (i = 0; i < n; i++) {
      if (lengths[i] !== 0) {
        symbol[offs[lengths[i]]++] = i
      }
    }
    return { count: count, symbol: symbol }
  }

  function InflateState(src, pos) {
    this.src = src
    this.pos = pos || 0
    this.bitBuf = 0
    this.bitCnt = 0
    this.out = new Uint8Array(Math.max(1024, src.length * 4))
    this.outLen = 0
  }

  InflateState.prototype.bits = function (need) {
    var val = this.bitBuf
    while (this.bitCnt < need) {
      if (this.pos >= this.src.length) {
        throw new Error('deflate 数据意外结束')
      }
      val |= this.src[this.pos++] << this.bitCnt
      this.bitCnt += 8
    }
    this.bitBuf = val >>> need
    this.bitCnt -= need
    return val & ((1 << need) - 1)
  }

  InflateState.prototype.put = function (b) {
    if (this.outLen >= this.out.length) {
      var bigger = new Uint8Array(this.out.length * 2)
      bigger.set(this.out)
      this.out = bigger
    }
    this.out[this.outLen++] = b
  }

  InflateState.prototype.decode = function (h) {
    var code = 0
    var first = 0
    var index = 0
    for (var len = 1; len <= 15; len++) {
      code |= this.bits(1)
      var count = h.count[len]
      if (code - count < first) {
        return h.symbol[index + (code - first)]
      }
      index += count
      first += count
      first <<= 1
      code <<= 1
    }
    throw new Error('无效的 Huffman 编码')
  }

  InflateState.prototype.codes = function (lenH, distH) {
    while (true) {
      var sym = this.decode(lenH)
      if (sym < 256) {
        this.put(sym)
      } else if (sym === 256) {
        return
      } else {
        sym -= 257
        if (sym >= 29) {
          throw new Error('无效的长度符号')
        }
        var len = LEN_BASE[sym] + this.bits(LEN_EXTRA[sym])
        var dsym = this.decode(distH)
        if (dsym >= 30) {
          throw new Error('无效的距离符号')
        }
        var dist = DIST_BASE[dsym] + this.bits(DIST_EXTRA[dsym])
        if (dist > this.outLen) {
          throw new Error('deflate 距离超出范围')
        }
        for (var i = 0; i < len; i++) {
          this.put(this.out[this.outLen - dist])
        }
      }
    }
  }

  function getFixedTables() {
    if (fixedTables == null) {
      var l = new Uint8Array(288)
      var i
      for (i = 0; i < 144; i++) l[i] = 8
      for (; i < 256; i++) l[i] = 9
      for (; i < 280; i++) l[i] = 7
      for (; i < 288; i++) l[i] = 8
      var d = new Uint8Array(30)
      for (i = 0; i < 30; i++) d[i] = 5
      fixedTables = { len: buildHuffman(l, 288), dist: buildHuffman(d, 30) }
    }
    return fixedTables
  }

  /** 解压裸 deflate 流；返回 { data, end }，end 为输入里消耗到的位置 */
  function inflateRaw(src, start) {
    var st = new InflateState(src, start)
    var last
    do {
      last = st.bits(1)
      var type = st.bits(2)
      if (type === 0) {
        st.bitBuf = 0
        st.bitCnt = 0
        if (st.pos + 4 > src.length) {
          throw new Error('deflate 数据意外结束')
        }
        var len = src[st.pos] | (src[st.pos + 1] << 8)
        st.pos += 4
        if (st.pos + len > src.length) {
          throw new Error('deflate 数据意外结束')
        }
        for (var i = 0; i < len; i++) {
          st.put(src[st.pos++])
        }
      } else if (type === 1) {
        var fixed = getFixedTables()
        st.codes(fixed.len, fixed.dist)
      } else if (type === 2) {
        var nlen = st.bits(5) + 257
        var ndist = st.bits(5) + 1
        var ncode = st.bits(4) + 4
        var lengths = new Uint8Array(320)
        var k
        for (k = 0; k < ncode; k++) {
          lengths[CL_ORDER[k]] = st.bits(3)
        }
        var clh = buildHuffman(lengths.subarray(0, 19), 19)
        var all = new Uint8Array(nlen + ndist)
        var idx = 0
        while (idx < nlen + ndist) {
          var sym = st.decode(clh)
          if (sym < 16) {
            all[idx++] = sym
          } else {
            var prev = 0
            var rep
            if (sym === 16) {
              if (idx === 0) {
                throw new Error('无效的重复长度')
              }
              prev = all[idx - 1]
              rep = 3 + st.bits(2)
            } else if (sym === 17) {
              rep = 3 + st.bits(3)
            } else {
              rep = 11 + st.bits(7)
            }
            if (idx + rep > nlen + ndist) {
              throw new Error('无效的重复长度')
            }
            while (rep-- > 0) {
              all[idx++] = prev
            }
          }
        }
        st.codes(buildHuffman(all.subarray(0, nlen), nlen), buildHuffman(all.subarray(nlen), ndist))
      } else {
        throw new Error('无效的 deflate 块类型')
      }
    } while (!last)
    return { data: st.out.subarray(0, st.outLen), end: st.pos }
  }

  function gunzip(bytes) {
    if (bytes.length < 18 || bytes[0] !== 0x1f || bytes[1] !== 0x8b || bytes[2] !== 8) {
      throw new Error('不是 gzip 数据')
    }
    var flg = bytes[3]
    var pos = 10
    if (flg & 4) {
      pos += 2 + (bytes[pos] | (bytes[pos + 1] << 8))
    }
    if (flg & 8) {
      while (bytes[pos++] !== 0) { }
    }
    if (flg & 16) {
      while (bytes[pos++] !== 0) { }
    }
    if (flg & 2) {
      pos += 2
    }
    return inflateRaw(bytes, pos).data
  }

  function zlibInflate(bytes) {
    if (bytes.length > 2 && (bytes[0] & 0x0f) === 8 && ((bytes[0] << 8) | bytes[1]) % 31 === 0) {
      return inflateRaw(bytes, 2).data
    }
    return inflateRaw(bytes, 0).data
  }

  // ---------------------------------------------------------------- ZIP 读取

  function readZip(bytes) {
    var view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
    var eocd = -1
    for (var i = bytes.length - 22; i >= Math.max(0, bytes.length - 22 - 65535); i--) {
      if (view.getUint32(i, true) === 0x06054b50) {
        eocd = i
        break
      }
    }
    if (eocd < 0) {
      throw new Error('不是有效的 ZIP（.chlz）文件')
    }
    var total = view.getUint16(eocd + 10, true)
    var pos = view.getUint32(eocd + 16, true)
    var entries = {}
    for (var n = 0; n < total; n++) {
      if (pos + 46 > bytes.length || view.getUint32(pos, true) !== 0x02014b50) {
        throw new Error('ZIP 中央目录损坏')
      }
      var flags = view.getUint16(pos + 8, true)
      var method = view.getUint16(pos + 10, true)
      var compSize = view.getUint32(pos + 20, true)
      var nameLen = view.getUint16(pos + 28, true)
      var extraLen = view.getUint16(pos + 30, true)
      var commentLen = view.getUint16(pos + 32, true)
      var localAt = view.getUint32(pos + 42, true)
      var name = decodeUtf8(bytes.subarray(pos + 46, pos + 46 + nameLen))
      pos += 46 + nameLen + extraLen + commentLen
      if (name.charAt(name.length - 1) === '/') {
        continue
      }
      entries[name] = { name: name, method: method, compSize: compSize, localAt: localAt, encrypted: (flags & 1) !== 0 }
    }
    return { bytes: bytes, view: view, entries: entries }
  }

  function zipEntryBytes(zip, entry) {
    if (entry.encrypted) {
      throw new Error('不支持加密的 ZIP：' + entry.name)
    }
    var v = zip.view
    var at = entry.localAt
    if (v.getUint32(at, true) !== 0x04034b50) {
      throw new Error('ZIP 本地文件头损坏：' + entry.name)
    }
    var start = at + 30 + v.getUint16(at + 26, true) + v.getUint16(at + 28, true)
    var raw = zip.bytes.subarray(start, start + entry.compSize)
    if (entry.method === 0) {
      return raw
    }
    if (entry.method === 8) {
      return inflateRaw(raw, 0).data
    }
    throw new Error('不支持的 ZIP 压缩方式 ' + entry.method + '：' + entry.name)
  }

  // ---------------------------------------------------------------- 文本/编码工具

  function decodeUtf8(bytes) {
    if (bytes == null) {
      return ''
    }
    if (typeof bytes === 'string') {
      return bytes
    }
    if (!(bytes instanceof Uint8Array)) {
      return ''
    }
    if (typeof TextDecoder !== 'undefined') {
      return new TextDecoder('utf-8').decode(bytes)
    }
    var out = []
    var i = 0
    var n = bytes.length
    while (i < n) {
      var c = bytes[i++]
      var cp
      if (c < 0x80) {
        cp = c
      } else if ((c & 0xE0) === 0xC0) {
        cp = ((c & 0x1F) << 6) | (bytes[i++] & 0x3F)
      } else if ((c & 0xF0) === 0xE0) {
        cp = ((c & 0x0F) << 12) | ((bytes[i++] & 0x3F) << 6) | (bytes[i++] & 0x3F)
      } else {
        cp = ((c & 0x07) << 18) | ((bytes[i++] & 0x3F) << 12) | ((bytes[i++] & 0x3F) << 6) | (bytes[i++] & 0x3F)
      }
      if (cp > 0xFFFF) {
        cp -= 0x10000
        out.push(String.fromCharCode(0xD800 + (cp >> 10), 0xDC00 + (cp & 0x3FF)))
      } else {
        out.push(String.fromCharCode(cp))
      }
    }
    return out.join('')
  }

  function base64ToBytes(text) {
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    var clean = String(text).replace(/[^A-Za-z0-9+\/]/g, '')
    var out = new Uint8Array(Math.floor(clean.length * 3 / 4))
    var o = 0
    var buf = 0
    var bits = 0
    for (var i = 0; i < clean.length; i++) {
      buf = (buf << 6) | chars.indexOf(clean.charAt(i))
      bits += 6
      if (bits >= 8) {
        bits -= 8
        out[o++] = (buf >> bits) & 0xFF
      }
    }
    return out.subarray(0, o)
  }

  function getHeader(pairs, name) {
    for (var i = 0; i < pairs.length; i++) {
      if (String(pairs[i].name).toLowerCase() === name) {
        return String(pairs[i].value || '')
      }
    }
    return ''
  }

  /** 按 Content-Encoding / 魔数解压 body 字节，解不了就原样返回 */
  function decodeContentEncoding(bytes, encoding) {
    encoding = String(encoding || '').toLowerCase()
    try {
      if (bytes.length > 2 && bytes[0] === 0x1f && bytes[1] === 0x8b) {
        return gunzip(bytes)
      }
      if (encoding.indexOf('deflate') >= 0) {
        return zlibInflate(bytes)
      }
    } catch (e) {
      // 解压失败时保留原始字节
    }
    return bytes
  }

  // ---------------------------------------------------------------- .chlz / .chlsj → calls

  function toBytes(buffer) {
    if (buffer instanceof Uint8Array) {
      return buffer
    }
    if (buffer && buffer.buffer instanceof ArrayBuffer && buffer.byteLength != null) {
      return new Uint8Array(buffer.buffer, buffer.byteOffset, buffer.byteLength)
    }
    return new Uint8Array(buffer)
  }

  function baseName(name) {
    var at = name.lastIndexOf('/')
    return at >= 0 ? name.substring(at + 1) : name
  }

  function headerPairs(header) {
    var list = header && Array.isArray(header.headers) ? header.headers : []
    var pairs = []
    for (var i = 0; i < list.length; i++) {
      pairs.push({
        name: list[i].name == null ? '' : String(list[i].name),
        value: list[i].value == null ? '' : String(list[i].value)
      })
    }
    return pairs
  }

  /** 读取一侧（request/response）的 body 文本 */
  function readBody(zipCtx, id, side, part, headers) {
    var prefix = id + '-' + side // 1-req / 1-res
    var encoding = (part && part.contentEncoding) || getHeader(headers, 'content-encoding')
    var body = part && part.body
    var bodyFile = (part && part.bodyFile) || (body && typeof body === 'object' && body.bodyFile) || null
    var bytes = null

    if (zipCtx) {
      var files = zipCtx.byBase
      var decodedName = null
      var names = Object.keys(files)
      for (var i = 0; i < names.length; i++) {
        // N-req.<ext>：已解码；排除 N-req-enc.dat 与 N-meta.json
        if (names[i].indexOf(prefix + '.') === 0) {
          decodedName = names[i]
          break
        }
      }
      var entry = decodedName ? files[decodedName] : (bodyFile && files[baseName(bodyFile)])
      if (entry) {
        bytes = decodeContentEncoding(zipEntryBytes(zipCtx.zip, entry), encoding)
      } else if (files[prefix + '-enc.dat']) {
        bytes = decodeContentEncoding(zipEntryBytes(zipCtx.zip, files[prefix + '-enc.dat']), encoding)
      }
    }
    if (bytes != null) {
      return decodeUtf8(bytes)
    }

    // 内联 body（.chlsj 或元数据内嵌）：decoded > text > encoded(base64)
    if (typeof body === 'string') {
      return body
    }
    if (body && typeof body === 'object') {
      if (typeof body.decoded === 'string') {
        return body.decoded
      }
      if (typeof body.text === 'string') {
        return body.text
      }
      if (typeof body.encoded === 'string') {
        var raw = body.encoding === 'base64' || body.base64 ? base64ToBytes(body.encoded) : null
        return raw ? decodeUtf8(decodeContentEncoding(raw, encoding)) : body.encoded
      }
    }
    return ''
  }

  function parseTime(times) {
    if (!times) {
      return 0
    }
    var candidates = [times.start, times.requestBegin, times.requestComplete, times.responseBegin, times.end]
    for (var i = 0; i < candidates.length; i++) {
      var v = candidates[i]
      if (typeof v === 'number') {
        return v
      }
      if (typeof v === 'string') {
        var ms = Date.parse(v)
        if (!isNaN(ms)) {
          return ms
        }
      }
    }
    return 0
  }

  function metaToCall(meta, id, index, zipCtx) {
    var req = meta.request || {}
    var res = meta.response || {}
    var reqHeaders = headerPairs(req.header)
    var resHeaders = headerPairs(res.header)
    var requestLine = (req.header && req.header.firstLine) || ''
    var responseLine = (res.header && res.header.firstLine) || ''

    var method = meta.method || ''
    var target = (meta.path || '/') + (meta.query ? '?' + meta.query : '')
    if (!meta.path && typeof requestLine === 'string' && requestLine) {
      var parts = requestLine.trim().split(/\s+/)
      if (parts.length >= 2) {
        method = method || parts[0]
        target = parts[1]
      }
    }
    var status = typeof res.status === 'number' ? res.status : 0
    if (!status) {
      var m = String(responseLine).match(/HTTP\/\d+(?:\.\d+)?\s+(\d{3})/)
      status = m ? parseInt(m[1], 10) : 0
    }
    if (!responseLine && status) {
      responseLine = (meta.protocolVersion || 'HTTP/1.1') + ' ' + status
    }
    if (!requestLine && method) {
      requestLine = method + ' ' + target + ' ' + (meta.protocolVersion || 'HTTP/1.1')
    }
    return {
      index: index,
      time: parseTime(meta.times),
      method: String(method || '').toUpperCase(),
      target: target,
      protocol: meta.scheme || 'http',
      host: meta.host || '',
      port: meta.actualPort || meta.port || 0,
      requestLine: requestLine,
      responseLine: responseLine,
      status: status,
      requestHeaders: reqHeaders,
      responseHeaders: resHeaders,
      requestBody: readBody(zipCtx, id, 'req', req, reqHeaders),
      responseBody: readBody(zipCtx, id, 'res', res, resHeaders)
    }
  }

  function isZip(bytes) {
    return bytes.length > 3 && bytes[0] === 0x50 && bytes[1] === 0x4b
  }

  /** 解析 .chlz（或 .chlsj）为调用列表，结构与 Charles.js 的 parseCharlesSession 返回值一致 */
  function parseCharlesNewSession(buffer) {
    var bytes = toBytes(buffer)
    var calls = []
    var i

    if (!isZip(bytes)) {
      // .chlsj：JSON 数组
      var text = decodeUtf8(bytes).replace(/^\uFEFF/, '')
      var json
      try {
        json = JSON.parse(text)
      } catch (e) {
        throw new Error('不是 Charles .chlz / .chlsj 会话文件')
      }
      var arr = Array.isArray(json) ? json : (json && Array.isArray(json.transactions) ? json.transactions : [json])
      for (i = 0; i < arr.length; i++) {
        if (arr[i] && typeof arr[i] === 'object') {
          calls.push(metaToCall(arr[i], i + 1, i, null))
        }
      }
      return calls
    }

    var zip = readZip(bytes)
    var byBase = {}
    var metas = []
    Object.keys(zip.entries).forEach(function (name) {
      var base = baseName(name)
      byBase[base] = zip.entries[name]
      var m = base.match(/^(\d+)-meta\.json$/)
      if (m) {
        metas.push({ id: parseInt(m[1], 10), name: name })
      }
    })
    metas.sort(function (a, b) {
      return a.id - b.id
    })
    var zipCtx = { zip: zip, byBase: byBase }
    for (i = 0; i < metas.length; i++) {
      var meta
      try {
        meta = JSON.parse(decodeUtf8(zipEntryBytes(zip, zip.entries[metas[i].name])).replace(/^\uFEFF/, ''))
      } catch (e) {
        continue
      }
      calls.push(metaToCall(meta, metas[i].id, metas[i].id, zipCtx))
    }
    return calls
  }

  // ---------------------------------------------------------------- calls → Document + TestRecord（与 Charles.js 保持一致）

  function splitHttpTarget(target) {
    target = target || '/'
    var hash = ''
    var query = ''
    var hashAt = target.indexOf('#')
    if (hashAt >= 0) {
      hash = target.substring(hashAt + 1)
      target = target.substring(0, hashAt)
    }
    var queryAt = target.indexOf('?')
    if (queryAt >= 0) {
      query = target.substring(queryAt + 1)
      target = target.substring(0, queryAt)
    }
    if (target.length > 1 && target.charAt(target.length - 1) === '/') {
      target = target.substring(0, target.length - 1)
    }
    if (!target || target.charAt(0) !== '/') {
      target = '/' + (target || '')
    }
    return { path: target, query: query, hash: hash }
  }

  function charlesBaseUrl(call) {
    var protocol = call.protocol || 'http'
    var port = parseInt(call.port, 10) || 0
    var omit = !port || (protocol === 'http' && port === 80) || (protocol === 'https' && port === 443)
    return protocol + '://' + call.host + (omit ? '' : ':' + port)
  }

  function charlesHeaderText(pairs) {
    var skip = {
      'content-length': true,
      'accept-encoding': true,
      'connection': true,
      'keep-alive': true
    }
    var lines = []
    for (var i = 0; i < pairs.length; i++) {
      var name = pairs[i].name
      var value = pairs[i].value
      if (!name || value == null || value === '') {
        continue
      }
      if (skip[String(name).toLowerCase()]) {
        continue
      }
      lines.push(name + ': ' + value)
    }
    return lines.join('\n')
  }

  function charlesRequestType(call) {
    var contentType = getHeader(call.requestHeaders, 'content-type').toLowerCase()
    if (contentType.indexOf('json') >= 0 || contentType.indexOf('grpc') >= 0) {
      return 'JSON'
    }
    if (contentType.indexOf('multipart/form-data') >= 0) {
      return 'DATA'
    }
    if (contentType.indexOf('application/x-www-form-urlencoded') >= 0) {
      return 'FORM'
    }
    var method = call.method
    if (method === 'GET' || method === 'HEAD' || method === 'OPTIONS') {
      return 'PARAM'
    }
    return 'JSON'
  }

  function charlesOperation(path) {
    var name = String(path || '').split('?')[0].replace(/^\/+/, '').toLowerCase()
    if (/^(insert|post|add|pub|write)/.test(name)) return 'INSERT'
    if (/^(update|edit|put|patch|mutate|mod)/.test(name)) return 'UPDATE'
    if (/^(del|remove|rmv|clear|clean|release)/.test(name)) return 'DELETE'
    if (/^(get|find|query|list|search|select|read|retrieve|fetch)/.test(name)) return 'SELECT'
    return null
  }

  function charlesFormatTime(ms) {
    var date = new Date(ms)
    function fill(n) {
      return (n < 10 ? '0' : '') + n
    }
    return date.getFullYear() + '-' + fill(date.getMonth() + 1) + '-' + fill(date.getDate())
        + ' ' + fill(date.getHours()) + ':' + fill(date.getMinutes()) + ':' + fill(date.getSeconds())
  }

  function charlesRequestTag(body, type) {
    if (type !== 'JSON' || !body) {
      return null
    }
    try {
      var obj = JSON.parse(body)
      return obj && typeof obj.tag === 'string' ? obj.tag : null
    } catch (e) {
      return null
    }
  }

  /**
   * 按 start 时间升序提取接口，生成 Document + TestRecord。
   * response 不在 Document 表里，放在关联的 TestRecord，供场景用例上传对比。
   */
  function charlesNewSessionToDocuments(buffer, ctx) {
    ctx = ctx || {}
    var calls = parseCharlesNewSession(buffer).filter(function (call) {
      return call.method && [null, '', 'CONNECT', 'OPTIONS', 'TRACE'].indexOf(call.method) < 0 && call.target && call.responseBody
    })

    calls.sort(function (a, b) {
      if (a.time !== b.time) {
        return a.time < b.time ? -1 : 1
      }
      return a.index - b.index
    })
    var hostLabel = calls.length > 0 ? calls[0].host : 'session'
    var groupName = ctx.groupName || ('Charles ' + hostLabel)
    if (groupName.length > 45) {
      groupName = groupName.substring(0, 45)
    }
    var project = /apijson/i.test(hostLabel) ? 'APIJSON' : (ctx.project || 'APIJSON')
    var userId = ctx.userId || 0
    var testAccountId = ctx.testAccountId || 0
    var list = []
    for (var i = 0; i < calls.length; i++) {
      var call = calls[i]
      var target = splitHttpTarget(call.target)
      var url = target.path + (target.query ? '?' + target.query : '') + (target.hash ? '#' + target.hash : '')
      if (url.length > 250) {
        url = url.substring(0, 250)
      }
      var type = charlesRequestType(call)
      var tag = charlesRequestTag(call.requestBody, type)
      var name = (i + 1) + '. ' + call.method + ' ' + target.path + (tag ? ' ' + tag : '')
      if (name.length > 100) {
        name = name.substring(0, 100)
      }
      var request = call.requestBody || ''
      list.push({
        Document: {
          deleted: 0,
          debug: 0,
          from: 2,
          userId: userId,
          project: project,
          testAccountId: testAccountId,
          version: 3,
          tagList: tag ? [tag] : null,
          group: groupName,
          name: name,
          operation: charlesOperation(target.path),
          method: call.method,
          type: type,
          url: url,
          request: request,
          apijson: type === 'JSON' ? request : null,
          sqlauto: null,
          standard: null,
          header: charlesHeaderText(call.requestHeaders),
          date: charlesFormatTime(call.time || Date.now()),
          path: null,
          deleteTime: null,
          deleterId: 0,
          detail: String(call.requestLine || '').trim() + ' -> ' + String(call.responseLine || '').trim()
        },
        TestRecord: {
          userId: userId,
          testAccountId: testAccountId,
          host: charlesBaseUrl(call),
          response: call.responseBody,
          header: charlesHeaderText(call.responseHeaders),
          status: call.status || 200
        }
      })
    }
    return { groupName: groupName, list: list }
  }

  global.CHARLES_NEW_SESSION_FILE = CHARLES_NEW_SESSION_FILE
  global.parseCharlesNewSession = parseCharlesNewSession
  global.charlesNewSessionToDocuments = charlesNewSessionToDocuments

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
      parseCharlesNewSession: parseCharlesNewSession,
      charlesNewSessionToDocuments: charlesNewSessionToDocuments,
      CHARLES_NEW_SESSION_FILE: CHARLES_NEW_SESSION_FILE
    }
  }
})(typeof globalThis !== 'undefined' ? globalThis : (typeof window !== 'undefined' ? window : this))
