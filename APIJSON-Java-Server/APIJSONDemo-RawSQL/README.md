## 使用
[apijson 支持sql语句模版, 传递参数, 执行sql语句](https://github.com/Tencent/APIJSON/issues/510#issuecomment-1445774929)

## 数据库配置
```sql

INSERT INTO `Document` (`id`, `debug`, `userId`, `testAccountId`, `version`, `name`, `type`, `url`, `request`, `apijson`, `sqlauto`, `standard`, `header`, `date`, `detail`) VALUES (5, 0, 1, 0, 0, '执行sql语句', 'JSON', '/router/get/RawUserList', '{}', '{\n	\"@datasource\": \"master\",\n	\"paramName\": [\"name\",\"state\",\"page\",\"count\"],\n	\"tag\": \"RawUserList\",\n	\"rawData()\": \"rawSQL(paramName)\",\n	\"removeKeys+()\": \"removeKeys(paramName)\"\n}', 'SELECT * FROM `user` where `username` LIKE concat(?,\'%\') and state = ? and deleted != 1 limit ?,?', NULL, NULL, '2023-02-27 10:30:56', NULL);


INSERT INTO `request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`) 
VALUES (302, 0, 1, 'GET', 'RawUserList', '{}', 'router raw sql 测试', '2023-02-27 10:34:21');


INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) 
VALUES (37, 0, '0', 0, 'rawSQL', 'Object', 'paramName', '{\"paramName\": [\"paramName\"]}', '远程函数执行sql语句', 0, NULL, NULL, '2023-02-24 16:55:38', NULL, NULL, NULL);


INSERT INTO `function` (`id`, `debug`, `userId`, `type`, `name`, `returnType`, `arguments`, `demo`, `detail`, `version`, `tag`, `methods`, `date`, `appId`, `return`, `language`) VALUES (17, 0, '0', 0, 'removeKeys', 'void', 'keys', '{\"keys\": \"tag,aa\"}', '(低代码平台需要) 控制response返回字段', 0, NULL, NULL, '2022-12-02 11:46:23', NULL, NULL, NULL);


```
