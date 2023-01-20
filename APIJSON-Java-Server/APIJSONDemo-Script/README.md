1、目前支持脚步引擎 <br/>
 jdk默认实现 Nashorn 引擎<br/>
Nashorn(--global-per-engine)<br/>
graalvm<br/>
lua<br/>
其他脚步引擎,业务侧可以扩展<br/>
2、扩展脚步引擎,支持更多脚步执行器<br/>
![image](https://user-images.githubusercontent.com/12228225/212584805-12f7c2d0-4b67-4c9e-b4c7-4259e2c7cb04.png)
![image](https://user-images.githubusercontent.com/12228225/212584868-3893f192-8f7c-4612-ac72-d022ff0550ed.png)
3、脚本 线程安全问题<br/>
业务侧按照需求,进行锁颗粒度控制<br/>
目前测试, lua Bindings无法保证线程安全 需要通过外部锁,比如 lock、synchronized、redis 分布式锁，防止并发问题<br/>
建议锁颗粒度: 脚本名.<br/>
举例:<br/>
脚本: length, testArray_lua<br/>
锁: length<br/>
锁: testArray_lua<br/>
ConcurrentHashMap 写key实现原理差不多<br/>
![image](https://user-images.githubusercontent.com/12228225/212581538-a68d677b-bb3f-487b-8e4a-b7415e03666a.png)

![image](https://user-images.githubusercontent.com/12228225/212581560-5304baf4-fd80-4809-80cc-168767199986.png)
4、支持传递 apijson元数据 参数:<br/>
version、tag、args<br/>
5、支持业务侧扩展参数<br/>
extParam<br/>
![image](https://user-images.githubusercontent.com/12228225/212581889-edbe0d99-1a0e-401f-ba14-73d81e244382.png)
![image](https://user-images.githubusercontent.com/12228225/212582389-f5de9267-893e-4db1-beae-39f5a3cbdcc7.png)
6、脚本编写规范<br/>
案例一:<br/>

```
function getType() {
	var curObj = _meta.args[0];
	var val = _meta.args[1];
	var index = _meta.args[2];
	return curObj[val] instanceof Array ? 'array' : typeof curObj[val];
}
getType()

```
案例二:<br/>

```
function getType(curObj, val, index) {
	return curObj[val] instanceof Array ? 'array' : typeof curObj[val];
}
getType(_meta.args[0], _meta.args[1], _meta.args[2])

```
7、支持二次处理脚步<br/>
格式化等<br/>
![image](https://user-images.githubusercontent.com/12228225/212583376-52081fee-7c1a-40c2-8a40-3ec04cb6c5f9.png)
8、数据库测试脚本<br/>

```
DROP TABLE IF EXISTS `function`;
CREATE TABLE `function` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `debug` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `userId` varchar(36) NOT NULL COMMENT '管理员用户Id',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '''0'' COMMENT ''类型：0-远程函数；1- SQL 函数''',
  `name` varchar(50) NOT NULL COMMENT '方法名',
  `returnType` varchar(50) NOT NULL DEFAULT 'Object' COMMENT '返回值类型。TODO RemoteFunction 校验 type 和 back',
  `arguments` varchar(100) DEFAULT NULL COMMENT '参数列表，每个参数的类型都是 String。\n用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。',
  `demo` json NOT NULL COMMENT '可用的示例。\nTODO 改成 call，和返回值示例 back 对应。',
  `detail` varchar(1000) NOT NULL COMMENT '详细描述',
  `version` tinyint(4) NOT NULL DEFAULT '0' COMMENT '允许的最低版本号，只限于GET,HEAD外的操作方法。\nTODO 使用 requestIdList 替代 version,tag,methods',
  `tag` varchar(20) DEFAULT NULL COMMENT '允许的标签.\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `methods` varchar(50) DEFAULT NULL COMMENT '允许的操作方法。\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `appId` varchar(36) DEFAULT NULL COMMENT '应用编号',
  `return` varchar(45) DEFAULT NULL COMMENT '返回值示例',
  `language` varchar(255) DEFAULT NULL COMMENT '语言：Java(java), JavaScript(js), Lua(lua), Python(py), Ruby(ruby), PHP(php) 等，NULL 默认为 Java，JDK 1.6-11 默认支持 JavaScript，JDK 12+ 需要额外依赖 Nashron/Rhiro 等 js 引擎库，其它的语言需要依赖对应的引擎库，并在 ScriptEngineManager 中注册',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name_UNIQUE` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='远程函数。强制在启动时校验所有demo是否能正常运行通过';

-- ----------------------------
-- Records of function
-- ----------------------------
BEGIN;
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (18, 0, '0', 1, 'getType', 'String', 'var,index', '{\"var\": [1, 2, 3], \"index\": 0}', '系统', 0, NULL, NULL, '2022-12-13 14:17:43', NULL, NULL, 'js');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (28, 0, '0', 0, 'testArray', 'Object', 'var,index', '{\"var\": [1, 2, 3], \"index\": 0}', '测试', 0, NULL, NULL, '2022-12-20 18:42:39', NULL, NULL, 'js');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (31, 0, '0', 0, 'isContainJs', 'Object', 'var,valKey', '{\"var\": \"a, b,c\", \"valKey\": \"1\"}', '测试', 0, NULL, NULL, '2023-01-12 14:29:11', NULL, NULL, 'nashornJS');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (32, 0, '0', 0, 'length', 'Object', 'var', '{\"var\": [1, 2, 3]}', '测试', 0, NULL, NULL, '2023-01-12 17:28:47', NULL, NULL, 'js');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (33, 0, '0', 0, 'lengthExtendParameter', 'Object', 'var', '{\"var\": [1, 2, 3]}', '测试', 0, NULL, NULL, '2023-01-12 18:18:31', NULL, NULL, 'nashornJS');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (34, 0, '0', 0, 'length_lua', 'Object', 'var', '{\"var\": [1, 2, 3]}', '测试', 0, NULL, NULL, '2023-01-13 15:59:47', NULL, NULL, 'luaj');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (35, 0, '0', 0, 'testArray_lua', 'Object', 'var,index', '{\"var\": [1, 2, 3], \"index\": 0}', '测试', 0, NULL, NULL, '2023-01-13 16:02:00', NULL, NULL, 'luaj');
INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (36, 0, '0', 0, 'length_graalJS', 'Object', 'var', '{\"var\": [1, 2, 3]}', '测试', 0, NULL, NULL, '2023-01-13 18:03:25', NULL, NULL, 'graalJS');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

```
```
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for script
-- ----------------------------
DROP TABLE IF EXISTS `script`;
CREATE TABLE `script` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `documentId` bigint(20) NOT NULL,
  `randomId` bigint(20) NOT NULL,
  `simple` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为可直接执行的简单代码段：0-否 1-是',
  `name` varchar(100) NOT NULL,
  `script` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ahead` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为前置脚本',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='脚本，前置预处理脚本、后置断言和恢复脚本等';

-- ----------------------------
-- Records of script
-- ----------------------------
BEGIN;
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (1, 0, 0, 0, 'getType', 'function getType() {\n	var curObj = _meta.args[0];\n	var val = _meta.args[1];\n	var index = _meta.args[2];\n	return curObj[val] instanceof Array ? \'array\' : typeof curObj[val];\n}\ngetType()', '2022-11-16 16:01:23', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (2, 0, 0, 0, 'isContainJs', 'function isContainJs() {\n	var curObj = _meta.args[0];\n	var key = _meta.args[1];\n	var valKey = _meta.args[2];\n    var arr = curObj == null ? null : curObj[key];\n    var val = curObj == null ? null : curObj[valKey];\n    return arr != null && arr.indexOf(val) >=0;\n}\nisContainJs()\n', '2022-11-16 16:02:48', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (3, 0, 0, 1, 'init', 'var i = 1;\n\"init done \"  + i;', '2022-11-16 16:41:35', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (4, 0, 0, 0, 'length', 'function length() {\n	var curObj = _meta.args[0];\n	var key = _meta.args[1];\n    var val = curObj == null ? null : curObj[key];\n    return val == null ? 0 : val.length;\n}\nlength()', '2022-11-16 17:18:43', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (5, 0, 0, 0, 'testArray', 'function testArray() {\n	var curObj = _meta.args[0];\n	var key = _meta.args[1];\n	var index = _meta.args[2];\n    var val = curObj == null ? null : curObj[key][curObj[index]];\n    return val;\n}\ntestArray()', '2022-12-20 18:44:09', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (6, 0, 0, 0, 'lengthExtendParameter', 'function lengthExtendParameter() {\n	var data = extParam.data;\n	print(\'data:\'+data);\n	var curObj = _meta.args[0];\n	var key = _meta.args[1];\n    var val = curObj == null ? null : curObj[key];\n    return val == null ? 0 : val.length;\n}\nlengthExtendParameter()', '2023-01-12 18:23:45', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (7, 0, 0, 0, 'length_lua', 'function length_lua()\n	local extParam = extParam:getUsername()\n	local version = _meta:get(\'version\')\n	local args = _meta:get(\'args\')\n	local curObj = args[1];\n	local key = args[2]\n	print(\'curObj:get(key):\'..tostring(curObj:get(key)))\n	print(\'ret type:\'..type(curObj:get(key)))\n	print(\'ret:\'..tostring(curObj:get(key):size()))\n	return curObj:get(key):size()\nend\nreturn length_lua()', '2023-01-13 16:00:34', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (8, 0, 0, 0, 'testArray_lua', 'function testArray_lua()\n	local args = _meta:get(\'args\')\n	local curObj = args[1];\n	print(\'curObj:\'..tostring(curObj)) \n	local key = args[2];\n	local index = args[3];\n	local valIndex = curObj:get(index)\n	print(\'valIndex:\'..tostring(valIndex)) \n	print(\'ret:\'..tostring(curObj:get(key)))\n	return curObj:get(key):get(valIndex)\nend\nreturn testArray_lua()', '2023-01-13 16:01:35', 0);
INSERT INTO `script` (`id`, `documentId`, `randomId`, `simple`, `name`, `script`, `date`, `ahead`) VALUES (9, 0, 0, 0, 'length_graalJS', 'function length() {\n	var curObj = _meta.args[0];\n	var key = _meta.args[1];\n    var val = curObj == null ? null : curObj[key];\n    return val == null ? 0 : val.length;\n}\nlength()', '2023-01-13 18:04:25', 0);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

```
9、apijson 测试json<br/>
```
#js
{
    "func": {
    	"var": [1,2,3],
    	"index": 0,
        "id()": "getType(var,index)"
    }
}

{
    "func": {
    	"var": "a,b,c",
    	"valKey": "a1",
        "id()": "isContainJs(var,valKey)"
    }
}

{
    "func": {
    	"var": [1,2,3],
        "length()": "length(var)"
    }
}

{
    "func": {
    	"var": [1,2,3],
        "index": 1,
        "testArray()": "testArray(var,index)"
    }
}
#lua
{
    "func": {
    	"var": [1,2,3,'dd'],
        "length_lua()": "length_lua(var)"
    }
}

{
    "func": {
    	"var": [1,2,3],
        "index": 2,
        "testArray_lua()": "testArray_lua(var,index)"
    }
}

# graalJS
{
    "func": {
    	"var": [1,2,3],
        "length_graalJS()": "length_graalJS(var)"
    }
}
```
