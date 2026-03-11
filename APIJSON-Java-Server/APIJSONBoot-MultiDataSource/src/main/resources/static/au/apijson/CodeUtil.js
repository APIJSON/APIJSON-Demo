/*Copyright ©2017 TommyLemon(https://github.com/TommyLemon/AutoUI)

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use CodeUtil file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

if (typeof window == 'undefined') {
  try {
    eval(`
      var StringUtil = require("./StringUtil");
      var JSONObject = require("./JSONObject");
      var JSON5 = require('json5');
    `)
  } catch (e) {
    console.log(e)
  }
}

/**util for generate code
 * @author Lemon
 */
var CodeUtil = {
  TAG: 'CodeUtil',
  APP_NAME: 'AutoUI',
  DIVIDER: '/',

  LANGUAGE_KOTLIN: 'Kotlin',
  LANGUAGE_JAVA: 'Java',
  LANGUAGE_C_SHARP: 'C#',
  LANGUAGE_SWIFT: 'Swift',
//  LANGUAGE_OBJECTIVE_C: 'Objective-C',
  LANGUAGE_GO: 'Go',
  LANGUAGE_C_PLUS_PLUS: 'C++',
  LANGUAGE_TYPE_SCRIPT: 'TypeScript',
  LANGUAGE_JAVA_SCRIPT: 'JavaScript',
  LANGUAGE_PHP: 'PHP',
  LANGUAGE_PYTHON: 'Python',

  DATABASE_MYSQL: 'MYSQL',
  DATABASE_POSTGRESQL: 'POSTGRESQL',
  DATABASE_SQLITE: 'SQLITE',
  DATABASE_ORACLE: 'ORACLE',
  DATABASE_SQLSERVER: 'SQLSERVER',
  DATABASE_DB2: 'DB2',
  DATABASE_DAMENG: 'DAMENG',
  DATABASE_KINGBASE: 'KINGBASE',
  DATABASE_TIDB: 'TIDB',
  DATABASE_TDENGINE: 'TDENGINE',
  DATABASE_SURREALDB: 'SURREALDB',
  DATABASE_PRESTO: 'PRESTO',
  DATABASE_TRINO: 'TRINO',
  DATABASE_INFLUXDB: 'INFLUXDB',
  DATABASE_CLICKHOUSE: 'CLICKHOUSE',
  DATABASE_ELASTICSEARCH: 'ELASTICSEARCH',
  DATABASE_REDIS: 'REDIS',
  DATABASE_KAFKA: 'KAFKA',
  DATABASE_MARIADB: 'MARIADB',
  DATABASE_HIVE: 'HIVE',
  DATABASE_SNOWFLAKE: 'SNOWFLAKE',
  DATABASE_DATABRICKS: 'DATABRICKS',
  DATABASE_MILVUS: 'MILVUS',
  DATABASE_IOTDB: 'IOTDB',
  DATABASE_DUCKDB: 'DUCKDB',
  DATABASE_CASSANDRA: 'CASSANDRA',
  DATABASE_MONGODB: 'MONGODB',

  type: 'JSON',
  database: 'MYSQL',
  schema: 'sys',
  language: 'Kotlin',
  functionList: [],
  requestList: [],
  tableList: [],
  thirdParty: 'YAPI',
  thirdPartyApiMap: null,  // {}


  /**生成JSON的注释
   * @param reqStr //已格式化的JSON String
   * @param tableList
   * @param method
   * @param database
   * @param language
   * @return parseComment
   */
  parseComment: function (reqStr, tableList, method, database, language, isReq, standardObj, isExtract, isWarning, isAPIJSONRouter) { //怎么都获取不到真正的长度，cols不行，默认20不变，maxLineLength不行，默认undefined不变 , maxLineLength) {
    if (StringUtil.isEmpty(reqStr)) {
      return '';
    }

    var reqObj = JSON5.parse(reqStr);

    var methodInfo = JSONObject.parseUri(method, isReq) || {};
    method = methodInfo.method;
    var isRestful = methodInfo.isRestful;
    var tag = methodInfo.tag;
    var startName = methodInfo.table;

    if (isRestful != true) {
      method = method.toUpperCase();
    }

    var lines = reqStr.split('\n');

    var depth = startName == null ? 0 : 1;
    var names =  startName == null ? [] : [startName];
    var isInSubquery = false;

    var curObj = {
      parent: null,
      name: null,
      value: {
        [startName == null ? '' : startName]: reqObj
      }
    };

//    var cc = isRestful == true ? '//' : ' //'; // 对 APIJSON API 要求严格些，因为本来就有字段注释
//    var ccLen = cc.length;

    for (var i = 0; i < lines.length; i ++) {
      var line = lines[i].trim() || '';

      //每一种都要提取:左边的key
      var index = line.indexOf(':'); //可能是 ' 或 "，所以不好用 ': , ": 判断
      var key = index < 0 ? (depth <= 1 && startName != null ? startName : '') : line.substring(1, index - 1);
      var cIndex = line.lastIndexOf(' //');
      var ccLen = cIndex < 0 ? 2 : 3;
      if (cIndex < 0) {
        cIndex = line.lastIndexOf('//');
      }

      var comment = '';
      if (cIndex >= 0) {
        if (isExtract && standardObj != null && (isReq || depth != 1
          || [JSONResponse.KEY_CODE, JSONResponse.KEY_MSG, JSONResponse.KEY_THROW].indexOf(key) < 0)) {
          comment = line.substring(cIndex + ccLen).trim();
          // standardObj = CodeUtil.updateStandardByPath(standardObj, names, key, value, comment)
        }

        line = line.substring(0, cIndex).trim();
      }

      if (line.endsWith(',')) {
        line = line.substring(0, line.length - 1);
      }
      line = line.trim();

      var value = (curObj.value || {})[key];

      var hintComment;

      if (line.endsWith('{')) { //对象，判断是不是Table，再加对应的注释
        if (value == null) {
          value = {}
        }

        if (depth > 0 && comment.length > 0) {
          standardObj = JSONResponse.updateStandardByPath(standardObj, names, key, value, comment)
        }

        isInSubquery = key.endsWith('@');

        hintComment = CodeUtil.getComment4Request(tableList, names[depth - 1], key, value, method, false, database, language, isReq, names, isRestful, standardObj, isWarning, isAPIJSONRouter);

        names[depth] = key;
        depth ++;

        curObj = {
          parent: curObj,
          name: key,
          value: value
        };
      }
      else {
        if (line.endsWith('}')) {
          if (value == null) {
            value = {}
          }

          if (depth > 0 && comment.length > 0) {
            standardObj = JSONResponse.updateStandardByPath(standardObj, names, key, value, comment)
          }

          isInSubquery = false;

          if (line.endsWith('{}')) { //对象，判断是不是Table，再加对应的注释
            hintComment = CodeUtil.getComment4Request(tableList, names[depth - 1], key, value, method, false, database, language, isReq, names, isRestful, standardObj, isWarning, isAPIJSONRouter);
          }
          else {
            depth --;
            names = names.slice(0, depth);

            if (isWarning && i > 0 && i < lines.length - 1) {
              lines[i] = '';  // 节约性能，收尾不能为空，否则外面 trim 一下格式就变了对不上原文本。奇怪的是右大括号 } 总是不走这里
            }

            curObj = curObj.parent || {};
            continue;
          }
        }
        // else if (key == '') { //[ 1, \n 2, \n 3] 跳过
        //   if (depth > 0 && comment.length > 0) {
        //     standardObj = JSONResponse.updateStandardByPath(standardObj, names, 0, '', comment)
        //   }
        //
        //   continue;
        // }
        else {
          if (line.endsWith('[')) { // []  不影响
            if (value == null) {
              value = []
            }

            if (depth > 0 && comment.length > 0) {
              standardObj = JSONResponse.updateStandardByPath(standardObj, names, key, value, comment)
            }

            hintComment = CodeUtil.getComment4Request(tableList, names[depth - 1], key, value, method, false, database, language, isReq, names, isRestful, standardObj, isWarning, isAPIJSONRouter);

            names[depth] = key;
            depth ++;

            curObj = {
              parent: curObj,
              name: key,
              value: value
            };
          }
          else {
            if (line.endsWith(']')) {
              if (value == null) {
                value = []
              }

              if (depth > 0 && comment.length > 0) {
                standardObj = JSONResponse.updateStandardByPath(standardObj, names, key, value, comment)
              }

              if (line.endsWith('[]')) { //对象，判断是不是Table，再加对应的注释
                hintComment = CodeUtil.getComment4Request(tableList, names[depth - 1], key, value, method, false, database, language, isReq, names, isRestful, standardObj, isWarning, isAPIJSONRouter);
              }
              else {
                depth --;
                names = names.slice(0, depth);

                if (isWarning && i > 0 && i < lines.length - 1) {
                  lines[i] = '';  // 节约性能，收尾不能为空，否则外面 trim 一下格式就变了对不上原文本。奇怪的是右大括号 } 总是不走这里
                }

                curObj = curObj.parent || {};
                continue;
              }
            }
            else if (value == null) { //其它，直接在后面加上注释
              value = line.substring(index + 2).trim()
              if (value.startsWith('"')) {
                value = value.substring(1, value.lastIndexOf('"'))
              }
              else {
                try {
                  value = parseJSON(value)
                }
                catch (e) {
                  console.log(e)
                }
              }
            }
            // alert('depth = ' + depth + '; line = ' + line + '; isArray = ' + isArray);
            hintComment = CodeUtil.getComment4Request(tableList, names[depth - 1], key, value, method, isInSubquery, database, language, isReq, names, isRestful, standardObj, isWarning, isAPIJSONRouter);
          }
        }

        if (depth > 0 && comment.length > 0) {
          standardObj = JSONResponse.updateStandardByPath(standardObj, names, key, value, comment)
        }
      }

      // 普通注释需要完整保留原 JSON，以防预览请求不显示部分 JSON 内容
      if (isWarning && i > 0 && i < lines.length - 1 && StringUtil.isEmpty(hintComment, true)) {
        lines[i] = '';  // 节约性能，收尾不能为空，否则外面 trim 一下格式就变了对不上原文本。奇怪的是右大括号 } 总是不走这里
      }
      else {
        lines[i] += hintComment;
      }
    }

    var apiMap = isRestful ? CodeUtil.thirdPartyApiMap : null;
    var api = apiMap == null ? null : apiMap['/' + method];
    var detail = api == null ? null : api.detail;

    return lines.join('\n') + (StringUtil.isEmpty(detail, true) ? '' : '\n\n/*\n\n' + detail + '\n\n*/');
  },


  getOperation: function (method, json) {
        var ind = method == null ? -1 : method.indexOf('?');
        method = StringUtil.toLowerCase(ind < 0 ? method : method.substring(0, ind));
        if (method.startsWith('insert') || method.startsWith('post') || method.startsWith('add')
          || method.startsWith('pub') || method.startsWith('write')) {
          return 'INSERT'
        }
        if (method.startsWith('update') || method.startsWith('edit') || method.startsWith('put')
          || method.startsWith('patch') || method.startsWith('mutate') || method.startsWith('mod')) { // modify
          return 'UPDATE'
        }
        if (method.startsWith('del') || method.startsWith('remove') || method.startsWith('rmv')
          || method.startsWith('clear') || method.startsWith('clean') || method.startsWith('release')) {
          return 'DELETE'
        }
        if (method.startsWith('get') || method.startsWith('find') || method.startsWith('query') || method.startsWith('list')
          || method.startsWith('search') || method.startsWith('select') || method.startsWith('read')
          || method.startsWith('retrieve') || method.startsWith('fetch')) {
          return 'SELECT'
        }
        if (JSONResponse.getType(json) == 'object') {
          for (var key in json) {
              var k = key == null ? '' : key.replaceAll('_', '').toLowerCase()
              if (k.startsWith('page') || json.size != null || json.orderby != null) {
                 return 'SELECT'
              }
          }
        }
        return null // 'SELECT'
  },


  /**用数据字典转为 Python 类
   * @param docObj
   */
  parsePythonEntity: function(docObj, clazz, database) {
    //转为Java代码格式
    var doc = '';
    var item;

    var blank = CodeUtil.getBlank(1);
    var blank2 = CodeUtil.getBlank(2);

    //[] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    var list = docObj == null ? null : docObj['[]'];
    if (list != null) {
      console.log('parsePythonEntity  [] = \n' + format(JSON.stringify(list)));

      var table;
      var model;
      var columnList;
      var column;
      for (var i = 0; i < list.length; i++) {
        item = list[i];

        //Table
        table = item == null ? null : item.Table;
        model = CodeUtil.getModelName(table == null ? null : table.table_name);
        if (model != clazz) {
          continue;
        }

        console.log('parsePythonEntity [] for i=' + i + ': table = \n' + format(JSON.stringify(table)));


        doc += '/**'
            + '\n *' + CodeUtil.APP_NAME + ' 自动生成 Python Entity\n *主页: https://github.com/TommyLemon/' + CodeUtil.APP_NAME
            + '\n *使用方法：\n *1.修改包名 package \n *2.import 需要引入的类，可使用快捷键 Ctrl+Shift+O '
            + '\n */'
            + '\npackage apijson.demo.server.model;\n\n\n'
            + CodeUtil.getComment(database != 'POSTGRESQL' ? table.table_comment : (item.PgClass || {}).table_comment, true)
            + '\n@MethodAccess'
            + '\nclass ' + model + ':';

        //Column[]
        columnList = item['[]'];
        if (columnList != null) {

          console.log('parsePythonEntity [] for ' + i + ': columnList = \n' + format(JSON.stringify(columnList)));

          doc += '\n'
              + '\n' + blank + 'def __init__(self, id: int = 0):'
              + '\n' + blank2 + 'super().__init__()'
              + '\n' + blank2 + 'setId(id)'
              + '\n\n';

          var name;
          var type;

          for (var j = 0; j < columnList.length; j++) {
            column = (columnList[j] || {}).Column;

            name = CodeUtil.getFieldName(column == null ? null : column.column_name);
            if (name == '') {
              continue;
            }

            column.column_type = CodeUtil.getColumnType(column, database);
            type = CodeUtil.getType4Language(CodeUtil.LANGUAGE_PYTHON, column.column_type, false);


            console.log('parseCSharpEntity [] for j=' + j + ': column = \n' + format(JSON.stringify(column)));

            var o = database != 'POSTGRESQL' ? column : (columnList[j] || {}).PgAttribute
            doc += '\n' + blank + name + ': ' + type + ' = None ' + CodeUtil.getComment((o || {}).column_comment, false);

          }

          doc += '\n\n'

          for (var j = 0; j < columnList.length; j++) {
            column = (columnList[j] || {}).Column;

            name = CodeUtil.getFieldName(column == null ? null : column.column_name);
            if (name == '') {
              continue;
            }
            column.column_type = CodeUtil.getColumnType(column, database);
            type = CodeUtil.getType4Language(CodeUtil.LANGUAGE_PYTHON, column.column_type, false);

            console.log('parsePythonEntity [] for j=' + j + ': column = \n' + format(JSON.stringify(column)));

            //getter
            doc += '\n' + blank + 'def ' + CodeUtil.getMethodName('get', name) + '() -> ' + type + ':'
                + '\n' + blank2 + 'return ' + name;

            //setter
            doc += '\n' + blank + 'def ' + CodeUtil.getMethodName('set', name) + '(' + name + ': ' + type + '):'
                + '\n' + blank2 + 'self.' + name + ' = ' + name
                + '\n' + blank2 + 'return this';

          }
        }

        doc += '\n\n}';

      }
    }
    //[] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    return doc;
  },


  /**生成封装 Web-Python 请求JSON 的代码
   * 转换注释符号和关键词
   * @param reqStr
   * @return
   */
  parsePythonRequest: function(name, reqObj, depth, isSmart, reqStr) {
    if (isSmart != true) {
      if (StringUtil.isEmpty(reqStr, true) && reqObj != null) {
        reqStr = JSON.stringify(reqObj, null, '    ')
      }
      return StringUtil.trim(reqStr).replace(/\/\//g, '#').replace(/null/g, 'None').replace(/false/g, 'False').replace(/true/g, 'True').replace(/\/\*/g, isSmart ? '\'\'\'' : '"""').replace(/\*\//g, isSmart ? '\'\'\'' : '"""').replace(/'/g, '"')
    }

    if (depth == null || depth < 0) {
      depth = 0;
    }

    var isEmpty = true;
    if (reqObj instanceof Array) {
      isEmpty = reqObj.length <= 0;
    }
    else if (reqObj instanceof Object) {
      isEmpty = Object.keys(reqObj).length <= 0;
    }

    var padding = CodeUtil.getBlank(depth);
    var nextPadding = CodeUtil.getBlank(depth + 1);
    var nextNextPadding = CodeUtil.getBlank(depth + 2);
    var nextNextNextPadding = CodeUtil.getBlank(depth + 3);
    var quote = isSmart ? "'" : '"'

    return CodeUtil.parseCode(name, reqObj, {

      onParseParentStart: function () {
        return isEmpty ? '{' : '{\n';
      },

      onParseParentEnd: function () {
        return isEmpty ? '}' : ('\n' + CodeUtil.getBlank(depth) + '}');
      },

      onParseChildArray: function (key, value, index) {
        return (index > 0 ? ',\n' : '') + nextPadding + quote + key + quote + ': ' + CodeUtil.parsePythonRequest(key, value, depth + 1, isSmart);
      },

      onParseChildObject: function (key, value, index) {
        return (index > 0 ? ',\n' : '') + nextPadding + quote + key + quote + ': ' + CodeUtil.parsePythonRequest(key, value, depth + 1, isSmart);
      },

      onParseArray: function (key, value, index, isOuter) {
        var isEmpty = value.length <= 0;
        var s = '[' + (isEmpty ? '' : '\n');

        var inner = '';
        var innerPadding = isOuter ? nextNextPadding : nextNextNextPadding;
        for (var i = 0; i < value.length; i ++) {
          inner += (i > 0 ? ',\n' : '') + innerPadding + CodeUtil.parsePythonRequest(null, value[i], depth + (isOuter ? 1 : 2), isSmart);
        }
        s += inner;

        s += isEmpty ? ']' : '\n' + (isOuter ? nextPadding : nextNextPadding) + ']';
        return s;
      },

      onParseChildOther: function (key, value, index, isOuter) {
        var valStr = (value instanceof Array ? this.onParseArray(key, value, index, true) :CodeUtil.getCode4Value(CodeUtil.LANGUAGE_PYTHON, value, key, depth, isSmart));
        return (index > 0 ? ',\n' : '') + (key == null ? '' : (isOuter ? padding : nextPadding) + quote + key + quote + ': ') + valStr;
      }
    })

  },


  PYTHON_KEY_WORDS: [
    'bool', 'int', 'float', 'str', 'list', 'dict', 'is', 'as', 'type', 'import', 'from', 'def', 'assert', 'return',
    'None', 'False', 'True', 'null', 'false', 'true', 'print', 'for', 'in', 'range', 'yield', 'async', 'await',
    'if', 'elif', 'else', 'eval', 'exec', 'tuple', 'object', 'req', 'res', 'res_data', 'and', 'or', 'not'
  ],


  /**生成 Web-Python 解析 Response JSON 的代码
   * @param name_
   * @param resObj
   * @param depth
   * @param isSmart
   * @return parseCode
   */
  parsePythonResponse: function(name_, resObj, depth, isSmart, isML, funDefs, funNames) {
    if (depth == null || depth < 0) {
      depth = 0;
    }
    if (depth <= 0) {
      return CodeUtil.parsePythonResponseByStandard('', name_, resObj, null, 1, isSmart, false, funDefs, funNames);
    }

    if (funDefs == null) {
      funDefs = []
    }
    if (funNames == null) {
      funNames = []
    }

    var name = name_; //解决生成多余的解析最外层的初始化代码
    if (StringUtil.isEmpty(name, true)) {
      name = 'res_data';
    }

    var quote = "'";

    var str = CodeUtil.parseCode(name, resObj, {

      onParseParentStart: function () { //解决生成多余的解析最外层的初始化代码
        return depth > 0 || StringUtil.isEmpty(name_, true) == false ? '' : CodeUtil.getBlank(depth) + '# ' + name + (isSmart ? '' : ': dict') + ' = json.loads(resultJson) \n';
      },

      onParseParentEnd: function () {
        return '';
      },

      onParseChildArray: function (key, value, index) {
        return this.onParseChildObject(key, value, index);
      },

      onParseChildObject: function (key, value, index) {
        return this.onParseJSONObject(key, value, index);
      },

      onParseChildOther: function (key, value, index) {
        if (value instanceof Array) {
          log(CodeUtil.TAG, 'parsePythonResponse  for typeof value === "array" >>  ' );
          return this.onParseJSONArray(key, value, index);
        }

        if (value instanceof Object) {
          log(CodeUtil.TAG, 'parsePythonResponse  for typeof value === "array" >>  ' );
          return this.onParseJSONObject(key, value, index);
        }

        var type = value == null ? 'any' : CodeUtil.getPythonTypeFromJS(key, value);
        var padding = '\n' + CodeUtil.getBlank(depth);
        var varName = JSONResponse.getVariableName(key);
        if (varName.startsWith('_') != true && CodeUtil.PYTHON_KEY_WORDS.indexOf(varName) >= 0) {
          varName = '_' + varName // { '1': 0, '2': true ... } '1' -> '_1'
        }

        var funName = 'is_' + varName;
        if (isSmart && funNames.indexOf(funName) < 0) {
          var funDef = 'def ' + funName + '(' + varName + ': ' + type + ', strict: bool = False) -> bool:'
              + '\n    if is_' + (type == 'str' ? 'blank' : 'empty') + '(' + varName + '):'
              + '\n        return not strict'
              + '\n    return ' + varName + (type == 'bool' ? ' is ' : ' = ')
              + CodeUtil.getCode4Value(CodeUtil.LANGUAGE_PYTHON, value, key);
          funDefs.push(funDef);
          funNames.push(funName);
        }

        return padding + varName + (isSmart ? '' : ': ' + type) + ' = '
          + (isSmart ? ('get_val(' + name + ', ') : (name + '[')) + quote + key + quote + (isSmart ? ')' : ']')
          + padding + 'print(\'' + name + '.' + varName + ' = \' + str(' + varName + '))'
          + padding + 'assert is_' + varName + '(' + varName + ')\n';
      },

      onParseJSONArray: function (key, value, index) {
        value = value || []

        var padding = '\n' + CodeUtil.getBlank(depth);
        var innerPadding = padding + CodeUtil.getBlank(1);

        var k = JSONResponse.getVariableName(key, 'array');
        if (k.startsWith('_') != true && CodeUtil.PYTHON_KEY_WORDS.indexOf(k) >= 0) {
          k = '_' + k;
        }

        var itemName = StringUtil.addSuffix(k, 'Item') + (depth <= 0 ? '' : depth);

        //还有其它字段冲突以及for循环的i冲突，解决不完的，只能让开发者自己抽出函数  var item = StringUtil.addSuffix(k, 'Item');
        var type = value[0] == null ? 'any' : CodeUtil.getPythonTypeFromJS(key, value[0]);

        var s = '\n' + padding + '# ' + key + ' <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';

        //不支持 varname: list[int] 这种语法   s += padding + k + (isSmart ? '' : ': list[' + type + ']') + ' = ' + name + '[' + quote + key + quote + ']'
        s += padding + k + (isSmart ? '' : ': list') + ' = '
          + (isSmart ? ('get_val(' + name + ', ') : (name + '[')) + quote + key + quote + (isSmart ? ')' : ']') + ' or []'
        s += padding + '# assert not_none(' + k + ')';
        // s += padding + 'if ' + k + ' == None:';
        // s += padding + '    ' + k + ' = []\n';

        s += '\n' + padding + '#TODO 把这段代码抽取一个函数，以免for循环嵌套时 i 冲突 或 id等其它字段冲突';

        var indexName = 'i' + (depth <= 0 ? '' : depth + 1);
        s += padding + 'for ' + indexName + ' in range(len(' + k + ')):'; // let i in arr; let item of arr
        s += innerPadding + itemName + (isSmart ? '' : ': ' + type) + ' = ' + k + '[' + indexName + ']';
        s += innerPadding + 'assert not_none(' + itemName + ')';
        s += innerPadding + '# if ' + itemName + ' is None:';
        s += innerPadding + '#     continue\n';
        s += innerPadding + 'print(\'\\n' + itemName + ' = ' + k + '[\' + str(' + indexName + ') + \'] = \\n\' + str(' + itemName + ') + \'\\n\\n\'' + ')';
        s += innerPadding + '# TODO 你的代码\n';

        //不能生成N个，以第0个为准，可能会不全，剩下的由开发者自己补充。 for (var i = 0; i < value.length; i ++) {
        if (value[0] instanceof Object) {
          s += CodeUtil.parsePythonResponse(itemName, value[0], depth + 1, isSmart, isML, funDefs, funNames);
        }
        // }

        s += padding + '# ' + key + ' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n';

        return s;
      },

      onParseJSONObject: function (key, value, index) {
        var padding = '\n' + CodeUtil.getBlank(depth);
        var k = JSONResponse.getVariableName(key);
        if (k.startsWith('_') != true && CodeUtil.PYTHON_KEY_WORDS.indexOf(k) >= 0) {
          k = '_' + k;
        }

        var s = '\n' + padding + '# ' + key + ' <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';

        s += padding + k + (isSmart ? '' : ': dict') + ' = '
          + (isSmart ? ('get_val(' + k + ', ') : (k + '[')) + quote + key + quote + (isSmart ? ')' : ']') + ' or {}'
        s += padding + '# assert not_none(' + k + ')';
        // s += padding + 'if ' + k + ' == None:';
        // s += padding + '    ' + k + ' = {}\n';

        s += CodeUtil.parsePythonResponse(k, value, depth, isSmart, isML, funDefs, funNames);

        s += padding + '# ' + key + ' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n';

        return s;
      }
    })

    if (depth <= 0) {
      str = `def asserts(res):
res_data = rep.json()

` + str;

      if (funDefs.length > 0) {
        str += '\n\n\n# TODO 把这些通用函数放到专门的一个 asserter.py 文件中 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n'
            + funDefs.join('\n\n\n')
            + '\n\n# TODO 把这些通用函数放到专门的一个 asserter.py 文件中 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
      }
    }

    return str;
  },

  parsePythonResponseByStandard: function(name, key, target, real, depth, isSmart, ignoreDef, funDefs, funNames) {
    var isRoot = depth <= 1 && StringUtil.isEmpty(name, true);
    name = name == null ? 'res_data' : name;
    if (target == null) {
      if (real == null) {
        return '';
      }
      target = JSONResponse.updateStandardByPath(null, null, null, real);
    }
    if (target instanceof Array) { // JSONArray
      throw new Error('Standard 在 ' + name + ' 语法错误，不应该有 array！');
    }


    log('\n\n\n\n\nparsePythonResponseByStandard <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n' +
        ' \ntarget = ' + JSON.stringify(target, null, '    ') + '\n\n\nreal = ' + JSON.stringify(real, null, '    '));

    depth = depth == null || depth < 0 ? 0 : depth;

    funDefs = funDefs == null ? [] : funDefs;
    funNames = funNames == null ? [] : funNames;

    var quote = isSmart ? "'" : '"';

    var type_ = target.type;
    log('parsePythonResponseByStandard  type = target.type = ' + type_ + ' >>')
    var type = type_ == null ? 'any' : CodeUtil.getPythonTypeFromJSType(key, null, type_);

    var varName = JSONResponse.getVariableName(StringUtil.isEmpty(key, true) ? 'res_data' : key, 'array');
    if (varName.startsWith('_') != true && CodeUtil.PYTHON_KEY_WORDS.indexOf(varName) >= 0) {
      varName = '_' + varName;
    }

    var padding = '\n' + CodeUtil.getBlank(depth);
    var innerPadding = padding + CodeUtil.getBlank(1);

    var s = ignoreDef ? '' : (padding + varName + (isSmart ? '' : ': ' + type) + ' = ' + (
        StringUtil.isEmpty(key, true)
            ? 'res.json()'
            : (isSmart ? ('get_val(' + name + ', ') : (name + '[')) + quote + key + quote + (isSmart ? ')' : ']')
    ));

    if (ignoreDef != true) {
      if (type_ == 'object') {
        s += ' or {}'
      }
      else if (type_ == 'array') {
        s += ' or []'
      }
    }

    var notNull = target.notNull;
    log('parsePythonResponseByStandard  notNull = target.notNull = ' + notNull + ' >>');

    var funName = 'is_' + (isRoot ? '' : name + '_') + varName;
    var genFunDef = isSmart && funNames.indexOf(funName) < 0;

    var prefix = padding + 'assert ';
    var prefix2 = genFunDef ? '\n    if not (' : prefix;

    var funDef = ''
    if (isSmart) {
      if (genFunDef) {
        funDef = 'def ' + funName + '(' + varName + ': ' + type + ', strict: bool = False) -> bool:'
            + '\n    if is_' + (type == 'str' ? 'blank' : 'empty') + '(' + varName + '):'
            + '\n        return not strict'
            + '\n    if not is_' + type + '(' + varName + ', strict):'
            + '\n        return false\n'
      }
      s += prefix + funName + '(' + varName + ', ' + notNull + ')';
    } else {
      if (notNull) {
        s += prefix + 'not_none(' + varName + ')';
      }
      s += prefix + 'is_' + type + '(' + varName + ')';
    }

    var lengths = target.lengths;
    if (lengths != null && lengths.length > 0) {
      var lengthLevel = target.lengthLevel;

      var as = (genFunDef ? '\n    ' : padding) + varName + 'Len = 0 if ' + varName + ' is None else len(' + varName + ')'
      if (lengthLevel == 0 || lengths.length <= 1) {
        as += prefix2 + varName + 'Len in ' + JSON.stringify(lengths);
      } else {
        as += prefix2 + varName + 'Len >= ' + lengths[lengths.length - 1] + ' and ' + varName + 'Len <= ' + lengths[0];
      }

      if (isSmart) {
        if (genFunDef && StringUtil.isNotEmpty(as, true)) {
          funDef += as + '):\n        return false';
        }
      } else {
        s += as;
      }
    }

    var values = target.values;
    log('parsePythonResponseByStandard  values = target.values = ' + JSON.stringify(values, null, '    ') + ' >>');
    var firstVal = values == null || values.length <= 0 ? null : values[0];

    if (values != null && values.length > 0) {
      var valueLevel = target.valueLevel;
      log('parsePythonResponseByStandard  valueLevel = target.valueLevel = ' + valueLevel + ' >>');

      if (type_ == 'array') { // JSONArray
        log('parsePythonResponseByStandard  type == array >> ');
        var itemName = StringUtil.addSuffix(varName, 'Item') + (depth <= 1 ? '' : depth);

        s += '\n' + padding + '# TODO 把这段代码抽取一个函数，以免 for 循环嵌套时 i 冲突 或 id 等其它字段冲突';
        var indexName = 'i' + (depth <= 1 ? '' : depth);
        s += padding + 'for ' + indexName + ' in range(len(' + varName + ')):'; // let i in arr; let item of arr
        s += innerPadding + itemName + (isSmart ? '' : ': ' + type) + ' = ' + varName + '[' + indexName + ']';
        s += innerPadding + 'assert not_none(' + itemName + ')';
        s += innerPadding + '# if ' + itemName + ' is None:';
        s += innerPadding + '#     continue';

        var cs = CodeUtil.parsePythonResponseByStandard(varName, itemName, firstVal, null, depth + 1, isSmart, true, funDefs, funNames);
        if (StringUtil.isNotEmpty(cs, true)) {
          s += '\n' + innerPadding + cs.trim();
        }
      } else if (type_ == 'object') { // JSONObject
        log('parsePythonResponseByStandard  type == object >> ');

        var tks = firstVal == null ? [] : Object.keys(firstVal);
        var tk;
        for (var i = 0; i < tks.length; i++) { //遍历并递归下一层
          tk = tks[i];
          if (tk == null) {
            continue;
          }
          log('parsePythonResponseByStandard  for tk = ' + tk + ' >> ');
          var cs = CodeUtil.parsePythonResponseByStandard(varName, tk, firstVal[tk], null, depth, isSmart, false, funDefs, funNames);
          if (StringUtil.isNotEmpty(cs, true)) {
            s += '\n' + padding + cs.trim();
          }
        }
      } else { // Boolean, Number, String
        log('parsePythonResponseByStandard  type == boolean | number | string >> ');

        var as = '';
        if (type_ == 'number' || type_ == 'integer') {
          var select = (target.trend || {}).select;
          var maxVal = firstVal;
          var minVal = values == null || values.length <= 0 ? null : values[values.length - 1];

          if (select == '>') {
            as = prefix2 + varName + ' > ' + maxVal;
          } else if (select == '>=') {
            as = prefix2 + varName + ' >= ' + maxVal;
          } else if (select == '<') {
            as = prefix2 + varName + ' < ' + minVal;
          } else if (select == '<=') {
            as = prefix2 + varName + ' <= ' + minVal;
          } else if (select == '%' || (valueLevel == 1 || values.length >= 2)) {
            as = prefix2 + varName + ' >= ' + minVal + ' and ' + varName + ' <= ' + maxVal;
          } else {
            as = prefix2 + varName + ' in ' + JSON.stringify(values);
          }
        } else {
          as = prefix2 + varName + ' in ' + JSON.stringify(values);
        }

        if (isSmart) {
          if (genFunDef && StringUtil.isNotEmpty(as, true)) {
            funDef += as + '):\n        return false';
          }
        } else {
          s += as;
        }
      }

    }

    var fas = '';
    var format = target.format;
    if (typeof format == 'string' && FORMAT_PRIORITIES[format] != null) {
      var verifier = FORMAT_VERIFIERS[format];
      if (typeof verifier == 'function') {
        fas = prefix2 + verifier.name + '(' + varName + ', ' + notNull + ')';
      }
    }
    else if (format instanceof Array == false && format instanceof Object) {
      s += prefix2 + varName + '_json = json.loads(' + varName + ')'
      try {
        var realObj = parseJSON(real);
        var cs = CodeUtil.parsePythonResponseByStandard(varName + '_json', key, format, realObj, depth, isSmart, true, funDefs, funNames);
        if (StringUtil.isNotEmpty(cs, true)) {
          s += '\n' + padding + cs.trim();
        }
      } catch (e) {
        log(e)
      }

    }

    if (isSmart) {
      if (genFunDef && StringUtil.isNotEmpty(fas, true)) {
        funDef += fas + '):\n        return false';
      }
    } else {
      s += fas;
    }

    if (isSmart && genFunDef) {
      funDef += '\n    return true'
      funDefs.push(funDef);
      funNames.push(funName);
    }

    if (isRoot) {
      s = 'def asserts(res):'
          + '\n' + s
          + '\n    return res'

      if (funDefs.length > 0) {
        s += '\n\n\n# TODO 把这些通用函数放到专门的一个 asserter.py 文件中 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n'
            + funDefs.join('\n\n\n')
            + '\n\n# TODO 把这些通用函数放到专门的一个 asserter.py 文件中 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
      }
    }

    log('\nparsePythonResponseByStandard >> return s = ' + s + '\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n\n\n\n\n');
    return s;
  },


  /**解析出 生成请求JSON 的代码
   * @param name
   * @param reqObj
   * @param callback Object，带以下回调函数function：
   *                 解析父对象Parent的onParseParentStart和onParseParentEnd,
   *                 解析APIJSON数组Object的onParseArray,
   *                 解析普通Object的onParseObject,
   *                 解析其它键值对的onParseOther.
   *
   *                 其中每个都必须返回String，空的情况下返回'' -> response += callback.fun(...)
   * @return
   */
  parseCode: function(name, reqObj, callback) {
    // if (reqObj == null || reqObj == '') {
    //   log(CodeUtil.TAG, 'parseCode  reqObj == null || reqObj.isEmpty() >> return null;');
    //   return null;
    // }
    if (reqObj instanceof Object == false || reqObj instanceof Array) { // Array 居然也被判断成 object ！  typeof reqObj != 'object') {
      log(CodeUtil.TAG, 'parseCode  typeof reqObj != object >> return null;');
      // return null;
      return callback.onParseChildOther(name, reqObj, 0, true);
    }
    log(CodeUtil.TAG, '\n\n\n parseCode  name = ' + name + '; reqObj = \n' + format(JSON.stringify(reqObj)));

    var response = callback.onParseParentStart();

    var index = 0; //实际有效键值对key:value的所在reqObj内的位置
    var value;
    for (var key in reqObj) {
      log(CodeUtil.TAG, 'parseCode  for  key = ' + key);
      //key == null || value == null 的键值对被视为无效
      value = key == null ? null : reqObj[key];
      // if (value == null) {
      //   continue;
      // }
      log(CodeUtil.TAG, 'parseCode  for  index = ' + index);

      if (value instanceof Object == false || value instanceof Array) { //typeof value != 'object') {//APIJSON Array转为常规JSONArray
        response += callback.onParseChildOther(key, value, index);
      }
      else { // 其它Object，直接填充
        log(CodeUtil.TAG, 'parseCode  for typeof value === "object" >>  ' );

        if (JSONObject.isArrayKey(key)) { // APIJSON Array转为常规JSONArray
          log(CodeUtil.TAG, 'parseCode  for JSONObject.isArrayKey(key) >>  ' );

          response += callback.onParseChildArray(key, value, index);
        }
        else { // 常规JSONObject，往下一级提取
          log(CodeUtil.TAG, 'parseCode  for JSONObject.isArrayKey(key) == false >>  ' );

          response += callback.onParseChildObject(key, value, index);
        }
      }

      index ++;
    }

    response += callback.onParseParentEnd();

    log(CodeUtil.TAG, 'parseCode  return response = \n' + response + '\n\n\n');
    return response;
  },



  /**获取model类名
   * @param tableName
   * @return {*}
   */
  getModelName: function(tableName) {
    var model = StringUtil.noBlank(tableName);
    if (model == '') {
      return model;
    }
    var lastIndex = model.lastIndexOf('_');
    if (lastIndex >= 0) {
      model = model.substring(lastIndex + 1);
    }
    return StringUtil.firstCase(model, true);
  },
  /**获取model成员变量名
   * @param columnName
   * @return {*}
   */
  getFieldName: function(columnName) {
    return StringUtil.firstCase(StringUtil.noBlank(columnName), false);
  },
  /**获取model方法名
   * @param prefix @NotNull 前缀，一般是get,set等
   * @param field @NotNull
   * @return {*}
   */
  getMethodName: function(prefix, field) {
    if (field.startsWith('_')) {
      field = '_' + field; //get_name 会被fastjson解析为name而不是_name，所以要多加一个_
    }
    return prefix + StringUtil.firstCase(field, true);
  },

  /**获取注释
   * @param comment
   * @param multiple 多行
   * @param prefix 多行注释的前缀，一般是空格
   * @return {*}
   */
  getComment: function(comment, multiple, prefix) {
    comment = comment == null ? '' : comment.trim();
    if (prefix == null) {
      prefix = '';
    }
    if (multiple == false) {
      return prefix + '// ' + comment.replace(/\n/g, '  ');
    }


    //多行注释，需要每行加 * 和空格

    var newComment = prefix + '/**';
    var index;
    do {
      newComment += '\n';
      index = comment.indexOf('\n');
      if (index < 0) {
        newComment += prefix + ' * ' + comment;
        break;
      }
      newComment += prefix + ' * ' + comment.substring(0, index);
      comment = comment.substring(index + 2);
    }
    while(comment != '')

    return newComment + '\n' + prefix + ' */';
  },

  /**获取Java的值
   * @param value
   * @return {*}
   */
  getCode4Value: function (language, value, key, depth, isSmart, isArrayItem, callback) {
    language = language || '';
    if (value == null) {
      switch (language) {
        case CodeUtil.LANGUAGE_KOTLIN:
        case CodeUtil.LANGUAGE_JAVA:
        case CodeUtil.LANGUAGE_C_SHARP:
          break;

        case CodeUtil.LANGUAGE_SWIFT:
        case CodeUtil.LANGUAGE_OBJECTIVE_C:
          return 'nil';

        case CodeUtil.LANGUAGE_GO:
          return 'nil';
        case CodeUtil.LANGUAGE_C_PLUS_PLUS:
          return 'Value().Move()'; //报错：AddMemeber 不允许 NULL ！ 'NULL';

        case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        case CodeUtil.LANGUAGE_JAVA_SCRIPT:
          break;

        case CodeUtil.LANGUAGE_PHP:
          break;
        case CodeUtil.LANGUAGE_PYTHON:
          return 'None';
      }
      return 'null';
    }

    if (value === false) {
      switch (language) {
        case CodeUtil.LANGUAGE_KOTLIN:
        case CodeUtil.LANGUAGE_JAVA:
        case CodeUtil.LANGUAGE_C_SHARP:
          break;

        case CodeUtil.LANGUAGE_SWIFT:
        case CodeUtil.LANGUAGE_OBJECTIVE_C:
          break;

        case CodeUtil.LANGUAGE_GO:
        case CodeUtil.LANGUAGE_C_PLUS_PLUS:
          break;

        //以下都不需要解析，直接用左侧的 JSON
        case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        case CodeUtil.LANGUAGE_JAVA_SCRIPT:
          break;

        case CodeUtil.LANGUAGE_PHP:
          break;
        case CodeUtil.LANGUAGE_PYTHON:
          return 'False';
      }
      return 'false';
    }
    if (value === true) {
      switch (language) {
        case CodeUtil.LANGUAGE_KOTLIN:
        case CodeUtil.LANGUAGE_JAVA:
        case CodeUtil.LANGUAGE_C_SHARP:
          break;

        case CodeUtil.LANGUAGE_SWIFT:
        case CodeUtil.LANGUAGE_OBJECTIVE_C:
          break;

        case CodeUtil.LANGUAGE_GO:
        case CodeUtil.LANGUAGE_C_PLUS_PLUS:
          break;

        case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        case CodeUtil.LANGUAGE_JAVA_SCRIPT:
          break;

        case CodeUtil.LANGUAGE_PHP:
          break;
        case CodeUtil.LANGUAGE_PYTHON:
          return 'True';
      }
      return 'true';
    }

    if (typeof value == 'number') {
      log(CodeUtil.TAG, 'getCode4Value  value == null || typeof value == "boolean" || typeof value == "number"  >>  return value;');
      return value;
    }
    if (typeof value == 'string') {
      log(CodeUtil.TAG, 'getCode4Value  typeof value === "string"  >>  return " + value + ";' );
      if (isSmart && [CodeUtil.LANGUAGE_JAVA_SCRIPT, CodeUtil.LANGUAGE_TYPE_SCRIPT, CodeUtil.LANGUAGE_PHP, CodeUtil.LANGUAGE_PYTHON].indexOf(language) >= 0) {
        return (language == CodeUtil.LANGUAGE_PYTHON ? 'u' : '') + "'" + value + "'";
      }
      return (language == CodeUtil.LANGUAGE_PYTHON ? 'u' : '') + '"' + value + '"';
    }

    if (callback == null) {
      return value;
    }

    depth = (depth || 0)
    return '\n' + CodeUtil.getBlank(depth + 1) + callback(key, value, depth + 1, isSmart, isArrayItem);// + '\n' + CodeUtil.getBlank(depth);
  },

  getJavaTypeFromJS: function (key, value, isArrayItem, baseFirst, rawType, isSmart) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return baseFirst ? 'boolean' : 'Boolean';
    }
    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return baseFirst ? 'double' : 'Double';
      }
    }

    if (t == 'number' || t == 'integer') {
      if (Math.abs(value) >= 2147483647 || CodeUtil.isId(key, 'bigint', isArrayItem)) {
        return baseFirst ? 'long' : 'Long';
      }
      return baseFirst ? 'int' : 'Integer';
    }

    if (t == 'string') {
      return 'String';
    }
    if (t == 'array') {
      return rawType ? 'List<Object>' : (! isSmart ? 'JSONArray' : 'List<' + StringUtil.firstCase(JSONResponse.getTableName(key), true) + '>');
    }
    if (t == 'object') {
      return rawType ? 'Map<String, Object>' : (! isSmart ? 'JSONObject' : StringUtil.firstCase(JSONResponse.getTableName(key), true));
    }

    return 'Object';
  },

  getKotlinTypeFromJS: function (key, value, isArrayItem, baseFirst, rawType, isSmart) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return baseFirst ? 'boolean' : 'Boolean';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return baseFirst ? 'double' : 'Double';
      }
    }

    if (t == 'number' || t == 'integer') {
      if (Math.abs(value) >= 2147483647 || CodeUtil.isId(key, 'bigint', isArrayItem)) {
        return baseFirst ? 'long' : 'Long';
      }
      return baseFirst ? 'int' : 'Int';
    }

    if (t == 'string') {
      return 'String';
    }
    if (t == 'array') {
      return rawType ? 'List<Any>' : (! isSmart ? 'JSONArray' : 'List<' + StringUtil.firstCase(JSONResponse.getTableName(key), true) + '>');
    }
    if (t == 'object') {
      return rawType ? 'Map<String, Any>' : (! isSmart ? 'JSONObject' : StringUtil.firstCase(JSONResponse.getTableName(key), true));
    }

    return 'Any';
  },

  getCSharpTypeFromJS: function (key, value, baseFirst) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return baseFirst ? 'bool' : 'Boolean';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return baseFirst ? 'double' : 'Double';
      }
    }

    if (t == 'number' || t == 'integer') {
      if (Math.abs(value) >= 2147483647 || CodeUtil.isId(key, 'bigint', isArrayItem)) {
        return baseFirst ? 'long' : 'Int64';
      }
      return baseFirst ? 'int' : 'Int32';
    }

    if (t == 'string') {
      return 'String';
    }
    if (t == 'array') {
      return 'JArray';
    }
    if (t == 'object') {
      return 'JObject';
    }

    return baseFirst ? 'object' : 'Object';
  },

  getSwiftTypeFromJS: function (key, value) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return 'Bool';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return 'Double';
      }
    }

    if (t == 'number' || t == 'integer') {
      return 'Int';
    }

    if (t == 'string') {
      return 'String';
    }
    if (t == 'array') {
      return 'NSArray';
    }
    if (t == 'object') {
      return 'NSDictionary';
    }

    return 'NSObject';
  },


  getCppTypeFromJS: function (key, value, isArrayItem) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return 'bool';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return 'double';
      }
    }

    if (t == 'number' || t == 'integer') {
      if (Math.abs(value) >= 2147483647 || CodeUtil.isId(key, 'bigint', isArrayItem)) {
        return 'long'
      }
      return 'int';
    }

    if (t == 'string') {
      return 'const char*'; //CLion 报错 'rapidjson::Value::Ch*';
    }
    if (t == 'array') {
      return 'rapidjson::Value::Array';
    }
    if (t == 'object') {
      return 'rapidjson::Value::Object';
    }

    return 'rapidjson::Value&';
  },

  getCppGetterFromJS: function (key, value, isArrayItem) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return 'GetBool';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return 'GetDouble';
      }
    }

    if (t == 'number' || t == 'integer') {
      if (Math.abs(value) >= 2147483647 || CodeUtil.isId(key, 'bigint', isArrayItem)) {
        return 'GetInt64';
      }
      return 'GetInt';
    }

    if (t == 'string') {
      return 'GetString';
    }
    if (t == 'array') {
      return 'GetArray';
    }
    if (t == 'object') {
      return 'GetObject';
    }

    return 'Get';
  },

  getPythonTypeFromJS: function (key, value) {
    return CodeUtil.getPythonTypeFromJSType(key, value, null);
  },
  getPythonTypeFromJSType: function (key, value, type) {
    var t = value == null ? type : JSONResponse.getType(value);
    if (t == 'boolean') {
      return 'bool';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return 'float';
      }
    }

    if (t == 'number' || t == 'integer') {
      return 'int';
    }

    if (t == 'string') {
      return 'str';
    }
    if (t == 'array') {
      return 'list';
    }
    if (t == 'object') {
      return 'dict';
    }

    return 'any';
  },

  getGoTypeFromJS: function (key, value) {
    var t = JSONResponse.getType(value);
    if (t == 'boolean') {
      return 'bool';
    }

    if (t == 'number') {
      if (Number.isInteger(value) != true) {
        return 'double';
      }
    }

    if (t == 'number' || t == 'integer') {
      return 'int';
    }

    if (t == 'string') {
      return 'string';
    }
    if (t == 'array') {
      return '[]interface{}';
    }
    if (t == 'object') {
      return 'map[string]interface{}';
    }

    return 'interface{}';
  },

  getColumnType: function (column, database) {
    if (column == null) {
      return 'text';
    }

    log(CodeUtil.TAG, 'getColumnType  database = ' + database + '; column = ' + JSON.stringify(column, null, '  '));

    if (column.column_type == null) { // && database == 'POSTGRESQL') {
      var dt = column.data_type || '';
      log(CodeUtil.TAG, 'getColumnType  column.data_type = ' + column.data_type);

      var len;
      if (column.character_maximum_length != null) { // dt.indexOf('char') >= 0) {
        log(CodeUtil.TAG, 'getColumnType  column.character_maximum_length != null >>  column.character_maximum_length = ' + column.character_maximum_length);

        len = '(' + column.character_maximum_length + ')';
      }
      else if (column.numeric_precision != null) { // dt.indexOf('int') >= 0) {
        log(CodeUtil.TAG, 'getColumnType  column.numeric_precision != null >>  column.numeric_precision = ' + column.numeric_precision + '; column.numeric_scale = ' + column.numeric_scale);

        len = '(' + column.numeric_precision + (column.numeric_scale == null || column.numeric_scale <= 0 ? '' : ',' + column.numeric_scale) + ')';
      }
      else {
        len = ''
      }

      log(CodeUtil.TAG, 'getColumnType  return dt + len; = ' + (dt + len));
      return dt + len;
    }

    log(CodeUtil.TAG, 'getColumnType  return column.column_type; = ' + column.column_type);
    return column.column_type;
  },

  /**根据数据库类型获取Java类型
   * @param t
   * @param saveLength
   */
  getJavaType: function(type, saveLength) {
    return CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA, type, saveLength);
  },
  /**根据数据库类型获取Java类型
   * @param t
   * @param saveLength
   */
  getCppType: function(type, saveLength) {
    return CodeUtil.getType4Language(CodeUtil.LANGUAGE_C_PLUS_PLUS, type, saveLength);
  },
  getType4Language: function(language, type, saveLength) {
    log(CodeUtil.TAG, 'getJavaType  type = ' + type + '; saveLength = ' + saveLength);
    type = StringUtil.noBlank(type);

    var index = type.indexOf('(');

    var t = index < 0 ? type : type.substring(0, index);
    if (t == '' || t == 'object') {
      return CodeUtil.getType4Any(language, '');
    }
    var length = index < 0 || saveLength != true ? '' : type.substring(index);

    if (t.indexOf('char') >= 0 || t.indexOf('text') >= 0 || t == 'enum' || t == 'set') {
      return CodeUtil.getType4String(language, length);
    }
    if (t.indexOf('int') >= 0) {
      return t == 'bigint' ? CodeUtil.getType4Long(language, length) : CodeUtil.getType4Integer(language, length);
    }
    if (t.endsWith('binary') || t.indexOf('blob') >= 0 || t.indexOf('clob') >= 0) {
      return CodeUtil.getType4ByteArray(language, length);
    }
    if (t.indexOf('timestamp') >= 0) {
      return CodeUtil.getType4Timestamp(language, length);
    }

    switch (t) {
      case 'id':
        return CodeUtil.getType4Long(language, length);
      case 'bit':
      case 'bool': //同tinyint
      case 'boolean': //同tinyint
        return CodeUtil.getType4Boolean(language, length);
      case 'datetime':
        return CodeUtil.getType4Timestamp(language, length);
      case 'year':
        return CodeUtil.getType4Date(language, length);
      case 'decimal':
      case 'number':
      case 'numberic':
        return CodeUtil.getType4Decimal(language, length);
      case 'json':
      case 'jsonb':
      case 'array':
        return CodeUtil.getType4Array(language);
      case 'string':
        return CodeUtil.getType4String(language, length);
      default:
        return StringUtil.firstCase(t, true) + length;
    }

  },

  getType4Any: function (language, length) {
    length = length || '';
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
        return 'Any' + length;
      case CodeUtil.LANGUAGE_JAVA:
        return 'Object' + length;
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'object' + length;

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Any' + length;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSObject' + length;

      case CodeUtil.LANGUAGE_GO:
        return 'interface{}' + length;
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'GenericValue';

      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'object' + length;

      case CodeUtil.LANGUAGE_PHP:
      case CodeUtil.LANGUAGE_PYTHON:
        return 'any' + length;
    }
    return 'Object' + length;  //以 JSON 类型为准
  },
  getType4Boolean: function (language, length) {
    length = length || '';
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'Boolean' + length;

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Bool' + length;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'bool' + length;

      case CodeUtil.LANGUAGE_GO:
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'bool' + length;

      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'boolean' + length;

      case CodeUtil.LANGUAGE_PHP:
      case CodeUtil.LANGUAGE_PYTHON:
        return 'bool' + length;
    }
    return 'Boolean' + length;  //以 JSON 类型为准
  },
  getType4Integer: function (language, length) {
    length = length || '';
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
        return 'Int' + length;
      case CodeUtil.LANGUAGE_JAVA:
        break;
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'Int32' + length;

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Int' + length;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSInteger' + length;


      case CodeUtil.LANGUAGE_GO:
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'int' + length;

      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'number' + length;

      case CodeUtil.LANGUAGE_PHP:
      case CodeUtil.LANGUAGE_PYTHON:
        return 'int' + length;
    }
    return 'Integer' + length;  //以 JSON 类型为准
  },
  getType4Long: function (language, length) {
    length = length || ''
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
        return 'Int' + length;
      case CodeUtil.LANGUAGE_JAVA:
        return 'Long' + length;
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'Int64' + length;

      case CodeUtil.LANGUAGE_SWIFT:
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'Int' + length;

      case CodeUtil.LANGUAGE_GO:
        return 'int64' + length;
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'long' + length;

      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'number' + length;

      case CodeUtil.LANGUAGE_PHP:
      case CodeUtil.LANGUAGE_PYTHON:
        return 'int' + length;
    }
    return CodeUtil.getType4Integer(language, length);
  },

  getType4Decimal: function (language, length) {
    length = length || ''
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
        return 'BigDecimal' + length;
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'decimal' + length;

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Decimal' + length;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSDecimal' + length;

      case CodeUtil.LANGUAGE_GO:
        return 'float64' + length;
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'double' + length;

      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'number' + length;

      case CodeUtil.LANGUAGE_PHP:
      case CodeUtil.LANGUAGE_PYTHON:
        return 'float' + length;
    }
    return 'Number' + length;  //以 JSON 类型为准
  },
  getType4String: function (language, length) {
    length = length || ''
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
      case CodeUtil.LANGUAGE_C_SHARP:
        break;

      case CodeUtil.LANGUAGE_SWIFT:
        break;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSString' + length;

      case CodeUtil.LANGUAGE_GO:
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'string' + length;

      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'string' + length;

      case CodeUtil.LANGUAGE_PHP:
        return 'string' + length;
      case CodeUtil.LANGUAGE_PYTHON:
        return 'str' + length;
    }
    return 'String' + length;  //以 JSON 类型为准
  },
  getType4Date: function (language, length) {
    length = length || ''
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
        return 'Date' + length;
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'DateTime' + length;

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Date' + length;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSDate' + length;

      case CodeUtil.LANGUAGE_GO:
        return 'time.Time' + length;
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'tm' + length;

      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        return 'Date' + length;

      case CodeUtil.LANGUAGE_PHP:
        break;
      case CodeUtil.LANGUAGE_PYTHON:
        return 'datetime' + length;
    }
    return CodeUtil.getType4String(language, length);
  },
  getType4Timestamp: function (language, length) {
    length = length || ''
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
        return 'Timestamp' + length;
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'TimeSpan' + length;

      case CodeUtil.LANGUAGE_SWIFT:
        return 'TimeInterval' + length;
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        break;

      case CodeUtil.LANGUAGE_GO:
        return 'time.Time' + length;
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'time_t' + length;

      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'string';
      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        break;

      case CodeUtil.LANGUAGE_PHP:
        break;
      case CodeUtil.LANGUAGE_PYTHON:
        return 'datetime' + length;
    }
    return CodeUtil.getType4Integer(language, length);
  },
  getType4Object: function (language) {
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
        return 'JSONObject';
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'JObject';

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Dictionary';
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSDictionary';

      case CodeUtil.LANGUAGE_GO:
        return 'map[string]interface{}';
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'map<string, object>';

      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        return 'object';

      case CodeUtil.LANGUAGE_PHP:
        return 'object';
      case CodeUtil.LANGUAGE_PYTHON:
        return 'dict[str, any]';
    }
    return 'Object';  //以 JSON 类型为准
  },
  getType4ByteArray: function (language) {
    return 'byte[]';
  },
  getType4Array: function (language) {
    length = length || ''
    switch (language) {
      case CodeUtil.LANGUAGE_KOTLIN:
      case CodeUtil.LANGUAGE_JAVA:
      case CodeUtil.LANGUAGE_C_SHARP:
        return 'List<Object>';

      case CodeUtil.LANGUAGE_SWIFT:
        return 'Array';
      case CodeUtil.LANGUAGE_OBJECTIVE_C:
        return 'NSArray';

      case CodeUtil.LANGUAGE_GO:
        return '[]interface{}';
      case CodeUtil.LANGUAGE_C_PLUS_PLUS:
        return 'vector<object>';

      case CodeUtil.LANGUAGE_JAVA_SCRIPT:
        return 'object[]';
      case CodeUtil.LANGUAGE_TYPE_SCRIPT:
        return 'any[]';

      case CodeUtil.LANGUAGE_PHP:
        return 'any[]';
      case CodeUtil.LANGUAGE_PYTHON:
        return 'list[any]';
    }
    return 'Array';  //以 JSON 类型为准
  },


  /**获取字段对应值的最大长度
   * @param columnType
   * @return {string}
   */
  getMaxLength: function (columnType) {
    var index = columnType == null ? -1 : columnType.indexOf('(');
    return index < 0 ? '不限' : columnType.substring(index + 1, columnType.length - (columnType.endsWith(')') ? 1 : 0));
  },


  /**根据层级获取键值对前面的空格
   * @param depth
   * @return {string}
   */
  getBlank: function(depth, unit) {
    var s = '';
    var one = '    ';
    if (unit != null && unit > 0 && unit != 4) {
        one = ''
        for (var i = 0; i < unit; i ++) {
            one += ' ';
        }
    }
    for (var i = 0; i < depth; i ++) {
      s += one;
    }
    return s;
  },

  /**根据数组arr生成用 , 分割的字符串
   * 直接用 join 会导致里面的 String 没有被 "" 包裹
   * @param arr
   * @param path
   */
  getArrayString: function(arr, path) {
    if (arr == null || arr.length <= 0) {
      return arr;
    }

    var s = '';
    var v;
    var t;
    for (var i = 0; i < arr.length; i ++) {
      t = typeof arr[i];
      if (t == 'object' || t == 'array') {
        //TODO 不止为什么parseJavaResponse会调用这个函数，先放过  throw new Error('请求JSON中 ' + (path || '""') + ':[] 格式错误！key:[] 的[]中所有元素都不能为对象{}或数组[] ！');
      }
      v = (t == 'string' ? '"' + arr[i] + '"': arr[i]) //只支持基本类型
      s += (i > 0 ? ', ' : '') + v;
    }
    return s;
  },


  /**获取Table变量名
   * @param key
   * @return empty ? 'request' : key
   */
  getTableKey: function(key) {
    key = StringUtil.trim(key);
    return key == '' ? 'request' : StringUtil.firstCase(key, false);//StringUtil.addSuffix(key, 'Request');
  },
  /**获取数组内Object变量名
   * @param key
   * @return empty ? 'item' : key + 'Item' 且首字母小写
   */
  getItemKey: function(key) {
    return StringUtil.addSuffix(key.substring(0, key.length - 2), 'Item');
  },

  /**是否为id
   * @param column
   * @return {boolean}
   */
  isId: function (column, type, isArrayItem) {
    if (column == null || type == null || type.indexOf('int') < 0) {
      return false;
    }

    if (isArrayItem) {
      // if (column.endsWith('[]')) {
      //   column = column.substring(0, column.length - '[]'.length);
      // }
      //
      // if (column.endsWith('Item')) {
      //   column = column.substring(0, column.length - 'Item'.length);
      // }
      // else if (column.endsWith('Element')) {
      //   column = column.substring(0, column.length - 'Element'.length);
      // }
      //
      // if (column.endsWith('List')) {
      //   column = column.substring(0, column.length - 'List'.length);
      // }
      // else if (column.endsWith('Array')) {
      //   column = column.substring(0, column.length - 'Array'.length);
      // }
      // else if (column.endsWith('Vector')) {
      //   column = column.substring(0, column.length - 'Vector'.length);
      // }
      // else if (column.endsWith('Set')) {
      //   column = column.substring(0, column.length - 'Set'.length);
      // }
      // else if (column.endsWith('Collection')) {
      //   column = column.substring(0, column.length - 'Collection'.length);
      // }
      // else if (column.endsWith('Arr')) {
      //   column = column.substring(0, column.length - 'Arr'.length);
      // }
      // else if (column.endsWith('s')) {
      //   column = column.substring(0, column.length - 's'.length);
      // }

      while (true) {
        var index = column == null || column.length < 2 ? -1 : column.lastIndexOf('d');
        if (index <= 0) {
          break;
        }

        var prefix = column.substring(index <= 2 ? 0 : index - 2, index);

        if (prefix.endsWith('I') || (prefix.endsWith('i') && /[A-Za-z]/.test(prefix.length < 2 ? '' : prefix.substring(0, 1)) == false)) {

          var suffix = column.length <= index + 1 ? '' : column.substring(index + 1, index + 3);
          var after = suffix.length < 1 ? '' : suffix.substring(0, 1);

          // id%, %_id, %Id%, %ids%, %_ids%, %Ids%
          if (/[a-z]/.test(after) == false || (after == 's' && /[a-z]/.test(suffix.length < 2 ? '' : suffix.substring(1, 2)) == false)) {
            return true;
          }
        }

        column = index < 2 ? null : column.substring(0, index - 2);
      }

      return false;
    }

    if (column.endsWith('Id')) { // lowerCamelCase
      return true;
    }

    var index = column.lastIndexOf('_'); // snake_case
    var id = index < 0 ? column : column.substring(index + 1);
    return id.toLowerCase() == 'id';
  },



  QUERY_TYPES: ['数据', '数量', '全部'],
  JOIN_TYPES: {"@": 'APP', "<": 'LEFT', ">": 'RIGHT', "*": 'CROSS', "&": 'INNER', "|": 'FULL', "!": 'OUTER', "^": 'SIDE', "(": 'ANTI', ")": 'FOREIGN'},
  CACHE_TYPES: ['全部', '磁盘', '内存'],
  SUBQUERY_RANGES: ['ANY', 'ALL'],
  QUERY_TYPE_KEYS: [0, 1, 2],
  CACHE_TYPE_KEYS: [0, 1, 2],
  QUERY_TYPE_CONSTS: ["JSONRequest.QUERY_TABLE", "JSONRequest.QUERY_TOTAL", "JSONRequest.QUERY_ALL"],
  ROLE_KEYS: ['UNKNOWN', 'LOGIN', 'CONTACT', 'CIRCLE', 'OWNER', 'ADMIN'],
  ROLES: {
    UNKNOWN: '未登录',
    LOGIN: '已登录',
    CONTACT: '联系人',
    CIRCLE: '圈子成员',
    OWNER: '拥有者',
    ADMIN: '管理员'
  },
  DATABASE_KEYS: ['MYSQL', 'POSTGRESQL', 'SQLSERVER', 'ORACLE', 'DB2', 'DAMENG', 'KINGBASE', 'MARIADB', 'SQLITE', 'INFLUXDB', 'TDENGINE', 'PRESTO', 'TRINO', 'HIVE', 'TIDB', 'CLICKHOUSE', 'ELASTICSEARCH', 'REDIS', 'IOTDB', 'SURREALDB', 'DUCKDB', 'CASSANDRA', 'MONGODB', 'SNOWFLAKE', 'DATABRICKS', 'MILVUS'], // , 'KAFKA'],

  getComment4Function: function (funCallStr, method, language) {
    if (typeof funCallStr != 'string') {
      return '远程函数 value 必须是 String 类型！';
    }

    var start = funCallStr == null ? -1 : funCallStr.indexOf('(')
    if (start <= 0 || funCallStr.endsWith(')') != true) {
      throw new Error('远程函数调用格式非法！必须为 fun(arg0,arg1..) 这种形式！不允许多余的空格！')
    }

    var fun = funCallStr.substring(0, start)
    if (StringUtil.isName(fun) != true) {
      throw new Error('远程函数名称 ' + fun + ' 非法！必须为大小写英文字母开头且其它字符只能是字母/下划线/数字！')
    }

    var funObj = CodeUtil.getFunctionFromList(fun, method)
    if (funObj == null) {
      throw new Error('远程函数 ' + fun + ' 非法！只能传后端 Function 表中配置的！')
    }

    // 不做校验，似乎怎么写都是对的
    var argStr = funCallStr.substring(start + 1, funCallStr.length - 1)
    var args = StringUtil.isEmpty(argStr) ? null : StringUtil.split(argStr)
    var argLen = args == null ? 0 : args.length

    // if (args != null) {
    //   for (var i = 0; i < args.length; i++) {
    //     var a = args[i]
    //     if (a.startsWith("'") && a.endsWith("'")) {
    //       continue
    //     }
    //
    //     if (a.startsWith('`') && a.endsWith('`')) {
    //       a = a.substring(1, a.length - 1)
    //       if (StringUtil.isName(a) != true) {
    //         throw new Error('远程函数名称 ' + fun + ' 非法！必须为大小写英文字母开头且其它字符只能是字母/下划线/数字！')
    //       }
    //     }
    //   }
    // }

    var allowArgStr = funObj.arguments
    var allowArgs = StringUtil.isEmpty(allowArgStr) ? null : StringUtil.split(allowArgStr)
    var allowArgLen = allowArgs == null ? 0 : allowArgs.length
    if (argLen != allowArgLen) {
      throw new Error('远程函数参数数量 ' + argLen + ' 非法！必须是 ' + allowArgLen + ' 个！格式为 ' + fun + '(' + StringUtil.trim(allowArgStr) + ')')
    }

    return CodeUtil.getType4Language(language, funObj.returnType) + ', ' + (funObj.rawDetail || funObj.detail)
  },

  getFunctionFromList: function (name, method) {
    if (StringUtil.isEmpty(name)) {
      return null
    }

    var functionMap = CodeUtil.functionMap;
    var funObj = functionMap == null ? null : functionMap[name]
    if (funObj != null) {
      return funObj;
    }

    var functionList = CodeUtil.functionList;
    if (functionList != null) {
      for (var i = 0; i < functionList.length; i++) {
        var f = functionList[i];
        if (f != null && f.name == name) {
          if (functionMap == null) {
            functionMap = {};
          }
          functionMap[name] = f;
          CodeUtil.functionMap = functionMap;
          return f;
        }
      }
    }

    return null;
  },

  /**获取请求JSON的注释
   * @param tableList
   * @param name
   * @param key
   * @param value
   * @param isInSubquery
   * @param database
   */
  getComment4Request: function (tableList, name, key, value, method, isInSubquery, database, language, isReq, names, isRestful, standardObj, isWarning, isAPIJSONRouter) {
    // alert('name = ' + name + '; key = ' + key + '; value = ' + value + '; method = ' + method);

    if (key == null) {
      return '';
    }

    var typeOfValue = CodeUtil.getType4Request(value);
    var isValueNotString = typeOfValue != 'string';
    var isValueNotInteger = typeOfValue != 'integer';
    // var isValueNotNumber = isValueNotInteger && typeOfValue != 'number';
    var isValueNotBoolean = typeOfValue != 'boolean';
    var isValueNotEmpty = isValueNotString ? (typeOfValue != 'array' ? value != null : value.length > 0) : StringUtil.isNotEmpty(value, true);

    var extraComment = '';
    if (isAPIJSONRouter) {
      var ks = key.split('.')
      if (ks != null && ks.length >= 2) {
        name = ks[ks.length - 2];
        key = ks[ks.length - 1];
        names = ks.slice(0, ks.length - 1)

        var nk = name.endsWith('[]') ? name.substring(0, name.length - 2) : name;
        if (JSONObject.isTableKey(nk) != true) {
          nk = name;
        }

        extraComment = CodeUtil.getComment4Request(tableList, null, nk, { [key]:value }, method, isInSubquery, database, language, isReq, ks.slice(0, ks.length - 2), isRestful, standardObj, isWarning, false).trim();
        if (StringUtil.isNotEmpty(extraComment, true)) {
          extraComment = ' < ' + nk + ': ' + (extraComment.startsWith('//') ? extraComment.substring(2).trim() : extraComment);
        }
      }
    }

    if (isRestful == true || (standardObj != null && key.indexOf('@') < 0)) {
      if (StringUtil.isEmpty(key, true)) {
        return '';
      }

      var pathKeys = []; // slice 居然每次都返回数字 1  names == null || names.length < 2 ? null : names.slice(2).push(key)
      if (names != null && names.length > 1) {
        for (var i = 1; i < names.length; i++) {
          pathKeys.push(names[i]);
        }
      }

      // FIXME names 居然出现 ['', 'user', 'user']  if (value instanceof Object == false) {
        pathKeys.push(key);
      // }

      try {
        var c = CodeUtil.getCommentFromDoc(tableList, name, key, method, database, language, isReq != true || isRestful, isReq, pathKeys, isRestful, value == null ? {} : value, true, standardObj, null, isWarning);
        if (isRestful == true || StringUtil.isEmpty(c) == false) {  // TODO 最好都放行，查不到都去数据库查表和字段属性
          if (c.startsWith(' ! ')) {
            return c;
          }
          return StringUtil.isEmpty(c) ? ' ! 字段 ' + key + ' 不存在！' : (isWarning ? '' : CodeUtil.getComment(c, false, ' ')) + extraComment;
        }
      }
      catch (e) {
        if (isRestful == true) {
          return e.message;
        }
      }
    }


    if (isRestful != true || isReq != true) {  // 解决 APIJSON 批量 POST/PUT "Table[]": [{ key:value }] 中 {} 及 key:value 不显示注释
      if (StringUtil.isEmpty(key, true)) {
        // 这里处理将不显示表名，且空格少一个不能让注释和下方 key 对齐
        // if ((method == 'POST' || method == 'PUT') && names != null && names.length >= 1 && JSONObject.isArrayKey(name)) {
        //   var aliaIndex = name.indexOf(':');
        //   var objName = name.substring(0, aliaIndex >= 0 ? aliaIndex : name.length - 2);
        //
        //   if (JSONObject.isTableKey(objName)) {
        //     key = objName;
        //   }
        // }
      }
      else if (StringUtil.isEmpty(name, true) && (isReq != true || method == 'POST' || method == 'PUT')
        && names != null && names.length >= 2 && names[names.length - 1] == name) {

        var arrName = names[names.length - 2];

        if (JSONObject.isArrayKey(arrName)) {
          var aliaIndex = arrName.indexOf(':');
          var objName = arrName.substring(0, aliaIndex >= 0 ? aliaIndex : arrName.length - 2);

          if (JSONObject.isTableKey(objName)) {
            name = objName;
          }
        }
      }
    }

    if (isRestful != true && key != null && key.startsWith('@') != true && key.endsWith('()')) { // 方法，查询完后处理，先用一个Map<key,function>保存？
      if (['GET', 'HEAD'].indexOf(method) < 0) {
        return ' ! 远程函数只能用于 GET,HEAD 请求！！';
      }

      if (value != null && isValueNotString) {
        return ' ! 远程函数 value 必须是 String 类型！';
      }

      // if (value != null) {
      //   var startIndex = value.indexOf("(");
      //   if (startIndex <= 0 || value.endsWith(")") == false) {
      //     return ' ! 远程函数 value 必须符合 fun(arg0,arg1..) 这种格式！且不要有任何多余的空格！';
      //   }
      //   var fun = value.substring(0, startIndex);
      //   if (StringUtil.isName(fun) != true) {
      //     return '! 函数名' + fun + '不合法！value 必须符合 fun(arg0,arg1..) 这种格式！且不要有任何多余的空格！';
      //   }
      // }

      var c = ''
      if (StringUtil.isNotEmpty(value)) { // isValueNotEmpty 居然不对
        try {
          c = CodeUtil.getComment4Function(value, method, language)
        } catch (e) {
          return ' ! ' + e.message
        }
      }

      if (isWarning) {
        return ' ';
      }

      var priority = '';
      if (key.endsWith("-()")) {
        priority = ' < 在解析所在对象前优先执行';
      }
      else if (key.endsWith("+()")) {
        priority = ' < 在解析所在对象后滞后执行';
      }
      else {
        priority = ' < 执行时机在解析所在对象后，解析子对象前，可以在 () 前用 + - 设置优先级，例如 key-() 优先执行';
      }

      return CodeUtil.getComment('远程函数' + (isValueNotEmpty ? (StringUtil.isEmpty(c, true) ? '' : '：' + c) + priority
        : '，例如 "isContain(praiseUserIdList,userId)"'), false, ' ');
    }


    // if (value == null) {
    //  return ' ! key:value 中 key 或 value 任何一个为 null 时，该 key:value 都无效！'
    // }
    if (value instanceof Array) {
      if ((isReq != true || method == 'POST' || method == 'PUT') && JSONObject.isArrayKey(key)) {
        var aliaIndex = key.indexOf(':');
        var objName = key.substring(0, aliaIndex >= 0 ? aliaIndex : key.length - 2);

        if (JSONObject.isTableKey(objName)) {
          var c = CodeUtil.getCommentFromDoc(tableList, objName, null, method, database, language, isReq != true || isRestful, isReq, pathKeys, isRestful, value, null, null, null, isWarning);
          if (c != null && c.startsWith(' ! ')) {
            return c;
          }
          return StringUtil.isEmpty(c) ? ' ! 表 ' + objName + ' 不存在！' : (isWarning ? '' : CodeUtil.getComment(
            (aliaIndex < 0 ? '' : '新建别名: ' + key.substring(aliaIndex + 1, key.length - 2) + ' < ') + objName + ': ' + c, false, ' ')) + extraComment;
        }
      }

      if (isReq == true && isRestful != true && method != 'POST' && method != 'PUT') {
        return StringUtil.isEmpty(extraComment, true) ? '' : CodeUtil.getComment(extraComment.substring(3), false, ' ');
      }
    }
    else if (value instanceof Object) {
      if ((isReq != true || isRestful != true) && StringUtil.isEmpty(key, true)) {
        if (names == null || names.length <= 0) {
          return isReq != true || isWarning ? '' : '  ' + CodeUtil.getComment('根对象，可在内部加 Table:{}'
            + (method == null || method == 'GET' || method == 'GETS' ? ', []:{}' : (method == 'POST' || method == 'PUT' ? ', []:[{}]' : ''))
            + ' 等或 format,tag,version,@role,@database,@schema,@datasource,@explain,@cache 等全局关键词键值对', false, ' ');
        }

        // 解决 APIJSON 批量 POST/PUT "Table[]": [{ key:value }] 中 {} 不显示注释
        if ((isReq != true || method == 'POST' || method == 'PUT') && JSONObject.isArrayKey(name)) {
          var aliaIndex = name.indexOf(':');
          var objName = name.substring(0, aliaIndex >= 0 ? aliaIndex : name.length - 2);

          if (JSONObject.isTableKey(objName)) {
            var c = CodeUtil.getCommentFromDoc(tableList, objName, null, method, database, language, isReq != true || isRestful, isReq, pathKeys, isRestful, value, null, null, null, isWarning);
            if (c.startsWith(' ! ')) {
              return c;
            }
            return StringUtil.isEmpty(c) ? ' ! 表 ' + objName + ' 不存在！' : (isWarning ? '' : ' ' + CodeUtil.getComment(objName + ': ' + c, false, ' ')) + extraComment;
          }
        }
      }

      if (isRestful != true && key.endsWith('@')) {
        if (isWarning) {
          return '';
        }

        if (key == '@from@') {
          return CodeUtil.getComment('数据来源：子查询' + (isValueNotEmpty ? '，里面必须有 "from":Table, Table:{}' : '，例如 { "from":"User", "User":{} }'), false, ' ') + extraComment;
        }

        var aliaIndex = name == null ? -1 : name.indexOf(':');
        var objName = aliaIndex < 0 ? name : name.substring(0, aliaIndex);
        if (JSONObject.isTableKey(objName)) {
          return CodeUtil.getComment('子查询，里面必须有 "from":Table, Table:{} < ' + CodeUtil.getCommentFromDoc(tableList, objName, key.substring(0, key.length - 1),
                method, database, language, isReq != true || isRestful, isReq, pathKeys, isRestful, value, null, null, true, isWarning), false, ' ') + extraComment;
        }
        return CodeUtil.getComment('子查询，可在内部加 Table:{} 或 from,range 或 数组关键词 等键值对，需要被下面的表字段相关 key 引用赋值', false, ' ') + extraComment;
      }

      if (isRestful != true && JSONObject.isArrayKey(key)) {
        if (method != 'GET' && method != 'GETS') {
          return ' ! key[]:{} 只支持 GET,GETS 方法！';
        }

        if (isWarning) {
          return '';
        }

        key = key.substring(0, key.lastIndexOf('[]'));

        var aliaIndex = key.indexOf(':');
        var objName = aliaIndex < 0 ? key : key.substring(0, aliaIndex);
        var alias = aliaIndex < 0 ? '' : key.substring(aliaIndex + 1, key.length);

        var firstIndex = objName.indexOf('-');
        var firstKey = firstIndex < 0 ? objName : objName.substring(0, firstIndex);
        alias = alias.length <= 0 ? '' : '新建别名: ' + alias + ' < ';
        return CodeUtil.getComment((JSONObject.isTableKey(firstKey) ? '提取' + objName + ' < ' : '') + alias
          + '数组，可在内部加 Table:{}, []:{} 等或 count,page,query,compat,join 等关键词键值对', false, ' ') + extraComment;
      }

      var aliaIndex = key.indexOf(':');
      var objName = aliaIndex < 0 ? key : key.substring(0, aliaIndex);

      var isTableKey = JSONObject.isTableKey(objName)
      if (isRestful == true || isTableKey) {
        var c = CodeUtil.getCommentFromDoc(tableList, objName, null, method, database, language
          , isReq != true || isRestful, isReq, pathKeys, isRestful, value, null, null, null, isWarning);
        if (c.startsWith(' ! ')) {
          return c;
        }
        return StringUtil.isEmpty(c) ? ' ! 表不存在！' : (isWarning ? '' : CodeUtil.getComment(
          (aliaIndex < 0 ? '' : '新建别名: ' + key.substring(aliaIndex + 1, key.length) + ' < ' + objName + ': ') + c, false, ' ')) + extraComment;
      }

      if (isWarning != true && isRestful != true && isTableKey != true && StringUtil.isEmpty(objName) != true) {
        return CodeUtil.getComment('普通对象。如果要对应数据库表请把 ' + objName + ' 改成 ' + StringUtil.firstCase(objName, true)
          + ' 这种以大写字母开头的 APIJSON 表名！数据库表不一样要这样，MySQL 默认大小写不敏感。', false, ' ') + extraComment;
      }

      return StringUtil.isEmpty(extraComment, true) ? '' : CodeUtil.getComment(extraComment.substring(3), false, ' ');
    }

    if (isRestful != true && (isInSubquery || JSONObject.isArrayKey(name))) {
      switch (key) {
        case 'count':
          return value != null && isValueNotInteger ? ' ! value必须是Integer类型！' : (isWarning ? '' : CodeUtil.getComment('每页数量' + (isValueNotEmpty ? '' : '，例如 5 10 20 等'), false, ' ')) + extraComment;
        case 'page':
          if (value != null && isValueNotInteger) {
            return ' ! value必须是Integer类型！';
          }
          return value != null && value < 0 ? ' ! 必须 >= 0 ！' : (isWarning ? '' : CodeUtil.getComment('分页页码' + (isValueNotEmpty ? '' : ': 例如 0 1 2 ...'), false, ' ')) + extraComment;
        case 'query':
          var query = CodeUtil.QUERY_TYPES[value];
          return StringUtil.isEmpty(query) ? ' ! value必须是[' + CodeUtil.QUERY_TYPE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment('查询内容：0-对象 1-总数和分页详情 2-数据、总数和分页详情', false, ' ')) + extraComment;
        case 'join':
          if (isValueNotString) {
            return ' ! value必须是String类型！';
          }

          var s = '';
          var must = '';
          var items = value.length < 1 ? null : StringUtil.split(value);
          if (items != null && items.length > 0) {

            var chars = Object.keys(CodeUtil.JOIN_TYPES);

            for (var i = 0; i < items.length; i++) {
              var item = items[i] || '';

              if (item.endsWith('@') != true) {
                return ' ! ' + item + ' 不合法 ! 必须以 @ 结尾' + (isValueNotEmpty ? '' : '，例如 "&/User/id@" ！');
              }

              var index = item.indexOf('/');
              var lastIndex = item.lastIndexOf('/');

              if (index < 0 || lastIndex <= index + 1) {
                return ' ! ' + item + ' 不合法 ! 必须有两个不相邻的 /' + (isValueNotEmpty ? '' : '，例如 "&/User/id@" ！');
              }

              var c = index <= 0 ? '|' : item.substring(0, index);
              if (chars.indexOf(c) < 0) {
                return ' ! JOIN 类型 ' + c + ' 不合法 ! 必须是 [' + chars.join(', ') + '] 中的一种！';
              }

              var t = item.substring(index + 1, lastIndex);
              var ind = t.indexOf(':')
              var a = ind < 0 ? '' : t.substring(ind + 1)
              t = ind < 0 ? t : t.substring(0, ind)

              if (JSONObject.isTableKey(t) != true) {
                return ' ! 表名 ' + t + ' 不合法 ! 必须是 Table 这种大驼峰格式' + (isValueNotEmpty ? '' : '，例如 "User" "Comment" "ViewTable" 等 ！');
              }

              if (isWarning != true) {
                s += CodeUtil.JOIN_TYPES[c] + ' JOIN ' + t + (a.length <= 0 ? '' : ' AS ' + a);
                must += (i > 0 ? ', ' : '，同一层级必须有 "') + t + '":{ "' + item.substring(lastIndex + 1) + '":"/../.." }';
              }
            }
          }

          return isWarning ? '' : CodeUtil.getComment('多表连接：' + (s + must || '例如 &/User/id@,</Comment/momentId@,... ' +
            '对应关系为 @ APP, < LEFT, > RIGHT, * CROSS, & INNER, | FULL, ! OUTER, ^ SIDE, ( ANTI, ) FOREIGN'), false, ' ') + extraComment;
        default:
          if (isInSubquery) {
            switch (key) {
              case 'range':
                if (isValueNotString) {
                  return ' ! value必须是String类型！';
                }
                return CodeUtil.SUBQUERY_RANGES.indexOf(value) < 0 ? ' ! value必须是[' + CodeUtil.SUBQUERY_RANGES.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment('比较范围：ANY-任意 ALL-全部', false, ' ')) + extraComment;
              case 'from':
                return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment('数据来源' + (isValueNotEmpty ? '，同一层级必须有 "' + value + '":{...}' : '，例如 "User"，同一层级必须有 "User":{...}'), false, ' ')) + extraComment;
            }
          }
          break;
      }

      return StringUtil.isEmpty(extraComment, true) ? '' : CodeUtil.getComment(extraComment.substring(3), false, ' ');
    }

    var aliaIndex = name == null ? -1 : name.indexOf(':');
    var objName = aliaIndex < 0 ? name : name.substring(0, aliaIndex);

    if (isRestful != true && JSONObject.isTableKey(objName)) {
      switch (key) {
        case '@column':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '返回字段' + (isValueNotEmpty ? '，可传 字段(:别名)、SQL 函数(:别名，用分号 ; 隔开)、表达式，以及部分 SQL 关键词'
              : '：例如 "name" "toId:parentId" "id,userId;json_length(praiseUserIdList):praiseCount" 等'), false, ' ')) + extraComment;
        case '@from@': //value 类型为 Object 时 到不了这里，已在上方处理
          return isValueNotString && typeOfValue != 'object' ? ' ! value必须是String或Object类型！' : (isWarning ? '' : CodeUtil.getComment(
            '数据来源：引用赋值 子查询 "' + value + '@":{...} ', false, ' ')) + extraComment;
        case '@group':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '分组方式' + (isValueNotEmpty ? '' : '，例如 "userId" "momentId,toId" 等'), false, ' ')) + extraComment;
        case '@having':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '聚合函数' + (isValueNotEmpty ? '，可传 SQL 函数(用分号 ; 隔开)、表达式，以及部分 SQL 关键词'
              : '，例如 "max(id)>100" "length(phone)>0;sum(balance)<=10000" 等'), false, ' ')) + extraComment;
        case '@order':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '排序方式：+升序，-降序' + (isValueNotEmpty ? '' : '，例如 "date-" "name+,id-" 等'), false, ' ')) + extraComment;
        case '@combine':  //TODO 解析 value 并直接给出条件组合结果
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '条件组合' + (isValueNotEmpty ? '，| 可省略。合并同类，外层按照 & | ! 顺序，内层按传参顺序组合成 (key0 & key1 & key6 & 其它key) & (key2 | key3 | key7) & !(key4 | key5)'
              : '，例如 "name$,tag$" "!userId<,!toId" 等'), false, ' ')) + extraComment;
        case '@raw':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '原始SQL片段' + (isValueNotEmpty ? '，由后端 RAW_MAP 代码配置指定 "key0,key1.." 中每个 key 对应 key:"SQL片段" 中的 SQL片段'
              : '，例如 "@column" "id{},@having" 等'), false, ' ')) + extraComment;
        case '@json':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '转为JSON' + (isValueNotEmpty ? '' : '，例如 "request" "gets,heads" 等'), false, ' ')) + extraComment;
        case '@null':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            'NULL值字段' + (isValueNotEmpty ? '' : '，例如 "tag" "content,praiseUserIdList" 等'), false, ' ')) + extraComment;
        case '@cast':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '类型转换' + (isValueNotEmpty ? '' : '，例如 "date:DATETIME" "date>:DATETIME,id{}:JSON" 等'), false, ' ')) + extraComment;
        case '@schema':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '集合空间(数据库名/模式)' + (isValueNotEmpty ? '' : '，例如 "sys" "apijson" "postgres" "dbo" 等'), false, ' ')) + extraComment;
        case '@database':
          return CodeUtil.DATABASE_KEYS.indexOf(value) < 0 ? ' ! value必须是[' + CodeUtil.DATABASE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment(
            '数据库类型：例如 "MYSQL" "POSTGRESQL" "SQLSERVER" "ORACLE" "DB2" "CLICKHOUSE" 等', false, ' ')) + extraComment;
        case '@datasource':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '跨数据源' + (isValueNotEmpty ? '' : '，例如 "DRUID" "HIKARICP" 等'), false, ' ')) + extraComment;
        case '@role':
          var role = CodeUtil.ROLES[value];
          return StringUtil.isEmpty(role) ? ' ! value必须是[' + CodeUtil.ROLE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment(
            '来访角色：' + role + '，限制可操作的数据，假定真实强制匹配', false, ' ')) + extraComment;
        case '@cache':
          var cache = CodeUtil.CACHE_TYPES[value];
          return StringUtil.isEmpty(cache) ? ' ! value必须是[' + CodeUtil.CACHE_TYPE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment(
            '缓存方式：0-全部 1-磁盘 2-内存', false, ' ')) + extraComment;
        case '@explain':
          return isValueNotBoolean ? ' ! value必须是Boolean类型！' : (isWarning ? '' : CodeUtil.getComment(
            '性能分析：true-开启 false-关闭，返回执行的 SQL 及查询计划', false, ' ')) + extraComment;
      }
      if (key.startsWith('@')) {
        if (key.endsWith('()')) {
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '存储过程' + (isValueNotEmpty ? '，触发调用数据库存储过程' : '：例如 "getCommentByUserId(id,@limit,@offset)"'), false, ' ')) + extraComment;
        }
        return StringUtil.isEmpty(extraComment, true) ? '' : CodeUtil.getComment(extraComment.substring(3), false, ' ');
      }
      var c = CodeUtil.getCommentFromDoc(tableList, objName, key, method, database, language
        , isReq != true || isRestful, isReq, pathKeys, isRestful, value, null, null, null, isWarning);
      if (c.startsWith(' ! ')) {
        return c;
      }
      return StringUtil.isEmpty(c) ? ' ! 字段不存在！' : (isWarning ? '' : CodeUtil.getComment(c, false, ' ')) + extraComment;
    }

    // alert('name = ' + name + '; key = ' + key);
    if (isRestful != true && StringUtil.isEmpty(name)) {
      switch (key) {
        case 'tag':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '请求标识' + (method == 'GET' || method == 'HEAD' ? '，GET,HEAD 请求不会自动解析，仅为后续迭代可能的手动优化而预留'
              : (isValueNotEmpty ? '，用来区分不同请求并校验，由后端 Request 表中指定' : '，例如 "User" "Comment[]" "Privacy-CIRCLE" 等')), false, ' '));
        case 'version':
          return isValueNotInteger ? ' ! value必须是Integer类型！' : (isWarning ? '' : CodeUtil.getComment(
            '版本号' + (method == 'GET' || method == 'HEAD' ? '，GET,HEAD 请求不会自动解析，仅为后续迭代可能的手动优化而预留'
              : (isValueNotEmpty ? '，用来使用特定版本的校验规则，由后端 Request 表中指定' : '，例如 1 2 3 等')), false, ' '));
        case 'format':
          return isValueNotBoolean ? ' ! value必须是Boolean类型！' : (isWarning ? '' : CodeUtil.getComment(
            '格式化: true-是 false-否，将 TableName 转为 tableName, TableName[] 转为 tableNameList, Table:alias 转为 alias 等小驼峰格式', false, ' '));
        case '@schema':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '集合空间(数据库名/模式)' + (isValueNotEmpty ? '' : '，例如 "sys" "apijson" "postgres" "dbo" 等'), false, ' '));
        case '@datasource':
          return isValueNotString ? ' ! value必须是String类型！' : (isWarning ? '' : CodeUtil.getComment(
            '跨数据源' + (isValueNotEmpty ? '' : '，例如 "DRUID" "HIKARICP" 等'), false, ' '));
        case '@database':
          return CodeUtil.DATABASE_KEYS.indexOf(value) < 0 ? ' ! value必须是[' + CodeUtil.DATABASE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment(
            '数据库' + (isValueNotEmpty ? '' : '，例如 "MYSQL" "POSTGRESQL" "SQLSERVER" "ORACLE" 等'), false, ' '));
        case '@role':
          var role = CodeUtil.ROLES[value];
          return StringUtil.isEmpty(role) ? ' ! value必须是[' + CodeUtil.ROLE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment(
            '默认角色：' + role, false, ' '));
        case '@cache':
          var cache = CodeUtil.CACHE_TYPES[value];
          return StringUtil.isEmpty(cache) ? ' ! value必须是[' + CodeUtil.CACHE_TYPE_KEYS.join() + ']中的一种！' : (isWarning ? '' : CodeUtil.getComment(
            '缓存方式：0-全部 1-磁盘 2-内存', false, ' '));
        case '@explain':
          return isValueNotBoolean ? ' ! value必须是Boolean类型！' : (isWarning ? '' : CodeUtil.getComment(
            '性能分析：true-开启 false-关闭，返回执行的 SQL 及查询计划', false, ' '));
      }
    }

    return StringUtil.isEmpty(extraComment, true) ? '' : CodeUtil.getComment(extraComment.substring(3), false, ' ');
  },

  /**
   * @param tableList
   * @param tableName
   * @param columnName
   * @param method
   * @param database
   * @param language
   * @param onlyTableAndColumn
   * @return {*}
   */
  getCommentFromDoc: function (tableList, tableName, columnName, method, database, language, onlyTableAndColumn
    , isReq, pathKeys, isRestful, value, ignoreError, standardObj, isSubquery, isWarning) {
    log('getCommentFromDoc  tableName = ' + tableName + '; columnName = ' + columnName
      + '; method = ' + method + '; database = ' + database + '; language = ' + language
      + '; onlyTableAndColumn = ' + onlyTableAndColumn + '; tableList = \n' + JSON.stringify(tableList));

    var typeOfValue = CodeUtil.getType4Request(value);
    var isValueNotArray = typeOfValue != 'array';
    var isValueNotObject = typeOfValue != 'object';

    if (standardObj != null) {
      var parentObj = pathKeys == null || pathKeys.length <= 0 ? null : JSONResponse.getStandardByPath(standardObj, pathKeys.slice(0, pathKeys.length - 1));
      var targetValues = parentObj == null ? null : parentObj.values;
      var targetObj = targetValues == null ? null : (targetValues[0] || {})[pathKeys[pathKeys.length - 1]]; // JSONResponse.getStandardByPath(standardObj, pathKeys);

      var t = targetObj == null ? null : targetObj.type;
      var targetComment = targetObj == null ? null : targetObj.comment;
      var c = StringUtil.isEmpty(targetComment, true) ? null : CodeUtil.getType4Language(language, t, true)
       + (targetObj.notEmpty ? '! ' : (targetObj.notNull ? ', ' : '? ')) + StringUtil.trim(targetComment);
      if (CodeUtil.isTypeMatch(t, CodeUtil.getType4Request(value)) != true) {
        c = ' ! value必须是' + CodeUtil.getType4Language(language, t) + '类型！' + (isWarning ? ' ' : CodeUtil.getComment(c, false, ' '));
        if (ignoreError != true) {
          throw new Error(c);
        }

        if (isWarning) {
          return c;
        }
      }

      if (StringUtil.isNotEmpty(targetComment, true)) {  // 如果这里没注释就从数据库/第三方平台取
        return c;
      }

      var parentName = parentObj == null || StringUtil.isEmpty(parentObj.name, true) ? null : parentObj.name;
      var name = targetObj == null || StringUtil.isEmpty(targetObj.name, true) ? null : targetObj.name;
      if (StringUtil.isNotEmpty(parentName, true) || StringUtil.isNotEmpty(name, true)) {
        var pn = parentName || tableName;
        var n = name || columnName;
        var isValObj = isValueNotObject != true; // && StringUtil.isName(pn)

        c = CodeUtil.getCommentFromDoc(tableList, isValObj ? n : pn, isValObj ? null : n
          , method, database, language, onlyTableAndColumn, isReq, pathKeys, value, ignoreError, null, isSubquery, isWarning);
        if (StringUtil.isNotEmpty(c, true)) {
          return (isValObj && StringUtil.isNotEmpty(name, true) ? StringUtil.trim(name) : CodeUtil.getType4Language(language, t, true))
            + (targetObj.notEmpty ? '! ' : (targetObj.notNull ? ', ' : '? ')) + StringUtil.trim(c);
        }
      }
    }

    var isValueNotString = typeOfValue != 'string';
    var isValueNotInteger = typeOfValue != 'integer';
    var isValueNotNumber = isValueNotInteger && typeOfValue != 'number';
    var isValueNotStringOrObject = isValueNotString && isValueNotObject;
    var isValueNotStringOrArray = isValueNotString && isValueNotArray;
    var isValueNotStringOrNumber = isValueNotString && isValueNotNumber;
    var isValueNotStringOrNumberOrObject = isValueNotStringOrNumber && isValueNotObject;
    var isValueNotStringOrArrayOrObject = isValueNotString && isValueNotArray && isValueNotObject;
    var isValueNotEmpty = isValueNotString ? (typeOfValue != 'array' ? value != null : value.length > 0) : StringUtil.isEmpty(value, true) != true;

    if (isRestful == true && StringUtil.isEmpty(columnName, true) == false && StringUtil.isEmpty(CodeUtil.thirdParty, true) == false) { // } && CodeUtil.thirdParty == 'YAPI') {
      var apiMap = CodeUtil.thirdPartyApiMap;
      if (apiMap == null) {
        // 用 下方 tableList 兜底  return isWarning ? ' ' : '...';
      }
      else {
        var api = apiMap[(method.startsWith('/') ? '' : '/') + method];
        var doc = api == null ? null : (isReq ? (api.request || api.parameters) : api.response);
        if (doc != null) {
          var parentDoc = api;

          if (pathKeys != null && pathKeys.length > 0) {
            for (var i = 0; i < pathKeys.length; i++) {
              var p = pathKeys[i];

              if (doc instanceof Array) {
                var find = false;
                for (var j = 0; j < doc.length; j++) {
                  var d = doc[j];
                  if (d != null && d.name == p) {
                    // parentDoc = doc;
                    doc = d;
                    find = true;
                    break;
                  }
                }

                if (find == false) {
                  doc = null;
                }
              }
              else if (doc instanceof Object) {
                if ((doc.type == 'object' || doc.type == null) && JSONResponse.getType(doc) == 'object') {
                  parentDoc = doc;
                  doc = doc.properties || parentDoc.parameters;
                }
                else if (doc.type == 'array') {
                  parentDoc = doc;
                  doc = doc.items;

                  try {
                    if (p != null && p != '' && Number.isNaN(+p)) {
                      i--;
                    }
                  } catch (e) {
                  }

                  continue;
                }

                if (doc.type != 'object') {
                  parentDoc = doc;
                }

                if (doc instanceof Array) {
                }
                else if (properties instanceof Object) {
                  doc = doc[p];
                }
              }
            }
          }
          else if (doc instanceof Array) {
            doc = null;
          }

          if (doc == null && parentDoc != null) {
            var properties = parentDoc.properties || parentDoc.parameters;
            var required = parentDoc.required;

            var cols = '';
            if (properties instanceof Array) {
              var first = true;
              for (var i = 0; i < properties.length; i ++) {

                var para = properties[i];
                var pn = para == null ? null : para.name;

                if (StringUtil.isEmpty(pn, true) == false) {
                  cols += (first ? '' : ',') + pn;
                  first = false;
                }
              }
            }
            else if (properties instanceof Object) {
              cols = Object.keys(properties).join();
            }

            var musts = required == null ? '' : required.join();

            return ' ! 字段 ' + columnName + ' 不存在！只能是 [' + cols + '] 中的一个！' + (StringUtil.isEmpty(musts, true) ? '' : '其中 [' + musts + '] 必传！');
          }

          var t = doc == null ? null : doc.type;
          var c = doc == null ? null : CodeUtil.getType4Language(language, t, true) + (doc.required ? ', ' : '? ') + StringUtil.trim(doc.description || doc.title);
          if (t == null) {
            // 避免崩溃
          }
          else if (t.endsWith('[]')) {
            t = 'array';
          }
          else if (t == 'integer') {
            t = 'number';
          }

          if (CodeUtil.isTypeMatch(t, CodeUtil.getType4Request(value)) != true) {
            c = ' ! value必须是' + CodeUtil.getType4Language(language, t) + '类型！' + (isWarning ? ' ' : CodeUtil.getComment(c, false, ' '))
            if (ignoreError != true) {
              throw new Error(c);
            }
            return c;
          }
          else {
            if (c != null) {  // 可能存在但只是没注释  StringUtil.isEmpty(c, true) == false) {
              return isWarning ? ' ' : c;
            }
          }

        }

      }

    }

    // if (isRestful != true && onlyTableAndColumn != true && columnName != null && columnName.endsWith('()')) { // 方法，查询完后处理，先用一个Map<key,function>保存？
    //   if (['GET', 'HEAD'].indexOf(method) < 0) {
    //     return ' ! 远程函数只能用于 GET,HEAD 请求！！';
    //   }
    //
    //   if (value != null && isValueNotString) {
    //     return ' ! value必须是String类型！';
    //   }
    //   if (value != null) {
    //     var startIndex = value.indexOf("(");
    //     if (startIndex <= 0 || value.endsWith(")") == false) {
    //       return ' ! value必须符合 fun(arg0,arg1..) 这种格式！且不要有任何多余的空格！';
    //     }
    //     var fun = value.substring(0, startIndex);
    //     if (StringUtil.isName(fun) != true) {
    //       return '! 函数名' + fun + '不合法！value必须符合 fun(arg0,arg1..) 这种格式！且不要有任何多余的空格！';
    //     }
    //   }
    //
    //   if (isWarning) {
    //     return ' ';
    //   }
    //
    //   var priority = '';
    //   if (columnName.endsWith("-()")) {
    //     priority = ' < 在解析所在对象前优先执行';
    //   }
    //   else if (columnName.endsWith("+()")) {
    //     priority = ' < 在解析所在对象后滞后执行';
    //   }
    //   else {
    //     priority = '，执行时机在解析所在对象后，解析子对象前，可以在 () 前用 + - 设置优先级，例如 key-() 优先执行';
    //   }
    //
    //   return '远程函数' + (isValueNotEmpty ? '，触发调用后端对应的方法/函数' + priority : '，例如 "isContain(praiseUserIdList,userId)"');
    // }

    if (tableList == null || tableList.length <= 0) {
      return isWarning ? ' ' : '...';
    }

    if (StringUtil.isEmpty(tableName, true)) {
      return ' ';
    }

    var isTSQL = ['ORACLE', 'DAMENG'].indexOf(database) >= 0;

    var item;

    var table;
    var columnList;
    var column;
    for (var i = 0; i < tableList.length; i++) {
      item = tableList[i];

      //Table
      table = item == null ? null : (isTSQL ? item.AllTable : (database != 'SQLSERVER' ? item.Table : item.SysTable));
      var table_name = table == null ? null : table.table_name;
      if (table_name == null || table_name.replaceAll('_', '').toLowerCase().endsWith(tableName.replaceAll('_', '').toLowerCase()) != true) { // tableName != CodeUtil.getModelName(table.table_name)) {
        continue;
      }
      log('getDoc [] for i=' + i + ': table = \n' + format(JSON.stringify(table)));

      if (StringUtil.isEmpty(columnName)) {
        return /*没必要，常识，太占地方，而且自动生成代码就有  CodeUtil.getType4Object(language) + ', ' + */ (
          isTSQL ? (item.AllTableComment || {}).table_comment : (database == 'POSTGRESQL'
            ? (item.PgClass || {}).table_comment
            : (database == 'SQLSERVER'
              ? (item.ExtendedProperty || {}).table_comment
              : table.table_comment
          ))
        );
      }

      var at = '';
      var fun = '';
      var key;
      var logic = '';

      var verifyType = isSubquery != true && value != null;

      if (onlyTableAndColumn) {
        key = StringUtil.get(columnName);
      }
      else {
        //功能符 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        if (columnName.endsWith("()")) {//方法，查询完后处理，先用一个Map<key,function>保存？
          if (['GET', 'HEAD'].indexOf(method) < 0) {
            return ' ! 远程函数只能用于 GET,HEAD 请求！！';
          }

          if (value != null && isValueNotString) {
            return ' ! value必须是String类型！';
          }
          if (value != null) {
            var startIndex = value.indexOf("(");
            if (startIndex <= 0 || value.endsWith(")") == false) {
              return ' ! value必须符合 fun(arg0,arg1..) 这种格式！且不要有任何多余的空格！';
            }
            var fun = value.substring(0, startIndex);
            if (StringUtil.isName(fun) != true) {
              return '! 函数名' + fun + '不合法！value必须符合 fun(arg0,arg1..) 这种格式！且不要有任何多余的空格！';
            }
          }

          if (isWarning) {
            return ' ';
          }

          var priority = '';
          if (columnName.endsWith("-()")) {
            priority = ' < 在解析所在对象前优先执行';
          }
          else if (columnName.endsWith("+()")) {
            priority = ' < 在解析所在对象后滞后执行';
          }
          else {
            priority = '，执行时机在解析所在对象后，解析子对象前，可以在 () 前用 + - 设置优先级，例如 key-() 优先执行';
          }

          return '远程函数' + (isValueNotEmpty ? '，触发调用后端对应的方法/函数' + priority : '，例如 "isContain(praiseUserIdList,userId)"');
        }

        var hasAt = false;
        if (columnName.endsWith("@")) {//引用，引用对象查询完后处理。fillTarget中暂时不用处理，因为非GET请求都是由给定的id确定，不需要引用
          // 没传 value 进来，不好解析，而且太长导致后面的字段属性被遮住
          // var lastIndex = value.lastIndexOf('/');
          // var refLastPath =
          // at = '引用赋值: ' + tableName + '.' + columnName + '=' + ;
          hasAt = true;

          at = '引用赋值' + (isValueNotEmpty ? (value.startsWith('/') ? '，从对象父级开始的相对(缺省)路径' : '，从最外层开始的绝对(完整)路径') : '，例如 "User/id" "[]/Moment/id" 等');
          columnName = columnName.substring(0, columnName.length - 1);

          if (value != null && isValueNotStringOrObject) {
            return ' ! value必须是String或Object类型！';
          }

          verifyType = false;
        }

        if (columnName.endsWith("$")) {//搜索，查询时处理
          if (verifyType && hasAt != true && isValueNotStringOrArray) {
              return ' ! value必须是String或Array类型！';
            }

          fun = '模糊搜索' + (isValueNotEmpty ? '' : '，例如 "%c%" "S%" "%end" 等');
          key = columnName.substring(0, columnName.length - 1);
        }
        else if (columnName.endsWith("~")) {//匹配正则表达式，查询时处理
          if (verifyType && hasAt != true && isValueNotStringOrArray) {
            return ' ! value必须是String或Array类型！';
          }

          fun = '正则匹配' + (isValueNotEmpty ? '' : '，例如 "C" "^[0-9]+$" "^[a-zA-Z]+$" 等');
          key = columnName.substring(0, columnName.length - 1);
          if (key.endsWith("*")) {
            key = key.substring(0, key.length - 1);
            fun += '(忽略大小写)';
          }
        }
        else if (columnName.endsWith("%")) {//连续范围 BETWEEN AND，查询时处理
          if (verifyType && hasAt != true && isValueNotStringOrArray) {
            return ' ! value必须是String或Array类型！';
          }

          fun = '连续范围' + (isValueNotEmpty ? '' : '，例如 "82001,82020" "2018-01-01,2020-01-01" ["1-10", "90-100"] 等');
          key = columnName.substring(0, columnName.length - 1);
        }
        else if (columnName.endsWith("{}")) {//被包含，或者说key对应值处于value的范围内。查询时处理
          if (verifyType && hasAt != true && isValueNotStringOrArray) {
            return ' ! value必须是String或Array类型！';
          }

          fun = (isValueNotString ? '匹配选项' : '匹配条件') + (isValueNotEmpty ? '' : '，例如 ' + (isValueNotString ? '[1, 2, 3] ["%c%", "S%", "%end"] 等' : '">100" "%2=0;<=100000" 等'));
          key = columnName.substring(0, columnName.length - 2);

          verifyType = false;
        }
        else if (columnName.endsWith("<>")) {//包含，或者说value处于key对应值的范围内。查询时处理
          fun = '包含选项' + (isValueNotEmpty ? '' : '，例如 1 "Test" [82001, 82002] 等');
          key = columnName.substring(0, columnName.length - 2);

          verifyType = false;
        }
        else if (columnName.endsWith("}{")) {//存在，EXISTS。查询时处理
          if (verifyType && hasAt != true && isSubquery != true) {
            return ' ! key}{ 后面必须接 @，写成 key}{@:{} 格式！';
          }
          if (verifyType && isValueNotObject) {
            return ' ! value必须是Object类型！';
          }

          fun = '是否存在' + (isValueNotEmpty ? '' : '，例如 { "from":"Comment", "Comment":{ "@column":"userId" } }');
          key = columnName.substring(0, columnName.length - 2);

          verifyType = false;
        }
        else if (columnName.endsWith("+")) {//延长，PUT查询时处理
          if (method != 'PUT') {//不为PUT就抛异常
            return ' ! 功能符 + - 只能用于PUT请求！';
          }
          fun = '增加/扩展' + (isValueNotEmpty ? '' : '，例如 1 9.9 "a" [82001, 82002] 等');
          key = columnName.substring(0, columnName.length - 1);
        }
        else if (columnName.endsWith("-")) {//缩减，PUT查询时处理
          if (method != 'PUT') {//不为PUT就抛异常
            return ' ! 功能符 + - 只能用于PUT请求！';
          }
          fun = '减少/去除' + (isValueNotEmpty ? '' : '，例如 1 9.9 "a" [82001, 82002] 等');
          key = columnName.substring(0, columnName.length - 1);
        }
        else if (columnName.endsWith(">=")) {//大于或等于
          if (verifyType && hasAt != true && isValueNotStringOrNumber) {
            return ' ! value必须是String或Number类型！';
          }

          fun = '大于或等于' + (isValueNotEmpty ? '' : '，例如 1 9.9 "2020-01-01" 等');
          key = columnName.substring(0, columnName.length - 2);
        }
        else if (columnName.endsWith("<=")) {//小于或等于
          if (verifyType && hasAt != true && isValueNotStringOrNumber) {
            return ' ! value必须是String或Number类型！';
          }

          fun = '小于或等于' + (isValueNotEmpty ? '' : '，例如 1 9.9 "2020-01-01" 等');
          key = columnName.substring(0, columnName.length - 2);
        }
        else if (columnName.endsWith(">")) {//大于
          if (verifyType && hasAt != true && isValueNotStringOrNumber) {
            return ' ! value必须是String或Number类型！';
          }

          fun = '大于' + (isValueNotEmpty ? '' : '，例如 1 9.9 "2020-01-01" 等');
          key = columnName.substring(0, columnName.length - 1);
        }
        else if (columnName.endsWith("<")) {//小于
          if (verifyType && hasAt != true && isValueNotStringOrNumber) {
            return ' ! value必须是String或Number类型！';
          }

          fun = '小于' + (isValueNotEmpty ? '' : '，例如 1 9.9 "2020-01-01" 等');
          key = columnName.substring(0, columnName.length - 1);
        }
        else {
          fun = '';
          key = StringUtil.get(columnName);
        }


        if (key.endsWith("&")) {
          if (fun.length <= 0) {
            return ' ! 逻辑运算符 & | 后面必须接其它功能符！';
          }
          logic = '符合全部';
        }
        else if (key.endsWith("|")) {
          if (fun.length <= 0) {
            return ' ! 逻辑运算符 & | 后面必须接其它功能符！';
          }
          logic = '符合任意';
        }
        else if (key.endsWith("!")) {
          logic = '都不符合';
        }
        else {
          logic = '';
        }

        if (logic.length > 0) {
          if (['GET', 'HEAD', 'GETS', 'HEADS', 'PUT', 'DELETE'].indexOf(method) < 0) {//逻辑运算符仅供GET,HEAD方法使用
            return ' ! 逻辑运算符 & | ! 只能用于 GET,HEAD,GETS,HEADS,PUT,DELETE 请求！';
          }
          key = key.substring(0, key.length - 1);
        }

        if (StringUtil.isName(key) == false) {
          return ' ! 字符 ' + key + ' 不合法！';
        }

        //功能符 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      }

      columnList = item['[]'];
      if (columnList == null) {
        continue;
      }
      log('getDoc [] for ' + i + ': columnList = \n' + format(JSON.stringify(columnList)));

      var name;
      var columnNames = []
      for (var j = 0; j < columnList.length; j++) {
        column = (columnList[j] || {})[isTSQL ? 'AllColumn' : 'Column'];
        name = column == null ? null : column.column_name;
        if (name == null || key != name) {
          if (name != null) {
            columnNames.push(name)
          }
          continue;
        }

        var p = (at.length <= 0 ? '' : at + ' < ')
          + (fun.length <= 0 ? '' : fun + ' < ')
          + (logic.length <= 0 ? '' : logic + ' < ');

        var o = isTSQL ? (columnList[j] || {}).AllColumnComment : (database == 'POSTGRESQL'
          ? (columnList[j] || {}).PgAttribute
          : (database == 'SQLSERVER'
              ? (columnList[j] || {}).ExtendedProperty
              : column
          ));

        column.column_type = CodeUtil.getColumnType(column, database);
        var t = CodeUtil.getType4Language(language, column.column_type, true);
        var c = (p.length <= 0 ? '' : p + key + ': ') + t + (column.is_nullable == 'YES' ? '? ' : ', ') + (o || {}).column_comment;

        var ct = CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT, column.column_type, false);
        if (verifyType && t != null && CodeUtil.isTypeMatch(ct, CodeUtil.getType4Language(CodeUtil.LANGUAGE_JAVA_SCRIPT, typeOfValue)) != true) {
          // c = ' ! value必须是' + t + '类型！' + CodeUtil.getComment(c, false, ' ')
          // if (ignoreError != true) {
          //   throw new Error(c);
          // }
          return ' ! value必须是' + t + '类型！' + (isWarning ? ' ' : CodeUtil.getComment(c, false, ' '));
        }

        return isWarning ? ' ' : c;
      }

      return onlyTableAndColumn ? '' : ' ! 字段 ' + key + ' 不存在！只能是 [' + columnNames.join() + '] 中的一个！';
    }

    return '';
  },

  getType4Request: function (value) {
    // return t != 'string' ? t : typeof parseJSON(value);
    if (value instanceof Array) {
      return 'array'
    }
    if (Number.isInteger(value)) {
      return 'integer';
    }
    return typeof value;
  },

  isTypeMatch: function(targetType, realType) {
    if (targetType == null || targetType == realType) {
      return true;
    }
    return (targetType == 'number' && realType == 'integer') || (targetType == 'string' && ['date', 'time', 'datetime'].indexOf(realType) >= 0);
  }

};

if (typeof module == 'object') {
  module.exports = CodeUtil;
}
