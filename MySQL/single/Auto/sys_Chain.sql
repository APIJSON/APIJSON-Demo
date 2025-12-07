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
-- Table structure for table `chain`
--

DROP TABLE IF EXISTS `chain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chain` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userId` bigint NOT NULL,
  `host` varchar(100) DEFAULT NULL,
  `testAccountId` varchar(45) NOT NULL DEFAULT '0',
  `toGroupId` bigint NOT NULL DEFAULT '0',
  `groupId` bigint NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `rank` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `documentId` bigint NOT NULL DEFAULT '0',
  `documentName` varchar(100) DEFAULT NULL,
  `randomId` bigint NOT NULL DEFAULT '0',
  `randomName` varchar(100) DEFAULT NULL,
  `scriptId` bigint NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tagList` json DEFAULT NULL COMMENT '标签列表',
  `testName` varchar(45) DEFAULT NULL COMMENT '测试用户名称',
  `testAccount` varchar(45) DEFAULT NULL COMMENT '测试用户账号，一般是手机号、邮箱等',
  `testInfo` json DEFAULT NULL COMMENT '测试用户信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idnew_table_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1761204465119 DEFAULT CHARSET=utf8mb3 COMMENT='多接口串联的场景链路用例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chain`
--

LOCK TABLES `chain` WRITE;
/*!40000 ALTER TABLE `chain` DISABLE KEYS */;
INSERT INTO `chain` VALUES (11,82001,NULL,'',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2024-10-27 13:46:19',0,NULL,0,NULL,0,'2024-05-02 13:12:36','[\"Moment\"]',NULL,NULL,NULL),(12,82001,NULL,'',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2024-10-27 13:46:19',1648334213866,NULL,0,NULL,0,'2024-05-02 13:15:49','[\"Moment\"]','','','{}'),(13,82001,NULL,'82002',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2024-10-27 13:46:19',1546414179257,NULL,0,NULL,0,'2024-05-02 13:16:02','[\"Moment\"]','Jan','13000082002','{\"id\": 82002, \"name\": \"Jan\", \"phone\": \"13000082002\", \"account\": \"13000082002\", \"baseUrl\": \"http://localhost:8080\", \"password\": \"123456\", \"redCount\": 0, \"remember\": false, \"blueCount\": 0, \"greenCount\": 0, \"isLoggedIn\": true, \"totalCount\": 18, \"whiteCount\": 18, \"orangeCount\": 0, \"summaryType\": \"total\"}'),(15,82001,NULL,'',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2024-10-27 13:46:19',1704192205562,NULL,0,NULL,0,'2024-05-02 13:21:29','[\"Moment\"]',NULL,NULL,NULL),(16,82001,NULL,'',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2024-10-27 13:46:19',1704192205563,NULL,0,NULL,0,'2024-05-02 13:21:54','[\"Moment\"]',NULL,NULL,NULL),(17,82001,NULL,'82003',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2024-10-27 13:46:19',1511969630372,NULL,0,NULL,0,'2024-05-02 13:22:10','[\"Moment\"]','Wechat','13000082003','{\"id\": 82003, \"name\": \"Wechat\", \"phone\": \"13000082003\", \"account\": \"13000082003\", \"baseUrl\": \"http://localhost:8080\", \"password\": \"123456\", \"redCount\": 0, \"remember\": false, \"blueCount\": 0, \"greenCount\": 0, \"isLoggedIn\": true, \"totalCount\": 0, \"whiteCount\": 0, \"orangeCount\": 0, \"summaryType\": \"total\"}'),(48,1704867025040,NULL,'',0,1742784526673,'查询动态列表','2025-03-24 02:48:46',0,NULL,0,NULL,0,'2025-03-24 02:48:46',NULL,NULL,NULL,NULL),(49,82001,NULL,'',0,1742784526673,'查询动态列表','2025-03-24 06:05:56',1704192205420,NULL,0,NULL,0,'2025-03-24 06:05:56','[\"Moment\", \"Tommy\"]','','','{}'),(54,1681451084123,NULL,'',0,1751529769988,'查询','2025-07-03 08:02:50',0,NULL,0,NULL,0,'2025-07-03 08:02:50',NULL,NULL,NULL,NULL),(59,82001,NULL,'',0,1742784526673,'查询动态列表','2025-08-08 04:09:57',1564483634841,NULL,0,NULL,0,'2025-08-08 04:09:58','[\"Moment\", \"Tommy\"]','','','{}'),(1759994627546,82001,NULL,'',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2025-10-09 07:23:47',1546414192830,NULL,0,NULL,0,'2025-10-09 07:23:47','[\"Moment\"]',NULL,NULL,NULL),(1761204465097,82001,NULL,'82001',0,1714655556079,'查询动态列表-查询动态详情-查询评论列表-回复评论','2025-10-23 07:27:45',1704192205420,NULL,0,NULL,0,'2025-10-23 07:27:45','[\"Moment\"]','Test User','13000082001','{\"id\": 82001, \"name\": \"Test User\", \"phone\": \"13000082001\", \"account\": \"13000082001\", \"baseUrl\": \"http://localhost:8080\", \"password\": \"123456\", \"redCount\": 7, \"remember\": false, \"blueCount\": 13, \"greenCount\": 0, \"isLoggedIn\": true, \"totalCount\": 26, \"whiteCount\": 6, \"orangeCount\": 0, \"summaryType\": \"total\"}'),(1761204465098,82001,NULL,'',0,1742784526673,'查询动态列表','2025-10-27 03:14:19',1522905895591,NULL,0,NULL,0,'2025-10-27 03:14:20','[\"Moment\", \"Tommy\"]','','','{}'),(1761204465117,82001,NULL,'',0,1742784526673,'查询动态列表','2025-11-30 10:43:35',1511796155276,'获取验证码',0,NULL,0,'2025-11-30 10:43:35','[\"Moment\", \"Tommy\"]',NULL,NULL,NULL),(1761204465118,82001,NULL,'0',0,1765106927698,'test chain case','2025-12-07 11:28:47',0,NULL,0,NULL,0,'2025-12-07 11:28:47','[\"test\"]',NULL,NULL,NULL);
/*!40000 ALTER TABLE `chain` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-07 19:38:58
