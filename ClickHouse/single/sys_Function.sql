
--
-- Table structure for table `Function`
--

DROP TABLE IF EXISTS `Function`;
CREATE TABLE `Function` (
  `id` UInt64,
  `userId` UInt64 COMMENT '管理员用户Id',
  `name` String  COMMENT '方法名',
  `arguments`  Nullable(String) COMMENT '参数列表，每个参数的类型都是 String。\n用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。',
  `demo` String COMMENT '可用的示例。\nTODO 改成 call，和返回值示例 back 对应。',
  `detail` String  COMMENT '详细描述',
  `type` String DEFAULT 'Object' COMMENT '返回值类型。TODO RemoteFunction 校验 type 和 back',
  `version` UInt64  DEFAULT '0' COMMENT '允许的最低版本号，只限于GET,HEAD外的操作方法。\nTODO 使用 requestIdList 替代 version,tag,methods',
  `tag` Nullable(String) COMMENT '允许的标签.\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `methods` Nullable(String) COMMENT '允许的操作方法。\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `date` DateTime DEFAULT now() COMMENT '创建时间',
  `back` Nullable(String) COMMENT '返回值示例'
) ENGINE = MergeTree PRIMARY KEY id COMMENT '远程函数。强制在启动时校验所有demo是否能正常运行通过';


--
-- Dumping data for table `Function`
--

INSERT INTO `Function` VALUES (3,0,'countArray','array','{\"array\": [1, 2, 3]}','获取数组长度。没写调用键值对，会自动补全 \"result()\": \"countArray(array)\"','Object',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(4,0,'countObject','object','{\"object\": {\"key0\": 1, \"key1\": 2}}','获取对象长度。','Object',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(5,0,'isContain','array,value','{\"array\": [1, 2, 3], \"value\": 2}','判断是否数组包含值。','Object',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(6,0,'isContainKey','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','判断是否对象包含键。','Object',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(7,0,'isContainValue','object,value','{\"value\": 1, \"object\": {\"id\": 1}}','判断是否对象包含值。','Object',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(8,0,'getFromArray','array,position','{\"array\": [1, 2, 3], \"result()\": \"getFromArray(array,1)\"}','根据下标获取数组里的值。position 传数字时直接作为值，而不是从所在对象 request 中取值','Object',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(9,0,'getFromObject','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','根据键获取对象里的值。','Object',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(10,0,'deleteCommentOfMoment','momentId','{\"momentId\": 1}','根据动态 id 删除它的所有评论','Object',0,'Moment','DELETE','2019-08-17 18:46:56',NULL),(11,0,'verifyIdList','array','{\"array\": [1, 2, 3], \"result()\": \"verifyIdList(array)\"}','校验类型为 id 列表','Object',0,NULL,NULL,'2019-08-17 19:58:33',NULL),(12,0,'verifyURLList','array','{\"array\": [\"http://123.com/1.jpg\", \"http://123.com/a.png\", \"http://www.abc.com/test.gif\"], \"result()\": \"verifyURLList(array)\"}','校验类型为 URL 列表','Object',0,NULL,NULL,'2019-08-17 19:58:33',NULL),(13,0,'getWithDefault','value,defaultValue','{\"value\": null, \"defaultValue\": 1}','如果 value 为 null，则返回 defaultValue','Object',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(14,0,'removeKey','key','{\"key\": \"s\", \"key2\": 2}','从对象里移除 key','Object',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(15,0,'getFunctionDemo',NULL,'{}','获取远程函数的 Demo','Object',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(16,0,'getFunctionDetail',NULL,'{}','获取远程函数的详情','Object',0,NULL,NULL,'2019-08-20 15:26:36',NULL);
