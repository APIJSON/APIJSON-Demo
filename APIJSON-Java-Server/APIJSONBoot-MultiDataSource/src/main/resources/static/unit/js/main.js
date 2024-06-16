
(function () {
  const DEBUG = false // true
  const IS_NODE = typeof window == 'undefined'
  const IS_BROWSER = typeof window == 'object'

  if (IS_NODE) {  // 解决在 Node 环境下缺少相关变量/常量/函数导致报错
    try {
      eval(`
        var alert = function(msg) {console.log('alert: ' + msg)};
        // var console = {log: function(msg) {}};

        var vUrl = {value: 'unitauto.test.TestUtil.divide'};
        var vUrlComment = {value: ''};
        var vTransfer = {value: '', disabled: false};
        var vType = {value: 'JSON'};
        var vSend = {value: '', disabled: false};

        var vInput = {value: ''};
        var vWarning = {value: ''};
        var vComment = {value: ''};
        var vHeader = {value: ''};
        var vRandom = {value: ''};
        var vScript = {value: ''};
        var vOutput = {value: ''};

        var vAccount = {value: ''};
        var vPassword = {value: ''};
        var vVerify = {value: ''};
        var vRemember = {checked: true}

        var vRequestMarkdown = {value: ''};
        var vMarkdown = {value: ''};
        var vPage = {value: '0'};
        var vCount = {value: '100'};
        var vSearch = {value: ''};
        var vTestCasePage = {value: '0'};
        var vTestCaseCount = {value: '100'};
        var vTestCaseSearch = {value: ''};
        var vRandomPage = {value: '0'};
        var vRandomCount = {value: '100'};
        var vRandomSearch = {value: ''};
        var vRandomSubPage = {value: '0'};
        var vRandomSubCount = {value: '100'};
        var vRandomSubSearch = {value: ''};

        var Vue = require('./vue.min'); // 某些版本不兼容 require('vue');
        var StringUtil = require('../apijson/StringUtil');
        var CodeUtil = require('../apijson/CodeUtil');
        var JSONObject = require('../apijson/JSONObject');
        var JSONResponse = require('../apijson/JSONResponse');
        var JSONRequest = require('../apijson/JSONRequest');
        var localforage = require('./localforage.min');
        var clipboard = require('./clipboard.min');
        var jsonlint = require('./jsonlint');
        var JSON5 = require('json5');
        // var window = {};
        // var $ = require('./jquery').jQuery;
        // var $ = {
        //   isEmptyObject: function (obj) {
        //     return obj == null || Object.keys(obj).length <= 0;
        //   }
        // };

        // var LocalStorage = require('node-localstorage').LocalStorage;
        // var localStorage = new LocalStorage('./scratch');
        var localStorage = {
          getItem: function (key) {},
          setItem: function (key, value) {}
        }
        // var difflib = require('./difflib');
        // var diffview = require('./diffview');
        // var editor = require('./editor');
        // var FileSaver = require('./FileSaver');
        // var helper = require('./helper');
        // var jquery = require('./jquery');
        // var jsonlint = require('./jsonlint');
        // var parse = require('./parse');
        // var uuid = require('./uuid');

        var URL_BASE = 'unitauto.test';  // JSONRequest.URL_BASE;

        var axios = require('axios');
        var editormd = null;
      `)
    } catch (e) {
      console.log(e)
    }
  }

  function log(msg) {
    if (DEBUG) {
      console.log(msg)
    }
  }

  Vue.component('vue-item', {
    props: ['jsondata', 'theme'],
    template: '#item-template'
  })

  Vue.component('vue-outer', {
    props: ['jsondata', 'isend', 'path', 'theme'],
    template: '#outer-template'
  })

  Vue.component('vue-expand', {
    props: [],
    template: '#expand-template'
  })

  Vue.component('vue-val', {
    props: ['field', 'val', 'isend', 'path', 'theme'],
    template: '#val-template'
  })

  Vue.use({
    install: function (Vue, options) {

      // 判断数据类型
      Vue.prototype.getTyp = function (val) {
        return toString.call(val).split(']')[0].split(' ')[1]
      }

      // 判断是否是对象或者数组，以对下级进行渲染
      Vue.prototype.isObjectArr = function (val) {
        return ['Object', 'Array'].indexOf(this.getTyp(val)) > -1
      }

      // 折叠
      Vue.prototype.fold = function ($event) {
        var target = Vue.prototype.expandTarget($event)
        target.siblings('svg').show()
        target.hide().parent().siblings('.expand-view').hide()
        target.parent().siblings('.fold-view').show()
      }
      // 展开
      Vue.prototype.expand = function ($event) {
        var target = Vue.prototype.expandTarget($event)
        target.siblings('svg').show()
        target.hide().parent().siblings('.expand-view').show()
        target.parent().siblings('.fold-view').hide()
      }

      //获取展开折叠的target
      Vue.prototype.expandTarget = function ($event) {
        switch($event.target.tagName.toLowerCase()) {
          case 'use':
            return $($event.target).parent()
          case 'label':
            return $($event.target).closest('.fold-view').siblings('.expand-wraper').find('.icon-square-plus').first()
          default:
            return $($event.target)
        }
      }

      // 格式化值
      Vue.prototype.formatVal = function (val) {
        switch(Vue.prototype.getTyp(val)) {
          case 'String':
            return '"' + val + '"'
          case 'Null':
            return 'null'
          default:
            return val
        }
      }

      // 判断值是否是链接
      Vue.prototype.isaLink = function (val) {
        return /^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+/.test(val)
      }

      // 计算对象的长度
      Vue.prototype.objLength = function (obj) {
        return Object.keys(obj).length
      }

      /**渲染 JSON key:value 项
       * @author TommyLemon
       * @param val
       * @param key
       * @return {boolean}
       */
      Vue.prototype.onRenderJSONItem = function (val, key, path) {
        if (isSingle || key == null) {
          return true
        }
        if (key == '_$_this_$_') {
          // return true
          return false
        }

        var method = App.getMethod();
        var isRestful = ! JSONObject.isAPIJSONPath(method);

        try {
          if (val instanceof Array) {
            if (val[0] instanceof Object && (val[0] instanceof Array == false)) {  // && JSONObject.isArrayKey(key, null, isRestful)) {
              // alert('onRenderJSONItem  key = ' + key + '; val = ' + JSON.stringify(val))

              var ckey = key.substring(0, key.lastIndexOf('[]'));

              var aliaIndex = ckey.indexOf(':');
              var objName = aliaIndex < 0 ? ckey : ckey.substring(0, aliaIndex);

              var firstIndex = objName.indexOf('-');
              var firstKey = firstIndex < 0 ? objName : objName.substring(0, firstIndex);

              for (var i = 0; i < val.length; i++) {
                var cPath = (StringUtil.isEmpty(path, false) ? '' : path + '/') + key;

                var vi = val[i]

                if (JSONObject.isTableKey(firstKey, val, isRestful)) {
                  // var newVal = JSON.parse(JSON.stringify(val[i]))
                  if (vi == null) {
                    continue
                  }

                  var newVal = {}
                  for (var k in vi) {
                    newVal[k] = vi[k] //提升性能
                    delete vi[k]
                  }

                  vi._$_this_$_ = JSON.stringify({
                    path: cPath + '/' + i,
                    table: firstKey
                  })

                  for (var k in newVal) {
                    vi[k] = newVal[k]
                  }
                }
                else {
                  this.onRenderJSONItem(vi, '' + i, cPath);
                }

                // this.$children[i]._$_this_$_ = key
                // alert('this.$children[i]._$_this_$_ = ' + this.$children[i]._$_this_$_)
              }
            }
          }
          else if (val instanceof Object) {
            var aliaIndex = key.indexOf(':');
            var objName = aliaIndex < 0 ? key : key.substring(0, aliaIndex);

            // var newVal = JSON.parse(JSON.stringify(val))

            var newVal = {}
            for (var k in val) {
              newVal[k] = val[k] //提升性能
              delete val[k]
            }

            val._$_this_$_ = JSON.stringify({
              path: (StringUtil.isEmpty(path, false) ? '' : path + '/') + key,
              table: JSONObject.isTableKey(objName, val, isRestful) ? objName : null
            })

            for (var k in newVal) {
              val[k] = newVal[k]
            }

            // val = Object.assign({ _$_this_$_: objName }, val) //解决多显示一个逗号 ,

            // this._$_this_$_ = key  TODO  不影响 JSON 的方式，直接在组件读写属性
            // alert('this._$_this_$_ = ' + this._$_this_$_)
          }


        } catch (e) {
          if (DEBUG) {
            alert('onRenderJSONItem  try { ... } catch (e) {\n' + e.message)
          } else {
            console.log(e)
          }
        }

        return true

      }


      /**显示 Response JSON 的注释
       * @author TommyLemon
       * @param val
       * @param key
       * @param $event
       */
      Vue.prototype.setResponseHint = function (val, key, $event) {
        console.log('setResponseHint')
        this.$refs.responseKey.setAttribute('data-hint', isSingle ? '' : this.getResponseHint(val, key, $event));
      }
      /**获取 Response JSON 的注释
       * 方案一：
       * 拿到父组件的 key，逐层向下传递
       * 问题：拿不到爷爷组件 "Comment[]": [ { "id": 1, "content": "content1" }, { "id": 2 }... ]
       *
       * 方案二：
       * 改写 jsonon 的 refKey 为 key0/key1/.../refKey
       * 问题：遍历，改 key；容易和特殊情况下返回的同样格式的字段冲突
       *
       * 方案三：
       * 改写 jsonon 的结构，val 里加 .path 或 $.path 之类的隐藏字段
       * 问题：遍历，改 key；容易和特殊情况下返回的同样格式的字段冲突
       *
       * @author TommyLemon
       * @param val
       * @param key
       * @param $event
       */
      Vue.prototype.getResponseHint = function (val, key, $event) {
        // alert('setResponseHint  key = ' + key + '; val = ' + JSON.stringify(val))

        var s = ''

        try {
          var standardObj = null;
          try {
            var currentItem = App.isTestCaseShow ? App.remotes[App.currentDocIndex] : App.currentRemoteItem;
            standardObj = JSON.parse(((currentItem || {}).TestRecord || {}).standard);
          } catch (e3) {
            log(e3)
          }

          var path = null
          var table = null
          var column = null

          var method = App.isTestCaseShow ? ((App.currentRemoteItem || {}).Method || {}).url : App.getMethod();
          var isRestful = ! JSONObject.isAPIJSONPath(method);

          if (val instanceof Object && (val instanceof Array == false)) {

            var parent = $event.currentTarget.parentElement.parentElement
            var valString = parent.textContent

            // alert('valString = ' + valString)

            var i = valString.indexOf('"_$_this_$_":  "')
            if (i >= 0) {
              valString = valString.substring(i + '"_$_this_$_":  "'.length)
              i = valString.indexOf('}"')
              if (i >= 0) {
                valString = valString.substring(0, i + 1)
                // alert('valString = ' + valString)
                var _$_this_$_ = JSON.parse(valString) || {}
                path = _$_this_$_.path
                table = _$_this_$_.table
              }


              var aliaIndex = key == null ? -1 : key.indexOf(':');
              var objName = aliaIndex < 0 ? key : key.substring(0, aliaIndex);

              if (JSONObject.isTableKey(objName, val, isRestful)) {
                table = objName
              }
              else if (JSONObject.isTableKey(table, val, isRestful)) {
                column = key
              }

              // alert('path = ' + path + '; table = ' + table + '; column = ' + column)
            }
          }
          else {
            var parent = $event.currentTarget.parentElement.parentElement
            var valString = parent.textContent

            // alert('valString = ' + valString)

            var i = valString.indexOf('"_$_this_$_":  "')
            if (i >= 0) {
              valString = valString.substring(i + '"_$_this_$_":  "'.length)
              i = valString.indexOf('}"')
              if (i >= 0) {
                valString = valString.substring(0, i + 1)
                // alert('valString = ' + valString)
                var _$_this_$_ = JSON.parse(valString) || {}
                path = _$_this_$_ == null ? '' : _$_this_$_.path
                table = _$_this_$_ == null ? '' : _$_this_$_.table
              }
            }

            if (val instanceof Array && JSONObject.isArrayKey(key, val, isRestful)) {
              var key2 = key == null ? null : key.substring(0, key.lastIndexOf('[]'));

              var aliaIndex = key2 == null ? -1 : key2.indexOf(':');
              var objName = aliaIndex < 0 ? key2 : key2.substring(0, aliaIndex);

              var firstIndex = objName == null ? -1 : objName.indexOf('-');
              var firstKey = firstIndex < 0 ? objName : objName.substring(0, firstIndex);

              // alert('key = ' + key + '; firstKey = ' + firstKey + '; firstIndex = ' + firstIndex)
              if (JSONObject.isTableKey(firstKey, null, isRestful)) {
                table = firstKey

                var s0 = '';
                if (firstIndex > 0) {
                  objName = objName.substring(firstIndex + 1);
                  firstIndex = objName.indexOf('-');
                  column = firstIndex < 0 ? objName : objName.substring(0, firstIndex)

                  var pathUri = (StringUtil.isEmpty(path) ? '' : path + '/') + key;

                  var c = CodeUtil.getCommentFromDoc(docObj == null ? null : docObj['[]'], table, column, method, App.database, App.language, true, false, pathUri.split('/'), isRestful, val, true, standardObj); // this.getResponseHint({}, table, $event
                  s0 = column + (StringUtil.isEmpty(c, true) ? '' : ': ' + c)
                }

                var pathUri = (StringUtil.isEmpty(path) ? '' : path + '/') + (StringUtil.isEmpty(column) ? key : column);

                var c = CodeUtil.getCommentFromDoc(docObj == null ? null : docObj['[]'], table, isRestful ? key : null, method, App.database, App.language, true, false, pathUri.split('/'), isRestful, val, true, standardObj);
                s = (StringUtil.isEmpty(path) ? '' : path + '/') + key + ' 中 '
                  + (
                    StringUtil.isEmpty(c, true) ? '' : table + ': '
                      + c + ((StringUtil.isEmpty(s0, true) ? '' : '  -  ' + s0) )
                  );

                return s;
              }
              //导致 key[] 的 hint 显示为  key[]key[]   else {
              //   s = (StringUtil.isEmpty(path) ? '' : path + '/') + key
              // }
            }
            else {
              if (isRestful || JSONObject.isTableKey(table)) {
                column = key
              }
              // alert('path = ' + path + '; table = ' + table + '; column = ' + column)
            }
          }
          // alert('setResponseHint  table = ' + table + '; column = ' + column)

          var pathUri = (StringUtil.isEmpty(path) ? '' : path + '/') + key;
          var c = CodeUtil.getCommentFromDoc(docObj == null ? null : docObj['[]'], table, isRestful ? key : column, method, App.database, App.language, true, false, pathUri.split('/'), isRestful, val, true, standardObj);

          s += pathUri + (StringUtil.isEmpty(c, true) ? '' : ': ' + c)
        }
        catch (e) {
          s += '\n' + e.message
        }

        return s;
      }

    }
  })


  var initJson = {}

// 主题 [key, String, Number, Boolean, Null, link-link, link-hover]
  var themes = [
    ['#92278f', '#3ab54a', '#25aae2', '#f3934e', '#f34e5c', '#717171'],
    ['rgb(19, 158, 170)', '#cf9f19', '#ec4040', '#7cc500', 'rgb(211, 118, 126)', 'rgb(15, 189, 170)'],
    ['#886', '#25aae2', '#e60fc2', '#f43041', 'rgb(180, 83, 244)', 'rgb(148, 164, 13)'],
    ['rgb(97, 97, 102)', '#cf4c74', '#20a0d5', '#cd1bc4', '#c1b8b9', 'rgb(25, 8, 174)']
  ]




// APIJSON <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  var ERR_MSG = `出现了一些问题，可以按照以下步骤解决：
1.检查网络连接是否畅通，可用浏览器打开右侧地址： https://www.baidu.com/s?wd=%22APIJSON%22
2.检查 URL 是否为一个可用的 域名/IPV4 地址，可用浏览器打开试试：正常返回结果 或 非 GET 请求返回 Whitelabel Error Page，一般都没问题
3.开启或关闭 右上方 设置>托管服务器代理，然后再试：如果开启后才通应该是 CORS 跨域问题；关闭后才通应该是用外网服务代理来访问内网导致，可退出登录后修改退关服务器地址为内网的 APIJSON 代理服务地址
4.Disable 关闭 VPN 等 电脑/手机/平板 上的网络代理软件 App 客户端，或者切换代理服务器地址，然后再试
5.按 Fn+F12 或 右键网页>Inspect 检查 查看 Network 接口调用信息和 Console 控制台日志
6.查看请求目标服务器上的日志，优先找异常报错内容
7.改用 Postman 等其它 HTTP API 接口工具测试同一个接口
8.再试一次

# 问题与解答大全(可截屏后 New issue 上报问题等待解答)：
https://github.com/TommyLemon/APIAuto/issues

如果是请求 APIJSON 后端服务，则使用以下链接：
https://github.com/Tencent/APIJSON/issues

There may be something wrong, you can follow by the steps:
1. Check whether the network connection is available, you can open the address with a browser: https://www.google.com/search?q=%22APIJSON%22
2. Check whether the URL is an available domain name/IPV4 address, try opening it with a browser: if return the result normally or return a Whitelabel Error Page for a non-GET request, generally the URL is available
3. Turn it on or off at the top right, Settings>Server Proxy, and try again: If it is enabled, it should be a CORS cross-domain problem; and if it is turned off, it should be caused by using an external network service proxy to access the intranet, You can log out and modify the logout server address to the APIJSON proxy service address of the intranet
4. Disable the network proxy software App client on the computer/phone/tablet such as VPN, or switch the proxy server address, and then try again
5. Press Fn+F12 or right-click the webpage>Inspect to view the Network interface call information and Console console log
6. Check the log on the request target server, and give priority to find the abnormal error content
7. Use other HTTP API tools such as Postman to test the same interface
8. Try again

# Questions and answers (you can report the problem after taking a screenshot and wait for the answer):
https://github.com/TommyLemon/APIAuto/issues

If you are requesting an APIJSON backend service, use the following link:
https://github.com/Tencent/APIJSON/issues
`;


  function getRequestFromURL(url_, tryParse) {
    var url = url_ || window.location.search;

    var index = url == null ? -1 : url.indexOf("?")
    if(index < 0) { //判断是否有参数
      return null;
    }

    var theRequest = null;
    var str = url.substring(index + 1);  //从第一个字符开始 因为第0个是?号 获取所有除问号的所有符串
    var arr = str.split("&");  //截除“&”生成一个数组

    var len = arr == null ? 0 : arr.length;
    for(var i = 0; i < len; i++) {
      var part = arr[i];
      var ind = part == null ? -1 : part.indexOf("=");
      if (ind <= 0) {
        continue
      }

      if (theRequest == null) {
        theRequest = {};
      }

      var v = decodeURIComponent(part.substring(ind+1));
      if (tryParse == true) {
        try {
          v = JSON.parse(v)
        }
        catch (e) {
          console.log(e)
        }
      }

      theRequest[part.substring(0, ind)] = v;
    }

    return theRequest;
  }


  function markdownToHTML(md, isRequest) {
    if (typeof editormd == 'undefined' || editormd == null) {
      return;
    }

    if (isRequest) {
      vRequestMarkdown.innerHTML = '';
    }
    else {
      vMarkdown.innerHTML = '';
    }
    editormd.markdownToHTML(isRequest ? 'vRequestMarkdown' : "vMarkdown", {
      markdown        : md ,//+ "\r\n" + $("#append-test").text(),
      //htmlDecode      : true,       // 开启 HTML 标签解析，为了安全性，默认不开启
      htmlDecode      : "style,script,iframe",  // you can filter tags decode
      //toc             : false,
      tocm            : true,    // Using [TOCM]
      //tocContainer    : "#custom-toc-container", // 自定义 ToC 容器层
      //gfm             : false,
      tocDropdown     : true,
      // markdownSourceCode : true, // 是否保留 Markdown 源码，即是否删除保存源码的 Textarea 标签
      taskList        : true,
      tex             : true,  // 默认不解析
      flowChart       : true,  // 默认不解析
      sequenceDiagram : true,  // 默认不解析
    });
  }



  var PLATFORM_POSTMAN = 'POSTMAN'
  var PLATFORM_SWAGGER = 'SWAGGER'
  var PLATFORM_YAPI = 'YAPI'
  var PLATFORM_RAP = 'RAP'

  var REQUEST_TYPE_PARAM = 'PARAM'  // GET ?a=1&b=c&key=value
  var REQUEST_TYPE_FORM = 'FORM'  // POST x-www-form-urlencoded
  var REQUEST_TYPE_DATA = 'DATA'  // POST form-data
  var REQUEST_TYPE_JSON = 'JSON'  // POST application/json
  var REQUEST_TYPE_GRPC = 'GRPC'  // POST application/json
  var REQUEST_TYPE_GET = 'GET'  // GET ?a=1&b=c&key=value
  var REQUEST_TYPE_POST = 'POST'  // POST application/json
  var REQUEST_TYPE_PUT = 'PUT'  // PUT
  var REQUEST_TYPE_PATCH = 'PATCH'  // PATCH
  var REQUEST_TYPE_DELETE = 'DELETE'  // DELETE
  var REQUEST_TYPE_HEAD = 'HEAD'  // HEAD
  var REQUEST_TYPE_OPTIONS = 'OPTIONS'  // OPTIONS
  var REQUEST_TYPE_TRACE = 'TRACE'  // TRACE
  var HTTP_METHODS = [REQUEST_TYPE_GET, REQUEST_TYPE_POST, REQUEST_TYPE_PUT, REQUEST_TYPE_PATCH, REQUEST_TYPE_DELETE, REQUEST_TYPE_HEAD, REQUEST_TYPE_OPTIONS, REQUEST_TYPE_TRACE]
  var HTTP_POST_TYPES = [REQUEST_TYPE_POST, REQUEST_TYPE_JSON, REQUEST_TYPE_FORM, REQUEST_TYPE_DATA, REQUEST_TYPE_GRPC]
  var HTTP_URL_ARG_TYPES = [REQUEST_TYPE_GET, REQUEST_TYPE_PARAM, REQUEST_TYPE_FORM]
  var HTTP_JSON_TYPES = [REQUEST_TYPE_POST, REQUEST_TYPE_JSON, REQUEST_TYPE_GRPC]
  var HTTP_FORM_DATA_TYPES = [REQUEST_TYPE_DATA, REQUEST_TYPE_PUT, REQUEST_TYPE_DELETE]
  var HTTP_CONTENT_TYPES = [REQUEST_TYPE_PARAM, REQUEST_TYPE_FORM, REQUEST_TYPE_DATA, REQUEST_TYPE_JSON, REQUEST_TYPE_GRPC]

  var CONTENT_TYPE_MAP = {
    // 'PARAM': 'text/plain',
    'FORM': 'application/x-www-form-urlencoded',
    'DATA': 'multipart/form-data',
    'JSON': 'application/json',
    'GRPC': 'application/json',
  }
  var CONTENT_VALUE_TYPE_MAP = {
    'text/plain': 'JSON',
    'application/x-www-form-urlencoded': 'FORM',
    'multipart/form-data': 'DATA',
    'application/json': 'JSON'
  }

  var IGNORE_HEADERS = ['status code', 'remote address', 'referrer policy', 'connection', 'content-length'
    , 'content-type', 'date', 'keep-alive', 'proxy-connection', 'set-cookie', 'vary', 'accept', 'cache-control', 'dnt'
    , 'host', 'origin', 'pragma', 'referer', 'user-agent']

  var RANDOM_DB = 'RANDOM_DB'
  var RANDOM_IN = 'RANDOM_IN'
  var RANDOM_INT = 'RANDOM_INT'
  var RANDOM_NUM = 'RANDOM_NUM'
  var RANDOM_STR = 'RANDOM_STR'
  var RANDOM_BAD = 'RANDOM_BAD'
  var RANDOM_BAD_BOOL = 'RANDOM_BAD_BOOL'
  var RANDOM_BAD_NUM = 'RANDOM_BAD_NUM'
  var RANDOM_BAD_STR = 'RANDOM_BAD_STR'
  var RANDOM_BAD_IN = 'RANDOM_BAD_IN'
  var RANDOM_BAD_ARR = 'RANDOM_BAD_ARR'
  var RANDOM_BAD_OBJ = 'RANDOM_BAD_OBJ'

  var ORDER_DB = 'ORDER_DB'
  var ORDER_IN = 'ORDER_IN'
  var ORDER_INT = 'ORDER_INT'
  var ORDER_BAD = 'ORDER_BAD'
  var ORDER_BAD_BOOL = 'ORDER_BAD_BOOL'
  var ORDER_BAD_NUM = 'ORDER_BAD_NUM'
  var ORDER_BAD_STR = 'ORDER_BAD_STR'
  var ORDER_BAD_IN = 'ORDER_BAD_IN'
  var ORDER_BAD_ARR = 'ORDER_BAD_ARR'
  var ORDER_BAD_OBJ = 'ORDER_BAD_OBJ'

  var ORDER_MAP = {}

  var BAD_BOOLS = [null, undefined, false, true, -1, 0, 1, 2, 3.14, 'null', 'undefined', 'None', 'nil', 'false', 'true',
   '-1', '0', '1', '2', '3.14', '', ' ', '\\t', '\\r', '\\n', '\\a', '\\b', '\\v', '\\f', 'a', 'dY', [], {}, '[]', '{}']
  var BAD_NUMS = BAD_BOOLS.concat([
   -2049, -1025, -13, 13, 1025, 2049, Number.NaN, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.MIN_SAFE_INTEGER,
   Number.MAX_SAFE_INTEGER, Number.MIN_SAFE_INTEGER - 1, Number.MAX_SAFE_INTEGER + 1,
   '-2049', '-1025', '-13', '13', '1025', '2049', 'Number.NaN', 'Number.POSITIVE_INFINITY', 'Number.NEGATIVE_INFINITY',
    'Number.MIN_SAFE_INTEGER', 'Number.MAX_SAFE_INTEGER', '' + Number.MIN_SAFE_INTEGER, '' + Number.MAX_SAFE_INTEGER
  ])
  var BAD_STRS = BAD_NUMS.concat([
     '`', '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', ';', ':',
     "'", '\\"', ',', '.', '<', '>', '/', '?', '\\t\\r\\n\\a\\b\\v\\f', '`~!@#$%^&*()-_=+[]{};:\'\\",.<>/?',
     'qwertyuiopasdfghjklzxcvbnm', 'MNBVCZLKJHGFDSAPOIUYTREWQ', 'ä½ å¥½', 'ÄãºÃ', '浣犲ソ', '�����',
     '鐢辨湀瑕佸ソ濂藉涔犲ぉ澶╁悜涓?', '����Ҫ�¨²�ѧϰ������', 'ç”±æœˆè¦�å¥½å¥½å­¦ä¹ å¤©å¤©å�‘ä¸Š', 'ÓÉÔÂÒªºÃºÃÑ§Ï°ÌìÌìÏòÉÏ',
     '由月要好好学习天天向??', '锟斤拷锟斤拷要锟矫猴拷学习锟斤拷锟斤拷锟斤拷'
  ])
  // FIXME 打开时直接卡死崩溃
  var sl = Math.min(10, Math.floor(BAD_STRS.length/5))
  for (var i = 0; i < sl; i ++) {
     var v = BAD_STRS[i]
     for (var j = 0; j < sl; j ++) {
         BAD_STRS.push(v + BAD_STRS[j])
     }
  }
  var sl2 = Math.min(5, Math.floor(sl/5))
  for (var i = 0; i < sl2; i ++) {
      var v = BAD_STRS[i]
      for (var j = 0; j < sl2; j ++) {
          var v2 = v + BAD_STRS[j]
          for (var k = 0; k < sl2; k ++) {
            BAD_STRS.push(v2 + BAD_STRS[k])
          }
      }
  }

  var BAD_ARRS = []
  for (var i = 0; i < BAD_STRS.length; i ++) {
    BAD_ARRS.push([BAD_STRS[i]])
  }
  // FIXME 打开时直接卡死崩溃
  var al = Math.min(10, Math.floor(BAD_STRS.length/5))
  for (var i = 0; i < al; i ++) {
      var v = BAD_STRS[i]
      for (var j = 0; j < al; j ++) {
        BAD_ARRS.push([v, BAD_STRS[j]])
      }
  }
  var al2 = Math.min(3, Math.floor(al/5))
  for (var i = 0; i < al2; i ++) {
      var v = BAD_STRS[i]
      for (var j = 0; j < al2; j ++) {
          var v2 = BAD_STRS[j]
          for (var k = 0; k < al2; k ++) {
            BAD_ARRS.push([v, v2, BAD_STRS[k]])
          }
      }
  }

  var BAD_OBJS = []
  var ol = Math.min(10, Math.floor(BAD_STRS.length/5))
  for (var i = 10; i < ol; i ++) { // 太多就导致 RANDOM_BAD 基本每次随机出来都是对象
    var k = BAD_STRS[i]
    var key = k == undefined ? 'undefined' : (typeof k == 'string' ? k : JSON.stringify(k))
    for (var j = 0; j < ol; j ++) {
        BAD_OBJS.push({[key]: BAD_STRS[j]})
    }
  }
  // FIXME 打开时直接卡死崩溃
  for (var i = 0; i < ol; i ++) {
    var k = BAD_STRS[i]
    var key = k == undefined ? 'undefined' : (typeof k == 'string' ? k : JSON.stringify(k))
    for (var j = 0; j < ol; j ++) {
      var val = BAD_STRS[j]
      for (var i2 = 0; i2 < ol; i2 ++) {
        var k2 = BAD_STRS[i2]
        var key2 = k2 == undefined ? 'undefined' : (typeof k2 == 'string' ? k2 : JSON.stringify(k))
        for (var j2 = 0; j2 < ol; j2 ++) {
            BAD_OBJS.push({[key]: val, [key2]: BAD_STRS[j2]})
        }
      }
    }
  }
//  var ol = Math.min(10, Math.floor(BAD_OBJS.length/5))
  var BADS = BAD_STRS.concat(BAD_ARRS).concat(BAD_OBJS)

  var PRIME_INTS = [
  1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
  , 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199
  , 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293
  , 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397
  , 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499
  , 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599
  , 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691
  , 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797
  , 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887
  , 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997
  , 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097
  , 1103, 1109, 1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193
  , 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297
  , 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399
  , 1409, 1423, 1427, 1429, 1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499
  , 1511, 1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, 1597
  , 1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669, 1693, 1697, 1699
  , 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777, 1783, 1787, 1789
  , 1801, 1811, 1823, 1831, 1847, 1861, 1867, 1871, 1873, 1877, 1879, 1889
  , 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987, 1993, 1997, 1999
  ]
  function randomPrimeInt() {
    return PRIME_INTS[randomInt(0, PRIME_INTS.length - 1)]
  }
  function randomInt(min, max) {
    return randomNum(min, max, 0);
  }
  function randomNum(min, max, precision) {
    // 0 居然也会转成  Number.MIN_SAFE_INTEGER ！！！
    // start = start || Number.MIN_SAFE_INTEGER
    // end = end || Number.MAX_SAFE_INTEGER

    if (min == null) {
      min = Number.MIN_SAFE_INTEGER
    }
    if (max == null) {
      max = Number.MAX_SAFE_INTEGER
    }
    if (precision == null) {
      precision = 2
    }

    return + ((max - min)*Math.random() + min).toFixed(precision)
  }
  function randomStr(minLength, maxLength, availableChars) {
    return 'Ab_Cd' + randomNum()
  }
  function randomIn(...args) {
    return args == null || args.length <= 0 ? null : args[randomInt(0, args.length - 1)]
  }
  function randomBad(defaultArgs, ...args) {
    if (defaultArgs == null) {
      defaultArgs = BADS
    }

    if (args == null || args.length <= 0) {
      return defaultArgs[randomInt(0, defaultArgs.length - 1)]
    }

    args = []
    for (var i = 0; i < defaultArgs.length; i++) {
      args.push(defaultArgs[i])
    }

    return args[randomInt(0, args.length - 1)]
  }
  function randomBadBool(...args) {
    return randomBad(BAD_BOOLS, args)
  }
  function randomBadNum(...args) {
    return randomBad(BAD_NUMS, args)
  }
  function randomBadStr(...args) {
    return randomBad(BAD_STRS, args)
  }
  function randomBadArr(...args) {
    return randomBad(BAD_ARRS, args)
  }
  function randomBadObj(...args) {
    return randomBad(BAD_OBJS, args)
  }

  function orderInt(desc, index, min, max) {
    if (min == null) {
      min = Number.MIN_SAFE_INTEGER
    }
    if (max == null) {
      max = Number.MAX_SAFE_INTEGER
    }

    if (desc) {
      return max - index%(max - min + 1)
    }
    return min + index%(max - min + 1)
  }
  function orderIn(desc, index, ...args) {
    // alert('orderIn  index = ' + index + '; args = ' + JSON.stringify(args));
    index = index || 0;
    return args == null || args.length <= index ? null : args[desc ? args.length - 1 - index : index];
  }
  function orderBad(defaultArgs, desc, index, ...args) {
    // alert('orderIn  index = ' + index + '; args = ' + JSON.stringify(args));
    if (defaultArgs == null) {
      defaultArgs = BADS
    }

    index = index || 0;
    if (args == null || args.length <= 0) {
      return defaultArgs[desc ? defaultArgs.length - index : index]
    }

    args = []
    for (var i = 0; i < defaultArgs.length; i++) {
      args.push(defaultArgs[i])
    }

    return args[desc ? args.length - index : index]
  }
  function orderBadBool(desc, index, ...args) {
    return orderBad(BAD_BOOLS, desc, index, ...args)
  }
  function orderBadNum(desc, index, ...args) {
    return orderBad(BAD_NUMS, desc, index, ...args)
  }
  function orderBadStr(desc, index, ...args) {
    return orderBad(BAD_STRS, desc, index, ...args)
  }
  function orderBadArr(desc, index, ...args) {
    return orderBad(BAD_ARRS, desc, index, ...args)
  }
  function orderBadObj(desc, index, ...args) {
    return orderBad(BAD_OBJS, desc, index, ...args)
  }

  function getOrderIndex(randomId, line, argCount, step) {
    // alert('randomId = ' + randomId + '; line = ' + line + '; argCount = ' + argCount);
    // alert('ORDER_MAP = ' + JSON.stringify(ORDER_MAP, null, '  '));

    if (randomId == null) {
      randomId = 0;
    }
    if (ORDER_MAP == null) {
      ORDER_MAP = {};
    }
    if (ORDER_MAP[randomId] == null) {
      ORDER_MAP[randomId] = {};
    }

    var orderIndex = ORDER_MAP[randomId][line];
    // alert('orderIndex = ' + orderIndex)

    if (orderIndex == null || orderIndex < -1) {
      orderIndex = -1;
    }
    if (argCount == null) {
      argCount = 0;
    }
    if (step == null) {
      step = 1;
    }

    orderIndex ++
    ORDER_MAP[randomId][line] = orderIndex;
    orderIndex = argCount <= 0 ? step*orderIndex : step*orderIndex%argCount;

    // alert('orderIndex = ' + orderIndex)
    // alert('ORDER_MAP = ' + JSON.stringify(ORDER_MAP, null, '  '));
    return orderIndex;
  }
  //这些全局变量不能放在data中，否则会报undefined错误

  var BREAK_ALL = 'BREAK_ALL'
  var BREAK_LAST = 'BREAK_LAST'

  var baseUrl
  var inputted
  var handler
  var errHandler
  var docObj
  var doc
  var output

  var isSingle = true

  var currentTarget = vInput;
  var isInputValue = false;
  var isClickSelectInput = false;
  var selectionStart = 0;
  var selectionEnd = 0;

  function newDefaultScript() {
    return { // index.html 中 v-model 绑定，不能为 null
      case: {
        0: {
          pre: { // 可能有 id
            script: '' // index.html 中 v-model 绑定，不能为 null
          },
          post: {
            script: ''
          }
        },
        1560244940013: {
          pre: { // 可能有 id
            script: '' // index.html 中 v-model 绑定，不能为 null
          },
          post: {
            script: ''
          }
        }
      },
      account: {
        0: {
          pre: {
            script: ''
          },
          post: {
            script: ''
          }
        },
        82001: {
          pre: {
            script: ''
          },
          post: {
            script: ''
          }
        }
      },
      global: {
        0: {
          pre: {
            script: ''
          },
          post: {
            script: ''
          }
        }
      }
    }
  }

// APIJSON >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  var App = {
    el: '#app',
    data: {
      baseview: 'formater',
      view: 'output',
      jsoncon: JSON.stringify(initJson),
      jsonhtml: initJson,
      compressStr: '',
      error: {},
      requestVersion: 3,
      requestCount: 1,
      urlComment: ': double // 除法运算',
      selectIndex: 0,
      options: [], // [{name:"id", type: "integer", comment:"主键"}, {name:"name", type: "string", comment:"用户名称"}],
      historys: [],
      history: {name: '请求0'},
      remotes: [],
      locals: [],
      casePaths: [],
      caseGroups: [],
      testCases: [],
      randoms: [],
      randomSubs: [],
      account: '13000082001',
      password: '123456',
      logoutSummary: {},
      accounts: [
        {
          'id': 82001,
          'isLoggedIn': false,
          'name': '测试账号1',
          'phone': '13000082001',
          'password': '123456'
        },
        {
          'id': 82002,
          'isLoggedIn': false,
          'name': '测试账号2',
          'phone': '13000082002',
          'password': '123456'
        },
        {
          'id': 82003,
          'isLoggedIn': false,
          'name': '测试账号3',
          'phone': '13000082003',
          'password': '123456'
        }
      ],
      otherEnvCookieMap: {},
      allSummary: {},
      currentAccountIndex: 0,
      currentDocIndex: -1,
      currentRandomIndex: -1,
      currentRandomSubIndex: -1,
      tests: { '-1':{}, '0':{}, '1':{}, '2': {} },
      crossProcess: '交叉账号:已关闭',
      testProcess: '机器学习:已关闭',
      randomTestTitle: '参数注入 Random Test',
      testRandomCount: 1,
      testRandomProcess: '',
      compareColor: '#0000',
      scriptType: 'case',
      scriptBelongId: 0,
      scripts: newDefaultScript(),
      loadingCount: 0,
      isPreScript: true,
      isRandomTest: false,
      isDelayShow: false,
      isSaveShow: false,
      isExportShow: false,
      isExportCheckShow: false,
      isExportRandom: false,
      isExportScript: false,
      isOptionListShow: false,
      isTestCaseShow: false,
      isHeaderShow: false,
      isScriptShow: false,
      isRandomShow: true,  // 默认展示
      isRandomListShow: false,
      isRandomSubListShow: false,
      isRandomEditable: false,
      isCaseGroupEditable: false,
      isLoginShow: false,
      isConfigShow: false,
      isDeleteShow: false,
      caseShowType: 0,
      statisticsShowType: 0,
      currentHttpResponse: {},
      currentDocItem: {
        "Method":{
          "id":1648471968021,
          "userId":82001,
          "static":0,
          "ui":0,
          "type":"double",
          "genericType":"double",
          "package":"unitauto.test",
          "class":"TestUtil",
          "method":"divide",
          "methodArgs":"[{\"type\":\"long\",\"value\":1},{\"type\":\"long\",\"value\":2}]",
          "request":"{\n    \"static\": true,\n    \"methodArgs\": [\n        {   // 可省略来自动判断的 type : Boolean,Integer,BigDecimal,String,JSONObject,JSONArray\n            \"type\": \"long\",\n            \"value\": 1\n        },\n        {\n            \"type\": \"long\",\n            \"value\": 2\n        }\n    ]\n}\n\n/* 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。 */\n\n\n                                                                                                                                                                                                              \n",
          "detail":": double  // 除法运算",
          "date":"2022-03-28 20:52:48.0",
          "arguments":"",
          "defination":"divide(): double",
          "constructorArguments":""
        },
        "TestRecord":{
          "id":1649186005068,
          "userId":82001,
          "documentId":1648471968021,
          "response":"{\"msg\":\"success\",\"type\":\"double\",\"return\":0.5,\"methodArgs\":[{\"type\":\"long\",\"value\":1},{\"type\":\"long\",\"value\":2}],\"code\":200}",
          "standard":"{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"msg\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[7]},\"type\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[6]},\"return\":{\"notnull\":true,\"type\":\"number\",\"valueLevel\":1,\"values\":[0.5],\"lengthLevel\":1,\"lengths\":[1]},\"methodArgs\":{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"0\":{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"type\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[4]},\"value\":{\"notnull\":true,\"type\":\"integer\",\"valueLevel\":0,\"values\":[1],\"lengthLevel\":1,\"lengths\":[]}}]},\"1\":{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"type\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[4]},\"value\":{\"notnull\":true,\"type\":\"integer\",\"valueLevel\":0,\"values\":[2],\"lengthLevel\":1,\"lengths\":[]}}]}}]}}],\"code\":200}"
        }
      },
      currentRemoteItem: {
        "Method":{
          "id":1648471968021,
          "userId":82001,
          "static":0,
          "ui":0,
          "type":"double",
          "genericType":"double",
          "package":"unitauto.test",
          "class":"TestUtil",
          "method":"divide",
          "methodArgs":"[{\"type\":\"long\",\"value\":1},{\"type\":\"long\",\"value\":2}]",
          "request":"{\n    \"static\": true,\n    \"methodArgs\": [\n        {   // 可省略来自动判断的 type : Boolean,Integer,BigDecimal,String,JSONObject,JSONArray\n            \"type\": \"long\",\n            \"value\": 1\n        },\n        {\n            \"type\": \"long\",\n            \"value\": 2\n        }\n    ]\n}\n\n/* 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。 */\n\n\n                                                                                                                                                                                                              \n",
          "detail":": double  // 除法运算",
          "date":"2022-03-28 20:52:48.0",
          "arguments":"",
          "defination":"divide(): double",
          "constructorArguments":""
        },
        "TestRecord":{
          "id":1649186005068,
          "userId":82001,
          "documentId":1648471968021,
          "response":"{\"msg\":\"success\",\"type\":\"double\",\"return\":0.5,\"methodArgs\":[{\"type\":\"long\",\"value\":1},{\"type\":\"long\",\"value\":2}],\"code\":200}",
          "standard":"{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"msg\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[7]},\"type\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[6]},\"return\":{\"notnull\":true,\"type\":\"number\",\"valueLevel\":1,\"values\":[0.5],\"lengthLevel\":1,\"lengths\":[1]},\"methodArgs\":{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"0\":{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"type\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[4]},\"value\":{\"notnull\":true,\"type\":\"integer\",\"valueLevel\":0,\"values\":[1],\"lengthLevel\":1,\"lengths\":[]}}]},\"1\":{\"notnull\":true,\"type\":\"object\",\"valueLevel\":0,\"values\":[{\"type\":{\"notnull\":true,\"type\":\"string\",\"valueLevel\":3,\"values\":[],\"lengthLevel\":1,\"lengths\":[4]},\"value\":{\"notnull\":true,\"type\":\"integer\",\"valueLevel\":0,\"values\":[2],\"lengthLevel\":1,\"lengths\":[]}}]}}]}}],\"code\":200}"
        }
      },
      currentRandomItem: {},
      isAdminOperation: false,
      loginType: 'login',
      isExportRemote: false,
      isRegister: false,
      isCrossEnabled: false,
      isMLEnabled: false,
      isDelegateEnabled: false,
      isEnvCompareEnabled: false,
      isPreviewEnabled: false,
      isStatisticsEnabled: false,
      isEncodeEnabled: false,
      isEditResponse: false,
      isLocalShow: false,
      uploadTotal: 0,
      uploadDoneCount: 0,
      uploadFailCount: 0,
      uploadRandomCount: 0,
      exTxt: {
        name: 'APIJSON测试',
        label: '发布简单接口',
        button: '保存',
        index: 0
      },
      themes: themes,
      checkedTheme: 0,
      isExpand: true,
      reportId: null,
      User: {
        id: 0,
        name: '',
        head: ''
      },
      Privacy: {
        id: 0,
        balance: null //点击更新提示需要判空 0.00
      },
      type: REQUEST_TYPE_JSON,
      types: [ REQUEST_TYPE_JSON ],
      host: '', // 'apijson.demo.server.DemoFunction.',
      branch: 'countArray',
      database: undefined,  // 后端决定 'MYSQL',// 'POSTGRESQL',
      schema: undefined,  // 后端决定 'admin',  // 'sys'
      otherEnv: 'http://localhost:8080',  // 其它环境服务地址，用来对比当前的
      server: 'http://apijson.cn:9090',  //apijson.cn
      // server: 'http://47.74.39.68:9090',  // apijson.org
      project: 'http://apijson.cn:8080', // 'http://localhost:8081',
      language: 'Java,Kotlin,Go', // CodeUtil.LANGUAGE_JAVA,
      header: {},
      page: 0,
      count: 15,
      search: '',
      caseGroupPage: 0,
      caseGroupPages: {},
      caseGroupCount: 0,
      caseGroupCounts: {},
      caseGroupSearch: '',
      caseGroupSearches: {},
      testCasePage: 0,
      testCasePages: {},
      testCaseCount: 50,
      testCaseCounts: {},
      testCaseSearch: '',
      testCaseSearches: {},
      randomPage: 0,
      randomCount: 50,
      randomSearch: '',
      randomSubPage: 0,
      randomSubCount: 50,
      randomSubSearch: '',
      doneCount: 0,
      allCount: 0,
      deepDoneCount: 0,
      deepAllCount: 0,
      randomDoneCount: 0,
      randomAllCount: 0,
      coverage: {
        json: {},
        html: ''
      }
    },

    methods: {
      // 全部展开
      expandAll: function () {
        if (this.view != 'code') {
          alert('请先获取正确的JSON Response！')
          return
        }

        $('.icon-square-min').show()
        $('.icon-square-plus').hide()
        $('.expand-view').show()
        $('.fold-view').hide()

        this.isExpand = true;
      },

      // 全部折叠
      collapseAll: function () {
        if (this.view != 'code') {
          alert('请先获取正确的JSON Response！')
          return
        }

        $('.icon-square-min').hide()
        $('.icon-square-plus').show()
        $('.expand-view').hide()
        $('.fold-view').show()

        this.isExpand = false;
      },

      // diff
      diffTwo: function () {
        var oldJSON = {}
        var newJSON = {}
        this.view = 'code'
        try {
          oldJSON = jsonlint.parse(this.jsoncon)
        } catch (ex) {
          this.view = 'error'
          this.error = {
            msg: '原 JSON 解析错误\r\n' + ex.message
          }
          return
        }

        try {
          newJSON = jsonlint.parse(this.jsoncon)
        } catch (ex) {
          this.view = 'error'
          this.error = {
            msg: '新 JSON 解析错误\r\n' + ex.message
          }
          return
        }

        var base = difflib.stringAsLines(JSON.stringify(oldJSON, '', 4))
        var newtxt = difflib.stringAsLines(JSON.stringify(newJSON, '', 4))
        var sm = new difflib.SequenceMatcher(base, newtxt)
        var opcodes = sm.get_opcodes()
        $('#diffoutput').empty().append(diffview.buildView({
          baseTextLines: base,
          newTextLines: newtxt,
          opcodes: opcodes,
          baseTextName: '原 JSON',
          newTextName: '新 JSON',
          contextSize: 2,
          viewType: 0
        }))
      },

      baseViewToDiff: function () {
        this.baseview = 'diff'
        this.diffTwo()
      },

      // 回到格式化视图
      baseViewToFormater: function () {
        this.baseview = 'formater'
        this.view = 'code'
        this.showJsonView()
      },

      // 根据json内容变化格式化视图
      showJsonView: function () {
        if (this.baseview === 'diff') {
          return
        }
        try {
          if (this.jsoncon.trim() === '') {
            this.view = 'empty'
          } else {
            this.view = 'code'

            var ret = this.jsoncon
            try {
              ret = jsonlint.parse(this.jsoncon)
            } catch (ex) {
              log(ex)
            }
            if (isSingle || ret instanceof Array || (ret instanceof Object == false)) {
              this.jsonhtml = ret
            }
            else {
              this.jsonhtml = Object.assign({
                _$_this_$_: JSON.stringify({
                  path: null,
                  table: null
                })
              }, ret)
            }

          }
        } catch (ex) {
          this.view = 'error'
          this.error = {
            msg: ex.message
          }
        }
      },


      showUrl: function (isAdminOperation, branchUrl) {
        if (StringUtil.isEmpty(this.host, true)) {  //显示(可编辑)URL Host
          if (isAdminOperation != true) {
            baseUrl = this.getBaseUrl()
          }
          vUrl.value = (isAdminOperation ? this.server : baseUrl) + branchUrl
        }
        else {  //隐藏(固定)URL Host
          if (isAdminOperation) {
            this.host = this.server
          }
          vUrl.value = branchUrl
        }

        vUrlComment.value = isSingle || StringUtil.isEmpty(this.urlComment, true)
          ? '' : CodeUtil.getBlank(StringUtil.length(vUrl.value), 1) + ' ' + this.urlComment
          // + ' - ' + (this.requestVersion > 0 ? 'V' + this.requestVersion : 'V*');
      },

      //设置基地址
      setBaseUrl: function () {
        if (StringUtil.isEmpty(this.host, true) != true) {
          return
        }
        // 重新拉取文档
        var bu = this.getBaseUrl()
        if (baseUrl != bu) {
          baseUrl = bu;
          // doc = null //这个是本地的数据库字典及非开放请求文档
          this.saveCache('', 'URL_BASE', baseUrl)

          //已换成固定的管理系统URL

          // this.remotes = []

          // var index = baseUrl.indexOf(':') //http://localhost:8080
          // this.server = (index < 0 ? baseUrl : baseUrl.substring(0, baseUrl)) + ':9090'

        }
      },
      getUrl: function () {
        var url = StringUtil.get(this.host) + vUrl.value
        return url.replaceAll(' ', '')
      },
      //获取基地址
      getBaseUrl: function (url_) {
        var url = StringUtil.trim(url_ || vUrl.value)
        var length = this.getBaseUrlLength(url)
        url = length <= 0 ? '' : url.substring(0, length)
        return url == '' ? URL_BASE : url
      },
      //获取基地址长度，以://后的第一个/分割baseUrl和method
      getBaseUrlLength: function (url_) {
        var url = StringUtil.trim(url_)
        var index = url.indexOf(' ')
        if (index >= 0) {
          return index + 1
        }

        index = url.lastIndexOf('.')
        return index < 0 ? 0 : index + 1
      },
      //获取操作方法
      getMethod: function (url) {
        url = StringUtil.trim(url || vUrl.value)
        var index = url.lastIndexOf('.')
        url = index <= 0 ? url : url.substring(index + 1)
        return StringUtil.trim(url.startsWith('.') ? url.substring(1) : url)
      },
      //获取操作方法
      getClass: function (url) {
        url = url || this.getUrl()
        var index = url.lastIndexOf('.')
        if (index <= 0) {
          throw new Error('完整的 URI 必须符合格式 Java/Kotlin: package.Class.method, Go: package.func / package.Struct.method, ' +
              '\n Python: package.function / package.file.function / package.Class.method / package.file.Class.method ！')
        }
        url = url.substring(0, index)
        index = url.lastIndexOf('.')
        var clazz = StringUtil.trim(index < 0 ? url : url.substring(index + 1))
        var lang = this.language
        if (StringUtil.isBigName(clazz) != true) {
          if (lang == CodeUtil.LANGUAGE_GO) {
            return ''
          }

          if ([CodeUtil.LANGUAGE_JAVA, CodeUtil.LANGUAGE_KOTLIN].indexOf(lang) >= 0) {
            alert('类名 ' + clazz + ' 不符合规范！')
          }
        }
        return clazz
      },
      //获取操作方法
      getPackage: function (url) {
        url = url || this.getUrl()
        var index = url.lastIndexOf('.')
        if (index <= 0) {
          throw new Error('完整的 URI 必须符合格式 Java/Kotlin: package.Class.method, Go: package.func / package.Struct.method, ' +
              '\n Python: package.function / package.file.function / package.Class.method / package.file.Class.method ！')
        }
        url = url.substring(0, index)
        index = url.lastIndexOf('.')
        var cls = url.substring(index + 1)
        var pkg = index < 0 ? '' : url.substring(0, index)

        if (this.language == CodeUtil.LANGUAGE_GO && StringUtil.isBigName(cls) != true) {
          pkg = StringUtil.isEmpty(pkg) ? cls : pkg + '.' + cls
        }
        return StringUtil.trim(pkg)
      },
      //获取请求的tag
      getTag: function () {
        var req = null;
        try {
          req = this.getRequest(vInput.value);
        } catch (e) {
          log('main.getTag', 'try { req = this.getRequest(vInput.value); \n } catch (e) {\n' + e.message)
        }
        return req == null ? null : req.tag
      },

      getRequest: function (json, defaultValue, isRaw) {  // JSON5 兜底，减少修改范围  , isSingle) {
        var s = isRaw != true && isSingle ? this.switchQuote(json) : json; // this.toDoubleJSON(json, defaultValue);
        if (StringUtil.isEmpty(s, true)) {
          return defaultValue
        }
        try {
          return jsonlint.parse(s);
        }
        catch (e) {
          log('main.getRequest', 'try { return jsonlint.parse(s); \n } catch (e) {\n' + e.message)
          log('main.getRequest', 'return JSON5.parse(s);')
          return JSON5.parse(s);  // jsonlint.parse(this.removeComment(s));
        }
      },
      getExtraComment: function(json) {
        var it = json != null ? json : StringUtil.trim(vInput.value);

        var start = it.lastIndexOf('\n/*');
        var end = it.lastIndexOf('\n*/');

        return start < 0 || end <= start ? null : it.substring(start + '\n/*'.length, end);
      },

      getHeader: function (text) {
        var header = {}
        var hs = StringUtil.isEmpty(text, true) ? null : StringUtil.split(text, '\n')

        if (hs != null && hs.length > 0) {
          var item
          for (var i = 0; i < hs.length; i++) {
            item = hs[i] || ''

            // 解决整体 trim 后第一行  // 被当成正常的 key 路径而不是注释
            var index = StringUtil.trim(item).startsWith('//') ? 0 : item.lastIndexOf(' //')  // 不加空格会导致 http:// 被截断  ('//')  //这里只支持单行注释，不用 removeComment 那种带多行的去注释方式
            var item2 = index < 0 ? item : item.substring(0, index)
            item2 = item2.trim()
            if (item2.length <= 0) {
              continue;
            }

            index = item2.indexOf(':')
            if (index <= 0) {
              throw new Error('请求头 Request Header 输入错误！请按照每行 key: value 的格式输入，不要有多余的换行或空格！'
                + '\n错误位置: 第 ' + (i + 1) + ' 行'
                + '\n错误文本: ' + item)
            }

            var val = item2.substring(index + 1, item2.length)

            var ind = val.indexOf('(')  //一定要有函数是为了避免里面是一个简短单词和 UnitAuto 代码中变量冲突
            if (ind > 0 && val.indexOf(')') > ind) {  //不从 0 开始是为了保证是函数，且不是 (1) 这种单纯限制作用域的括号
              try {
                val = eval(val)
              }
              catch (e) {
                this.log("getHeader  if (hs != null && hs.length > 0) { ... if (ind > 0 && val.indexOf(')') > ind) { ... try { val = eval(val) } catch (e) = " + e.message)
              }
            }

            header[StringUtil.trim(item2.substring(0, index))] = val
          }
        }

        return header
      },

      // 分享 UnitAuto 特有链接，打开即可还原分享人的 JSON 参数、设置项、搜索关键词、分页数量及页码等配置
      shareLink: function (isRandom) {
        var settingStr = null
        try {
          settingStr = JSON.stringify({
            requestVersion: this.requestVersion,
            requestCount: this.requestCount,
            isTestCaseShow: this.isTestCaseShow,
            // isHeaderShow: this.isHeaderShow,
            // isRandomShow: this.isRandomShow,
            isRandomListShow: this.isRandomShow ? this.isRandomListShow : undefined,
            isRandomSubListShow: this.isRandomListShow ? this.isRandomSubListShow : undefined,
            // isRandomEditable: this.isRandomEditable,
            isCrossEnabled: this.isCrossEnabled,
            isMLEnabled: this.isMLEnabled,
            isDelegateEnabled: this.isDelegateEnabled,
            isPreviewEnabled: this.isPreviewEnabled,
            isStatisticsEnabled: this.isStatisticsEnabled,
            isEncodeEnabled: this.isEncodeEnabled,
            isEditResponse: this.isEditResponse,
            isLocalShow: this.isTestCaseShow ? this.isLocalShow : undefined,
            language: this.language,
            page: this.page,
            count: this.count,
            testCasePage: this.testCasePage,
            testCaseCount: this.testCaseCount,
            testRandomCount: this.testRandomCount,
            randomPage: this.randomPage,
            randomCount: this.randomCount,
            randomSubPage: this.randomSubPage,
            randomSubCount: this.randomSubCount,
            host: StringUtil.isEmpty(this.host, true) ? undefined : encodeURIComponent(this.host),
            search: StringUtil.isEmpty(this.search, true) ? undefined : encodeURIComponent(this.search),
            testCaseSearch: StringUtil.isEmpty(this.testCaseSearch, true) ? undefined : this.testCaseSearch,
            randomSearch: StringUtil.isEmpty(this.randomSearch, true) ? undefined : encodeURIComponent(this.randomSearch),
            randomSubSearch: StringUtil.isEmpty(this.randomSubSearch, true) ? undefined : encodeURIComponent(this.randomSubSearch)
          })
        } catch (e) {
          log(e)
        }

        // 实测 561059 长度的 URL 都支持，只是输入框显示长度约为 2000
        window.open(this.getShareLink(
          isRandom
          , null
          , null
          , null
          , this.isTestCaseShow || StringUtil.isEmpty(vHeader.value, true) ? null : encodeURIComponent(StringUtil.trim(vHeader.value))
          , this.isTestCaseShow || StringUtil.isEmpty(vRandom.value, true) ? null : encodeURIComponent(StringUtil.trim(vRandom.value))
          , settingStr
        ))
      },
      getShareLink: function (isRandom, json, url, type, header, random, setting) {
        var jsonStr = json == null ? null : (typeof json == 'string' ? json : JSON.stringify(json))
        if (this.isTestCaseShow != true && jsonStr == null) { // StringUtil.isEmpty(jsonStr)
          try {
            jsonStr = JSON.stringify(encode(JSON.parse(vInput.value)))
          } catch (e) {  // 可能包含注释
            log(e)
            jsonStr = encode(StringUtil.trim(vInput.value))
          }
        }

        var headerStr = header

        var randomStr = random

        // URL 太长导致打不开标签
        var settingStr = setting

        var href = window.location.href || 'http://apijson.cn/api'
        var ind = href == null ? -1 : href.indexOf('?')  // url 后带参数只能 encodeURIComponent

        return (ind < 0 ? href : href.substring(0, ind))
          + (this.view != 'code' ? "?send=false" : (isRandom ? "?send=random" : "?send=true"))
          + "&type=" + StringUtil.trim(this.type || 'Object')
          + "&url=" + encodeURIComponent(StringUtil.trim(url == null ? vUrl.value : url))
          + (jsonStr == null ? '' : "&json=" + jsonStr)
          + (headerStr == null ? '' : "&header=" + headerStr)
          + (randomStr == null ? '' : "&random=" + randomStr)
          + (settingStr == null ? '' : "&setting=" + settingStr)

      },

      onClickSelectInput: function (item, index) {
        isClickSelectInput = true;
        this.selectInput(item, index, true);
      },
      selectInput: function (item, index, isDone) { // , isValue) {
        var target = currentTarget = currentTarget || vInput; // currentTarget = target;
        var isValue = isInputValue; // isInputValue = isValue;

        // 失去焦点后拿不到有效值
        // var selectionStart = target.selectionStart;
        // var selectionEnd = target.selectionEnd;

        var text = StringUtil.get(target.value);
        var before = text.substring(0, selectionStart);
        var after = text.substring(selectionEnd);

        var name = item == null ? '' : StringUtil.get(item.name);
        target.value = text = before + name + after
        if (target == vScript) { // 不这样会自动回滚
          App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = text
        }
        else if (target == vInput) {
          inputted = target.value;
        }

        if (isDone) {
          this.options = [];

          target.focus();
          selectionStart = target.selectionStart = selectionEnd + (isClickSelectInput ? (name.length - (isValue ? 4 : 0)) : 0)
            + (isValue ? (after.startsWith(',') ? 1 : 0) : (target == vInput || target == vScript ? 3 : 2));
          selectionEnd = target.selectionEnd = selectionStart + (isValue ? 0 : 4)
          isClickSelectInput = false;
          // vOption.focusout()

          if (isInputValue != true) {
            App.showOptions(target, text, before + name + (isSingle ? "'" : '"') + ': ', after.substring(3), true);
          }
        } else {
          target.selectionStart = selectionStart;
          selectionEnd = target.selectionEnd = selectionStart + name.length;
          isClickSelectInput = false;
        }
      },

      // 显示保存弹窗
      showSave: function (show) {
        if (show) {
          if (this.isTestCaseShow) {
            alert('请先输入请求内容！')
            return
          }

          var tag = this.getTag()
          this.history.name = (this.urlComment || this.getMethod() + (StringUtil.isEmpty(tag, true) ? '' : ' ' + tag)) + ' ' + this.formatTime() //不自定义名称的都是临时的，不需要时间太详细
        }
        this.isSaveShow = show
      },

      // 显示导出弹窗
      showExport: function (show, isRemote, isRandom, isScript) {
        if (show) {
          // this.isExportCheckShow = isRemote

          if (isRemote) { //共享测试用例
            this.isExportRandom = isRandom
            this.isExportScript = isScript

            // if (isRandom != true) {  // 分享搜索关键词和分页信息也挺好 } && this.isTestCaseShow != true) {  // 没有拿到列表，没用
              // setTimeout(function () {
              //   App.shareLink(App.isRandomTest)
              // }, 1000)
            // }

            if (this.isTestCaseShow) {
              alert('请先输入请求内容！')
              return
            }

            if (this.view == 'error') {  // this.view != 'code') {
              alert('发现错误，请输入正确的内容！')  // alert('请先测试请求，确保是正确可用的！')
              return
            }
            if (isRandom) {
              this.exTxt.name = '随机配置 ' + this.formatDateTime()
            }
            else if (isScript) { // 避免 APIJSON 启动报错  '执行脚本 ' + this.formatDateTime()
              this.exTxt.name = this.scriptType + (this.isPreScript ? 'Pre' : 'Post') + this.getCurrentScriptBelongId()
            }
            else {
              if (this.isEditResponse) {
                this.isExportRemote = isRemote
                this.exportTxt()
                return
              }

              var tag = this.getTag()
              this.exTxt.name = this.urlComment || (this.getMethod() + (StringUtil.isEmpty(tag, true) ? '' : ' ' + tag))
            }
          }
          else { //下载到本地
            if (this.isTestCaseShow) { //文档
              this.exTxt.name = 'APIJSON自动化文档 ' + this.formatDateTime()
            }
            else if (this.view == 'markdown' || this.view == 'output') {
              var suffix
              switch (this.language) {
                case CodeUtil.LANGUAGE_KOTLIN:
                  suffix = '.kt';
                  break;
                case CodeUtil.LANGUAGE_JAVA:
                  suffix = '.java';
                  break;
                case CodeUtil.LANGUAGE_C_SHARP:
                  suffix = '.cs';
                  break;

                case CodeUtil.LANGUAGE_SWIFT:
                  suffix = '.swift';
                  break;
                case CodeUtil.LANGUAGE_OBJECTIVE_C:
                  suffix = '.h';
                  break;

                case CodeUtil.LANGUAGE_GO:
                  suffix = '.go';
                  break;
                case CodeUtil.LANGUAGE_C_PLUS_PLUS:
                  suffix = '.cpp';
                  break;

                case CodeUtil.LANGUAGE_TYPE_SCRIPT:
                  suffix = '.ts';
                  break;
                case CodeUtil.LANGUAGE_JAVA_SCRIPT:
                  suffix = '.js';
                  break;

                case CodeUtil.LANGUAGE_PHP:
                  suffix = '.php';
                  break;
                case CodeUtil.LANGUAGE_PYTHON:
                  suffix = '.py';
                  break;
                default:
                  suffix = '.java';
                  break;
              }

              this.exTxt.name = 'User' + suffix
              alert('自动生成模型代码，可填类名后缀:\n'
                + 'Kotlin.kt, Java.java, Swift.swift, Objective-C.m, C#.cs, Go.go,'
                + '\nTypeScript.ts, JavaScript.js, PHP.php, Python.py, C++.cpp');
            }
            else {
              this.exTxt.name = 'APIJSON测试 ' + this.getMethod() + ' ' + this.formatDateTime()
            }
          }
        }

        this.isExportShow = show
        this.isExportRemote = isRemote
      },

      // 显示配置弹窗
      showConfig: function (show, index) {
        this.isConfigShow = false
        if (this.isTestCaseShow) {
          if (index == 3 || index == 4 || index == 5 || index == 10 || index == 13) {
            this.showTestCase(false, false)
          }
        }

        if (show) {
          this.exTxt.button = index == 16 ? '上传' : '切换'
          this.exTxt.index = index
          switch (index) {
            case 0:
            case 1:
            case 2:
            case 6:
            case 7:
            case 8:
            case 16:
            case 15:
              this.exTxt.name = index == 0 ? this.database : (index == 1 ? this.schema : (index == 2 ? this.language
               : (index == 6 ? this.server : (index == 8 ? this.project : (index == 15 ? this.otherEnv : '/method/list')))))
              this.isConfigShow = true

              if (index == 0) {
                alert('可填数据库:\n' + CodeUtil.DATABASE_KEYS.join())
              }
              else if (index == 2) {
                alert('根据语言筛选用例，可填语言:\nKotlin,Java,Swift,Objective-C,C#,Go,\nTypeScript,JavaScript,PHP,Python,C++')
              }
              else if (index == 7) {
                alert('多个类型用 , 隔开，可填类型:\nPARAM(GET ?a=1&b=c&key=value),\nJSON(POST application/json),\nFORM(POST x-www-form-urlencoded),\nDATA(POST form-data),\nGRPC(POST application/json 需要 GRPC 服务开启反射)')
              }
              else if (index == 16) {
                this.showTestCase(false, this.isLocalShow)
                var pkg = this.getPackage()

                vInput.value = this.getCache(this.project, 'request4MethodList') || '{'
                  + '\n    "query": 2, // 查询类型：0-数据，1-总数，2-全部'
                  + '\n    "mock": true, // 是否生成模拟参数值'
                  + '\n    "package": "' + (pkg.startsWith("*") ? pkg.substring(1) : pkg) + '", // 包名，不填默认全部'
                  + '\n    "class": "' + this.getClass() + '", // 类名，不填默认全部'
                  + '\n    "types": null // 类型，不填默认全部，填 ["int", "String"] 这种则只查对应参数的方法 '
                  + '\n}'
                this.onChange(false)
                this.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.project + this.exTxt.name
                  , this.getRequest(vInput.value), this.getHeader(vHeader.value))
              }
              break
            case 3:
              this.host = this.getBaseUrl()
              this.showUrl(false, new String(vUrl.value).substring(this.host.length)) //没必要导致必须重新获取 Response，this.onChange(false)
              this.remotes = null
              break
            case 4:
              this.isHeaderShow = show
              this.saveCache('', 'isHeaderShow', show)
              break
            case 13:
              this.isScriptShow = show
              this.saveCache('', 'isScriptShow', show)
              this.listScript()
              break
            case 5:
              this.isRandomShow = show
              this.saveCache('', 'isRandomShow', show)
              break
            case 9:
              this.isDelegateEnabled = show
              this.saveCache('', 'isDelegateEnabled', show)
              break
            case 14:
              this.isEnvCompareEnabled = show
              this.saveCache('', 'isEnvCompareEnabled', show)

              // this.enableML(false)
              break
            case 10:
              this.isPreviewEnabled = show
              this.saveCache('', 'isPreviewEnabled', show)

              this.onChange(false)
              break
            case 17:
              this.isStatisticsEnabled = show
              this.saveCache('', 'isStatisticsEnabled', show)
              this.isTestCaseShow = false
              this.remotes = null
              this.reportId = 0
              this.showTestCase(true, false)
              break
            case 12:
              this.isEncodeEnabled = show
              this.saveCache('', 'isEncodeEnabled', show)
              break
            case 11:
              var did = ((this.currentRemoteItem || {}).Method || {}).id
              if (did == null) {
                alert('请先选择一个已上传的用例！')
                return
              }

              this.isEditResponse = show
              // this.saveCache('', 'isEditResponse', show)

              vInput.value = ((this.view != 'code' || StringUtil.isEmpty(this.jsoncon, true) ? null : this.jsoncon)
                || (this.currentRemoteItem.TestRecord || {}).response) || ''

              vHeader.value = (this.currentRemoteItem.TestRecord || {}).header || ''

              this.isTestCaseShow = false
              this.onChange(false)
              break
          }
        }
        else if (index == 3) {
          var host = StringUtil.get(this.host)
          var branch = vUrl.value
          this.host = ''
          vUrl.value = host + branch //保证 showUrl 里拿到的 baseUrl = this.host (http://apijson.cn:8080/put /balance)
          this.setBaseUrl() //保证自动化测试等拿到的 baseUrl 是最新的
          this.showUrl(false, branch) //没必要导致必须重新获取 Response，this.onChange(false)
          this.remotes = null
        }
        else if (index == 4) {
          this.isHeaderShow = show
          this.saveCache('', 'isHeaderShow', show)
        }
        else if (index == 13) {
          this.isScriptShow = show
          this.saveCache('', 'isScriptShow', show)
        }
        else if (index == 5) {
          this.isRandomShow = show
          this.saveCache('', 'isRandomShow', show)
        }
        else if (index == 9) {
          this.isDelegateEnabled = show
          this.saveCache('', 'isDelegateEnabled', show)
        }
        else if (index == 10) {
          this.isPreviewEnabled = show
          this.saveCache('', 'isPreviewEnabled', show)
          // vRequestMarkdown.innerHTML = ''
        }
        else if (index == 17) {
          this.isStatisticsEnabled = show
          this.saveCache('', 'isStatisticsEnabled', show)
        }
        else if (index == 14) {
          this.isEnvCompareEnabled = show
          this.saveCache('', 'isEnvCompareEnabled', show)
          this.enableML(this.isMLEnabled)
        }
        else if (index == 12) {
          this.isEncodeEnabled = show
          this.saveCache('', 'isEncodeEnabled', show)
        }
        else if (index == 11) {
          this.isEditResponse = show
          // this.saveCache('', 'isEditResponse', show)

          vInput.value = (this.currentRemoteItem.Method || {}).request || ''
          vHeader.value = (this.currentRemoteItem.Method || {}).header || ''

          this.isTestCaseShow = false
          this.onChange(false)
        }
      },

      // 显示删除弹窗
      showDelete: function (show, item, index, isRandom) {
        this.isDeleteShow = show
        this.isDeleteRandom = isRandom
        this.exTxt.name = '请输入' + (isRandom ? '随机配置' : '接口') + '名来确认'
        if (isRandom) {
          this.currentRandomItem = Object.assign(item, {
            index: index
          })
        }
        else {
          this.currentDocItem = Object.assign(item, {
            index: index
          })
        }
      },

      // 删除接口文档
      deleteDoc: function () {
        var isDeleteRandom = this.isDeleteRandom
        var item = (isDeleteRandom ? this.currentRandomItem : this.currentDocItem) || {}
        var doc = (isDeleteRandom ? item.Random : item.Method) || {}

        var type = isDeleteRandom ? '随机配置' : '方法'
        if (doc.id == null) {
          alert('未选择' + type + '或' + type + '不存在！')
          return
        }
        var nameKey = isDeleteRandom ? 'name' : 'method'
        if (doc[nameKey] != this.exTxt.name) {
          alert('输入的' + type + '名和要删除的' + type + '名不匹配！')
          return
        }

        this.showDelete(false, {})

        this.isTestCaseShow = false
        this.isRandomListShow = false

        var url = this.server + '/delete'
        var req = isDeleteRandom ? {
          format: false,
          'Random': {
            'id': doc.id
          },
          'tag': 'Random'
        } : {
          format: false,
          'Method': {
            'id': doc.id
          },
          'tag': 'Method'
        }
        this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,url, req, {}, function (url, res, err) {
          App.onResponse(url, res, err)

          var rpObj = res.data || {}

          if (isDeleteRandom) {
            if (rpObj.Random != null && JSONResponse.isSuccess(rpObj.Random)) {
              if (((item.Random || {}).toId || 0) <= 0) {
                App.randoms.splice(item.index, 1)
              }
              else {
                App.randomSubs.splice(item.index, 1)
              }
              // App.showRandomList(true, App.currentRemoteItem)
            }
          } else {
            if (rpObj.Method != null && JSONResponse.isSuccess(rpObj.Method)) {
              App.remotes.splice(item.index, 1)
              App.showTestCase(true, App.isLocalShow)
            }
          }
        })
      },

      // 保存当前的JSON
      save: function () {
        if (this.history.name.trim() === '') {
          Helper.alert('名称不能为空！', 'danger')
          return
        }
        var val = {
          name: this.history.name,
          detail: this.history.name,
          type: this.type,
          package: this.getPackage(),
          class: this.getClass(),
          method: this.getMethod(),
          request: inputted,
          response: this.jsoncon,
          header: vHeader.value,
          random: vRandom.value,
          scripts: this.scripts
        }
        var key = String(Date.now())
        localforage.setItem(key, val, function (err, value) {
          Helper.alert('保存成功！', 'success')
          App.showSave(false)
          val.key = key
          App.historys.push(val)
        })
      },

      // 清空本地历史
      clearLocal: function () {
        this.locals.splice(0, this.locals.length) //UI无反应 this.locals = []
        this.saveCache('', 'locals', [])
      },

      // 删除已保存的
      remove: function (item, index, isRemote, isRandom) {
        if (isRemote == null || isRemote == false) { //null != false
          localforage.removeItem(item.key, function () {
            App.historys.splice(index, 1)
          })
        } else {
          if (this.isLocalShow) {
            this.locals.splice(index, 1)
            this.saveCache('', 'locals', this.locals)
            return
          }

          if (isRandom && (((item || {}).Random || {}).id || 0) <= 0) {
            this.randomSubs.splice(index, 1)
            return
          }

          this.showDelete(true, item, index, isRandom)
        }
      },

      // 根据参数注入用例恢复数据
      restoreRandom: function (index, item) {
        this.currentRandomIndex = index
        this.currentRandomItem = item
        this.isRandomListShow = false
        this.isRandomSubListShow = false
        var random = (item || {}).Random || {}
        this.randomTestTitle = random.name
        this.testRandomCount = random.count
        vRandom.value = StringUtil.get(random.config)

        var response = ((item || {}).TestRecord || {}).response
        if (StringUtil.isEmpty(response, true) == false) {
            this.jsoncon = StringUtil.trim(response)
            this.view = 'code'
        }
      },
      // 根据测试用例/历史记录恢复数据
      restoreRemoteAndTest: function (index, item) {
        this.restoreRemote(index, item, true)
      },
      // 根据测试用例/历史记录恢复数据
      restoreRemote: function (index, item, test, showRandom) {
        this.currentDocIndex = index
        this.currentRemoteItem = item
        if (showRandom != null) {
           this.isRandomShow = showRandom
           this.isRandomListShow = showRandom
        }
        this.restore(item, ((item || {}).TestRecord || {}).response, true, test)
      },
      // 根据历史恢复数据
      restore: function (item, response, isRemote, test) {
        this.isEditResponse = false

        item = item || {}
        var doc = item
        var docId = doc.id || 0

        var scripts = item.scripts
        if (isRemote) {
          var orginItem = item
          doc = item.Method || {}
          docId = doc.id || 0

          var pre = Object.assign({
            'script': ''
          }, item['Script:pre'] || {})
          var post = Object.assign({
            'script': ''
          }, item['Script:post'] || {})

          var preId = pre.id
          var postId = post.id
          if (docId > 0 && (preId == null || postId == null)) {
            // var accountId = this.getCurrentAccountId();
            this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,'/get', {
              'Script:pre': preId != null ? undefined : {
                'ahead': 1,
                // 'testAccountId': 0,
                'documentId': docId,
                '@order': 'date-'
              },
              'Script:post': postId != null ? undefined : {
                'ahead': 0,
                // 'testAccountId': 0,
                'documentId': docId,
                '@order': 'date-'
              }
            }, {}, function (url, res, err) {
              var rpObj = res.data
              if (JSONResponse.isSuccess(rpObj) != true) {
                App.log(err != null ? err : (rpObj == null ? '' : rpObj.msg))
                return
              }

              // var scripts = item.scripts || {}
              var scripts = orginItem.scripts || {}
              // var ss = scripts.case
              // if (ss == null) {
              //   scripts.case = ss = {}
              // }

              // var bs = ss[docId]
              // if (bs == null) {
              //   ss[docId] = bs = {}
              // }

              var bs = scripts

              var pre = rpObj['Script:pre']
              if (pre != null && pre.script != null) {
                bs.pre = orginItem['Script:pre'] = rpObj['Script:pre']
              }

              var post = rpObj['Script:post']
              if (post != null && post.script != null) {
                bs.post = orginItem['Script:post'] = rpObj['Script:post']
              }

              orginItem.scripts = scripts

              App.changeScriptType(App.scriptType)
              App.scripts.case[docId] = scripts
            })
          }

          if (scripts == null) {
            scripts = {
              pre: pre,
              post: post
            }
          }
          item.scripts = scripts

          item = doc
          this.scripts.case[docId] = scripts
        }
        else {
          this.scripts = scripts
        }
        
        // localforage.getItem(item.key || '', function (err, value) {

          // this.type = item.type;
          this.urlComment =  ': ' + item.type + CodeUtil.getComment(StringUtil.get(item.detail), false, ' ');
          this.requestVersion = item.version;

          var host = StringUtil.get(this.host)
          var url = item.package + '.' + item.class + '.' + item.method
          if (url.startsWith(host.trim())) {
            var branch = url.substring(host.endsWith(' ') ? host.length - 1 : host.length)
            vUrl.value = branch
          }
          else {
            this.host = ''
            vUrl.value = url
          }
          vUrlComment.value = isSingle || StringUtil.isEmpty(this.urlComment, true) // 导致重复加前缀 App.showUrl(false, branch)
            ? '' : CodeUtil.getBlank(StringUtil.length(vUrl.value), 1) + ' ' + this.urlComment
          // + ' - ' + (this.requestVersion > 0 ? 'V' + this.requestVersion : 'V*');

          this.showTestCase(false, this.isLocalShow)
          vInput.value = StringUtil.get(item.request)
          vHeader.value = StringUtil.get(item.header)
          vRandom.value = StringUtil.get(item.random)
          this.changeScriptType(this.scriptType)

          this.onChange(false)

          if (isRemote) {
            this.randoms = []
            this.showRandomList(this.isRandomListShow, item)
          }

          if (test) {
            this.send(false)
          }
          else {
            if (StringUtil.isEmpty(response, true) == false) {
              setTimeout(function () {
                App.jsoncon = StringUtil.trim(response)
                App.view = 'code'
              }, 500)
            }
          }

        // })
      },

      // 获取所有保存的json
      listHistory: function () {
        localforage.iterate(function (value, key, iterationNumber) {
          if (key[0] !== '#') {
            value.key = key
            App.historys.push(value)
          }
          if (key === '#theme') {
            // 设置默认主题
            App.checkedTheme = value
          }
        })
      },

      // 导出文本
      exportTxt: function (btnIndex) {
        if (btnIndex == null) {
          btnIndex = 0
        }

        if (btnIndex == 1 && this.isExportRandom != true) {
          this.shareLink(this.isRandomTest)
          return
        }

        this.isExportShow = false

        if (this.isExportRemote == false) { //下载到本地

          if (this.isTestCaseShow) { //文档
            saveTextAs('# ' + this.exTxt.name + '\n主页: https://github.com/Tencent/APIJSON'
              + '\n\nBASE_URL: ' + this.getBaseUrl()
              + '\n\n\n## 测试用例(Markdown格式，可用工具预览) \n\n' + this.getDoc4TestCase()
              + '\n\n\n\n\n\n\n\n## 文档(Markdown格式，可用工具预览) \n\n' + doc
              , this.exTxt.name + '.txt')
          }
          else if (this.view == 'markdown' || this.view == 'output') { //model
            var clazz = StringUtil.trim(this.exTxt.name)

            var txt = '' //配合下面 +=，实现注释判断，一次全生成，方便测试
            if (clazz.endsWith('.java')) {
              txt += CodeUtil.parseJavaBean(docObj, clazz.substring(0, clazz.length - 5), this.database)
            }
            else if (clazz.endsWith('.swift')) {
              txt += CodeUtil.parseSwiftStruct(docObj, clazz.substring(0, clazz.length - 6), this.database)
            }
            else if (clazz.endsWith('.kt')) {
              txt += CodeUtil.parseKotlinDataClass(docObj, clazz.substring(0, clazz.length - 3), this.database)
            }
            else if  (clazz.endsWith('.m')) {
              txt += CodeUtil.parseObjectiveCEntity(docObj, clazz.substring(0, clazz.length - 2), this.database)
            }
            else if  (clazz.endsWith('.cs')) {
              txt += CodeUtil.parseCSharpEntity(docObj, clazz.substring(0, clazz.length - 3), this.database)
            }
            else if  (clazz.endsWith('.php')) {
              txt += CodeUtil.parsePHPEntity(docObj, clazz.substring(0, clazz.length - 4), this.database)
            }
            else if  (clazz.endsWith('.go')) {
              txt += CodeUtil.parseGoEntity(docObj, clazz.substring(0, clazz.length - 3), this.database)
            }
            else if  (clazz.endsWith('.cpp')) {
              txt += CodeUtil.parseCppStruct(docObj, clazz.substring(0, clazz.length - 4), this.database)
            }
            else if  (clazz.endsWith('.js')) {
              txt += CodeUtil.parseJavaScriptEntity(docObj, clazz.substring(0, clazz.length - 3), this.database)
            }
            else if  (clazz.endsWith('.ts')) {
              txt += CodeUtil.parseTypeScriptEntity(docObj, clazz.substring(0, clazz.length - 3), this.database)
            }
            else if (clazz.endsWith('.py')) {
              txt += CodeUtil.parsePythonEntity(docObj, clazz.substring(0, clazz.length - 3), this.database)
            }
            else {
              alert('请正确输入对应语言的类名后缀！')
            }

            if (StringUtil.isEmpty(txt, true)) {
              alert('找不到 ' + clazz + ' 对应的表！请检查数据库中是否存在！\n如果不存在，请重新输入存在的表；\n如果存在，请刷新网页后重试。')
              return
            }
            saveTextAs(txt, clazz)
          }
          else {
            var res = JSON.parse(this.jsoncon)
            res = this.removeDebugInfo(res)

            var s = ''
            switch (this.language) {
              case CodeUtil.LANGUAGE_KOTLIN:
                s += '(Kotlin):\n\n' + CodeUtil.parseKotlinResponse('', res, 0, false, ! isSingle)
                break;
              case CodeUtil.LANGUAGE_JAVA:
                s += '(Java):\n\n' + CodeUtil.parseJavaResponse('', res, 0, false, ! isSingle)
                break;
              case CodeUtil.LANGUAGE_C_SHARP:
                s += '(C#):\n\n' + CodeUtil.parseCSharpResponse('', res, 0)
                break;

              case CodeUtil.LANGUAGE_SWIFT:
                s += '(Swift):\n\n' + CodeUtil.parseSwiftResponse('', res, 0, isSingle)
                break;
              case CodeUtil.LANGUAGE_OBJECTIVE_C:
                s += '(Objective-C):\n\n' + CodeUtil.parseObjectiveCResponse('', res, 0)
                break;

              case CodeUtil.LANGUAGE_GO:
                s += '(Go):\n\n' + CodeUtil.parseGoResponse('', res, 0)
                break;
              case CodeUtil.LANGUAGE_C_PLUS_PLUS:
                s += '(C++):\n\n' + CodeUtil.parseCppResponse('', res, 0, isSingle)
                break;

              case CodeUtil.LANGUAGE_TYPE_SCRIPT:
                s += '(TypeScript):\n\n' + CodeUtil.parseTypeScriptResponse('', res, 0, isSingle)
                break;
              case CodeUtil.LANGUAGE_JAVA_SCRIPT:
                s += '(JavaScript):\n\n' + CodeUtil.parseJavaScriptResponse('', res, 0, isSingle)
                break;

              case CodeUtil.LANGUAGE_PHP:
                s += '(PHP):\n\n' + CodeUtil.parsePHPResponse('', res, 0, isSingle)
                break;
              case CodeUtil.LANGUAGE_PYTHON:
                var isML = this.isMLEnabled
                var tr = (this.currentRemoteItem || {}).TestRecord || {}
                var stddObj = isML ? JSONResponse.updateFullStandard(parseJSON(tr.standard), res, isML) : null
                var resObj = isML ? stddObj : (res || parseJSON(tr.response))
                s += '(Python):\n\n' + CodeUtil.parsePythonResponse('', resObj, 0, ! isSingle, isML)
                break;
              default:
                s += ':\n没有生成代码，可能生成代码(封装,解析)的语言配置错误。 \n';
                break;
            }

            saveTextAs('# ' + this.exTxt.name + '\n主页: https://github.com/Tencent/APIJSON'
              + '\n\n\nURL: ' + StringUtil.get(vUrl.value)
              + '\n\n\nHeader:\n' + StringUtil.get(vHeader.value)
              + '\n\n\nRequest:\n' + StringUtil.get(vInput.value)
              + '\n\n\nResponse:\n' + StringUtil.get(this.jsoncon)
              + '\n\n\n## 解析 Response 的代码' + s
              , this.exTxt.name + '.txt')
          }
        }
        else { //上传到远程服务器
          var id = this.User == null ? null : this.User.id
          if (id == null || id <= 0) {
            alert('请先登录！')
            return
          }

          const isExportRandom = this.isExportRandom
          const isExportScript = this.isExportScript

          const currentAccountId = this.getCurrentAccountId()
          const doc = (this.currentRemoteItem || {}).Method || {}
          const tr = (this.currentRemoteItem || {}).TestRecord || {}
          const did = isExportRandom && btnIndex == 1 ? null : doc.id

          if (isExportScript) {
            const extName = this.exTxt.name;
            const scriptType = this.scriptType
            const script = ((this.scripts[scriptType] || {})[this.getCurrentScriptBelongId()] || {})[this.isPreScript ? 'pre' : 'post'] || {};
            const sid = script.id
            const url = sid == null ? '/post' : '/put'
            const req = {
              format: false,
              'Script': Object.assign({
                'id': sid == null ? undefined : sid,
                'simple': 1,
                'ahead': this.isPreScript ? 1 : 0,
                'documentId': did == null || scriptType != 'case' ? 0 : did,
                'testAccountId': scriptType != 'account' ? 0 : currentAccountId,
                'name': extName,
                'script': vScript.value
              }, script),
              'tag': 'Script'
            }

            this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,url, req, {}, function (url, res, err) {
              App.onResponse(url, res, err)

              var rpObj = res.data || {}
              var isPut = url.indexOf('/put') >= 0
              var ok = JSONResponse.isSuccess(rpObj)
              alert((isPut ? '修改' : '上传') + (ok ? '成功' : '失败！\n' + StringUtil.get(err != null ? err.message : rpObj.msg)))

              if (ok && ! isPut) {
                script.id = (rpObj.Script || {}).id
              }
            })

            return
          }

          const isEditResponse = this.isEditResponse
          const isReleaseRESTful = isExportRandom && btnIndex == 1 && ! isEditResponse

          const method = App.getMethod();
          const methodInfo = isReleaseRESTful ? (JSONObject.parseUri(method, true) || {}) : {};
          if (isReleaseRESTful) {
            var isRestful = methodInfo.isRestful;
            var tag = methodInfo.tag;
            var table = methodInfo.table;

            if (isRestful) {
              alert('请求 URL 格式不是 APIJSON 万能通用接口！必须为 /get/user 这种 /{method}/{tag} 格式！其中 method 只能为 [' + APIJSON_METHODS.join() + '] 中的一个，tag 不能为 Table, Table[] 这种与 APIJSON 简单接口冲突的格式！ ')
              return
            }
            if (StringUtil.isEmpty(tag, true)) {
              alert('请求 URL 缺少 tag！必须为 /get/user 这种 /{method}/{tag} 格式！其中 method 只能为 [' + APIJSON_METHODS.join() + '] 中的一个，tag 不能为 Table, Table[] 这种与 APIJSON 简单接口冲突的格式！ ')
              return
            }
            if (JSONObject.isTableKey(table)) {
              alert('请求 URL 中的字符 ' + table + ' 与 APIJSON 简单接口冲突！必须为 /get/user 这种 /{method}/{tag} 格式！其中 method 只能为 [' + APIJSON_METHODS.join() + '] 中的一个，tag 不能为 Table, Table[] 这种与 APIJSON 简单接口冲突的格式！ ')
              return
            }
          }

          if ((isExportRandom != true || btnIndex == 1) && StringUtil.isEmpty(this.exTxt.name, true)) {
            alert('请输入接口名！')
            return
          }

          if (isExportRandom && btnIndex <= 0 && did == null) {
            alert('请先上传测试用例！')
            return
          }

          this.isTestCaseShow = false

          const currentResponse = this.view != 'code' || StringUtil.isEmpty(this.jsoncon, true) ? {} : this.removeDebugInfo(JSON.parse(this.jsoncon));

          const after = isSingle ? this.switchQuote(inputted) : inputted;  // this.toDoubleJSON(inputted);
          const inputObj = this.getRequest(after, {});

          const rawInputStr = JSON.stringify(inputObj)

          var commentObj = null;
          if (isExportRandom != true) {
            var m = this.getMethod();
            var commentStddObj = null
            try {
              commentStddObj = JSON.parse(isEditResponse ? tr.standard : doc.standard);
            }
            catch(e) {
              log(e)
            }
            var code_ = inputObj.code
            inputObj.code = null // delete inputObj.code

            commentObj = JSONResponse.updateStandard(commentStddObj, inputObj, ['@time']);
            CodeUtil.parseComment(after, docObj == null ? null : docObj['[]'], m, this.database, this.language, isEditResponse != true, commentObj, true);

            inputObj.code = code_
          }


          var rawRspStr = JSON.stringify(currentResponse || {})
          const code = currentResponse.code;
          const thrw = currentResponse.throw;
          delete currentResponse.code; // currentResponse.code = null; //code必须一致
          delete currentResponse.throw; // currentResponse.throw = null; // throw必须一致
          
          const isML = this.isMLEnabled;

          var rsp = JSON.parse(JSON.stringify(currentResponse || {}))
          rsp = JSONResponse.array2object(rsp, 'methodArgs', ['methodArgs'], true)
          rsp = JSONResponse.array2object(rsp, 'return', ['return'], true)
          rsp = JSONResponse.array2object(rsp, 'type', ['type'], true)

          const stddObj = isML ? JSONResponse.updateStandard({}, rsp, ['@time']) : {};
          stddObj.status = (this.currentHttpResponse || {}).status || 200;
          stddObj.code = code;
          stddObj.throw = thrw;
          currentResponse.code = code;
          currentResponse.throw = thrw;

          var config = vRandom.value;
          const mapReq = {};
          const mustKeys = [];
          const typeObj = {};
          const refuseKeys = [];

          if (isReleaseRESTful) {
            var mapReq2 = {}

            var cfgLines = StringUtil.split(config, '\n', true);
            var newCfg = '';
            if (cfgLines != null) {
              for (var i = 0; i < cfgLines.length; i++) {
                var cfgLine = cfgLines[i];
                var ind = cfgLine == null ? -1 : cfgLine.indexOf(': ');
                if (ind <= 0) {
                  continue;
                }

                var cInd = cfgLine.indexOf('//');
                if (cInd >= 0 && cInd <= ind) {
                  continue;
                }

                var k = cfgLine.substring(0, ind).replaceAll('/', '.'); // .trim();
                var ks = StringUtil.split(k, '.')
                var p = inputObj;
                for (var j = 0; j < ks.length - 1; j ++) {
                  if (p == null) {
                    break;
                  }

                  var jk = ks[j];
                  p = jk == null ? null : p[jk];
                }

                var v = p == null ? null : p[ks[ks.length - 1]];
                mapReq[k] = v;
                mapReq2[k] = v;

                // 智能判断 count, @key 等
                if (k.startsWith('@') || k.endsWith('[].count') || k.endsWith('[].query') || ['format', 'version'].indexOf(k) >= 0) {
                  refuseKeys.push('!' + k);
                }
                else {
                  mustKeys.push(k);
                }

                var t = JSONResponse.getType(v);
                typeObj[k] = t == 'integer' ? 'NUMBER' : (t == 'number' ? 'DECIMAL' : t.toUpperCase());

                newCfg += (i <= 0 ? '' : '\n') + k + ': ' + cfgLine.substring(ind+2).trim();
              }

              refuseKeys.push('!');
              config = newCfg;
            }

            commentObj = JSONResponse.updateStandard({}, mapReq2, ['@time']);
          }


          var callback = function (randomName, constConfig, constJson) {
            // 用现成的测试过的更好，Response 与 Request 严格对应
            // var mapReq = {};
            // if (isExportRandom && btnIndex == 1) {
            //
            //   var mapReq2 = {}
            //   var cfgLines = StringUtil.split(constConfig, '\n', true);
            //   if (cfgLines != null) {
            //     for (var i = 0; i < cfgLines.length; i++) {
            //       var cfgLine = cfgLines[i];
            //       var ind = cfgLine == null ? -1 : cfgLine.indexOf(': ');
            //       if (ind <= 0) {
            //         continue;
            //       }
            //
            //       var k = cfgLine.substring(0, ind).replaceAll('/', '.'); // .trim();
            //       var v = cfgLine.substring(ind + 1).trim();
            //       try {
            //         v = JSON.parse(v);
            //       }
            //       catch (e) {
            //         log(e)
            //       }
            //
            //       mapReq[k] = v
            //       mapReq2[k] = v
            //     }
            //   }
            //
            //   commentObj = JSONResponse.updateStandard({}, mapReq2, ['@time']);
            // }

            var returnType = currentResponse == null ? null : currentResponse.type
            if (returnType instanceof Array) {
              if (returnType.length <= 0) {
                returnType = null
              } else if (returnType.length == 1) {
                returnType = returnType[0]
              } else {
                returnType = returnType.join() // "(" + returnType.join() + ")"
              }
            }

            const extName = App.exTxt.name;
            const baseUrl = App.getBaseUrl();
            const method = App.getMethod();
            const url = App.server + (isExportRandom || isEditResponse || did == null ? '/post' : '/put')
            const req = isExportRandom && btnIndex <= 0 ? {
              format: false,
              'Random': {
                toId: 0,
                documentId: did,
                count: App.requestCount,
                name: App.exTxt.name,
                config: config
              },
              'TestRecord': {
                'response': rawRspStr,
                'standard': isML ? JSON.stringify(stddObj) : null
              },
              'tag': 'Random'
            } : {
              format: false,
              'Method': isEditResponse ? null : {
                'id': did == null ? undefined : did,
//                'testAccountId': currentAccountId,
                'operation': CodeUtil.getOperation(method),
                'language': StringUtil.isEmpty(currentResponse.language, true) ? this.language : currentResponse.language,
                'method': method,
                'detail': App.exTxt.name,
                'type': returnType,
                'genericType': returnType,
                'class': App.getClass(),
                'package': App.getPackage(),
                'methodArgs': JSON.stringify(currentResponse.methodArgs),
                'genericMethodArgs': JSON.stringify(App.getRequest(vInput.value, {}).methodArgs),
                'request': App.toDoubleJSON(inputted)
              },
              'TestRecord': isEditResponse != true && did != null ? null : {
                'documentId': isEditResponse ? did : undefined,
                'randomId': 0,
                'host': App.getBaseUrl(),
//                'testAccountId': currentAccountId,
                'response': isEditResponse ? rawInputStr : rawRspStr,
                'standard': isML || isEditResponse ? JSON.stringify(isEditResponse ? commentObj : stddObj) : undefined
                // 没必要，直接都在请求中说明，查看也方便 'detail': (isEditResponse ? App.getExtraComment() : null) || ((App.currentRemoteItem || {}).TestRecord || {}).detail,
              },
              'tag': isEditResponse ? 'TestRecord' : 'Method'
            }

            App.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,url, req, {}, function (url, res, err) {
              App.onResponse(url, res, err)

              var rpObj = res.data || {}

              if (isExportRandom && btnIndex <= 0) {
                if (JSONResponse.isSuccess(rpObj)) {
                  App.randoms = []
                  App.showRandomList(true, (App.currentRemoteItem || {}).Method)
                }
              }
              else {
                var isPut = url.indexOf('/put') >= 0

                if (JSONResponse.isSuccess(rpObj) != true) {
                  if (isPut) {  // 修改失败就转为新增
                    App.currentRemoteItem = null;
                    alert('修改失败，请重试(自动转为新增)！' + StringUtil.trim(rpObj.msg))
                  }
                }
                else {
                  App.remotes = []
                  App.showTestCase(true, false)

                  if (isPut) {  // 修改失败就转为新增
                    alert('修改成功')
                    return
                  }

                  if (isReleaseRESTful) {
                    var structure = {"MUST": mustKeys.join(), "TYPE": typeObj, "REFUSE": refuseKeys.join()};

                    var reqObj = {
                      format: false,
                      Request: {
                        method: StringUtil.toUpperCase(methodInfo.method),
                        tag: methodInfo.tag,
                        structure: JSON.stringify(structure, null, '    '),
                        detail: extName
                      },
                      tag: 'Request'
                    };

                    App.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,baseUrl + '/post', reqObj, {}, function (url, res, err) {
                      if (res.data != null && res.data.Request != null && JSONResponse.isSuccess(res.data.Request)) {
                        alert('已自动生成并上传 Request 表校验规则配置:\n' + JSON.stringify(reqObj.Request, null, '  '))
                      }
                      else {
                        var reqStr = JSON.stringify(reqObj, null, '  ');
                        console.log('已自动生成，但上传以下 Request 表校验规则配置失败，可能需要手动加表记录:\nPOST ' + baseUrl + '/post' + '\n' + reqStr)
                        alert('已自动生成，但上传以下 Request 表校验规则配置失败，可能需要手动加表记录，如未自动复制可在控制台复制:\n' + reqStr)
                        navigator.clipboard.writeText(reqStr);
                      }
                      App.onResponse(url, res, err)
                    })
                  }

                  //自动生成随机配置（遍历 JSON，对所有可变值生成配置，排除 @key, key@, key() 等固定值）

                  const isGenerate = StringUtil.isEmpty(config, true);
                  var req = isGenerate != true ? null : (isReleaseRESTful ? mapReq : App.getRequest(vInput.value, {}))
                  App.newAndUploadRandomConfig(baseUrl, req, (rpObj.Method || {}).id, config, App.requestCount, function (url, res, err) {
                    if (res.data != null && res.data.Random != null && JSONResponse.isSuccess(res.data.Random)) {
                      alert('已' + (isGenerate ? '自动生成并' : '') + '上传随机配置:\n' + config)
                      App.isRandomListShow = true
                    }
                    else {
                      alert((isGenerate ? '已自动生成，但' : '') + '上传以下随机配置失败:\n' + config)
                      vRandom.value = config
                    }
                    App.onResponse(url, res, err)
                  })
                }
              }
            })
          };

          if (btnIndex == 1) {
            // this.parseRandom(inputObj, config, null, true, true, false, callback)
            callback(null, null, inputObj)
          }
          else {
            callback(null, null, inputObj)
          }

        }
      },
      newAndUploadRandomConfig: function(baseUrl, req, documentId, config, count, callback, isReleaseRESTful) {
                  if (documentId == null) {
                     return
                  }
                  const isGenerate = StringUtil.isEmpty(config, true);
                  var configs = isGenerate ? [] : [config]
                  if (isGenerate) {
                    var config = StringUtil.trim(this.newRandomConfig(null, '', req, false))
                    if (StringUtil.isEmpty(config, true)) {
                      return;
                    }
                    configs.push(config)
                    config2 = StringUtil.trim(this.newRandomConfig(null, '', req, true))
                    if (StringUtil.isNotEmpty(config2, true)) {
                      configs.push(config2)
                    }
                  }
                  for (var i = 0; i < configs.length; i ++) {
                      const config = configs[i]
                      this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, (isReleaseRESTful ? baseUrl : this.server) + '/post', {
                        format: false,
                        Random: {
                          documentId: documentId,
                          count: count,
                          name: '默认配置' + (isGenerate ? '(上传测试用例时自动生成)' : ''),
                          config: config
                        },
                        TestRecord: {
                          host: baseUrl,
                          response: ''
                        },
                        tag: 'Random'
                      }, {}, callback)
        }
      },

      onClickAddRandom: function () {
         if (this.isRandomListShow || this.isRandomSubListShow) {
            this.randomTestTitle = null;
            this.isRandomListShow = false;
            this.isRandomSubListShow = false;
         } else if (StringUtil.isEmpty(vRandom.value, true)) {
            var req = this.getRequest(vInput.value, {})
            vRandom.value = StringUtil.trim(this.newRandomConfig(null, '', req, Math.random() >= 0.5, Math.random() >= 0.3, Math.random() >= 0.8))
         } else {
            this.showExport(true, true, true)
         }
      },
      newRandomConfig: function (path, key, value, isRand, isBad, noDeep, isConst) {
        if (key == null) {
          return ''
        }
        if (path == '' && (key == 'tag' || key == 'version' || key == 'format')) {
          return ''
        }

        var config = ''
        var childPath = path == null || path == '' ? key : path + '/' + key
        var prefix = childPath + ': '

        var isPositive = Math.random() >= 0.3
        var offset = (isPositive ? '+' : '') + (isPositive ? 1 : -1)*randomPrimeInt()
        if (value instanceof Array) {
          if (isConst) {
               config += prefix + '[]'
               for (var i = 0; i < value.length; i ++) {
                  var cfg = this.newRandomConfig(childPath, '' + i, value[i], isRand, isBad, noDeep, isConst)
                  config += '\n' + (StringUtil.isEmpty(cfg, true) ? 'null' : cfg.trim())
               }
               return config
          }
          if (isBad && noDeep && StringUtil.isNotEmpty(childPath, true)) {
            return prefix + (isRand ? 'RANDOM_BAD_ARR' : 'ORDER_BAD_ARR' + offset) + '()'
          }
          if (Math.random() >= 7) {
              var val
              if (value.length <= 0) {
                val = ''
              }
              else {
                if (value.length <= 1) {
                  val = ', ' + JSON.stringify(value)
                }
                else if (value.length <= 2) {
                  val = ', ' + JSON.stringify([value[0]]) + ', ' + JSON.stringify([value[1]]) + ', ' + JSON.stringify(value)
                }
                else {
                  val = ', ' + JSON.stringify([value[0]]) + ', ' + JSON.stringify([value[value.length - 1]]) + ', ' + JSON.stringify([value[Math.floor(value.length / 2)]]) + ', ' + JSON.stringify(value)
                }
              }

              config += prefix + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null, false, true, -1025, 0, [], {}, 1, 3.14, "null", "undefined", Number.MAX_SAFE_INTEGER, "-1025", "0", "" + Number.MAX_SAFE_INTEGER, "[", "]", "{", "}", "1", "3.14", "true", "false"' + val + ')'
          }
          else {
              config += prefix + '[]'
              var l = randomInt(0, 13)
              for (var i = 0; i < l; i ++) {
                 var cfg = this.newRandomConfig(childPath, '' + i, value[i], isRand, isBad, noDeep, isConst)
                 if (StringUtil.isEmpty(cfg, true)) {
                   break
                 }
                 config += '\n' + cfg.trim()
              }
          }
          return config
        }
        else if (value instanceof Object) {
          if (isBad && noDeep && StringUtil.isNotEmpty(childPath, true)) {
            return prefix + (isRand ? 'RANDOM_BAD_OBJ' : 'ORDER_BAD_OBJ' + offset) + '()'
          }
          for(var k in value) {
            var v = value[k]

            var isAPIJSONArray = isConst == false && v instanceof Object && v instanceof Array == false
              && k.startsWith('@') == false && (k.endsWith('[]') || k.endsWith('@'))
            if (isAPIJSONArray) {
              if (k.endsWith('@')) {
                delete v.from
                delete v.range
              }

              prefix = '\n' + (childPath == null || childPath == '' ? '' : childPath + '/') + k + '/'
              if (v.hasOwnProperty('page')) {
                config += prefix + 'page: ' + (isRand ? 'RANDOM_INT' : 'ORDER_INT') + '(0, 10)'
                delete v.page
              }
              if (v.hasOwnProperty('count')) {
                config += prefix + 'count: ' + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null, 0, 1, 5, 10, 20'
                  + ([0, 1, 5, 10, 20].indexOf(v.count) >= 0 ? ')' : ', ' + v.count + ')')
                delete v.count
              }
              if (v.hasOwnProperty('query')) {
                config += prefix + 'query: ' + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null, 0, 1, 2)'
                delete v.query
              }
            }

            var cfg = this.newRandomConfig(childPath, k, v, isRand, isBad, noDeep, isConst)
            if (StringUtil.isNotEmpty(cfg, true)) {
              config += '\n' + cfg
            }
          }
          return config
        }
        else {
          if (isConst) {
            return prefix + JSON.stringify(value) // 会自动给 String 加 ""
          }
          //自定义关键词
          if (key.startsWith('@')) {
            return config
          }

          if (typeof value == 'boolean') {
            if (isBad) {
              return prefix + (isRand ? 'RANDOM_BAD_BOOL' : 'ORDER_BAD_BOOL' + offset) + '()'
            }
            config += prefix + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null, false, true)'
          }
          else if (typeof value == 'number') {
            if (isBad) {
              return prefix + (isRand ? 'RANDOM_BAD_NUM' : 'ORDER_BAD_NUM' + offset) + '()'
            }
            var isId = key == 'id' || key.endsWith('Id') || key.endsWith('_id') || key.endsWith('_ID')
            if (isId) {
              config += prefix + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null, ' + value + ')'
              if (value >= 1000000000) { //PHP 等语言默认精确到秒 1000000000000) {
                config += '\n// 可替代上面的 ' + prefix + 'RANDOM_INT(' + Math.round(0.9 * value) + ', ' + Math.round(1.1 * value) + ')'
              }
              else {
                config += '\n// 可替代上面的 ' + prefix + 'RANDOM_INT(1, ' + (10 * value) + ')'
              }
            }
            else {
              var valStr = String(value)
              var dotIndex = valStr.indexOf('.')
              var hasDot = dotIndex >= 0
              var keep = dotIndex < 0 ? 2 : valStr.length - dotIndex - 1

              if (value < 0) {
                config += prefix + (hasDot ? 'RANDOM_NUM' : 'RANDOM_INT') + '(' + (100 * value) + (hasDot ? ', 0, ' + keep + ')' : ', 0)')
              }
              else if (value > 0 && value < 1) {  // 0-1 比例
                config += prefix + 'RANDOM_NUM(0, 1, ' + keep + ')'
              }
              else if ((hasDot && value > 0 && value <= 100) || (hasDot != true && value > 5 && value <= 100)) {  // 10% 百分比
                config += prefix + (hasDot ? 'RANDOM_NUM(0, 100, ' + keep + ')' : 'RANDOM_INT(0, 100)')
              }
              else {
                config += prefix + (dotIndex < 0 && value <= 10
                      ? (isRand ? 'RANDOM_INT' : 'ORDER_INT') + '(0, 10)'
                      : ((hasDot ? 'RANDOM_NUM' : 'RANDOM_INT') + '(0, ' + 100 * value + (hasDot ? ', ' + keep + ')' : ')'))
                  )
                var hasDot = String(value).indexOf('.') >= 0

                if (value < 0) {
                  config += '\n// 可替代上面的 ' + prefix + (hasDot ? 'RANDOM_NUM' : 'RANDOM_INT') + '(' + (100 * value) + ', 0)'
                }
                else if (value > 0 && value < 1) { // 0-1 比例
                  config += '\n// 可替代上面的 ' + prefix + 'RANDOM_NUM(0, 1)'
                }
                else if (value >= 0 && value <= 100) { // 10% 百分比
                  config += '\n// 可替代上面的 ' + prefix + 'RANDOM_INT(0, 100)'
                }
                else {
                  config += '\n// 可替代上面的 ' + prefix + (hasDot != true && value < 10 ? (isRand ? 'RANDOM_INT' : 'ORDER_INT') + '(0, 9)' : ((hasDot ? 'RANDOM_NUM' : 'RANDOM_INT') + '(0, ' + 100 * value + ')'))
                }
              }
            }
          }
          else if (typeof value == 'string') {
            if (isBad) {
              return prefix + (isRand ? 'RANDOM_BAD_STR' : 'ORDER_BAD_STR' + offset) + '()'
            }
            //引用赋值 || 远程函数 || 匹配条件范围
            if (key.endsWith('@') || key.endsWith('()') || key.endsWith('{}')) {
              return config
            }

            config += prefix + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null, ""' + (value == '' ? ')' : ', "' + value + '")')
          }
          else {
            if (isBad) {
              return prefix + (isRand ? 'RANDOM_BAD' : 'ORDER_BAD' + offset) + '()'
            }

            config += prefix + (isRand ? 'RANDOM_IN' : 'ORDER_IN') + '(undefined, null' + (value == null ? ')' : ', ' + JSON.stringify(value) + ')')
          }

        }

        return config
      },



      // 保存配置
      saveConfig: function () {
        this.isConfigShow = this.exTxt.index == 16

        switch (this.exTxt.index) {
          case 0:
            this.database = CodeUtil.database = this.exTxt.name
            this.saveCache('', 'database', this.database)

            doc = null
            var item = this.accounts[this.currentAccountIndex]
            item.isLoggedIn = false
            this.onClickAccount(this.currentAccountIndex, item)
            break
          case 1:
            this.schema = CodeUtil.schema = this.exTxt.name
            this.saveCache('', 'schema', this.schema)

            doc = null
            var item = this.accounts[this.currentAccountIndex]
            item.isLoggedIn = false
            this.onClickAccount(this.currentAccountIndex, item)
            break
          case 2:
            this.language = CodeUtil.language = this.exTxt.name
            this.saveCache('', 'language', this.language)

            doc = null
            this.onChange(false)
            break
          case 6:
            this.server = this.exTxt.name
            this.saveCache('', 'server', this.server)
            this.logout(true)
            break
          case 7:
            this.types = StringUtil.split(this.exTxt.name)
            this.saveCache('', 'types', this.types)
            break
          case 15:
            this.otherEnv = StringUtil.get(this.exTxt.name)
            this.saveCache('', 'otherEnv', this.otherEnv)
            break
          case 8:
            this.project = this.exTxt.name
            this.saveCache('', 'project', this.project)

            var c = this.currentAccountIndex == null ? -1 : this.currentAccountIndex
            var item = this.accounts == null ? null : this.accounts[c]
            if (item != null) {
              item.isLoggedIn = ! item.isLoggedIn
              this.onClickAccount(c, item)
            }
            break
          case 16:
              if (this.isSyncing) {
                alert('正在同步，请等待完成')
                return
              }

              this.saveCache(this.project, 'request4MethodList', vInput.value)
              this.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.project + this.exTxt.name, this.getRequest(vInput.value), this.getHeader(vHeader.value), function (url, res, err) {
                App.isSyncing = true
                App.onResponse(url, res, err)

                var data = res.data || {}
                var code = data.code
                if (code != CODE_SUCCESS) {
                  alert('查询 Project 文档报错！' + data.msg)
                  return
                }

                var packageList = data.packageList
                if (packageList == null || packageList.length <= 0) {
                  alert('没有查到 Project 文档！请开启跨域代理，并检查 URL 是否正确！')
                  return
                }

                App.uploadTotal = 0
                App.uploadDoneCount = 0
                App.uploadFailCount = 0

                for (var j in packageList) {
                  var packageItem = packageList[j]
                  var classList = (packageItem || {}).classList
                  if (classList == null || classList.length <= 0) {
                      alert('没有查到 Project 文档！请开启跨域代理，并检查 URL 是否正确！')
                      return
                  }

                  for (var i in classList) {
                    try {
                      var classItem = classList[i]
                      if (StringUtil.isEmpty(classItem['package'], true)) {
                    	  classItem['package'] = packageItem['package']
                      }
                      App.sync2DB(classItem, data.language)
                    } catch (e) {
                      App.uploadFailCount++
                      App.exTxt.button = 'All:' + App.uploadTotal + '\nDone:' + App.uploadDoneCount + '\nFail:' + App.uploadFailCount
                    }
                  }
                }

              })
            break
        }
      },

      /**同步到数据库
       * @param classItem
       * @param callback
       */
      sync2DB: function(classItem, language) {
        if (classItem == null) {
          this.log('postApi', 'classItem == null  >> return')
          return
        }

        var methodList = classItem.methodList || []
        this.uploadTotal += methodList.length
        this.exTxt.button = 'All:' + this.uploadTotal + '\nDone:' + this.uploadDoneCount + '\nFail:' + this.uploadFailCount

        var currentAccount = this.accounts[this.currentAccountIndex]
        var classArgs = this.getArgs4Sync(classItem.parameterTypeList)

        for (var k = 0; k < methodList.length; k++) {
          var methodItem = methodList[k]
          if (methodItem == null || methodItem.name == null) {
            this.uploadFailCount ++
            this.exTxt.button = 'All:' + this.uploadTotal + '\nDone:' + this.uploadDoneCount + '\nFail:' + this.uploadFailCount
            continue
          }

          var currentAccountId = this.getCurrentAccountId()
          var returnType = methodItem.returnType == null ? null : methodItem.returnType
          if (returnType instanceof Array) {
            if (returnType.length <= 0) {
              returnType = null
            } else if (returnType.length == 1) {
              returnType = returnType[0]
            } else {
              returnType = returnType.join() // "(" + returnType.join() + ")"
            }
          }

          const baseUrl = this.getBaseUrl()
          const reqObj = {
            format: false,
            'Method': {
              'userId': this.User.id,
              'language': StringUtil.isEmpty(language, true) ? this.language : language,
              'package': classItem.package == null ? null : classItem.package,  // .replace(/[.]/g, '/'),
              'class': classItem.class,
              'method': methodItem.name,
              'this': null,
              'constructor': null,
              'classArgs': classArgs,
              'genericClassArgs': this.getArgs4Sync(classItem.genericParameterTypeList),
              'methodArgs': this.getArgs4Sync(methodItem.parameterTypeList, methodItem.parameterDefaultValueList),
              'genericMethodArgs': this.getArgs4Sync(methodItem.genericParameterTypeList, methodItem.parameterDefaultValueList),
              'type': returnType,  // .replace(/[.]/g, '/'),
              'genericType': methodItem.genericReturnType == null ? null : methodItem.genericReturnType,  // .replace(/[.]/g, '/'),
              'static': methodItem.static ? 1 : 0,
              'timeout': methodItem.timeout,
              'ui': methodItem.ui ? 1 : 0,
              'exceptions': methodItem.exceptionTypeList == null ? null : methodItem.exceptionTypeList.join(),  // .replace(/[.]/g, '/').join(),
              'genericExceptions': methodItem.genericExceptionTypeList == null ? null : methodItem.genericExceptionTypeList.join(), //  .replace(/[.]/g, '/').join(),
              'detail': methodItem.name
            },
            'TestRecord': {
              'randomId': 0,
              'host': baseUrl,
              'testAccountId': currentAccountId,
              'response': ""
            },
            'tag': 'Method'
          }

          this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.server + '/post', reqObj, {}, function (url, res, err) {
            // 太卡 App.onResponse(url, res, err)
            var rpObj = res.data || {}
            var tblObj = rpObj.Method
            if (tblObj.id != null && tblObj.id > 0) {
                App.uploadDoneCount ++
            } else {
              App.uploadFailCount ++
            }

            App.newAndUploadRandomConfig(baseUrl, reqObj, tblObj.id, null, 5)
            App.exTxt.button = 'All:' + App.uploadTotal + '\nDone:' + App.uploadDoneCount + '\nFail:' + App.uploadFailCount
            if (App.uploadDoneCount + App.uploadFailCount >= App.uploadTotal) {
              alert('导入完成，其中 ' + App.uploadRandomCount + ' 个用例已存在，改为生成和上传了参数注入配置')
              App.isSyncing = false
              App.testCasePage = 0
              App.isRandomShow = true
              App.isRandomListShow = true
              App.showTestCase(false, false)
              App.remotes = []
              var branch = vUrl.value
              vUrl.value = StringUtil.get(App.host) + branch
              App.host = ''

              vUrlComment.value = isSingle || StringUtil.isEmpty(App.urlComment, true) // 导致重复加前缀 App.showUrl(false, branch)
                  ? '' : CodeUtil.getBlank(StringUtil.length(vUrl.value), 1) + ' ' + App.urlComment
              // + ' - ' + (this.requestVersion > 0 ? 'V' + this.requestVersion : 'V*');

              App.showTestCase(true, false)
            }

          })
        }

      },

      getArgs4Sync: function (typeList, valueList) {
        var size = Math.max(typeList == null ? 0 : typeList.length, valueList == null ? 0 : valueList.length)
        if (size <= 0) {
          return null
        }

        var args = []
        for (var l = 0; l < size; l++) {

          var type = typeList == null ? null : typeList[l]  //保持用 . 分割  .replace(/[.]/g, '/')
          var value = valueList == null ? this.mockValue4Type(type) : valueList[l];

          args.push({
            type: type,
            value: value
          })
        }
        return args
      },

      mockValue4Type: function (type) {
        type = StringUtil.trim(type)
        if (type == '') {
          return
        }

        switch (type) {
          case 'Boolean':
          case 'boolean':
          case 'bool':
            return randomInt(0, 1) == 1
          case 'number':
          case 'Number':
          case 'Double':
          case 'Float':
          case 'double':
          case 'float':
          case 'float32':
          case 'float64':
            return randomNum(-100, 200, randomInt(0, 2))
          case 'Long':
          case 'long':
          case 'int64':
          case 'uint64':
            return randomInt(-100, 200)
          case 'Integer':
          case 'integer':
          case 'int':
          case 'int8':
          case 'int16':
          case 'int32':
          case 'uint':
          case 'uint8':
          case 'uint16':
          case 'uint32':
            return randomInt(-10, 20)
          case 'str':
          case 'string':
          case 'String':
          case 'CharSequence':
            return randomStr(0, 5)
        }

        var ct = ''
        if (type.endsWith('[]')) {
          return null //除了 null，其它任何类型的值都不行 argument type mismatch   ct = type.substring(0, type.length - 2)
        }
        else {
          var index = type.indexOf('<')
          if (index >= 0) {
            type = type.substring(0, index).trim();
            ct = type.substring(index + 1, type.lastIndexOf('>')).trim()
          }
        }

        if (type.startsWith('list') || type.startsWith('[]') || type.endsWith('[]') ||type.endsWith('List') || type.endsWith('Array') || type.endsWith('Set') || type.endsWith('Collection')) {
          var size = randomInt(0, 10)
          var arr = []
          for (var i = 0; i < size; i ++) {
            var v = this.mockValue4Type(ct)
            if (v != null) {
              arr.push(v)
            }
          }
          return arr
        }

        if (type.startsWith('map') || type.startsWith('dict') || type.endsWith('Map') || type.endsWith('Table') || type.endsWith('JSONObject')) {
          var size = randomInt(0, 10)

          var index = ct.indexOf(',')
          var lct = index < 0 ? 'String' : ct.substring(0, index).trim()
          var rct = index < 0 ? ct : ct.substring(index + 1).trim()

          var obj = {}
          for (var i = 0; i < size; i ++) {
            obj[this.mockValue4Type(lct), this.mockValue4Type(rct)]
          }
          return obj
        }

        if (type.endsWith('Decimal')) {
          return this.mockValue4Type('Number')
        }

        return null // type == 'Object' || type == 'java.lang.Object' ? null : {}
      },

      // 切换主题
      switchTheme: function (index) {
        this.checkedTheme = index
        localforage.setItem('#theme', index)
      },


      // APIJSON <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      //格式化日期
      formatDate: function (date) {
        if (date == null) {
          date = new Date()
        }
        return date.getFullYear() + '-' + this.fillZero(date.getMonth() + 1) + '-' + this.fillZero(date.getDate())
      },
      //格式化时间
      formatTime: function (date) {
        if (date == null) {
          date = new Date()
        }
        return this.fillZero(date.getHours()) + ':' + this.fillZero(date.getMinutes())
      },
      formatDateTime: function (date) {
        if (date == null) {
          date = new Date()
        }
        return this.formatDate(date) + ' ' + this.formatTime(date)
      },
      //填充0
      fillZero: function (num, n) {
        if (num == null) {
          num = 0
        }
        if (n == null || n <= 0) {
          n = 2
        }
        var len = num.toString().length;
        while(len < n) {
          num = "0" + num;
          len++;
        }
        return num;
      },




      onClickAccount: function (index, item, callback) {
        var accounts = this.accounts
        var num = accounts == null ? 0 : accounts.length
        if (index < 0 || index >= num) {
          item = this.getCurrentAccount()
          if (item != null && item.isLoggedIn) {
            //logout FIXME 没法自定义退出，浏览器默认根据url来管理session的
            this.logout(false, function (url, res, err) {
              App.onResponse(url, res, err)

              item.isLoggedIn = false
              App.saveCache(App.getBaseUrl(), 'currentAccountIndex', App.currentAccountIndex)
              App.saveCache(App.getBaseUrl(), 'accounts', App.accounts)
              App.changeScriptType(App.scriptType)

              if (callback != null) {
                callback(false, index, err)
              }
            });
          } else {
            if (callback != null) {
              callback(false, index)
            }
          }

          this.currentAccountIndex = index
          this.changeScriptType(App.scriptType)
          return
        }

        if (this.currentAccountIndex == index) {
          if (item == null) {
            if (callback != null) {
              callback(false, index)
            }
          }
          else {
            this.setRememberLogin(item.remember)
            this.account = item.phone
            this.password = item.password

            if (item.isLoggedIn) {
              //logout FIXME 没法自定义退出，浏览器默认根据url来管理session的
              this.logout(false, function (url, res, err) {
                App.onResponse(url, res, err)

                item.isLoggedIn = false
                App.saveCache(App.getBaseUrl(), 'currentAccountIndex', App.currentAccountIndex)
                App.saveCache(App.getBaseUrl(), 'accounts', App.accounts)
                App.changeScriptType(App.scriptType)

                if (callback != null) {
                  callback(false, index, err)
                }
              });

              this.currentAccountIndex = -1
              this.changeScriptType(App.scriptType)
            }
            else {
              //login
              this.login(false, function (url, res, err) {
                App.onResponse(url, res, err)

                var data = res.data || {}
                var user = JSONResponse.isSuccess(data) ? data.user : null
                if (user == null) {
                  if (callback != null) {
                    callback(false, index, err)
                  }
                }
                else {
                  var headers = res.headers || {}

                  item.id = user.id
                  item.name = user.name
                  item.remember = data.remember
                  item.isLoggedIn = true
                  item.cookie = res.cookie || headers.cookie || headers.Cookie || headers['set-cookie'] || headers['Set-Cookie']

                  App.accounts[App.currentAccountIndex] = item
                  App.saveCache(App.getBaseUrl(), 'currentAccountIndex', App.currentAccountIndex)
                  App.saveCache(App.getBaseUrl(), 'accounts', App.accounts)
                  App.changeScriptType(App.scriptType)

                  if (callback != null) {
                      callback(true, index, err)
                  }
                }
              });
            }

          }

          return;
        }

        //退出当前账号
        var c = this.currentAccountIndex
        var it = c == null || this.accounts == null ? null : this.accounts[c];
        if (it != null) { //切换 BASE_URL后 it = undefined 导致UI操作无法继续
          it.isLoggedIn = false  //异步导致账号错位 this.onClickAccount(c, this.accounts[c])
        }

        //切换到这个tab
        this.currentAccountIndex = index
        this.changeScriptType(App.scriptType)

        //目前还没做到同一标签页下测试账号切换后，session也跟着切换，所以干脆每次切换tab就重新登录
        if (item != null) {
          item.isLoggedIn = false
          this.onClickAccount(index, item, callback)
        }
        else {
          if (callback != null) {
              callback(false, index)
          }
        }
      },

      removeAccountTab: function () {
        if (this.accounts.length <= 1) {
          alert('至少要 1 个测试账号！')
          return
        }

        this.accounts.splice(this.currentAccountIndex, 1)
        if (this.currentAccountIndex >= this.accounts.length) {
          this.currentAccountIndex = this.accounts.length - 1
        }

        this.saveCache(this.getBaseUrl(), 'currentAccountIndex', this.currentAccountIndex)
        this.saveCache(this.getBaseUrl(), 'accounts', this.accounts)
      },
      addAccountTab: function () {
        this.showLogin(true, false)
      },

      showCompare4TestCaseList: function (show) {
        var testCases = show ? App.testCases : null
        var allCount = testCases == null ? 0 : testCases.length
        App.allCount = allCount
        if (allCount > 0) {
          var accountIndex = (this.accounts[this.currentAccountIndex] || {}).isLoggedIn ? this.currentAccountIndex : -1
          this.currentAccountIndex = accountIndex  //解决 onTestResponse 用 -1 存进去， handleTest 用 currentAccountIndex 取出来为空

          var reportId = this.reportId
          if (reportId == null || Number.isNaN(reportId)) {
            reportId = null
          }
          var tests = this.tests[String(accountIndex)]
          if ((reportId != null && reportId >= 0) || (tests != null && JSONObject.isEmpty(tests) != true)) {
            for (var i = 0; i < allCount; i++) {
              var item = testCases[i]
              var d = item == null ? null : item.Method
              if (d == null || d.id == null) {
                continue
              }

              if (reportId != null && reportId >= 0) {
                var tr = item.TestRecord || {}
                var rsp = parseJSON(tr.response)
                tests[d.id] = [rsp]
                var cmp = parseJSON(tr.compare)
                if (cmp == null || Object.keys(cmp).length <= 0) {
                  cmp = JSONResponse.compareWithBefore(null, null)
                }
                this.onTestResponse(null, allCount, testCases, i, item, d, item.Random, tr, rsp, cmp, false, accountIndex, true);
                continue
              }
              this.compareResponse(null, allCount, testCases, i, item, (tests[d.id] || {})[0], false, accountIndex, true)
            }
          }
        }
      },


      onClickPath: function (index, path) {
        var casePaths = this.casePaths;
        this.casePaths = casePaths.slice(0, index)
        this.selectCaseGroup(0, path)
      },
      isCaseGroupShow: function () {
        return this.caseShowType != 1 && (this.caseGroups.length > 0 || this.casePaths.length <= 0)
      },
      isCaseItemShow: function () {
        return this.caseShowType != 2 || (this.caseGroups.length <= 0 && this.casePaths.length > 0)
      },
      getCaseGroupShowName: function(index, item) {
        if (StringUtil.isNotEmpty(item.groupName, true)) {
          return item.groupName
        }
        if (StringUtil.isEmpty(item.groupUrl, true)) {
          return '-'
        }

        var prev = index <= 0 ? null : (this.casePaths[index-1] || {}).groupUrl
        return StringUtil.isEmpty(prev) ? item.groupUrl : item.groupUrl.substring(prev.length + 1)
      },
      selectCaseGroup: function (index, group) {
        this.isCaseGroupEditable = false

        if (group == null) {
          if (index == null) {
            index = this.casePaths.length - 1
            group = this.casePaths[index]
          } else {
            this.casePaths = []
          }
        } else {
          this.casePaths.push(group)
        }

        var groupUrl = group == null ? '' : (group.groupUrl || '')
        if (group != null && StringUtil.isEmpty(groupUrl)) {
          this.caseGroups = []
          this.remotes = App.testCases = []
          this.showTestCase(true, false, null)
          return
        }

        var page = this.caseGroupPage = this.caseGroupPages[groupUrl] || 0
        var count = this.caseGroupCount = this.caseGroupCounts[groupUrl] || 0
        var search = this.caseGroupSearch = this.caseGroupSearches[groupUrl] || ''

        search = StringUtil.isEmpty(search, true) ? null : '%' + StringUtil.trim(search).replaceAll('_', '\\_').replaceAll('%', '\\%') + '%'
        var req = {
          format: false,
          'Method[]': {
            'count': count || 0,
            'page': page || 0,
            'Method': {
              '@from@': {
                'Method': {
                  '@raw': '@column',
                  '@column': "group:groupName;(CASE WHEN package LIKE '*%' THEN substr(package,2) ELSE package END) `groupUrl`",
                  'userId': this.User.id,
                  'group$': search,
                  'package$': search,
                  '@combine': search == null ? null : 'group$,package$',
                  '@null': 'sqlauto', //'sqlauto{}': '=null',
                  'package|$': StringUtil.isEmpty(groupUrl) ? null : [groupUrl.replaceAll('_', '\\_').replaceAll('%', '\\%') + '.%'],
                  'package{}': 'length(package)>0',
                  // 'group{}': group == null || StringUtil.isNotEmpty(groupUrl) ? null : 'length(group)<=0' // SQL WHERE 条件不用别名
                  // '@having': "length(url)>0" //  StringUtil.isEmpty(groupUrl) ? "length(url)>0" : "(url = '" + groupUrl.replaceAll("'", "\\'") + "')"
                }
              },
              'groupUrl|$': StringUtil.isEmpty(groupUrl) ? null : [groupUrl.replaceAll('_', '\\_').replaceAll('%', '\\%') + '.%'],
              'groupName$': search,
              'groupUrl$': search,
              '@combine': search == null ? null : 'groupName$,groupUrl$',
              '@column': "groupName,groupUrl;any_value(groupName):rawName;length(groupName):groupNameLen;length(groupUrl):groupUrlLen;count(*):count",
              '@group': 'groupName,groupUrl',
              '@order': 'groupNameLen+,groupName-,groupUrlLen+,groupUrl+',
            }
          },
          '@role': IS_NODE ? null : 'LOGIN',
          key: IS_NODE ? this.key : undefined  // 突破常规查询数量限制
        }

        if (IS_BROWSER) {
          this.onChange(false)
        }

        this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, this.server + '/get', req, {}, function (url, res, err) {
          App.onResponse(url, res, err)
          var data = res.data
          if (JSONResponse.isSuccess(data) == false) {
            alert('获取用例分组失败！\n' + (err != null ? err.message : (data || '').msg))
            if (IS_BROWSER) { // 解决一旦错了，就只能清缓存
              App.caseGroupCount = 50
              App.caseGroupPage = 0
              App.caseGroupSearch = ''
              App.caseGroupCounts = {}
              App.caseGroupPages = {}
              App.caseGroupSearches = {}

              App.saveCache(App.server, 'caseGroupCount', App.caseGroupCount)
              App.saveCache(App.server, 'caseGroupPage', App.caseGroupPage)
              App.saveCache(App.server, 'caseGroupSearch', App.caseGroupSearch)
              App.saveCache(App.server, 'caseGroupCounts', App.caseGroupCounts)
              App.saveCache(App.server, 'caseGroupPages', App.caseGroupPages)
              App.saveCache(App.server, 'caseGroupSearches', App.caseGroupSearches)
            }
            return
          }

          App.caseGroups = data['Method[]'] || []
          App.remotes = App.testCases = []
          App.showTestCase(true, false, null)
        })
      },

      switchCaseShowType: function () {
        if (this.isLocalShow) {
          alert('只有远程用例才能切换！')
          return
        }

        this.caseShowType = (this.caseShowType + 1)%3
        if (this.caseShowType != 1 && this.casePaths.length <= 0 && this.caseGroups.length <= 0) {
          this.selectCaseGroup(-1, null)
        }
      },

      onClickPathRoot: function () {
        if (this.casePaths.length <= 0) {
          this.showTestCase(true, ! this.isLocalShow)
        } else {
          this.selectCaseGroup(-1, null)
        }
      },

      //显示远程的测试用例文档
      showTestCase: function (show, isLocal, callback) {
        this.isTestCaseShow = show
        this.isLocalShow = isLocal

        if (IS_BROWSER) {
          vOutput.value = show ? '' : (output || '')
          this.showDoc()
        }

        if (isLocal) {
          this.testCases = this.locals || []
          return
        }

        this.testCases = this.remotes || []
        this.getCurrentSummary().summaryType = 'total' // this.onClickSummary('total', true)

        if (show) {
          var testCases = this.testCases
          var allCount = testCases == null ? 0 : testCases.length
          App.allCount = allCount
          if (allCount > 0) {
            if (! (this.isAllSummaryShow() || this.isCurrentSummaryShow())) {
              this.showCompare4TestCaseList(show)
            }
            return;
          }

          // this.isTestCaseShow = false
          var reportId = this.reportId
          var lastInd = this.casePaths.length - 1
          var group = this.casePaths[lastInd]
          var groupUrl = group == null ? '' : (group.groupUrl || '')

          var page = this.testCasePage = this.testCasePages[groupUrl] || 0
          var count = this.testCaseCount = this.testCaseCounts[groupUrl] || 100
          var search = this.testCaseSearch = this.testCaseSearches[groupUrl] || ''
          
          search = StringUtil.isEmpty(search, true) ? null : StringUtil.trim(search)

          var host = StringUtil.get(this.host);
          var pkg = this.getPackage()

          var packagePrefix = ''
          var classPrefix = ''
          if (host.length > pkg.length) {
            packagePrefix = pkg
            classPrefix = host.substring(pkg.length)
            var index = classPrefix.indexOf('.')
            if (index == 0) {
              classPrefix = classPrefix.substring(1)
              index = classPrefix.indexOf('.')
            }
            if (index >= 0) {
              classPrefix = classPrefix.substring(0, index)
            }
            classPrefix = classPrefix.trim()
          }
          packagePrefix = packagePrefix.trim()

          var langauges = StringUtil.split(this.language, ',', true)
          var langCond = {}
          if (langauges == null || langauges.length <= 0) {
            langauges = undefined
          } else {
            var combineStr = StringUtil.isEmpty(search) ? 'language{}' : '(package*~ | class*~ | method*~ | type*~ | operation*~ | detail*~) & (language{}'
            for (var i = 0; i < langauges.length; i++) {
              langCond['lang' + i + '{}'] = "find_in_set('" + langauges[i] + "',language)"
              combineStr += ' | lang' + i + '{}'
            }
            langCond['@combine'] = combineStr + (StringUtil.isEmpty(search) ? '' : ')')

            langauges.push('')
            langauges.push(null)
          }

          this.coverage = {}
          this.view = 'markdown'

          var req = {
            format: false,
            '[]': {
              'count': count || 50, //200 条测试直接卡死 0,
              'page': page || 0,
              'Method': Object.assign({  // 不管是 item.Method.constructor 还是 item.Method['constructor'] 都取到了 js 语言构造器而不是 JSON 中的 value
                '@column': 'id,userId,language,static,ui,operation,type,genericType,package,class,constructor:cttr,classArgs,genericClassArgs,method,methodArgs,genericMethodArgs,exceptions,genericExceptions,request,demo,detail,date',
                '@order': 'date-',
                'userId{}': [0, this.User.id],
                // 'arguments()': 'getMethodArguments(genericMethodArgs)',
                // 'defination()': 'getMethodDefination(method,arguments,type,exceptions,null)',
                // 'constructorArguments()': 'getMethodArguments(genericClassArgs)',
                'request()': 'getMethodRequest()',
                'language{}': langauges,
                // 'language|{}': "find_in_set('" + langauges[0] + "',language)",
                'package|$': StringUtil.isEmpty(groupUrl) ? null : [groupUrl, groupUrl.replaceAll('_', '\\_').replaceAll('%', '\\%') + '.%'],
                'package$': StringUtil.isEmpty(packagePrefix) ? null : packagePrefix + '%',
                'class$': StringUtil.isEmpty(classPrefix) ? null : classPrefix + '%',
                'package*~': search,
                'class*~': search,
                'method*~': search,
                'type*~': search,
                'operation*~': search,
                'detail*~': search,
                '@combine': StringUtil.isEmpty(search) ? null : 'package*~,class*~,method*~,type*~,operation*~,detail*~'
              }, langCond),
              'TestRecord': {
                'documentId@': '/Method/id',
                'userId': this.User.id,
//                'testAccountId': this.getCurrentAccountId(),
                'randomId': 0,
                'reportId': reportId <= 0 ? null : reportId,
                'invalid': reportId == null ? 0 : null,
                '@order': 'date-',
                '@column': 'id,userId,documentId,testAccountId,reportId,duration,minDuration,maxDuration,response' + (this.isStatisticsEnabled ? ',compare' : '')+ (this.isMLEnabled ? ',standard' : ''),
                'standard{}': this.isMLEnabled ? (this.database == 'SQLSERVER' ? 'len(standard)>2' : 'length(standard)>2') : null  //用 MySQL 5.6   '@having': this.isMLEnabled ? 'json_length(standard)>0' : null
              },
              'Script:pre': {
                'ahead': 1,
                // 'testAccountId': 0,
                'documentId@': '/Method/id',
                '@order': 'date-'
              },
              'Script:post': {
                'ahead': 0,
                // 'testAccountId': 0,
                'documentId@': '/Method/id',
                '@order': 'date-'
              }
            },
            '@role': IS_NODE ? null : 'LOGIN',
            key: IS_NODE ? this.key : undefined  // 突破常规查询数量限制
          }

          if (IS_BROWSER) {
            this.onChange(false)
          }
          this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.server + '/get', req, {}, function (url, res, err) {
            App.isTestCaseShow = false
            if (callback) {
              callback(url, res, err)
              return
            }

            App.onTestCaseListResponse(show, url, res, err)
          })
        } else if (callback != null) {
          callback(null, {}, null)
        }
      },

      onTestCaseListResponse: function(show, url, res, err) {
        this.onResponse(url, res, err)

        var rpObj = res.data

        if (JSONResponse.isSuccess(rpObj)) {
          this.isTestCaseShow = true
          this.isLocalShow = false
          this.testCases = App.remotes = rpObj['[]']
          this.getCurrentRandomSummary().summaryType = 'total' // App.onClickSummary('total', true)

          if (IS_BROWSER) {
            vOutput.value = show ? '' : (output || '')
            this.showDoc()
          }

          this.showCompare4TestCaseList(show)

          //this.onChange(false)
        } else if (IS_BROWSER) { // 解决一旦错了，就只能清缓存
          this.testCaseCount = 50
          this.testCasePage = 0
          this.testCaseSearch = ''
          this.testCasePages = {}
          this.testCaseCounts = {}
          this.testCaseSearches = {}

          this.saveCache(this.server, 'testCasePage', this.testCasePage)
          this.saveCache(this.server, 'testCaseCount', this.testCaseCount)
          this.saveCache(this.server, 'testCaseSearch', this.testCaseSearch)
          this.saveCache(this.server, 'testCasePages', null)
          this.saveCache(this.server, 'testCaseCounts', null)
          this.saveCache(this.server, 'testCaseSearches', null)
        }
      },

      onClickLogoutSummary: function (color) {
        this.onClickSummary(color, false, -1)
      },
      onClickAllSummary: function (color) {
        this.onClickSummary(color, false, this.accounts.length) // this.currentAccountIndex)
      },
      onClickCurrentSummary: function (color) {
        this.onClickSummary(color, false, this.currentAccountIndex)
      },
      onClickSummary: function (color, isRandom, accountIndex) {
        var isCur = this.currentAccountIndex == accountIndex
        if (! isCur) {
          this.onClickAccount(accountIndex, accountIndex < 0 ? this.logoutSummary : this.accounts[accountIndex])
        }
        // this.currentAccountIndex = accountIndex
        // this.isTestCaseShow = false

        var isSub = this.isRandomSubListShow
        var arr = isRandom ? (isSub ? this.currentRandomItem.subs : this.currentRemoteItem.randoms) : this.remotes;
        var list = []
        if (color == null || color == 'total') {
          list = arr
          if (isCur) {
            this.statisticsShowType = (this.statisticsShowType + 1)%3;
          }
        } else if (arr != null) {
          for (var i = 0; i < arr.length; i++) {
            var obj = arr[i]
            if (obj == null) {
              continue
            }

            var count = isRandom && obj.Random != null ? obj.Random.count : (isRandom ? null : obj.totalCount)
            if (count != null && count > (isRandom ? 1 : 0)) {
              var sum = obj[color + 'Count']
              if (sum != null && sum > 0) {
                list.push(obj)
              }
              continue
            }

            if (obj.compareColor == color) {
              list.push(obj)
            }
          }
        }

        if (isRandom) {
          if (isSub) {
            this.currentRandomItem.summaryType = color
            this.randomSubs = list
          } else {
            this.currentRemoteItem.summaryType = color
            this.randoms = list
          }
        } else {
          var summary = this.getSummary(accountIndex) || {}
          summary.summaryType = color
          this.testCases = list
          this.isTestCaseShow = true
          // this.showTestCase(true, false)
        }
      },

      showCompare4RandomList: function (show, isSub) {
        this.getCurrentRandomSummary().summaryType = 'total'

        var randoms = show ? (isSub ? this.randomSubs : this.randoms) : null
        var randomCount = randoms == null ? 0 : randoms.length
        if (randomCount > 0) {
          var accountIndex = (this.accounts[this.currentAccountIndex] || {}).isLoggedIn ? this.currentAccountIndex : -1
          this.currentAccountIndex = accountIndex  //解决 onTestResponse 用 -1 存进去， handleTest 用 currentAccountIndex 取出来为空
          var docId = ((this.currentRemoteItem || {}).Method || {}).id

          var tests = (this.tests[String(accountIndex)] || {})[docId]
          if (tests != null && JSONObject.isEmpty(tests) != true) {
            // if (! isSub) {
            //   this.resetCount(this.currentRemoteItem, true, isSub, accountIndex)
            // }

            for (var i = 0; i < randomCount; i++) {
              var item = randoms[i]
              var r = item == null ? null : item.Random
              if (r == null || r.id == null) {
                continue
              }

              this.resetCount(item, true, isSub, accountIndex)

              var subCount = r.count || 0
              if (subCount == 1) {
                this.compareResponse(null, randomCount, randoms, i, item, tests[r.id], true, accountIndex, true)
              }
              else if (subCount > 1) {
                var subRandoms = item['[]'] || []
                var subSize = Math.min(subRandoms.length, subCount)
                for (var j = 0; j < subSize; j++) {
                  var subItem = subRandoms[j]
                  var sr = subItem == null ? null : subItem.Random
                  if (sr == null || sr.id == null) {
                    continue
                  }

                  this.compareResponse(null, subSize, subRandoms, j, subItem, tests[sr.id > 0 ? sr.id : (sr.toId + '' + sr.id)], true, accountIndex, true)
                }
              }
            }
          }
        }
      },

      //显示远程的随机配置文档
      showRandomList: function (show, item, isSub, callback) {
        this.isRandomEditable = false
        this.isRandomListShow = show && ! isSub
        this.isRandomSubListShow = show && isSub
        if (! isSub) {
          this.randomSubs = []
        }

        if (IS_BROWSER) {
          vOutput.value = show ? '' : (output || '')
          this.showDoc()
        }

        var randoms = []
        if (this.randomPage == 0 && ! isSub) {
          randoms = (this.currentRemoteItem || {}).randoms || []
        }
        else if (this.randomSubPage == 0 && isSub) {
          randoms = (this.currentRandomItem || {}).subs || []
        }

        if (isSub) {
          this.randomSubs = randoms
        }
        else {
          this.randoms = randoms
        }

        this.getCurrentRandomSummary().summaryType = 'total' // this.onClickSummary('total', true)
        if (! this.isRandomSummaryShow()) {
          this.showCompare4RandomList(show, isSub)
        }

        if (show && this.isRandomShow && randoms.length <= 0 && item != null && item.id != null) {
          this.isRandomListShow = false

          var subSearch = StringUtil.isEmpty(this.randomSubSearch, true)
            ? null : '%' + StringUtil.trim(this.randomSubSearch) + '%'
          var search = isSub ? subSearch : (StringUtil.isEmpty(this.randomSearch, true)
            ? null : '%' + StringUtil.trim(this.randomSearch) + '%')

          var url = this.server + '/get'
          var req = {
            '[]': {
              'count': (isSub ? this.randomSubCount : this.randomCount) || 100,
              'page': (isSub ? this.randomSubPage : this.randomPage) || 0,
              'Random': {
                'toId': isSub ? item.id : 0,
                'documentId': isSub ? null : item.id,
                '@order': "date-",
                'name$': search
              },
              'TestRecord': {
                'randomId@': '/Random/id',
//                'testAccountId': this.getCurrentAccountId(),
                'host': this.getBaseUrl(),
                '@order': 'date-'
              },
              '[]': isSub ? null : {
                'count': this.randomSubCount || 100,
                'page': this.randomSubPage || 0,
                'Random': {
                  'toId@': '[]/Random/id',
                  'documentId': item.id,
                  '@order': "date-",
                  'name$': subSearch
                },
                'TestRecord': {
                  'randomId@': '/Random/id',
//                  'testAccountId': this.getCurrentAccountId(),
                  'host': this.getBaseUrl(),
                  '@order': 'date-'
                }
              }
            },
            key: IS_NODE ? this.key : undefined  // 突破常规查询数量限制
          }

          if (IS_BROWSER) {
            this.onChange(false)
          }

          this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,url, req, {}, function (url, res, err) {
            if (callback) {
              callback(url, res, err)
              return
            }
            App.onRandomListResponse(show, isSub, url, res, err)
          })
        } else if (callback) {
          callback(null, {}, null)
        }
      },

      onRandomListResponse: function (show, isSub, url, res, err) {
        res = res || {}

        App.onResponse(url, res, err)

        var rpObj = res.data

        if (JSONResponse.isSuccess(rpObj)) {
          App.isRandomListShow = ! isSub
          App.isRandomSubListShow = isSub
          if (isSub) {
            if (App.currentRandomItem == null) {
              App.currentRandomItem = {}
            }
            App.randomSubs = App.currentRandomItem.subs = App.currentRandomItem['[]'] = rpObj['[]']
          }
          else {
            if (App.currentRemoteItem == null) {
              App.currentRemoteItem = {}
            }
            App.randoms = App.currentRemoteItem.randoms = rpObj['[]']
          }
          this.getCurrentRandomSummary().summaryType = 'total' // App.onClickSummary('total', true)

          if (IS_BROWSER) {
            vOutput.value = show ? '' : (output || '')
            App.showDoc()
          }

          // if (! this.isRandomSummaryShow()) {
            App.showCompare4RandomList(show, isSub)
          // }

          //App.onChange(false)
        }
      },

      // 设置文档
      showDoc: function () {
        if (this.setDoc(doc) == false) {
          this.getDoc(function (d) {
            App.setDoc(d);
          });
        }
      },


      saveCache: function (url, key, value) {
        var cache = this.getCache(url);
        cache[key] = value
        localStorage.setItem('UnitAuto:' + url, JSON.stringify(cache))
      },
      getCache: function (url, key, defaultValue) {
        var cache = localStorage.getItem('UnitAuto:' + url)
        try {
          cache = JSON.parse(cache)
        } catch(e) {
          this.log('login  this.send >> try { cache = JSON.parse(cache) } catch(e) {\n' + e.message)
        }
        cache = cache || {}
        var val = key == null ? cache : cache[key]
        return val == null && defaultValue != null ? defaultValue : val
      },

      getCurrentDocumentId: function() {
        var d = (this.currentRemoteItem || {}).Method
        return d == null ? null : d.id;
      },
      getCurrentRandomId: function() {
        var r = (this.currentRandomItem || {}).Random
        return r == null ? null : r.id;
      },
      getCurrentScriptBelongId: function() {
        return this.getScriptBelongId(this.scriptType)
      },
      getScriptBelongId: function(scriptType) {
        var st = scriptType;
        var bid = st == 'global' ? 0 : ((st == 'account' ? this.getCurrentAccountId() : this.getCurrentDocumentId()) || 0)
        return bid
      },
      listScript: function() {
        var req = {
          'Script:pre': {
            'ahead': 1,
            'testAccountId': 0,
            'documentId': 0,
            '@order': 'date-'
          },
          'Script:post': {
            'ahead': 0,
            'testAccountId': 0,
            'documentId': 0,
            '@order': 'date-'
          }
        }

        var accounts = this.accounts || []
        for (let i = 0; i < accounts.length; i++) {
          var a = accounts[i]
          var id = a == null ? null : a.id
          if (id == null) {
            continue
          }

          req['account_' + id] = { // 用数字被居然强制格式化到 JSON 最前
            'Script:pre': {
              'ahead': 1,
              'testAccountId': id,
              'documentId': 0,
              '@order': 'date-'
            },
            'Script:post': {
              'ahead': 0,
              'testAccountId': id,
              'documentId': 0,
              '@order': 'date-'
            }
          }
        }

        this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,'/get', req, {}, function (url, res, err) {
          var rpObj = res.data
          if (JSONResponse.isSuccess(rpObj) != true) {
            App.log(err != null ? err : (rpObj == null ? '' : rpObj.msg))
            return
          }

          var scripts = App.scripts || {}
          var ss = scripts.global
          if (ss == null) {
            scripts.global = ss = {}
          }

          var bs = ss['0'] || {}
          if (bs == null) {
            ss['0'] = bs = {}
          }

          var pre = rpObj['Script:pre']
          if (pre != null && pre.script != null) {
            bs.pre = rpObj['Script:pre']
          }
          var post = rpObj['Script:post']
          if (post != null && post.script != null) {
            bs.post = rpObj['Script:post']
          }

          // delete rpObj['Script:pre']
          // delete rpObj['Script:post']

          var cs = scripts.account
          if (cs == null) {
            scripts.account = cs = {}
          }

          for (let key in rpObj) {
            var val = rpObj[key]
            var pre = val == null || key.startsWith('account_') != true ? null : val['Script:pre']
            if (pre == null) {
              continue
            }

            var post = val['Script:post']

            var bs = cs[key.substring('account_'.length)]

            if (pre != null) { // && pre.script != null) {
              bs.pre = pre
            }
            if (post != null) { // && post.script != null) {
              bs.post = post
            }
          }

          App.scripts = Object.assign(newDefaultScript(), scripts)
        })
      },


      /**登录确认
       */
      confirm: function () {
        switch (this.loginType) {
          case 'login':
            this.login(this.isAdminOperation)
            break
          case 'register':
            this.register(this.isAdminOperation)
            break
          case 'forget':
            this.resetPassword(this.isAdminOperation)
            break
        }
      },

      showLogin: function (show, isAdmin) {
        this.isLoginShow = show
        this.isAdminOperation = isAdmin

        if (show != true) {
          return
        }

        var user = isAdmin ? this.User : null  // add account   this.accounts[this.currentAccountIndex]

        // alert("showLogin  isAdmin = " + isAdmin + "; user = \n" + JSON.stringify(user, null, '    '))

        if (user == null || StringUtil.isEmpty(user.phone, true)) {
          user = {
            phone: '13000082001',
            password: '123456'
          }
        }

        this.setRememberLogin(user.remember)
        this.account = user.phone
        this.password = user.password

        var schemas = StringUtil.isEmpty(this.schema, true) ? null : StringUtil.split(this.schema)

        const req = {
          type: 0, // 登录方式，非必须 0-密码 1-验证码
          // asDBAccount: ! isAdminOperation,  // 直接 /execute 接口传 account, password
          phone: this.account,
          password: this.password,
          version: 1, // 全局默认版本号，非必须
          remember: vRemember.checked,
          format: false,
          defaults: isAdmin ? {
            key: IS_NODE ? this.key : undefined  // 突破常规查询数量限制
          } : {
            '@database': StringUtil.isEmpty(this.database, true) ? undefined : this.database,
            '@schema': schemas == null || schemas.length != 1 ? undefined : this.schema
          }
        }

        this.isHeaderShow = true
        this.isRandomShow = true
        this.isRandomListShow = false

        if (IS_BROWSER && ! isAdmin) {
          this.prevUrl = vUrl.value
          this.prevUrlComment = vUrlComment.value
          this.prevInput = vInput.value
          this.prevComment = vComment.value
          this.prevWarning = vWarning.value
          this.prevRandom = vRandom.value
          this.prevHeader = vHeader.value
          this.prevScript = vScript.value

          vUrl.value = '/login' // this.showUrl(isAdmin, '/login')
          vInput.value = JSON.stringify(req, null, '    ')

          this.testRandomCount = 1
          vRandom.value = `phone: App.account\npassword: App.password\nremember: vRemember.checked`
        }

        this.scripts = newDefaultScript()
        this.method = REQUEST_TYPE_POST
        this.type = REQUEST_TYPE_JSON
        this.showTestCase(false, this.isLocalShow)
        if (IS_BROWSER) {
          this.onChange(false)
        }
      },

      setRememberLogin: function (remember) {
        vRemember.checked = remember || false
      },

      getCurrentAccount: function() {
        return this.accounts == null ? null : this.accounts[this.currentAccountIndex]
      },
      getCurrentAccountId: function() {
        var a = this.getCurrentAccount()
        return a != null && a.isLoggedIn ? a.id : null
      },

      /**登录
       */
      login: function (isAdminOperation, callback) {
        this.isEditResponse = false

        const req = {
          type: 0, // 登录方式，非必须 0-密码 1-验证码
          // asDBAccount: ! isAdminOperation,  // 直接 /execute 接口传 account, password
          phone: this.account,
          password: this.password,
          version: 1, // 全局默认版本号，非必须
          remember: vRemember.checked,
          format: false,
          defaults: isAdminOperation ? {
            key: IS_NODE ? this.key : undefined  // 突破常规查询数量限制
          } : undefined  // 后端决定
          // {
          //  '@database': StringUtil.isEmpty(this.database, true) ? undefined : this.database,
          //  '@schema': StringUtil.isEmpty(this.schema, true) ? undefined : this.schema
          // }
        }

        if (isAdminOperation) {
          this.isLoginShow = false
          this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.server + '/login', req, this.getHeader(vHeader.value), function (url, res, err) {
            if (callback) {
              callback(url, res, err)
              return
            }

            App.onLoginResponse(isAdminOperation, req, url, res, err);
          })
        }
        else {
          function recover() {
            App.isLoginShow = false

            if (App.prevUrl != null) {
              vUrl.value = App.prevUrl || 'unitauto.test.TestUtil.test'
              vUrlComment.value = App.prevUrlComment || ''
              vComment.value = App.prevComment || ''
              vWarning.value = App.prevWarning || ''
              vInput.value = App.prevInput || '{}'
              vRandom.value = App.prevRandom || ''
              vHeader.value = App.prevHeader || ''
              vScript.value = App.prevScript || ''

              App.prevUrl = null
            }
          }

          if (IS_BROWSER && callback == null) {
            var item
            for (var i in this.accounts) {
              item = this.accounts[i]
              if (item != null && req.phone == item.phone) {
                recover()
                alert(req.phone +  ' 已在测试账号中！')
                // this.currentAccountIndex = i
                item.remember = vRemember.checked
                this.onClickAccount(i, item)
                return
              }
            }
          }
          
          this.scripts = newDefaultScript()

          const isLoginShow = this.isLoginShow
          var curUser = this.getCurrentAccount() || {}
          const loginMethod = (isLoginShow ? this.method : curUser.loginMethod) || REQUEST_TYPE_POST
          const loginType = (isLoginShow ? this.type : curUser.loginType) || REQUEST_TYPE_JSON
          const loginUrl = (isLoginShow ? vUrl.value : curUser.loginUrl) || '/login'
          const loginReq = (isLoginShow ? this.getRequest(vInput.value) : curUser.loginReq) || req
          const loginHeader = (isLoginShow ? this.getHeader(vHeader.value) : curUser.loginHeader) || {}

          function loginCallback(url, res, err, random) {
            recover()
            if (callback) {
              callback(url, res, err)
            } else {
              App.onLoginResponse(isAdminOperation, req, url, res, err, loginMethod, loginType, loginUrl, loginReq, loginHeader)
            }
          }

          if (isLoginShow) {
            this.testRandomWithText(true, loginCallback)
            return
          }

          this.scripts = newDefaultScript()

          this.request(isAdminOperation, loginMethod, loginType, this.project + loginUrl, loginReq, loginHeader, function (url, res, err) {
            if (App.isEnvCompareEnabled != true) {
              loginCallback(url, res, err, null, loginMethod, loginType, loginUrl, loginReq, loginHeader)
              return
            }

            App.request(isAdminOperation, loginMethod, loginType, App.getBaseUrl(App.otherEnv) + loginUrl
                , loginReq, loginHeader, function(url_, res_, err_) {
                  var data = res_.data
                  var user = JSONResponse.isSuccess(data) ? data.user : null
                  if (user != null) {
                    var headers = res.headers || {}
                    App.otherEnvCookieMap[req.phone] = res.cookie || headers.cookie || headers.Cookie || headers['set-cookie'] || headers['Set-Cookie']
                    App.saveCache(App.otherEnv, 'otherEnvCookieMap', App.otherEnvCookieMap)
                  }

                  if (callback) {
                    callback(url, res, err)
                    return
                  }

                  App.onResponse(url_, res_, err_);
                  App.onLoginResponse(isAdminOperation, req, url, res, err, loginMethod, loginType, loginUrl, loginReq, loginHeader)
            }, App.scripts)
          })
        }
      },

      onLoginResponse: function(isAdmin, req, url, res, err, loginMethod, loginType, loginUrl, loginReq, loginHeader) {
        res = res || {}
        if (isAdmin) {
          var rpObj = res.data || {}

          if (JSONResponse.isSuccess(rpObj) != true) {
            alert('登录失败，请检查网络后重试。\n' + rpObj.msg + '\n详细信息可在浏览器控制台查看。')
            App.onResponse(url, res, err)
          }
          else {
            var user = rpObj.user || {}

            if (user.id > 0) {
              user.remember = rpObj.remember
              user.phone = req.phone
              user.password = req.password
              user.cookie = res.cookie || (res.headers || {}).cookie
              App.User = user
            }

            //保存User到缓存
            App.saveCache(App.server, 'User', user)

            if (App.currentAccountIndex == null || App.currentAccountIndex < 0) {
              App.currentAccountIndex = 0
            }
            var item = App.accounts[App.currentAccountIndex]
            item.isLoggedIn = false
            App.onClickAccount(App.currentAccountIndex, item) //自动登录测试账号

            if (user.id > 0) {
              if (App.caseShowType != 1 && App.casePaths.length <= 0 && App.caseGroups.length <= 0) {
                App.selectCaseGroup(-1, null)
              }
              App.showTestCase(true, false)
            }
          }
        } else {
          App.onResponse(url, res, err)

          //由login按钮触发，不能通过callback回调来实现以下功能
          var data = res.data || {}
          if (JSONResponse.isSuccess(data)) {
            var user = data.user || {}
            App.accounts.push({
              isLoggedIn: true,
              id: user.id,
              name: user.name,
              phone: req.phone,
              password: req.password,
              remember: data.remember,
              loginMethod: loginMethod,
              loginType: loginType,
              loginUrl: loginUrl,
              loginReq: loginReq,
              loginHeader: loginHeader,
              cookie: res.cookie || (res.headers || {}).cookie
            })

            var lastItem = App.accounts[App.currentAccountIndex]
            if (lastItem != null) {
              lastItem.isLoggedIn = false
            }

            App.currentAccountIndex = App.accounts.length - 1

            var key = App.getBaseUrl(loginUrl)
            App.saveCache(key, 'currentAccountIndex', App.currentAccountIndex)
            App.saveCache(key, 'accounts', App.accounts)

            App.listScript()
          }
        }
      },

      /**注册
       */
      register: function (isAdminOperation) {
        this.scripts = newDefaultScript()
        this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,'/register', {
          Privacy: {
            phone: this.account,
            _password: this.password
          },
          User: {
            name: 'APIJSONUser'
          },
          verify: vVerify.value
        }, this.getHeader(vHeader.value), function (url, res, err) {
          App.onResponse(url, res, err)

          var rpObj = res.data

          if (JSONResponse.isSuccess(rpObj)) {
            alert('注册成功')

            var privacy = rpObj.Privacy || {}

            App.account = privacy.phone
            App.loginType = 'login'
          }
        }, this.scripts)
      },

      /**重置密码
       */
      resetPassword: function (isAdminOperation) {
        this.scripts = newDefaultScript()
        this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,'/put/password', {
          verify: vVerify.value,
          Privacy: {
            phone: this.account,
            _password: this.password
          }
        }, this.getHeader(vHeader.value), function (url, res, err) {
          App.onResponse(url, res, err)

          var rpObj = res.data

          if (JSONResponse.isSuccess(rpObj)) {
            alert('重置密码成功')

            var privacy = rpObj.Privacy || {}

            App.account = privacy.phone
            App.loginType = 'login'
          }
        }, this.scripts)
      },

      /**退出
       */
      logout: function (isAdminOperation, callback) {
        this.isEditResponse = false
        var req = {}

        if (isAdminOperation) {
          // alert('logout  isAdminOperation  this.saveCache(this.server, User, {})')
          this.delegateId = null
          this.saveCache(this.server, 'delegateId', null)

          this.saveCache(this.server, 'User', {})
        }

        // alert('logout  isAdminOperation = ' + isAdminOperation + '; url = ' + url)
        if (isAdminOperation) {
          this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.server + '/logout'
              , req, this.getHeader(vHeader.value), function (url, res, err) {
            if (callback) {
              callback(url, res, err)
              return
            }

            // alert('logout  clear admin ')

            App.clearUser()
            App.onResponse(url, res, err)
            App.showTestCase(false, App.isLocalShow)
          })
        }
        else {
          this.scripts = newDefaultScript()
          this.showTestCase(false, this.isLocalShow)
          this.onChange(false)
          this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.project + '/logout', req, this.getHeader(vHeader.value), function (url, res, err) {
            if (App.isEnvCompareEnabled != true) {
              if (callback) {
                callback(url, res, err)
              }
              return
            }

            App.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, App.getBaseUrl(App.otherEnv) + '/logout'
                , req, App.getHeader(vHeader.value), function (url_, res_, err_) {
              if (callback) {
                callback(url, res, err)
                return
              }
            })

          }, this.scripts)
        }
      },

      /**获取验证码
       */
      getVerify: function (isAdminOperation) {
        this.scripts = newDefaultScript()
        var type = this.loginType == 'login' ? 0 : (this.loginType == 'register' ? 1 : 2)
        this.showTestCase(false, this.isLocalShow)
        this.onChange(false)
        this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,'/post/verify', {
          type: type,
          phone: this.account
        }, this.getHeader(vHeader.value), function (url, res, err) {
          App.onResponse(url, res, err)

          var data = res.data || {}
          var obj = JSONResponse.isSuccess(data) ? data.verify : null
          var verify = obj == null ? null : obj.verify
          if (verify != null) { //FIXME isEmpty校验时居然在verify=null! StringUtil.isEmpty(verify, true) == false) {
            vVerify.value = verify
          }
        }, this.scripts)
      },

      clearUser: function () {
        this.User.id = 0
        this.Privacy = {}
        this.casePaths = []
        this.caseGroups = []
        this.remotes = []
        // 导致刚登录成功就马上退出 this.delegateId = null
        this.saveCache(this.server, 'User', this.User) //应该用lastBaseUrl,baseUrl应随watch输入变化重新获取
        // this.saveCache(this.server, 'delegateId', this.delegateId) //应该用lastBaseUrl,baseUrl应随watch输入变化重新获取
      },

      /**计时回调
       */
      onHandle: function (before) {
        if (IS_NODE) {
          return;
        }

        this.isDelayShow = false
        if (inputted != before) {
          clearTimeout(handler);
          return;
        }

        this.view = 'output';
        vComment.value = '';
        vWarning.value = '';
        // vUrlComment.value = '';
        vOutput.value = 'resolving...';

        //格式化输入代码
        try {
          try {
            this.header = this.getHeader(vHeader.value)
          } catch (e2) {
            this.isHeaderShow = true
            vHeader.select()
            throw new Error(e2.message)
          }

          before = StringUtil.trim(before);

          var afterObj;
          var after;
          var code = '';

          if (StringUtil.isEmpty(before)) {
            afterObj = {};
            after = '';
          } else {
            before = StringUtil.trim(before); // this.toDoubleJSON(StringUtil.trim(before));
            log('onHandle  before = \n' + before);

            var json = isSingle ? this.switchQuote(before) : before;
            try {
              afterObj = jsonlint.parse(json);
              after = JSON.stringify(afterObj, null, "    ");
              before = isSingle ? this.switchQuote(after) : after;
            }
            catch (e) {
              log('main.onHandle', 'try { return jsonlint.parse(before); \n } catch (e) {\n' + e.message)
              log('main.onHandle', 'return jsonlint.parse(this.removeComment(before));')

              try {
                afterObj = JSON5.parse(json);  // jsonlint.parse(this.removeComment(before));
                after = JSON.stringify(afterObj, null, "    ");
              } catch (e2) {
                throw new Error('请求 JSON 格式错误！请检查并编辑请求！\n\n如果JSON中有注释，请 手动删除 或 点击左边的 \'/" 按钮 来去掉。\n\n' + e.message + '\n\n' + e2.message)
              }
            }

            //关键词let在IE和Safari上不兼容
            // if (this.isEditResponse != true) {
            // var code = '';
            // try {
            //   code = this.getCode(after); //必须在before还是用 " 时使用，后面用会因为解析 ' 导致失败
            // } catch(e) {
            //   code = '\n\n\n建议:\n使用其它浏览器，例如 谷歌Chrome、火狐FireFox 或者 微软Edge， 因为这样能自动生成请求代码.'
            //     + '\nError:\n' + e.message + '\n\n\n';
            // }
            // }



            var selectionStart = vInput.selectionStart
            var selectionEnd = vInput.selectionEnd
            vInput.value = before
              + '\n\n\n                                                                                                       '
              + '                                                                                                       \n';  //解决遮挡

            vInput.selectionStart = selectionStart
            vInput.selectionEnd = selectionEnd
            vInput.setSelectionRange(selectionStart, selectionEnd)
          }

          vSend.disabled = false;
          if (this.isEditResponse != true) {
            vOutput.value = output = '登录后点 ↑ 上方左侧最后图标按钮可查看用例列表，点上方右侧中间图标按钮可上传用例到列表中 ↑ \nOK，请点左上方 [远程执行] 按钮来测试。[点击这里查看视频教程](https://www.bilibili.com/video/BV1Tk4y1R7Yo)' + code;

            this.showDoc()
          }

          var docKey = this.isEditResponse ? 'TestRecord' : 'Method';
          var currentItem = (this.currentRemoteItem || {})[docKey] || {}
          var detail = currentItem.detail;
          var extraComment = this.getExtraComment()

          try {
            var standardObj = null;
            try {
              standardObj = JSON.parse(currentItem.standard);
            } catch (e3) {
              log(e3)
            }

            var isAPIJSONRouter = false;
            // try {
              // var apijson = JSON.parse(currentItem.apijson);
              // isAPIJSONRouter = JSONResponse.isObject(apijson)
            // } catch (e3) {
              // log(e3)
            // }

            var m = null  // this.getMethod();
            var w = isSingle || this.isEditResponse ? '' : StringUtil.trim(CodeUtil.parseComment(after, docObj == null ? null : docObj['[]'], m, this.database, this.language, this.isEditResponse != true, standardObj, null, true, isAPIJSONRouter));
            var c = isSingle ? '' : StringUtil.trim(CodeUtil.parseComment(after, docObj == null ? null : docObj['[]'], m, this.database, this.language, this.isEditResponse != true, standardObj, null, null, isAPIJSONRouter));

            //TODO 统计行数，补全到一致 vInput.value.lineNumbers
            if (isSingle != true) {
              if (afterObj.tag == null) {
                m = m == null ? 'GET' : m.toUpperCase()
                if (['GETS', 'HEADS', 'POST', 'PUT', 'DELETE'].indexOf(m) >= 0) {
                  w += ' ! 非开放请求必须设置 tag ！例如 "tag": "User"'
                  c += ' ! 非开放请求必须设置 tag ！例如 "tag": "User"'
                }
              }

              if (StringUtil.isEmpty(detail, true)) {
                c += extraComment == null ? '' : ('\n\n/*' + extraComment + '\n*/');
              } else {
                c += '\n\n/*' + (extraComment == null ? '' : extraComment + '\n\n') + detail + '\n*/';
              }
            }


            vWarning.value = w
              + '\n\n\n                                                                                                       '
              + '                                                                                                       \n';  //解决遮挡
            vComment.value = c
              + '\n\n\n                                                                                                       '
              + '                                                                                                       \n';  //解决遮挡

            vUrlComment.value = isSingle || StringUtil.isEmpty(this.urlComment, true)
              ? '' : CodeUtil.getBlank(StringUtil.length(vUrl.value), 1) + ' ' + this.urlComment
              // + ' - ' + (this.requestVersion > 0 ? 'V' + this.requestVersion : 'V*');


            onScrollChanged()
            onURLScrollChanged()
          } catch (e) {
            log('onHandle   try { vComment.value = CodeUtil.parseComment >> } catch (e) {\n' + e.message);
          }

          if (this.isPreviewEnabled) {
            try {
              // 去掉前面的 JSON
              var raw = StringUtil.trim(isSingle ? vInput.value : vComment.value);
              var start = raw.lastIndexOf('\n/*')
              var end = raw.lastIndexOf('\n*/')
              var ct = start < 0 || end <= start ? '' : StringUtil.trim(raw.substring(start + '\n/*'.length, end))

              markdownToHTML('```js\n' + (start < 0 || end <= start ? raw : raw.substring(0, start)) + '\n```\n'
                + (StringUtil.isEmpty(ct, true) ? '' : ct + '\n\n```js\n' + ct + '\n```\n'), true);
            } catch (e3) {
              log(e3)
            }
          }

          if (this.isEditResponse) {
            this.view = 'code';
            this.jsoncon = after
          }

        } catch(e) {
          log(e)
          vSend.disabled = true

          this.view = 'error'
          this.error = {
            msg: e.message
          }
        }
      },


      /**输入内容改变
       */
      onChange: function (delay) {
        this.setBaseUrl();

        if (IS_NODE || document.activeElement == vOption || this.options.length > 0) {
          return;
        }

        inputted = new String(vInput.value);
        vComment.value = '';
        vWarning.value = '';
        // vUrlComment.value = '';

        clearTimeout(handler);

        this.isDelayShow = delay;

        if (delay) {
          handler = setTimeout(function () {
            App.onHandle(inputted);
          }, 2000);
        } else {
          this.onHandle(inputted);
        }
      },

      /**单双引号切换
       */
      transfer: function () {
        isSingle = ! isSingle;

        vInput.value = this.switchQuote(vInput.value);

        this.isTestCaseShow = false;

        // // 删除注释 <<<<<<<<<<<<<<<<<<<<<
        //
        // var input = this.removeComment(vInput.value);
        // if (vInput.value != input) {
        //   vInput.value = input
        // }
        //
        // // 删除注释 >>>>>>>>>>>>>>>>>>>>>

        this.onChange(false);

        var list = docObj == null ? null : docObj['[]'];
        if (list != null && list.length > 0) {
          this.onDocumentListResponse('', {data: docObj}, null, function (d) {
            App.setDoc(d);
          });
        }
      },

      /**获取显示的请求类型名称
       */
      getTypeName: function (type, method) {
        var t = type
        if (StringUtil.isEmpty(t, true)) {
          if (StringUtil.isEmpty(method, true)) {
            t = REQUEST_TYPE_JSON
          }
          else if (method == REQUEST_TYPE_GET) {
            t = REQUEST_TYPE_PARAM
          }
          else if (method == REQUEST_TYPE_POST) {
            t = REQUEST_TYPE_JSON
          }
          else {
            t = REQUEST_TYPE_DATA
          }
        }
//        var methods = this.methods
//        if (this.isShowMethod()) {
//          return t
//        }
//
//        var ts = this.types
//        if (ts == null || ts.length <= 1 || (ts.length <= 2 && ts.indexOf(REQUEST_TYPE_PARAM) >= 0 && ts.indexOf(REQUEST_TYPE_GRPC) < 0)) {
//          return t == REQUEST_TYPE_PARAM ? 'GET' : 'POST'
//        }
        return t
      },
      /**请求类型切换
       */
      changeType: function () {
        var types = this.types
        var count = types == null ? 0 : types.length
        if (count <= 0) {
          types = HTTP_CONTENT_TYPES
          count = HTTP_CONTENT_TYPES.length
        }
        if (count > 1) {
          var index = types.indexOf(this.type) + 1
          this.type = types[index % count]
          CodeUtil.type = this.type;
        }

        var url = StringUtil.get(vUrl.value)
        var index = url.indexOf('?')
        if (index >= 0) {
          var paramObj = getRequestFromURL(url.substring(index), true)
          vUrl.value = url.substring(0, index)
          if (paramObj != null && JSONObject.isEmpty(paramObj) == false) {
            var originVal = this.getRequest(vInput.value, {});
            var isConflict = false;

            if (JSONObject.isEmpty(originVal) == false) {
              for (var k in paramObj) {
                if (originVal.hasOwnProperty(k)) {
                  isConflict = true;
                  break;
                }
              }
            }

            if (isConflict) {
              vInput.value = JSON.stringify(paramObj, null, '    ') + '\n\n// FIXME 从 URL 上的参数转换过来，需要与下面原来的字段合并为一个 JSON：\n\n' + StringUtil.get(vInput.value)
            }
            else {
              vInput.value = JSON.stringify(Object.assign(originVal, paramObj), null, '    ')
            }
          }
          clearTimeout(handler)  //解决 vUrl.value 和 vInput.value 变化导致刷新，而且会把 vInput.value 重置，加上下面 onChange 再刷新就卡死了
        }

        this.onChange(false);
      },

      changeScriptType: function (type) {
        type = type || 'case'
        if (type == 'account') {
          var id = this.getCurrentAccountId()
          if (id == null || id <= 0) {
            type = 'case'
          }
        }

        this.scriptBelongId = 0 // 解决可能的报错
        this.scriptType = type
        var bid = this.getCurrentScriptBelongId()

        var scripts = this.scripts
        if (scripts == null) {
          scripts = newDefaultScript()
          this.scripts = scripts
        }
        var ss = scripts[type]
        if (ss == null) {
          ss = {
            0: {
              pre: { // 可能有 id
                script: '' // index.html 中 v-model 绑定，不能为 null
              },
              post: {
                script: ''
              }
            },
            [bid]: {
              pre: { // 可能有 id
                script: '' // index.html 中 v-model 绑定，不能为 null
              },
              post: {
                script: ''
              }
            }
          }
          scripts[type] = ss
        }

        var bs = ss[bid]
        if (bs == null) {
          bs = {
            pre: { // 可能有 id
              script: '' // index.html 中 v-model 绑定，不能为 null
            },
            post: {
              script: ''
            }
          }
          ss[bid] = bs
        }
        var pre = bs.pre
        if (pre == null) {
          pre = {
            script: ''
          }
          bs.pre = pre
        }
        if (pre.script == null) {
          pre.script = ''
        }

        var post = bs.post
        if (post == null) {
          post = {
            script: ''
          }
          bs.post = post
        }
        if (post.script == null) {
          post.script = ''
        }

        this.scriptBelongId = bid
      },
      changeScriptPriority: function (isPre) {
        this.isPreScript = isPre == true
        this.changeScriptType(this.scriptType)
      },

      /**
       * 删除注释
       */
      removeComment: function (json) {
        var reg = /("([^\\\"]*(\\.)?)*")|('([^\\\']*(\\.)?)*')|(\/{2,}.*?(\r|\n))|(\/\*(\n|.)*?\*\/)/g // 正则表达式
        try {
          return new String(json).replace(reg, function(word) { // 去除注释后的文本
            return /^\/{2,}/.test(word) || /^\/\*/.test(word) ? "" : word;
          })
        } catch (e) {
          log('transfer  delete comment in json >> catch \n' + e.message);
        }
        return json;
      },

      showAndSend: function (branchUrl, req, isAdminOperation, callback) {
        this.showUrl(isAdminOperation, branchUrl)
        vInput.value = JSON.stringify(req, null, '    ')
        this.showTestCase(false, this.isLocalShow)
        this.onChange(false)
        this.send(isAdminOperation, callback)
      },

      /**发送请求
       */
      send: function(isAdminOperation, callback, caseScript_, accountScript_, globalScript_, ignorePreScript) {
        if (this.isTestCaseShow) {
          alert('请先输入请求内容！')
          return
        }

        if (StringUtil.isEmpty(this.host, true)) {
          // if (StringUtil.get(vUrl.value).startsWith('http://') != true && StringUtil.get(vUrl.value).startsWith('https://') != true) {
          //   alert('URL 缺少 http:// 或 https:// 前缀，可能不完整或不合法，\n可能使用同域的 Host，很可能访问出错！')
          // }
        }
        else {
          if (StringUtil.get(vUrl.value).indexOf('://') >= 0) {
            alert('URL Host 已经隐藏(固定) 为 \n' + this.host + ' \n将会自动在前面补全，导致 URL 不合法访问出错！\n如果要改 Host，右上角设置 > 显示(编辑)URL Host')
          }
        }

        this.onHandle(vInput.value)

        clearTimeout(handler)

        if (this.isEditResponse) {
          this.onChange(false)
          return
        }

        try {
          var header = this.getHeader(vHeader.value)

          var req = this.getRequest(vInput.value, {})

          var url = this.getUrl()

          var httpReq = Object.assign({
            "package": this.getPackage(url),
            "class": this.getClass(url),
            "method": this.getMethod(url)
          }, req)

          vOutput.value = "requesting... \nURL = " + url

          errHandler = function () {
            vOutput.value = "requesting... \nURL = " + url + "\n\n可能" + ERR_MSG
          }
          setTimeout(errHandler, 5000)

          this.view = 'output';

          var caseScript = (caseScript_ != null ? caseScript_ : ((this.scripts || {}).case || {})[this.getCurrentDocumentId() || 0]) || {}

          this.setBaseUrl()
          this.request(isAdminOperation, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, this.project + '/method/invoke', httpReq, isAdminOperation ? {} : header, callback, caseScript, accountScript_, globalScript_, ignorePreScript)

          this.locals = this.locals || []
          if (this.locals.length >= 1000) { //最多1000条，太多会很卡
            this.locals.splice(999, this.locals.length - 999)
          }
          var method = this.getMethod()
          this.locals.unshift({
            'Method': {
              'userId': this.User.id,
              'name': this.formatDateTime() + (StringUtil.isEmpty(req.tag, true) ? '' : ' ' + req.tag),
              'operation': CodeUtil.getOperation(method, req),
              'method': this.getMethod(url),
              'class': this.getClass(url),
              'package': this.getPackage(url),
              'type': this.type,
              'url': method,
              'request': JSON.stringify(req, null, '    '),
              'header': vHeader.value,
              'scripts': this.scripts
            }
          })
          this.saveCache('', 'locals', this.locals)
        } catch (e) {
          this.onResponse(url, {}, e)
        }
      },

      //请求
      request: function (isAdminOperation, method, type, url, req, header, callback, caseScript_, accountScript_, globalScript_, ignorePreScript) {
        this.loadingCount ++

        const isEnvCompare = this.isEnvCompareEnabled

        const scripts = (isAdminOperation || caseScript_ == null ? null : this.scripts) || {}
        const globalScript = (isAdminOperation ? null : (globalScript_ != null ? globalScript_ : (scripts.global || {})[0])) || {}
        const accountScript = (isAdminOperation ? null : (accountScript_ != null ? accountScript_ : (scripts.account || {})[this.getCurrentAccountId() || 0])) || {}
        const caseScript = (isAdminOperation ? null : caseScript_) || {}

        var evalPostScript = function () {}

        var sendRequest = function (isAdminOperation, method, type, url, req, header, callback) {
          var hs = ""
          if (isDelegate && header != null) {
            for (var k in header) {
                var v = k == null ? null : header[k]
                if (k == null || k.toLowerCase() == 'apijson-delegate-id') {
                    continue
                }
                hs += '\n' + k + ': ' + (v instanceof Object ? JSON.stringify(v) : v)
            }
          }

          if (req != null && JSONResponse.getType(req) == 'object') { // 支持 URL 里有 Path Variable，例如 http://apijson.cn:8080/{method}/{table}
            var ind = -1 // 支持 ?id={id} 这种动态参数  url.indexOf('?')
            var uri = ind < 0 ? url : url.substring(0, ind)

            var newReq = {}
            for (var k in req) {
                var v = k == null ? null : req[k]
                var kind = uri.indexOf('{' + k + '}')
                if (kind >= 0) {
                   uri = uri.replaceAll('${' + k + '}', v).replaceAll('{{' + k + '}}', v).replaceAll('{' + k + '}', v)
                   continue
                }

                newReq[k] = v
            }

            url = uri + (ind < 0 ? '' : url.substring(ind))
            req = newReq
          }

          // axios.defaults.withcredentials = true
          axios({
            method: method != null ? method : (HTTP_METHODS.indexOf(type) >= 0 ? type.toLowerCase() : (type == REQUEST_TYPE_PARAM ? 'get' : 'post')),
            url: (isDelegate ? (
                  App.server + '/delegate?$_type=' + (type || REQUEST_TYPE_JSON)
                  + (StringUtil.isEmpty(App.delegateId, true) ? '' : '&$_delegate_id=' + App.delegateId)
                  + '&$_delegate_url=' + encodeURIComponent(url)
                  + (StringUtil.isEmpty(hs, true) ? '' : '&$_headers=' + encodeURIComponent(hs.trim()))
                ) : (
                  App.isEncodeEnabled ? encodeURI(url) : url
                )
            ),
            params: HTTP_URL_ARG_TYPES.indexOf(type) >= 0 ? req : null,
            data: HTTP_JSON_TYPES.indexOf(type) >= 0 ? req : (HTTP_FORM_DATA_TYPES.indexOf(type) >= 0 ? toFormData(req) : null),
            headers: header,  //Accept-Encoding（HTTP Header 大小写不敏感，SpringBoot 接收后自动转小写）可能导致 Response 乱码
            withCredentials: true, //Cookie 必须要  type == REQUEST_TYPE_JSON
            // crossDomain: true
          })
            .then(function (res) {
              App.currentHttpResponse = res
              clearTimeout(errHandler)
              var postEvalResult = evalPostScript(url, res, null)
              if (postEvalResult == BREAK_ALL) {
                return
              }

              App.loadingCount --
              res = res || {}

              if (isDelegate) {
                var hs = res.headers || {}
                var delegateId = hs['Apijson-Delegate-Id'] || hs['apijson-delegate-id']

                if (delegateId != null) {
                  if (isEnvCompare) {
                    if (delegateId != App.otherEnvDelegateId) {
                      App.otherEnvDelegateId = delegateId
                      App.saveCache(App.server, 'otherEnvDelegateId', delegateId)
                    }
                  } else {
                    if (delegateId != App.delegateId) {
                      App.delegateId = delegateId
                      App.saveCache(App.server, 'delegateId', delegateId)
                    }
                  }
                }
              }

              //any one of then callback throw error will cause it calls then(null)
              // if ((res.config || {}).method == 'options') {
              //   return
              // }
              if (DEBUG) {
                log('send >> success:\n' + JSON.stringify(res.data, null, '    '))
              }

              //未登录，清空缓存
              if (res.data != null && res.data.code == 407) {
                // alert('request res.data != null && res.data.code == 407 >> isAdminOperation = ' + isAdminOperation)
                if (isAdminOperation) {
                  // alert('request App.User = {} App.server = ' + App.server)

                  App.clearUser()
                }
                else {
                  // alert('request App.accounts[App.currentAccountIndex].isLoggedIn = false ')

                  if (App.accounts[App.currentAccountIndex] != null) {
                    App.accounts[App.currentAccountIndex].isLoggedIn = false
                  }
                }
              }

              if (postEvalResult == BREAK_LAST) {
                return
              }

              if (callback != null) {
                callback(url, res, null)
                return
              }
              App.onResponse(url, res, null)
            })
            .catch(function (err) {
              var errObj = err instanceof Array == false && err instanceof Object ? err : {}
              var res = {status: errObj.status || (errObj.response || {}).status, request: {url: url, headers: header, data: req}, data: (errObj.response || {}).data}
              App.currentHttpResponse = res

              var postEvalResult = evalPostScript(url, res, err)
              if (postEvalResult == BREAK_ALL) {
                return
              }

              App.loadingCount --

              log('send >> error:\n' + err)
              if (isAdminOperation) {
                App.delegateId = null
              }

              if (postEvalResult == BREAK_LAST) {
                return
              }

              if (callback != null) {
                callback(url, res, err)
                return
              }

              if (typeof App.autoTestCallback == 'function') {
                App.autoTestCallback('Error when testing: ' + err + '.\nurl: ' + url + ' \nrequest: \n' + JSON.stringify(req, null, '    '), err)
              }

              App.onResponse(url, {request: {url: url, headers: header, data: req}}, err)
            })
        }

        var evalScript = isAdminOperation || caseScript_ == null ? function () {} : function (isPre, code, res, err) {
          var logger = console.log
          console.log = function(msg) {
            logger(msg)
            vOutput.value = StringUtil.get(msg)
          }

          App.view = 'output'
          vOutput.value = ''

          try {
//             var s = `(function () {
// var App = ` + App + `;
//
// var type = ` + type + `;
// var url = ` + url + `;
// var req = ` + (req == null ? null : JSON.stringify(req)) + `;
// var header = ` + (header == null ? null : JSON.stringify(header)) + `;
//
// ` + (isPre ? '' : `
// // var res = ` + (res == null ? null : JSON.stringify(res)) + `;
// var data = ` + (res == null || res.data == null ? null : JSON.stringify(res.data)) + `;
// var err = ` + (err == null ? null : JSON.stringify(err)) + `;
//
// `) + code + `
//           })()`
//
//             eval(s)

            var isTest = false;
            var isInject = false;
            var data = res == null ? null : res.data
            var result = eval(code)
            console.log = logger
            return result
          }
          catch (e) {
            console.log(e);
            console.log = logger

            App.loadingCount --

            // TODO if (isPre) {
            App.view = 'error'
            App.error = {
              msg: '执行脚本报错：\n' + e.message
            }

            if (callback != null) {
              callback(url, res, e)
            } else {
              // catch 中也 evalScript 导致死循环
              // if (isPre != true) {
              //   throw e
              // }

              // TODO 右侧底部新增断言列表
              App.onResponse(url, null, new Error('执行脚本报错：\n' + e.message)) // this.onResponse is not a function
              // callback = function (url, res, err) {}  // 仅仅为了后续在 then 不执行 onResponse
            }
          }

          return BREAK_ALL
        }

        // const preScript = function () {
        //   if (isAdminOperation) {
        //     return
        //   }

          var preScript = ''

          var globalPreScript = isAdminOperation || ignorePreScript || caseScript_ == null ? null : StringUtil.trim((globalScript.pre || {}).script)
          if (StringUtil.isNotEmpty(globalPreScript, true)) {
            preScript += globalPreScript + '\n\n' // evalScript(true, globalPreScript)
          }

          var accountPreScript = isAdminOperation || ignorePreScript || caseScript_ == null ? null : StringUtil.trim((accountScript.pre || {}).script)
          if (StringUtil.isNotEmpty(accountPreScript, true)) {
            preScript += accountPreScript + '\n\n' // evalScript(true, accountPreScript)
          }

          var casePreScript = isAdminOperation || ignorePreScript || caseScript_ == null ? null : StringUtil.trim((caseScript.pre || {}).script)
          if (StringUtil.isNotEmpty(casePreScript, true)) {
            preScript += casePreScript + '\n\n' // evalScript(true, casePreScript)
          }

          var preEvalResult = null;
          if (StringUtil.isNotEmpty(preScript, true)) {
            preEvalResult = evalScript(true, preScript)
          }

        // }

        evalPostScript = isAdminOperation || caseScript_ == null ? function () {} : function (url, res, err) {
          var postScript = ''

          var casePostScript = StringUtil.trim((caseScript.post || {}).script)
          if (StringUtil.isNotEmpty(casePostScript, true)) {
            postScript += casePostScript + '\n\n' // evalScript(false, casePostScript, res, err)
          }

          var accountPostScript = StringUtil.trim((accountScript.post || {}).script)
          if (StringUtil.isNotEmpty(accountPostScript, true)) {
            postScript += accountPostScript + '\n\n' // evalScript(false, accountPostScript, res, err)
          }

          var globalPostScript = StringUtil.trim((globalScript.post || {}).script)
          if (StringUtil.isNotEmpty(globalPostScript, true)) {
            postScript += globalPostScript + '\n\n' // evalScript(false, globalPostScript, res, err)
          }

          if (StringUtil.isNotEmpty(postScript, true)) {
            if (StringUtil.isNotEmpty(preScript, true)) { // 如果有副作用代码，则通过判断 if (isPre) {..} 在里面执行
              postScript = preScript + '\n\n// request >>>>>>>>>>>>>>>>>>>>>>>>>> response \n\n' + postScript
            }

            return evalScript(false, postScript, res, err)
          }

          return null;
        }

        if (preEvalResult == BREAK_ALL) {
          return
        }

        type = type || REQUEST_TYPE_JSON
        url = StringUtil.noBlank(url)
        if (url.startsWith('/')) {
          url = (isAdminOperation ? this.server : this.project) + url
        }

        var isDelegate = (isAdminOperation == false && this.isDelegateEnabled) || (isAdminOperation && url.indexOf('://apijson.cn:9090') > 0)

        if (header != null && header.Cookie != null) {
          if (isDelegate) {
            header['Set-Cookie'] = header.Cookie
            delete header.Cookie
          }
          else if (IS_BROWSER) {
            document.cookie = header.Cookie
          }
        } else if (IS_NODE) {
          var curUser = isAdminOperation ? this.User : this.getCurrentAccount()
          if (curUser != null && curUser[isEnvCompare ? 'phone' : 'cookie'] != null) {
            if (header == null) {
              header = {}
            }

            // Node 环境内通过 headers 设置 Cookie 无效
            header.Cookie = isEnvCompare ? this.otherEnvCookieMap[curUser.phone] : curUser.cookie
          }
        }

        var delegateId = isEnvCompare ? this.otherEnvDelegateId : this.delegateId
        if (isDelegate && delegateId != null && (header == null || header['Apijson-Delegate-Id'] == null)) {
          if (header == null) {
            header = {};
          }
          header['Apijson-Delegate-Id'] = delegateId
        }


        if (IS_NODE) {
          if (DEBUG) {
          log('req = ' + JSON.stringify(req, null, '  '))
          }
          // 低版本 node 报错 cannot find module 'node:url' ，高版本报错 TypeError: axiosCookieJarSupport is not a function
          //   const axiosCookieJarSupport = require('axios-cookiejar-support').default;
          //   const tough = require('tough-cookie');
          //   axiosCookieJarSupport(axios);
          //   const cookieJar = new tough.CookieJar();
          //   axios.defaults.jar = cookieJar;
          //   axios.defaults.withCredentials = true;

          // const {parse, stringify, toJSON, fromJSON} = require('flatted');
          // JSON.stringify = stringify;
          // JSON.parse = parse;

          // const CircularJSON = require('circular-json');
          // JSON.stringify = CircularJSON.stringify;
          // JSON.parse = CircularJSON.parse;
        }

        if (preEvalResult == BREAK_LAST) {
          return
        }

        sendRequest(isAdminOperation, method, type, url, req, header, callback)
      },


      /**请求回调
       */
      onResponse: function (url, res, err) {
        if (res == null) {
          res = {}
        }
        if (DEBUG) {
          log('onResponse url = ' + url + '\nerr = ' + err + '\nreq = \n'
            + (res.request == null || res.request.data == null ? 'null' : JSON.stringify(res.request.data))
            + '\n\nres = \n' + (res.data == null ? 'null' : JSON.stringify(res.data))
          )
        }

        if (err != null) {
          if (IS_BROWSER) {
            var errObj = err instanceof Array == false && err instanceof Object ? err : {}
            var data = (errObj.response || {}).data
            var msg = typeof data == 'string' ? StringUtil.trim(data) : JSON.stringify(data, null, '    ')
            msg = "Response:\nurl = " + url + "\nerror = " + err.message + (StringUtil.isEmpty(msg) ? '' : '\n\n' + msg) + '\n\n' + ERR_MSG
            // vOutput.value = "Response:\nurl = " + url + "\nerror = " + err.message;
            this.view = 'error';
            this.error = {
              msg: msg
            }
            this.output = msg
          }
        }
        else {
          if (IS_BROWSER) {
            var data = res.data || {}
            var isStr = typeof data == 'string'
            if (isSingle && (isStr != true) && data instanceof Object && (data instanceof Array == false) && JSONResponse.isSuccess(data)) { //不格式化错误的结果
              data = JSONResponse.formatObject(data);
            }
            this.jsoncon = isStr ? data : JSON.stringify(data, null, '    ')
            this.view = 'code' // isStr ? 'output' : 'code'

            vOutput.value = isStr ? data : ''
          }

          // 会导致断言用了这个
          // if (this.currentRemoteItem == null) {
          //   this.currentRemoteItem = {}
          // }
          // if (this.currentRemoteItem.TestRecord == null) {
          //   this.currentRemoteItem.TestRecord = {}
          // }
          // this.currentRemoteItem.TestRecord.response = data
        }
      },


      /**处理复制事件
       * @param event
       */
      doOnCopy: function(event) {
        var target = event.target;
        var selectionStart = target.selectionStart;
        var selectionEnd = target.selectionEnd;

        if (target == vUrl) {
          try {
            var contentType = CONTENT_TYPE_MAP[this.type];
            var json = this.getRequest(vInput.value)
            var header = this.getHeader(vHeader.value);
            var headerStr = '';
            if (header != null) {
              for (var k in header) {
                var v = header[k];
                headerStr += '\n' + k + ': ' + StringUtil.get(v);
              }
            }

            console.log('复制时自动转换:\n'
            + `Request URL: ` + vUrl.value + `
Request Method: ` + (this.type == REQUEST_TYPE_PARAM ? 'GET' : 'POST') + (StringUtil.isEmpty(contentType, true) ? '' : `
Content-Type: ` + contentType) + (StringUtil.isEmpty(headerStr, true) ? '' : headerStr)
              + '\n\n' + JSON.stringify(json));
          } catch (e) {
            log(e)
          }
        }
        else if (target == vHeader || target == vRandom) {  // key: value 转 { "key": value }
          if (selectionStart < 0 || selectionStart <= selectionEnd) {
            try {
              var selection = selectionStart < 0 ? target.value : StringUtil.get(target.value).substring(selectionStart, selectionEnd);
              var lines = StringUtil.split(selection, '\n');
              var json = {};

              for (var i = 0; i < lines.length; i ++) {
                var l = StringUtil.trim(lines[i]) || '';
                if (l.startsWith('//')) {
                  continue;
                }

                var ind = l.lastIndexOf(' //');
                l = ind < 0 ? l : StringUtil.trim(l.substring(0, ind));

                ind = l.indexOf(':');
                if (ind >= 0) {
                  var left = target == vHeader ? StringUtil.trim(l.substring(0, ind)) : l.substring(0, ind);
                  json[left] = StringUtil.trim(l.substring(ind + 1));
                }
              }

              if (Object.keys(json).length > 0) {
                var txt = JSON.stringify(json)
                console.log('复制时自动转换:\n' +  txt)
                navigator.clipboard.writeText(selection + '\n\n' + txt);
                alert('复制内容最后拼接了，控制台 Console 也打印了：\n' + txt);
              }
            } catch (e) {
              log(e)
            }
          }
        }

      },

      /**处理粘贴事件
       * @param event
       */
      doOnPaste: function(event) {
        var paste = (event.clipboardData || window.clipboardData || navigator.clipboard).getData('text');
        var target = event.target;
        var selectionStart = target.selectionStart;
        var selectionEnd = target.selectionEnd;

        if (StringUtil.isNotEmpty(paste, true) && (StringUtil.isEmpty(target.value, true)
          || selectionStart <= 0 && selectionEnd >= StringUtil.get(target.value).length)) {
          if (target == vUrl) {  // TODO 把 Chrome 或 Charles 等抓到的 Response Header 和 Content 自动粘贴到 vUrl, vHeader
            try {
              if (paste.trim().indexOf('\n') > 0) {  // 解决正常的 URL 都粘贴不了
                var contentStart = 0;
                var lines = StringUtil.split(paste, '\n');
                var header = '';

                for (var i = 0; i < lines.length; i++) {
                  var l = StringUtil.trim(lines[i]);
                  var ind = l.indexOf(':');
                  var left = ind < 0 ? '' : StringUtil.trim(l.substring(0, ind));

                  if (/^[a-zA-Z0-9\- ]+$/g.test(left)) {
                    var lowerKey = left.toLowerCase();
                    var value = l.substring(ind + 1).trim();

                    if (lowerKey == 'host') {
                      this.setBaseUrl(value.endsWith(':443') ? 'https://' + value.substring(0, value.length - ':443'.length) : 'http://' + value);
                      event.preventDefault();
                    }
                    else if (lowerKey == 'request method') {
                      value = value.toUpperCase();
                      // this.method = value
                      // this.type = value == 'GET' ? 'PARAM' : (value == 'POST' ? 'JSON' : value);
                      event.preventDefault();
                    }
                    else if (lowerKey == 'content-type') {
                      var type = vType.value != 'JSON' ? null : CONTENT_VALUE_TYPE_MAP[value];
                      if (StringUtil.isEmpty(type, true) != true) {
                        this.type = type;
                        event.preventDefault();
                      }
                    }
                    else if (lowerKey == 'request url') {
                      vUrl.value = value;
                      event.preventDefault();
                    }
                    else if (StringUtil.isEmpty(lowerKey, true) || lowerKey.startsWith('accept-')
                      || lowerKey.startsWith('access-control-') || IGNORE_HEADERS.indexOf(lowerKey) >= 0) {
                      // 忽略
                    }
                    else {
                      header += '\n' + left + ': ' + StringUtil.trim(l.substring(ind + 1));
                    }

                    contentStart += lines[i].length + 1;
                  }
                  else {
                    if (ind <= 0 || StringUtil.isEmpty(l) || l.startsWith('HTTP/') || l.startsWith('HTTPS/')) {  // HTTP/1.1 200
                      contentStart += lines[i].length + 1;
                      continue;
                    }

                    var ind = l.indexOf(' ');
                    var m = ind < 0 ? '' : StringUtil.trim(l.substring(0, ind));
                    if (APIJSON_METHODS.indexOf(m.toLowerCase()) >= 0) {  // POST /gets HTTP/1.1
                      contentStart += lines[i].length + 1;
                      var t = m.toUpperCase()
                      // this.method = t
                      // this.type = t == 'GET' ? 'PARAM' : (t == 'POST' ? 'JSON' : t);

                      l = l.substring(ind).trim();
                      ind = l.indexOf(' ');
                      var url = ind < 0 ? l : l.substring(0, ind);
                      if (url.length > 0 && url != '/') {
                        vUrl.value = this.getBaseUrl() + (url.startsWith('/') ? url : '/' + url);
                      }

                      event.preventDefault();
                      continue;
                    }

                    var content = StringUtil.trim(paste.substring(contentStart));
                    var json = null;
                    try {
                      json = JSON5.parse(content);  // { "a":1, "b": "c" }
                    }
                    catch (e) {
                      log(e)
                      try {
                        json = getRequestFromURL('?' + content, true);  // a=1&b=c
                      } catch (e2) {
                        log(e2)
                      }
                    }

                    vInput.value = json == null ? '' : JSON.stringify(json, null, '    ');
                    event.preventDefault();
                    break;
                  }

                }

                if (StringUtil.isEmpty(header, true) != true) {
                  vHeader.value = StringUtil.trim(header);
                  event.preventDefault();
                }
              }
            }
            catch (e) {
              log(e)
            }
          }
          else if (target == vHeader || target == vRandom) {  // { "key": value } 转 key: value
            try {
              var json = JSON5.parse(paste);
              var newStr = '';
              for (var k in json) {
                var v = json[k];
                if (v instanceof Object || v instanceof Array) {
                  v = JSON.stringify(v);
                }
                newStr += '\n' + k + ': ' + (target != vHeader && typeof v == 'string' ? "'" + v.replaceAll("'", "\\'") + "'" : StringUtil.get(v));
              }
              target.value = StringUtil.trim(newStr);
              event.preventDefault();
            }
            catch (e) {
              log(e)
            }
          }
          else if (target == vInput) {  // key: value 转 { "key": value }
            try {
              try {
                JSON5.parse(paste);  // 正常的 JSON 就不用转了
              }
              catch (e) {
                var lines = StringUtil.split(paste, '\n');
                var json = {};

                for (var i = 0; i < lines.length; i++) {
                  var l = StringUtil.trim(lines[i]) || '';
                  if (l.startsWith('//')) {
                    continue;
                  }

                  var ind = l.lastIndexOf(' //');
                  l = ind < 0 ? l : StringUtil.trim(l.substring(0, ind));

                  ind = l.indexOf(':');
                  if (ind >= 0) {
                    var left = target == vHeader ? StringUtil.trim(l.substring(0, ind)) : l.substring(0, ind);
                    if (left.indexOf('=') >= 0 || left.indexOf('&') >= 0) {
                      try {
                        json = getRequestFromURL('?' + paste, true);
                        if (Object.keys(json).length > 0) {
                          break;
                        }
                      } catch (e2) {
                        log(e)
                      }
                    }

                    json[left] = StringUtil.trim(l.substring(ind + 1));
                  }
                }

                if (Object.keys(json).length <= 0) {
                  json = getRequestFromURL('?' + paste, true);
                }

                if (Object.keys(json).length > 0) {
                  vInput.value = JSON.stringify(json, null, '    ');
                  event.preventDefault();
                }
              }
            }
            catch (e) {
              log(e)
            }
          }
        }

      },

      /**处理按键事件
       * @param event
       */
      doOnKeyUp: function (event, type, isFilter, item) {
        var keyCode = event.keyCode ? event.keyCode : (event.which ? event.which : event.charCode);
        if (type == 'option') {
          if (keyCode == 13) {
            this.selectInput(item);
          }
          return
        }

        if (isFilter && type == 'caseGroup') {
          this.isCaseGroupEditable = true
        }
        var obj = event.srcElement ? event.srcElement : event.target;
        if ($(obj).attr('id') == 'vUrl') {
          vUrlComment.value = ''
          this.currentDocItem = null
          this.currentRemoteItem = null
        }

        if (keyCode == 13) { // enter
          if (isFilter) {
            this.onFilterChange(type)
            return
          }

          if (type == null) {
// 无效，这时已经换行了           if (event.target == vUrl) {
//               event.preventDefault();
//            }
            this.send(false);
            return
          }

          if (type == 'caseGroup') {
            var groupUrl = item == null ? null : item.groupUrl
            var rawName = item == null ? null : item.rawName
            this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, this.server + '/put', {
              Method: {
                'group': item.groupName,
                'package{}': [groupUrl],
                'group{}': rawName == null ? "=null" : [rawName]
              },
              tag: 'Method-group'
            }, {}, function (url, res, err) {
              App.onResponse(url, res, err)
              var isOk = JSONResponse.isSuccess(res.data)

              var msg = isOk ? '' : ('\nmsg: ' + StringUtil.get((res.data || {}).msg))
              if (err != null) {
                msg += '\nerr: ' + err.msg
              }
              alert('修改' + (isOk ? '成功' : '失败') + '！\ngroupUrl: ' + item.groupUrl + '\ngroupName: ' + item.groupName + '\nrawName: ' + item.rawName + msg)

              App.isCaseGroupEditable = ! isOk
            })

            return
          }

          if (type == 'random' || type == 'randomSub') {
            var r = item == null ? null : item.Random
            if (r == null || r.id == null) {
              alert('请选择有效的选项！item.Random.id == null !')
              return
            }

            //修改 Random 的 count
            this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, this.server + '/put', {
              Random: {
                id: r.id,
                count: r.count,
                name: r.name
              },
              tag: 'Random'
            }, {}, function (url, res, err) {
              App.onResponse(url, res, err)
              var isOk = JSONResponse.isSuccess(res.data)

              var msg = isOk ? '' : ('\nmsg: ' + StringUtil.get((res.data || {}).msg))
              if (err != null) {
                msg += '\nerr: ' + err.msg
              }
              alert('修改' + (isOk ? '成功' : '失败') + '！\ncount: ' + r.count + '\nname: ' + r.name + msg)

              App.isRandomEditable = ! isOk
            })

            return
          }

        }
        else {
          if (isFilter) {
            return
          }
          if (type == 'random' || type == 'randomSub') {
            this.isRandomEditable = true
            return
          }
          if (type == 'document' || type == 'testCase') {
            return
          }

          this.urlComment = '';
          this.requestVersion = '';
          this.onChange(true);
        }
      },

      pageDown: function(type) {
        type = type || ''
        var page
        switch (type) {
          case 'caseGroup':
            page = this.caseGroupPage
            break
          case 'testCase':
            page = this.testCasePage
            break
          case 'random':
            page = this.randomPage
            break
          case 'randomSub':
            page = this.randomSubPage
            break
          default:
            page = this.page
            break
        }

        if (page == null) {
          page = 0
        }

        if (page > 0) {
          page --
          switch (type) {
            case 'caseGroup':
              this.caseGroupPage = page
              break
            case 'testCase':
              this.testCasePage = page
              break
            case 'random':
              this.randomPage = page
              break
            case 'randomSub':
              this.randomSubPage = page
              break
            default:
              this.page = page
              break
          }

          this.onFilterChange(type)
        }
      },
      pageUp: function(type) {
        type = type || ''
        switch (type) {
          case 'caseGroup':
            this.caseGroupPage ++
            break
          case 'testCase':
            this.testCasePage ++
            break
          case 'random':
            this.randomPage ++
            break
          case 'randomSub':
            this.randomSubPage ++
            break
          default:
            this.page ++
            break
        }
        this.onFilterChange(type)
      },
      onFilterChange: function(type) {
        type = type || ''
        if (type == 'testCase' || type == 'caseGroup') {
          var index = this.casePaths.length - 1
          var group = this.casePaths[index]
          var groupUrl = group == null ? '' : (group.groupUrl || '')
          if (type == 'caseGroup') {
            this.caseGroupPages[groupUrl] = this.caseGroupPage
            this.caseGroupCounts[groupUrl] = this.caseGroupCount
            this.caseGroupSearches[groupUrl] = this.caseGroupSearch
            if (index < 0) {
              this.saveCache(this.server, 'caseGroupPage', this.caseGroupPage)
              this.saveCache(this.server, 'caseGroupCount', this.caseGroupCount)
            }
            this.saveCache(this.server, 'caseGroupPages', this.caseGroupPages)
            this.saveCache(this.server, 'caseGroupCounts', this.caseGroupCounts)
            this.selectCaseGroup()
          }
          else {
            this.testCasePages[groupUrl] = this.testCasePage
            this.testCaseCounts[groupUrl] = this.testCaseCount
            this.testCaseSearches[groupUrl] = this.testCaseSearch
            if (index < 0) {
            this.saveCache(this.server, 'testCasePage', this.testCasePage)
            this.saveCache(this.server, 'testCaseCount', this.testCaseCount)
            }
            this.saveCache(this.server, 'testCasePages', this.testCasePages)
            this.saveCache(this.server, 'testCaseCounts', this.testCaseCounts)

            this.resetTestCount(this.currentAccountIndex)

            this.remotes = null
            this.showTestCase(true, false)
          }
        }
        else if (type == 'random') {
            this.saveCache(this.server, 'randomPage', this.randomPage)
            this.saveCache(this.server, 'randomCount', this.randomCount)

            this.resetTestCount(this.currentAccountIndex, true)

            var cri = this.currentRemoteItem || {}
            cri.randoms = null
            this.randoms = null
          this.showRandomList(true, cri.Method, false)
        }
        else if (type == 'randomSub') {
            this.saveCache(this.server, 'randomSubPage', this.randomSubPage)
            this.saveCache(this.server, 'randomSubCount', this.randomSubCount)

            this.resetTestCount(this.currentAccountIndex, true, true)

            var cri = this.currentRandomItem || {}
            this.randomSubs = null
            this.showRandomList(true, cri.Random, true)
        }
        else {
            docObj = null
            doc = null
            this.saveCache(this.server, 'page', this.page)
            this.saveCache(this.server, 'count', this.count)
            // this.saveCache(this.server, 'docObj', null)
            // this.saveCache(this.server, 'doc', null)

            this.onChange(false)

            //虽然性能更好，但长时间没反应，用户会觉得未生效
            // this.getDoc(function (d) {
            //   // vOutput.value = 'resolving...';
            //   App.setDoc(d)
            //   App.onChange(false)
            // });
        }
      },

      /**转为请求代码
       * @param rq
       */
      getCode: function (rq) {
        var s = '\n\n\n### 请求代码(自动生成) \n';
        switch (this.language) {
          case CodeUtil.LANGUAGE_KOTLIN:
            s += '\n#### <= Android-Kotlin: 空对象用 HashMap&lt;String, Any&gt;()，空数组用 ArrayList&lt;Any&gt;()\n'
              + '```kotlin \n'
              + CodeUtil.parseKotlinRequest(null, JSON.parse(rq), 0, isSingle, false, false, this.type, this.getBaseUrl(), '/' + this.getMethod(), this.urlComment)
              + '\n ``` \n注：对象 {} 用 mapOf("key": value)，数组 [] 用 listOf(value0, value1)\n';
            break;
          case CodeUtil.LANGUAGE_JAVA:
            s += '\n#### <= Android-Java: 同名变量需要重命名'
              + ' \n ```java \n'
              + StringUtil.trim(CodeUtil.parseJavaRequest(null, JSON.parse(rq), 0, isSingle, false, false, this.type, '/' + this.getMethod(), this.urlComment))
              + '\n ``` \n注：' + (isSingle ? '用了 APIJSON 的 JSONRequest, JSONResponse 类，也可使用其它类封装，只要 JSON 有序就行\n' : 'LinkedHashMap&lt;&gt;() 可替换为 fastjson 的 JSONObject(true) 等有序JSON构造方法\n');

            var serverCode = CodeUtil.parseJavaServer(this.type, '/' + this.getMethod(), this.database, this.schema, JSON.parse(rq), isSingle);
            if (StringUtil.isEmpty(serverCode, true) != true) {
              s += '\n#### <= Server-Java: RESTful 等非 APIJSON 规范的 API'
                + ' \n ```java \n'
                + serverCode
                + '\n ``` \n注：' + (isSingle ? '分页和排序用了 Mybatis-PageHelper，如不需要可在生成代码基础上修改\n' : '使用 SSM(Spring + SpringMVC + Mybatis) 框架 \n');
            }
            break;
          case CodeUtil.LANGUAGE_C_SHARP:
            s += '\n#### <= Unity3D-C\#: 键值对用 {"key", value}' +
              '\n ```csharp \n'
              + CodeUtil.parseCSharpRequest(null, JSON.parse(rq), 0)
              + '\n ``` \n注：对象 {} 用 new JObject{{"key", value}}，数组 [] 用 new JArray{value0, value1}\n';
            break;

          case CodeUtil.LANGUAGE_SWIFT:
            s += '\n#### <= iOS-Swift: 空对象用 [ : ]'
              + '\n ```swift \n'
              + CodeUtil.parseSwiftRequest(null, JSON.parse(rq), 0)
              + '\n ``` \n注：对象 {} 用 ["key": value]，数组 [] 用 [value0, value1]\n';
            break;
          case CodeUtil.LANGUAGE_OBJECTIVE_C:
            s += '\n#### <= iOS-Objective-C \n ```objective-c \n'
              + CodeUtil.parseObjectiveCRequest(null, JSON.parse(rq))
              + '\n ```  \n';
            break;

          case CodeUtil.LANGUAGE_GO:
            s += '\n#### <= Web-Go: 对象 key: value 会被强制排序，每个 key: value 最后都要加逗号 ","'
              + ' \n ```go \n'
              + CodeUtil.parseGoRequest(null, JSON.parse(rq), 0)
              + '\n ``` \n注：对象 {} 用 map[string]interface{} {"key": value}，数组 [] 用 []interface{} {value0, value1}\n';
            break;
          case CodeUtil.LANGUAGE_C_PLUS_PLUS:
            s += '\n#### <= Web-C++: 使用 RapidJSON'
              + ' \n ```cpp \n'
              + StringUtil.trim(CodeUtil.parseCppRequest(null, JSON.parse(rq), 0, isSingle))
              + '\n ``` \n注：std::string 类型值需要判断 RAPIDJSON_HAS_STDSTRING\n';
            break;

          case CodeUtil.LANGUAGE_PHP:
            s += '\n#### <= Web-PHP: 空对象用 (object) ' + (isSingle ? '[]' : 'array()')
              + ' \n ```php \n'
              + CodeUtil.parsePHPRequest(null, JSON.parse(rq), 0, isSingle)
              + '\n ``` \n注：对象 {} 用 ' + (isSingle ? '[\'key\' => value]' : 'array("key" => value)') + '，数组 [] 用 ' + (isSingle ? '[value0, value1]\n' : 'array(value0, value1)\n');
            break;

          case CodeUtil.LANGUAGE_PYTHON:
            s += '\n#### <= Web-Python: 注释符用 \'\#\''
              + ' \n ```python \n'
              + CodeUtil.parsePythonRequest(null, JSON.parse(rq), 0, isSingle, vInput.value)
              + '\n ``` \n注：关键词转换 null: None, false: False, true: True';
            break;

          //以下都不需要解析，直接用左侧的 JSON
          case CodeUtil.LANGUAGE_TYPE_SCRIPT:
          case CodeUtil.LANGUAGE_JAVA_SCRIPT:
          //case CodeUtil.LANGUAGE_PYTHON:
            s += '\n#### <= Web-JavaScript/TypeScript: 和左边的请求 JSON 一样 \n';
            break;
          default:
            s += '\n没有生成代码，可能生成代码(封装,解析)的语言配置错误。\n';
            break;
        }

        if (((this.User || {}).id || 0) > 0) {
          s += '\n\n#### 开放源码 '
            + '\nAPIJSON 接口测试: https://github.com/TommyLemon/APIAuto '
            + '\nAPIJSON 单元测试: https://github.com/TommyLemon/UnitAuto '
            + '\nAPIJSON 中文文档: https://github.com/vincentCheng/apijson-doc '
            + '\nAPIJSON 英文文档: https://github.com/ruoranw/APIJSONdocs '
            + '\nAPIJSON 官方网站: https://github.com/APIJSON/apijson.cn '
            + '\nAPIJSON -Java版: https://github.com/Tencent/APIJSON '
            + '\nAPIJSON - C# 版: https://github.com/liaozb/APIJSON.NET '
            + '\nAPIJSON - Go 版: https://github.com/glennliao/apijson-go '
            + '\nAPIJSON - PHP版: https://github.com/kvnZero/hyperf-APIJSON '
            + '\nAPIJSON -Node版: https://github.com/kevinaskin/apijson-node '
            + '\nAPIJSON -Python: https://github.com/zhangchunlin/uliweb-apijson '
            + '\n感谢热心的作者们的贡献，GitHub 右上角点 ⭐Star 支持下他们吧 ^_^';
        }

        return s;
      },


      /**显示文档
       * @param d
       **/
      setDoc: function (d) {
        if (d == null) { //解决死循环 || d == '') {
          return false;
        }
        doc = d;
        var url = StringUtil.trim((this.coverage || {}).url)
        if (url != null && url.startsWith('/')) {
          url = this.project + url
          this.view = 'html'
          vHtml.innerHTML = '<iframe width="100%" height="100%" src="' + url + '"></iframe><br>'
          return true
        }
        var html = null // (this.coverage || {}).html
        if (StringUtil.isEmpty(html) != true) {
          this.view = 'html'
          vHtml.innerHTML = html
          return true
        }

        vOutput.value = (StringUtil.isEmpty(url, true) ? (StringUtil.isEmpty(html, true) ? '' : StringUtil.trim(html) + '<br>') : '<iframe src="' + url + '"></iframe><br>')
          + (this.isTestCaseShow ? '' : output) + (
          '\n\n\n## 包和类文档\n自动查数据库表和字段属性来生成 \n\n' + d
          + '<h3 align="center">关于</h3>'
          + '<p align="center">UnitAuto-零代码单元测试'
          + '<br>机器学习自动化测试、一键导入单元测试用例、自动生成复杂参数组合'
          + '<br>由 <a href="https://github.com/TommyLemon/UnitAuto" target="_blank">UnitAuto-Admin(前端网页工具)</a>, <a href="https://github.com/Tencent/APIJSON" target="_blank">APIJSON(后端接口服务)</a> 等提供技术支持'
          + '<br>遵循 <a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">Apache-2.0 开源协议</a>'
          + '<br>Copyright &copy; 2020-' + new Date().getFullYear() + ' Tommy Lemon'
          + '<br><a href="https://beian.miit.gov.cn/" target="_blank"><span >粤ICP备18005508号-1</span></a>'
          + '</p><br><br>'
        );

        this.view = 'markdown';
        markdownToHTML(vOutput.value);
        return true;
      },


      /**
       * 获取文档
       */
      getDoc: function (callback) {

      	var isTSQL = ['ORACLE', 'DAMENG'].indexOf(this.database) >= 0
      	var isNotTSQL = ! isTSQL
        var count = this.count || 15  //超过就太卡了
        var page = this.page || 0

        var search = StringUtil.isEmpty(this.search, true) ? null : StringUtil.trim(this.search)
        var condition = {
        	'len&{}': this.database == 'SQLSERVER' ? "len(package)>0;len(class)>0;len(method)>0": "length(package)>0;length(class)>0;length(method)>0",
        	'package%$': search,
          'class%$': search,
//         'method%$': search,
           '@combine': StringUtil.isEmpty(search) ? null : 'package%$ | class%$'  // 'package%$ | class%$ | method%$'
        }

        this.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,this.server + '/get', {
          format: false,
          '@database': this.database,
          '@schema': this.schema,
          '[]': {
//          'query': 2,  // 可能 DISTINCT 关键词加空格导致拼接成了 count(*)
            'count': count,
            'page': page,
            'Method': Object.assign({
              '@column': 'DISTINCT package',
              '@order': 'package-'
            }, condition),
//            'Method[]': {
//              'query': 2,
//              'count': 0,
//              'Method': {
//                '@from@': {
//                  'from': 'Method',
//                  'join': '</Method:count',
//                  'Method': {
//                    'package@': '[]/Method/package',
//                    'class{}': "length(class)>0",
//                    'package%$': search,
//                    'class%$': search,
//                    '@combine': StringUtil.isEmpty(search) ? null : 'package%$ | class%$',
//                    '@order': 'class+,constructor+,genericClassArgs+',
//                    'arguments()': 'getMethodArguments(genericClassArgs)',
//			          'Method:count': {
//			            'package@': '[]/Method/package',
//			            'class@': "/class",
//			            '@column': "count(1):methodTotal"
//			          }
//                  },
//                  'Method:count': {
//                    'package@': '[]/Method/package',
//                    'class@': "/Method/class",
//                    '@column': "count(1):methodTotal"
//                  }
//                }
//              }
//            },
//          'total@': '/Method[]/total'
            '[]': {
            	'query': 2,
            	'count': 5,
            	'Method': Object.assign({
            		'package@': '[]/Method/package',
            		'@raw': '@column',
            		'@column': "DISTINCT package,class,constructor;(CASE genericClassArgs WHEN '[]' THEN NULL ELSE genericClassArgs END):genericClassArgs",
            		'@order': 'class+,constructor+,genericClassArgs+',
            		// 'arguments()': 'getMethodArguments(genericClassArgs)'
            	}, condition),
            	'Method:count': Object.assign({
            		'package@': '[]/Method/package',
            		'class@': "/Method/class",
//            		'constructor@': '/Method/constructor',
//            		'genericClassArgs@': '/Method/genericClassArgs',
            		'@column': "count(1):total"
            	}, condition)
            },
            'total@': '/[]/total'
          },
//          'total@': '/[]/total',
          'Method:package': Object.assign({
              '@column': 'count(DISTINCT package):total'
          }, condition),
          'Method:class': Object.assign({
              '@column': 'count(DISTINCT package,class):total'
          }, condition),
          'Method:method': Object.assign({
        	  '@column': 'count(DISTINCT package,class,method):total'
          }, condition)
        }, {}, function (url, res, err) {
          App.onDocumentListResponse(url, res, err, callback)
        })
      },

      onDocumentListResponse: function(url, res, err, callback) {
        if (err != null || res == null || res.data == null) {
          log('getDoc  err != null || res == null || res.data == null >> return;');
          if (callback != null) {
            callback('')
          }
          return;
        }

//        log('getDoc  docRq.responseText = \n' + docRq.responseText);
        docObj = res.data || {};  //避免后面又调用 onChange ，onChange 又调用 getDoc 导致死循环

          var finalCallback = function (url2, res2, err2) {
        	  var data2 = (res2 || {}).data || {}
        	  var realPackageTotal = data2.packageTotal || 0
        	  var realClassTotal = data2.classTotal || 0
        	  var realMethodTotal = data2.methodTotal || 0

        	  //转为文档格式

        	  //[] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        	  var packageTotal = (docObj['Method:package'] || {}).total || 0
        	  var classTotal = (docObj['Method:class'] || {}).total || 0
        	  var methodTotal = (docObj['Method:method'] || {}).total || 0
        	  var doc = App.getTotalAndCoverageString('包', packageTotal, realPackageTotal)
        	  + '\n' +  App.getTotalAndCoverageString('类', classTotal, realClassTotal)
        	  + '\n' +  App.getTotalAndCoverageString('方法', methodTotal, realMethodTotal)

        	  var list = docObj == null ? null : docObj['[]'];
        	  CodeUtil.tableList = list;
        	  if (list != null) {
        		  if (DEBUG) {
        			  log('getDoc  [] = \n' + format(JSON.stringify(list)));
        		  }

        		  for (var i = 0; i < list.length; i++) {
        			  var item = list[i];

        			  //package
        			  var table = item == null ? null : item.Method
        			  var pkg = table == null ? null : table['package']
        			  if (StringUtil.isEmpty(pkg, true)) {
        				  continue;
        			  }

        			  if (DEBUG) {
        				  log('getDoc [] for i=' + i + ': table = \n' + format(JSON.stringify(table)));
        			  }

        			  var classTotal = item.total || 0
        			  var realClassTotal = App.getRealClassTotal(data2, pkg);

        			  doc += '\n### ' + (i + 1) + '. ' + pkg + ' - ' + App.getTotalAndCoverageString('类', classTotal, realClassTotal) + '\n'

        			  var columnList = item['[]'];
        			  if (columnList == null) {
        				  continue;
        			  }
        			  if (DEBUG) {
        				  log('getDoc [] for ' + i + ': columnList = \n' + format(JSON.stringify(columnList)));
        			  }

        			  for (var j = 0; j < columnList.length; j++) {
        				  var column = columnList[j];
        				  //class
        				  var clazz = column == null ? null : column.Method;
        				  var cls = clazz == null ? null : clazz['class'];
        				  if (StringUtil.isEmpty(cls, true)) {
        					  continue;
        				  }

        				  if (DEBUG) {
        					  log('getDoc [] for j=' + j + ': column = \n' + format(JSON.stringify(column)));
        				  }

        				  doc += '\n' + (j + 1) + ') ' + cls;
                          var args = clazz.arguments
                          if (StringUtil.isEmpty(args, true) == false) {
                            args = App.getArgumentTypes(clazz, true);
                          }

        				  if (StringUtil.isEmpty(args, true) == false) {
        					  doc += '(' + StringUtil.get(clazz.arguments) + ')';
        				  }

        				  var methodTotal = (column['Method:count'] || {}).total || 0;
        				  var realMethodTotal = App.getRealMethodTotal(data2, pkg, cls);
        				  doc += ' - ' + App.getTotalAndCoverageString('方法', methodTotal, realMethodTotal)
        			  }

        			  doc += '\n\n\n';

        		  }

        	  }

        	  doc += '\n\n';

        	  //[] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


              App.onChange(false);

              if (callback != null) {
                callback(doc);
              }

//      	  log('getDoc  callback(doc); = \n' + doc);

          }

          finalCallback()

          App.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON,App.project + '/method/list', {
        	  'query': 1,
        	  'package': App.getPackage(),
//        	  'class': App.getClass()
          }, {}, finalCallback)

      },

      getTableKey: function(database) {
        database = database || this.database
        return this.database == 'SQLSERVER' ? 'SysTable' : (['ORALCE', 'DAMENG'].indexOf(database) >= 0 ? 'AllTable' : 'Table')
      },
      getColumnKey: function(database) {
        database = database || this.database
        return this.database == 'SQLSERVER' ? 'SysColumn' : (['ORALCE', 'DAMENG'].indexOf(database) >= 0 ? 'AllColumn' : 'Column')
      },
      getTableObj: function(tableIndex) {
        var list = docObj == null ? null : docObj['[]']
        var item = list == null ? null : list[tableIndex]
        return item == null ? null : item[this.getTableKey()];
      },
      getColumnList: function(tableIndex) {
        var list = docObj == null ? null : docObj['[]']
        var item = list == null ? null : list[tableIndex]
        return item == null ? null : item['[]']
      },
      getColumnListWithModelName: function(modelName, schemaName) {
        var list = docObj == null ? null : docObj['[]']
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            var table = this.getTableObj(i)
            if (table != null && this.getModelName(i) == modelName
              && (schemaName == null || table.table_schema == schemaName)) {
              return list[i]['[]']
            }
          }
        }
        return null
      },
      getTableByName: function(tableName, schemaName) {
        var list = docObj == null ? null : docObj['[]']
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            var table = this.getTableObj(i)
            if (table != null && table.table_name == tableName
              && (schemaName == null || table.table_schema == schemaName)) {
              return table
            }
          }
        }

        return null
      },
      getTableByModelName: function(modelName, schemaName) {
        var list = docObj == null ? null : docObj['[]']
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            var table = this.getTableObj(i)
            if (table != null && this.getModelName(i) == modelName
              && (schemaName == null || table.table_schema == schemaName)) {
              return table
            }
          }
        }
        return null
      },
      getColumnTypeWithModelName: function(columnName, modelName, schemaName) {
        var columnList = this.getColumnListWithModelName(modelName, schemaName)
        if (columnList != null) {
          for (var j = 0; j < columnList.length; j++) {
            var column = this.getColumnObj(columnList, j)
            if (column != null && column.column_name == columnName) {
              return column
            }
          }
        }
        return null
      },
      getColumnObj: function(columnList, columnIndex) {
        return columnList == null ? null : (columnList[columnIndex] || {})[this.getColumnKey()];
      },
      getAccessObj: function(index) {
        var list = docObj == null ? null : docObj['Access[]']
        return list == null ? null : list[index];
      },
      getFunctionObj: function(index) {
        var list = docObj == null ? null : docObj['Function[]']
        return list == null ? null : list[index];
      },
      getFunctionByName: function(functionName) {
        var list = docObj == null ? null : docObj['Function[]']
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            var fun = this.getFunctionObj(i)
            if (fun != null && fun.name == functionName) {
              return fun
            }
          }
        }
        return null
      },
      getRequestObj: function(index) {
        var list = docObj == null ? null : docObj['Request[]']
        return list == null ? null : list[index];
      },
      getRequestBy: function(method, tag, version) {
        var list = docObj == null ? null : docObj['Request[]']
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            var req = this.getRequestObj(i)
            if (req != null && req.method == method && req.tag == tag && (
              version == null || req.version == version)) {
              return req
            }
          }
        }
        return null
      },
      getSchemaName: function(tableIndex) {
        var table = this.getTableObj(tableIndex)
        var sch = table == null ? null : table.table_shema
        if (StringUtil.isNotEmpty(sch)) {
          return sch
        }

        var schemas = StringUtil.isEmpty(this.schema, true) ? null : StringUtil.split(this.schema)
        return schemas == null || schemas.length != 1 ? null : this.schema
      },
      getTableName: function(tableIndex) {
        var table = this.getTableObj(tableIndex)
        return table == null ? '' : table.table_name
      },
      getColumnName: function(columnList, columnIndex) {
        var column = this.getColumnObj(columnList, columnIndex)
        return column == null ? '' : column.column_name
      },
      getModelName: function(tableIndex) {
        var table = this.getTableObj(tableIndex)
        var table_name = table == null ? null : table.table_name

        var accessMap = table_name == null ? null : CodeUtil.accessMap
        var access = accessMap == null ? null : accessMap[StringUtil.toLowerCase(table.table_schema) + '.' + StringUtil.toLowerCase(table_name)]
        var alias = access == null ? null : access.alias

        return StringUtil.isEmpty(alias, true) ? StringUtil.firstCase(table_name, true) : alias
      },
      getModelNameByTableName: function(tableName, schemaName) {
        var table = this.getTableByName(tableName, schemaName)
        var table_name = table == null ? null : table.table_name

        var accessMap = table_name == null ? null : CodeUtil.accessMap
        var access = accessMap == null ? null : accessMap[StringUtil.toLowerCase(table.table_schema) + '.' + StringUtil.toLowerCase(table_name)]
        var alias = access == null ? null : access.alias

        return StringUtil.isEmpty(alias, true) ? StringUtil.firstCase(table_name, true) : alias
      },

      onClickPost: function (tableIndex, modelName, schemaName, role) {
        this.handleClickPost(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickPost: function (columnList, modelName, schemaName, role) {
        if (columnList == null) {
          columnList = this.getColumnListWithModelName(modelName, schemaName)
        }

        var tbl = {}

        if (columnList != null && columnList.length > 0) {
          for (var j = 0; j < columnList.length; j++) {
            var column = this.getColumnObj(columnList, j)
            var name = column == null ? null : column.column_name;
            if (name == null || name.toLowerCase() == "id") {
              continue;
            }

            var val = column.column_default
            if (val == null) {
              var column_type = CodeUtil.getColumnType(column, this.database);
              var type = CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT, column_type, false);
              val = this.generateValue(type, name)
            }

            tbl[name] = val
          }
        }

        if (StringUtil.isNotEmpty(schemaName, true)) {
          tbl['@schema'] = schemaName
        }
        if (StringUtil.isNotEmpty(role, true)) {
          tbl['@role'] = role
        }

        var json = isSingle ? tbl : {}
        if (! isSingle) {
          json[modelName] = tbl
          json.tag = modelName
          json['@explain'] = true
        }

        var s = JSON.stringify(json, null, '    ')
        this.showCRUD('/post' + (isSingle ? '/' + modelName : ''), isSingle ? this.switchQuote(s) : s)
      },

      onClickGet: function (tableIndex, modelName, schemaName, role) {
        this.handleClickGet(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickGet: function (columnList, modelName, schemaName, role) {
        if (columnList == null) {
          columnList = this.getColumnListWithModelName(modelName, schemaName)
        }

        var idName = 'id'
        var userIdName = 'userId'
        var dateName = 'date'
        var s = ''
        if (columnList != null && columnList.length > 0) {
          for (var j = 0; j < columnList.length; j++) {
            var column = this.getColumnObj(columnList, j)
            var name = column == null ? null : column.column_name;
            if (name == null) {
              continue;
            }

            var ln = name.replaceAll('_', '').toLowerCase()
            if (name.toLowerCase() == "id") {
              idName = name
            }
            else if (ln == "userid") {
              userIdName = name
            }
            else if (("date", "time", "createtime", "createat", "createat", "createdat").indexOf(ln) >= 0) {
              dateName = name
            }

            s += (j <= 0 ? '' : ',') + name
          }
        }

        var arrName = modelName + '[]'

        this.showCRUD('/get' + (isSingle ? '/' + arrName + '?total@=' + arrName + '/total' + '&info@=' + arrName + '/info' : ''),
          isSingle ? `{
    '` + modelName + `': {` + (StringUtil.isEmpty(role, true) ? '' : `
        '@role': '` + role + "',") + (StringUtil.isEmpty(schemaName, true) ? '' : `
        '@schema': '` + schemaName + "',") + `
        '@column': '` + s + `',
        '@order': '` + idName + `-', // '@group': '` + userIdName + `',
        '` + idName + `>': 10, // '@column': '` + userIdName + `;avg(` + idName + `)',
        '` + dateName + `{}': '!=null' // '@having': 'avg(` + idName + `)>10'
    },
    'count': 10,
    'page': 0,
    'query': 2
}` : `{
    "` + modelName + `[]": {
        "` + modelName + `": {` + (StringUtil.isEmpty(role, true) ? '' : `
            "@role": "` + role + '",') + (StringUtil.isEmpty(schemaName, true) ? '' : `
            "@schema": "` + schemaName + '",') + `
            "@column": "` + s + `",
            "@order": "` + idName + `-", // "@group": "` + userIdName + `",
            "` + idName + `>": 10, // "@column": "` + userIdName + `;avg(` + idName + `)",
            "` + dateName + `{}": "!=null" // "@having": "avg(` + idName + `)>10"
        },
        "count": 10,
        "page": 0,
        "query": 2
    },
    "total@": "` + modelName + `[]/total",
    "info@": "` + modelName + `[]/info",
    "@explain": true
}`)
      },

      onClickPut: function (tableIndex, modelName, schemaName, role) {
        this.handleClickPut(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickPut: function (columnList, modelName, schemaName, role) {
        if (columnList == null) {
          columnList = this.getColumnListWithModelName(modelName, schemaName)
        }

        var tbl = {
          "id{}": [
            1,
            2,
            4,
            12,
            470,
            82011,
            82012
          ]
        }

        if (columnList != null && columnList.length > 0) {
          for (var j = 0; j < columnList.length; j++) {
            var column = this.getColumnObj(columnList, j)
            var name = column == null ? null : column.column_name;
            if (name == null) {
              continue;
            }

            var val = column.column_default
            if (val == null) {
              var column_type = CodeUtil.getColumnType(column, this.database);
              var type = CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT, column_type, false);
              val = this.generateValue(type, name)
            }

            tbl[name] = val
          }
        }

        if (StringUtil.isNotEmpty(schemaName, true)) {
          tbl['@schema'] = schemaName
        }
        if (StringUtil.isNotEmpty(role, true)) {
          tbl['@role'] = role
        }

        var json = isSingle ? tbl : {}
        if (! isSingle) {
          json[modelName] = tbl
          json.tag = modelName
          json['@explain'] = true
        }

        var s = JSON.stringify(json, null, '    ')
        this.showCRUD('/put' + (isSingle ? '/' + modelName + '[]' : ''), isSingle ? this.switchQuote(s) : s)
      },

      onClickDelete: function (tableIndex, modelName, schemaName, role) {
        this.handleClickDelete(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickDelete: function (columnList, modelName, schemaName, role) {
        this.handleClickGetsOrDelete(false, columnList, modelName, schemaName, role)
      },
      handleClickGetsOrDelete: function (isGets, columnList, modelName, schemaName, role) {
        if (columnList == null) {
          columnList = this.getColumnListWithModelName(modelName, schemaName)
        }

        var isSchemaEmpty = StringUtil.isEmpty(schemaName, true)
        var isRoleEmpty = StringUtil.isEmpty(role, true)

        this.showCRUD((isGets ? '/gets' : '/delete') + (isSingle ? '/' + modelName : ''),
          isSingle ? `{
    'id': 1` + (StringUtil.isEmpty(schemaName, true) ? '' : `,
    '@schema': '` + schemaName + "'") + (StringUtil.isEmpty(role, true) ? '' : `,
    '@role': '` + role + "'") + `
}` : `{
    "` + modelName + `": {
        "id": 1` + (StringUtil.isEmpty(schemaName, true) ? '' : `,
        "@schema": "` + schemaName + '"') + (StringUtil.isEmpty(role, true) ? '' : `,
        "@role": "` + role + '"') + `
    },
    "tag": "` + modelName + `",
    "@explain": true
}`)
      },

      onClickGets: function (tableIndex, modelName, schemaName, role) {
        this.handleClickGets(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickGets: function (columnList, modelName, schemaName, role) {
        this.handleClickGetsOrDelete(true, columnList, modelName, schemaName, role)
      },

      onClickHead: function (tableIndex, modelName, schemaName, role) {
        this.handleClickHead(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickHead: function (columnList, modelName, schemaName, role) {
        this.handleClickHeadOrHeads(false, columnList, modelName, schemaName, role)
      },
      onClickHeads: function (tableIndex, modelName, schemaName, role) {
        this.handleClickHeads(this.getColumnList(tableIndex), modelName || this.getModelName(tableIndex), schemaName, role)
      },
      handleClickHeads: function (columnList, modelName, schemaName, role) {
        this.handleClickHeadOrHeads(true, columnList, modelName, schemaName, role)
      },
      handleClickHeadOrHeads: function (isHeads, columnList, modelName, schemaName, role) {
        if (columnList == null) {
          columnList = this.getColumnListWithModelName(modelName, schemaName)
        }

        this.showCRUD((isHeads ? '/heads' : '/head') + (isSingle ? '/' + modelName : ''),
          isSingle ? `{
    'userId': 82001` + (StringUtil.isEmpty(schemaName, true) ? '' : `,
    '@schema': '` + schemaName + "'") + (StringUtil.isEmpty(role, true) ? '' : `,
    '@role': '` + role + "'") + `
}` : `{
    "` + modelName + `": {
        "userId": 82001` + (StringUtil.isEmpty(schemaName, true) ? '' : `,
        "@schema": "` + schemaName + '"') + (StringUtil.isEmpty(role, true) ? '' : `,
        "@role": "` + role + '"') + `
    },` + (isHeads ? `
    "tag": "` + modelName + `",` : '') + `
    "@explain": true
}`)
      },

      onClickColumn: function (tableIndex, modelName, columnIndex, columnName) {
        modelName = modelName || this.getModelName(tableIndex)
        if (StringUtil.isEmpty(columnName, true)) {
          var columnList = this.getColumnList(tableIndex)
          columnName = columnName || this.getColumnName(columnList, columnIndex)
        }

        var arrName = modelName + '[]'

        this.showCRUD('/get' + (isSingle ? '/' + arrName + '?total@=' + arrName + '/total' + '&info@=' + arrName + '/info' : ''),
          isSingle ? `{
    '` + modelName + `': {
        '@column': 'DISTINCT ` + columnName + `',
        '@order': '` + columnName + `+', // '@order': 'id-'
    },
    'count': 0,
    'page': 0,
    'query': 2
}` : `{
    "` + modelName + '-' + columnName + `[]": {
        "` + modelName + `": {
            "@column": "DISTINCT ` + columnName + `",
            "@order": "` + columnName + `+", // "@order": "id-"
        },
        "count": 0,
        "page": 0,
        "query": 2
    },
    "total@": "` + modelName + '-' + columnName + `[]/total",
    "info@": "` + modelName + '-' + columnName + `[]/info",
    "@explain": true
}`)
      },

      onClickAccess: function (index, model, schema, method, role) {
        if (StringUtil.isEmpty(model, true) || StringUtil.isEmpty(schema, true) || StringUtil.isEmpty(method, true) || StringUtil.isEmpty(role, true)) {
          // var access = this.getAccessObj(index)
          // model = this.getModelNameByTableName()
        }

        method = StringUtil.toLowerCase(method)
        switch (method) {
          case 'get':
            this.handleClickGet(null, model, schema, role)
            break
          case 'gets':
            this.handleClickGets(null, model, schema, role)
            break
          case 'head':
            this.handleClickHead(null, model, schema, role)
            break
          case 'heads':
            this.handleClickHeads(null, model, schema, role)
            break
          case 'post':
            this.handleClickPost(null, model, schema, role)
            break
          case 'put':
            this.handleClickPut(null, model, schema, role)
            break
          case 'delete':
            this.handleClickDelete(null, model, schema, role)
            break
        }
      },

      onClickFunction: function (index, demo) {
        if (StringUtil.isEmpty(demo, true)) {
          var fun = this.getFunctionObj(index)
          demo = JSON.stringify(fun.demo, null, '    ')  // this.getFunctionDemo(fun)
        }

        this.showCRUD('/get', isSingle ? this.switchQuote(demo) : demo)
      },

      onClickRequest: function (index, method, tag, version, jsonStr) {
        if (StringUtil.isEmpty(method, true) || StringUtil.isEmpty(tag, true) || StringUtil.isEmpty(jsonStr, true)) {
          var fun = this.getRequestObj(index)
          method = fun.method || 'get'
          tag = fun.tag
          version = fun.version
          if (StringUtil.isEmpty(jsonStr, true)) {
            var json = this.getStructure(true, null, fun.structure, method, tag, version, isSingle, true)
            jsonStr = json == null ? '' : JSON.stringify(json, null, '    ')
          }
        }

        vInput.value = ''
        this.showCRUD(
          '/' + StringUtil.toLowerCase(method) + (isSingle ? '/' + tag + (version == null ? '' : '?version=' + version) : '')
          , isSingle ? this.switchQuote(jsonStr) : jsonStr
        )
      },

      showCRUD: function (url, json) {
        if (url == this.getBranchUrl()) {
          var origin = this.getRequest(vInput.value)
          if (origin != null && Object.keys(origin).length > 0) {
            json = this.getRequest(json)
            if (json == null || Object.keys(json).length <= 0
              || (json instanceof Array != true && json instanceof Object)) {
              json = Object.assign(origin, json)
              json = JSON.stringify(json, null, '    ')
            }
          }
        }

        this.method = REQUEST_TYPE_POST
        this.type = REQUEST_TYPE_JSON
        this.showUrl(false, url)
        this.urlComment = ''
        vInput.value = StringUtil.trim(json)
        this.showTestCase(false, this.isLocalShow)
        this.onChange(false)
      },

      getTotalAndCoverageString: function(typeName, count, total) {
    	  count = count || 0
    	  total = total || 0
        if (count > total) {
          count = total
        }

    	  return '共 ' + total + ' 个' + (typeName || '子项') + '，覆盖 ' + count  + ' 个'
		  + (Number.isInteger(total) != true || total <= 0 ? '' : '，覆盖率 ' + (100*count/total).toFixed(2) + '%');
      },

      getRealClassTotal: function(data, packageName) {
    	if (data == null) {
    		return 0;
    	}

    	var packageList = data.packageList
    	var len = packageList == null ? 0 : packageList.length

  		if (StringUtil.isEmpty(packageName, true)) {
  			return Math.max(data.classTotal || 0, len);
  		}

    	if (len <= 0) {
    		return 0;
    	}

  		for (var i in packageList) {
  			var pkgObj = packageList[i]
  			if (pkgObj != null && pkgObj['package'] == packageName) {
  				return Math.max(pkgObj.classTotal || 0, (pkgObj.classList || []).length || 0);
  			}
  		}

  		return 0;
	  },

	  getRealMethodTotal: function(data, packageName, className) {
		    if (data == null) {
	    	 return 0;
	      }

	    	var packageList = data.packageList
	    	var len = packageList == null ? 0 : packageList.length

  			if (StringUtil.isEmpty(packageName, true)) {
  				if (StringUtil.isEmpty(className, true)) {
  					return Math.max(data.classTotal || 0, len);
  				}
  				return 0;
  			}

	    	if (len <= 0) {
	    		return 0;
	    	}


		  for (var i in packageList) {
			  var pkgObj = packageList[i]
			  if (pkgObj != null && pkgObj['package'] == packageName) {

				  var classList = pkgObj.classList
				  var len2 = classList == null ? 0 : classList.length
				  if (StringUtil.isEmpty(className, true)) {
					 return Math.max(data.methodTotal || 0, len2);
				  }

				  if (len2 <= 0) {
			    	  return 0;
			      }

				  for (var j in classList) {
					  var clsObj = classList[j]
					  if (clsObj != null && clsObj['class'] == className) {
						  return Math.max(clsObj.methodTotal || 0, (clsObj.methodList || []).length || 0);
					  }
				  }
			  }
		  }

		  return 0;
	   },
     toDoubleJSON: function (json, defaultValue) {
        if (StringUtil.isEmpty(json)) {
          return defaultValue == null ? '{}' : JSON.stringify(defaultValue)
        }
        else if (json.indexOf("'") >= 0) {
          json = json.replace(/'/g, '"');
        }
        return json;
      },

      switchQuote: function (before) {
        if (before == null) {
          return before;
        }

        var newBefore = '';
        for (var i = 0; i < before.length; i++) {
          var chr = before.substring(i, i + 1); // .charAt(i);
          if (chr == '"') {
            newBefore += "'"; // chr = "'";
          }
          else if (chr == "'") {
            newBefore += '"'; // chr = '"';
          }
          else {
            newBefore += chr;
          }
        }
        return newBefore;
      },

      /**转为Markdown格式
       * @param s
       * @return {*}
       */
      toMD: function (s) {
        if (s == null) {
          return ''
        }

        if (s instanceof Object) {
          s = JSON.stringify(s)
        }

        if (typeof s != 'string') {
          return new String(s)
        }

        //无效
        s = s.replace(/\|/g, '\|');
        s = s.replace(/\n/g, ' <br /> ');
        // s = s.replace(/ /g, '&ensp;');
        return s;
      },

      /**处理请求结构
       */
      getStructure: function (isDemo, name, obj, method, tag, version, unwrap) {
        if (obj == null) {
          return null;
        }

        if (DEBUG) {
          log('getStructure  tag = ' + tag + '; version = ' + version + '; isDemo = ' + isDemo + '; obj = \n' + format(obj));
        }

        method = method == null ? 'GET' : method.trim().toUpperCase()

        var isArrayKey = tag != null && tag.endsWith('[]');
        var isMultiArrayKey = isArrayKey && tag.endsWith(":[]")
        var isTableKey = false
        var tableName = tag
        if (tag != null) { //补全省略的Table
          var key = isArrayKey ? tag.substring(0, tag.length - (tag.endsWith(':[]') ? 3 : 2)) : tag;
          if (this.isTableKey(key)) {
            isTableKey = true
            tableName = key
            // name = key
          }
        }

        var newObj = {}

        if (obj instanceof Array) {
          for (var i = 0; i < obj.length; i++) {
            newObj[i] = this.getStructure(isDemo, i + '', obj[i], method);
          }
        }
        else if (obj instanceof Object) {
          var refuseKeys = null

          for (var k in obj) {
            if (k == null || k == '' || k == 'INSERT' || k == 'REMOVE' || k == 'REPLACE' || k == 'UPDATE') {
              continue;
            }

            var v = obj[k];
            if (v == null) {
              continue;
            }

            var nk = k;

            if (isDemo) {
              nk = null
              if (k == 'REFUSE') {
                refuseKeys = StringUtil.isEmpty(v, true) ? null : StringUtil.split(v)
              }
              else if (k == 'MUST' || k == 'UNIQUE') {
                var ks = StringUtil.isEmpty(v, true) ? null : StringUtil.split(v)
                if (ks != null) {
                  for (var j = 0; j < ks.length; j++) {
                    var kj = ks[j]
                    newObj[kj] = this.generateValue(CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT
                      , CodeUtil.getColumnType(this.getColumnTypeWithModelName(kj, tableName), this.database)), kj)
                  }
                }
              }
              else if (k == 'VERIFY') { // 后续会用数据字典填空
                nk = null
                // for (var kj in v) { // 还得把功能符去掉 {} $ > <= ...
                //   newObj[kj] = this.generateValue(CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT
                //     , CodeUtil.getColumnType(this.getColumnTypeWithModelName(kj, tableName), this.database)), kj)
                // }
              }
              else if (k == 'TYPE') {
                for (var kj in v) {
                  newObj[kj] = this.generateValue(CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT, v[kj]), kj)
                }
              }
              else {
                nk = k
              }
            }
            else {
              if (k == 'REFUSE') {
                nk = '不能传';
              } else if (k == 'MUST') {
                nk = '必须传';
              } else if (k == 'UNIQUE') {
                nk = '不重复';
              } else if (k == 'VERIFY') {
                nk = '满足条件';
              } else if (k == 'TYPE') {
                nk = '满足类型';
              } else {
                nk = k;
              }
            }

            if (nk != null) {
              if (v instanceof Object && (v instanceof Array == false)) {
                v = this.getStructure(isDemo, nk, v, method);
              }
              else if (v === '!') {
                v = '非必须传的字段';
              }

              if (v != null) {
                newObj[nk] = v;
              }
            }
          }

          var isPutOrDel = method == 'PUT' || method == 'DELETE'
          var isPostOrPutMulti = isMultiArrayKey && (method == 'POST' || method == 'PUT')
          var isGetOrGetsMulti = isArrayKey && (method == 'GET' || method == 'GETS')
          var mustHasKey = tableName + (isPostOrPutMulti || isGetOrGetsMulti ? '[]' : '')
          var isFulfill = name == null && isTableKey && (isPostOrPutMulti || newObj[mustHasKey] == null)
          if (isFulfill && (isPostOrPutMulti || ! isArrayKey)) {
            name = tableName
          }

          if (isDemo && this.isTableKey(name) && (refuseKeys == null || refuseKeys.indexOf('!') < 0)) {
            var columnList = this.getColumnListWithModelName(name)
            if (columnList != null) {
              var s = ''
              for (var i = 0; i < columnList.length; i++) {
                var column = this.getColumnObj(columnList, i)
                var cn = column == null ? null : column.column_name

                if (cn == null || cn.startsWith('_') || (method == 'POST' && cn.toLowerCase() == 'id') || (refuseKeys != null && refuseKeys.indexOf(cn) >= 0)) {
                  continue
                }

                if (method == 'GET' || method == 'GETS') {
                  s += (i <= 0 ? '' : ',') + cn
                } else {
                  var nv = this.generateValue(CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT, CodeUtil.getColumnType(column, this.database)), cn)
                  if (nv != null || newObj[cn] == null) {
                    newObj[cn] = nv
                  }
                }
              }
            }

            if (method == 'GET' || method == 'GETS') {
              newObj['@column'] = s
            }
          }

          if (isFulfill) { //补全省略的Table
            var realObj = {};
            if (isArrayKey) { //自动为 tag = Comment:[] 的 { ... } 新增键值对 "Comment[]":[] 为 { "Comment[]":[], ... }
              if (isPostOrPutMulti) {
                var reqObj = isDemo ? this.getRequestBy(method, tableName) : null
                var childStruct = reqObj == null ? null : reqObj.structure
                if (childStruct != null && childStruct[tableName] != null) {
                  childStruct = childStruct[tableName]
                }

                newObj = childStruct == null ? newObj : Object.assign(
                  this.getStructure(isDemo, null, childStruct, reqObj.method, null, null, true), newObj
                )

                delete newObj[mustHasKey]
                realObj[mustHasKey] = isDemo ? [newObj, newObj] : [newObj];
              }
              else if (unwrap || isPutOrDel) {
                if (isDemo && isPutOrDel && newObj['id{}'] == null) {
                  newObj['id{}'] = [
                    1,
                    2,
                    4,
                    12,
                    470,
                    82011,
                    82012
                  ]
                }
                realObj[mustHasKey] = newObj;
              }
              else {
                realObj[mustHasKey] = newObj
              }
              newObj = realObj
            }
            else if (unwrap != true) { //自动为 tag = Comment 的 { ... } 包一层为 { "Comment": { ... } }
              if (isPutOrDel) {
                if (isDemo && newObj.id == null) {
                  newObj.id = 1
                }
              }

              realObj[mustHasKey] = newObj;
              newObj = realObj;
            }
          }

        }

        if (tag != null && unwrap != true) {
          newObj.tag = tag; //补全tag
        }
        if (version != null && unwrap != true) {
          newObj.version = version;
        }

        if (DEBUG) {
          log('getStructure  return newObj = \n' + format(newObj));
        }

        return newObj;
      },

      /**判断key是否为表名，用CodeUtil里的同名函数会在Safari上报undefined
       * @param key
       * @return
       */
      isTableKey: function (key) {
        log('isTableKey  typeof key = ' + (typeof key));
        if (key == null) {
          return false;
        }
        return /^[A-Z][A-Za-z0-9_]*$/.test(key);
      },

      log: function (msg) {
        // this.log('Main.  ' + msg)
      },

      getDoc4TestCase: function () {
        var list = this.remotes || []
        var doc = ''
        var item
        for (var i = 0; i < list.length; i ++) {
          item = list[i] == null ? null : list[i].Method
          if (item == null || item.method == null) {
            continue
          }
          doc += '\n\n#### ' + item.method  + '    ' + this.getMethodDefinition(item) // item.defination
          doc += '\n```json\n' + item.request + '\n```\n'
        }
        return doc
      },

      getArgumentTypes: function (method, isClass) {
        var curObj = method || {}
        var types = curObj.arguments || '';
        if (StringUtil.isEmpty(types, true)) {
          var args = isClass ? (curObj.genericClassArgs || curObj.classArgs) : (curObj.genericMethodArgs || curObj.methodArgs)
          if (args instanceof Array == false || args.length <= 0) {
            var req = this.getRequest(method.request, {});
            args = isClass ? req.classArgs : req.methodArgs;
          }

          if (args instanceof Array) {
            var l = method.language || this.language

            for (var i = 0; i < args.length; i++) {
              var arg = args[i];
              var type = JSONResponse.getType(arg);
              var t = null;
              if (type == 'string' && arg != null) {
                var ind = arg.indexOf(':');
                t = ind < 0 ? null : arg.substring(0, ind).trim().toLowerCase();
                if (t == null || t == '') {
                  t = CodeUtil.getType4String(l);
                }
              }
              else if (type == 'object' && arg != null) {
                t = arg.type;
                if (t == null) {
                  t = CodeUtil.getType4Language(l, JSONResponse.getType(arg.value), false);
                }
              }
              else {
                t = CodeUtil.getType4Language(l, JSONResponse.getType(arg), false);
              }

              types += (i <= 0 ? '' : ',') + (t == null ? CodeUtil.getType4Any(l) : t);
            }
          }
        }
        return types;
      },

      getMethodDefinition: function (method, isClass) {
        var curObj = method || {}
        var n = curObj.method || curObj.name;
        if (StringUtil.isEmpty(n, true)) {
          throw new Error("getMethodDefinition  StringUtil.isEmpty(n, true) !");
        }
        var a = this.getArgumentTypes(method, isClass);

        var t = curObj.type;
        var e = curObj.exceptions;
        // var l = curObj.language || '';

        // 同一格式更好
        // switch (l) {
        //   case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        //     return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")" + (StringUtil.isEmpty(t, true) ? "" : ": " + t) + (StringUtil.isEmpty(e, true) ? "" : " throws " + e);
        //   case CodeUtil.LANGUAGE_GO:
        //     var isMulti = t != null && t.indexOf(',') > 0;
        //     return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a ) + ")" + (StringUtil.isEmpty(t, true) ? "" : " " + (isMulti ? '(' + t + ')' : t));
        //   default:
            //类型可能很长，Eclipse, Idea 代码提示都是类型放后面			return (StringUtil.isEmpty(t, true) ? "" : t + " ") + n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")";
            // return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")" + (StringUtil.isEmpty(t, true) ? "" : ": " + t) + (StringUtil.isEmpty(e, true) ? "" : " throws " + e);
        // }

        return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")" + (StringUtil.isEmpty(t, true) ? "" : ": " + t) + (StringUtil.isEmpty(e, true) ? "" : " # " + e);
      },

      enableCross: function (enable) {
        this.isCrossEnabled = enable
        this.crossProcess = enable ? '交叉账号:已开启' : '交叉账号:已关闭'
        this.saveCache(this.server, 'isCrossEnabled', enable)
      },

      enableML: function (enable) {
        this.isMLEnabled = enable
        this.testProcess = enable ? '机器学习:已开启' : '机器学习:已关闭'
        this.saveCache(this.server, 'isMLEnabled', enable)
        // if (enable) {
        //   this.isEnvCompareEnabled = false
        //   this.saveCache(this.server, 'isEnvCompareEnabled', this.isEnvCompareEnabled)
        // }

        this.resetTestCount(this.currentAccountIndex)

        this.remotes = null
        this.showTestCase(true, false)
      },

      resetTestCount: function (accountIndex, isRandom, isSub) {
        if (isRandom) {
          this.resetCount(isSub ? this.currentRandomItem : this.currentRemoteItem, isRandom, isSub, accountIndex)
          return
        }

        if (accountIndex == -1) {
          this.logoutSummary = this.resetCount(this.logoutSummary, false, false, accountIndex)
        }
        else if (accountIndex >= 0 && accountIndex < (this.accounts || []).length) {
          var accountItem = this.resetCount(this.getSummary(accountIndex), false, false, accountIndex)
          this.accounts[accountIndex] = accountItem
        }
      },

      onClickTestScript: function () {
        var logger = console.log
        console.log = function(msg) {
          logger(msg)
          vOutput.value = StringUtil.get(msg)
        }

        this.view = 'output'
        vOutput.value = ''

        try {
          var isTest = true
          var isPre = this.isPreScript

          var isAdminOperation = false
          var type = this.type
          var url = this.getUrl()
          var req = this.getRequest(vInput.value, {})
          req = Object.assign({
            "package": this.getPackage(url),
            "class": this.getClass(url),
            "method": this.getMethod(url)
          }, req)
          type = REQUEST_TYPE_JSON
          url = this.project + '/method/invoke'

          var header = this.getHeader(vHeader.value)
          var callback = null

          var data = isPre ? undefined : (this.jsoncon == null ? null : JSON.parse(this.jsoncon))
          var res = isPre ? undefined : {
            data: data
          }
          var err = isPre ? undefined : null

          var sendRequest = function (isAdminOperation, method, type, url, httpReq, header, callback) {
            App.request(isAdminOperation, method, type, url, req, header, callback)
          }

          eval(vScript.value);
        }
        catch(e) {
          console.log(e);
          console.log = logger

          this.view = 'error'
          this.error = {
            msg: '执行脚本报错：\n' + e.message
          }
        }

        console.log = logger
      },

      /**参数注入，动态替换键值对
       * @param show
       */
      onClickTestRandom: function (isCross, callback) {
        this.isRandomTest = true
        this.isStatisticsEnabled = true
        this.testRandom(! this.isRandomListShow && ! this.isRandomSubListShow, this.isRandomListShow, this.isRandomSubListShow, null, isCross, true, callback)
      },
      testRandom: function (show, testList, testSubList, limit, isCross, isManual, callback) {
        this.isRandomEditable = false
        if (testList != true && testSubList != true) {
          this.testRandomProcess = ''
          this.testRandomWithText(show, callback)
        }
        else {
          var baseUrl = StringUtil.trim(this.getBaseUrl())
          if (baseUrl == '') {
            if (callback) {
              callback(true, 0, '请先输入有效的URI！')
            } else {
              alert('请先输入有效的URI！')
            }
            return
          }
          //开放测试
          // if (baseUrl.indexOf('/apijson.cn') >= 0 || baseUrl.indexOf('/39.108.143.172') >= 0) {
          //   alert('请把URL改成你自己的！\n例如 http://localhost:8080')
          //   return
          // }
          // if (baseUrl.indexOf('/apijson.org') >= 0) {
          //   alert('请把URL改成 http://apijson.cn:8080 或 你自己的！\n例如 http://localhost:8080')
          //   return
          // }

          const list = (testSubList ? App.randomSubs : App.randoms) || []
          var allCount = 0  // list.length
          for (let i = 0; i < list.length; i++) {
            const item = list[i]
            const random = item == null ? null : item.Random
            allCount += (random == null || random.count == null ? 0 : random.count)
          }

          App.randomAllCount = allCount
          App.randomDoneCount = 0

          if (allCount <= 0) {
            if (callback) {
              callback(true, 0, '请先获取随机配置\n点击[查看列表]按钮')
            } else {
              alert('请先获取随机配置\n点击[查看列表]按钮')
            }
            return
          }

          this.testRandomProcess = '正在测试: ' + 0 + '/' + allCount
          var summaryItem = (testSubList ? this.currentRandomItem : this.currentRemoteItem) || {}
          if (isManual) {
            this.resetCount(summaryItem, true, testSubList, this.currentAccountIndex)
          } else {
            summaryItem.whiteCount = 0
            summaryItem.greenCount = 0
            summaryItem.blueCount = 0
            summaryItem.orangeCount = 0
            summaryItem.redCount = 0
          }
          summaryItem.totalCount = allCount

          var json = this.getRequest(vInput.value, {})
          var url = this.getUrl()
          var header = this.getHeader(vHeader.value)

          ORDER_MAP = {}  //重置

          for (var i = 0; i < (limit != null ? limit : list.length); i ++) {  //limit限制子项测试个数
            const item = list[i]
            const random = item == null ? null : item.Random
            if (random == null || random.name == null) {
              App.randomDoneCount ++
              continue
            }
            if (DEBUG) {
              this.log('test  random = ' + JSON.stringify(random, null, '  '))
            }

            const index = i

            const itemAllCount = random.count || 0
            // allCount += (itemAllCount - 1)  // 为什么减 1？因为初始化时 var allCount = list.length

            // UI 往上顶出屏幕
            // try {
            //   document.getElementById((testSubList ?  'randomSubItem' : 'randomItem') + index).scrollIntoView()
            // } catch (e) {
            //   console.log(e)
            // }

            App[testSubList ? 'currentRandomSubIndex' : 'currentRandomIndex'] = index
            try {
              this.testRandomSingle(show, false, itemAllCount > 1 && ! testSubList, item, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, url, json, header, isCross, isManual, function (url, res, err) {
                var data = null
                if (res instanceof Object) {  // 可能通过 onTestResponse 返回的是 callback(true, 18, null)
                  data = res.data
                  try {
                    App.onResponse(url, res, err)
                    if (DEBUG) {
                      App.log('test  App.request >> res.data = ' + (data == null ? 'null' : JSON.stringify(data, null, '  ')))
                    }
                  } catch (e) {
                    App.log('test  App.request >> } catch (e) {\n' + e.message)
                  }
                }

                App.compareResponse(res, allCount, list, index, item, data, true, App.currentAccountIndex, false, err, null, isCross, callback)
                return true
              })
            }
            catch (e) {
              this.compareResponse(null, allCount, list, index, item, data, true, this.currentAccountIndex, false, e, null, isCross, callback)
            }
          }
        }
      },
      /**参数注入，动态替换键值对
       * @param show
       * @param callback
       */
      testRandomSingle: function (show, testList, testSubList, item, method, type, url, json, header, isCross, isManual, callback) {
        item = item || {}

        // 保证能调用自定义函数等 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        const scripts = this.scripts || {}
        const globalScript = (scripts.global || {})[0] || {}
        const accountScript = (scripts.account || {})[this.getCurrentAccountId() || 0] || {}
        const caseScript = (scripts.case || {})[this.getCurrentDocumentId() || 0] || {}

        var preScript = ''

        var globalPreScript = StringUtil.trim((globalScript.pre || {}).script)
        if (StringUtil.isNotEmpty(globalPreScript, true)) {
          preScript += globalPreScript + '\n\n'
        }

        var accountPreScript = StringUtil.trim((accountScript.pre || {}).script)
        if (StringUtil.isNotEmpty(accountPreScript, true)) {
          preScript += accountPreScript + '\n\n'
        }

        var casePreScript = StringUtil.trim((caseScript.pre || {}).script)
        if (StringUtil.isNotEmpty(casePreScript, true)) {
          preScript += casePreScript + '\n\n'
        }
        // 保证能调用自定义函数等 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


        var random = item.Random = item.Random || {}
        var subs = item['[]'] || []
        var existCount = subs.length
        subs = existCount <= 0 ? subs : JSON.parse(JSON.stringify(subs))

        var count = random.count || 0
        var respCount = 0;

        for (var i = 0; i < count; i ++) {
          // var constConfig = i < existCount ? ((subs[i] || {}).Random || {}).config : this.getRandomConstConfig(random.config, random.id) //第1遍，把 key : expression 改为 key : value
          // var constJson = this.getRandomJSON(JSON.parse(JSON.stringify(json)), constConfig, random.id) //第2遍，用新的 random config 来修改原 json

          const which = i;
          var rawConfig = testSubList && i < existCount ? ((subs[i] || {}).Random || {}).config : random.config

          var cb = function (url, res, err) {
            if (callback != null) {
              callback(url, res, err, random)
            }
            else {
              App.onResponse(url, res, err)
            }
          };
                  
          try {
            this.parseRandom(
              JSON.parse(JSON.stringify(json)), rawConfig, random.id
              , ! testSubList, testSubList && i >= existCount, testSubList && i >= existCount
              , function (randomName, constConfig, constJson) {

                respCount ++;

                if (testSubList) {  //在原来已上传的基础上，生成新的
                  if (which >= existCount) {
                    //异步导致顺序错乱 subs.push({
                    subs[which] = {
                      Random: {
                        id: -i - 1, //表示未上传
                        toId: random.id == null ? 1 : random.id,  // 1 为了没选择测试用例时避免用 toId 判断子项错误
                        userId: random.userId,
                        documentId: random.documentId,
                        count: 1,
                        name: randomName || 'Temp ' + i,
                        config: constConfig
                      },
                      //不再需要，因为子项里前面一部分就是已上传的，而且这样更准确，交互更直观
                      // TestRecord: {  //解决子项始终没有对比标准
                      //   id: 0, //不允许子项撤回 tr.id, //表示未上传
                      //   userId: random.userId,
                      //   documentId: random.documentId,
                      //   testAccountId: tr.testAccountId,
                      //   randomId: -i - 1,
                      //   response: tr.response,
                      //   standard: tr.standard,
                      //   date: tr.date,
                      //   compare: tr.compare
                      // }
                    // })
                    };
                  }
                }
                else {
                  if (App.isLoginShow) {
                    App.isLoginShow = false
                    App.request(false, method, type, url, json, header, cb, caseScript, null, null, true);
                  }
                  else if (show == true) {
                    vInput.value = JSON.stringify(constJson, null, '    ');
                    App.send(false, cb, caseScript);
                  }
                  else {
                    var httpReq = {
                      "package": constJson.package || App.getPackage(url),
                      "class": constJson.class || App.getClass(url),
                      "this": constJson.this,
                      "constructor": constJson.constructor,
                      "classArgs": constJson.classArgs,
                      "method": constJson.method || App.getMethod(url),
                      "methodArgs": constJson.methodArgs,
                      "static": constJson.static,
                      "timeout": constJson.timeout,
                      "ui": constJson.ui
                    }
                    App.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, App.project + '/method/invoke', httpReq, header, cb, caseScript, null, null, true);
                  }
                }

                if (testSubList && respCount >= count) { // && which >= count - 1) {
                  if (App.currentRandomItem == null) {
                    App.currentRandomItem = {}
                  }
                  App.randomSubs = App.currentRandomItem.subs = subs
                  App.getCurrentRandomSummary().summaryType = 'total' // App.onClickSummary('total', true)
                  if (App.isRandomListShow == true) {
                    App.resetCount(item, true, false, App.currentAccountIndex)
                    item.subs = subs
                  }
                  if (respCount == count) {
                    App.testRandom(false, false, true, count, isCross, isManual, callback)
                  }
                }

              },
              preScript
            );
          }
          catch (e) {
            cb(App.project + '/method/invoke', {}, e)
          }

        }  // for

      },

      resetParentCount: function (item, cri, isRandom, accountIndex) {
        if (cri == null || item == null) {
          return
        }

        if (item.whiteCount == null || item.whiteCount < 0) {
          item.whiteCount = 0
        }
        if (item.greenCount == null || item.greenCount < 0) {
          item.greenCount = 0
        }
        if (item.blueCount == null || item.blueCount < 0) {
          item.blueCount = 0
        }
        if (item.orangeCount == null || item.orangeCount < 0) {
          item.orangeCount = 0
        }
        if (item.redCount == null || item.redCount < 0) {
          item.redCount = 0
        }

        if (cri.whiteCount == null) {
          cri.whiteCount = 0
        }
        if (cri.greenCount == null) {
          cri.greenCount = 0
        }
        if (cri.blueCount == null) {
          cri.blueCount = 0
        }
        if (cri.orangeCount == null) {
          cri.orangeCount = 0
        }
        if (cri.redCount == null) {
          cri.redCount = 0
        }

        cri.whiteCount -= item.whiteCount
        cri.greenCount -= item.greenCount
        cri.blueCount -= item.blueCount
        cri.orangeCount -= item.orangeCount
        cri.redCount -= item.redCount
        // cri.totalCount -= item.totalCount

        // var isTestCase = isRandom != true && item.Method != null && accountIndex < (this.accounts || []).length

        if (cri.whiteCount < 0) {
          cri.whiteCount = 0 // isTestCase ? item.whiteCount : 0
        }
        if (cri.greenCount < 0) {
          cri.greenCount = 0 // isTestCase ? item.greenCount : 0
        }
        if (cri.blueCount < 0) {
          cri.blueCount = 0 // isTestCase ? item.blueCount : 0
        }
        if (cri.orangeCount < 0) {
          cri.orangeCount = 0 // isTestCase ? item.orangeCount : 0
        }
        if (cri.redCount < 0) {
          cri.redCount = 0 // isTestCase ? item.redCount : 0
        }
        // if (cri.totalCount < 0) {
        //   cri.totalCount = 0
        // }

        cri.totalCount = cri.whiteCount + cri.greenCount + cri.blueCount + cri.orangeCount + cri.redCount
      },
      resetCount: function (item, isRandom, isSub, accountIndex) {
        if (item == null) {
          this.log('resetCount  randomItem == null >> return')
          return item
        }

        if (isRandom) {
          var cri = isSub ? this.currentRandomItem : this.currentRemoteItem
          if (cri != null && (cri != item || cri.id != item.id)) {
            this.resetParentCount(item, cri, isRandom, accountIndex)
          }

          cri = this.currentRandomItem
          if (isSub && cri != null && (cri != item || cri.id != item.id)) {
            this.resetParentCount(item, cri, isRandom, accountIndex)
          }
        }

        var accounts = this.accounts
        var num = accounts == null ? 0 : accounts.length
        if (accountIndex < num) { //  && accountIndex != this.currentAccountIndex) {
          var cs = this.getSummary(accountIndex)
          if (cs != null && (cs != item || cs.id != item.id)) {
            this.resetParentCount(item, cs, false, accountIndex)
          }
        }

        if (accountIndex < num) {
          var als = this.getAllSummary()
          // 不知道为啥总是不对
          // if (als != null && (als != item || als.id != item.id)) {
          //   this.resetParentCount(item, als, false, accountIndex)
          // }

          // 改用以下方式
          var whiteCount = 0
          var greenCount = 0
          var blueCount = 0
          var orangeCount = 0
          var redCount = 0
          // var totalCount = 0
          for (var i = -1; i < num; i++) {
            var cs = this.getSummary(i)
            if (cs == null) {
              continue
            }

            if (cs.whiteCount == null || cs.whiteCount < 0) {
              cs.whiteCount = 0
            }
            if (cs.greenCount == null || cs.greenCount < 0) {
              cs.greenCount = 0
            }
            if (cs.blueCount == null || cs.blueCount < 0) {
              cs.blueCount = 0
            }
            if (cs.orangeCount == null || cs.orangeCount < 0) {
              cs.orangeCount = 0
            }
            if (cs.redCount == null || cs.redCount < 0) {
              cs.redCount = 0
            }
            if (cs.totalCount == null || cs.totalCount < 0) {
              cs.totalCount = cs.whiteCount + cs.greenCount + cs.blueCount + cs.orangeCount + cs.redCount
            }

            whiteCount += cs.whiteCount
            greenCount += cs.greenCount
            blueCount += cs.blueCount
            orangeCount += cs.orangeCount
            redCount += cs.redCount
            // totalCount += cs.totalCount
          }

          als.whiteCount = whiteCount
          als.greenCount = greenCount
          als.blueCount = blueCount
          als.orangeCount = orangeCount
          als.redCount = redCount
          als.totalCount = whiteCount + greenCount + blueCount + orangeCount + redCount // totalCount
        }

        // var isTop = isRandom != true && item.Method == null && item.Random == null && accountIndex < (this.accounts || []).length

        item.whiteCount = 0
        item.greenCount = 0
        item.blueCount = 0
        item.orangeCount = 0
        item.redCount = 0
        item.totalCount = 0
        return item
      },

      /**参数注入，动态替换键值对
       * @param show
       * @param callback
       */
      testRandomWithText: function (show, callback) {
        try {
          var count = this.testRandomCount || 0;
          this.isRandomSubListShow = count > 1;
          this.currentRandomItem = {
            Random: {
              toId: 0, // ((this.currentRandomItem || {}).Random || {}).id || 0,
              userId: (this.User || {}).id,
              count: count,
              name: this.randomTestTitle,
              config: vRandom.value
            },
            totalCount: count
          }

          this.testRandomSingle(show, false, this.isRandomSubListShow, this.currentRandomItem,
            null, this.type, this.isLoginShow ? this.project + vUrl.value : this.getUrl()
              , this.getRequest(vInput.value, {}), this.getHeader(vHeader.value), false, false, callback
          )
        }
        catch (e) {
          log(e)
          vSend.disabled = true

          this.view = 'error'
          this.error = {
            msg: e.message
          }

          this.isRandomShow = true
          vRandom.select()
        }
      },

      /**
       *  与 getRandomJSON 合并，返回一个
       *  {
       *    name: 'long 1, long 2', // 自动按 type0 value0, type1, value1 格式
       *    config: {}, //const config
       *    json: {} //const json
       *  }
       */
      /**参数注入，动态替换键值对
       * @param show
       * @param callback
       */
      parseRandom: function (json, config, randomId, generateJSON, generateConfig, generateName, callback, preScript) {
        var lines = config == null ? null : config.trim().split('\n')
        if (lines == null || lines.length <= 0) {
          // return null;
          callback(null, null, null);
          return
        }
        json = json || {};

        baseUrl = this.getBaseUrl();

        var reqCount = lines.length; //有无效的行  lines.length;  //等待次数
        var respCount = 0;

        randomId = randomId || 0;
        var randomNameKeys = []
        var constConfigLines = [] //TODO 改为 [{ "rawPath": "User/id", "replacePath": "User/id@", "replaceValue": "RANDOM_INT(1, 10)", "isExpression": true }] ?

        // alert('< json = ' + JSON.stringify(json, null, '    '))

        for (let i = 0; i < reqCount; i ++) {
          const which = i;
          const lineItem = lines[i] || '';

          // remove comment   // 解决整体 trim 后第一行  // 被当成正常的 key 路径而不是注释
          const commentIndex = StringUtil.trim(lineItem).startsWith('//') ? 0 : lineItem.lastIndexOf(' //'); //  -1; // eval 本身支持注释 eval('1 // test') = 1 lineItem.indexOf(' //');
          const line = commentIndex < 0 ? lineItem : lineItem.substring(0, commentIndex).trim();

          if (line.length <= 0) {
            respCount ++;
            if (i >= lines.length - 1 && respCount >= reqCount) {
              var cn = randomNameKeys.join(', ')
              if (cn.length > 50) {
                cn = cn.substring(0, 30) + ' ..' + randomNameKeys.length + '.. ' + cn.substring(cn.length - 12)
              }
              callback(cn, constConfigLines.join('\n'), json);
            }
            continue;
          }

          // path User/id  key id@
          const index = line.indexOf(': '); //APIJSON Table:alias 前面不会有空格 //致后面就接 { 'a': 1} 报错 Unexpected token ':'   lastIndexOf(': '); // indexOf(': '); 可能会有 Comment:to
          const p_k = line.substring(0, index);
          const bi = -1;  //没必要支持，用 before: undefined, after: .. 同样支持替换，反而这样导致不兼容包含空格的 key   p_k.indexOf(' ');
          const path = bi < 0 ? p_k : p_k.substring(0, bi); // User/id

          const pathKeys = path.split('/')
          if (pathKeys == null || pathKeys.length <= 0) {
            throw new Error('参数注入 第 ' + (i + 1) + ' 行格式错误！\n字符 ' + path + ' 不符合 JSON 路径的格式 key0/key1/../targetKey !' +
              '\n每个随机变量配置都必须按照\n  key0/key1/../targetKey replaceKey: value  // 注释\n的格式！' +
              '\n注意冒号 ": " 左边 0 空格，右边 1 空格！其中 replaceKey 可省略。' +
              '\nkey: {} 中最外层常量对象 {} 必须用括号包裹为 ({})，也就是 key: ({}) 这种格式！' +
              '\nkey: 多行代码 必须用 function f() { var a = 1; return a; } f() 这种一行代码格式！');
          }

          const lastKeyInPath = pathKeys[pathKeys.length - 1]
          const customizeKey = bi > 0;
          const key = customizeKey ? p_k.substring(bi + 1) : lastKeyInPath;
          if (key == null || key.trim().length <= 0) {
            throw new Error('参数注入 第 ' + (i + 1) + ' 行格式错误！\n字符 ' + key + ' 不是合法的 JSON key!' +
              '\n每个随机变量配置都必须按照\n  key0/key1/../targetKey replaceKey: value  // 注释\n的格式！' +
              '\n注意冒号 ": " 左边 0 空格，右边 1 空格！其中 replaceKey 可省略。' +
              '\nkey: {} 中最外层常量对象 {} 必须用括号包裹为 ({})，也就是 key: ({}) 这种格式！' +
              '\nkey: 多行代码 必须用 function f() { var a = 1; return a; } f() 这种一行代码格式！');
          }

          // value RANDOM_DB
          const value = line.substring(index + ': '.length);

          var invoke = function (val, which, p_k, pathKeys, key, lastKeyInPath) {
            try {
              if (generateConfig) {
                var configVal;
                if (val instanceof Object) {
                  configVal = JSON.stringify(val);
                }
                else if (typeof val == 'string') {
                  configVal = '"' + val + '"';
                }
                else {
                  configVal = val;
                }
                constConfigLines[which] = p_k + ': ' + configVal;
              }

              if (generateName) {
                var s = val == undefined ? 'undefined' : (typeof val == 'string' && val != '' ? val : JSON.stringify(val)); // null 可以正常转为字符串
                if (val instanceof Array) {
                  valStr = val.length <= 1 ? s : '[' + val.length + ' .. ' + s.substring(1, s.length - 1) + ']';
                }
                else if (val instanceof Object) {
                  var kl = Object.keys(val).length;
                  valStr = kl <= 1 ? s : '{' + kl + ' .. ' + s.substring(1, s.length - 1) + '}';
                }
                else {
                  valStr = s;
                }

                  if (valStr.length > 13) {
                  valStr = valStr.substring(0, 5) + '..';
                }
                randomNameKeys[which] = valStr;
              }

              if (generateJSON) {
                //先按照单行简单实现
                //替换 JSON 里的键值对 key: value
                var parent = json;
                var current = null;
                for (var j = 0; j < pathKeys.length - 1; j ++) {
                  current = parent[pathKeys[j]]
                  if (current == null) {
                    current = parent[pathKeys[j]] = {}
                  }
                  if (parent instanceof Object == false) {
                    throw new Error('参数注入 第 ' + (i + 1) + ' 行格式错误！路径 ' + path + ' 中' +
                      ' pathKeys[' + j + '] = ' + pathKeys[j] + ' 在实际请求 JSON 内对应的值不是对象 {} 或 数组 [] !');
                  }
                  parent = current;
                }

                if (current == null) {
                  current = json;
                }
                // alert('< current = ' + JSON.stringify(current, null, '    '))

                if (key != lastKeyInPath || current.hasOwnProperty(key) == false) {
                  delete current[lastKeyInPath];
                }

                current[key] = val;
              }

            }
            catch (e) {
              throw new Error('第 ' + (which + 1) + ' 行随机配置 key: value 后的 value 不合法！ \nerr: ' + e.message)
            }

            respCount ++;
            if (respCount >= reqCount) {
              var cn = randomNameKeys.join(', ')
              if (cn.length > 50) {
                cn = cn.substring(0, 30) + ' ..' + randomNameKeys.length + '.. ' + cn.substring(cn.length - 12)
              }
              callback(cn, constConfigLines.join('\n'), json);
            }
          };


          const start = value.indexOf('(');
          const end = value.lastIndexOf(')');

          var request4Db = function(tableName, which, p_k, pathKeys, key, lastKeyInPath, isRandom, isDesc, step) {
            // const tableName = JSONResponse.getTableName(pathKeys[pathKeys.length - 2]);
            vOutput.value = 'requesting value for ' + tableName + '/' + key + ' from database...';

            const args = StringUtil.split(value.substring(start + 1, end)) || [];
            var min = StringUtil.trim(args[0]);
            var max = StringUtil.trim(args[1]);
            var table = StringUtil.trim(args[2]) || '';
            var column = StringUtil.trim(args[3]) || '';

            min = min == '' || min == 'null' || min == 'undefined' ? null : +min;
            max = max == '' || max == 'null' || max == 'undefined' ? null : +max;

            if ((table.startsWith('"') && table.endsWith('"')) || (table.startsWith("'") && table.endsWith("'"))) {
              table = table.substring(1, table.length - 1);
            }
            if ((column.startsWith('"') && column.endsWith('"')) || (column.startsWith("'") && column.endsWith("'"))) {
              column = column.substring(1, column.length - 1);
            }

            const finalTableName = StringUtil.isEmpty(table, true) ? tableName : table;
            const finalColumnName = StringUtil.isEmpty(column, true) ? lastKeyInPath : column;

            const tableReq = {
              '@column': isRandom ? finalColumnName : ('DISTINCT ' + finalColumnName),
              '@order': isRandom ? 'rand()' : (finalColumnName + (isDesc ? '-' : '+'))
            };
            tableReq[finalColumnName + '>='] = min;
            tableReq[finalColumnName + '<='] = max;

            const req = {};
            const listName = isRandom ? null : finalTableName + '-' + finalColumnName + '[]';
            const orderIndex = isRandom ? null : getOrderIndex(randomId, line, null)

            if (isRandom) {
              req[finalTableName] = tableReq;
            }
            else {
              // 从数据库获取时不考虑边界，不会在越界后自动循环
              var listReq = {
                count: 1, // count <= 100 ? count : 0,
                page: (step*orderIndex) % 100  //暂时先这样，APIJSON 应该改为 count*page <= 10000  //FIXME 上限 100 怎么破，lastKeyInPath 未必是 id
              };
              listReq[finalTableName] = tableReq;
              req[listName] = listReq;
            }

            // reqCount ++;
            App.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, App.project + '/get', req, {}, function (url, res, err) {
              // respCount ++;
              try {
                App.onResponse(url, res, err)
              } catch (e) {}

              var data = (res || {}).data || {}
              if (JSONResponse.isSuccess(data) != true) {
                respCount = -reqCount;
                vOutput.value = '参数注入 为第 ' + (which + 1) + ' 行\n  ' + p_k + '  \n获取数据库数据 异常：\n' + data.msg;
                alert(StringUtil.get(vOutput.value));
                return
                // throw new Error('参数注入 为\n  ' + tableName + '/' + key + '  \n获取数据库数据 异常：\n' + data.msg)
              }

              if (isRandom) {
                invoke((data[finalTableName] || {})[finalColumnName], which, p_k, pathKeys, key, lastKeyInPath);
              }
              else {
                var val = (data[listName] || [])[0];
                //越界，重新获取
                if (val == null && orderIndex > 0 && ORDER_MAP[randomId] != null && ORDER_MAP[randomId][line] != null) {
                  ORDER_MAP[randomId][line] = null;  //重置，避免还是在原来基础上叠加
                  request4Db(JSONResponse.getTableName(pathKeys[pathKeys.length - 2]), which, p_k, pathKeys, key, lastKeyInPath, false, isDesc, step);
                }
                else {
                  invoke(val, which, p_k, pathKeys, key, lastKeyInPath);
                }
              }

              // var list = data[listName] || [];
              //代码变化会导致缓存失效，而且不好判断，数据量大会导致页面很卡 ORDER_MAP[randomId][line].list = list;
              //
              // if (step == null) {
              //   invoke('randomIn(' + list.join() + ')');
              // }
              // else {
              //   invoke('orderIn(' + isDesc + ', ' + step*getOrderIndex(randomId, line, list.length) + list.join() + ')');
              // }

            })
          };



          //支持 1, "a" 这种原始值
          // if (start < 0 || end <= start) {  //(1) 表示原始值  start*end <= 0 || start >= end) {
          //   throw new Error('参数注入 第 ' + (i + 1) + ' 行格式错误！字符 ' + value + ' 不是合法的随机函数!');
          // }

          var toEval = value;
          if (start > 0 && end > start) {

            var funWithOrder = value.substring(0, start);
            var splitIndex = funWithOrder.indexOf('+');

            var isDesc = false;
            if (splitIndex < 0) {  // -(1+2) 这种是表达式，不能作为函数   splitIndex <= 0) {
              splitIndex = funWithOrder.indexOf('-');
              isDesc = splitIndex > 0;
            }

            var fun = splitIndex < 0 ? funWithOrder : funWithOrder.substring(0, splitIndex);

            if (fun.startsWith('ORDER_') && /^[_A-Z]+$/g.test(fun)) { // [ORDER_DB, ORDER_IN, ORDER_INT].indexOf(fun) >= 0) {  //顺序函数
              var stepStr = splitIndex < 0 ? null : funWithOrder.substring(splitIndex + 1, funWithOrder.length);
              var step = stepStr == null || stepStr.length <= 0 ? 1 : +stepStr; //都会自动忽略空格 Number(stepStr); //Number.parseInt(stepStr); //+stepStr;

              if (Number.isSafeInteger(step) != true || step <= 0
                || (StringUtil.isEmpty(stepStr, false) != true && StringUtil.isNumber(stepStr) != true)
              ) {
                throw new Error('参数注入 第 ' + (i + 1) + ' 行格式错误！路径 ' + path + ' 中字符 ' + stepStr + ' 不符合跨步 step 格式！'
                  + '\n顺序整数 和 顺序取值 可以通过以下格式配置 升降序 和 跨步：'
                  + '\n  ORDER_DB+step(arg0, arg1...)\n  ORDER_DB-step(arg0, arg1...)'
                  + '\n  ORDER_INT+step(arg0, arg1...)\n  ORDER_INT-step(arg0, arg1...)'
                  + '\n  ORDER_IN+step(start, end)\n  ORDER_IN-step(start, end)'
                  + '\n其中：\n  + 为升序，后面没有 step 时可省略；\n  - 为降序，不可省略；' + '\n  step 为跨步值，类型为 正整数，默认为 1，可省略。'
                  + '\n+，-，step 前后都不能有空格等其它字符！');
              }

              if (fun == ORDER_DB) {
                request4Db(JSONResponse.getTableName(pathKeys[pathKeys.length - 2]), which, p_k, pathKeys, key, lastKeyInPath, false, isDesc, step); //request4Db(key + (isDesc ? '-' : '+'), step);
                continue;
              }

              var args = StringUtil.split(value.substring(start + 1, end))
              toEval = (fun == ORDER_IN ? 'orderIn' : (fun == ORDER_INT ? 'orderInt' : (fun == ORDER_BAD_BOOL ? 'orderBadBool' : (fun == ORDER_BAD_NUM
               ? 'orderBadNum' : (fun == ORDER_BAD_STR ? 'orderBadStr' : (fun == ORDER_BAD_ARR ? 'orderBadArr' : (fun == ORDER_BAD_OBJ ? 'orderBadObj' : 'orderBad')))))))
                + '(' + (fun == ORDER_BAD ? 'BADS, ' : '') + isDesc + ', ' + getOrderIndex(
                  randomId, line
                  , (fun == ORDER_INT || args == null ? 0 : args.length)
                  + (fun == ORDER_BAD_BOOL ? BAD_BOOLS.length : (fun == ORDER_BAD_NUM ? BAD_NUMS.length : (fun == ORDER_BAD_STR
                   ? BAD_STRS.length : (fun == ORDER_BAD_ARR ? BAD_ARRS.length : (fun == ORDER_BAD_OBJ ? BAD_OBJS.length : (fun == ORDER_BAD ? BADS.length : 0))))))
                  , step
                ) + ', ' + value.substring(start + 1);
            }
            else {  //随机函数
              fun = funWithOrder;  //还原，其它函数不支持 升降序和跨步！

              if (fun == RANDOM_DB) {
                request4Db(JSONResponse.getTableName(pathKeys[pathKeys.length - 2]), which, p_k, pathKeys, key, lastKeyInPath, true); //'random()');
                continue;
              }

              if (fun == RANDOM_IN) {
                toEval = 'randomIn' + value.substring(start);
              }
              else if (fun == RANDOM_INT) {
                toEval = 'randomInt' + value.substring(start);
              }
              else if (fun == RANDOM_NUM) {
                toEval = 'randomNum' + value.substring(start);
              }
              else if (fun == RANDOM_STR) {
                toEval = 'randomStr' + value.substring(start);
              }
              else if (fun == RANDOM_BAD) {
                toEval = 'randomBad' + value.substring(start);
              }
              else if (fun == RANDOM_BAD_BOOL) {
                toEval = 'randomBadBool' + value.substring(start);
              }
              else if (fun == RANDOM_BAD_NUM) {
                toEval = 'randomBadNum' + value.substring(start);
              }
              else if (fun == RANDOM_BAD_STR) {
                toEval = 'randomBadStr' + value.substring(start);
              }
              else if (fun == RANDOM_BAD_ARR) {
                toEval = 'randomBadArr' + value.substring(start);
              }
              else if (fun == RANDOM_BAD_OBJ) {
                toEval = 'randomBadObj' + value.substring(start);
              }

            }

          }

          var isInject = true;
          var isPre = false; // 避免执行副作用代码 true;
          var isTest = false;
          var method = null;
          var type = null;
          var url = null;
          var req = null;
          var header = null;
          var res = {};
          var data = res.data;
          var err = null;
          invoke(eval(StringUtil.trim(preScript) + '\n;\n(' + toEval + ')'), which, p_k, pathKeys, key, lastKeyInPath);

          // alert('> current = ' + JSON.stringify(current, null, '    '))
        }

      },

      onClickSend: function () {
        this.isRandomTest = false
        this.send(false)
      },
      onClickTest: function (callback) {
        this.isRandomTest = false
        this.isStatisticsEnabled = true
        this.reportId = new Date().getTime()
        this.caseShowType = 1

        // 自动往右移动，避免断言结果遮挡太多接口名称、URL
        var split_obj = IS_BROWSER ? $('.splitx') : null
        var split_obj_left = split_obj == null ? 0 : parseInt(split_obj.css('left'))
        var width = split_obj_left <= 0 ? 0 : (window.innerWidth || 1280)
        if (width > 0 && Math.abs(split_obj_left - 0.5*width) <= 5) {
          // 构造事件比较麻烦，即便用 JQuery 也是
          // split_obj[0].dispatchEvent(new TouchEvent('', new class implements TouchEventInit{
          //   clientX: 0.6*width
          // }()))

          var left_ele = $('.side-left')
          var right_ele = $('.side-right')

          // var left_width = left_ele.width()
          // var right_width = right_ele.width()
          //
          // var right_left = parseInt(right_ele.css('left'))

          split_obj.css('left', 0.55*width)
          left_ele.width(0.55*width);
          right_ele.width(0.45*width).css('left', 0.55*width);
          // right_ele.width(right_width - left_ele.width() + left_width).css('left', right_left + left_ele.width() - left_width);
        }

        var isCross = this.isCrossEnabled
        var accountIndex = isCross ? -1 : this.currentAccountIndex

        var accounts = this.accounts
        var num = accounts == null ? 0 : accounts.length

        var remotes = this.remotes
        var total = remotes == null ? 0 : remotes.length

        var als = this.getAllSummary()
        als = this.resetCount(als, false, false, num)
        als.totalCount = isCross ? (num + 1)*total : total

        if (isCross) {
          for (var i = -1; i < num; i++) {
            var cs = this.getSummary(i)
            cs = this.resetCount(cs, false, false, i)
            cs.totalCount = total
          }
        } else {
          var cs = this.getSummary(accountIndex)
          cs = this.resetCount(cs, false, false, accountIndex)
          cs.totalCount = total
        }

        this.coverage = {}
        this.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, this.project + '/coverage/start', {}, {}, function (url, res, err) {
          try {
            App.onResponse(url, res, err)
            if (DEBUG) {
              App.log('test  App.request >> res.data = ' + JSON.stringify(res.data, null, '  '))
            }
          } catch (e) {
            App.log('test  App.request >> } catch (e) {\n' + e.message)
          }

          App.test(false, accountIndex, isCross, callback)
        })

      },
      /**回归测试
       * 原理：
       1.遍历所有上传过的测试用例（URL+请求JSON）
       2.逐个发送请求
       3.对比同一用例的先后两次请求结果，如果不一致，就在列表中标记对应的用例(× 蓝黄红色下载(点击下载两个文件) √)。
       4.如果这次请求结果正确，就把请求结果保存到和公司开发环境服务器的APIJSON Server，并取消标记

       compare: 新的请求与上次请求的对比结果
       0-相同，无颜色；
       1-对象新增字段或数组新增值，绿色；
       2-值改变，蓝色；
       3-对象缺少字段/整数变小数，黄色；
       4-code/值类型 改变，红色；
       */
      test: function (isRandom, accountIndex, isCross, callback) {
        var accounts = this.accounts || []
        // alert('test  accountIndex = ' + accountIndex)
        if (accountIndex == null) {
          accountIndex = -1 //isCross ? -1 : 0
        }

        if (isCross) {
          var isCrossDone = accountIndex >= accounts.length
          this.crossProcess = isCrossDone ? '交叉账号:已开启' : ('交叉账号: ' + (accountIndex + 1) + '/' + accounts.length)
          if (isCrossDone) {
            this.testProcess = (this.isMLEnabled ? '机器学习:已开启' : '机器学习:已关闭')
            this.testRandomProcess = ''
            if (accountIndex == accounts.length) {
              this.currentAccountIndex = accounts.length - 1  // -1 导致最后右侧显示空对象

              if (callback) {
                callback('已完成账号交叉测试: 退出登录状态 和 每个账号登录状态')
              } else {
                alert('已完成账号交叉测试: 退出登录状态 和 每个账号登录状态')
              }

              if (callback != this.autoTestCallback && typeof this.autoTestCallback == 'function') {
                this.autoTestCallback('已完成账号交叉测试: 退出登录状态 和 每个账号登录状态')
              }
            }
            return
          }

          if (callback != this.autoTestCallback && typeof this.autoTestCallback == 'function') {
            this.autoTestCallback('正在账号交叉测试 ')
          }
        }

        var baseUrl = StringUtil.trim(this.getBaseUrl())
        if (baseUrl == '') {
          if (callback) {
            callback('请先输入有效的URI！')
          } else {
            alert('请先输入有效的URI！')
          }
          return
        }
        //开放测试
        // if (baseUrl.indexOf('/apijson.cn') >= 0 || baseUrl.indexOf('/39.108.143.172') >= 0) {
        //   alert('请把URL改成你自己的！\n例如 http://localhost:8080')
        //   return
        // }
        // if (baseUrl.indexOf('/apijson.org') >= 0) {
        //   alert('请把URL改成 http://apijson.cn:8080 或 你自己的！\n例如 http://localhost:8080')
        //   return
        // }

        const list = (isRandom ? this.randoms : this.remotes) || []
        const allCount = list.length
        App.doneCount = 0
        App.deepAllCount = 0
        App.randomDoneCount = 0
        if (isRandom != true) {
          App.allCount = allCount
        }

        // var cs = this.getSummary(accountIndex)
        // if (isCross && cs.totalCount <= 0) {
        //   cs = this.resetCount(cs)
        //   cs.totalCount = allCount
        // }
        //
        // var als = this.getAllSummary()
        // if (als.totalCount <= 0) {
        //   als = this.resetCount(als)
        //   als.totalCount = allCount
        // }

        if (allCount <= 0) {
          if (callback) {
            callback('请先获取测试用例文档\n点击[查看用例列表]图标按钮')
          } else {
            alert('请先获取测试用例文档\n点击[查看用例列表]图标按钮')
          }
          return
        }

        if (isCross) {
          if (accountIndex < 0 && accounts[this.currentAccountIndex] != null) {  //退出登录已登录的账号
            accounts[this.currentAccountIndex].isLoggedIn = true
          }
          var index = accountIndex < 0 ? this.currentAccountIndex : accountIndex
          this.onClickAccount(index, accounts[index], function (isLoggedIn, index, err) {
            // if (index >= 0 && isLoggedIn == false) {
            //   alert('第 ' + index + ' 个账号登录失败！' + (err == null ? '' : err.message))
            //   App.test(isRandom, accountIndex + 1)
            //   return
            // }
            App.showTestCase(true, false)
            App.startTest(list, allCount, isRandom, accountIndex, isCross, callback)
          })
        }
        else {
          this.startTest(list, allCount, isRandom, accountIndex, isCross, callback)
        }
      },

      toTestDocIndexes: [],

      startTest: function (list, allCount, isRandom, accountIndex, isCross, callback) {
        this.testProcess = '正在测试: ' + 0 + '/' + allCount
        this.toTestDocIndexes = []

        if (callback != this.autoTestCallback && typeof this.autoTestCallback == 'function') {
          this.autoTestCallback(this.testProcess)
        }

        const isMLEnabled = this.isMLEnabled
        const standardKey = isMLEnabled != true ? 'response' : 'standard'

        const otherEnv = this.otherEnv;
        const otherBaseUrl = this.isEnvCompareEnabled && StringUtil.isNotEmpty(otherEnv, true) ? otherEnv : null
        const isEnvCompare = StringUtil.isNotEmpty(otherBaseUrl, true) // 对比自己也行，看看前后两次是否幂等  && otherBaseUrl != baseUrl

        for (var i = 0; i < allCount; i++) {
          const index = i
          const item = list[i]

          try {
            const document = item == null ? null : item.Method
            if (document == null || document.method == null) {
              if (isRandom) {
                App.randomDoneCount ++
              } else {
                App.doneCount ++
              }
              continue
            }
            var method = (document.method || '').toLowerCase()
            if (method.indexOf('login') >= 0 || method.indexOf('logout') >= 0) { //login会导致登录用户改变为默认的但UI上还显示原来的，单独测试OWNER权限时能通过很困惑
              this.log("startTest  method.indexOf('login') >= 0 || method.indexOf('logout') >= 0 >> continue")
              if (isRandom) {
                App.randomDoneCount ++
              } else {
                App.doneCount ++
              }
              continue
            }

            if (DEBUG) {
              this.log('test  document = ' + JSON.stringify(document, null, '  '))
            }

            var hdr = null
            try {
              hdr = this.getHeader(document.header)
            } catch (e) {
              this.log('test  for ' + i + ' >> try { header = this.getHeader(document.header) } catch (e) { \n' + e.message)
            }
            const header = hdr

            const caseScript = {
              pre: item['Script:pre'],
              post: item['Script:post']
            }

            const otherEnvUrl = isEnvCompare ? (otherBaseUrl + '/method/invoke') : null
            const curEnvUrl = this.project + '/method/invoke'

            var httpReq = null
            if (StringUtil.isEmpty(document.request, true)) {
              httpReq = {
                "package": document.package,
                "class": document.class,
                "this": document.this,
                "constructor": document.constructor,
                "classArgs": this.getRequest(document.classArgs),
                "method": document.method,
                "methodArgs": this.getRequest(document.methodArgs),
                "static": document.static,
                "timeout": document.timeout,
                "ui": document.ui
              }
            }
            else {
              httpReq = this.getRequest(document.request)
              if (httpReq.package == null) {
                httpReq.package = document.package
              }
              if (httpReq.class == null) {
                httpReq.class = document.class
              }
              if (httpReq.method == null) {
                httpReq.method = document.method
              }
              if (httpReq.constructor == null) {
                httpReq.constructor = document.constructor
              }
              if (httpReq.classArgs == null) {
                httpReq.classArgs = this.getRequest(document.classArgs)
              }
              if (httpReq.methodArgs == null) {
                httpReq.methodArgs = this.getRequest(document.methodArgs)
              }
              if (httpReq.this == null) {
                httpReq.this = document.this
              }
            }

            this.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, isEnvCompare ? otherEnvUrl : curEnvUrl, httpReq, header, function (url, res, err) {
              try {
                App.onResponse(url, res, err)
                if (DEBUG) {
                  App.log('test  App.request >> res.data = ' + JSON.stringify(res.data, null, '  '))
                }
              } catch (e) {
                App.log('test  App.request >> } catch (e) {\n' + e.message)
              }

              if (isEnvCompare != true) {
              App.compareResponse(res, allCount, list, index, item, res.data, isRandom, accountIndex, false, err, null, isCross, callback)
                return
              }

              const otherErr = err
              const rsp = App.removeDebugInfo(res.data)
              const rspStr = JSON.stringify(rsp)
              const tr = item.TestRecord || {}
              if (isMLEnabled) {
                tr.response = rspStr
              }
              tr[standardKey] = isMLEnabled ? JSON.stringify(JSONResponse.updateFullStandard({}, rsp, isMLEnabled)) : rspStr // res.data
              item.TestRecord = tr

              App.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, curEnvUrl, httpReq, header, function (url, res, err) {
                try {
                  App.onResponse(url, res, err)
                  if (DEBUG) {
                    App.log('test  App.request >> res.data = ' + JSON.stringify(res.data, null, '  '))
                  }
                } catch (e) {
                  App.log('test  App.request >> } catch (e) {\n' + e.message)
                }

              App.compareResponse(res, allCount, list, index, item, res.data, isRandom, accountIndex, false, err || otherErr, null, isCross, callback)
              }, caseScript)

            }, caseScript)
          }
          catch(e) {
            this.compareResponse(null, allCount, list, index, item, null, isRandom, accountIndex, false, e, null, isCross, callback)
          }
        }

      },

      compareResponse: function (res, allCount, list, index, item, response, isRandom, accountIndex, justRecoverTest, err, ignoreTrend, isCross, callback) {
        var it = item || {} //请求异步
        var cri = this.currentRemoteItem || {} //请求异步
        var d = (isRandom ? cri.Method : it.Method) || {} //请求异步
        var r = isRandom ? it.Random : null //请求异步
        var tr = it.TestRecord || {} //请求异步

        var bdt = tr.duration || 0
        it.durationBeforeShowStr = bdt <= 0 ? '' : (bdt < 1000 ? bdt + 'ms' : (bdt < 1000*60 ? (bdt/1000).toFixed(1) + 's' : (bdt <= 1000*60*60 ? (bdt/1000/60).toFixed(1) + 'm' : '>1h')))
        try {
          var durationInfo = response == null ? null : response['time:start|duration|end']
          it.durationInfo = durationInfo
          if (durationInfo == null) {
            throw new Error("response['time:start|duration|end'] is null!");
          }

          var di = durationInfo.substring(durationInfo.indexOf('|') + 1)
          it.duration = di.substring(0, di.indexOf('|') || di.length) || 0
          var dt = + it.duration
          it.duration = dt
          it.durationShowStr = dt <= 0 ? '' : (dt < 1000 ? dt + 'ms' : (dt < 1000*60 ? (dt/1000).toFixed(1) + 's' : (dt <= 1000*60*60 ? (dt/1000/60).toFixed(1) + 'm' : '>1h')))
          var min = tr.minDuration == null || tr.minDuration < 0 ? 2 : tr.minDuration
          var max = tr.maxDuration == null || tr.maxDuration < 0 ? 20 : tr.maxDuration
          it.durationColor = dt < min ? 'green' : (dt > 2*max ? 'red' : (dt > max + min ? 'orange' : (dt > max ? 'blue' : 'black')))
          it.durationHint = dt < min ? '很快：比以往 [' + min + 'ms, ' + max + 'ms] 最快还更快' : (dt > 2*max ? '非常慢：比以往 [' + min + 'ms, ' + max + 'ms] 最慢的两倍还更慢'
            : (dt > max + min ? '比较慢：比以往 [' + min + 'ms, ' + max + 'ms] 最快与最慢之和(平均值两倍)还更慢'
              : (dt > max ? '有点慢：比以往 [' + min + 'ms, ' + max + 'ms] 最慢还更慢' : '正常：在以往 [' + min + 'ms, ' + max + 'ms] 最快和最慢之间')))
        }
        catch (e) {
          // log(e)
          it.durationShowStr = it.durationShowStr || it.duration
          it.durationHint = it.durationHint || '最外层缺少字段 "time:start|duration|end"，无法对比耗时'
        }

        if (err != null) {
          var status = res == null ? null : res.status
          tr.compare = {
            code: JSONResponse.COMPARE_ERROR, //请求出错
            msg: '请求出错！',
            path: (status != null && status != 200 ? status + ' ' : '') + err.message
          }
        }
        else {
          var isML = this.isMLEnabled
          var standardKey = isML ? 'standard' : 'response'
          var stdd = tr[standardKey]
          if (isRandom) {
            stdd = stdd || ((this.currentRemoteItem || {}).TestRecord || {})[standardKey]
          }
          
          var standard = typeof stdd != 'string' ? stdd : (StringUtil.isEmpty(stdd, true) ? null : JSON.parse(stdd))

          var rsp = JSON.parse(JSON.stringify(this.removeDebugInfo(response) || {}))
          if (isML) {
            rsp = JSONResponse.array2object(rsp, 'methodArgs', ['methodArgs'], true)
            rsp = JSONResponse.array2object(rsp, 'return', ['return'], true)
            rsp = JSONResponse.array2object(rsp, 'type', ['type'], true)
          }
          tr.compare = JSONResponse.compareResponse(res, standard, rsp, '', isML, null, ['call()[]', '@time'], ignoreTrend) || {}
          tr.compare.duration = it.durationHint
        }

        this.onTestResponse(res, allCount, list, index, it, d, r, tr, response, tr.compare || {}, isRandom, accountIndex, justRecoverTest, isCross, callback);
      },

      onTestResponse: function(res, allCount, list, index, it, d, r, tr, response, cmp, isRandom, accountIndex, justRecoverTest, isCross, callback) {
        tr = tr || {}
        cmp = cmp || {}
        tr.compare = cmp
        var status = res == null ? null : res.status

        it = it || {}
        var p = cmp.path
        it.compareType = cmp.code;
        it.compareMessage = (StringUtil.isEmpty(p, true) ? '' : p + '  ') + (cmp.msg || '查看结果')
        switch (it.compareType) {
          case JSONResponse.COMPARE_ERROR:
            it.compareColor = 'red'
            it.hintMessage = (status != null && status != 200 ? status + ' ' : '') + '请求出错！'
            break;
          case JSONResponse.COMPARE_NO_STANDARD:
            it.compareColor = 'green'
            it.hintMessage = '确认正确后点击[对的，纠正]'
            break;
          case JSONResponse.COMPARE_KEY_MORE:
          case JSONResponse.COMPARE_VALUE_MORE:
          case JSONResponse.COMPARE_EQUAL_EXCEPTION:
            it.compareColor = 'green'
            it.hintMessage = '新增字段/新增值 等'
            break;
          case JSONResponse.COMPARE_LENGTH_CHANGE:
          case JSONResponse.COMPARE_VALUE_CHANGE:
            it.compareColor = 'blue'
            it.hintMessage = '值改变 等'
            break;
          case JSONResponse.COMPARE_VALUE_EMPTY:
          case JSONResponse.COMPARE_KEY_LESS:
            it.compareColor = 'orange'
            it.hintMessage = '缺少字段/整数变小数 等'
            break;
          case JSONResponse.COMPARE_FORMAT_CHANGE:
          case JSONResponse.COMPARE_NUMBER_TYPE_CHANGE:
          case JSONResponse.COMPARE_TYPE_CHANGE:
          case JSONResponse.COMPARE_CODE_CHANGE:
          case JSONResponse.COMPARE_THROW_CHANGE:
            var code = response == null ? null : response[JSONResponse.KEY_CODE]
            it.compareColor = 'red'
            it.hintMessage = (code != null && code != JSONResponse.CODE_SUCCESS
             ? code + ' ' : (status != null && status != 200 ? status + ' ' : '')) + '状态码/异常/值类型 改变等'
            break;
          default:
            it.compareColor = 'white'
            it.hintMessage = '结果正确'
            break;
        }

        if (isRandom) {
          r = r || {}
          it.Random = r

          this.updateToRandomSummary(it, 1, accountIndex)
        }
        else {
          d = d || {}
          it.Method = d

          this.updateToSummary(it, 1, accountIndex)
        }
        it.TestRecord = tr

        Vue.set(list, index, it)

        if (justRecoverTest) {
          // callback(isRandom, allCount)
          return
        }

        if (isRandom) {
          App.randomDoneCount ++
        } else {
          App.doneCount ++
        }

        var doneCount = isRandom ? App.randomDoneCount : App.doneCount
        if (isRandom) {
          this.testRandomProcess = doneCount >= allCount ? '' : ('正在测试: ' + doneCount + '/' + allCount)
        } else {
          this.testProcess = doneCount >= allCount ? (this.isMLEnabled ? '机器学习:已开启' : '机器学习:已关闭') : '正在测试: ' + doneCount + '/' + allCount
        }

        if (doneCount < allCount && callback != this.autoTestCallback && typeof this.autoTestCallback == 'function') {
          this.autoTestCallback('正在测试')
        }

        this.log('doneCount = ' + doneCount + '; d.name = ' + (isRandom ? r.name : d.name) + '; it.compareType = ' + it.compareType)

        var documentId = isRandom ? r.documentId : d.id
        if (this.tests == null) {
          this.tests = {}
        }

        var accountIndexStr = String(accountIndex)
        if (this.tests[accountIndexStr] == null) {
          this.tests[accountIndexStr] = {}
        }

        var tests = this.tests[accountIndexStr] || {}
        var t = tests[documentId]
        if (t == null) {
          t = tests[documentId] = {}
        }
        t[isRandom ? (r.id > 0 ? r.id : (r.toId + '' + r.id)) : 0] = response

        if (isRandom != true && it.compareColor != 'red') {
          if (this.toTestDocIndexes == null) {
            this.toTestDocIndexes = []
          }
          this.toTestDocIndexes.push(index);
        }

        this.tests[accountIndexStr] = tests
        if (DEBUG) {
          this.log('tests = ' + JSON.stringify(tests, null, '    '))
        }
        // this.showTestCase(true)

        if (doneCount >= allCount) {  // 导致不继续测试  App.doneCount == allCount) {
          if (callback != null && callback(isRandom, allCount)) {
            return
          }

          // alert('onTestResponse  accountIndex = ' + accountIndex)

          const deepAllCount = this.toTestDocIndexes == null ? 0 : this.toTestDocIndexes.length
          App.deepAllCount = deepAllCount
          if (isRandom != true && deepAllCount > 0) { // 自动给非 红色 报错的接口跑参数注入
            App.deepDoneCount = 0;
            this.startRandomTest4Doc(list, this.toTestDocIndexes, 0, deepAllCount, accountIndex, isCross)
          } else if (isCross && doneCount == allCount && accountIndex <= this.accounts.length) {
            this.test(false, accountIndex + 1, isCross)
          }
        }
      },

      startRandomTest4Doc: function (list, indexes, position, deepAllCount, accountIndex, isCross) {
        const accInd = accountIndex
        var callback = function (isRandom, allCount, msg) {
          log("startRandomTest4Doc  callback isRandom = " + isRandom + "; allCount = " + allCount + "; msg = " + msg)
          if (App.randomDoneCount < App.randomAllCount) {
            return true
          }

          App.randomDoneCount = App.randomAllCount

          App.deepDoneCount ++
          const deepDoneCount = App.deepDoneCount
          const autoTestCallback = App.autoTestCallback

          App.testProcess = deepDoneCount < deepAllCount ? ('正在深度测试: ' + deepDoneCount + '/' + deepAllCount) : (App.isMLEnabled ? '机器学习:已开启' : '机器学习:已关闭')
          App.testRandomProcess = App.randomDoneCount >= App.randomAllCount ? '' : ('正在测试: ' + App.randomDoneCount + '/' + App.randomAllCount)

          setTimeout(function () {
            App.isTestCaseShow = true

            if (typeof autoTestCallback == 'function') {
              autoTestCallback('正在深度测试')
            }

            if (deepDoneCount < deepAllCount) {
              setTimeout(function () {
                App.startRandomTest4Doc(list, indexes, position + 1, deepAllCount, accInd, isCross)
              }, IS_NODE ? 200 : 1000)
            } else {
              App.testRandomProcess = ''
              if (isCross) {
                if (deepDoneCount == deepAllCount) {
                  App.test(false, accInd + 1, isCross)
                }
              } else {
                if (deepDoneCount == deepAllCount) {
                  alert('已完成回归测试')
                  if (typeof autoTestCallback == 'function') {
                    autoTestCallback('已完成回归测试')
                  }

                  App.request(false, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, App.project + '/coverage/report', {}, {}, function (url, res, err) {
                    try {
                      App.onResponse(url, res, err)
                      if (DEBUG) {
                        App.log('test  App.request >> res.data = ' + JSON.stringify(res.data, null, '  '))
                      }
                    } catch (e) {
                      App.log('test  App.request >> } catch (e) {\n' + e.message)
                    }

                    App.coverage = res.data
                    if (IS_BROWSER) {
                      setTimeout(function () {
                        var url = StringUtil.trim((App.coverage || {}).url)
                        if (StringUtil.isEmpty(url, false)) {
                          url = App.project + "/htmlcov/index.html"
                        }
                        if (url.startsWith('/')) {
                          url = App.project + url
                        }
                        window.open(url)
                      }, 2000)
                    }
                  })
                }
              }
            }
          }, IS_NODE ? 200 : 1000)

          return true
        }

        try {
          var index = indexes[position]
          var it = list[index] || {}

          if (IS_BROWSER) {
            try {
              document.getElementById('docItem' + index).scrollIntoView()
            } catch (e) {
              console.log(e)
            }
          }

          this.restoreRemote(index, it, false)

          this.randoms = []
          this.isRandomShow = true
          this.isRandomEditable = true
          this.isRandomListShow = false
          this.isRandomSubListShow = false
          this.showRandomList(true, it.Method, false, function (url, res, err) {
            try {
              App.onRandomListResponse(true, false, url, res, err)
            } catch (e) {
              log(e)
            }

            App.testRandom(false, true, false, null, isCross, false, callback)
          })
        } catch (e2) {
          log(e2)
          callback(true, deepAllCount)
        }
      },

      getSummary: function (accountIndex) {
        if (accountIndex == -1) {
          return this.getLogoutSummary()
        }
        var accounts = this.accounts || []
        if (accountIndex == accounts.length) {
          return this.getAllSummary()
        }

        if (accountIndex < 0 || accountIndex >= accounts.length) {
          return {}
        }

        var ci = this.accounts[accountIndex]
        return ci || {}
      },

      getLogoutSummary: function () {
        return this.logoutSummary || {}
      },
      getCurrentSummary: function () {
        return this.getSummary(this.currentAccountIndex) || {}
      },
      getAllSummary: function () {
        return this.allSummary || {}
      },

      getCurrentRandomSummary: function () {
        return (this.isRandomSubListShow ? this.currentRandomItem : this.currentRemoteItem) || {}
      },
      getStatisticsShowStr: function (count, total) {
        if (count == null) {
          count = 0;
        }
        if (total == null) {
          total = 0;
        }
        var showType = this.statisticsShowType;
        if (showType == 0) {
          return '' + count;
        }
        return Math.round(total <= 0 ? 0 : count*1000/total)/10 + '%' + (showType == 1 ? '' : ' ' + count)
      },
      getLogoutSummaryTotalText: function () {
        return this.getStatisticsShowStr(this.getLogoutSummary().totalCount, this.getAllSummary().totalCount)
      },
      getLogoutSummaryWhiteText: function () {
        var summary = this.getLogoutSummary()
        return this.getStatisticsShowStr(summary.whiteCount, summary.totalCount)
      },
      getLogoutSummaryGreenText: function () {
        var summary = this.getLogoutSummary()
        return this.getStatisticsShowStr(summary.greenCount, summary.totalCount)
      },
      getLogoutSummaryBlueText: function () {
        var summary = this.getLogoutSummary()
        return this.getStatisticsShowStr(summary.blueCount, summary.totalCount)
      },
      getLogoutSummaryOrangeText: function () {
        var summary = this.getLogoutSummary()
        return this.getStatisticsShowStr(summary.orangeCount, summary.totalCount)
      },
      getLogoutSummaryRedText: function () {
        var summary = this.getLogoutSummary()
        return this.getStatisticsShowStr(summary.redCount, summary.totalCount)
      },
      getSummaryTotalText: function (index) {
        return this.getStatisticsShowStr(this.getSummary(index).totalCount, this.getAllSummary().totalCount)
      },
      getSummaryWhiteText: function (index) {
        var summary = this.getSummary(index)
        return this.getStatisticsShowStr(summary.whiteCount, summary.totalCount)
      },
      getSummaryGreenText: function (index) {
        var summary = this.getSummary(index)
        return this.getStatisticsShowStr(summary.greenCount, summary.totalCount)
      },
      getSummaryBlueText: function (index) {
        var summary = this.getSummary(index)
        return this.getStatisticsShowStr(summary.blueCount, summary.totalCount)
      },
      getSummaryOrangeText: function (index) {
        var summary = this.getSummary(index)
        return this.getStatisticsShowStr(summary.orangeCount, summary.totalCount)
      },
      getSummaryRedText: function (index) {
        var summary = this.getSummary(index)
        return this.getStatisticsShowStr(summary.redCount, summary.totalCount)
      },
      getCurrentSummaryTotalText: function () {
        return this.getStatisticsShowStr(this.getCurrentSummary().totalCount, this.getAllSummary().totalCount)
      },
      getCurrentSummaryWhiteText: function () {
        var summary = this.getCurrentSummary()
        return this.getStatisticsShowStr(summary.whiteCount, summary.totalCount)
      },
      getCurrentSummaryGreenText: function () {
        var summary = this.getCurrentSummary()
        return this.getStatisticsShowStr(summary.greenCount, summary.totalCount)
      },
      getCurrentSummaryBlueText: function () {
        var summary = this.getCurrentSummary()
        return this.getStatisticsShowStr(summary.blueCount, summary.totalCount)
      },
      getCurrentSummaryOrangeText: function () {
        var summary = this.getCurrentSummary()
        return this.getStatisticsShowStr(summary.orangeCount, summary.totalCount)
      },
      getCurrentSummaryRedText: function () {
        var summary = this.getCurrentSummary()
        return this.getStatisticsShowStr(summary.redCount, summary.totalCount)
      },
      getAllSummaryTotalText: function () {
        return this.getStatisticsShowStr(this.getAllSummary().totalCount, this.getAllSummary().totalCount)
      },
      getAllSummaryWhiteText: function () {
        var summary = this.getAllSummary()
        return this.getStatisticsShowStr(summary.whiteCount, summary.totalCount)
      },
      getAllSummaryGreenText: function () {
        var summary = this.getAllSummary()
        return this.getStatisticsShowStr(summary.greenCount, summary.totalCount)
      },
      getAllSummaryBlueText: function () {
        var summary = this.getAllSummary()
        return this.getStatisticsShowStr(summary.blueCount, summary.totalCount)
      },
      getAllSummaryOrangeText: function () {
        var summary = this.getAllSummary()
        return this.getStatisticsShowStr(summary.orangeCount, summary.totalCount)
      },
      getAllSummaryRedText: function () {
        var summary = this.getAllSummary()
        return this.getStatisticsShowStr(summary.redCount, summary.totalCount)
      },

      isSummaryShow: function (accountIndex) {
        if (accountIndex == -1) {
          return this.isLogoutSummaryShow()
        }
        var accounts = this.accounts
        if (accountIndex == accounts.length) {
          return this.isAllSummaryShow()
        }

        if (accountIndex < 0 || accountIndex >= accounts.length) {
          return false
        }

        // var ci = this.isTestCaseShow ? this.accounts[accountIndex] : null
        var ci = this.accounts[accountIndex]
        return ci != null && ci.totalCount != null && ci.totalCount > 0
      },
      isLogoutSummaryShow: function () {
        // var ci = this.isCrossEnabled != true ? null : this.logoutSummary
        var ci = this.logoutSummary
        return ci != null && ci.totalCount != null && ci.totalCount > 0
      },
      isCurrentSummaryShow: function () {
        return this.isSummaryShow(this.currentAccountIndex)
      },
      isAllSummaryShow: function () {
        // var ci = this.isCrossEnabled != true ? null : this.allSummary
        var ci = this.allSummary
        return ci != null && ci.totalCount != null && ci.totalCount > 0
      },
      isRandomSummaryShow: function () {
        var ci = this.isRandomListShow || this.isRandomSubListShow ? this.getCurrentRandomSummary() : null
        return ci != null && ci.totalCount != null && ci.totalCount > 0
      },

      updateSummary: function (item, change, key) {
        if (change == null || key == null) {
          return item
        }

        if (item == null) {
          item = {}
        }

        var count = item[key]
        if (count == null || count < 0) {
          count = 0
        }
        count += change

        item[key] = count

        // 对于 Random 进入子项再退出后有时显示居然不准
        // if (cri.totalCount == null) {
        //   cri.totalCount = 0
        // }
        // cri.totalCount += change
        // if (cri.totalCount < 0) {
        //   cri.totalCount = 0
        // }
        item.totalCount = item.whiteCount + item.greenCount + item.blueCount + item.orangeCount + item.redCount

        return item
      },

      //更新父级总览数据
      updateToSummary: function (item, change, accountIndex) {
        if (item == null || change == null) {
          return
        }

        var key = item.compareColor + 'Count'
        this.allSummary = this.updateSummary(this.allSummary, change, key)

        if (accountIndex == -1) {
          this.logoutSummary = this.updateSummary(this.logoutSummary, change, key)
        }
        else if (accountIndex >= 0 && accountIndex < this.accounts.length) {
          var accountItem = this.updateSummary(this.getSummary(accountIndex), change, key)
          this.accounts[accountIndex] = accountItem
        }
      },
      updateToRandomSummary: function (item, change, accountIndex) {
        var random = item == null || change == null ? null : item.Random
        if (random == null) {
          return
        }

        if (random.count == 1 || (random.id != null && random.id < 0)) {
          var key = item.compareColor + 'Count'
          this.updateToSummary(item, change, accountIndex)

          var curRandom = this.isRandomListShow || this.currentRandomItem == null ? null : this.currentRandomItem.Random
          var isTemp = curRandom != null && (curRandom.id == null || curRandom.id < 0)
          var cri = this.updateSummary(isTemp ? this.currentRandomItem : this.currentRemoteItem, change, key)  // this.getCurrentRandomSummary())

          if (isTemp) {
            this.currentRandomItem = cri
            this.updateSummary(this.currentRemoteItem, change, key)
          } else {
            this.currentRemoteItem = cri
            Vue.set(this.testCases, this.currentDocIndex, cri)
          }

          var toId = random.toId
          if (toId != null && toId > 0) {
            for (var i in this.randoms) {
              var toIt = this.randoms[i]
              if (toIt != null && toIt.Random != null && toIt.Random.id == toId) {

                var toRandom = toIt.Random
                var id = toRandom == null ? 0 : toRandom.id
                var count = id == null || id <= 0 ? 0 : toRandom.count
                if (count != null && count > 1) {
                  toIt = this.updateSummary(toIt, change, key)
                  Vue.set(this.randoms, i, toIt)
                }

                break
              }
            }
          }
        }
      },

      /**移除调试字段
       * @param obj
       */
      removeDebugInfo: function (obj) {
        if (obj != null) {
          delete obj["trace"]
          // 保留 delete obj["sql:generate|cache|execute|maxExecute"]
          // 保留 delete obj["depth:count|max"]
          delete obj["time:start|duration|end"]
          delete obj["time:start|duration|end|parse|sql"]
          // 保留 delete obj["throw"]
          // 保留 delete obj["trace:throw"]
          delete obj["trace:stack"]
          delete obj["stack"]
          delete obj["debug:info|help"]
        }
        return obj
      },

      /**
       * @param index
       * @param item
       */
      downloadTest: function (index, item, isRandom) {
        item = item || {}
        var document;
        if (isRandom) {
          document = this.currentRemoteItem || {}
        }
        else {
          document = item.Method = item.Method || {}
        }
        var random = isRandom ? item.Random : null
        var testRecord = item.TestRecord = item.TestRecord || {}

        saveTextAs(
          '# APIJSON自动化回归测试-前\n主页: https://github.com/Tencent/APIJSON'
          + '\n\n方法名称: \n' + document.method
          + '\n返回结果: \n' + JSON.stringify(JSON.parse(testRecord.response || '{}'), null, '    ')
          , '测试：' + document.method + '-前.txt'
        )

        /**
         * 浏览器不允许连续下载，saveTextAs也没有回调。
         * 在第一个文本里加上第二个文本的信息？
         * beyond compare会把第一个文件的后面一段与第二个文件匹配，
         * 导致必须先删除第一个文件内的后面与第二个文件重复的一段，再重新对比。
         */
        setTimeout(function () {
          var tests = App.tests[String(App.currentAccountIndex)] || {}
          saveTextAs(
            '# APIJSON自动化回归测试-后\n主页: https://github.com/Tencent/APIJSON'
            + '\n\n方法名称: \n' + document.method
            + '\n返回结果: \n' + JSON.stringify(tests[document.id][isRandom ? random.id : 0] || {}, null, '    ')
            , '测试：' + document.method + '-后.txt'
          )


          if (StringUtil.isEmpty(testRecord.standard, true) == false) {
            setTimeout(function () {
              saveTextAs(
                '# APIJSON自动化回归测试-标准\n主页: https://github.com/Tencent/APIJSON'
                + '\n\n方法名称: \n' + document.method
                + '\n测试结果: \n' + JSON.stringify(testRecord.compare || '{}', null, '    ')
                + '\n测试标准: \n' + JSON.stringify(JSON.parse(testRecord.standard || '{}'), null, '    ')
                , '测试：' + document.method + '-标准.txt'
              )
            }, 5000)
          }

        }, 5000)

      },

      /**
       * @param index
       * @param item
       */
      handleTest: function (right, index, item, isRandom, isDuration, isCross) {
        item = item || {}
        var random = item.Random = item.Random || {}
        var document;
        if (isRandom) {
          if ((random.count || 0) > 1) {
            this.currentRandomIndex = index
            // this.currentRandomSubIndex = -1
            this.restoreRandom(index, item)
            this.randomSubs = (item.subs || item['[]']) || []
            this.isRandomSubListShow = true
            this.getCurrentRandomSummary().summaryType = 'total'
            return
          }

          this.currentRandomSubIndex = index
          document = this.currentRemoteItem || {}
        }
        else {
          this.currentDocIndex = index
          this.currentRemoteItem = item
          // this.currentRandomIndex = -1
          // this.currentRandomSubIndex = -1
          document = item.Method = item.Method || {}
        }
        var testRecord = item.TestRecord = item.TestRecord || {}

        var tests = this.tests[String(this.currentAccountIndex)] || {}
        var currentResponse = (tests[isRandom ? random.documentId : document.id] || {})[
          isRandom ? (random.id > 0 ? random.id : (random.toId + '' + random.id)) : 0
        ] || {}

        var rawRspStr = JSON.stringify(currentResponse)

        const list = isRandom ? (random.toId == null || random.toId <= 0 ? this.randoms : this.randomSubs) : this.testCases

        var isBefore = item.showType == 'before'
        if (right != true) {
          item.showType = isBefore ? 'after' : 'before'
          Vue.set(list, index, item);

          var res = isBefore ? rawRspStr : testRecord.response
          if (isRandom && ! isBefore) {
            res = res || ((this.currentRemoteItem || {}).TestRecord || {}).response
          }

          this.view = 'code'
          this.jsoncon = res || ''
        }
        else {
          var url

          if (isBefore) { //撤回原来错误提交的校验标准
            if (isDuration) {
              alert('撤回上次的耗时需要删除上次的对比标准，请点左边 [错的，撤回] 按钮')
              return
            }

            url = this.server + '/delete'
            const req = {
              TestRecord: {
                id: testRecord.id, //TODO 权限问题？ item.userId,
              },
              tag: 'TestRecord'
            }

            this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, url, req, {}, function (url, res, err) {
              App.onResponse(url, res, err)

              var data = res.data || {}
              if (JSONResponse.isSuccess(data) != true && testRecord!= null && testRecord.id != null) {
                alert('撤回最新的校验标准 异常：\n' + data.msg)
                return
              }

              if (isRandom) {
                App.updateToRandomSummary(item, -1, App.currentAccountIndex)
              } else {
                App.updateToSummary(item, -1, App.currentAccountIndex)
              }

              if (isDuration) {
                item.durationColor = 'black'
                item.durationHint = '正常：在以往最快和最慢之间'
              }
              else {
                item.compareType = JSONResponse.COMPARE_NO_STANDARD
                item.compareMessage = '查看结果'
                item.compareColor = 'white'
                item.hintMessage = '没有校验标准！'
                item.TestRecord = null
              }

              App.updateTestRecord(0, list, index, item, JSON.parse(rawRspStr), isRandom, true, App.currentAccountIndex, isCross)
            })
          }
          else { //上传新的校验标准
            // if (isRandom && random.id <= 0) {
            //   alert('请先上传这个配置！')
            //   App.currentRandomItem = random
            //   App.showExport(true, false, true)
            //   return
            // }
            var isML = this.isMLEnabled;  // 异常分支不合并内容，只记录 code, throw, msg 等关键信息

            var standard
            var stddObj

            var minDuration = testRecord.minDuration
            var maxDuration = testRecord.maxDuration
            if (isDuration) {
              if (item.duration == null) {  // 没有获取到
                alert('最外层缺少字段 "time:start|duration|end"，无法对比耗时！')
                return
              }
              else if (maxDuration == null && minDuration == null) {
                maxDuration = item.duration
                minDuration = Math.round(maxDuration*0.8)
              }
              else if (maxDuration == null && minDuration != null) {
                maxDuration = Math.max(minDuration, item.duration)
                testRecord.minDuration = Math.min(minDuration, item.duration)
              }
              else if (minDuration == null && maxDuration != null) {
                minDuration = Math.min(maxDuration, item.duration)
                testRecord.maxDuration = Math.max(maxDuration, item.duration)
              }
              else if (maxDuration >= 0 && maxDuration < item.duration) {
                maxDuration = item.duration
              }
              else if (minDuration >= 0 && minDuration > item.duration) {
                minDuration = item.duration
              }
              else {  // 已经在正常范围中，不需要纠错
                alert('耗时已经在正常范围中，不需要纠错！')
                return
              }
            }
            else {
              standard = (StringUtil.isEmpty(testRecord.standard, true) ? null : JSON.parse(testRecord.standard)) || {}
              stddObj = JSONResponse.updateFullStandard(standard, JSON.parse(rawRspStr), isML)
            }

            const isNewRandom = isRandom && random.id <= 0
            const userId = this.User.id

            //TODO 先检查是否有重复名称的！让用户确认！
            // if (isML != true) {
            url = this.server + '/post'
            const req = {
              Random: isNewRandom != true ? null : {
                toId: random.toId,
                userId: userId,
                documentId: random.documentId,
                name: random.name,
                count: random.count,
                config: random.config
              },
              TestRecord: isDuration ? Object.assign(testRecord, {
                id: undefined,
                reportId: this.reportId,
                host: this.getBaseUrl(),
                userId: userId,
                testAccountId: this.getCurrentAccountId(),
                duration: item.duration,
                minDuration: minDuration,
                maxDuration: maxDuration,
                compare: JSON.stringify(testRecord.compare || {}),
              }) : {
                userId: userId,
                documentId: isNewRandom ? null : (isRandom ? random.documentId : document.id),
                randomId: isRandom && ! isNewRandom ? random.id : null,
                reportId: this.reportId,
                host: this.getBaseUrl(),
                testAccountId: this.getCurrentAccountId(),
                compare: JSON.stringify(testRecord.compare || {}),
                response: rawRspStr,
                standard: isML ? JSON.stringify(stddObj) : null
              },
              tag: isNewRandom ? 'Random' : 'TestRecord'
            }
            // }
            // else {
            //   url = this.server + '/post/testrecord/ml'
            //   req = {
            //     documentId: document.id
            //   }
            // }

            this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, url, req, {}, function (url, res, err) {
              App.onResponse(url, res, err)

              var data = res.data || {}
              if (JSONResponse.isSuccess(data) != true) {
                if (isML) {
                  alert('机器学习更新标准 异常：\n' + data.msg)
                }
              }
              else {
                if (isRandom) {
                  App.updateToRandomSummary(item, -1, App.currentAccountIndex)
                } else {
                  App.updateToSummary(item, -1, App.currentAccountIndex)
                }

                var testRecord = item.TestRecord || {}
                if (isDuration) {
                  item.durationColor = 'black'
                  item.durationHint = '正常：在以往最快和最慢之间'
                }
                else {
                  item.compareType = JSONResponse.COMPARE_EQUAL
                  item.compareMessage = '查看结果'
                  item.compareColor = 'white'
                  item.hintMessage = '结果正确'

                  testRecord.compare = {
                    code: 0,
                    msg: '结果正确'
                  }
                  testRecord.response = rawRspStr
                  // testRecord.standard = stdd
                }

                if (isRandom) {
                  var r = req == null ? null : req.Random
                  if (r != null && (data.Random || {}).id != null) {
                    r.id = data.Random.id
                    item.Random = r
                  }
                  if ((data.TestRecord || {}).id != null) {
                    testRecord.id = data.TestRecord.id
                    if (r != null) {
                      testRecord.randomId = r.id
                    }
                  }
                }
                item.TestRecord = testRecord


                // if (! isNewRandom) {
                //   if (isRandom) {
                //     App.showRandomList(true, App.currentRemoteItem)
                //   }
                //   else {
                //     App.showTestCase(true, false)
                //   }
                // }

                App.updateTestRecord(0, list, index, item, JSON.parse(rawRspStr), isRandom, true, App.currentAccountIndex, isCross)
              }

            })

          }
        }
      },

      updateTestRecord: function (allCount, list, index, item, response, isRandom, ignoreTrend, accountIndex, isCross) {
        item = item || {}
        var doc = (isRandom ? item.Random : item.Method) || {}

        this.request(true, REQUEST_TYPE_POST, REQUEST_TYPE_JSON, this.server + '/get', {
          TestRecord: {
            documentId: isRandom ? doc.documentId : doc.id,
            randomId: isRandom ? doc.id : null,
            testAccountId: this.getCurrentAccountId(),
            'invalid': 0,
            'host': this.getBaseUrl(),
            '@order': 'date-',
            '@column': 'id,userId,testAccountId,documentId,randomId,reportId,duration,minDuration,maxDuration,response' + (this.isMLEnabled ? ',standard' : ''),
            'standard{}': this.isMLEnabled ? (this.database == 'SQLSERVER' ? 'len(standard)>2' : 'length(standard)>2') : null  // '@having': this.isMLEnabled ? 'json_length(standard)>0' : null
          }
        }, {}, function (url, res, err) {
          App.onResponse(url, res, err)

          var data = (res || {}).data || {}
          if (JSONResponse.isSuccess(data) != true) {
            alert('获取最新的校验标准 异常：\n' + data.msg)
            return
          }

          item.TestRecord = data.TestRecord
          App.compareResponse(res, allCount, list, index, item, response, isRandom, accountIndex, true, err, ignoreTrend, isCross);
        })
      },

      //显示详细信息, :data-hint :data, :hint 都报错，只能这样
      setRequestHint: function (index, item, isRandom, isClass) {
        item = item || {}
        var d = isRandom ? item.Random : item.Method;
        // this.$refs[isRandom ? 'randomTexts' : (isClass ? 'testCaseClassTexts' : 'testCaseMethodTexts')][index]
        //   .setAttribute('data-hint', r == null ? '' : (isRandom ? r : JSON.stringify(this.getRequest(isClass ? r.classArgs : r.methodArgs), null, ' ')));

        if (isRandom) {
          var toId = (d == null ? null : d.toId) || 0
          this.$refs[toId <= 0 ? 'randomTexts' : 'randomSubTexts'][index].setAttribute('data-hint', (d || {}).config == null ? '' : d.config);
        }
        else {
          if (isClass && d.static && StringUtil.isEmpty(d.cttr)) {
            return '';
          }

          var args = isClass ? (d.genericClassArgs || d.classArgs) : (d.genericMethodArgs || d.methodArgs);
          if (args instanceof Array == false || args.length <= 0) {
            var req = this.getRequest(d.request, {});
            args = isClass ? req.classArgs : req.methodArgs;
          }

          var s = '(';
          if (args != null) {
            var l = d.language || this.language

            for (var i = 0; i < args.length; i ++) {
              var arg = args[i];
              var type = JSONResponse.getType(arg);
              var val = type == 'object' ? (arg || {}).value : arg;

              if (type == 'string' && arg != null) {
                var ind = arg.indexOf(':');
                var t = ind < 0 ? null : arg.substring(0, ind).trim().toLowerCase();
                val = ind < 0 ? arg : arg.substring(ind + 1);

                if (t != '' && t != 'string' && t != 'str') {
                  try {
                    val = JSON.parse(val);
                  } catch (e) {
                    log(e)
                  }
                }
              }

              s += (i <= 0 ? '' : ', ') + (val == null ? CodeUtil.getCode4Value(l, null) : JSON.stringify(val, null, ' '));
            }
          }
          s += ')';

          this.$refs[isClass ? 'testCaseClassTexts' : 'testCaseMethodTexts'][index].setAttribute('data-hint', s);
        }
      },

      //显示详细信息, :data-hint :data, :hint 都报错，只能这样
      setTestHint: function(index, item, isRandom, isDuration, isHandle) {
        item = item || {};
        var toId = isRandom ? ((item.Random || {}).toId || 0) : 0;
        var h = isDuration ? item.durationHint : (isHandle ? item.compareMessage : item.hintMessage);
        this.$refs['test' + (isRandom ? (toId <= 0 ? 'Random' : 'RandomSub') : '') + (isHandle ? 'Handle' : 'Result')
         + (isDuration ? 'Duration' : '') + 'Buttons'][index].setAttribute('data-hint', h || '');
      },

      handleTestArg: function(hasTestArg, rawReq, delayTime, callback) {
        if (hasTestArg && IS_BROWSER) {
          vUrlComment.value = ""
          vComment.value = ""
          vWarning.value = ""
        }

        if (IS_BROWSER) {
          App.onChange(false)
        }

        if (hasTestArg && rawReq.send != "false" && rawReq.send != "null") {
          setTimeout(function () {
            if (rawReq.send == 'random') {
              App.onClickTestRandom(App.isCrossEnabled, callback)
            } else if (App.isTestCaseShow) {
              App.onClickTest(callback)
            } else {
              App.send(false, callback)
            }

            var url = vUrl.value || ''
            if (IS_BROWSER && (rawReq.jump == "true" || rawReq.jump == "null"
              || (rawReq.jump != "false" && App.isTestCaseShow != true && rawReq.send != 'random'
                && (url.endsWith("/get") || url.endsWith("/head"))
              )
            )) {
              setTimeout(function () {
                window.open(vUrl.value + "/" + encodeURIComponent(JSON.stringify(encode(JSON.parse(vInput.value)))))
              }, 2000)
            }
          }, Math.max(2000, delayTime))
        }
      },

      autoTest: function(callback, delayTime, isTest, rawReq, setting) {
        this.autoTestCallback = callback

        if (delayTime == null) {
          delayTime = 0
        }

        if (isTest == null) {
          isTest = true
        }

        if (rawReq == null) {
          rawReq = {
            send: true,
            type: REQUEST_TYPE_JSON,
            url: 'unitauto.test.TestUtil.divide'
          }
        }

        if (setting == null) {
          setting = StringUtil.isEmpty(rawReq.setting, true) ? null : JSON.parse(StringUtil.trim(rawReq.setting, true))
        }

        if (setting == null) {
          setting = {
            isLocalShow: false,
            isTestCaseShow: true,
            isRandomShow: true,
            isRandomListShow: false,
            isRandomSubListShow: false,
            isMLEnabled: true,
            isCrossEnabled: true,
            // testCaseCount: 100,
            testCasePage: 0,
            // randomCount: 100,
            randomPage: 0,
          }
        }

        rawReq.setting = setting

        this.isLocalShow = setting.isLocalShow
        this.isTestCaseShow = setting.isTestCaseShow
        this.isRandomShow = setting.isRandomShow
        this.isRandomListShow = setting.isRandomListShow
        this.isRandomSubListShow = setting.isRandomSubListShow
        this.isMLEnabled = setting.isMLEnabled
        this.isCrossEnabled = setting.isCrossEnabled
        // this.testCaseCount = setting.testCaseCount
        this.testCasePage = setting.testCasePage
        // this.randomCount = setting.randomCount
        this.randomPage = setting.randomPage
        this.server = 'http://localhost:8080' // this.getBaseUrl()

        // if (this.isCrossEnabled) {
        //   this.currentAccountIndex = -1
        // }

        this.login(true, function (url, res, err) {
          if (setting.isRandomShow && setting.isRandomListShow) {
            delayTime += Math.min(5000, (App.isMLEnabled ? 50 : 20) * (setting.randomCount || App.randomCount) + 1000)
            App.isRandomShow = true
            App.isRandomEditable = true
            App.isRandomListShow = false
            App.isRandomSubListShow = false
            // App.showRandomList(false, setting.isRandomSubListShow ? App.currentRandomItem : null, setting.isRandomSubListShow)
            App.showRandomList(true, setting.isRandomSubListShow ? (App.currentRandomItem || {}).Random : (App.currentRemoteItem || {}).Method, setting.isRandomSubListShow, function (url, res, err) {
              App.onRandomListResponse(true, setting.isRandomSubListShow, url, res, err)
              App.handleTestArg(isTest, rawReq, delayTime, callback)
            })
          }
          else {  // if (setting.isTestCaseShow) {
            delayTime += Math.min(5000, (App.isMLEnabled ? 30 : 10) * (setting.testCaseCount || App.testCaseCount) + 1000)

            // App.login(true)
            App.onLoginResponse(true, {
              type: 0, // 登录方式，非必须 0-密码 1-验证码
              phone: App.account,
              password: App.password,
              version: 1, // 全局默认版本号，非必须
              remember: vRemember.checked,
              format: false
            }, url, res, err)

            App.showTestCase(true, setting.isLocalShow, function (url, res, err) {
              App.onTestCaseListResponse(IS_BROWSER, url, res, err)
              App.isTestCaseShow = true
              App.handleTestArg(isTest, rawReq, delayTime, callback)
            })
          }

        })
      },

      toPathValuePairMap: function (json, path, map) {
        if (map == null) {
           map = {}
        }
        if (json == null) {
          return map
        }

        if (json instanceof Array) {
          for (var i = 0; i < json.length; i++) {
            var p = StringUtil.isEmpty(path) ? '' + i : path + '/' + i
            map = this.toPathValuePairMap(json[i], p, map)
          }
        }
        else if (json instanceof Object) {
          for (var k in json) {
            var p = StringUtil.isEmpty(path) ? k : path + '/' + k
            map = this.toPathValuePairMap(json[k], p, map)
          }
        }
        else {
          map[path == null ? '' : path] = json
        }

        return map
      },

      showOptions: function(target, text, before, after, isValue, filter) {
        currentTarget = target;
        isInputValue = isValue;
        selectionStart = target.selectionStart;
        selectionEnd = target.selectionEnd;
        App.selectIndex = -1;

        clearTimeout(handler);

        // var posX = 0, posY = 0;

        // var event = window.event;
        // if (event.pageX || event.pageY) {
        //   posX = event.pageX;
        //   posY = event.pageY;
        // }
        // else if (event.clientX || event.clientY) {
        //   posX = event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
        //   posY = event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
        // }
        // else if (target.offsetHeight || target.offsetWidth) {
        //   // posX = target.offsetHeight;
        //   // posY = target.offsetWidth;
        // }
        //
        // vOption.style.left = posX + 'px';
        // vOption.style.top = posY + 'px';


        var options = App.options;
        if (options.length > 0 && StringUtil.isNotEmpty(filter, true)) {
          var newOptions = [];
          for (var i = 0; i < options.length; i++) {
            var opt = options[i];
            var name = opt == null ? null : opt.name;
            if (name != null && name.indexOf(filter) >= 0) {
              newOptions.push(opt);
            }
          }

          // App.options = [];
          App.options = newOptions;
        }
        else {
          App.options = [];

          var stringType = CodeUtil.getType4Language(App.language, "string")
          var objectType = CodeUtil.getType4Language(App.language, "object")
          var arrayType = CodeUtil.getType4Language(App.language, "array")
          var varcharType = CodeUtil.getType4Language(App.language, "varchar")
          var intType = CodeUtil.getType4Language(App.language, "int")
          var booleanType = CodeUtil.getType4Language(App.language, "boolean")
          var isReq = App.isEditResponse != true

          if (target == vHeader) {
            if (isValue != true) {
              App.options = [
                {
                  name: "Cookie",
                  type: stringType,
                  comment: "指定 Cookie"
                }, {
                  name: "Set-Cookie",
                  type: stringType,
                  comment: "设置 Cookie"
                }, {
                  name: "Add-Cookie",
                  type: stringType,
                  comment: "添加 Cookie"
                }, {
                  name: "Token",
                  type: stringType,
                  comment: "指定 Token"
                }, {
                  name: "Authorization",
                  type: stringType,
                  comment: "授权"
                }, {
                  name: "Authentication",
                  type: stringType,
                  comment: "鉴权"
                }, {
                  name: "Content-Type",
                  type: stringType,
                  comment: "数据类型"
                }, {
                  name: "Accept",
                  type: stringType,
                  comment: "接收格式"
                }, {
                  name: "Accept-Encoding",
                  type: stringType,
                  comment: "接收编码"
                }, {
                  name: "Accept-Language",
                  type: stringType,
                  comment: "接收语言"
                }, {
                  name: "Cache-Control",
                  type: stringType,
                  comment: "缓存控制"
                }, {
                  name: "Connection",
                  type: stringType,
                  comment: "连接控制"
                }, {
                  name: "Keep-Alive",
                  type: stringType,
                  comment: "保持连接"
                }];
            }
          }
          else if (target == vRandom || target == vScript) {
            if (target == vScript) {
              App.options = [
                {
                  name: "type",
                  type: stringType,
                  comment: '请求格式类型：PARAM, JSON, FORM, DATA'
                },{
                  name: "url",
                  type: stringType,
                  comment: '请求地址，例如 http://localhost:8080/get '
                },{
                  name: "req",
                  type: objectType,
                  comment: '请求参数，例如 { format: true, "User": { "id": 82001 } } '
                },{
                  name: "header",
                  type: objectType,
                  comment: '请求头，例如 Cookie: abc123 '
                }];

              if (isValue) {
                App.options.push({
                  name: "callback(url, res, err)",
                  type: objectType,
                  comment: '回调函数'
                })
                App.options.push({
                  name: "sendRequest(isAdminOperation, method, type, url, req, header, callback)",
                  type: objectType,
                  comment: '真正发送请求函数'
                })
                App.options.push({
                  name: "App.request(isAdminOperation, method, type, url, req, header, callback)",
                  type: objectType,
                  comment: '包装发送请求函数'
                })
                App.options.push({
                  name: "if () {\n    \n} else if () {\n    \n} else {\n    \n}",
                  type: objectType,
                  comment: '包装发送请求函数'
                })
                App.options.push({
                  name: "switch () {\n    case 1:\n        \n        break\n    case 2:\n        \n        break\n    default:\n        \n        break\n}",
                  type: objectType,
                  comment: '包装发送请求函数'
                })
                App.options.push({
                  name: "try {\n    \n} catch(e) {\n    console.log(e)\n}",
                  type: objectType,
                  comment: '包装发送请求函数'
                })
                App.options.push({
                  name: "{}", type: objectType, comment: '对象'
                })
                App.options.push({
                    name: "[]", type: arrayType, comment: '数组'
                })
                App.options.push({
                    name: "undefined", name: "undefined", comment: '未定义'
                })
              }
              else {
                App.options.push({
                  name: "callback",
                  type: objectType,
                  comment: '回调函数 function(url, res, err) {} '
                })
              }
            }

            if (isValue != true) {
              var standardObj = null;
              try {
                var currentItem = App.isTestCaseShow ? App.remotes[App.currentDocIndex] : App.currentRemoteItem;
                standardObj = JSON.parse(((currentItem || {})[isReq ? 'Method' : 'TestRecord'] || {}).standard);
              } catch (e3) {
                log(e3)
              }
              if (standardObj == null) {
                standardObj = JSONResponse.updateStandard({},
                  isReq ? App.getRequest(vInput.value) : App.jsoncon == null ? null : JSON.parse(App.jsoncon)
                  , ['@time']
                )
              }

              var method = App.isTestCaseShow ? ((App.currentRemoteItem || {}).Method || {}).url : App.getMethod();
              var isRestful = ! JSONObject.isAPIJSONPath(method);
              var ind = method == null ? -1 : method.lastIndexOf('/');
              var ind2 = ind < 0 ? -1 : method.substring(0, ind).lastIndexOf('/');
              var table = method == null ? null : (ind < 0 ? method : (isRestful
                ? StringUtil.firstCase(method.substring(ind2+1, ind), true) : method.substring(ind+1))
              );

              var tableList = docObj == null ? null : docObj['[]']
              var isAPIJSONRouter = false // TODO

              var json = App.getRequest(vInput.value)
              var map = App.toPathValuePairMap(json) || {}
              for (var path in map) {
                if (StringUtil.isEmpty(path)) {
                  continue
                }

                var ks = StringUtil.split(path, '/')
                var tbl = ks.length < 2 ? table : ks[ks.length - 2]

                var v = map[path]
                var t = v == null ? null : CodeUtil.getType4Request(v)
                var k = ks[ks.length - 1]

                App.options.push({
                  name: target != vScript ? path : JSONResponse.formatKey(ks.join('_'), true, true, true, true, true, true),
                  type: t == null ? null : (t == 'string' ? stringType : (t == 'integer' ? intType : CodeUtil.getType4Language(App.language, t))),
                  comment: CodeUtil.getComment4Request(tableList, tbl, k, v, method, false, App.database, App.language
                    , isReq, ks, isRestful, standardObj, false, isAPIJSONRouter)
                })
              }
            }
            else if (target == vRandom) {
              App.options = [
                {
                  name: "ORDER_DB(-10, 100000, 'Comment', 'id')",
                  type: stringType,
                  comment: "从数据库顺序取值 function(min:Integer, max:Integer, table:String, column:String) 可使用 ORDER_DB+2(0, 100) 间隔 step = 2 位来升序取值"
                }, {
                  name: "ORDER_IN(true, 1, 'a')",
                  type: stringType,
                  comment: "从选项内顺序取值 function(val0:Any, val1:Any ...) 可使用 ORDER_INT-3(0, 100) 间隔 step = -3 位来降序取值"
                }, {
                  name: "ORDER_INT(-10, 100)",
                  type: stringType,
                  comment: "从范围内顺序取值 function(min:Integer, max:Integer) 可使用 ORDER_IN+(0, 100) 间隔 step = 1 位来升序取值"
                }, {
                  name: "RANDOM_DB(-10, 100000, 'Comment', 'id')",
                  type: stringType,
                  comment: "从数据库随机取值 function(min:Integer, max:Integer, table:String, column:String)"
                }, {
                  name: "RANDOM_IN(true, 1, 'a')",
                  type: stringType,
                  comment: "从选项内随机取值 function(val0:Any, val1:Any ...)"
                }, {
                  name: "RANDOM_INT(-10, 100)",
                  type: stringType,
                  comment: "从范围内随机取整数 function(min:Integer, max:Integer)"
                }, {
                  name: "RANDOM_NUM(-9.9, 99.99)",
                  type: stringType,
                  comment: "从范围内随机取小数 function(min:Number, max:Number, precision:Integer)"
                }, {
                  name: "RANDOM_STR()",
                  type: stringType,
                  comment: "从长度范围内随机取字符串 function(minLength:Integer, maxLength:Integer, regexp:String)"
                }, {
                  name: "undefined", type: "undefined", comment: '未定义'
                }, {
                  name: "Math.round(100*Math.random())", type: stringType, comment: '自定义代码'
                }
              ]
            }
            else {
              App.options.push({
                name: isSingle ? "res.key" : "res['key']", type: stringType, comment: '从上个请求的结果中取值'
              })
            }
          }
          else if (target == vInput) {
          var quote = isSingle ? "'" : '"';

          var table = null;
          var isArrayKey = false;
          var isSubqueryKey = false;

          var prev = before;
          while (prev != null && prev.length > 0) {
            var lastIndex = prev.lastIndexOf('{');
            prev = prev.substring(0, lastIndex).trimRight();

            if (prev.endsWith(':')) {
              prev = prev.substring(0, prev.length - 1).trimRight();
              var endsWithDoubleQuote = prev.endsWith('"')

              if (endsWithDoubleQuote || prev.endsWith("'")) {
                prev = prev.substring(0, prev.length - 1);
                lastIndex = prev.lastIndexOf('\n');

                var lastLine = prev.substring(lastIndex + 1, prev.length);
                var ind = lastLine.lastIndexOf(endsWithDoubleQuote ? '"' : "'");
                table = ind < 0 ? null : lastLine.substring(ind + 1, lastLine.length);

                if (App.isTableKey(table)) {
                  break;
                }
                if (table != null && table.endsWith('[]')) {
                  isArrayKey = true;
                  break;
                }
                if (table != null && table.endsWith('@')) {
                  isSubqueryKey = true;
                  break;
                }

                prev = lastIndex <= 0 ? '' : prev.substring(0, lastIndex);
              }
            }
          }

          if (isValue) {
            var lastIndex = before.lastIndexOf('\n');
            var lastLine = before.substring(lastIndex + 1, before.length);
            lastIndex = lastLine.lastIndexOf(':');
            lastLine = lastIndex < 0 ? '' : lastLine.substring(0, lastIndex).trim();

            var endsWithDoubleQuote = lastLine.endsWith('"')
            if (endsWithDoubleQuote || lastLine.endsWith("'")) {
              lastLine = lastLine.substring(0, lastLine.length - 1);
            }
            var ind = lastLine.lastIndexOf(endsWithDoubleQuote ? '"' : "'");
            var key = ind < 0 ? null : lastLine.substring(ind + 1, lastLine.length);

              switch (key) {
                case 'type':
                case '@type':
                  App.options = [{
                    name: quote + "boolean" + quote,
                    type: stringType
                  }, {
                    name: quote + "int" + quote,
                    type: stringType
                  }, {
                    name: quote + "long" + quote,
                    type: stringType
                  }, {
                    name: quote + "double" + quote,
                    type: stringType
                  }, {
                    name: quote + "String" + quote,
                    type: stringType
                  }, {
                    name: quote + "Object" + quote,
                    type: stringType
                  }, {
                    name: quote + "Array" + quote,
                    type: stringType
                  }, {
                    name: quote + "JSON" + quote,
                    type: stringType
                  }, {
                    name: quote + "JSONObject" + quote,
                    type: stringType
                  }, {
                    name: quote + "JSONArray" + quote,
                    type: stringType
                  }, {
                    name: quote + "Map<String,Object>" + quote,
                    type: stringType
                  }, {
                    name: quote + "List<String>" + quote,
                    type: stringType
                  }, {
                    name: quote + "Collection<String>" + quote,
                    type: stringType
                  }, {
                    name: quote + "Set<String>" + quote,
                    type: stringType
                  }];
                  break;
                case 'static':
                case 'reuse':
                case 'callback':
                case 'ui':
                  App.options = [{
                    name: "true",
                    type: booleanType
                  }, {
                    name: "false",
                    type: booleanType
                  }];
                  break;
                case 'timeout':
                    for (var i = 0; i <= 100; i++) {
                        App.options.push({
                          name: new String(100*i),
                          type: intType,
                          comment: '毫秒'
                        });
                    }
                  break;
                case 'constructor':
                  App.options = [
                    {name: quote + "getInstance" + quote, type: varcharType, comment: '获取实例'},
                    {name: quote + "getDefault" + quote, type: varcharType, comment: '获取实例'},
                    {name: quote + "get" + quote, type: varcharType, comment: '获取实例'},
                    {name: quote + "instance" + quote, type: varcharType, comment: '获取实例'},
                    {name: quote + "singleton" + quote, type: varcharType, comment: '获取单例'}
                  ];
                  break;
                case 'classArgs':
                  App.options = [{
                    name: "[]",
                    type: arrayType
                  }, {
                    name: "[\n        null\n    ]",
                    type: arrayType
                  }, {
                    name: "[\n        null,\n        null\n    ]",
                    type: arrayType
                  }];
                  break;
                case 'this':
                  App.options = [{
                    name: "{}",
                    type: objectType
                  }, {
                    name: "{\n        " + quote + "type" + quote + ": " + quote + "apijson.demo.server.model.User"
                        + quote + ",\n        " + quote + "value" + quote + ": {}\n    }",
                    type: objectType
                  }];
                  break;
                case 'methodArgs':
                  App.options = [{
                    name: "[]",
                    type: arrayType
                  }, {
                    name: "[\n" +
                        "        {\n" +
                        "            " + quote + "type" + quote + ": " + quote + "String" + quote + ",\n" +
                        "            " + quote + "value" + quote + ": " + quote + "APIJSON" + quote + "\n" +
                        "        }\n" +
                        "    ]",
                    type: arrayType
                  }, {
                    name: "[\n" +
                        "        {\n" +
                        "            " + quote + "type" + quote + ": " + quote + "int" + quote + ",\n" +
                        "            " + quote + "value" + quote + ": 1\n" +
                        "        },\n" +
                        "        {\n" +
                        "            " + quote + "type" + quote + ": " + quote + "boolean" + quote + ",\n" +
                        "            " + quote + "value" + quote + ": true\n" +
                        "        }\n" +
                        "    ]",
                    type: arrayType
                  }];
                  break;
                default:
                  if (key.endsWith(')') && key.indexOf('(') > 0) {
                      App.options = [{
                        name: "{\n" +
                            "                " + quote + "type" + quote + ": " + quote + "int" + quote + ",\n" +
                            "                " + quote + "return" + quote + ": 1,\n" +
                            "                " + quote + "callback" + quote + ": true\n" +
                            "            }",
                        type: stringType,
                        comment: '回调方法'
                      }];
                  }
                  break;
              }

              var columnList = App.getColumnListWithModelName(table);
              if (columnList != null) {
                var isHaving = key == '@having';
                var arr = ['max', 'min', 'sum', 'avg', 'length', 'len', 'json_length'];

                var ks = '';
                var first = true;
                for (var j = 0; j < columnList.length; j++) {
                  var column = App.getColumnObj(columnList, j)
                  var name = column == null ? null : column.column_name;
                  if (StringUtil.isEmpty(name, true)) {
                    continue;
                  }

                  var k = name;
                  switch (key) {
                    case '@having':
                      var which = Math.floor(arr.length * Math.random());
                      k = arr[which] + '(' + name + ')' + (Math.random() < 0.2 ? '<82010' : (Math.random() < 0.5 ? '>3' : '%2=0'));
                      break;
                    case '@order':
                      k = name + (Math.random() < 0.2 ? '' : (Math.random() < 0.5 ? '-' : '+'));
                      break;
                    case '@cast':
                      var t = column.column_type;
                      var ind = t == null ? -1 : t.indexOf('(');
                      k = name + ':' + StringUtil.toUpperCase(ind < 0 ? t : t.substring(0, ind));
                      break;
                    // case '@column':
                    // case '@group':
                    // case '@json':
                    // case '@null':
                    default:
                      k = name;
                      break;
                  }

                  App.options.push({
                    name: quote + k + quote,
                    type: CodeUtil.getType4Language(App.language, column.column_type),
                    comment: column.column_comment
                  })

                  ks += (first ? '' : (isHaving ? ';' : ',')) + k;
                  first = false;
                }

                App.options.push({
                  name: quote + ks + quote,
                  type: stringType,
                  comment: '所有字段组合'
                })
              }

          } else {
            App.options = [
              {name: "type", type: varcharType, comment: "类型"},
              {name: "value", type: objectType, comment: "值"},
              {name: "reuse", type: booleanType, comment: "复用实例"},
              {name: "callback", type: booleanType, comment: "是否为最终回调方法"},
              {name: "@type", type: varcharType, comment: "指定具体类型"},
              {name: "static", type: booleanType, comment: "是否为静态"},
              {name: "ui", type: booleanType, comment: "放 UI 线程执行，仅 Android 可用"},
              {name: "timeout", type: intType, comment: "超时时间"},
              {name: "package", type: varcharType, comment: "被测方法所在的包名"},
              {name: "class", type: varcharType, comment: "被测方法所在的包名"},
              {name: "constructor", type: varcharType, comment: "构造方法，如果是类似单例模式的类，不能用默认构造方法，可以自定义获取实例的方法，传参仍用 classArgs"},
              {name: "classArgs", type: arrayType, comment: "构造方法的参数值"},
              {name: "this", type: objectType, comment: "当前类实例，和 constructor & classArgs 二选一"},
              {name: "method", type: varcharType, comment: "被测方法名"},
              {name: "methodArgs", type: arrayType, comment: "被测方法的参数值"},
              {name: "callback(int,Result,Exception)", type: objectType, comment: "回调方法"},
              {name: "onResponse(Response)", type: objectType, comment: "回调方法"},
              {name: "onSuccess(int,Response)", type: objectType, comment: "回调方法"},
              {name: "onFailure(int,Exception)", type: objectType, comment: "回调方法"},
              {name: "onSucceed(Result)", type: objectType, comment: "回调方法"},
              {name: "onFailed(Exception)", type: objectType, comment: "回调方法"},
              {name: "onComplete()", type: objectType, comment: "回调方法"},
              {name: "onCancel()", type: objectType, comment: "回调方法"},
              {name: "onCreate()", type: objectType, comment: "回调方法"},
              {name: "onStart()", type: objectType, comment: "回调方法"},
              {name: "onRestart()", type: objectType, comment: "回调方法"},
              {name: "onStop()", type: objectType, comment: "回调方法"},
              {name: "onResume()", type: objectType, comment: "回调方法"},
              {name: "onPause()", type: objectType, comment: "回调方法"},
              {name: "onDestroy()", type: objectType, comment: "回调方法"}
            ];
          }
          }
        }

        if (App.options.length > 0) {
          vOption.focus();
        }
        else {
          target.focus();
        }
      }
    },
    watch: {
      jsoncon: function () {
        this.showJsonView()
      }
    },
    computed: {
      theme: function () {
        var th = this.themes[this.checkedTheme]
        var result = {}
        var index = 0;
        ['key', 'String', 'Number', 'Boolean', 'Null', 'link-link'].forEach(function(key) {
          result[key] = th[index]
          index++
        })
        return result
      }
    },
    created: function  () {
      try { //可能URL_BASE是const类型，不允许改，这里是初始化，不能出错
        var url = this.getCache('', 'URL_BASE')
        if (StringUtil.isEmpty(url, true) == false) {
          URL_BASE = url
        }
        var branch = this.getCache('', 'branch')
        if (StringUtil.isEmpty(branch, true) == false) {
          this.branch = branch
        }
        var database = this.getCache('', 'database')
        if (StringUtil.isEmpty(database, true) == false) {
          this.database = CodeUtil.database = database
        }
        var schema = this.getCache('', 'schema')
        if (StringUtil.isEmpty(schema, true) == false) {
          this.schema = CodeUtil.schema = schema
        }
        var language = this.getCache('', 'language')
        if (StringUtil.isEmpty(language, true) == false) {
          this.language = CodeUtil.language = language
        }

        // vUrl.value = this.language == CodeUtil.LANGUAGE_GO ? 'test.Divide.Divide' : 'unitauto.test.TestUtil.divide'

        var types = this.getCache('', 'types')
        if (types != null && types.length > 0) {
          this.types = types instanceof Array ? types : StringUtil.split(types)
        }
        var otherEnv = this.getCache('', 'otherEnv')
        if (StringUtil.isEmpty(otherEnv, true) == false) {
          this.otherEnv = otherEnv
        }
        var server = this.getCache('', 'server')
        if (StringUtil.isEmpty(server, true) == false) {
          this.server = server
        }
        var project = this.getCache('', 'project')
        if (StringUtil.isEmpty(project, true) == false) {
          this.project = project
        }

        this.locals = this.getCache('', 'locals', [])

        this.isDelegateEnabled = this.getCache('', 'isDelegateEnabled', this.isDelegateEnabled)
        this.isEncodeEnabled = this.getCache('', 'isEncodeEnabled', this.isEncodeEnabled)
        this.isEnvCompareEnabled = this.getCache('', 'isEnvCompareEnabled', this.isEnvCompareEnabled)
        //预览了就不能编辑了，点开看会懵 this.isPreviewEnabled = this.getCache('', 'isPreviewEnabled', this.isPreviewEnabled)
        this.isStatisticsEnabled = false // this.getCache('', 'isStatisticsEnabled', this.isStatisticsEnabled)
        this.isHeaderShow = this.getCache('', 'isHeaderShow', this.isHeaderShow)
        this.isRandomShow = this.getCache('', 'isRandomShow', this.isRandomShow)
      } catch (e) {
        console.log('created  try { ' +
          '\nvar url = this.getCache(, url) ...' +
          '\n} catch (e) {\n' + e.message)
      }
      try { //这里是初始化，不能出错
        var accounts = this.getCache(URL_BASE, 'accounts')
        if (accounts != null) {
          this.accounts = accounts
          this.currentAccountIndex = this.getCache(URL_BASE, 'currentAccountIndex')
        }
      } catch (e) {
        console.log('created  try { ' +
          '\nvar accounts = this.getCache(URL_BASE, accounts)' +
          '\n} catch (e) {\n' + e.message)
      }
      try { //这里是初始化，不能出错
        var otherEnvCookieMap = this.getCache(App.otherEnv, 'otherEnvCookieMap')
        if (otherEnvCookieMap != null) {
          this.otherEnvCookieMap = otherEnvCookieMap
        }
      } catch (e) {
        console.log('created  try { ' +
            '\nvar accounts = this.getCache(URL_BASE, accounts)' +
            '\n} catch (e) {\n' + e.message)
      }

      try { //可能URL_BASE是const类型，不允许改，这里是初始化，不能出错
        this.User = this.getCache(this.server, 'User', {})
        this.isCrossEnabled = this.getCache(this.server, 'isCrossEnabled', this.isCrossEnabled)
        this.isMLEnabled = this.getCache(this.server, 'isMLEnabled', this.isMLEnabled)
        this.crossProcess = this.isCrossEnabled ? '交叉账号:已开启' : '交叉账号:已关闭'
        this.testProcess = this.isMLEnabled ? '机器学习:已开启' : '机器学习:已关闭'
        // this.host = this.getBaseUrl()

        this.page = this.getCache(this.server, 'page', this.page)
        this.count = this.getCache(this.server, 'count', this.count)

        this.caseGroupPage = this.getCache(this.server, 'caseGroupPage', this.caseGroupPage)
        this.caseGroupCount = this.getCache(this.server, 'caseGroupCount', this.caseGroupCount)
        this.caseGroupSearch = this.getCache(this.server, 'caseGroupSearch', this.caseGroupSearch)
        this.caseGroupPages = this.getCache(this.server, 'caseGroupPages', this.caseGroupPages)
        this.caseGroupCounts = this.getCache(this.server, 'caseGroupCounts', this.caseGroupCounts)
        this.caseGroupSearches = this.getCache(this.server, 'caseGroupSearches', this.caseGroupSearches)

        this.testCasePage = this.getCache(this.server, 'testCasePage', this.testCasePage)
        this.testCaseCount = this.getCache(this.server, 'testCaseCount', this.testCaseCount)
        this.testCasePages = this.getCache(this.server, 'testCasePages', this.testCasePages)
        this.testCaseCounts = this.getCache(this.server, 'testCaseCounts', this.testCaseCounts)
        this.testCaseSearches = this.getCache(this.server, 'testCaseSearches', this.testCaseSearches)

        this.randomPage = this.getCache(this.server, 'randomPage', this.randomPage)
        this.randomCount = this.getCache(this.server, 'randomCount', this.randomCount)
        this.randomSubPage = this.getCache(this.server, 'randomSubPage', this.randomSubPage)
        this.randomSubCount = this.getCache(this.server, 'randomSubCount', this.randomSubCount)

        this.delegateId = this.getCache(this.server, 'delegateId', this.delegateId)
        this.otherEnvDelegateId = this.getCache(this.server, 'otherEnvDelegateId', this.otherEnvDelegateId)

        CodeUtil.thirdPartyApiMap = this.getCache(this.thirdParty, 'thirdPartyApiMap')
      } catch (e) {
        console.log('created  try { ' +
          '\nthis.User = this.getCache(this.server, User, {})' +
          '\n} catch (e) {\n' + e.message)
      }

      try {
        var accounts = this.accounts
        var num = accounts == null ? 0 : accounts.length
        for (var i = -1; i <= num; i++) {
          this.resetCount(this.getSummary(i), false, false, i)
        }
      } catch (e) {
        console.log('created  try { ' +
          '\nthis.User = this.getCache(this.server, User, {})' +
          '\n} catch (e) {\n' + e.message)
      }

      //无效，只能在index里设置 vUrl.value = this.getCache('', 'URL_BASE')

      this.listHistory()
      if (this.isScriptShow) {
        this.changeScriptType()
        this.listScript()
      }

      if (this.caseShowType != 1 && this.casePaths.length <= 0 && this.caseGroups.length <= 0) {
        this.selectCaseGroup(-1, null)
      }
      var rawReq = getRequestFromURL() || {}
      if (StringUtil.isNotEmpty(rawReq.language, true)) {
        this.language = rawReq.language;
      }
      // if (StringUtil.isNotEmpty(rawReq.project, true)) {
      //   this.project = rawReq.project;
      // }

      if (StringUtil.isEmpty(rawReq.type, true) && StringUtil.isEmpty(rawReq.reportId, true)) {
        this.transfer()

        if (this.User != null && this.User.id != null && this.User.id > 0) {
          setTimeout(function () {
            App.showTestCase(true, false)  // 本地历史仍然要求登录  this.User == null || this.User.id == null)
          }, 1000)
        }
      }
      else {
        setTimeout(function () {
          isSingle = ! isSingle

          var hasTestArg = false  // 避免 http://localhost:63342/UnitAuto/index.html?_ijt=fh8di51h7qip2d1s3r3bqn73nt 这种无意义参数
          if (StringUtil.isEmpty(rawReq.type, true) == false) {
            hasTestArg = true
            App.type = StringUtil.toUpperCase(rawReq.type, true)
            if (App.types == null) {
               App.types = [App.type]
            }
            else if (App.types.indexOf(App.type) < 0) {
              App.types.push(App.type)
            }
          }

          if (StringUtil.isEmpty(rawReq.url, true) == false) {
            hasTestArg = true
            vUrl.value = StringUtil.trim(rawReq.url)
          }

          if (StringUtil.isEmpty(rawReq.json, true) == false) {
            hasTestArg = true
            vInput.value = StringUtil.trim(rawReq.json)
          }

          if (StringUtil.isEmpty(rawReq.header, true) == false) {
            hasTestArg = true
            vHeader.value = StringUtil.trim(rawReq.header, true)
            App.isHeaderShow = true
          }

          if (StringUtil.isEmpty(rawReq.random, true) == false) {
            hasTestArg = true
            vRandom.value = StringUtil.trim(rawReq.random, true)
            App.isRandomShow = true
            App.isRandomListShow = false
          }
          if (StringUtil.isEmpty(rawReq.reportId, true) == false) {
            try {
              App.reportId = + StringUtil.trim(rawReq.reportId, true)
              if (Number.isNaN(App.reportId)) {
                throw new Error('URL query 中 reportId= 的值必须是 0 以上整数！')
              }
              App.isStatisticsEnabled = true
              App.isRandomShow = true
              App.isRandomListShow = false
              App.showTestCase(true, false)
            } catch (e) {
              App.onResponse(null, {}, e)
              alert(e)
            }
          }

          var delayTime = 0

          // URL 太长导致截断和乱码
          if (StringUtil.isEmpty(rawReq.setting, true) == false) {
            var save = rawReq.save == 'true'
            try {
              var setting = JSON.parse(StringUtil.trim(rawReq.setting, true)) || {}

              if ((setting.count != null && setting.count != App.count)
                || (setting.page != null && setting.page != App.page)
                || (setting.search != null && setting.search != App.search)) {
                delayTime += Math.min(5000, 30*(setting.count) + 1000)
                App.setDoc("");
                App.getDoc(function (d) {
                  App.setDoc(d);
                })
              }

              for (var k in setting) {
                var v = k == null ? null : setting[k]
                if (v == null) {
                  continue
                }
                App[k] = v  // App.$data[k] = app[k]

                if (save) {
                  App.saveCache('', k, v)
                }
              }

              if (setting.isTestCaseShow || (setting.isRandomShow && setting.isRandomListShow)) {
                var isTest = hasTestArg
                hasTestArg = false

                App.autoTest(null, delayTime, isTest, rawReq, setting)
              }
            } catch (e) {
              log(e)
            }
          }

          App.handleTestArg(hasTestArg, rawReq, delayTime)
        }, 2000)

      }


      // 快捷键 CTRL + I 格式化 JSON
      document.addEventListener('keydown', function(event) {
        // alert(event.key) 小写字母 i 而不是 KeyI

        var target = event.target;
        if (target == vSearch || target == vTestCaseSearch || target == vCaseGroupSearch) {
          return
        }

        var keyCode = event.keyCode;
        var isEnter = keyCode === 13;
        if (isEnter && target == vUrl) {
          App.send(false);
          event.preventDefault();
          return
        }
        var isDel = keyCode === 8 || keyCode === 46; // backspace 和 del
        var isChar = (keyCode >= 48 && keyCode <= 90) || (keyCode >= 106 && keyCode <= 111) || (keyCode >= 186 && keyCode <= 222);

        currentTarget = target;

        if (keyCode === 27) {  // ESC
          if (document.activeElement == vOption || App.options.length > 0) {
            App.options = [];
            if (target != null) {
              target.focus();
            }
            return;
          }
        }
        else if (keyCode === 40 || keyCode === 38) {  // 方向键 上 和 下
          if (document.activeElement == vOption || App.options.length > 0) {
            // currentTarget = target;
            if (keyCode === 38) {
              if (App.selectIndex >= 0) {
                App.selectIndex --
                App.selectInput(App.selectIndex < 0 ? null : App.options[App.selectIndex], App.selectIndex)
              }
            } else if (App.selectIndex < App.options.length) {
              App.selectIndex ++
              App.selectInput(App.selectIndex >= App.options.length ? null : App.options[App.selectIndex], App.selectIndex)
            }

            // var options = document.activeElement == vOption || App.options.length > 0 ? App.options : null; // vOption.options : null;
            // if (options != null) {
            //   for (var i = 0; i < options.length; i++) {
            //     var opt = options[i]
            //     if (opt != null && (opt.selected || i == App.selectIndex)) {
            //       if (keyCode === 38) {
            //         if (i > 0) {
            //           opt.selected = false
            //           options[i - 1].selected = true
            //           App.selectInput(App.options[i - 1], i - 1)
            //         }
            //       } else {
            //         if (i < options.length - 1) {
            //           opt.selected = false
            //           options[i + 1].selected = true
            //           App.selectInput(App.options[i + 1], i + 1)
            //         }
            //       }
            //
            //       break
            //     }
            //   }

            event.preventDefault();
            return;
            // }
          }
        }
        else if (isEnter || isDel) { // enter || delete
          if (document.activeElement == vOption || App.options.length > 0) { // hasFocus is undefined   vOption.hasFocus()) {

            var options = vOption.options || App.options
            if (options != null && options.length > 0) {
              if (isDel) {
                var selectionStart = target.selectionStart;
                var selectionEnd = target.selectionEnd;

                var text = StringUtil.get(target.value);
                var before = text.substring(0, selectionStart);
                var after = text.substring(selectionEnd);

                App.showOptions(target, text, before, after);
              }
              else {
                event.preventDefault();

                for (var i = 0; i < options.length; i++) {
                  var opt = options[i]
                  if (opt != null && (opt.selected || i == App.selectIndex)) {
                    // currentTarget = target;
                    App.selectInput(App.options[i], i, true);
                    return;
                  }
                }

                App.selectIndex - 1;
                App.options = [];
              }
            }

            return;
          }

          if (target == vUrl) {
          }
          else if (target != null && target != vOption) {
            var selectionStart = target.selectionStart;
            var selectionEnd = target.selectionEnd;

            var text = StringUtil.get(target.value);
            var before = text.substring(0, selectionStart);
            var after = text.substring(selectionEnd);

            var firstIndex = isEnter ? after.indexOf('\n') : -1;
            var firstLine = firstIndex <= 0 ? '' : after.substring(0, firstIndex);
            var tfl = firstLine.trimLeft();

            var hasRight = tfl.length > 0;
            if (isEnter && hasRight != true) {
              var aft = after.substring(firstIndex + 1);
              var fi = aft.indexOf('\n');
              tfl = fi < 0 ? aft : aft.substring(0, fi);
            }

            // var lastLineStart = isEnter && tfl.length > 0 ? -1 : before.lastIndexOf('\n') + 1;
            var lastLineStart = before.lastIndexOf('\n') + 1;
            var lastLine = lastLineStart < 0 ? '' : before.substring(lastLineStart);

            var prefixEnd = 0;
            for (var i = 0; i < lastLine.length; i++) {
              if (lastLine.charAt(i).trim().length > 0) {
                if (isDel) {
                  prefixEnd = 0;
                }
                break;
              }

              prefixEnd += 1;
            }


            var prefix = prefixEnd <= 0 ? '' : lastLine.substring(0, prefixEnd);

            var isStart = false;
            var isEnd = false;
            var hasPadding = false;
            var hasComma = false;
            var isVar = false;
            var isJSON = false;
            var hasNewKey = null;
            if (isEnter) {
              isEnd = tfl.startsWith(']') || tfl.startsWith('}')
              var tll = lastLine.trimRight();
              if (target != vInput) {
                hasNewKey = ! hasRight;
              }
              else if (isEnd || hasRight || tll.endsWith('[')) {
                hasNewKey = false;
              }
              // else if (tll.indexOf('":') > 1 || tll.indexOf("':") > 1) {
              else if (tll.indexOf(':') > 1) { // (target == vInput ? 1 : 0) || (target == vScript && tll.indexOf('=') > 0)) {
                hasNewKey = true;
              }
              // else {
              //   var ind = tll.indexOf(':')
              //   if (ind > 0) {
              //     var ind2 = tll.indexOf('"')
              //   }
              // }

              var lastInd = tfl.lastIndexOf('(');
              isVar = target == vScript && (before.indexOf('{') < 0 || (lastInd > 0 && tfl.endsWith('{') && tfl.lastIndexOf(')') > lastInd));
              isJSON = target == vInput || (isVar != true && target == vScript);

              isStart = tll.endsWith('{') || tll.endsWith('[');
              hasPadding = hasRight != true && isStart;

              tll = before.trimRight();
              hasComma = isJSON && isStart != true && isEnd != true && hasRight != true && tll.endsWith(',') != true;
              if (hasComma) {
                for (var i = before.length; i >= 0; i--) {
                  if (before.charAt(i).trim().length > 0) {
                    break;
                  }

                  selectionStart -= 1;
                }

                before = tll + ',';
                selectionStart += 1;
              }

              if (hasNewKey == null) {
                hasNewKey = tll.endsWith('{');
              }

            }

            if (prefix.length > 0 || (isEnter && target != vInput)) {
              if (isEnter) {
                // if (target == vScript) {
                //   hasNewKey = false // TODO 把全局定义的 function, variable 等放到 options。 var value = fun()
                //   target.value = before + '\n' + prefix + (hasPadding ? '    ' : '')
                //     + (isEnd ? after : (hasRight ? (hasPadding ? tfl : tfl) : '') + '\n' + after.substring(firstIndex + 1)
                //     );
                //   target.selectionEnd = target.selectionStart = selectionStart + prefix.length + 1 + (hasPadding ? 4 : 0);
                // }
                // else {
                  var newText = before + '\n' + prefix + (hasPadding ? '    ' : '')
                    + (hasNewKey ? (isJSON != true ? (isVar ? 'var ' : '') : (isSingle ? "''" : '""'))
                      + (isVar ? ' = ' : ': ') + (target == vHeader ? '' : 'null') + (hasComma || isEnd || isJSON != true ? '' : ',') : '')
                    + (isEnd ? after : (hasRight ? (hasPadding ? tfl.trimLeft() : tfl) : '') + '\n' + after.substring(firstIndex + 1)
                    );
                  target.value = newText
                  if (target == vScript) { // 不这样会自动回滚
                    App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = newText
                  }

                  target.selectionEnd = target.selectionStart = selectionStart + prefix.length + (hasComma && isJSON ? 1 : 0)
                    + (hasNewKey ? 1 : 0) + (hasPadding ? 4 : 0) + (isVar ? 4 : (isJSON ? 1 : 0));
                // }
                event.preventDefault();

                if (hasNewKey) {
                  App.showOptions(target, text, before, after);
                  if (target == vInput) {
                    inputted = target.value;
                  }
                  return;
                }
              }
              else if (isDel) {
                var newStr = (selectionStart == selectionEnd ? StringUtil.get(before.substring(0, lastLineStart - 1) + ' ') : before) + after;
                target.value = newStr;
                if (target == vScript) { // 不这样会自动回滚
                  App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = newStr
                }

                target.selectionEnd = target.selectionStart = selectionStart == selectionEnd ? lastLineStart - 1 : selectionStart;
                event.preventDefault();
              }

              if (target == vInput) {
                inputted = target.value;
              }
            }
          }
        }
        else if (target != null && keyCode === 9) {  // Tab 加空格
          try {
            var selectionStart = target.selectionStart;
            var selectionEnd = target.selectionEnd;

            var text = StringUtil.get(target.value);
            var before = text.substring(0, selectionStart);
            var after = text.substring(selectionEnd);

            var ind = before.lastIndexOf('\n');
            var start = ind < 0 ? 0 : ind + 1;
            ind = after.indexOf('\n');
            var end = ind < 0 ? text.length : selectionEnd + ind - 1;

            var selection = text.substring(start, end);
            var lines = StringUtil.split(selection, '\n');

            var newStr = text.substring(0, start);

            var prefix = '    ';
            var prefixLen = prefix.length;
            for (var i = 0; i < lines.length; i ++) {
              var l = lines[i] || '';
              if (i > 0) {
                newStr += '\n';
              }

              newStr += prefix + l;
              if (i <= 0) {
                selectionStart += prefixLen;
              }
              selectionEnd += prefixLen;
            }

            newStr += text.substring(end);

            target.value = newStr;
            if (target == vScript) { // 不这样会自动回滚
              App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = newStr
            }

            event.preventDefault();
            if (target == vInput) {
              inputted = newStr;
            }

            target.selectionStart = selectionStart;
            target.selectionEnd = selectionEnd;
          } catch (e) {
            log(e)
          }
        }
        else if ((event.ctrlKey || event.metaKey) && keyCode == 83) { // Ctrl + S 保存
          App.showSave(true)
          event.preventDefault()
        }
        else if (target != null && (event.ctrlKey || event.metaKey) && ([68, 73, 191].indexOf(keyCode) >= 0 || (isChar != true && event.shiftKey != true))) {
          var selectionStart = target.selectionStart;
          var selectionEnd = target.selectionEnd;

          // 这里拿不到 clipboardData  if (keyCode === 86) {

          if (keyCode === 73) {  // Ctrl + 'I'  格式化
            try {
              if (target == vInput) {
                var json = JSON.stringify(JSON5.parse(vInput.value), null, '    ');
                vInput.value = inputted = isSingle ? App.switchQuote(json) : json;
              }
              else {
                var lines = StringUtil.split(target.value, '\n');
                var newStr = '';

                for (var i = 0; i < lines.length; i ++) {
                  var l = StringUtil.trim(lines[i]) || '';
                  if (l.startsWith('//')) {
                   continue;
                  }

                  var ind = l.lastIndexOf(' //');
                  l = ind < 0 ? l : StringUtil.trim(l.substring(0, ind));

                  if (target == vHeader || target == vRandom) {
                    ind = l.indexOf(':');
                    if (ind >= 0) {
                      var left = target == vHeader ? StringUtil.trim(l.substring(0, ind)) : l.substring(0, ind);
                      l = left + ': ' + StringUtil.trim(l.substring(ind + 1));
                    }
                  }

                  if (l.length > 0) {
                    newStr += '\n' + l;
                  }
                }

                newStr = StringUtil.trim(newStr);
                target.value = newStr;
                if (target == vScript) { // 不这样会自动回滚
                  App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = newStr
                }
              }
            } catch (e) {
              log(e)
            }
          }
          else if (target != null && keyCode === 191) {  // Ctrl + '/' 注释与取消注释
            try {
              var text = StringUtil.get(target.value);
              var before = text.substring(0, selectionStart);
              var after = text.substring(selectionEnd);

              var ind = before.lastIndexOf('\n');
              var start = ind < 0 ? 0 : ind + 1;
              ind = after.indexOf('\n');
              var end = ind < 0 ? text.length : selectionEnd + ind - 1;

              var selection = text.substring(start, end);
              var lines = StringUtil.split(selection, '\n');

              var newStr = text.substring(0, start);

              var commentSign = '//'
              var commentSignLen = commentSign.length

              for (var i = 0; i < lines.length; i ++) {
                var l = lines[i] || '';
                if (i > 0) {
                  newStr += '\n';
                }

                if (StringUtil.trim(l).startsWith(commentSign)) {
                  var ind = l.indexOf(commentSign);
                  var suffix = l.substring(ind + commentSignLen);
                  if (suffix.startsWith(' ')) {
                    suffix = suffix.substring(1);
                    if (i <= 0) {
                      selectionStart -= 1;
                    }
                    selectionEnd -= 1;
                  }

                  newStr += StringUtil.get(l.substring(0, ind)) + StringUtil.get(suffix)
                  if (i <= 0) {
                    selectionStart -= commentSignLen;
                  }
                  selectionEnd -= commentSignLen;
                }
                else {
                  newStr += commentSign + ' ' + l;
                  if (i <= 0) {
                    selectionStart += commentSignLen + 1;
                  }
                  selectionEnd += commentSignLen + 1;
                }
              }

              newStr += text.substring(end);

              target.value = newStr;
              if (target == vScript) { // 不这样会自动回滚
                App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = newStr
              }

              if (target == vInput) {
                inputted = newStr;
              }
            } catch (e) {
              log(e)
            }
          }
          else if (target != null && keyCode == 68) {  // Ctrl + 'D' 删除行
            try {
              var text = StringUtil.get(target.value);
              var before = text.substring(0, selectionStart);
              var after = text.substring(selectionEnd);

              var lastIndex = before.lastIndexOf('\n');
              var firstIndex = after.indexOf('\n');

              var newStr = (lastIndex < 0 ? '' : before.substring(0, lastIndex)) + '\n' + after.substring(firstIndex + 1);
              target.value = newStr;
              if (target == vScript) { // 不这样会自动回滚
                App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = newStr
              }

              selectionEnd = selectionStart = lastIndex + 1;
              event.preventDefault();

              if (target == vInput) {
                inputted = newStr;
              }
            } catch (e) {
              log(e)
            }
          }

          target.selectionStart = selectionStart;
          target.selectionEnd = selectionEnd;
        }
        else if (target != null && (event.shiftKey || isChar)) {
          if (isChar && App.options.length > 0) {
            var key = StringUtil.get(event.key);

            var selectionStart = target.selectionStart;
            var selectionEnd = target.selectionEnd;

            var text = StringUtil.get(target.value);
            var before = text.substring(0, selectionStart);
            var after = text.substring(selectionEnd);
            var selection = text.substring(selectionStart, selectionEnd);
            text = before + (isInputValue && selection == 'null' ? '' : selection) + key + after;

            target.value = text;
            if (target == vScript) { // 不这样会自动回滚
              App.scripts[App.scriptType][App.scriptBelongId][App.isPreScript ? 'pre' : 'post'].script = text
            }

            target.selectionStart = selectionStart;
            target.selectionEnd = (isInputValue && selection == 'null' ? selectionStart : selectionEnd) + key.length;
            event.preventDefault();

            App.showOptions(target, text, before, after, isInputValue, key);
          }

          return;
        }

        App.selectIndex = -1;
        App.options = [];
      })
    }
  }

  if (IS_BROWSER) {
    App = new Vue(App)
    window.App = App
  }
  else {

    var methods = App.methods
    if (methods instanceof Object && (methods instanceof Array == false)) {
      App = Object.assign(App, methods)
    }
    App.autoTest = App.autoTest || methods.autoTest

    var data = App.data
    if (data instanceof Object && (data instanceof Array == false)) {
      App = Object.assign(App, data)
    }

    module.exports = {getRequestFromURL, App}
  }

})()

// APIJSON >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

