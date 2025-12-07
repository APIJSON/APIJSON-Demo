-- MySQL dump 10.13  Distrib 8.0.42, for macos15 (arm64)
--
-- Host: apijson.cn    Database: sys
-- ------------------------------------------------------
-- Server version	8.4.5

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
-- Table structure for table `script`
--

DROP TABLE IF EXISTS `script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `script` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userId` bigint NOT NULL DEFAULT '0' COMMENT '用户 id',
  `testAccountId` bigint NOT NULL DEFAULT '0' COMMENT '测试账号 id',
  `chainGroupId` bigint NOT NULL DEFAULT '0',
  `chainId` bigint NOT NULL DEFAULT '0',
  `documentId` bigint NOT NULL DEFAULT '0' COMMENT '测试用例 id',
  `simple` tinyint NOT NULL DEFAULT '0' COMMENT '是否为可直接执行的简单代码段：0-否 1-是',
  `ahead` tinyint NOT NULL DEFAULT '0' COMMENT '是否为前置脚本',
  `title` varchar(100) DEFAULT NULL COMMENT '函数名',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `script` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `detail` varchar(1000) DEFAULT NULL,
  `randomId` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1738490404343 DEFAULT CHARSET=utf8mb3 COMMENT='脚本，前置预处理脚本、后置断言和恢复脚本等';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `script`
--

LOCK TABLES `script` WRITE;
/*!40000 ALTER TABLE `script` DISABLE KEYS */;
INSERT INTO `script` VALUES (1,0,0,0,0,0,0,0,NULL,'getType','function getType(curObj, key) {\n    var val = curObj == null ? null : curObj[key];\n    return val instanceof Array ? \"array\" : typeof val;\n}','2022-11-16 16:01:23',NULL,0),(2,0,0,0,0,0,0,0,NULL,'isContain','function isContain(curObj, arrKey, valKey) {\n    var arr = curObj == null ? null : curObj[arrKey];\n    var val = curObj == null ? null : curObj[valKey];\n    return arr != null && arr.indexOf(val) >=0;\n}','2022-11-16 16:02:48',NULL,0),(3,0,0,0,0,0,1,0,NULL,'init','var i = 1;\n\"init done \"  + i;','2022-11-16 16:41:35',NULL,0),(4,0,0,0,0,0,0,0,NULL,'length','function length(curObj, key) {\n    var val = curObj == null ? null : curObj[key];\n    return val == null ? 0 : val.length;\n}','2022-11-16 17:18:43',NULL,0),(1670877914051,82001,0,0,0,0,1,1,'执行脚本 2022-12-13 04:44','','function assert(assertion, msg) {\n     if (assertion === true) {\n         return\n     }\n     if (msg == null) {\n         msg = \'assert failed! assertion = \' + assertion\n     }\n\n     if (isTest) {\n         console.log(msg)\n         alert(msg)\n     } else {\n         throw new Error(msg)\n     } \n}  \n\nif (isTest) {\n     assert(true)\n     assert(false)\n     assert(true, \'ok\')\n     assert(false, \'data.User shoule not be null!\') \n}\n\nfunction getCurAccount() {\n  return App.getCurrentAccount()\n}','2022-12-12 20:45:14',NULL,0),(1670878495619,82001,82002,0,0,0,1,0,'执行脚本 2022-12-13 04:54','','function getCurAccount() {\n  return App.getCurrentAccount()\n}','2022-12-12 20:54:55',NULL,0),(1670878529042,82001,82001,0,0,0,1,1,'执行脚本 2022-12-13 04:55','','function getCurAccount() {\n  return App.getCurrentAccount()\n}','2022-12-12 20:55:29',NULL,0),(1670878622401,82001,82003,0,0,0,1,0,'执行脚本 2022-12-13 04:57','','if (isPre) {\n  header[\'my-header\'] = \'test\'\n}','2022-12-12 20:57:02',NULL,0),(1670885503909,82001,0,0,0,1657045372046,1,1,'执行脚本 2022-12-13 06:51','','if (isPre) {\n  req.User.id = 82005\n}','2022-12-12 22:51:43',NULL,0),(1670887211207,82001,0,0,0,1657045372046,1,0,'执行脚本 2022-12-13 07:20','','','2022-12-12 23:20:11',NULL,0),(1676368454070,82001,0,0,0,1546414192830,1,0,NULL,'casePost1546414192830','','2023-02-14 09:54:14',NULL,0),(1679282174670,82001,0,0,0,0,1,1,NULL,'到店系统查询','','2023-03-20 03:16:14',NULL,0),(1680660620759,82001,0,0,0,1511796155276,1,1,NULL,'casePre1511796155276','if (isPre) {\n    console.log(\'test pre script 4 /post/verify\')    \n}\n','2024-05-03 03:55:14',NULL,0),(1680660620760,82001,0,1716706529846,42,1511970009072,1,1,NULL,'casePre1511970009072','if (isPre) { console.log(\"test pre script\") }','2024-09-08 16:00:15',NULL,0),(1680660620761,82001,0,1716706529846,42,1511970009072,1,0,NULL,'casePost1511970009072','console.log(\'run post script\')','2024-09-08 16:00:32',NULL,0),(1680660620762,82001,0,1714209723275,2,1546414192830,1,1,NULL,'casePre1546414192830','','2024-11-28 02:10:39',NULL,0),(1738490311550,0,0,0,0,1560244940013,1,0,NULL,'casePost1560244940013','','2025-02-02 09:58:32',NULL,0),(1738490327734,0,0,0,0,0,1,0,NULL,'globalPost0','if (data != null) {\n    delete data[\"sql:generate|cache|execute|maxExecute\"]\n}\n','2025-02-02 09:58:48',NULL,0),(1738490404341,0,0,0,0,0,1,1,NULL,'globalPre0','req[\'@explain\'] = true','2025-02-02 10:00:04',NULL,0),(1738490404342,82001,0,0,0,0,1,1,NULL,'','','2025-03-11 08:54:24',NULL,0);
/*!40000 ALTER TABLE `script` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-07 19:38:59
