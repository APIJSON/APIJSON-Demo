-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: localhost    Database: sys
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `Script`
--

DROP TABLE IF EXISTS `Script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Script` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userId` bigint NOT NULL DEFAULT '0' COMMENT '用户 id',
  `testAccountId` bigint NOT NULL DEFAULT '0' COMMENT '测试账号 id',
  `chainGroupId` bigint NOT NULL DEFAULT '0',
  `documentId` bigint NOT NULL DEFAULT '0' COMMENT '测试用例 id',
  `simple` tinyint NOT NULL DEFAULT '0' COMMENT '是否为可直接执行的简单代码段：0-否 1-是',
  `ahead` tinyint NOT NULL DEFAULT '0' COMMENT '是否为前置脚本',
  `title` varchar(100) DEFAULT NULL COMMENT '函数名',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `script` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `detail` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1680660620758 DEFAULT CHARSET=utf8mb3 COMMENT='脚本，前置预处理脚本、后置断言和恢复脚本等';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Script`
--

LOCK TABLES `Script` WRITE;
/*!40000 ALTER TABLE `Script` DISABLE KEYS */;
INSERT INTO `Script` VALUES (1,0,0,0,0,0,0,NULL,'getType','function getType(curObj, key) {\n    var val = curObj == null ? null : curObj[key];\n    return val instanceof Array ? \"array\" : typeof val;\n}','2022-11-16 16:01:23',NULL),(2,0,0,0,0,0,0,NULL,'isContain','function isContain(curObj, arrKey, valKey) {\n    var arr = curObj == null ? null : curObj[arrKey];\n    var val = curObj == null ? null : curObj[valKey];\n    return arr != null && arr.indexOf(val) >=0;\n}','2022-11-16 16:02:48',NULL),(3,0,0,0,0,1,0,NULL,'init','var i = 1;\n\"init done \"  + i;','2022-11-16 16:41:35',NULL),(4,0,0,0,0,0,0,NULL,'length','function length(curObj, key) {\n    var val = curObj == null ? null : curObj[key];\n    return val == null ? 0 : val.length;\n}','2022-11-16 17:18:43',NULL),(1670877704568,82001,0,0,1560244940013,1,0,'执行脚本 2022-12-13 04:41','','','2022-12-12 20:41:44',NULL),(1670877914051,82001,0,0,0,1,1,'执行脚本 2022-12-13 04:44','','function assert(assertion, msg) {\n     if (assertion === true) {\n         return\n     }\n     if (msg == null) {\n         msg = \'assert failed! assertion = \' + assertion\n     }\n\n     if (isTest) {\n         console.log(msg)\n         alert(msg)\n     } else {\n         throw new Error(msg)\n     } \n}  \n\nif (isTest) {\n     assert(true)\n     assert(false)\n     assert(true, \'ok\')\n     assert(false, \'data.User shoule not be null!\') \n}\n\nfunction getCurAccount() {\n  return App.getCurrentAccount()\n}','2022-12-12 20:45:14',NULL),(1670878495619,82001,82002,0,0,1,0,'执行脚本 2022-12-13 04:54','','function getCurAccount() {\n  return App.getCurrentAccount()\n}','2022-12-12 20:54:55',NULL),(1670878529042,82001,82001,0,0,1,1,'执行脚本 2022-12-13 04:55','','function getCurAccount() {\n  return App.getCurrentAccount()\n}','2022-12-12 20:55:29',NULL),(1670878622401,82001,82003,0,0,1,0,'执行脚本 2022-12-13 04:57','','if (isPre) {\n  header[\'my-header\'] = \'test\'\n}','2022-12-12 20:57:02',NULL),(1670885503909,82001,0,0,1657045372046,1,1,'执行脚本 2022-12-13 06:51','','if (isPre) {\n  req.User.id = 82005\n}','2022-12-12 22:51:43',NULL),(1670887211207,82001,0,0,1657045372046,1,0,'执行脚本 2022-12-13 07:20','','','2022-12-12 23:20:11',NULL),(1676368454070,82001,0,0,1546414192830,1,0,NULL,'casePost1546414192830','','2023-02-14 09:54:14',NULL),(1679045094732,82001,0,0,1634655384665,1,1,NULL,'zzq测试','console.log(\'test\')','2023-03-17 09:24:54',NULL),(1679282174670,82001,0,0,0,1,1,NULL,'到店系统查询','','2023-03-20 03:16:14',NULL),(1680660565019,82001,0,0,1560244940013,1,1,NULL,'casePre1560244940013','','2023-04-05 02:09:25',NULL),(1680660620757,82001,0,0,1560244940013,1,0,NULL,'casePost1560244940013','alert(123)','2023-04-05 02:10:20',NULL);
/*!40000 ALTER TABLE `Script` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-28 23:38:56
