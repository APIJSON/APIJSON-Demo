DROP TABLE IF EXISTS `Function`;

CREATE TABLE `Function` (
  `id` bigint,
  `debug` tinyint,
  `userId` bigint,
  `language` varchar(45),
  `name` varchar(50),
  `returnType` varchar(50),
  `arguments` varchar(100),
  `demo` json,
  `detail` varchar(1000),
  `version` tinyint,
  `tag` varchar(20),
  `methods` varchar(50),
  `date` datetime,
  `return` varchar(45)
);

LOCK TABLES `Function` WRITE;
INSERT INTO `Function` VALUES (3,0,0,NULL,'countArray','int','array','{\"array\": [1, 2, 3]}','获取数组长度。没写调用键值对，会自动补全 \"result()\": \"countArray(array)\"',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(4,0,0,NULL,'countObject','int','object','{\"object\": {\"key0\": 1, \"key1\": 2}}','获取对象长度。',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(5,0,0,NULL,'isContain','boolean','array,value','{\"array\": [1, 2, 3], \"value\": 2}','判断是否数组包含值。',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(6,0,0,NULL,'isContainKey','boolean','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','判断是否对象包含键。',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(7,0,0,NULL,'isContainValue','boolean','object,value','{\"value\": 1, \"object\": {\"id\": 1}}','判断是否对象包含值。',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(8,0,0,NULL,'getFromArray','Object','array,position','{\"array\": [1, 2, 3], \"result()\": \"getFromArray(array,1)\"}','根据下标获取数组里的值。position 传数字时直接作为值，而不是从所在对象 request 中取值',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(9,0,0,NULL,'getFromObject','Object','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','根据键获取对象里的值。',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(10,0,0,NULL,'deleteCommentOfMoment','int','momentId','{\"momentId\": 1}','根据动态 id 删除它的所有评论',0,'Moment','DELETE','2019-08-17 18:46:56',NULL),(11,0,0,NULL,'verifyIdList',NULL,'array','{\"array\": [1, 2, 3], \"result()\": \"verifyIdList(array)\"}','校验类型为 id 列表',0,NULL,NULL,'2019-08-17 19:58:33',NULL),(12,0,0,NULL,'verifyURLList',NULL,'array','{\"array\": [\"http://123.com/1.jpg\", \"http://123.com/a.png\", \"http://www.abc.com/test.gif\"], \"result()\": \"verifyURLList(array)\"}','校验类型为 URL 列表',0,NULL,NULL,'2019-08-17 19:58:33',NULL),(13,0,0,NULL,'getWithDefault','Object','value,defaultValue','{\"value\": null, \"defaultValue\": 1}','如果 value 为 null，则返回 defaultValue',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(14,0,0,NULL,'removeKey','Object','key','{\"key\": \"s\", \"key2\": 2}','从对象里移除 key',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(15,0,0,NULL,'getFunctionDemo','JSONObject',NULL,'{}','获取远程函数的 Demo',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(16,0,0,NULL,'getFunctionDetail','String',NULL,'{}','获取远程函数的详情',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(17,0,0,NULL,'getMethodArguments','String','methodArgs','{\"methodArgs\": \"methodArgs\"}','获取远程函数的参数',0,NULL,NULL,'2021-07-29 09:32:22',NULL),(18,0,0,NULL,'getMethodDefinition','String','method,arguments,type,exceptions,language','{\"method\": \"method\"}','获取远程函数的签名定义',0,NULL,NULL,'2021-07-29 09:34:37',NULL),(19,0,0,NULL,'getMethodRequest','String',NULL,'{}','获取远程函数的请求',0,NULL,NULL,'2021-07-29 09:35:37',NULL),(20,0,0,NULL,'deleteChildComment','int','commentId','{}','删除评论的子评论',0,NULL,NULL,'2021-09-10 06:53:24',NULL),(21,0,0,NULL,'getCurrentUserId','Long',NULL,'{}','获取当前登录用户 id',0,NULL,NULL,'2022-02-19 17:27:41',NULL),(22,0,0,NULL,'getCurrentUserIdAsList','List',NULL,'{}','获取当前登录用户 id 列表，只包含一个 id，只是为了前端方便构造某些请求',0,NULL,NULL,'2022-02-19 17:27:41',NULL),(24,0,0,NULL,'getCurrentUser','Visitor',NULL,'{}','获取当前登录用户公开信息',0,NULL,NULL,'2022-02-19 17:34:58',NULL),(26,0,0,NULL,'getCurrentContactIdList','List',NULL,'{}','获取当前登录用户的联系人 id 列表',0,NULL,NULL,'2022-02-19 17:37:35',NULL);
UNLOCK TABLES;