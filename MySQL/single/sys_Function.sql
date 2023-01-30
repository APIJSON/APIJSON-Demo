-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: apijson.cn    Database: sys
-- ------------------------------------------------------
-- Server version	5.7.34-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Function`
--

DROP TABLE IF EXISTS `Function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Function` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `debug` tinyint NOT NULL DEFAULT '0' COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `userId` bigint NOT NULL COMMENT '管理员用户Id',
  `language` varchar(45) DEFAULT NULL COMMENT '语言：Java(java), JavaScript(js), Lua(lua), Python(py), Ruby(ruby), PHP(php) 等，NULL 默认为 Java，JDK 1.6-11 默认支持 JavaScript，JDK 12+ 需要额外依赖 Nashron/Rhiro 等 js 引擎库，其它的语言需要依赖对应的引擎库，并在 ScriptEngineManager 中注册',
  `name` varchar(50) NOT NULL COMMENT '方法名',
  `returnType` varchar(50) DEFAULT 'Object' COMMENT '返回值类型。TODO RemoteFunction 校验 type 和 back',
  `arguments` varchar(100) DEFAULT NULL COMMENT '参数列表，每个参数的类型都是 String。\n用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。',
  `demo` json NOT NULL COMMENT '可用的示例。\nTODO 改成 call，和返回值示例 back 对应。',
  `detail` varchar(1000) NOT NULL COMMENT '详细描述',
  `version` tinyint NOT NULL DEFAULT '0' COMMENT '允许的最低版本号，只限于GET,HEAD外的操作方法。\nTODO 使用 requestIdList 替代 version,tag,methods',
  `tag` varchar(20) DEFAULT NULL COMMENT '允许的标签.\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `methods` varchar(50) DEFAULT NULL COMMENT '允许的操作方法。\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `return` varchar(45) DEFAULT NULL COMMENT '返回值示例',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='远程函数。强制在启动时校验所有demo是否能正常运行通过';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Function`
--

LOCK TABLES `Function` WRITE;
/*!40000 ALTER TABLE `Function` DISABLE KEYS */;
INSERT INTO `Function` VALUES (3,0,0,NULL,'countArray','int','array','{\"array\": [1, 2, 3]}','获取数组长度。没写调用键值对，会自动补全 \"result()\": \"countArray(array)\"',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(4,0,0,NULL,'countObject','int','object','{\"object\": {\"key0\": 1, \"key1\": 2}}','获取对象长度。',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(5,0,0,NULL,'isContain','boolean','array,value','{\"array\": [1, 2, 3], \"value\": 2}','判断是否数组包含值。',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(6,0,0,NULL,'isContainKey','boolean','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','判断是否对象包含键。',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(7,0,0,NULL,'isContainValue','boolean','object,value','{\"value\": 1, \"object\": {\"id\": 1}}','判断是否对象包含值。',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(8,0,0,NULL,'getFromArray','Object','array,position','{\"array\": [1, 2, 3], \"result()\": \"getFromArray(array,1)\"}','根据下标获取数组里的值。position 传数字时直接作为值，而不是从所在对象 request 中取值',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(9,0,0,NULL,'getFromObject','Object','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','根据键获取对象里的值。',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(10,0,0,NULL,'deleteCommentOfMoment','int','momentId','{\"momentId\": 1}','根据动态 id 删除它的所有评论',0,'Moment','DELETE','2019-08-17 18:46:56',NULL),(11,0,0,NULL,'verifyIdList',NULL,'array','{\"array\": [1, 2, 3], \"result()\": \"verifyIdList(array)\"}','校验类型为 id 列表',0,NULL,NULL,'2019-08-17 19:58:33',NULL),(12,0,0,NULL,'verifyURLList',NULL,'array','{\"array\": [\"http://123.com/1.jpg\", \"http://123.com/a.png\", \"http://www.abc.com/test.gif\"], \"result()\": \"verifyURLList(array)\"}','校验类型为 URL 列表',0,NULL,NULL,'2019-08-17 19:58:33',NULL),(13,0,0,NULL,'getWithDefault','Object','value,defaultValue','{\"value\": null, \"defaultValue\": 1}','如果 value 为 null，则返回 defaultValue',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(14,0,0,NULL,'removeKey','Object','key','{\"key\": \"s\", \"key2\": 2}','从对象里移除 key',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(15,0,0,NULL,'getFunctionDemo','JSONObject',NULL,'{}','获取远程函数的 Demo',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(16,0,0,NULL,'getFunctionDetail','String',NULL,'{}','获取远程函数的详情',0,NULL,NULL,'2019-08-20 15:26:36',NULL),(17,0,0,NULL,'getMethodArguments','String','methodArgs','{\"methodArgs\": \"methodArgs\"}','获取远程函数的参数',0,NULL,NULL,'2021-07-29 09:32:22',NULL),(18,0,0,NULL,'getMethodDefination','String','method,arguments,type,exceptions,language','{\"method\": \"method\"}','获取远程函数的签名定义',0,NULL,NULL,'2021-07-29 09:34:37',NULL),(19,0,0,NULL,'getMethodRequest','String',NULL,'{}','获取远程函数的请求',0,NULL,NULL,'2021-07-29 09:35:37',NULL),(20,0,0,NULL,'deleteChildComment','int','commentId','{}','删除评论的子评论',0,NULL,NULL,'2021-09-10 06:53:24',NULL),(21,0,0,NULL,'getCurrentUserId','Long',NULL,'{}','获取当前登录用户 id',0,NULL,NULL,'2022-02-19 17:27:41',NULL),(22,0,0,NULL,'getCurrentUserIdAsList','List',NULL,'{}','获取当前登录用户 id 列表，只包含一个 id，只是为了前端方便构造某些请求',0,NULL,NULL,'2022-02-19 17:27:41',NULL),(24,0,0,NULL,'getCurrentUser','Visitor',NULL,'{}','获取当前登录用户公开信息',0,NULL,NULL,'2022-02-19 17:34:58',NULL),(26,0,0,NULL,'getCurrentContactIdList','List',NULL,'{}','获取当前登录用户的联系人 id 列表',0,NULL,NULL,'2022-02-19 17:37:35',NULL),(27,0,0,NULL,'getMethodDefinition','String','method,arguments,type,exceptions,language','{\"method\": \"method\"}','获取远程函数的签名定义',0,NULL,NULL,'2021-07-29 09:34:37',NULL);
/*!40000 ALTER TABLE `Function` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-01-30 15:42:51
