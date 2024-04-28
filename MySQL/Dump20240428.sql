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
-- Table structure for table `Access`
--

DROP TABLE IF EXISTS `Access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Access` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `debug` tinyint NOT NULL DEFAULT '0' COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `schema` varchar(100) DEFAULT NULL COMMENT '数据库名/模式',
  `name` varchar(50) NOT NULL COMMENT '实际表名，例如 apijson_user',
  `alias` varchar(20) DEFAULT NULL COMMENT '外部调用的表别名，例如 User，前端传参示例 { "User":{} }',
  `get` varchar(100) NOT NULL DEFAULT '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 get 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]\n用 JSON 类型不能设置默认值，反正权限对应的需求是明确的，也不需要自动转 JSONArray。\nTODO: 直接 LOGIN,CONTACT,CIRCLE,OWNER 更简单，反正是开发内部用，不需要复杂查询。',
  `head` varchar(100) NOT NULL DEFAULT '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 head 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `gets` varchar(100) NOT NULL DEFAULT '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 gets 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `heads` varchar(100) NOT NULL DEFAULT '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 heads 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `post` varchar(100) NOT NULL DEFAULT '["OWNER", "ADMIN"]' COMMENT '允许 post 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `put` varchar(100) NOT NULL DEFAULT '["OWNER", "ADMIN"]' COMMENT '允许 put 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `delete` varchar(100) NOT NULL DEFAULT '["OWNER", "ADMIN"]' COMMENT '允许 delete 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `detail` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `alias_UNIQUE` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3 COMMENT='权限配置(必须)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Access`
--

LOCK TABLES `Access` WRITE;
/*!40000 ALTER TABLE `Access` DISABLE KEYS */;
INSERT INTO `Access` VALUES (1,0,NULL,'Access',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2019-07-21 12:21:36',NULL),(2,1,NULL,'tables','Table','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:14',NULL),(3,1,NULL,'columns','Column','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:14',NULL),(4,0,NULL,'Function',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:15',NULL),(5,0,NULL,'Request',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"ADMIN\"]','[]','[]','2018-11-28 16:38:14',NULL),(6,0,NULL,'Response',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:15',NULL),(7,1,NULL,'Document',NULL,'[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2018-11-28 16:38:15',NULL),(8,1,NULL,'TestRecord',NULL,'[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2018-11-28 16:38:15',NULL),(9,0,NULL,'Test',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:15',NULL),(10,1,NULL,'pg_attribute','PgAttribute','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:14',NULL),(11,1,NULL,'pg_class','PgClass','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:14',NULL),(12,0,NULL,'Login',NULL,'[]','[]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[ \"ADMIN\"]','[ \"ADMIN\"]','[\"ADMIN\"]','2018-11-28 16:29:48',NULL),(13,0,NULL,'Verify',NULL,'[]','[]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[ \"ADMIN\"]','[\"ADMIN\"]','2018-11-28 16:29:48',NULL),(14,0,NULL,'apijson_user','User','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\",\"LOGIN\",\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"ADMIN\"]','2018-11-28 16:28:53',NULL),(15,0,NULL,'apijson_privacy','Privacy','[]','[]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"UNKNOWN\",\"LOGIN\",\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"ADMIN\"]','2018-11-28 16:29:48',NULL),(16,0,NULL,'Moment',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2018-11-28 16:29:19',NULL),(17,0,NULL,'Comment',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2018-11-28 16:29:19',NULL),(19,1,NULL,'tables','SysTable','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2019-10-04 01:01:20',NULL),(20,1,NULL,'columns','SysColumn','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2019-10-04 01:01:20',NULL),(21,1,NULL,'extended_properties','ExtendedProperty','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2019-10-04 01:33:45',NULL),(22,1,NULL,'Random',NULL,'[\"LOGIN\", \"ADMIN\"]','[\"LOGIN\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2019-12-01 15:13:13',NULL),(24,1,NULL,'Method',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"LOGIN\",\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2018-11-28 16:38:15',NULL),(25,1,NULL,'Input',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2020-01-10 07:12:49',NULL),(26,1,NULL,'Device',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2020-01-10 07:12:49',NULL),(27,1,NULL,'System',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2020-01-10 07:12:49',NULL),(28,1,NULL,'Flow',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2020-01-10 07:12:49',NULL),(29,1,NULL,'Output',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2020-01-10 07:12:49',NULL),(30,0,NULL,'ViewTable',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2021-01-20 14:51:43','MySQL View 支持多张表合并为一张表，这个示例 View 的创建 SQL 为 CREATE VIEW sys.`ViewTable` AS SELECT C.id as `commentId`, C.toId, C.momentId, C.content,  U.* FROM sys.Comment AS C INNER JOIN sys.apijson_user AS U ON U.id = C.userId; 初测正则匹配等条件单表查询、与其它表关联查询、与其它表 JOIN 都和普通的表用起来没有大的区别，目前发现的问题两个是： 1.作为 ViewTable 的表中有同名字段的话要把部分字段取别名，例如 Comment 和 apijson_user 都有 id，这里就用 C.id as `commentId` 取了别名避免冲突；2.APIAuto 不能显示 ViewTable 的表注释和字段注释'),(31,1,NULL,'ALL_TABLES','AllTable','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-10-09 11:39:55',NULL),(32,1,NULL,'ALL_TAB_COLUMNS','AllColumn','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-10-09 11:39:55',NULL),(33,1,NULL,'ALL_TAB_COMMENTS','AllTableComment','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-10-09 07:07:04',NULL),(34,1,NULL,'ALL_COL_COMMENTS','AllColumnComment','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-10-09 07:07:04',NULL),(35,0,NULL,'Activity',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-12-05 17:45:34',NULL),(36,0,NULL,'Fragment',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-12-05 17:45:34',NULL),(37,0,NULL,'View',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-12-05 17:45:34',NULL),(38,0,NULL,'Script',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-12-05 17:45:34',NULL),(39,0,NULL,'Chain',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2022-12-05 17:45:34',NULL);
/*!40000 ALTER TABLE `Access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Chain`
--

DROP TABLE IF EXISTS `Chain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Chain` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userId` bigint NOT NULL,
  `toGroupId` bigint NOT NULL DEFAULT '0',
  `groupId` bigint NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `documentId` bigint NOT NULL DEFAULT '0',
  `randomId` bigint NOT NULL DEFAULT '0',
  `scriptId` bigint NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idnew_table_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COMMENT='多接口串联的场景链路用例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Chain`
--

LOCK TABLES `Chain` WRITE;
/*!40000 ALTER TABLE `Chain` DISABLE KEYS */;
INSERT INTO `Chain` VALUES (1,82001,0,1714209723275,'查询用户列表-查询用户',0,0,0,'2024-04-27 09:22:03'),(2,82001,0,1714209723275,'查询用户列表-查询用户',1546414192830,0,0,'2024-04-27 13:08:48'),(3,82001,0,1714209723275,'查询用户列表-查询用户',1560737118846,0,0,'2024-04-27 13:12:38'),(4,82001,0,1714209723275,'查询用户列表-查询用户',1511689914599,0,0,'2024-04-27 13:25:36'),(5,82001,0,1714224419584,'查询动态列表-查询动态详情-查询评论列表-回复评论',0,0,0,'2024-04-27 13:26:59'),(8,82001,0,1714224419584,'查询动态列表-查询动态详情-查询评论列表-回复评论',1546414155879,0,0,'2024-04-27 13:34:48'),(9,82001,0,1714224419584,'查询动态列表-查询动态详情-查询评论列表-回复评论',1546414179257,0,0,'2024-04-27 13:35:02'),(10,82001,0,1714225363685,'chain case',0,0,0,'2024-04-27 13:42:43');
/*!40000 ALTER TABLE `Chain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Random`
--

DROP TABLE IF EXISTS `Random`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Random` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `toId` bigint NOT NULL DEFAULT '0' COMMENT '父项 id',
  `from` tinyint NOT NULL DEFAULT '0' COMMENT '来源：0-接口工具；1-CI/CD；2-流量录制',
  `userId` bigint NOT NULL,
  `documentId` bigint NOT NULL COMMENT '测试用例 Document 的 id',
  `count` int NOT NULL DEFAULT '1' COMMENT '请求次数，默认 1',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `config` varchar(5000) NOT NULL COMMENT '配置',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `index_date` (`date` DESC),
  KEY `index_documentId` (`documentId` DESC),
  KEY `index_toId` (`toId` DESC),
  KEY `index_documentId_toId` (`documentId` DESC,`toId` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1703490140871 DEFAULT CHARSET=utf8mb3 COMMENT='随机测试配置(必须)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Random`
--

LOCK TABLES `Random` WRITE;
/*!40000 ALTER TABLE `Random` DISABLE KEYS */;
INSERT INTO `Random` VALUES (1592236063697,0,0,82001,1592232912349,20,'随机配置（模拟同步、异步、返回值等各种情况）','methodArgs/0/value: RANDOM_IN(1, 0.1, -10, 9.99, null)  // 随机取值\nmethodArgs/1/value: ORDER_INT(-10, 100)  // 顺序整数\n\nmethodArgs/2/value/id: RANDOM_INT(1, 100)  // 随机整数\nmethodArgs/2/value/sort()/callback: RANDOM_IN(true, false, null)  // 随机整数\nmethodArgs/2/value/sort()/return: ORDER_IN(true, false, null)  // 随机整数\nmethodArgs/2/value/setData(D)/callback: ORDER_IN(true, false, null)  // 顺序取值\n\n  // 清空文本内容可查看规则','2020-06-15 15:47:43'),(1592236120511,1592236063697,0,82001,1592232912349,1,'-10, -9, 60, false, false, false','methodArgs/0/value: -10 \nmethodArgs/1/value: -9 \nmethodArgs/2/value/id: 60 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:48:40'),(1592236129822,1592236063697,0,82001,1592232912349,1,'-10, -6, 93, null, false, false','methodArgs/0/value: -10 \nmethodArgs/1/value: -6 \nmethodArgs/2/value/id: 93 \nmethodArgs/2/value/sort()/callback: null \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:48:49'),(1592236131622,1592236063697,0,82001,1592232912349,1,'1, -5, 29, true, null, null','methodArgs/0/value: 1 \nmethodArgs/1/value: -5 \nmethodArgs/2/value/id: 29 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-06-15 15:48:51'),(1592236138019,1592236063697,0,82001,1592232912349,1,'-10, -1, 46, false, true, true','methodArgs/0/value: -10 \nmethodArgs/1/value: -1 \nmethodArgs/2/value/id: 46 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-06-15 15:48:58'),(1592236142525,1592236063697,0,82001,1592232912349,1,'-10, 2, 43, false, true, true','methodArgs/0/value: -10 \nmethodArgs/1/value: 2 \nmethodArgs/2/value/id: 43 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-06-15 15:49:02'),(1592236143975,1592236063697,0,82001,1592232912349,1,'-10, 3, 68, false, false, false','methodArgs/0/value: -10 \nmethodArgs/1/value: 3 \nmethodArgs/2/value/id: 68 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:49:03'),(1592236148039,1592236063697,0,82001,1592232912349,1,'-10, 6, 13, false, false, false','methodArgs/0/value: -10 \nmethodArgs/1/value: 6 \nmethodArgs/2/value/id: 13 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:49:08'),(1592236219210,1592236063697,0,82001,1592232912349,1,'-10, -10, 35, null, true, true','methodArgs/0/value: -10 \nmethodArgs/1/value: -10 \nmethodArgs/2/value/id: 35 \nmethodArgs/2/value/sort()/callback: null \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-06-15 15:50:19'),(1592236222611,1592236063697,0,82001,1592232912349,1,'0.1, -9, 37, false, false, false','methodArgs/0/value: 0.1 \nmethodArgs/1/value: -9 \nmethodArgs/2/value/id: 37 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:50:22'),(1592236224205,1592236063697,0,82001,1592232912349,1,'-10, -8, 58, false, null, null','methodArgs/0/value: -10 \nmethodArgs/1/value: -8 \nmethodArgs/2/value/id: 58 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-06-15 15:50:24'),(1592236225905,1592236063697,0,82001,1592232912349,1,'0.1, -7, 97, true, true, true','methodArgs/0/value: 0.1 \nmethodArgs/1/value: -7 \nmethodArgs/2/value/id: 97 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-06-15 15:50:25'),(1592236234662,1592236063697,0,82001,1592232912349,1,'1, -3, 24, null, false, false','methodArgs/0/value: 1 \nmethodArgs/1/value: -3 \nmethodArgs/2/value/id: 24 \nmethodArgs/2/value/sort()/callback: null \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:50:34'),(1592236238868,1592236063697,0,82001,1592232912349,1,'-10, 0, 87, false, false, false','methodArgs/0/value: -10 \nmethodArgs/1/value: 0 \nmethodArgs/2/value/id: 87 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:50:38'),(1592236241680,1592236063697,0,82001,1592232912349,1,'0.1, 1, 16, false, null, null','methodArgs/0/value: 0.1 \nmethodArgs/1/value: 1 \nmethodArgs/2/value/id: 16 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-06-15 15:50:41'),(1592236249655,1592236063697,0,82001,1592232912349,1,'0.1, -6, 94, true, false, false','methodArgs/0/value: 0.1 \nmethodArgs/1/value: -6 \nmethodArgs/2/value/id: 94 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:50:49'),(1592236300946,0,0,82001,1592232912349,10,'随机配置 2020-06-15 23:51','methodArgs/0/value: RANDOM_IN(1, 2, -3, 5, -10, 12, 50)  // 随机取值\nmethodArgs/1/value: ORDER_INT(-10, 100)  // 顺序整数\n\nmethodArgs/2/value/id: RANDOM_INT(1, 100)  // 随机整数\nmethodArgs/2/value/sort()/callback: RANDOM_IN(true, false, null)  // 随机整数\nmethodArgs/2/value/sort()/return: ORDER_IN(true, false, null)  // 随机整数\nmethodArgs/2/value/setData(D)/callback: ORDER_IN(true, false, null)  // 顺序取值\n\n  // 清空文本内容可查看规则','2020-06-15 15:51:40'),(1592236325414,1592236300946,0,82001,1592232912349,1,'5, -9, 89, false, false, false','methodArgs/0/value: 5 \nmethodArgs/1/value: -9 \nmethodArgs/2/value/id: 89 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:52:05'),(1592236327093,1592236300946,0,82001,1592232912349,1,'12, -8, 57, false, null, null','methodArgs/0/value: 12 \nmethodArgs/1/value: -8 \nmethodArgs/2/value/id: 57 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-06-15 15:52:07'),(1592236329908,1592236300946,0,82001,1592232912349,1,'2, -7, 72, null, true, true','methodArgs/0/value: 2 \nmethodArgs/1/value: -7 \nmethodArgs/2/value/id: 72 \nmethodArgs/2/value/sort()/callback: null \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-06-15 15:52:09'),(1592236331278,1592236300946,0,82001,1592232912349,1,'12, -6, 37, true, false, false','methodArgs/0/value: 12 \nmethodArgs/1/value: -6 \nmethodArgs/2/value/id: 37 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:52:11'),(1592236332607,1592236300946,0,82001,1592232912349,1,'-3, -5, 56, null, null, null','methodArgs/0/value: -3 \nmethodArgs/1/value: -5 \nmethodArgs/2/value/id: 56 \nmethodArgs/2/value/sort()/callback: null \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-06-15 15:52:12'),(1592236337079,1592236300946,0,82001,1592232912349,1,'-3, -3, 29, false, false, false','methodArgs/0/value: -3 \nmethodArgs/1/value: -3 \nmethodArgs/2/value/id: 29 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-06-15 15:52:17'),(1592236338392,1592236300946,0,82001,1592232912349,1,'1, -2, 81, false, null, null','methodArgs/0/value: 1 \nmethodArgs/1/value: -2 \nmethodArgs/2/value/id: 81 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-06-15 15:52:18'),(1592236516817,0,0,82001,1592232544326,50,'随机配置 2020-06-15 23:55','methodArgs/0/type: ORDER_IN(\'long\', \'double\', \'Number\', \'int\')  // 顺序取值\nmethodArgs/0/value: RANDOM_IN(1, 2, -10, 9.99, null)  // 随机取值\n\nmethodArgs/1/type: ORDER_IN(\'long\', \'double\', \'Number\', \'int\')  // 顺序取值\nmethodArgs/1/value: ORDER_INT(-10, 100)  // 顺序整数','2020-06-15 15:55:16'),(1592236538024,1592236516817,0,82001,1592232544326,1,'long, -10, long, -10','methodArgs/0/type: \"long\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: -10','2020-06-15 15:55:38'),(1592236540298,1592236516817,0,82001,1592232544326,1,'double, 1, double, -9','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -9','2020-06-15 15:55:40'),(1592236541830,1592236516817,0,82001,1592232544326,1,'Number, 2, Number, -8','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: -8','2020-06-15 15:55:41'),(1592236545792,1592236516817,0,82001,1592232544326,1,'long, -10, long, -6','methodArgs/0/type: \"long\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: -6','2020-06-15 15:55:45'),(1592236547836,1592236516817,0,82001,1592232544326,1,'double, 2, double, -5','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -5','2020-06-15 15:55:47'),(1592236549171,1592236516817,0,82001,1592232544326,1,'Number, -10, Number, -4','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: -4','2020-06-15 15:55:49'),(1592236550384,1592236516817,0,82001,1592232544326,1,'int, 9.99, int, -3','methodArgs/0/type: \"int\" \nmethodArgs/0/value: 9.99 \nmethodArgs/1/type: \"int\" \nmethodArgs/1/value: -3','2020-06-15 15:55:50'),(1592236555400,1592236516817,0,82001,1592232544326,1,'double, -10, double, -1','methodArgs/0/type: \"double\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -1','2020-06-15 15:55:55'),(1592236558165,1592236516817,0,82001,1592232544326,1,'Number, 9.99, Number, 0','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 9.99 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 0','2020-06-15 15:55:58'),(1592236560482,1592236516817,0,82001,1592232544326,1,'long, null, long, 2','methodArgs/0/type: \"long\" \nmethodArgs/0/value: null \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 2','2020-06-15 15:56:00'),(1592236566594,1592236516817,0,82001,1592232544326,1,'Number, -10, Number, 4','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 4','2020-06-15 15:56:06'),(1592236571068,1592236516817,0,82001,1592232544326,1,'double, 1, double, 7','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: 7','2020-06-15 15:56:11'),(1592236573614,1592236516817,0,82001,1592232544326,1,'Number, -10, Number, 8','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 8','2020-06-15 15:56:13'),(1592236575917,1592236516817,0,82001,1592232544326,1,'long, 2, long, 10','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 10','2020-06-15 15:56:15'),(1592236578178,1592236516817,0,82001,1592232544326,1,'double, -10, double, 11','methodArgs/0/type: \"double\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: 11','2020-06-15 15:56:18'),(1592236579227,1592236516817,0,82001,1592232544326,1,'Number, 1, Number, 12','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 12','2020-06-15 15:56:19'),(1592236580951,1592236516817,0,82001,1592232544326,1,'int, -10, int, 13','methodArgs/0/type: \"int\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"int\" \nmethodArgs/1/value: 13','2020-06-15 15:56:20'),(1592236583191,1592236516817,0,82001,1592232544326,1,'long, 2, long, 14','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 14','2020-06-15 15:56:23'),(1592236587324,1592236516817,0,82001,1592232544326,1,'double, 2, double, 15','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: 15','2020-06-15 15:56:27'),(1592236590200,1592236516817,0,82001,1592232544326,1,'Number, 2, Number, 16','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 16','2020-06-15 15:56:30'),(1592236594434,1592236516817,0,82001,1592232544326,1,'long, 1, long, 18','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 18','2020-06-15 15:56:34'),(1592236596915,1592236516817,0,82001,1592232544326,1,'Number, -10, Number, 20','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 20','2020-06-15 15:56:36'),(1592236602791,1592236516817,0,82001,1592232544326,1,'double, 2, double, 23','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: 23','2020-06-15 15:56:42'),(1592236604267,1592236516817,0,82001,1592232544326,1,'Number, -10, Number, 24','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 24','2020-06-15 15:56:44'),(1592236607642,1592236516817,0,82001,1592232544326,1,'long, 1, long, 26','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 26','2020-06-15 15:56:47'),(1592236609138,1592236516817,0,82001,1592232544326,1,'double, -10, double, 27','methodArgs/0/type: \"double\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: 27','2020-06-15 15:56:49'),(1592236611321,1592236516817,0,82001,1592232544326,1,'Number, -10, Number, 28','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 28','2020-06-15 15:56:51'),(1592236615311,1592236516817,0,82001,1592232544326,1,'long, -10, long, 30','methodArgs/0/type: \"long\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 30','2020-06-15 15:56:55'),(1592236620361,1592236516817,0,82001,1592232544326,1,'Number, 9.99, Number, 32','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 9.99 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 32','2020-06-15 15:57:00'),(1592236623833,1592236516817,0,82001,1592232544326,1,'long, 2, long, 34','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 34','2020-06-15 15:57:03'),(1592236627517,1592236516817,0,82001,1592232544326,1,'Number, 9.99, Number, 36','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 9.99 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: 36','2020-06-15 15:57:07'),(1592236631345,1592236516817,0,82001,1592232544326,1,'long, 2, long, 38','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: 38','2020-06-15 15:57:11'),(1592236633127,1592236516817,0,82001,1592232544326,1,'double, 2, double, 39','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: 39','2020-06-15 15:57:13'),(1592236688771,0,0,82001,1592232544326,10,'随机配置 2020-06-15 23:58','methodArgs/0/type: ORDER_IN(\'long\', \'double\', \'Number\')  // 顺序取值\nmethodArgs/0/value: RANDOM_IN(1, 2, -10, 9.99, 0, null)  // 随机取值\n\nmethodArgs/1/type: ORDER_IN(\'long\', \'double\', \'Number\')  // 顺序取值\nmethodArgs/1/value: ORDER_INT(-10, 100)  // 顺序整数','2020-06-15 15:58:08'),(1592236698823,1592236688771,0,82001,1592232544326,1,'long, -10, long, -10','methodArgs/0/type: \"long\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: -10','2020-06-15 15:58:18'),(1592236700066,1592236688771,0,82001,1592232544326,1,'double, 0, double, -9','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 0 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -9','2020-06-15 15:58:20'),(1592236701104,1592236688771,0,82001,1592232544326,1,'Number, 1, Number, -8','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: -8','2020-06-15 15:58:21'),(1592236702454,1592236688771,0,82001,1592232544326,1,'long, 9.99, long, -7','methodArgs/0/type: \"long\" \nmethodArgs/0/value: 9.99 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: -7','2020-06-15 15:58:22'),(1592236705390,1592236688771,0,82001,1592232544326,1,'double, 0, double, -6','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 0 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -6','2020-06-15 15:58:25'),(1592236706512,1592236688771,0,82001,1592232544326,1,'Number, 9.99, Number, -5','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 9.99 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: -5','2020-06-15 15:58:26'),(1592236709153,1592236688771,0,82001,1592232544326,1,'long, -10, long, -4','methodArgs/0/type: \"long\" \nmethodArgs/0/value: -10 \nmethodArgs/1/type: \"long\" \nmethodArgs/1/value: -4','2020-06-15 15:58:29'),(1592236711390,1592236688771,0,82001,1592232544326,1,'double, 2, double, -3','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 2 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -3','2020-06-15 15:58:31'),(1592236713133,1592236688771,0,82001,1592232544326,1,'Number, 1, Number, -2','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: -2','2020-06-15 15:58:33'),(1592236731951,1592236516817,0,82001,1592232544326,1,'double, 1, double, -9','methodArgs/0/type: \"double\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"double\" \nmethodArgs/1/value: -9','2020-06-15 15:58:51'),(1592236733731,1592236516817,0,82001,1592232544326,1,'Number, 1, Number, -8','methodArgs/0/type: \"Number\" \nmethodArgs/0/value: 1 \nmethodArgs/1/type: \"Number\" \nmethodArgs/1/value: -8','2020-06-15 15:58:53'),(1594457036085,1592236300946,0,82001,1592232912349,1,'2, -9, 7, true, false, false','methodArgs/0/value: 2 \nmethodArgs/1/value: -9 \nmethodArgs/2/value/id: 7 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-07-11 08:43:56'),(1594457184597,1592236300946,0,82001,1592232912349,1,'5, -8, 72, true, null, null','methodArgs/0/value: 5 \nmethodArgs/1/value: -8 \nmethodArgs/2/value/id: 72 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-07-11 08:46:24'),(1594457295834,1592236063697,0,82001,1592232912349,1,'-10, -10, 83, false, true, true','methodArgs/0/value: -10 \nmethodArgs/1/value: -10 \nmethodArgs/2/value/id: 83 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-07-11 08:48:15'),(1594457297410,1592236063697,0,82001,1592232912349,1,'null, -9, 28, null, false, false','methodArgs/0/value: null \nmethodArgs/1/value: -9 \nmethodArgs/2/value/id: 28 \nmethodArgs/2/value/sort()/callback: null \nmethodArgs/2/value/sort()/return: false \nmethodArgs/2/value/setData(D)/callback: false','2020-07-11 08:48:17'),(1594457298916,1592236063697,0,82001,1592232912349,1,'-10, -8, 52, true, null, null','methodArgs/0/value: -10 \nmethodArgs/1/value: -8 \nmethodArgs/2/value/id: 52 \nmethodArgs/2/value/sort()/callback: true \nmethodArgs/2/value/sort()/return: null \nmethodArgs/2/value/setData(D)/callback: null','2020-07-11 08:48:18'),(1594470112124,1592236300946,0,82001,1592232912349,1,'12, -10, 42, false, true, true','methodArgs/0/value: 12 \nmethodArgs/1/value: -10 \nmethodArgs/2/value/id: 42 \nmethodArgs/2/value/sort()/callback: false \nmethodArgs/2/value/sort()/return: true \nmethodArgs/2/value/setData(D)/callback: true','2020-07-11 12:21:52'),(1595232174907,0,0,82001,1595230510865,1,'order1-5','methodArgs/1/value: ORDER_INT(1,5)','2020-07-20 08:02:54'),(1595232196860,1595232174907,0,82001,1595230510865,1,'1','methodArgs/1/value: 1','2020-07-20 08:03:16'),(1603015545325,0,0,82001,1603015545204,1,'默认配置(上传测试用例时自动生成)','static: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"long\",\"value\":75}], [{\"type\":\"apijson.demo.server.MathUtil$Callback\",\"value\":{\"minusAsId(long,long)\":{},\"currentTime()\":{\"type\":\"long\",\"return\":8},\"sort()\":{\"type\":\"Boolean\",\"return\":true},\"setA(L)\":{},\"setData(D)\":{\"callback\":true},\"getA()\":{\"type\":\"Object\"},\"getB()\":{\"type\":\"Object\"},\"setB(L)\":{},\"getData()\":{\"type\":\"Object\"},\"setId(L)\":{},\"append(L,L)\":{\"type\":\"String\",\"return\":\"Uex\"},\"getId()\":{\"type\":\"Object\"}}}], [{\"type\":\"long\",\"value\":87}], [{\"type\":\"long\",\"value\":75},{\"type\":\"long\",\"value\":87},{\"type\":\"apijson.demo.server.MathUtil$Callback\",\"value\":{\"minusAsId(long,long)\":{},\"currentTime()\":{\"type\":\"long\",\"return\":8},\"sort()\":{\"type\":\"Boolean\",\"return\":true},\"setA(L)\":{},\"setData(D)\":{\"callback\":true},\"getA()\":{\"type\":\"Object\"},\"getB()\":{\"type\":\"Object\"},\"setB(L)\":{},\"getData()\":{\"type\":\"Object\"},\"setId(L)\":{},\"append(L,L)\":{\"type\":\"String\",\"return\":\"Uex\"},\"getId()\":{\"type\":\"Object\"}}}])','2020-10-18 10:05:45'),(1603015723182,0,0,82001,1603015723077,10,'默认配置(上传测试用例时自动生成)','static: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"Number\",\"value\":5.9139310449596305}], [{\"type\":\"Number\",\"value\":17.409419140887884}], [{\"type\":\"Number\",\"value\":5.9139310449596305},{\"type\":\"Number\",\"value\":17.409419140887884}])','2020-10-18 10:08:43'),(1603817773749,0,0,82001,1603817773655,1,'默认配置(上传测试用例时自动生成)','static: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"unitauto.test.TestEnum\",\"value\":\"WOMAN\"}])','2020-10-27 16:56:13'),(1603817803298,0,0,82001,1603817803198,1,'默认配置(上传测试用例时自动生成)','static: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [\"unitauto.test.TestEnum:\"])','2020-10-27 16:56:43'),(1603817836597,0,0,82001,1603817836500,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"String\",\"value\":\"time\"}])','2020-10-27 16:57:16'),(1603817850929,0,0,82001,1603817850838,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"String\",\"value\":\"id\"}])','2020-10-27 16:57:30'),(1603817867454,0,0,82001,1603817867359,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"java.lang.annotation.Annotation\",\"value\":{\"required()\":true}}])','2020-10-27 16:57:47'),(1603817892989,0,0,82001,1603817892889,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"unitauto.test.TestAnnotation\",\"value\":{\"required()\":true}}])','2020-10-27 16:58:12'),(1603817910364,0,0,82001,1603817910196,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [])','2020-10-27 16:58:30'),(1603817929802,0,0,82001,1603817929709,1,'默认配置(上传测试用例时自动生成)','constructor: ORDER_IN(undefined, null, \"\", \"getDefault\")\nmethodArgs: ORDER_IN(undefined, null, [])','2020-10-27 16:58:49'),(1603817963919,0,0,82001,1603817963818,1,'默认配置(上传测试用例时自动生成)','constructor: ORDER_IN(undefined, null, \"\", \"getInstance\")\nclassArgs: ORDER_IN(undefined, null, [], [\"boolean:false\"])\nmethodArgs: ORDER_IN(undefined, null, [], [\"get instance with args\"])','2020-10-27 16:59:23'),(1603817981918,0,0,82001,1603817981819,1,'默认配置(上传测试用例时自动生成)','constructor: ORDER_IN(undefined, null, \"\", \"getDefault\")\nmethodArgs: ORDER_IN(undefined, null, [])','2020-10-27 16:59:41'),(1603820036944,0,0,82001,1603820036845,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"String\",\"value\":\"id\"}])','2020-10-27 17:33:56'),(1603822242693,0,0,82001,1603822242584,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [])\nthis/type: ORDER_IN(undefined, null, \"\", \"unitauto.test.TestSingleton\")\nthis/value/name: ORDER_IN(undefined, null, \"\", \"Test\")','2020-10-27 18:10:42'),(1604152910319,0,0,82001,1604152910192,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"int:3\"])','2020-10-31 14:01:50'),(1628473468019,0,0,82001,1628473467907,1,'默认配置(上传测试用例时自动生成)','mock: ORDER_IN(undefined, null, false, true)\npackage: ORDER_IN(undefined, null, \"\", \"unitauto.test\")\nclass: ORDER_IN(undefined, null, \"\", \"TestUtil\")','2021-08-09 01:44:28'),(1634657525341,1603015723182,0,82001,1603015723077,1,'null, [..2..]','static: null\nmethodArgs: [{\"type\":\"Number\",\"value\":5.9139310449596305},{\"type\":\"Number\",\"value\":17.409419140887884}]','2021-10-19 15:32:05'),(1634657561273,1603015723182,0,82001,1603015723077,1,'true, [..1..]','static: true\nmethodArgs: [{\"type\":\"Number\",\"value\":5.9139310449596305}]','2021-10-19 15:32:41'),(1634657573715,1603015723182,0,82001,1603015723077,1,'false, []','static: false\nmethodArgs: []','2021-10-19 15:32:53'),(1634666028297,0,0,82001,1634666028167,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"List<Long>\",\"value\":[1,2]}])','2021-10-19 17:53:48'),(1634666674838,0,0,82001,1634666674736,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [3])','2021-10-19 18:04:34'),(1634666781106,0,0,82001,1634666781005,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"Long:1\"], [\"Long:2\"], [\"Long:1\",\"Long:2\"])','2021-10-19 18:06:21'),(1634676298966,0,0,82001,1634676298852,1,'默认配置(上传测试用例时自动生成)','reuse: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"List<unitauto.demo.domain.User>\",\"value\":[{\"id\":15,\"name\":\"Tommy\"},{\"id\":12,\"name\":\"Lemon\",\"contactIdList\":[1,3,6]}]}])','2021-10-19 20:44:58'),(1634676562870,0,0,82001,1634676562766,1,'默认配置(上传测试用例时自动生成)','reuse: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"Set<unitauto.demo.domain.User>\",\"value\":[{\"id\":15,\"name\":\"Tommy\"},{\"id\":12,\"name\":\"Lemon\",\"contactIdList\":[1,3,6]}]}])','2021-10-19 20:49:22'),(1634721437110,0,0,82001,1634721436947,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"UnitAuto\"])','2021-10-20 09:17:17'),(1634721834242,0,0,82001,1634721834141,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"UnitAuto\"])','2021-10-20 09:23:54'),(1634721846949,0,0,82001,1634721846828,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [])','2021-10-20 09:24:06'),(1634721932673,0,0,82001,1634721932541,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [])','2021-10-20 09:25:32'),(1634722123602,0,0,82001,1634722123503,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"version\"], [\"int:1\"], [\"version\",\"int:1\"])','2021-10-20 09:28:43'),(1634722143959,0,0,82001,1634722143855,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"name\"], [\"UnitAuto\"], [\"name\",\"UnitAuto\"])','2021-10-20 09:29:03'),(1634722180645,0,0,82001,1634722180539,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"version\"], [\"int:0\"], [\"version\",\"int:0\"])','2021-10-20 09:29:40'),(1634722206568,0,0,82001,1634722206462,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"name\"], [\"String:null\"], [\"name\",\"String:null\"])','2021-10-20 09:30:06'),(1634722983505,0,0,82001,1634722983402,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [\"unitauto.demo\"], [\"int:0\"], [\"unitauto.demo\",\"int:0\"])','2021-10-20 09:43:03'),(1634723013648,0,0,82001,1634723013549,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [])','2021-10-20 09:43:33'),(1634723173939,0,0,82001,1634723173836,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [])','2021-10-20 09:46:13'),(1635934829045,0,0,82001,1634724325010,1,'随机值','methodArgs/0/value: RANDOM_STR()\nmethodArgs/1/value: ORDER_IN(true,false)','2021-11-03 10:20:29'),(1640055489528,0,0,82001,1640053338292,1,'随机配置 2021-12-21 10:58','','2021-12-21 02:58:09'),(1640055509837,0,0,82001,1640053338292,1,'随机配置 2021-12-21 10:58','','2021-12-21 02:58:29'),(1640055637840,1640055509837,0,82001,1640053338292,1,'Temp 0','','2021-12-21 03:00:37'),(1640055990806,1640055509837,0,82001,1640053338292,1,'Temp 1','','2021-12-21 03:06:30'),(1640326734971,0,0,82001,1640060431437,1,'随机配置 2021-12-24 14:18','','2021-12-24 06:18:54'),(1640326751907,0,0,82001,1640060431437,1,'随机配置 2021-12-24 14:19','','2021-12-24 06:19:11'),(1640326760963,0,0,82001,1640060431437,1,'随机配置 2021-12-24 14:19','','2021-12-24 06:19:20'),(1640326927716,0,0,82001,1640060431454,1,'随机配置 2021-12-24 14:22','','2021-12-24 06:22:07'),(1645581382929,0,0,82001,1645522808022,1,'随机配置 2022-02-23 09:56','','2022-02-23 01:56:22'),(1649172731314,0,0,82001,1649136957131,1,'随机配置 2022-04-05 23:32','','2022-04-05 15:32:11'),(1649172748354,0,0,82001,1649136957131,1,'test','','2022-04-05 15:32:28'),(1649173009624,1649172748354,0,82001,1649136957131,1,'Temp 0','','2022-04-05 15:36:49'),(1649173010689,1649172748354,0,82001,1649136957131,1,'Temp 1','','2022-04-05 15:36:50'),(1649173011593,1649172748354,0,82001,1649136957131,1,'Temp 2','','2022-04-05 15:36:51'),(1649173012128,1649172748354,0,82001,1649136957131,1,'Temp 3','','2022-04-05 15:36:52'),(1649173013148,1649172748354,0,82001,1649136957131,1,'Temp 4','','2022-04-05 15:36:53'),(1649173013514,1649172748354,0,82001,1649136957131,1,'Temp 5','','2022-04-05 15:36:53'),(1649173014413,1649172748354,0,82001,1649136957131,1,'Temp 6','','2022-04-05 15:36:54'),(1649173014993,1649172748354,0,82001,1649136957131,1,'Temp 7','','2022-04-05 15:36:54'),(1649173250670,0,0,82001,1649136957131,1,'Temp1','methodArgs/0/value: RANDOM_IN(1,5)','2022-04-05 15:40:50'),(1649173670331,0,0,82001,1649136957131,1,'temp2','methodArgs/0/value: RANDOM_INT(1,10)\nmethodArgs/1/value: RANDOM_INT(1,10)','2022-04-05 15:47:50'),(1649173723791,0,0,82001,1649136957131,1,'随机配置 2022-04-05 23:48','methodArgs/0/value: 4\nmethodArgs/1/value: 10','2022-04-05 15:48:43'),(1649174035554,0,0,82001,1649136957131,1,'随机配置 2022-04-05 23:53','methodArgs/0/value: RANDOM_INT(1,10)\nmethodArgs/1/value: RANDOM_INT(1,10)','2022-04-05 15:53:55'),(1649174072393,1649173670331,0,82001,1649136957131,1,'2, 4','methodArgs/0/value: 2\nmethodArgs/1/value: 4','2022-04-05 15:54:32'),(1649174073248,1649173670331,0,82001,1649136957131,1,'8, 6','methodArgs/0/value: 8\nmethodArgs/1/value: 6','2022-04-05 15:54:33'),(1649174073645,1649173670331,0,82001,1649136957131,1,'6, 9','methodArgs/0/value: 6\nmethodArgs/1/value: 9','2022-04-05 15:54:33'),(1649174074384,1649173670331,0,82001,1649136957131,1,'1, 8','methodArgs/0/value: 1\nmethodArgs/1/value: 8','2022-04-05 15:54:34'),(1649174075037,1649173670331,0,82001,1649136957131,1,'5, 8','methodArgs/0/value: 5\nmethodArgs/1/value: 8','2022-04-05 15:54:35'),(1649174076414,1649173670331,0,82001,1649136957131,1,'6, 7','methodArgs/0/value: 6\nmethodArgs/1/value: 7','2022-04-05 15:54:36'),(1649174077629,1649173670331,0,82001,1649136957131,1,'3, 3','methodArgs/0/value: 3\nmethodArgs/1/value: 3','2022-04-05 15:54:37'),(1649174078102,1649173670331,0,82001,1649136957131,1,'8, 6','methodArgs/0/value: 8\nmethodArgs/1/value: 6','2022-04-05 15:54:38'),(1649174078649,1649173670331,0,82001,1649136957131,1,'3, 5','methodArgs/0/value: 3\nmethodArgs/1/value: 5','2022-04-05 15:54:38'),(1649174080134,1649173670331,0,82001,1649136957131,1,'5, 10','methodArgs/0/value: 5\nmethodArgs/1/value: 10','2022-04-05 15:54:40'),(1649174099469,1649173670331,0,82001,1649136957131,1,'3, 2','methodArgs/0/value: 3\nmethodArgs/1/value: 2','2022-04-05 15:54:59'),(1649174105749,1649173670331,0,82001,1649136957131,1,'2, 2','methodArgs/0/value: 2\nmethodArgs/1/value: 2','2022-04-05 15:55:05'),(1649174105855,1649173670331,0,82001,1649136957131,1,'7, 6','methodArgs/0/value: 7\nmethodArgs/1/value: 6','2022-04-05 15:55:05'),(1649174106128,1649173670331,0,82001,1649136957131,1,'4, 7','methodArgs/0/value: 4\nmethodArgs/1/value: 7','2022-04-05 15:55:06'),(1649174106888,1649173670331,0,82001,1649136957131,1,'6, 5','methodArgs/0/value: 6\nmethodArgs/1/value: 5','2022-04-05 15:55:06'),(1649174107134,1649173670331,0,82001,1649136957131,1,'2, 8','methodArgs/0/value: 2\nmethodArgs/1/value: 8','2022-04-05 15:55:07'),(1649174108169,1649173670331,0,82001,1649136957131,1,'2, 8','methodArgs/0/value: 2\nmethodArgs/1/value: 8','2022-04-05 15:55:08'),(1649174108469,1649173670331,0,82001,1649136957131,1,'4, 4','methodArgs/0/value: 4\nmethodArgs/1/value: 4','2022-04-05 15:55:08'),(1649174108613,1649173670331,0,82001,1649136957131,1,'3, 6','methodArgs/0/value: 3\nmethodArgs/1/value: 6','2022-04-05 15:55:08'),(1649174110783,1649173670331,0,82001,1649136957131,1,'7, 6','methodArgs/0/value: 7\nmethodArgs/1/value: 6','2022-04-05 15:55:10'),(1649174153266,0,0,82001,1649136957131,1,'随机配置 2022-04-05 23:55','methodArgs/0/value: 3\nmethodArgs/1/value: 2','2022-04-05 15:55:53'),(1649185881897,0,0,82001,1649185881700,1,'默认配置(上传测试用例时自动生成)','constructor: ORDER_IN(undefined, null, \"\", \"getInstance\")\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"Map<String, String>\",\"value\":{\"order_id\":\"123\",\"price\":\"12.5\"}}])\nresponse(Map<String, java.lang.Object>)/callback: ORDER_IN(undefined, null, false, true)','2022-04-05 19:11:21'),(1649207562414,0,0,82001,1649136956766,10,'day01','methodArgs/0/value: RANDOM_NUM(1,10)\nmethodArgs/1/value: RANDOM_NUM(1,10)','2022-04-06 01:12:42'),(1649207607105,1649207562414,0,82001,1649136956766,1,'3.26, 3.76','methodArgs/0/value: 3.26\nmethodArgs/1/value: 3.76','2022-04-06 01:13:27'),(1649207607609,1649207562414,0,82001,1649136956766,1,'7.72, 1.79','methodArgs/0/value: 7.72\nmethodArgs/1/value: 1.79','2022-04-06 01:13:27'),(1649207608632,1649207562414,0,82001,1649136956766,1,'4.33, 5.44','methodArgs/0/value: 4.33\nmethodArgs/1/value: 5.44','2022-04-06 01:13:28'),(1649207609040,1649207562414,0,82001,1649136956766,1,'2.31, 6.97','methodArgs/0/value: 2.31\nmethodArgs/1/value: 6.97','2022-04-06 01:13:29'),(1649207609776,1649207562414,0,82001,1649136956766,1,'3.31, 5.31','methodArgs/0/value: 3.31\nmethodArgs/1/value: 5.31','2022-04-06 01:13:29'),(1649207610184,1649207562414,0,82001,1649136956766,1,'1.04, 4.01','methodArgs/0/value: 1.04\nmethodArgs/1/value: 4.01','2022-04-06 01:13:30'),(1649207611369,1649207562414,0,82001,1649136956766,1,'7.37, 3.04','methodArgs/0/value: 7.37\nmethodArgs/1/value: 3.04','2022-04-06 01:13:31'),(1649207611761,1649207562414,0,82001,1649136956766,1,'8.94, 5.24','methodArgs/0/value: 8.94\nmethodArgs/1/value: 5.24','2022-04-06 01:13:31'),(1649207612161,1649207562414,0,82001,1649136956766,1,'9.72, 3.27','methodArgs/0/value: 9.72\nmethodArgs/1/value: 3.27','2022-04-06 01:13:32'),(1649207638216,1649207562414,0,82001,1649136956766,1,'3.76, 2.69','methodArgs/0/value: 3.76\nmethodArgs/1/value: 2.69','2022-04-06 01:13:58'),(1649749770903,0,0,82001,1649749770818,1,'默认配置(上传测试用例时自动生成)','constructor: ORDER_IN(undefined, null, \"\", \"getInstance\")\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"Map<String, String>\",\"value\":{\"host\":\"http://apijson.cn\",\"port\":\"8080\"}}], [{\"global\":true,\"type\":\"unitauto.test.TestSDK$Callback\",\"value\":{\"response(Map<String, java.lang.Object>)\":{\"callback\":true}}}], [{\"type\":\"Map<String, String>\",\"value\":{\"host\":\"http://apijson.cn\",\"port\":\"8080\"}},{\"global\":true,\"type\":\"unitauto.test.TestSDK$Callback\",\"value\":{\"response(Map<String, java.lang.Object>)\":{\"callback\":true}}}])','2022-04-12 07:49:30'),(1652249559702,0,0,82001,1649136956654,1,'随机配置 2022-05-11 14:12','','2022-05-11 06:12:39'),(1655361876811,0,0,82001,1655348708986,1,'随机配置 2022-06-16 14:44',' \n\n','2022-06-16 06:44:36'),(1655373809848,0,0,82001,1655373519467,1,'1-100随机配置','methodArgs/0/value: RANDOM_IN(1,100)  // 随机取值','2022-06-16 10:03:29'),(1655374065054,0,0,82001,1655373519467,1,'RANDOM_INT(1,100)','methodArgs/0/value: RANDOM_INT(1,100)  // 随机取值','2022-06-16 10:07:45'),(1655894481958,0,0,82001,1655894175730,1,'Test1','methodArgs/ 0/value : RANDOM_IN(2,10)','2022-06-22 10:41:21'),(1655894694515,1655894481958,0,82001,1655894175730,1,'10','methodArgs/ 0/value : 10','2022-06-22 10:44:54'),(1655897796988,0,0,82001,1655894175708,1,'111','','2022-06-22 11:36:36'),(1655952718955,0,0,82001,1655951898811,1,'随机测试1051','methodArgs/0/value: RANDOM_IN(2,3,5,710)\nmethodArgs/1/value: RANDOM_IN(2,3,5,710)','2022-06-23 02:51:58'),(1655952738128,1655952718955,0,82001,1655951898811,1,'3, 3','methodArgs/0/value: 3\nmethodArgs/1/value: 3','2022-06-23 02:52:18'),(1655952742939,1655952718955,0,82001,1655951898811,1,'710, 710','methodArgs/0/value: 710\nmethodArgs/1/value: 710','2022-06-23 02:52:22'),(1655952753395,1655952718955,0,82001,1655951898811,1,'2, 3','methodArgs/0/value: 2\nmethodArgs/1/value: 3','2022-06-23 02:52:33'),(1655952756378,1655952718955,0,82001,1655951898811,1,'3, 3','methodArgs/0/value: 3\nmethodArgs/1/value: 3','2022-06-23 02:52:36'),(1655952822014,0,0,82001,1655951898811,1,'随机配置 2022-06-23 10:53','methodArgs/0/value: 722\nmethodArgs/1/value: 710','2022-06-23 02:53:42'),(1655952908851,0,0,82001,1655951898811,1,'测试配置存储','methodArgs/0/value: RANDOM_IN(2,3,5,710)\nmethodArgs/1/value: RANDOM_IN(2,3,5,710)','2022-06-23 02:55:08'),(1655953247789,0,0,82001,1655951898757,1,' RANDOM_INT(30,80)','methodArgs/0/value: RANDOM_INT(1,10)\nmethodArgs/1/value: RANDOM_INT(30,80)','2022-06-23 03:00:47'),(1655963692441,0,0,82001,1655953038771,1,'测试1','methodArgs/0/value: 222\nmethodArgs/1/value: 22','2022-06-23 05:54:52'),(1655964007102,0,0,82001,1655953038771,1,'测试 10','methodArgs/0/value: RANDOM_INT(1,10)\nmethodArgs/1/value: RANDOM_INT(30,80)','2022-06-23 06:00:07'),(1655964065582,1655964007102,0,82001,1655953038771,1,'9, 63','methodArgs/0/value: 9\nmethodArgs/1/value: 63','2022-06-23 06:01:05'),(1655964071451,1655964007102,0,82001,1655953038771,1,'3, 66','methodArgs/0/value: 3\nmethodArgs/1/value: 66','2022-06-23 06:01:11'),(1655964080657,1655964007102,0,82001,1655953038771,1,'8, 38','methodArgs/0/value: 8\nmethodArgs/1/value: 38','2022-06-23 06:01:20'),(1655964081485,1655964007102,0,82001,1655953038771,1,'2, 42','methodArgs/0/value: 2\nmethodArgs/1/value: 42','2022-06-23 06:01:21'),(1655964082050,1655964007102,0,82001,1655953038771,1,'7, 60','methodArgs/0/value: 7\nmethodArgs/1/value: 60','2022-06-23 06:01:22'),(1655964082580,1655964007102,0,82001,1655953038771,1,'3, 35','methodArgs/0/value: 3\nmethodArgs/1/value: 35','2022-06-23 06:01:22'),(1655964083763,1655964007102,0,82001,1655953038771,1,'6, 63','methodArgs/0/value: 6\nmethodArgs/1/value: 63','2022-06-23 06:01:23'),(1655964084192,1655964007102,0,82001,1655953038771,1,'4, 35','methodArgs/0/value: 4\nmethodArgs/1/value: 35','2022-06-23 06:01:24'),(1655964084585,1655964007102,0,82001,1655953038771,1,'6, 50','methodArgs/0/value: 6\nmethodArgs/1/value: 50','2022-06-23 06:01:24'),(1655964085091,1655964007102,0,82001,1655953038771,1,'8, 77','methodArgs/0/value: 8\nmethodArgs/1/value: 77','2022-06-23 06:01:25'),(1655964113872,0,0,82001,1655953038771,1,'测试3','methodArgs/0/value: RANDOM_INT(1,10)\nmethodArgs/1/value: RANDOM_INT(30,80)','2022-06-23 06:01:53'),(1655978553422,0,0,82001,1655953038647,1,'ceshi','\nmethodArgs/0/value: RANDOM_INT(1,10)\nmethodArgs/1/value: RANDOM_INT(30,80)','2022-06-23 10:02:33'),(1655978562759,1655978553422,0,82001,1655953038647,1,'7, 54','methodArgs/0/value: 7\nmethodArgs/1/value: 54','2022-06-23 10:02:42'),(1655978567110,1655978553422,0,82001,1655953038647,1,'9, 39','methodArgs/0/value: 9\nmethodArgs/1/value: 39','2022-06-23 10:02:47'),(1655978571472,1655978553422,0,82001,1655953038647,1,'8, 57','methodArgs/0/value: 8\nmethodArgs/1/value: 57','2022-06-23 10:02:51'),(1655978574022,1655978553422,0,82001,1655953038647,1,'4, 63','methodArgs/0/value: 4\nmethodArgs/1/value: 63','2022-06-23 10:02:54'),(1655978574488,1655978553422,0,82001,1655953038647,1,'4, 77','methodArgs/0/value: 4\nmethodArgs/1/value: 77','2022-06-23 10:02:54'),(1657016943691,1603015723182,0,82001,1603015723077,1,'null, [..2..]','static: null\nmethodArgs: [{\"type\":\"Number\",\"value\":5.9139310449596305},{\"type\":\"Number\",\"value\":17.409419140887884}]','2022-07-05 10:29:03'),(1657016954782,1603015723182,0,82001,1603015723077,1,'null, [..2..]','static: null\nmethodArgs: [{\"type\":\"Number\",\"value\":5.9139310449596305},{\"type\":\"Number\",\"value\":17.409419140887884}]','2022-07-05 10:29:14'),(1657030369449,0,0,82001,1560244940013,1,'随机配置 2022-07-05 22:12','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-07-05 14:12:49'),(1657035880034,0,0,82001,1655953038154,30,'ORDER_INT(1,5), ORDER_INT(1,6)','methodArgs/0/value: ORDER_INT(1, 5)\nmethodArgs/1/value: ORDER_INT(1, 6)','2022-07-05 15:44:40'),(1657035890303,1657035880034,0,82001,1655953038154,1,'1, 1','methodArgs/0/value: 1\nmethodArgs/1/value: 1','2022-07-05 15:44:50'),(1657035890833,1657035880034,0,82001,1655953038154,1,'2, 2','methodArgs/0/value: 2\nmethodArgs/1/value: 2','2022-07-05 15:44:50'),(1657035891174,1657035880034,0,82001,1655953038154,1,'3, 3','methodArgs/0/value: 3\nmethodArgs/1/value: 3','2022-07-05 15:44:51'),(1657035892243,1657035880034,0,82001,1655953038154,1,'5, 5','methodArgs/0/value: 5\nmethodArgs/1/value: 5','2022-07-05 15:44:52'),(1657035892536,1657035880034,0,82001,1655953038154,1,'4, 4','methodArgs/0/value: 4\nmethodArgs/1/value: 4','2022-07-05 15:44:52'),(1657035892965,1657035880034,0,82001,1655953038154,1,'1, 6','methodArgs/0/value: 1\nmethodArgs/1/value: 6','2022-07-05 15:44:52'),(1657035893896,1657035880034,0,82001,1655953038154,1,'3, 2','methodArgs/0/value: 3\nmethodArgs/1/value: 2','2022-07-05 15:44:53'),(1657035894248,1657035880034,0,82001,1655953038154,1,'2, 1','methodArgs/0/value: 2\nmethodArgs/1/value: 1','2022-07-05 15:44:54'),(1657035895468,1657035880034,0,82001,1655953038154,1,'5, 4','methodArgs/0/value: 5\nmethodArgs/1/value: 4','2022-07-05 15:44:55'),(1657035895821,1657035880034,0,82001,1655953038154,1,'4, 3','methodArgs/0/value: 4\nmethodArgs/1/value: 3','2022-07-05 15:44:55'),(1657035896261,1657035880034,0,82001,1655953038154,1,'1, 5','methodArgs/0/value: 1\nmethodArgs/1/value: 5','2022-07-05 15:44:56'),(1657035896581,1657035880034,0,82001,1655953038154,1,'2, 6','methodArgs/0/value: 2\nmethodArgs/1/value: 6','2022-07-05 15:44:56'),(1657035897437,1657035880034,0,82001,1655953038154,1,'1, 4','methodArgs/0/value: 1\nmethodArgs/1/value: 4','2022-07-05 15:44:57'),(1657035897739,1657035880034,0,82001,1655953038154,1,'5, 3','methodArgs/0/value: 5\nmethodArgs/1/value: 3','2022-07-05 15:44:57'),(1657035898154,1657035880034,0,82001,1655953038154,1,'4, 2','methodArgs/0/value: 4\nmethodArgs/1/value: 2','2022-07-05 15:44:58'),(1657035898525,1657035880034,0,82001,1655953038154,1,'3, 1','methodArgs/0/value: 3\nmethodArgs/1/value: 1','2022-07-05 15:44:58'),(1657035899553,1657035880034,0,82001,1655953038154,1,'2, 5','methodArgs/0/value: 2\nmethodArgs/1/value: 5','2022-07-05 15:44:59'),(1657035899972,1657035880034,0,82001,1655953038154,1,'3, 6','methodArgs/0/value: 3\nmethodArgs/1/value: 6','2022-07-05 15:44:59'),(1657035900406,1657035880034,0,82001,1655953038154,1,'4, 1','methodArgs/0/value: 4\nmethodArgs/1/value: 1','2022-07-05 15:45:00'),(1657035900876,1657035880034,0,82001,1655953038154,1,'5, 2','methodArgs/0/value: 5\nmethodArgs/1/value: 2','2022-07-05 15:45:00'),(1657035901227,1657035880034,0,82001,1655953038154,1,'1, 3','methodArgs/0/value: 1\nmethodArgs/1/value: 3','2022-07-05 15:45:01'),(1657035902570,1657035880034,0,82001,1655953038154,1,'5, 1','methodArgs/0/value: 5\nmethodArgs/1/value: 1','2022-07-05 15:45:02'),(1657035902904,1657035880034,0,82001,1655953038154,1,'4, 6','methodArgs/0/value: 4\nmethodArgs/1/value: 6','2022-07-05 15:45:02'),(1657035903229,1657035880034,0,82001,1655953038154,1,'3, 5','methodArgs/0/value: 3\nmethodArgs/1/value: 5','2022-07-05 15:45:03'),(1657035903631,1657035880034,0,82001,1655953038154,1,'2, 4','methodArgs/0/value: 2\nmethodArgs/1/value: 4','2022-07-05 15:45:03'),(1657035904586,1657035880034,0,82001,1655953038154,1,'2, 3','methodArgs/0/value: 2\nmethodArgs/1/value: 3','2022-07-05 15:45:04'),(1657035905038,1657035880034,0,82001,1655953038154,1,'1, 2','methodArgs/0/value: 1\nmethodArgs/1/value: 2','2022-07-05 15:45:05'),(1657035905459,1657035880034,0,82001,1655953038154,1,'3, 4','methodArgs/0/value: 3\nmethodArgs/1/value: 4','2022-07-05 15:45:05'),(1657035905795,1657035880034,0,82001,1655953038154,1,'4, 5','methodArgs/0/value: 4\nmethodArgs/1/value: 5','2022-07-05 15:45:05'),(1657035906048,1657035880034,0,82001,1655953038154,1,'5, 6','methodArgs/0/value: 5\nmethodArgs/1/value: 6','2022-07-05 15:45:06'),(1657044649435,0,0,82001,1657044649283,1,'默认配置','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-07-05 18:10:49'),(1657045372256,0,0,82001,1657045372046,3,'id: ORDER_IN(undefined, null, 82001)','User/id: ORDER_IN(undefined, null, 82001)\n  // 可替代上面的 User/id: RANDOM_INT(1, 820010)','2022-07-05 18:22:52'),(1657117214268,0,0,82001,1657045372046,3,'随机配置 2022-07-06 22:20','User/id: ORDER_IN(undefined, null, 82001)\n  // 可替代上面的 User/id: RANDOM_INT(1, 820010)','2022-07-06 14:20:14'),(1657532085455,0,0,82001,1648471968021,50,'RANDOM_INT(1, 10),RANDOM_INT(10, 20)','methodArgs/0/value: RANDOM_INT(1, 10)\nmethodArgs/1/value: RANDOM_INT(10, 20)\n','2022-07-11 09:34:45'),(1657532109742,1657532085455,0,82001,1648471968021,1,'7, 19','methodArgs/0/value: 7\nmethodArgs/1/value: 19','2022-07-11 09:35:09'),(1657532114309,1657532085455,0,82001,1648471968021,1,'3, 18','methodArgs/0/value: 3\nmethodArgs/1/value: 18','2022-07-11 09:35:14'),(1657532181079,1657532085455,0,82001,1648471968021,1,'8, 11','methodArgs/0/value: 8\nmethodArgs/1/value: 11','2022-07-11 09:36:21'),(1657537630784,1657532085455,0,82001,1648471968021,1,'7, 12','methodArgs/0/value: 7\nmethodArgs/1/value: 12','2022-07-11 11:07:10'),(1657537635750,1657532085455,0,82001,1648471968021,1,'8, 18','methodArgs/0/value: 8\nmethodArgs/1/value: 18','2022-07-11 11:07:15'),(1657537661169,1657532085455,0,82001,1648471968021,1,'4, 17','methodArgs/0/value: 4\nmethodArgs/1/value: 17','2022-07-11 11:07:41'),(1657537741147,1657532085455,0,82001,1648471968021,1,'3, 11','methodArgs/0/value: 3\nmethodArgs/1/value: 11','2022-07-11 11:09:01'),(1657538348528,0,0,82001,1655951679722,1,'随机配置 2022-07-11 19:19','methodArgs/0/value: ({name: \"youbingqi\", id: 100, sex: 1})','2022-07-11 11:19:08'),(1657543001646,0,0,82001,1655953038160,1,'RANDOM_INT(-100, 100),RANDOM_INT(10, 20)','methodArgs/0/value: RANDOM_INT(-100, 100)\nmethodArgs/1/value: RANDOM_INT(10, 20)','2022-07-11 12:36:41'),(1657543129292,1657543001646,0,82001,1655953038160,1,'-90, 14','methodArgs/0/value: -90\nmethodArgs/1/value: 14','2022-07-11 12:38:49'),(1657543133676,1657543001646,0,82001,1655953038160,1,'40, 19','methodArgs/0/value: 40\nmethodArgs/1/value: 19','2022-07-11 12:38:53'),(1657543136560,1657543001646,0,82001,1655953038160,1,'-9, 14','methodArgs/0/value: -9\nmethodArgs/1/value: 14','2022-07-11 12:38:56'),(1657543151573,1657543001646,0,82001,1655953038160,1,'91, 19','methodArgs/0/value: 91\nmethodArgs/1/value: 19','2022-07-11 12:39:11'),(1657543180184,1657543001646,0,82001,1655953038160,1,'-88, 14','methodArgs/0/value: -88\nmethodArgs/1/value: 14','2022-07-11 12:39:40'),(1657543208387,1657543001646,0,82001,1655953038160,1,'30, 17','methodArgs/0/value: 30\nmethodArgs/1/value: 17','2022-07-11 12:40:08'),(1657543260646,1657543001646,0,82001,1655953038160,1,'-46, 11','methodArgs/0/value: -46\nmethodArgs/1/value: 11','2022-07-11 12:41:00'),(1657543657474,1657543001646,0,82001,1655953038160,1,'-91, 11','methodArgs/0/value: -91\nmethodArgs/1/value: 11','2022-07-11 12:47:37'),(1657543658473,1657543001646,0,82001,1655953038160,1,'-38, 16','methodArgs/0/value: -38\nmethodArgs/1/value: 16','2022-07-11 12:47:38'),(1657543660140,1657543001646,0,82001,1655953038160,1,'-12, 12','methodArgs/0/value: -12\nmethodArgs/1/value: 12','2022-07-11 12:47:40'),(1657544200357,1657543001646,0,82001,1655953038160,1,'2, 15','methodArgs/0/value: 2\nmethodArgs/1/value: 15','2022-07-11 12:56:40'),(1657544200790,1657543001646,0,82001,1655953038160,1,'-6, 13','methodArgs/0/value: -6\nmethodArgs/1/value: 13','2022-07-11 12:56:40'),(1657544201364,1657543001646,0,82001,1655953038160,1,'99, 15','methodArgs/0/value: 99\nmethodArgs/1/value: 15','2022-07-11 12:56:41'),(1657562189779,0,0,88888,1657562188877,1,'默认配置','Moment[].page: ORDER_INT(0, 10)\nMoment[].count: ORDER_IN(5, 10, 15, 20)\nformat: ORDER_IN(null, false, true, undefined)','2022-07-11 17:56:32'),(1657679394636,0,0,82001,1657679394533,1,'默认配置(上传测试用例时自动生成)','methodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"Integer\",\"value\":7}])','2022-07-13 02:29:54'),(1657811332723,0,0,88888,1657811332517,1,'默认配置','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-07-14 15:08:52'),(1658115531381,0,0,82001,1658115531197,1,'默认配置(上传测试用例时自动生成)','[]/Moment/content?: ORDER_IN(undefined, null, \"\", \"^[0-9]+$\")','2022-07-18 03:38:51'),(1658824126105,0,0,82001,1560244940013,10,'随机配置 2022-07-26 16:28','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-07-26 08:28:46'),(1658910337300,1658824126105,0,82001,1560244940013,1,'82008, 10, 4, false','User/id: 82008\n[]/count: 10\n[]/page: 4\n@explain: false','2022-07-27 08:25:37'),(1658910340957,1658824126105,0,82001,1560244940013,1,'82009, 5, 1, false','User/id: 82009\n[]/count: 5\n[]/page: 1\n@explain: false','2022-07-27 08:25:40'),(1660379943251,0,0,82001,1560244940013,1,'xxx','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-08-13 08:39:03'),(1660557762191,0,0,82001,1560244940013,1,'随机配置 2022-08-15 18:02','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-08-15 10:02:42'),(1660718942085,0,0,82001,1546414192830,1,'随机配置 2022-08-17 14:48','','2022-08-17 06:49:02'),(1660719277345,0,0,82001,1660550933107,1,'随机配置 2022-08-17 14:54','','2022-08-17 06:54:37'),(1661150329718,0,0,82001,1659601202134,1,'随机配置 2022-08-22 14:38','','2022-08-22 06:38:49'),(1662114151774,0,0,1662112443331,1662114150688,1,'默认配置(上传测试用例时自动生成)','User/id: ORDER_IN(undefined, null, 82001)\n  // 可替代上面的 User/id: RANDOM_INT(1, 820010)','2022-09-02 10:22:31'),(1662568938554,0,0,82001,1662568938435,10,'默认配置','searchKey: \'%a%\'  // 固定常量值\nuserId: RANDOM_IN(82001, 82002, 82003)  // 随机选项取值\nlimit: ORDER_IN(1, 3, 5, 10)  // 顺序选项取值\noffset: RANDOM_INT(0, 5)  // 随机范围取值\n  // 从数据库随机取值  userId: RANDOM_DB(\'Comment\', \'userId\')\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-09-07 16:42:18'),(1662568964238,1662568938554,0,82001,1662568938435,1,'%a%, 82003, 3, 5','searchKey: \"%a%\"\nuserId: 82003\nlimit: 3\noffset: 5','2022-09-07 16:42:44'),(1662568964603,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 1, 4','searchKey: \"%a%\"\nuserId: 82002\nlimit: 1\noffset: 4','2022-09-07 16:42:44'),(1662568964909,1662568938554,0,82001,1662568938435,1,'%a%, 82003, 5, 2','searchKey: \"%a%\"\nuserId: 82003\nlimit: 5\noffset: 2','2022-09-07 16:42:44'),(1662568966295,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 1, 4','searchKey: \"%a%\"\nuserId: 82002\nlimit: 1\noffset: 4','2022-09-07 16:42:46'),(1662568966730,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 10, 5','searchKey: \"%a%\"\nuserId: 82002\nlimit: 10\noffset: 5','2022-09-07 16:42:46'),(1662568967663,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 3, 3','searchKey: \"%a%\"\nuserId: 82002\nlimit: 3\noffset: 3','2022-09-07 16:42:47'),(1662568967916,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 5, 2','searchKey: \"%a%\"\nuserId: 82002\nlimit: 5\noffset: 2','2022-09-07 16:42:47'),(1662568968142,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 10, 5','searchKey: \"%a%\"\nuserId: 82002\nlimit: 10\noffset: 5','2022-09-07 16:42:48'),(1662568969043,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 3, 4','searchKey: \"%a%\"\nuserId: 82002\nlimit: 3\noffset: 4','2022-09-07 16:42:49'),(1662568969328,1662568938554,0,82001,1662568938435,1,'%a%, 82002, 1, 0','searchKey: \"%a%\"\nuserId: 82002\nlimit: 1\noffset: 0','2022-09-07 16:42:49'),(1662569422158,0,0,82001,1662569033547,30,'ORDER_IN, RANDOM_INT','key: ORDER_IN(\'s\', \'q\', \'l\')  // 顺序选项取值\nlimit: RANDOM_INT(1, 10)  // 随机范围取值','2022-09-07 16:50:22'),(1662569443041,1662569422158,0,82001,1662569033547,1,'s, 2','key: \"s\"\nlimit: 2','2022-09-07 16:50:43'),(1662569444062,1662569422158,0,82001,1662569033547,1,'q, 6','key: \"q\"\nlimit: 6','2022-09-07 16:50:44'),(1662569445565,1662569422158,0,82001,1662569033547,1,'l, 1','key: \"l\"\nlimit: 1','2022-09-07 16:50:45'),(1662569447021,1662569422158,0,82001,1662569033547,1,'q, 8','key: \"q\"\nlimit: 8','2022-09-07 16:50:47'),(1662569447529,1662569422158,0,82001,1662569033547,1,'s, 10','key: \"s\"\nlimit: 10','2022-09-07 16:50:47'),(1662569448710,1662569422158,0,82001,1662569033547,1,'q, 7','key: \"q\"\nlimit: 7','2022-09-07 16:50:48'),(1662569449008,1662569422158,0,82001,1662569033547,1,'s, 10','key: \"s\"\nlimit: 10','2022-09-07 16:50:49'),(1662569449431,1662569422158,0,82001,1662569033547,1,'l, 2','key: \"l\"\nlimit: 2','2022-09-07 16:50:49'),(1662569450573,1662569422158,0,82001,1662569033547,1,'s, 6','key: \"s\"\nlimit: 6','2022-09-07 16:50:50'),(1662569450856,1662569422158,0,82001,1662569033547,1,'l, 3','key: \"l\"\nlimit: 3','2022-09-07 16:50:50'),(1662569451661,1662569422158,0,82001,1662569033547,1,'l, 3','key: \"l\"\nlimit: 3','2022-09-07 16:50:51'),(1662569451962,1662569422158,0,82001,1662569033547,1,'q, 3','key: \"q\"\nlimit: 3','2022-09-07 16:50:51'),(1662569452915,1662569422158,0,82001,1662569033547,1,'l, 7','key: \"l\"\nlimit: 7','2022-09-07 16:50:52'),(1662569453158,1662569422158,0,82001,1662569033547,1,'q, 3','key: \"q\"\nlimit: 3','2022-09-07 16:50:53'),(1662569453524,1662569422158,0,82001,1662569033547,1,'s, 2','key: \"s\"\nlimit: 2','2022-09-07 16:50:53'),(1662569453898,1662569422158,0,82001,1662569033547,1,'l, 4','key: \"l\"\nlimit: 4','2022-09-07 16:50:53'),(1662569458240,1662569422158,0,82001,1662569033547,1,'l, 1','key: \"l\"\nlimit: 1','2022-09-07 16:50:58'),(1662569464926,1662569422158,0,82001,1662569033547,1,'q, 8','key: \"q\"\nlimit: 8','2022-09-07 16:51:04'),(1662569465979,1662569422158,0,82001,1662569033547,1,'s, 3','key: \"s\"\nlimit: 3','2022-09-07 16:51:05'),(1662569467051,1662569422158,0,82001,1662569033547,1,'l, 6','key: \"l\"\nlimit: 6','2022-09-07 16:51:07'),(1662569467511,1662569422158,0,82001,1662569033547,1,'q, 3','key: \"q\"\nlimit: 3','2022-09-07 16:51:07'),(1662569477799,1662569422158,0,82001,1662569033547,1,'l, 8','key: \"l\"\nlimit: 8','2022-09-07 16:51:17'),(1662569776431,1662569422158,0,82001,1662569033547,1,'s, 6','key: \"s\"\nlimit: 6','2022-09-07 16:56:16'),(1662569791332,1662569422158,0,82001,1662569033547,1,'s, 9','key: \"s\"\nlimit: 9','2022-09-07 16:56:31'),(1662569791645,1662569422158,0,82001,1662569033547,1,'l, 5','key: \"l\"\nlimit: 5','2022-09-07 16:56:31'),(1662569792662,1662569422158,0,82001,1662569033547,1,'s, 8','key: \"s\"\nlimit: 8','2022-09-07 16:56:32'),(1662569792927,1662569422158,0,82001,1662569033547,1,'q, 8','key: \"q\"\nlimit: 8','2022-09-07 16:56:32'),(1662603588008,0,0,82001,1662603529187,24,'随机配置 2022-09-08 10:19','searchKey1: \'an\'  // 固定常量值\nsearchKey2: \'an\'  // 固定常量值\nsearchKey3: \'an\'  // 固定常量值\nlimit: ORDER_IN(1, 3, 5, 10)  // 顺序选项取值\noffset: RANDOM_INT(0, 5)  // 随机范围取值\n                        ','2022-09-08 02:19:48'),(1662603633946,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 2','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 2','2022-09-08 02:20:33'),(1662603634210,1662603588008,0,82001,1662603529187,1,'an, an, an, 3, 1','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 3\noffset: 1','2022-09-08 02:20:34'),(1662603634531,1662603588008,0,82001,1662603529187,1,'an, an, an, 5, 4','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 5\noffset: 4','2022-09-08 02:20:34'),(1662603634950,1662603588008,0,82001,1662603529187,1,'an, an, an, 10, 1','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 10\noffset: 1','2022-09-08 02:20:34'),(1662603635209,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 2','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 2','2022-09-08 02:20:35'),(1662603636254,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 4','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 4','2022-09-08 02:20:36'),(1662603636775,1662603588008,0,82001,1662603529187,1,'an, an, an, 10, 3','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 10\noffset: 3','2022-09-08 02:20:36'),(1662603637792,1662603588008,0,82001,1662603529187,1,'an, an, an, 3, 0','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 3\noffset: 0','2022-09-08 02:20:37'),(1662603638250,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 2','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 2','2022-09-08 02:20:38'),(1662603638666,1662603588008,0,82001,1662603529187,1,'an, an, an, 5, 4','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 5\noffset: 4','2022-09-08 02:20:38'),(1662603639770,1662603588008,0,82001,1662603529187,1,'an, an, an, 5, 5','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 5\noffset: 5','2022-09-08 02:20:39'),(1662603640118,1662603588008,0,82001,1662603529187,1,'an, an, an, 3, 4','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 3\noffset: 4','2022-09-08 02:20:40'),(1662603640453,1662603588008,0,82001,1662603529187,1,'an, an, an, 10, 2','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 10\noffset: 2','2022-09-08 02:20:40'),(1662603872492,0,0,82001,1662603872425,20,'默认配置','minToId: ORDER_IN(0, 1, 3, 5)  // 顺序选项取值\nmaxAvgId: RANDOM_INT(1000, 100000)  // 随机范围取值\n                        ','2022-09-08 02:24:32'),(1662603893076,1662603872492,0,82001,1662603872425,1,'0, 56784','minToId: 0\nmaxAvgId: 56784','2022-09-08 02:24:53'),(1662603893539,1662603872492,0,82001,1662603872425,1,'1, 37559','minToId: 1\nmaxAvgId: 37559','2022-09-08 02:24:53'),(1662603893861,1662603872492,0,82001,1662603872425,1,'3, 82504','minToId: 3\nmaxAvgId: 82504','2022-09-08 02:24:53'),(1662603894324,1662603872492,0,82001,1662603872425,1,'5, 17016','minToId: 5\nmaxAvgId: 17016','2022-09-08 02:24:54'),(1662603894668,1662603872492,0,82001,1662603872425,1,'0, 86991','minToId: 0\nmaxAvgId: 86991','2022-09-08 02:24:54'),(1662603895639,1662603872492,0,82001,1662603872425,1,'0, 72789','minToId: 0\nmaxAvgId: 72789','2022-09-08 02:24:55'),(1662603895877,1662603872492,0,82001,1662603872425,1,'5, 3122','minToId: 5\nmaxAvgId: 3122','2022-09-08 02:24:55'),(1662603896554,1662603872492,0,82001,1662603872425,1,'3, 61029','minToId: 3\nmaxAvgId: 61029','2022-09-08 02:24:56'),(1662603897416,1662603872492,0,82001,1662603872425,1,'1, 98272','minToId: 1\nmaxAvgId: 98272','2022-09-08 02:24:57'),(1662603898027,1662603872492,0,82001,1662603872425,1,'0, 41767','minToId: 0\nmaxAvgId: 41767','2022-09-08 02:24:58'),(1662603898591,1662603872492,0,82001,1662603872425,1,'5, 78787','minToId: 5\nmaxAvgId: 78787','2022-09-08 02:24:58'),(1662603899616,1662603872492,0,82001,1662603872425,1,'3, 38492','minToId: 3\nmaxAvgId: 38492','2022-09-08 02:24:59'),(1662603899970,1662603872492,0,82001,1662603872425,1,'1, 43049','minToId: 1\nmaxAvgId: 43049','2022-09-08 02:24:59'),(1662603900399,1662603872492,0,82001,1662603872425,1,'5, 48646','minToId: 5\nmaxAvgId: 48646','2022-09-08 02:25:00'),(1662603901295,1662603872492,0,82001,1662603872425,1,'1, 99621','minToId: 1\nmaxAvgId: 99621','2022-09-08 02:25:01'),(1662603901698,1662603872492,0,82001,1662603872425,1,'3, 22039','minToId: 3\nmaxAvgId: 22039','2022-09-08 02:25:01'),(1662603902522,1662603872492,0,82001,1662603872425,1,'0, 25691','minToId: 0\nmaxAvgId: 25691','2022-09-08 02:25:02'),(1662603902779,1662603872492,0,82001,1662603872425,1,'5, 85496','minToId: 5\nmaxAvgId: 85496','2022-09-08 02:25:02'),(1662603903910,1662603872492,0,82001,1662603872425,1,'3, 53684','minToId: 3\nmaxAvgId: 53684','2022-09-08 02:25:03'),(1662603904614,1662603872492,0,82001,1662603872425,1,'1, 52879','minToId: 1\nmaxAvgId: 52879','2022-09-08 02:25:04'),(1662604351860,0,0,82001,1662604351793,60,'默认配置','key1: ORDER_IN(\'tom*\', \'api*\', \'test*\')\nkey2: ORDER_IN(\'tom*\', \'api*\', \'test*\', \'le*\')\nkey3: ORDER_IN(\'tom*\', \'api*\', \'test*\', \'le*\', \'mi*\')','2022-09-08 02:32:31'),(1662604390896,1662604351860,0,82001,1662604351793,1,'tom*, tom*, tom*','key1: \"tom*\"\nkey2: \"tom*\"\nkey3: \"tom*\"','2022-09-08 02:33:10'),(1662604391194,1662604351860,0,82001,1662604351793,1,'api*, api*, api*','key1: \"api*\"\nkey2: \"api*\"\nkey3: \"api*\"','2022-09-08 02:33:11'),(1662604391592,1662604351860,0,82001,1662604351793,1,'test*, test*, test*','key1: \"test*\"\nkey2: \"test*\"\nkey3: \"test*\"','2022-09-08 02:33:11'),(1662604391922,1662604351860,0,82001,1662604351793,1,'tom*, le*, le*','key1: \"tom*\"\nkey2: \"le*\"\nkey3: \"le*\"','2022-09-08 02:33:11'),(1662604392325,1662604351860,0,82001,1662604351793,1,'api*, tom*, mi*','key1: \"api*\"\nkey2: \"tom*\"\nkey3: \"mi*\"','2022-09-08 02:33:12'),(1662604393124,1662604351860,0,82001,1662604351793,1,'test*, api*, tom*','key1: \"test*\"\nkey2: \"api*\"\nkey3: \"tom*\"','2022-09-08 02:33:13'),(1662604393404,1662604351860,0,82001,1662604351793,1,'tom*, test*, api*','key1: \"tom*\"\nkey2: \"test*\"\nkey3: \"api*\"','2022-09-08 02:33:13'),(1662604393647,1662604351860,0,82001,1662604351793,1,'api*, le*, test*','key1: \"api*\"\nkey2: \"le*\"\nkey3: \"test*\"','2022-09-08 02:33:13'),(1662604394478,1662604351860,0,82001,1662604351793,1,'tom*, api*, mi*','key1: \"tom*\"\nkey2: \"api*\"\nkey3: \"mi*\"','2022-09-08 02:33:14'),(1662604394808,1662604351860,0,82001,1662604351793,1,'test*, tom*, le*','key1: \"test*\"\nkey2: \"tom*\"\nkey3: \"le*\"','2022-09-08 02:33:14'),(1662604395625,1662604351860,0,82001,1662604351793,1,'api*, test*, tom*','key1: \"api*\"\nkey2: \"test*\"\nkey3: \"tom*\"','2022-09-08 02:33:15'),(1662604396249,1662604351860,0,82001,1662604351793,1,'test*, le*, api*','key1: \"test*\"\nkey2: \"le*\"\nkey3: \"api*\"','2022-09-08 02:33:16'),(1662604396619,1662604351860,0,82001,1662604351793,1,'tom*, tom*, test*','key1: \"tom*\"\nkey2: \"tom*\"\nkey3: \"test*\"','2022-09-08 02:33:16'),(1662604397050,1662604351860,0,82001,1662604351793,1,'api*, api*, le*','key1: \"api*\"\nkey2: \"api*\"\nkey3: \"le*\"','2022-09-08 02:33:17'),(1662604397443,1662604351860,0,82001,1662604351793,1,'test*, test*, mi*','key1: \"test*\"\nkey2: \"test*\"\nkey3: \"mi*\"','2022-09-08 02:33:17'),(1662604398501,1662604351860,0,82001,1662604351793,1,'tom*, le*, tom*','key1: \"tom*\"\nkey2: \"le*\"\nkey3: \"tom*\"','2022-09-08 02:33:18'),(1662604398805,1662604351860,0,82001,1662604351793,1,'api*, tom*, api*','key1: \"api*\"\nkey2: \"tom*\"\nkey3: \"api*\"','2022-09-08 02:33:18'),(1662604399069,1662604351860,0,82001,1662604351793,1,'test*, api*, test*','key1: \"test*\"\nkey2: \"api*\"\nkey3: \"test*\"','2022-09-08 02:33:19'),(1662604399985,1662604351860,0,82001,1662604351793,1,'api*, le*, mi*','key1: \"api*\"\nkey2: \"le*\"\nkey3: \"mi*\"','2022-09-08 02:33:20'),(1662604400320,1662604351860,0,82001,1662604351793,1,'tom*, test*, le*','key1: \"tom*\"\nkey2: \"test*\"\nkey3: \"le*\"','2022-09-08 02:33:20'),(1662604400689,1662604351860,0,82001,1662604351793,1,'tom*, api*, api*','key1: \"tom*\"\nkey2: \"api*\"\nkey3: \"api*\"','2022-09-08 02:33:20'),(1662604401097,1662604351860,0,82001,1662604351793,1,'test*, tom*, tom*','key1: \"test*\"\nkey2: \"tom*\"\nkey3: \"tom*\"','2022-09-08 02:33:21'),(1662604402979,1662604351860,0,82001,1662604351793,1,'test*, le*, le*','key1: \"test*\"\nkey2: \"le*\"\nkey3: \"le*\"','2022-09-08 02:33:22'),(1662604403344,1662604351860,0,82001,1662604351793,1,'tom*, tom*, mi*','key1: \"tom*\"\nkey2: \"tom*\"\nkey3: \"mi*\"','2022-09-08 02:33:23'),(1662604404117,1662604351860,0,82001,1662604351793,1,'api*, test*, test*','key1: \"api*\"\nkey2: \"test*\"\nkey3: \"test*\"','2022-09-08 02:33:24'),(1662604404486,1662604351860,0,82001,1662604351793,1,'api*, api*, tom*','key1: \"api*\"\nkey2: \"api*\"\nkey3: \"tom*\"','2022-09-08 02:33:24'),(1662604404991,1662604351860,0,82001,1662604351793,1,'test*, test*, api*','key1: \"test*\"\nkey2: \"test*\"\nkey3: \"api*\"','2022-09-08 02:33:25'),(1662604405776,1662604351860,0,82001,1662604351793,1,'tom*, le*, test*','key1: \"tom*\"\nkey2: \"le*\"\nkey3: \"test*\"','2022-09-08 02:33:25'),(1662604406032,1662604351860,0,82001,1662604351793,1,'api*, tom*, le*','key1: \"api*\"\nkey2: \"tom*\"\nkey3: \"le*\"','2022-09-08 02:33:26'),(1662604407050,1662604351860,0,82001,1662604351793,1,'test*, api*, mi*','key1: \"test*\"\nkey2: \"api*\"\nkey3: \"mi*\"','2022-09-08 02:33:27'),(1662604408100,1662604351860,0,82001,1662604351793,1,'api*, le*, api*','key1: \"api*\"\nkey2: \"le*\"\nkey3: \"api*\"','2022-09-08 02:33:28'),(1662604408861,1662604351860,0,82001,1662604351793,1,'tom*, test*, tom*','key1: \"tom*\"\nkey2: \"test*\"\nkey3: \"tom*\"','2022-09-08 02:33:28'),(1662604409267,1662604351860,0,82001,1662604351793,1,'test*, tom*, test*','key1: \"test*\"\nkey2: \"tom*\"\nkey3: \"test*\"','2022-09-08 02:33:29'),(1662604409604,1662604351860,0,82001,1662604351793,1,'tom*, api*, le*','key1: \"tom*\"\nkey2: \"api*\"\nkey3: \"le*\"','2022-09-08 02:33:29'),(1662604410448,1662604351860,0,82001,1662604351793,1,'test*, le*, tom*','key1: \"test*\"\nkey2: \"le*\"\nkey3: \"tom*\"','2022-09-08 02:33:30'),(1662604411377,1662604351860,0,82001,1662604351793,1,'api*, test*, mi*','key1: \"api*\"\nkey2: \"test*\"\nkey3: \"mi*\"','2022-09-08 02:33:31'),(1662604412363,1662604351860,0,82001,1662604351793,1,'test*, test*, le*','key1: \"test*\"\nkey2: \"test*\"\nkey3: \"le*\"','2022-09-08 02:33:32'),(1662604412699,1662604351860,0,82001,1662604351793,1,'api*, api*, test*','key1: \"api*\"\nkey2: \"api*\"\nkey3: \"test*\"','2022-09-08 02:33:32'),(1662604413067,1662604351860,0,82001,1662604351793,1,'tom*, tom*, api*','key1: \"tom*\"\nkey2: \"tom*\"\nkey3: \"api*\"','2022-09-08 02:33:33'),(1662604413765,1662604351860,0,82001,1662604351793,1,'tom*, le*, mi*','key1: \"tom*\"\nkey2: \"le*\"\nkey3: \"mi*\"','2022-09-08 02:33:33'),(1662604414076,1662604351860,0,82001,1662604351793,1,'api*, tom*, tom*','key1: \"api*\"\nkey2: \"tom*\"\nkey3: \"tom*\"','2022-09-08 02:33:34'),(1662604414341,1662604351860,0,82001,1662604351793,1,'test*, api*, api*','key1: \"test*\"\nkey2: \"api*\"\nkey3: \"api*\"','2022-09-08 02:33:34'),(1662604415232,1662604351860,0,82001,1662604351793,1,'tom*, api*, tom*','key1: \"tom*\"\nkey2: \"api*\"\nkey3: \"tom*\"','2022-09-08 02:33:35'),(1662604415518,1662604351860,0,82001,1662604351793,1,'test*, tom*, mi*','key1: \"test*\"\nkey2: \"tom*\"\nkey3: \"mi*\"','2022-09-08 02:33:35'),(1662604415945,1662604351860,0,82001,1662604351793,1,'api*, le*, le*','key1: \"api*\"\nkey2: \"le*\"\nkey3: \"le*\"','2022-09-08 02:33:35'),(1662604417081,1662604351860,0,82001,1662604351793,1,'tom*, test*, test*','key1: \"tom*\"\nkey2: \"test*\"\nkey3: \"test*\"','2022-09-08 02:33:37'),(1662604417717,1662604351860,0,82001,1662604351793,1,'api*, test*, api*','key1: \"api*\"\nkey2: \"test*\"\nkey3: \"api*\"','2022-09-08 02:33:37'),(1662604418558,1662604351860,0,82001,1662604351793,1,'tom*, le*, api*','key1: \"tom*\"\nkey2: \"le*\"\nkey3: \"api*\"','2022-09-08 02:33:38'),(1662604418870,1662604351860,0,82001,1662604351793,1,'test*, test*, tom*','key1: \"test*\"\nkey2: \"test*\"\nkey3: \"tom*\"','2022-09-08 02:33:38'),(1662604419254,1662604351860,0,82001,1662604351793,1,'api*, api*, mi*','key1: \"api*\"\nkey2: \"api*\"\nkey3: \"mi*\"','2022-09-08 02:33:39'),(1662604419559,1662604351860,0,82001,1662604351793,1,'tom*, tom*, le*','key1: \"tom*\"\nkey2: \"tom*\"\nkey3: \"le*\"','2022-09-08 02:33:39'),(1662604420073,1662604351860,0,82001,1662604351793,1,'test*, le*, test*','key1: \"test*\"\nkey2: \"le*\"\nkey3: \"test*\"','2022-09-08 02:33:40'),(1662604421484,1662604351860,0,82001,1662604351793,1,'tom*, test*, mi*','key1: \"tom*\"\nkey2: \"test*\"\nkey3: \"mi*\"','2022-09-08 02:33:41'),(1662604421846,1662604351860,0,82001,1662604351793,1,'test*, api*, le*','key1: \"test*\"\nkey2: \"api*\"\nkey3: \"le*\"','2022-09-08 02:33:41'),(1662604422154,1662604351860,0,82001,1662604351793,1,'api*, tom*, test*','key1: \"api*\"\nkey2: \"tom*\"\nkey3: \"test*\"','2022-09-08 02:33:42'),(1662604423282,1662604351860,0,82001,1662604351793,1,'test*, tom*, api*','key1: \"test*\"\nkey2: \"tom*\"\nkey3: \"api*\"','2022-09-08 02:33:43'),(1662604423613,1662604351860,0,82001,1662604351793,1,'api*, le*, tom*','key1: \"api*\"\nkey2: \"le*\"\nkey3: \"tom*\"','2022-09-08 02:33:43'),(1662604424031,1662604351860,0,82001,1662604351793,1,'tom*, api*, test*','key1: \"tom*\"\nkey2: \"api*\"\nkey3: \"test*\"','2022-09-08 02:33:44'),(1662604425205,1662604351860,0,82001,1662604351793,1,'test*, le*, mi*','key1: \"test*\"\nkey2: \"le*\"\nkey3: \"mi*\"','2022-09-08 02:33:45'),(1662604425511,1662604351860,0,82001,1662604351793,1,'api*, test*, le*','key1: \"api*\"\nkey2: \"test*\"\nkey3: \"le*\"','2022-09-08 02:33:45'),(1662604680580,0,0,82001,1662604680510,12,'默认配置','like: ORDER_IN(\'%s%\', \'%q%\', \'%l%\')\nregexp: ORDER_IN(\'a\', \'u\', \'t\', \'o\')','2022-09-08 02:38:00'),(1662604697485,1662604680580,0,82001,1662604680510,1,'%s%, a','like: \"%s%\"\nregexp: \"a\"','2022-09-08 02:38:17'),(1662604697719,1662604680580,0,82001,1662604680510,1,'%q%, u','like: \"%q%\"\nregexp: \"u\"','2022-09-08 02:38:17'),(1662604698769,1662604680580,0,82001,1662604680510,1,'%q%, a','like: \"%q%\"\nregexp: \"a\"','2022-09-08 02:38:18'),(1662604699105,1662604680580,0,82001,1662604680510,1,'%s%, o','like: \"%s%\"\nregexp: \"o\"','2022-09-08 02:38:19'),(1662604699475,1662604680580,0,82001,1662604680510,1,'%l%, t','like: \"%l%\"\nregexp: \"t\"','2022-09-08 02:38:19'),(1662604700380,1662604680580,0,82001,1662604680510,1,'%s%, t','like: \"%s%\"\nregexp: \"t\"','2022-09-08 02:38:20'),(1662604701849,1662604680580,0,82001,1662604680510,1,'%l%, u','like: \"%l%\"\nregexp: \"u\"','2022-09-08 02:38:21'),(1662604704762,1662604680580,0,82001,1662604680510,1,'%l%, a','like: \"%l%\"\nregexp: \"a\"','2022-09-08 02:38:24'),(1662604705058,1662604680580,0,82001,1662604680510,1,'%q%, o','like: \"%q%\"\nregexp: \"o\"','2022-09-08 02:38:25'),(1662604705462,1662604680580,0,82001,1662604680510,1,'%s%, u','like: \"%s%\"\nregexp: \"u\"','2022-09-08 02:38:25'),(1662604706918,1662604680580,0,82001,1662604680510,1,'%q%, t','like: \"%q%\"\nregexp: \"t\"','2022-09-08 02:38:26'),(1662604708071,1662604680580,0,82001,1662604680510,1,'%l%, o','like: \"%l%\"\nregexp: \"o\"','2022-09-08 02:38:28'),(1662605088600,0,0,82001,1662605088494,60,'默认配置','limit: ORDER_IN(1, 3, 5, 8, 10)\noffset: RANDOM_INT(0, 5)','2022-09-08 02:44:48'),(1662605495972,0,0,82001,1662605495868,6,'默认配置','regexp: ORDER_IN(\'a\', \'p\', \'i\')\nsex: RANDOM_INT(0, 2)','2022-09-08 02:51:36'),(1662605510076,1662605495972,0,82001,1662605495868,1,'a, 1','regexp: \"a\"\nsex: 1','2022-09-08 02:51:50'),(1662605510347,1662605495972,0,82001,1662605495868,1,'p, 2','regexp: \"p\"\nsex: 2','2022-09-08 02:51:50'),(1662605511079,1662605495972,0,82001,1662605495868,1,'i, 1','regexp: \"i\"\nsex: 1','2022-09-08 02:51:51'),(1662605514260,1662605495972,0,82001,1662605495868,1,'a, 0','regexp: \"a\"\nsex: 0','2022-09-08 02:51:54'),(1662605515693,1662605495972,0,82001,1662605495868,1,'p, 1','regexp: \"p\"\nsex: 1','2022-09-08 02:51:55'),(1662605516862,1662605495972,0,82001,1662605495868,1,'i, 1','regexp: \"i\"\nsex: 1','2022-09-08 02:51:56'),(1662606200887,0,0,82001,1662606200791,50,'默认配置','momentId: RANDOM_IN(12, 15, 401)\nuserId: ORDER_INT(82001, 82010)\ncontent: RANDOM_STR()','2022-09-08 03:03:20'),(1662606482729,0,0,82001,1662606482664,1,'默认配置','name: RANDOM_STR()\nid: ORDER_IN(82001, 82010, 82345)','2022-09-08 03:08:02'),(1662607012326,1662606992422,0,82001,1662606992370,1,'82001, 89745, 1, 5','minId: 82001\nmaxId: 89745\nlimit: 1\noffset: 5','2022-09-08 03:16:52'),(1662607012600,1662606992422,0,82001,1662606992370,1,'82005, 86622, 3, 0','minId: 82005\nmaxId: 86622\nlimit: 3\noffset: 0','2022-09-08 03:16:52'),(1662607012874,1662606992422,0,82001,1662606992370,1,'82010, 94566, 5, 4','minId: 82010\nmaxId: 94566\nlimit: 5\noffset: 4','2022-09-08 03:16:52'),(1662607013279,1662606992422,0,82001,1662606992370,1,'82001, 98906, 10, 4','minId: 82001\nmaxId: 98906\nlimit: 10\noffset: 4','2022-09-08 03:16:53'),(1662607014504,1662606992422,0,82001,1662606992370,1,'82001, 99424, 5, 4','minId: 82001\nmaxId: 99424\nlimit: 5\noffset: 4','2022-09-08 03:16:54'),(1662607014739,1662606992422,0,82001,1662606992370,1,'82010, 82762, 3, 5','minId: 82010\nmaxId: 82762\nlimit: 3\noffset: 5','2022-09-08 03:16:54'),(1662607015013,1662606992422,0,82001,1662606992370,1,'82005, 86914, 1, 2','minId: 82005\nmaxId: 86914\nlimit: 1\noffset: 2','2022-09-08 03:16:55'),(1662607015446,1662606992422,0,82001,1662606992370,1,'82005, 89105, 10, 3','minId: 82005\nmaxId: 89105\nlimit: 10\noffset: 3','2022-09-08 03:16:55'),(1662607016430,1662606992422,0,82001,1662606992370,1,'82001, 99815, 1, 0','minId: 82001\nmaxId: 99815\nlimit: 1\noffset: 0','2022-09-08 03:16:56'),(1662607016768,1662606992422,0,82001,1662606992370,1,'82010, 98820, 10, 5','minId: 82010\nmaxId: 98820\nlimit: 10\noffset: 5','2022-09-08 03:16:56'),(1662607017169,1662606992422,0,82001,1662606992370,1,'82005, 90681, 5, 3','minId: 82005\nmaxId: 90681\nlimit: 5\noffset: 3','2022-09-08 03:16:57'),(1662607017477,1662606992422,0,82001,1662606992370,1,'82001, 89360, 3, 5','minId: 82001\nmaxId: 89360\nlimit: 3\noffset: 5','2022-09-08 03:16:57'),(1662607018376,1662606992422,0,82001,1662606992370,1,'82010, 93899, 1, 2','minId: 82010\nmaxId: 93899\nlimit: 1\noffset: 2','2022-09-08 03:16:58'),(1662607018979,1662606992422,0,82001,1662606992370,1,'82005, 98070, 3, 2','minId: 82005\nmaxId: 98070\nlimit: 3\noffset: 2','2022-09-08 03:16:58'),(1662607020012,1662606992422,0,82001,1662606992370,1,'82005, 96414, 1, 2','minId: 82005\nmaxId: 96414\nlimit: 1\noffset: 2','2022-09-08 03:17:00'),(1662607020245,1662606992422,0,82001,1662606992370,1,'82001, 85644, 10, 2','minId: 82001\nmaxId: 85644\nlimit: 10\noffset: 2','2022-09-08 03:17:00'),(1662607020925,1662606992422,0,82001,1662606992370,1,'82010, 99965, 5, 4','minId: 82010\nmaxId: 99965\nlimit: 5\noffset: 4','2022-09-08 03:17:00'),(1662607021768,1662606992422,0,82001,1662606992370,1,'82001, 99862, 5, 5','minId: 82001\nmaxId: 99862\nlimit: 5\noffset: 5','2022-09-08 03:17:01'),(1662607022167,1662606992422,0,82001,1662606992370,1,'82010, 99942, 3, 3','minId: 82010\nmaxId: 99942\nlimit: 3\noffset: 3','2022-09-08 03:17:02'),(1662607022605,1662606992422,0,82001,1662606992370,1,'82005, 92824, 10, 2','minId: 82005\nmaxId: 92824\nlimit: 10\noffset: 2','2022-09-08 03:17:02'),(1662607135972,1662607124866,0,82001,1662606992370,1,'82001, 83946, 3','minId: 82001\nmaxId: 83946\nlimit: 3','2022-09-08 03:18:55'),(1662607136243,1662607124866,0,82001,1662606992370,1,'82005, 95599, 5','minId: 82005\nmaxId: 95599\nlimit: 5','2022-09-08 03:18:56'),(1662607136628,1662607124866,0,82001,1662606992370,1,'82010, 83525, 5','minId: 82010\nmaxId: 83525\nlimit: 5','2022-09-08 03:18:56'),(1662607138070,1662607124866,0,82001,1662606992370,1,'82005, 83749, 3','minId: 82005\nmaxId: 83749\nlimit: 3','2022-09-08 03:18:58'),(1662607138374,1662607124866,0,82001,1662606992370,1,'82001, 90251, 3','minId: 82001\nmaxId: 90251\nlimit: 3','2022-09-08 03:18:58'),(1662607138605,1662607124866,0,82001,1662606992370,1,'82010, 91454, 3','minId: 82010\nmaxId: 91454\nlimit: 3','2022-09-08 03:18:58'),(1662607139256,1662607124866,0,82001,1662606992370,1,'82001, 85939, 1','minId: 82001\nmaxId: 85939\nlimit: 1','2022-09-08 03:18:59'),(1662607139832,1662607124866,0,82001,1662606992370,1,'82010, 88654, 5','minId: 82010\nmaxId: 88654\nlimit: 5','2022-09-08 03:18:59'),(1662607140162,1662607124866,0,82001,1662606992370,1,'82005, 96711, 10','minId: 82005\nmaxId: 96711\nlimit: 10','2022-09-08 03:19:00'),(1662607140575,1662607124866,0,82001,1662606992370,1,'82005, 85200, 5','minId: 82005\nmaxId: 85200\nlimit: 5','2022-09-08 03:19:00'),(1662607141821,1662607124866,0,82001,1662606992370,1,'82005, 90937, 3','minId: 82005\nmaxId: 90937\nlimit: 3','2022-09-08 03:19:01'),(1662607142092,1662607124866,0,82001,1662606992370,1,'82001, 95578, 3','minId: 82001\nmaxId: 95578\nlimit: 3','2022-09-08 03:19:02'),(1662607142870,1662607124866,0,82001,1662606992370,1,'82001, 82927, 3','minId: 82001\nmaxId: 82927\nlimit: 3','2022-09-08 03:19:02'),(1662607143134,1662607124866,0,82001,1662606992370,1,'82010, 92470, 5','minId: 82010\nmaxId: 92470\nlimit: 5','2022-09-08 03:19:03'),(1662607143902,1662607124866,0,82001,1662606992370,1,'82001, 99102, 3','minId: 82001\nmaxId: 99102\nlimit: 3','2022-09-08 03:19:03'),(1662607144135,1662607124866,0,82001,1662606992370,1,'82010, 87467, 1','minId: 82010\nmaxId: 87467\nlimit: 1','2022-09-08 03:19:04'),(1662607144378,1662607124866,0,82001,1662606992370,1,'82005, 99193, 3','minId: 82005\nmaxId: 99193\nlimit: 3','2022-09-08 03:19:04'),(1662607144648,1662607124866,0,82001,1662606992370,1,'82001, 90330, 3','minId: 82001\nmaxId: 90330\nlimit: 3','2022-09-08 03:19:04'),(1662607145755,1662607124866,0,82001,1662606992370,1,'82005, 86139, 10','minId: 82005\nmaxId: 86139\nlimit: 10','2022-09-08 03:19:05'),(1662607146058,1662607124866,0,82001,1662606992370,1,'82010, 86870, 5','minId: 82010\nmaxId: 86870\nlimit: 5','2022-09-08 03:19:06'),(1662607238174,0,0,82001,1662606992370,24,'随机配置 2022-09-08 11:20','minId: ORDER_IN(82001, 82005, 82010)  // 顺序选项取值\nmaxId: RANDOM_INT(82005, 82012)  // 随机范围取值','2022-09-08 03:20:38'),(1662607255913,1662607238174,0,82001,1662606992370,1,'82001, 82010','minId: 82001\nmaxId: 82010','2022-09-08 03:20:55'),(1662607256144,1662607238174,0,82001,1662606992370,1,'82005, 82005','minId: 82005\nmaxId: 82005','2022-09-08 03:20:56'),(1662607259133,1662607238174,0,82001,1662606992370,1,'82001, 82009','minId: 82001\nmaxId: 82009','2022-09-08 03:20:59'),(1662607259487,1662607238174,0,82001,1662606992370,1,'82010, 82009','minId: 82010\nmaxId: 82009','2022-09-08 03:20:59'),(1662607328439,1662607238174,0,82001,1662606992370,1,'82010, 82009','minId: 82010\nmaxId: 82009','2022-09-08 03:22:08'),(1662607328736,1662607238174,0,82001,1662606992370,1,'82005, 82007','minId: 82005\nmaxId: 82007','2022-09-08 03:22:08'),(1662607329401,1662607238174,0,82001,1662606992370,1,'82010, 82005','minId: 82010\nmaxId: 82005','2022-09-08 03:22:09'),(1662607329753,1662607238174,0,82001,1662606992370,1,'82001, 82007','minId: 82001\nmaxId: 82007','2022-09-08 03:22:09'),(1662607330809,1662607238174,0,82001,1662606992370,1,'82001, 82008','minId: 82001\nmaxId: 82008','2022-09-08 03:22:10'),(1662607382483,1662607238174,0,82001,1662606992370,1,'82001, 82006','minId: 82001\nmaxId: 82006','2022-09-08 03:23:02'),(1662607382806,1662607238174,0,82001,1662606992370,1,'82010, 82008','minId: 82010\nmaxId: 82008','2022-09-08 03:23:02'),(1662607384317,1662607238174,0,82001,1662606992370,1,'82010, 82011','minId: 82010\nmaxId: 82011','2022-09-08 03:23:04'),(1662607384663,1662607238174,0,82001,1662606992370,1,'82005, 82008','minId: 82005\nmaxId: 82008','2022-09-08 03:23:04'),(1662607385506,1662607238174,0,82001,1662606992370,1,'82005, 82007','minId: 82005\nmaxId: 82007','2022-09-08 03:23:05'),(1662607385814,1662607238174,0,82001,1662606992370,1,'82001, 82011','minId: 82001\nmaxId: 82011','2022-09-08 03:23:05'),(1662607387195,1662607238174,0,82001,1662606992370,1,'82010, 82012','minId: 82010\nmaxId: 82012','2022-09-08 03:23:07'),(1662607387596,1662607238174,0,82001,1662606992370,1,'82005, 82010','minId: 82005\nmaxId: 82010','2022-09-08 03:23:07'),(1662607388014,1662607238174,0,82001,1662606992370,1,'82001, 82005','minId: 82001\nmaxId: 82005','2022-09-08 03:23:08'),(1662607388478,1662607238174,0,82001,1662606992370,1,'82010, 82006','minId: 82010\nmaxId: 82006','2022-09-08 03:23:08'),(1662607390981,1662607238174,0,82001,1662606992370,1,'82005, 82007','minId: 82005\nmaxId: 82007','2022-09-08 03:23:10'),(1662607391931,1662607238174,0,82001,1662606992370,1,'82001, 82008','minId: 82001\nmaxId: 82008','2022-09-08 03:23:11'),(1662607393512,1662607238174,0,82001,1662606992370,1,'82005, 82008','minId: 82005\nmaxId: 82008','2022-09-08 03:23:13'),(1662607394206,1662607238174,0,82001,1662606992370,1,'82001, 82009','minId: 82001\nmaxId: 82009','2022-09-08 03:23:14'),(1662607452352,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 3','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 3','2022-09-08 03:24:12'),(1662607452673,1662603588008,0,82001,1662603529187,1,'an, an, an, 10, 1','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 10\noffset: 1','2022-09-08 03:24:12'),(1662607455636,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 1','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 1','2022-09-08 03:24:15'),(1662607456005,1662603588008,0,82001,1662603529187,1,'an, an, an, 10, 0','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 10\noffset: 0','2022-09-08 03:24:16'),(1662607456396,1662603588008,0,82001,1662603529187,1,'an, an, an, 5, 1','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 5\noffset: 1','2022-09-08 03:24:16'),(1662607456986,1662603588008,0,82001,1662603529187,1,'an, an, an, 3, 2','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 3\noffset: 2','2022-09-08 03:24:17'),(1662607466410,1662603588008,0,82001,1662603529187,1,'an, an, an, 1, 5','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 1\noffset: 5','2022-09-08 03:24:26'),(1662607468018,1662603588008,0,82001,1662603529187,1,'an, an, an, 3, 3','searchKey1: \"an\"\nsearchKey2: \"an\"\nsearchKey3: \"an\"\nlimit: 3\noffset: 3','2022-09-08 03:24:28'),(1662624731925,0,0,82001,1662569033547,9,'ORDER_IN, ORDER_IN','key: ORDER_IN(\'s\', \'q\', \'l\')  // 顺序选项取值\nlimit: ORDER_IN(1, 5, 10)  // 顺序范围取值','2022-09-08 08:12:11'),(1662624739168,1662624731925,0,82001,1662569033547,1,'q, 5','key: \"q\"\nlimit: 5','2022-09-08 08:12:19'),(1662624739443,1662624731925,0,82001,1662569033547,1,'l, 10','key: \"l\"\nlimit: 10','2022-09-08 08:12:19'),(1662624739642,1662624731925,0,82001,1662569033547,1,'s, 1','key: \"s\"\nlimit: 1','2022-09-08 08:12:19'),(1662624739882,1662624731925,0,82001,1662569033547,1,'q, 5','key: \"q\"\nlimit: 5','2022-09-08 08:12:19'),(1662624740692,1662624731925,0,82001,1662569033547,1,'s, 1','key: \"s\"\nlimit: 1','2022-09-08 08:12:20'),(1662624741140,1662624731925,0,82001,1662569033547,1,'l, 10','key: \"l\"\nlimit: 10','2022-09-08 08:12:21'),(1662624741910,1662624731925,0,82001,1662569033547,1,'q, 5','key: \"q\"\nlimit: 5','2022-09-08 08:12:21'),(1662624742278,1662624731925,0,82001,1662569033547,1,'l, 10','key: \"l\"\nlimit: 10','2022-09-08 08:12:22'),(1662624831439,1662624731925,0,82001,1662569033547,1,'s, 1','key: \"s\"\nlimit: 1','2022-09-08 08:13:51'),(1662624831798,1662624731925,0,82001,1662569033547,1,'q, 5','key: \"q\"\nlimit: 5','2022-09-08 08:13:51'),(1662624832543,1662624731925,0,82001,1662569033547,1,'q, 5','key: \"q\"\nlimit: 5','2022-09-08 08:13:52'),(1662624832822,1662624731925,0,82001,1662569033547,1,'s, 1','key: \"s\"\nlimit: 1','2022-09-08 08:13:52'),(1662624833111,1662624731925,0,82001,1662569033547,1,'l, 10','key: \"l\"\nlimit: 10','2022-09-08 08:13:53'),(1662624833954,1662624731925,0,82001,1662569033547,1,'s, 1','key: \"s\"\nlimit: 1','2022-09-08 08:13:53'),(1662634326721,1657045372256,0,82001,1657045372046,1,'undefined','User/id: undefined','2022-09-08 10:52:06'),(1662634328100,1657045372256,0,82001,1657045372046,1,'null','User/id: null','2022-09-08 10:52:08'),(1662634329013,1657045372256,0,82001,1657045372046,1,'82001','User/id: 82001','2022-09-08 10:52:09'),(1662634839880,0,0,82001,1662634839699,3,'默认配置','gql: ORDER_IN(\"MATCH (n) WHERE id(n) IN [\\\"monster033\\\", \\\"poison\\\", \\\"monster034\\\"] RETURN n\", \"fetch prop on `evolves_to` \\\"monster033\\\"->\\\"monster034\\\"@0 YIELD edge as `edge_`\", \"fetch prop on `monster_type` \\\"monster033\\\"->\\\"poison\\\"@0 YIELD edge as `edge_`\")','2022-09-08 11:00:39'),(1662989441967,0,0,82001,1511796155276,20,'RANDOM_INT','phone: RANDOM_INT(13000082001, 13000082020) + \"\"','2022-09-12 13:30:41'),(1663144540439,0,0,82001,1663144540138,10,'默认配置','id: \'testNode_\' + Math.round(10*Math.random())','2022-09-14 08:35:40'),(1663144844950,1663144540439,0,82001,1663144540138,1,'testNode_0','id: \'testNode_0\'','2022-09-14 08:40:45'),(1663144845933,1663144540439,0,82001,1663144540138,1,'testNode_4','id: \'testNode_4\'','2022-09-14 08:40:46'),(1663144846662,1663144540439,0,82001,1663144540138,1,'testNode_3','id: \'testNode_3\'','2022-09-14 08:40:46'),(1663144847655,1663144540439,0,82001,1663144540138,1,'testNode_1','id: \'testNode_1\'','2022-09-14 08:40:48'),(1663144847958,1663144540439,0,82001,1663144540138,1,'testNode_8','id: \'testNode_8\'','2022-09-14 08:40:48'),(1663144849025,1663144540439,0,82001,1663144540138,1,'testNode_7','id: \'testNode_7\'','2022-09-14 08:40:49'),(1663144849497,1663144540439,0,82001,1663144540138,1,'testNode_3','id: \'testNode_3\'','2022-09-14 08:40:49'),(1663144850835,1663144540439,0,82001,1663144540138,1,'testNode_8','id: \'testNode_8\'','2022-09-14 08:40:51'),(1663144851155,1663144540439,0,82001,1663144540138,1,'testNode_0','id: \'testNode_0\'','2022-09-14 08:40:51'),(1663144851396,1663144540439,0,82001,1663144540138,1,'testNode_7','id: \'testNode_7\'','2022-09-14 08:40:51'),(1663320436769,0,0,82001,1657797765823,1,'随机配置 2022-09-16 17:27','','2022-09-16 09:27:16'),(1663524173348,0,0,82001,1663513129371,1,'随机配置 2022-09-19 02:02','','2022-09-18 18:02:53'),(1663579977740,0,0,82001,1560244940013,1,'随机配置 2022-09-19 17:30','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-09-19 09:32:57'),(1663749767628,0,0,82001,1663749767546,1,'默认配置','searchKey: \'%a%\'  // 固定常量值\nuserId: RANDOM_IN(82001, 82002, 82003)  // 随机选项取值\nlimit: ORDER_IN(1, 3, 5, 10)  // 顺序选项取值\noffset: RANDOM_INT(0, 5)  // 随机范围取值\n  // 从数据库随机取值  userId: RANDOM_DB(\'Comment\', \'userId\')\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-09-21 08:42:47'),(1664264614662,0,0,82001,1560244940013,1,'随机配置 2022-09-27 15:43','User/id: RANDOM_INT(82001, 82020)  // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {})  // 随机取值\n[]/page: Math.round(5*Math.random())  // 通过代码来自定义\n@explain: ORDER_IN(true, false)  // 顺序取值\n  // 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-09-27 07:43:34'),(1664264870372,0,0,82001,1663749767546,1,'随机配置 2022-09-27 15:47','searchKey: \'%a%\'  // 固定常量值\nuserId: RANDOM_IN(82001, 82002, 82003)  // 随机选项取值\nlimit: ORDER_IN(1, 3, 5, 10)  // 顺序选项取值\noffset: RANDOM_INT(0, 5)  // 随机范围取值\n  // 从数据库随机取值  userId: RANDOM_DB(\'Comment\', \'userId\')\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-09-27 07:47:50'),(1664264877007,0,0,82001,1663749767546,1,'随机配置 2022-09-27 15:47','searchKey: \'%a%\'  // 固定常量值\nuserId: RANDOM_IN(82001, 82002, 82003)  // 随机选项取值\nlimit: ORDER_IN(1, 3, 5, 10)  // 顺序选项取值\noffset: RANDOM_INT(0, 5)  // 随机范围取值\n  // 从数据库随机取值  userId: RANDOM_DB(\'Comment\', \'userId\')\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-09-27 07:47:57'),(1665343358997,0,0,88888,1665343358862,1,'默认配置(上传测试用例时自动生成)','[]/Comment/name$: ORDER_IN(undefined, null, \"\", \"%a%\")\n[]/Comment/content$: ORDER_IN(undefined, null, \"\", \"%b%\")\n[]/Comment/@from@/from: ORDER_IN(undefined, null, \"\", \"Comment\")\n[]/Comment/@from@/join: ORDER_IN(undefined, null, \"\", \"&/User/id@\")\n[]/Comment/@from@/User/sex: ORDER_INT(0, 10)\n  // 可替代上面的 []/Comment/@from@/User/sex: RANDOM_INT(0, 100)','2022-10-09 19:22:39'),(1665343764091,0,0,88888,1665343763962,1,'默认配置(上传测试用例时自动生成)','[]/join: ORDER_IN(undefined, null, \"\", \"*/Moment\")\n[]/Comment/name$: ORDER_IN(undefined, null, \"\", \"%a%\")\n[]/Comment/content$: ORDER_IN(undefined, null, \"\", \"%b%\")\n[]/Comment/@from@/from: ORDER_IN(undefined, null, \"\", \"Comment\")\n[]/Comment/@from@/join: ORDER_IN(undefined, null, \"\", \"&/User/id@\")\n[]/Comment/@from@/User/sex: ORDER_INT(0, 10)\n  // 可替代上面的 []/Comment/@from@/User/sex: RANDOM_INT(0, 100)\n[]/Moment/userId>: RANDOM_INT(0, 100)','2022-10-09 19:29:24'),(1665450439167,0,0,82001,1665450439035,1,'默认配置(上传测试用例时自动生成)','query: ORDER_INT(0, 10)\n  // 可替代上面的 query: RANDOM_INT(0, 100)\nmock: ORDER_IN(undefined, null, false, true)\npackage: ORDER_IN(undefined, null, \"\", \"unitauto.test\")\nclass: ORDER_IN(undefined, null, \"\", \"TestUtil\")\ntypes: ORDER_IN(undefined, null)','2022-10-11 01:07:19'),(1666146136396,0,0,82001,1665817499997,1,'随机配置 2022-10-19 10:22','','2022-10-19 02:22:16'),(1666148328523,0,0,82001,1560244940013,1,'随机配置 2022-10-19 10:58','searchKey: \'%a%\'  // 固定常量值\nuserId: RANDOM_IN(82001, 82002, 82003)  // 随机选项取值\nlimit: ORDER_IN(1, 3, 5, 10)  // 顺序选项取值\noffset: RANDOM_INT(0, 5)  // 随机范围取值\n  // 从数据库随机取值  userId: RANDOM_DB(\'Comment\', \'userId\')\n\n  // 注释可省略，但如果未省略则前面两个空格必须；清空文本内容可查看规则。\n\n  // ## 快捷键\n  // Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n  // Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n                        ','2022-10-19 02:58:48'),(1666202661929,0,0,88888,1666202661817,1,'默认配置(上传测试用例时自动生成)','User/id: ORDER_IN(undefined, null, 38710)\n  // 可替代上面的 User/id: RANDOM_INT(1, 387100)','2022-10-19 18:04:21'),(1666938474669,0,0,82001,1666695095873,1,'随机配置 2022-10-28 14:27','','2022-10-28 06:27:54'),(1667277629162,1657532085455,0,82003,1648471968021,1,'2, 12','methodArgs/0/value: 2\nmethodArgs/1/value: 12','2022-11-01 04:40:29'),(1667277629466,1657532085455,0,82003,1648471968021,1,'8, 17','methodArgs/0/value: 8\nmethodArgs/1/value: 17','2022-11-01 04:40:29'),(1667277629811,1657532085455,0,82003,1648471968021,1,'8, 16','methodArgs/0/value: 8\nmethodArgs/1/value: 16','2022-11-01 04:40:29'),(1667277630171,1657532085455,0,82003,1648471968021,1,'10, 15','methodArgs/0/value: 10\nmethodArgs/1/value: 15','2022-11-01 04:40:30'),(1667277630541,1657532085455,0,82003,1648471968021,1,'6, 16','methodArgs/0/value: 6\nmethodArgs/1/value: 16','2022-11-01 04:40:30'),(1667277630911,1657532085455,0,82003,1648471968021,1,'9, 12','methodArgs/0/value: 9\nmethodArgs/1/value: 12','2022-11-01 04:40:30'),(1667277631956,1657532085455,0,82003,1648471968021,1,'6, 12','methodArgs/0/value: 6\nmethodArgs/1/value: 12','2022-11-01 04:40:31'),(1667277632256,1657532085455,0,82003,1648471968021,1,'7, 11','methodArgs/0/value: 7\nmethodArgs/1/value: 11','2022-11-01 04:40:32'),(1667277632648,1657532085455,0,82003,1648471968021,1,'2, 13','methodArgs/0/value: 2\nmethodArgs/1/value: 13','2022-11-01 04:40:32'),(1667277632943,1657532085455,0,82003,1648471968021,1,'3, 12','methodArgs/0/value: 3\nmethodArgs/1/value: 12','2022-11-01 04:40:32'),(1667277633547,1657532085455,0,82003,1648471968021,1,'3, 19','methodArgs/0/value: 3\nmethodArgs/1/value: 19','2022-11-01 04:40:33'),(1667277633773,1657532085455,0,82003,1648471968021,1,'8, 20','methodArgs/0/value: 8\nmethodArgs/1/value: 20','2022-11-01 04:40:33'),(1667277634638,1657532085455,0,82003,1648471968021,1,'3, 20','methodArgs/0/value: 3\nmethodArgs/1/value: 20','2022-11-01 04:40:34'),(1667277634929,1657532085455,0,82003,1648471968021,1,'8, 12','methodArgs/0/value: 8\nmethodArgs/1/value: 12','2022-11-01 04:40:34'),(1667277635185,1657532085455,0,82003,1648471968021,1,'6, 11','methodArgs/0/value: 6\nmethodArgs/1/value: 11','2022-11-01 04:40:35'),(1667277635558,1657532085455,0,82003,1648471968021,1,'3, 15','methodArgs/0/value: 3\nmethodArgs/1/value: 15','2022-11-01 04:40:35'),(1667277636021,1657532085455,0,82003,1648471968021,1,'6, 13','methodArgs/0/value: 6\nmethodArgs/1/value: 13','2022-11-01 04:40:36'),(1667277636535,1657532085455,0,82003,1648471968021,1,'9, 17','methodArgs/0/value: 9\nmethodArgs/1/value: 17','2022-11-01 04:40:36'),(1667277636786,1657532085455,0,82003,1648471968021,1,'3, 12','methodArgs/0/value: 3\nmethodArgs/1/value: 12','2022-11-01 04:40:36'),(1667277637772,1657532085455,0,82003,1648471968021,1,'4, 18','methodArgs/0/value: 4\nmethodArgs/1/value: 18','2022-11-01 04:40:37'),(1667277638020,1657532085455,0,82003,1648471968021,1,'7, 14','methodArgs/0/value: 7\nmethodArgs/1/value: 14','2022-11-01 04:40:38'),(1667277638280,1657532085455,0,82003,1648471968021,1,'9, 15','methodArgs/0/value: 9\nmethodArgs/1/value: 15','2022-11-01 04:40:38'),(1667277638682,1657532085455,0,82003,1648471968021,1,'7, 12','methodArgs/0/value: 7\nmethodArgs/1/value: 12','2022-11-01 04:40:38'),(1667277638996,1657532085455,0,82003,1648471968021,1,'2, 16','methodArgs/0/value: 2\nmethodArgs/1/value: 16','2022-11-01 04:40:39'),(1667277639432,1657532085455,0,82003,1648471968021,1,'6, 19','methodArgs/0/value: 6\nmethodArgs/1/value: 19','2022-11-01 04:40:39'),(1667277640485,1657532085455,0,82003,1648471968021,1,'4, 19','methodArgs/0/value: 4\nmethodArgs/1/value: 19','2022-11-01 04:40:40'),(1667277640809,1657532085455,0,82003,1648471968021,1,'7, 16','methodArgs/0/value: 7\nmethodArgs/1/value: 16','2022-11-01 04:40:40'),(1667277641108,1657532085455,0,82003,1648471968021,1,'2, 14','methodArgs/0/value: 2\nmethodArgs/1/value: 14','2022-11-01 04:40:41'),(1667277641907,1657532085455,0,82003,1648471968021,1,'7, 16','methodArgs/0/value: 7\nmethodArgs/1/value: 16','2022-11-01 04:40:41'),(1667277642276,1657532085455,0,82003,1648471968021,1,'8, 19','methodArgs/0/value: 8\nmethodArgs/1/value: 19','2022-11-01 04:40:42'),(1667277642978,1657532085455,0,82003,1648471968021,1,'4, 14','methodArgs/0/value: 4\nmethodArgs/1/value: 14','2022-11-01 04:40:42'),(1667277643997,1657532085455,0,82003,1648471968021,1,'6, 12','methodArgs/0/value: 6\nmethodArgs/1/value: 12','2022-11-01 04:40:44'),(1667277644332,1657532085455,0,82003,1648471968021,1,'6, 16','methodArgs/0/value: 6\nmethodArgs/1/value: 16','2022-11-01 04:40:44'),(1667277645044,1657532085455,0,82003,1648471968021,1,'9, 10','methodArgs/0/value: 9\nmethodArgs/1/value: 10','2022-11-01 04:40:45'),(1667277645446,1657532085455,0,82003,1648471968021,1,'9, 19','methodArgs/0/value: 9\nmethodArgs/1/value: 19','2022-11-01 04:40:45'),(1667277647600,1657532085455,0,82003,1648471968021,1,'2, 14','methodArgs/0/value: 2\nmethodArgs/1/value: 14','2022-11-01 04:40:47'),(1667277647614,1657532085455,0,82003,1648471968021,1,'7, 13','methodArgs/0/value: 7\nmethodArgs/1/value: 13','2022-11-01 04:40:47'),(1667277648168,1657532085455,0,82003,1648471968021,1,'1, 20','methodArgs/0/value: 1\nmethodArgs/1/value: 20','2022-11-01 04:40:48'),(1667277648524,1657532085455,0,82003,1648471968021,1,'10, 13','methodArgs/0/value: 10\nmethodArgs/1/value: 13','2022-11-01 04:40:48'),(1667277649259,1657532085455,0,82003,1648471968021,1,'2, 10','methodArgs/0/value: 2\nmethodArgs/1/value: 10','2022-11-01 04:40:49'),(1667277649625,1657532085455,0,82003,1648471968021,1,'10, 11','methodArgs/0/value: 10\nmethodArgs/1/value: 11','2022-11-01 04:40:49'),(1667277651437,1657532085455,0,82003,1648471968021,1,'6, 20','methodArgs/0/value: 6\nmethodArgs/1/value: 20','2022-11-01 04:40:51'),(1667277651780,1657532085455,0,82003,1648471968021,1,'6, 14','methodArgs/0/value: 6\nmethodArgs/1/value: 14','2022-11-01 04:40:51'),(1667277652075,1657532085455,0,82003,1648471968021,1,'1, 18','methodArgs/0/value: 1\nmethodArgs/1/value: 18','2022-11-01 04:40:52'),(1667277653010,1657532085455,0,82003,1648471968021,1,'7, 16','methodArgs/0/value: 7\nmethodArgs/1/value: 16','2022-11-01 04:40:53'),(1667277653235,1657532085455,0,82003,1648471968021,1,'4, 17','methodArgs/0/value: 4\nmethodArgs/1/value: 17','2022-11-01 04:40:53'),(1667277653490,1657532085455,0,82003,1648471968021,1,'1, 15','methodArgs/0/value: 1\nmethodArgs/1/value: 15','2022-11-01 04:40:53'),(1667277654499,1657532085455,0,82003,1648471968021,1,'8, 16','methodArgs/0/value: 8\nmethodArgs/1/value: 16','2022-11-01 04:40:54'),(1667277654787,1657532085455,0,82003,1648471968021,1,'6, 20','methodArgs/0/value: 6\nmethodArgs/1/value: 20','2022-11-01 04:40:54'),(1667277656305,1657532085455,0,82003,1648471968021,1,'2, 16','methodArgs/0/value: 2\nmethodArgs/1/value: 16','2022-11-01 04:40:56'),(1667277656790,1657532085455,0,82003,1648471968021,1,'8, 14','methodArgs/0/value: 8\nmethodArgs/1/value: 14','2022-11-01 04:40:56'),(1667277657351,1657532085455,0,82003,1648471968021,1,'4, 15','methodArgs/0/value: 4\nmethodArgs/1/value: 15','2022-11-01 04:40:57'),(1667277658860,1657532085455,0,82003,1648471968021,1,'1, 14','methodArgs/0/value: 1\nmethodArgs/1/value: 14','2022-11-01 04:40:58'),(1667277659207,1657532085455,0,82003,1648471968021,1,'5, 14','methodArgs/0/value: 5\nmethodArgs/1/value: 14','2022-11-01 04:40:59'),(1667277660363,1657532085455,0,82003,1648471968021,1,'7, 12','methodArgs/0/value: 7\nmethodArgs/1/value: 12','2022-11-01 04:41:00'),(1667277660739,1657532085455,0,82003,1648471968021,1,'1, 10','methodArgs/0/value: 1\nmethodArgs/1/value: 10','2022-11-01 04:41:00'),(1667277661155,1657532085455,0,82003,1648471968021,1,'4, 19','methodArgs/0/value: 4\nmethodArgs/1/value: 19','2022-11-01 04:41:01'),(1667277661577,1657532085455,0,82003,1648471968021,1,'3, 17','methodArgs/0/value: 3\nmethodArgs/1/value: 17','2022-11-01 04:41:01'),(1667277662735,1657532085455,0,82003,1648471968021,1,'6, 15','methodArgs/0/value: 6\nmethodArgs/1/value: 15','2022-11-01 04:41:02'),(1667277663108,1657532085455,0,82003,1648471968021,1,'10, 12','methodArgs/0/value: 10\nmethodArgs/1/value: 12','2022-11-01 04:41:03'),(1667277663446,1657532085455,0,82003,1648471968021,1,'4, 12','methodArgs/0/value: 4\nmethodArgs/1/value: 12','2022-11-01 04:41:03'),(1667277664572,1657532085455,0,82003,1648471968021,1,'9, 13','methodArgs/0/value: 9\nmethodArgs/1/value: 13','2022-11-01 04:41:04'),(1667277664874,1657532085455,0,82003,1648471968021,1,'4, 12','methodArgs/0/value: 4\nmethodArgs/1/value: 12','2022-11-01 04:41:04'),(1667277666364,1657532085455,0,82003,1648471968021,1,'6, 11','methodArgs/0/value: 6\nmethodArgs/1/value: 11','2022-11-01 04:41:06'),(1667277667106,1657532085455,0,82003,1648471968021,1,'3, 16','methodArgs/0/value: 3\nmethodArgs/1/value: 16','2022-11-01 04:41:07'),(1667277669897,1657532085455,0,82003,1648471968021,1,'2, 15','methodArgs/0/value: 2\nmethodArgs/1/value: 15','2022-11-01 04:41:09'),(1667277672755,1657532085455,0,82003,1648471968021,1,'4, 17','methodArgs/0/value: 4\nmethodArgs/1/value: 17','2022-11-01 04:41:12'),(1667277673586,1657532085455,0,82003,1648471968021,1,'2, 10','methodArgs/0/value: 2\nmethodArgs/1/value: 10','2022-11-01 04:41:13'),(1667277674439,1657532085455,0,82003,1648471968021,1,'5, 17','methodArgs/0/value: 5\nmethodArgs/1/value: 17','2022-11-01 04:41:14'),(1667277674825,1657532085455,0,82003,1648471968021,1,'8, 19','methodArgs/0/value: 8\nmethodArgs/1/value: 19','2022-11-01 04:41:14'),(1667277742221,1657532085455,0,82001,1648471968021,1,'6, 15','methodArgs/0/value: 6\nmethodArgs/1/value: 15','2022-11-01 04:42:22'),(1667277742825,1657532085455,0,82001,1648471968021,1,'8, 12','methodArgs/0/value: 8\nmethodArgs/1/value: 12','2022-11-01 04:42:22'),(1667277743183,1657532085455,0,82001,1648471968021,1,'1, 14','methodArgs/0/value: 1\nmethodArgs/1/value: 14','2022-11-01 04:42:23'),(1667277744288,1657532085455,0,82001,1648471968021,1,'3, 15','methodArgs/0/value: 3\nmethodArgs/1/value: 15','2022-11-01 04:42:24'),(1667382803181,0,0,82001,1634724321770,50,'ORDER_INT(-100, 10000)/1000','methodArgs/0/value: ORDER_INT(-100, 10000)/1000 + \'\'','2022-11-02 09:53:23'),(1667382864199,1667382803181,0,82001,1634724321770,1,'-0.1','methodArgs/0/value: \"-0.1\"','2022-11-02 09:54:24'),(1667382864481,1667382803181,0,82001,1634724321770,1,'-0.099','methodArgs/0/value: \"-0.099\"','2022-11-02 09:54:24'),(1667382865714,1667382803181,0,82001,1634724321770,1,'-0.097','methodArgs/0/value: \"-0.097\"','2022-11-02 09:54:25'),(1667382866203,1667382803181,0,82001,1634724321770,1,'-0.098','methodArgs/0/value: \"-0.098\"','2022-11-02 09:54:26'),(1667382866689,1667382803181,0,82001,1634724321770,1,'-0.096','methodArgs/0/value: \"-0.096\"','2022-11-02 09:54:26'),(1667382866984,1667382803181,0,82001,1634724321770,1,'-0.095','methodArgs/0/value: \"-0.095\"','2022-11-02 09:54:27'),(1667382867759,1667382803181,0,82001,1634724321770,1,'-0.089','methodArgs/0/value: \"-0.089\"','2022-11-02 09:54:27'),(1667382868052,1667382803181,0,82001,1634724321770,1,'-0.09','methodArgs/0/value: \"-0.09\"','2022-11-02 09:54:28'),(1667382868424,1667382803181,0,82001,1634724321770,1,'-0.091','methodArgs/0/value: \"-0.091\"','2022-11-02 09:54:28'),(1667382868840,1667382803181,0,82001,1634724321770,1,'-0.092','methodArgs/0/value: \"-0.092\"','2022-11-02 09:54:28'),(1667382869273,1667382803181,0,82001,1634724321770,1,'-0.093','methodArgs/0/value: \"-0.093\"','2022-11-02 09:54:29'),(1667382870122,1667382803181,0,82001,1634724321770,1,'-0.094','methodArgs/0/value: \"-0.094\"','2022-11-02 09:54:30'),(1667382871236,1667382803181,0,82001,1634724321770,1,'-0.083','methodArgs/0/value: \"-0.083\"','2022-11-02 09:54:31'),(1667382871549,1667382803181,0,82001,1634724321770,1,'-0.084','methodArgs/0/value: \"-0.084\"','2022-11-02 09:54:31'),(1667382872431,1667382803181,0,82001,1634724321770,1,'-0.086','methodArgs/0/value: \"-0.086\"','2022-11-02 09:54:32'),(1667382872775,1667382803181,0,82001,1634724321770,1,'-0.087','methodArgs/0/value: \"-0.087\"','2022-11-02 09:54:32'),(1667382873360,1667382803181,0,82001,1634724321770,1,'-0.085','methodArgs/0/value: \"-0.085\"','2022-11-02 09:54:33'),(1667382874388,1667382803181,0,82001,1634724321770,1,'-0.088','methodArgs/0/value: \"-0.088\"','2022-11-02 09:54:34'),(1667382876235,1667382803181,0,82001,1634724321770,1,'-0.077','methodArgs/0/value: \"-0.077\"','2022-11-02 09:54:36'),(1667382876529,1667382803181,0,82001,1634724321770,1,'-0.078','methodArgs/0/value: \"-0.078\"','2022-11-02 09:54:36'),(1667382877500,1667382803181,0,82001,1634724321770,1,'-0.079','methodArgs/0/value: \"-0.079\"','2022-11-02 09:54:37'),(1667382878122,1667382803181,0,82001,1634724321770,1,'-0.08','methodArgs/0/value: \"-0.08\"','2022-11-02 09:54:38'),(1667382879890,1667382803181,0,82001,1634724321770,1,'-0.076','methodArgs/0/value: \"-0.076\"','2022-11-02 09:54:39'),(1667382915549,0,0,82001,1634724321770,50,'RANDOM_INT(-100, 10000)/1000','methodArgs/0/value: RANDOM_INT(-100, 10000)/1000 + \'\'','2022-11-02 09:55:15'),(1667382934335,1667382915549,0,82001,1634724321770,1,'0.484','methodArgs/0/value: \"0.484\"','2022-11-02 09:55:34'),(1667382940787,1667382915549,0,82001,1634724321770,1,'1.047','methodArgs/0/value: \"1.047\"','2022-11-02 09:55:40'),(1667382945603,1667382915549,0,82001,1634724321770,1,'7.735','methodArgs/0/value: \"7.735\"','2022-11-02 09:55:45'),(1667382947849,1667382915549,0,82001,1634724321770,1,'4.087','methodArgs/0/value: \"4.087\"','2022-11-02 09:55:47'),(1667382956747,1667382915549,0,82001,1634724321770,1,'-0.045','methodArgs/0/value: \"-0.045\"','2022-11-02 09:55:56'),(1667382958568,1667382915549,0,82001,1634724321770,1,'9.24','methodArgs/0/value: \"9.24\"','2022-11-02 09:55:58'),(1667382959770,1667382915549,0,82001,1634724321770,1,'3.408','methodArgs/0/value: \"3.408\"','2022-11-02 09:55:59'),(1667382960606,1667382915549,0,82001,1634724321770,1,'0.049','methodArgs/0/value: \"0.049\"','2022-11-02 09:56:00'),(1667382961518,1667382915549,0,82001,1634724321770,1,'7.944','methodArgs/0/value: \"7.944\"','2022-11-02 09:56:01'),(1667383482020,1667382915549,0,82001,1634724321770,1,'6.614','methodArgs/0/value: \"6.614\"','2022-11-02 10:04:42'),(1667383482287,1667382915549,0,82001,1634724321770,1,'8.014','methodArgs/0/value: \"8.014\"','2022-11-02 10:04:42'),(1667383485433,1667382915549,0,82001,1634724321770,1,'1.226','methodArgs/0/value: \"1.226\"','2022-11-02 10:04:45'),(1667383488638,1667382915549,0,82001,1634724321770,1,'9.994','methodArgs/0/value: \"9.994\"','2022-11-02 10:04:48'),(1667383490357,1667382915549,0,82001,1634724321770,1,'7.102','methodArgs/0/value: \"7.102\"','2022-11-02 10:04:50'),(1667383492713,1667382915549,0,82001,1634724321770,1,'7.128','methodArgs/0/value: \"7.128\"','2022-11-02 10:04:52'),(1667383493056,1667382915549,0,82001,1634724321770,1,'8.911','methodArgs/0/value: \"8.911\"','2022-11-02 10:04:53'),(1667383496539,1667382915549,0,82001,1634724321770,1,'4.073','methodArgs/0/value: \"4.073\"','2022-11-02 10:04:56'),(1667383497221,1667382915549,0,82001,1634724321770,1,'9.004','methodArgs/0/value: \"9.004\"','2022-11-02 10:04:57'),(1667383499501,1667382915549,0,82001,1634724321770,1,'0.343','methodArgs/0/value: \"0.343\"','2022-11-02 10:04:59'),(1667383499947,1667382915549,0,82001,1634724321770,1,'9.564','methodArgs/0/value: \"9.564\"','2022-11-02 10:04:59'),(1667383500869,1667382915549,0,82001,1634724321770,1,'4.632','methodArgs/0/value: \"4.632\"','2022-11-02 10:05:00'),(1667383501470,1667382915549,0,82001,1634724321770,1,'7.253','methodArgs/0/value: \"7.253\"','2022-11-02 10:05:01'),(1667383502862,1667382915549,0,82001,1634724321770,1,'4.613','methodArgs/0/value: \"4.613\"','2022-11-02 10:05:02'),(1667383503207,1667382915549,0,82001,1634724321770,1,'9.003','methodArgs/0/value: \"9.003\"','2022-11-02 10:05:03'),(1667383504347,1667382915549,0,82001,1634724321770,1,'2.798','methodArgs/0/value: \"2.798\"','2022-11-02 10:05:04'),(1667383504674,1667382915549,0,82001,1634724321770,1,'6.432','methodArgs/0/value: \"6.432\"','2022-11-02 10:05:04'),(1667383505994,1667382915549,0,82001,1634724321770,1,'4.539','methodArgs/0/value: \"4.539\"','2022-11-02 10:05:06'),(1667383507275,1667382915549,0,82001,1634724321770,1,'8.752','methodArgs/0/value: \"8.752\"','2022-11-02 10:05:07'),(1667383507659,1667382915549,0,82001,1634724321770,1,'3.86','methodArgs/0/value: \"3.86\"','2022-11-02 10:05:07'),(1667383509355,1667382915549,0,82001,1634724321770,1,'8.202','methodArgs/0/value: \"8.202\"','2022-11-02 10:05:09'),(1667383509717,1667382915549,0,82001,1634724321770,1,'3.12','methodArgs/0/value: \"3.12\"','2022-11-02 10:05:09'),(1667383510946,1667382915549,0,82001,1634724321770,1,'3.614','methodArgs/0/value: \"3.614\"','2022-11-02 10:05:10'),(1667383511582,1667382915549,0,82001,1634724321770,1,'6.017','methodArgs/0/value: \"6.017\"','2022-11-02 10:05:11'),(1667383512972,1667382915549,0,82001,1634724321770,1,'9.327','methodArgs/0/value: \"9.327\"','2022-11-02 10:05:12'),(1667383513397,1667382915549,0,82001,1634724321770,1,'2.328','methodArgs/0/value: \"2.328\"','2022-11-02 10:05:13'),(1667383521818,1667382915549,0,82001,1634724321770,1,'1.794','methodArgs/0/value: \"1.794\"','2022-11-02 10:05:21'),(1667383522256,1667382915549,0,82001,1634724321770,1,'0.45','methodArgs/0/value: \"0.45\"','2022-11-02 10:05:22'),(1667383523110,1667382915549,0,82001,1634724321770,1,'7.217','methodArgs/0/value: \"7.217\"','2022-11-02 10:05:23'),(1667383624762,0,0,82001,1634724321770,3,'ORDER_IN(\'2.025\', \'-1.9\', \'5.145\')','methodArgs/0/value: ORDER_IN(\'2.025\', \'-1.9\', \'5.145\')','2022-11-02 10:07:04'),(1667383651006,1667383624762,0,82001,1634724321770,1,'2.025','methodArgs/0/value: \"2.025\"','2022-11-02 10:07:31'),(1667383651420,1667383624762,0,82001,1634724321770,1,'-1.9','methodArgs/0/value: \"-1.9\"','2022-11-02 10:07:31'),(1667383651813,1667383624762,0,82001,1634724321770,1,'5.145','methodArgs/0/value: \"5.145\"','2022-11-02 10:07:31'),(1667384116837,1667382915549,0,82001,1634724321770,1,'6.84','methodArgs/0/value: \"6.84\"','2022-11-02 10:15:16'),(1667384118148,1667382915549,0,82001,1634724321770,1,'2.028','methodArgs/0/value: \"2.028\"','2022-11-02 10:15:18'),(1667787712970,0,0,82001,1522905868719,1,'随机配置 2022-11-07 10:21','','2022-11-07 02:21:52'),(1681237271734,0,2,82001,1634655384665,1,'[Record] Apr 12, 2023, 2:21:10 AM','User/id: 82001\nquery: 2','2023-04-11 18:21:11'),(1681237352630,0,2,82001,1634655384665,1,'[Record] Apr 12, 2023, 2:22:32 AM','User/id: 82001\nquery: 2','2023-04-11 18:22:32'),(1681237353314,0,2,82001,1634655384665,1,'[Record] Apr 12, 2023, 2:22:33 AM','User/id: 82001\nquery: 2','2023-04-11 18:22:33'),(1681237391684,0,2,82001,1634655384665,1,'[Record] Apr 12, 2023, 2:23:11 AM','User/id: 82001\nquery: 2','2023-04-11 18:23:11'),(1681237460778,0,2,82001,1521901518765,1,'[Record] Apr 12, 2023, 2:24:20 AM','[]/page: 0\n[]/count: 2\n[]/Moment/content$/0: %a%\n[]/Moment/content$/1: %p\n[]/Moment/content$/2: i%\n[]/User/id@: /Moment/userId\n[]/User/@column: id,name,head\n[]/Comment[]/count: 2\n[]/Comment[]/Comment/momentId@: []/Moment/id','2023-04-11 18:24:20'),(1681239690813,0,2,82001,1,1,'[Record] Apr 12, 2023, 3:01:30 AM','type: 0\nphone: \"13000082001\"\npassword: \"123456\"\nversion: 1\nremember: false\nformat: false\ndefaults/@database: \"MYSQL\"\ndefaults/@schema: \"sys\"','2023-04-11 19:01:30'),(1681239718224,0,2,82001,1,1,'[Record] Apr 12, 2023, 3:01:58 AM','type: 0\nphone: \"13000082001\"\npassword: \"123456\"\nversion: 1\nremember: false\nformat: false\ndefaults/@database: \"MYSQL\"\ndefaults/@schema: \"sys\"','2023-04-11 19:01:58'),(1681240443306,0,2,82001,1,1,'[Record] Apr 12, 2023, 3:14:03 AM','type: 0\nphone: \"13000082001\"\npassword: \"123456\"\nversion: 1\nremember: false\nformat: false\ndefaults/@database: \"MYSQL\"\ndefaults/@schema: \"sys\"','2023-04-11 19:14:03'),(1681241064182,0,2,82001,1521901518765,1,'[Record] Apr 12, 2023, 3:24:24 AM','User/id: 82001','2023-04-11 19:24:24'),(1681313201857,0,2,82003,1663749767546,1,'[Record] Apr 12, 2023, 11:26:05 PM','sql: \"\nSELECT  `Comment`.`userId`, `User`.`id`, COUNT(1)\nFROM `sys`.`Comment` AS `Comment`\nINNER JOIN `sys`.`apijson_user` AS `User`\n  ON `User`.`id` = `Comment`.`userId`\n    AND `User`.`name` LIKE ?\nGROUP BY `User`.`id` HAVING ((`User`.`id`) % ? != 0)\nORDER BY `User`.`id` ASC LIMIT ? OFFSET ?\"\nargs: []\nargs/0: \"%a%\"\nargs/1: 82001\nargs/2: 3\nargs/3: 0\nuri: \"jdbc:mysql://localhost:3306/sys\"\naccount: \"13000082003\"\npassword: \"123456\"','2023-04-12 15:26:41'),(1681313232096,0,2,82003,1663749767546,1,'[Record] Apr 12, 2023, 11:27:11 PM','sql: \"\nSELECT  `Comment`.`userId`, `User`.`id`, COUNT(1)\nFROM `sys`.`Comment` AS `Comment`\nINNER JOIN `sys`.`apijson_user` AS `User`\n  ON `User`.`id` = `Comment`.`userId`\n    AND `User`.`name` LIKE ?\nGROUP BY `User`.`id` HAVING ((`User`.`id`) % ? != 0)\nORDER BY `User`.`id` ASC LIMIT ? OFFSET ?\"\nargs: []\nargs/0: \"%a%\"\nargs/1: 82001\nargs/2: 3\nargs/3: 0\nuri: \"jdbc:mysql://localhost:3306/sys\"\naccount: \"13000082003\"\npassword: \"123456\"','2023-04-12 15:27:12'),(1681313360272,0,2,82003,1663749767546,1,'[Record] Apr 12, 2023, 11:29:20 PM','sql: \"\nSELECT  `Comment`.`userId`, `User`.`id`, COUNT(1)\nFROM `sys`.`Comment` AS `Comment`\nINNER JOIN `sys`.`apijson_user` AS `User`\n  ON `User`.`id` = `Comment`.`userId`\n    AND `User`.`name` LIKE ?\nGROUP BY `User`.`id` HAVING ((`User`.`id`) % ? != 0)\nORDER BY `User`.`id` ASC LIMIT ? OFFSET ?\"\nargs: []\nargs/0: \"%a%\"\nargs/1: 82001\nargs/2: 3\nargs/3: 0\nuri: \"jdbc:mysql://localhost:3306/sys\"\naccount: \"13000082003\"\npassword: \"123456\"','2023-04-12 15:29:20'),(1681314782497,0,2,82003,1663749767546,1,'[Record] Apr 12, 2023, 11:52:54 PM','sql: \"\nSELECT  `Comment`.`userId`, `User`.`id`, COUNT(1)\nFROM `sys`.`Comment` AS `Comment`\nINNER JOIN `sys`.`apijson_user` AS `User`\n  ON `User`.`id` = `Comment`.`userId`\n    AND `User`.`name` LIKE ?\nGROUP BY `User`.`id` HAVING ((`User`.`id`) % ? != 0)\nORDER BY `User`.`id` ASC LIMIT ? OFFSET ?\"\nargs: []\nargs/0: \"%a%\"\nargs/1: 82001\nargs/2: 3\nargs/3: 0\nuri: \"jdbc:mysql://localhost:3306/sys\"\naccount: \"13000082003\"\npassword: \"123456\"','2023-04-12 15:53:02'),(1681315013281,0,2,82003,1663749767546,1,'[Record] Apr 12, 2023, 11:56:52 PM','sql: \"\nSELECT  `Comment`.`userId`, `User`.`id`, COUNT(1)\nFROM `sys`.`Comment` AS `Comment`\nINNER JOIN `sys`.`apijson_user` AS `User`\n  ON `User`.`id` = `Comment`.`userId`\n    AND `User`.`name` LIKE ?\nGROUP BY `User`.`id` HAVING ((`User`.`id`) % ? != 0)\nORDER BY `User`.`id` ASC LIMIT ? OFFSET ?\"\nargs: []\nargs/0: \"%a%\"\nargs/1: 82001\nargs/2: 3\nargs/3: 0\nuri: \"jdbc:mysql://localhost:3306/sys\"\naccount: \"13000082003\"\npassword: \"123456\"','2023-04-12 15:56:53'),(1681315083834,0,2,82003,1663749767546,1,'[Record] Apr 12, 2023, 11:57:42 PM','sql: \"\nSELECT  `Comment`.`userId`, `User`.`id`, COUNT(1)\nFROM `sys`.`Comment` AS `Comment`\nINNER JOIN `sys`.`apijson_user` AS `User`\n  ON `User`.`id` = `Comment`.`userId`\n    AND `User`.`name` LIKE ?\nGROUP BY `User`.`id` HAVING ((`User`.`id`) % ? != 0)\nORDER BY `User`.`id` ASC LIMIT ? OFFSET ?\"\nargs: []\nargs/0: \"%a%\"\nargs/1: 82001\nargs/2: 3\nargs/3: 0\nuri: \"jdbc:mysql://localhost:3306/sys\"\naccount: \"13000082003\"\npassword: \"123456\"','2023-04-12 15:58:04'),(1681316646469,0,2,82001,1652079373276,1,'[Record] Apr 13, 2023, 12:24:06 AM','type: 0\nphone: \"13000082001\"\npassword: \"123456\"\nversion: 1\nremember: false\nformat: false\ndefaults/@database: \"MYSQL\"\ndefaults/@schema: \"sys\"','2023-04-12 16:24:06'),(1681316727547,0,2,82001,1666202661817,1,'[Record] Apr 13, 2023, 12:24:45 AM','[]/page: 0\n[]/count: 2\n[]/Moment/content$: []\n[]/Moment/content$/0: \"%a%\"\n[]/Moment/content$/1: \"_p\"\n[]/Moment/content$/2: \"p%\"\n[]/User/id@: \"/Moment/userId\"\n[]/User/@column: \"id,name,head\"\n[]/Comment[]/count: 3\n[]/Comment[]/Comment/momentId@: \"[]/Moment/id\"','2023-04-12 16:25:27'),(1681316828475,0,2,82001,1681316780239,1,'[Record] Apr 13, 2023, 12:26:53 AM','[]/page: 0\n[]/count: 2\n[]/Moment/content$: []\n[]/Moment/content$/0: \"%a%\"\n[]/Moment/content$/1: \"_p\"\n[]/Moment/content$/2: \"p%\"\n[]/User/id@: \"/Moment/userId\"\n[]/User/@column: \"id,name,head\"\n[]/Comment[]/count: 3\n[]/Comment[]/Comment/momentId@: \"[]/Moment/id\"','2023-04-12 16:27:08'),(1681316856663,0,2,82001,1681316780239,1,'[Record] Apr 13, 2023, 12:27:36 AM','[]/page: 0\n[]/count: 2\n[]/Moment/content$: []\n[]/Moment/content$/0: \"%a%\"\n[]/Moment/content$/1: \"_p\"\n[]/Moment/content$/2: \"p%\"\n[]/User/id@: \"/Moment/userId\"\n[]/User/@column: \"id,name,head\"\n[]/Comment[]/count: 3\n[]/Comment[]/Comment/momentId@: \"[]/Moment/id\"','2023-04-12 16:27:36'),(1681476492850,0,0,82001,1634655384665,1,'随机配置 2023-04-14 20:48','User/id: 82001','2023-04-14 12:48:12'),(1681476497432,0,0,82001,1634655384665,1,'随机配置 2023-04-14 20:48','User/id: 82001','2023-04-14 12:48:17'),(1681476777796,0,0,82001,1681316780239,1,'随机配置 2023-04-14 20:52','[]/page: 0\n[]/count: 3\n[]/Moment/content$: []\n[]/Moment/content$/0: \"%a%\"\n[]/Moment/content$/1: \"_p\"\n[]/Moment/content$/2: \"i%\"\n[]/User/id@: \"/Moment/userId\"\n[]/User/@column: \"id,name,head\"\n[]/Comment[]/count: 3\n[]/Comment[]/Comment/momentId@: \"[]/Moment/id\"','2023-04-14 12:52:57'),(1686480606316,0,0,82001,1686480606291,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 10:50:06'),(1686480606317,0,0,82001,1686480606291,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 10:50:06'),(1686480606318,0,0,82001,1686480606295,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: RANDOM_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: RANDOM_IN(undefined, null, \"\", \"a\")','2023-06-11 10:50:06'),(1686480606319,0,0,82001,1686480606295,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: ORDER_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: ORDER_IN(undefined, null, \"\", \"a\")','2023-06-11 10:50:06'),(1686480606327,0,0,82001,1686480606293,5,'默认配置(上传测试用例时自动生成)','userId: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 serId: RANDOM_INT(1, 820010)\nmomentId: ORDER_IN(undefined, null, 15)\n// 可替代上面的 omentId: RANDOM_INT(1, 150)\ncontent: ORDER_IN(undefined, null, \"\", \"测试评论\")','2023-06-11 10:50:06'),(1686480606331,0,0,82001,1686480606293,5,'默认配置(上传测试用例时自动生成)','userId: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 serId: RANDOM_INT(1, 820010)\nmomentId: RANDOM_IN(undefined, null, 15)\n// 可替代上面的 omentId: RANDOM_INT(1, 150)\ncontent: RANDOM_IN(undefined, null, \"\", \"测试评论\")','2023-06-11 10:50:06'),(1686480682670,0,0,82001,1686480682648,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: ORDER_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: ORDER_IN(undefined, null, \"\", \"a\")','2023-06-11 10:51:22'),(1686480682671,0,0,82001,1686480682648,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: RANDOM_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: RANDOM_IN(undefined, null, \"\", \"a\")','2023-06-11 10:51:22'),(1686480682672,0,0,82001,1686480682649,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 10:51:22'),(1686480682673,0,0,82001,1686480682649,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 10:51:22'),(1686480682681,0,0,82001,1686480682650,5,'默认配置(上传测试用例时自动生成)','userId: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 serId: RANDOM_INT(1, 820010)\nmomentId: ORDER_IN(undefined, null, 15)\n// 可替代上面的 omentId: RANDOM_INT(1, 150)\ncontent: ORDER_IN(undefined, null, \"\", \"测试评论\")','2023-06-11 10:51:22'),(1686480682682,0,0,82001,1686480682650,5,'默认配置(上传测试用例时自动生成)','userId: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 serId: RANDOM_INT(1, 820010)\nmomentId: RANDOM_IN(undefined, null, 15)\n// 可替代上面的 omentId: RANDOM_INT(1, 150)\ncontent: RANDOM_IN(undefined, null, \"\", \"测试评论\")','2023-06-11 10:51:22'),(1686480747010,0,0,82001,1686480746992,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 10:52:27'),(1686480747011,0,0,82001,1686480746992,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 10:52:27'),(1686480747012,0,0,82001,1686480746991,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: RANDOM_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: RANDOM_IN(undefined, null, \"\", \"a\")','2023-06-11 10:52:27'),(1686480747013,0,0,82001,1686480746991,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: ORDER_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: ORDER_IN(undefined, null, \"\", \"a\")','2023-06-11 10:52:27'),(1686480747028,0,0,82001,1686480746993,5,'默认配置(上传测试用例时自动生成)','userId: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 serId: RANDOM_INT(1, 820010)\nmomentId: ORDER_IN(undefined, null, 15)\n// 可替代上面的 omentId: RANDOM_INT(1, 150)\ncontent: ORDER_IN(undefined, null, \"\", \"测试评论\")','2023-06-11 10:52:27'),(1686480747029,0,0,82001,1686480746993,5,'默认配置(上传测试用例时自动生成)','userId: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 serId: RANDOM_INT(1, 820010)\nmomentId: RANDOM_IN(undefined, null, 15)\n// 可替代上面的 omentId: RANDOM_INT(1, 150)\ncontent: RANDOM_IN(undefined, null, \"\", \"测试评论\")','2023-06-11 10:52:27'),(1686480929187,0,0,82001,1686480929079,1,'默认配置(上传测试用例时自动生成)','User/id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 ser/id: RANDOM_INT(1, 820010)','2023-06-11 10:55:29'),(1686481283863,0,0,82001,1686481274193,1,'默认配置','User/id: ORDER_BAD_NUM+181()\n\n\n[]/Comment/userId@: ORDER_BAD_STR+587()','2023-06-11 11:01:23'),(1686481320279,0,0,82001,1686481320181,1,'默认配置(上传测试用例时自动生成)','type: RANDOM_INT(0, 10)\n// 可替代上面的 ype: RANDOM_INT(0, 100)\nphone: RANDOM_IN(undefined, null, \"\", \"13000082001\")\npassword: RANDOM_IN(undefined, null, \"\", \"123456\")\nremember: RANDOM_IN(undefined, null, false, true)','2023-06-11 11:02:00'),(1686481320280,0,0,82001,1686481320181,1,'默认配置(上传测试用例时自动生成)','type: ORDER_INT(0, 10)\n// 可替代上面的 ype: RANDOM_INT(0, 100)\nphone: ORDER_IN(undefined, null, \"\", \"13000082001\")\npassword: ORDER_IN(undefined, null, \"\", \"123456\")\nremember: ORDER_IN(undefined, null, false, true)','2023-06-11 11:02:00'),(1686494708755,0,0,82001,1638254136616,1,'常量取值 2023-06-11 22:45','pageSize: 10\npageNum: 1\nsearchKey: \"a\"','2023-06-11 14:45:08'),(1686494708758,0,0,82001,1638254136620,1,'常量取值 2023-06-11 22:45','id: 82001','2023-06-11 14:45:08'),(1686494708760,0,0,82001,1638254136621,1,'常量取值 2023-06-11 22:45','userId: 82001\nmomentId: 15\ncontent: \"测试评论\"','2023-06-11 14:45:08'),(1686494737307,0,0,82001,1638254136621,1,'常量取值 2023-06-11 22:45','userId: 82001\nmomentId: 15\ncontent: \"测试评论\"','2023-06-11 14:45:37'),(1686494737310,0,0,82001,1638254136616,1,'常量取值 2023-06-11 22:45','pageSize: 10\npageNum: 1\nsearchKey: \"a\"','2023-06-11 14:45:37'),(1686494737315,0,0,82001,1638254136620,1,'常量取值 2023-06-11 22:45','id: 82001','2023-06-11 14:45:37'),(1686495092656,0,0,82001,1686495087795,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: RANDOM_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: RANDOM_IN(undefined, null, \"\", \"a\")','2023-06-11 14:51:32'),(1686495092660,0,0,82001,1686495087795,5,'默认配置(上传测试用例时自动生成)','pageSize: RANDOM_INT(0, 100)\npageNum: ORDER_INT(0, 10)\n// 可替代上面的 ageNum: RANDOM_INT(0, 100)\nsearchKey: ORDER_IN(undefined, null, \"\", \"a\")','2023-06-11 14:51:32'),(1686495092664,0,0,82001,1686495087797,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 14:51:32'),(1686495092665,0,0,82001,1686495087797,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 14:51:32'),(1686495158461,0,0,82001,1686495087797,1,'常量取值 2023-06-11 22:52','id: 82001','2023-06-11 14:52:38'),(1686495158465,0,0,82001,1686495087795,1,'常量取值 2023-06-11 22:52','pageSize: 10\npageNum: 1\nsearchKey: \"a\"','2023-06-11 14:52:38'),(1686495330298,0,0,82001,1686495087797,1,'常量取值 2023-06-11 22:55','id: 82001','2023-06-11 14:55:30'),(1686496114291,0,0,82001,1686496114264,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:08:34'),(1686496114292,0,0,82001,1686496114264,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:08:34'),(1686496132505,0,0,82001,1686496132482,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:08:52'),(1686496132506,0,0,82001,1686496132482,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:08:52'),(1686496190829,0,0,82001,1686496183455,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:09:50'),(1686496190830,0,0,82001,1686496183455,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:09:50'),(1686496355085,0,0,82001,1686496183455,1,'常量取值 2023-06-11 23:12','id: 82001','2023-06-11 15:12:35'),(1686496629174,0,0,82001,1686496629036,1,'默认配置(上传测试用例时自动生成)','User/id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 ser/id: RANDOM_INT(1, 820010)','2023-06-11 15:17:09'),(1686496629175,0,0,82001,1686496629036,1,'默认配置(上传测试用例时自动生成)','User/id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 ser/id: RANDOM_INT(1, 820010)','2023-06-11 15:17:09'),(1686496646222,0,0,82001,1686496646071,1,'默认配置(上传测试用例时自动生成)','[]/page: ORDER_INT(0, 10)\n// 可替代上面的 ]/page: RANDOM_INT(0, 100)\n[]/count: ORDER_INT(0, 10)\n// 可替代上面的 ]/count: RANDOM_INT(0, 100)\n\n[]/Moment/content$: []\n[]/Moment/content$/0: ORDER_IN(undefined, null, \"\", \"%a%\")\n[]/Moment/content$/1: ORDER_IN(undefined, null, \"\", \"_p\")\n[]/Moment/content$/2: ORDER_IN(undefined, null, \"\", \"p%\")\n\n[]/Comment[]/count: ORDER_INT(0, 10)\n// 可替代上面的 ]/Comment[]/count: RANDOM_INT(0, 100)','2023-06-11 15:17:26'),(1686496646223,0,0,82001,1686496646071,1,'默认配置(上传测试用例时自动生成)','[]/page: RANDOM_INT(0, 10)\n// 可替代上面的 ]/page: RANDOM_INT(0, 100)\n[]/count: RANDOM_INT(0, 10)\n// 可替代上面的 ]/count: RANDOM_INT(0, 100)\n\n[]/Moment/content$: []\n[]/Moment/content$/0: RANDOM_IN(undefined, null, \"\", \"%a%\")\n[]/Moment/content$/1: RANDOM_IN(undefined, null, \"\", \"_p\")\n[]/Moment/content$/2: RANDOM_IN(undefined, null, \"\", \"p%\")\n\n[]/Comment[]/count: RANDOM_INT(0, 10)\n// 可替代上面的 ]/Comment[]/count: RANDOM_INT(0, 100)','2023-06-11 15:17:26'),(1686496692780,0,0,82001,1686496692757,5,'默认配置(上传测试用例时自动生成)','id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:18:12'),(1686496692781,0,0,82001,1686496692757,5,'默认配置(上传测试用例时自动生成)','id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 d: RANDOM_INT(1, 820010)','2023-06-11 15:18:12'),(1690218398350,0,0,82001,1690218398316,1,'默认配置(上传测试用例时自动生成)','static: ORDER_IN(undefined, null, false, true)\nmethodArgs: ORDER_IN(undefined, null, [], [{\"type\":\"str\",\"value\":\"{\\\"a\\\":1}\"}])','2023-07-24 17:06:38'),(1693732583234,0,0,82001,1693732583023,1,'默认配置(上传测试用例时自动生成)','User:count/id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 ser:count/id: RANDOM_INT(1, 820010)\nUser:count/name: RANDOM_IN(undefined, null, \"\", \"Test User\")\n\n@gets/Privacy: RANDOM_IN(undefined, null, \"\", \"Privacy-CIRCLE\")\n\n@gets/User/tag: RANDOM_IN(undefined, null, \"\", \"User\")\n\nPrivacy/id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 rivacy/id: RANDOM_INT(1, 820010)','2023-09-03 09:16:23'),(1693732610780,0,0,88888,1693732610612,1,'默认配置(上传测试用例时自动生成)','User:count/id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 ser:count/id: RANDOM_INT(1, 820010)\nUser:count/name: RANDOM_IN(undefined, null, \"\", \"Test User\")\n\n@gets/Privacy: RANDOM_IN(undefined, null, \"\", \"Privacy-CIRCLE\")\n\n@gets/User/tag: RANDOM_IN(undefined, null, \"\", \"User\")\n\nPrivacy/id: RANDOM_IN(undefined, null, 82001)\n// 可替代上面的 rivacy/id: RANDOM_INT(1, 820010)','2023-09-03 09:16:50'),(1693732610781,0,0,88888,1693732610612,1,'默认配置(上传测试用例时自动生成)','User:count/id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 ser:count/id: RANDOM_INT(1, 820010)\nUser:count/name: ORDER_IN(undefined, null, \"\", \"Test User\")\n\n@gets/Privacy: ORDER_IN(undefined, null, \"\", \"Privacy-CIRCLE\")\n\n@gets/User/tag: ORDER_IN(undefined, null, \"\", \"User\")\n\nPrivacy/id: ORDER_IN(undefined, null, 82001)\n// 可替代上面的 rivacy/id: RANDOM_INT(1, 820010)','2023-09-03 09:16:50'),(1699781347044,0,0,82001,1699781346862,1,'默认配置','User/id: RANDOM_INT(82001, 82020) // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {}) // 随机取值\n[]/page: Math.round(5*Math.random()) // 通过代码来自定义\n@explain: ORDER_IN(true, false) // 顺序取值\n// 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n// 回车智能生成。注释可省略，未省略则前面必须空格；清空文本内容可查看规则。\n\n// ## 快捷键\n// Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n// Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n// Ctrl + D 或 Command + D 删除 选中行；\n// Ctrl + S 或 Command + S 保存当前请求；\n                        ','2023-11-12 09:29:07'),(1699782921840,0,0,82001,1699782921672,1,'默认配置','User/id: RANDOM_INT(82001, 82020) // 随机整数\n[]/count: RANDOM_IN(5, 10, \'s\', false, [], {}) // 随机取值\n[]/page: Math.round(5*Math.random()) // 通过代码来自定义\n@explain: ORDER_IN(true, false) // 顺序取值\n// 从数据库随机取值  []/Comment/toId: RANDOM_DB()\n\n// 回车智能生成。注释可省略，未省略则前面必须空格；清空文本内容可查看规则。\n\n// ## 快捷键\n// Ctrl + I 或 Command + I 格式化文本，清除所有注释和无效空格、换行等；\n// Ctrl + / 或 Command + / 对选中行 新增行注释 或 取消行注释；\n// Ctrl + D 或 Command + D 删除 选中行；\n// Ctrl + S 或 Command + S 保存当前请求；\n                        ','2023-11-12 09:55:21'),(1703490140837,1657117214268,0,82001,1657045372046,1,'undefined','User/id: null','2023-12-25 07:42:20'),(1703490140840,0,0,82001,1659345236492,10,'非法参数','methodArgs/0/value/id: ORDER_BAD_NUM-593()\nmethodArgs/0/value/name: ORDER_BAD_STR-1231()','2024-01-19 06:41:42'),(1703490140841,1703490140840,0,82001,1659345236492,1,'undefined, undefined','methodArgs/0/value/id: undefined\nmethodArgs/0/value/name: undefined','2024-01-19 06:41:49'),(1703490140842,1703490140840,0,82001,1659345236492,1,'1, 90071..','methodArgs/0/value/id: \"1\"\nmethodArgs/0/value/name: 9007199254740992','2024-01-19 06:41:51'),(1703490140843,1703490140840,0,82001,1659345236492,1,'0, 90071..','methodArgs/0/value/id: 0\nmethodArgs/0/value/name: \"9007199254740991\"','2024-01-19 06:41:52'),(1703490140844,1703490140840,0,82001,1659345236492,1,'\\r, ]','methodArgs/0/value/id: \"\\r\"\nmethodArgs/0/value/name: \"]\"','2024-01-19 06:41:57'),(1703490140845,1703490140840,0,82001,1659345236492,1,'true, \\t','methodArgs/0/value/id: \"true\"\nmethodArgs/0/value/name: \"\\t\"','2024-01-19 06:42:12'),(1703490140846,1703490140840,0,82001,1659345236492,1,'2049, false','methodArgs/0/value/id: \"2049\"\nmethodArgs/0/value/name: false','2024-01-19 06:42:15'),(1703490140847,1703490140840,0,82001,1659345236492,1,'1025, null','methodArgs/0/value/id: 1025\nmethodArgs/0/value/name: NaN','2024-01-19 06:42:26'),(1703490140848,1703490140840,0,82001,1659345236492,1,'undefined, undefined','methodArgs/0/value/id: undefined\nmethodArgs/0/value/name: undefined','2024-01-19 06:42:49'),(1703490140850,1703490140840,0,82001,1659345236492,1,'1, 90071..','methodArgs/0/value/id: \"1\"\nmethodArgs/0/value/name: 9007199254740992','2024-01-19 06:42:59'),(1703490140852,0,0,82001,1655897836190,10,'RANDOM_STR','methodArgs: []\nmethodArgs/0/value: RANDOM_STR()','2024-01-19 06:44:26'),(1703490140853,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd-6226966621026152\"','2024-01-19 06:44:40'),(1703490140854,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd5132122228932223\"','2024-01-19 06:44:43'),(1703490140855,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd-8971417660841211\"','2024-01-19 06:44:46'),(1703490140856,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd-2187970808197872\"','2024-01-19 06:44:47'),(1703490140857,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd-5767121691154072\"','2024-01-19 06:44:49'),(1703490140858,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd6342514150288095\"','2024-01-19 06:44:50'),(1703490140859,1703490140852,0,82001,1655897836190,1,'[], Ab_Cd..','methodArgs: []\nmethodArgs/0/value: \"Ab_Cd-1382552988793228\"','2024-01-19 06:44:52'),(1703490140860,0,0,82001,1659345236492,1,'随机配置 2024-01-19 15:07','methodArgs/0/value/id: ORDER_INT(1, 100)\nmethodArgs/0/value/name: \'Test\' + (1 + Math.round(99*Math.random()))','2024-01-19 07:07:47'),(1703490140862,0,0,82001,1699782921673,10,'随机配置 2024-01-19 15:25','Comment.id: ORDER_DB(null, null, \'Comment\', \'id\')','2024-01-19 07:25:52'),(1703490140863,1703490140862,0,82001,1699782921673,1,'13','Comment.id: 13','2024-01-19 07:26:48'),(1703490140864,1703490140862,0,82001,1699782921673,1,'4','Comment.id: 4','2024-01-19 07:26:49'),(1703490140865,1703490140862,0,82001,1699782921673,1,'44','Comment.id: 44','2024-01-19 07:26:51'),(1703490140866,1703490140862,0,82001,1699782921673,1,'45','Comment.id: 45','2024-01-19 07:26:52'),(1703490140867,1703490140862,0,82001,1699782921673,1,'47','Comment.id: 47','2024-01-19 07:26:54'),(1703490140868,1703490140862,0,82001,1699782921673,1,'68','Comment.id: 68','2024-01-19 07:26:57'),(1703490140869,1703490140862,0,82001,1699782921673,1,'76','Comment.id: 76','2024-01-19 07:26:57'),(1703490140870,1703490140862,0,82001,1699782921673,1,'54','Comment.id: 54','2024-01-19 07:26:58');
/*!40000 ALTER TABLE `Random` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Request`
--

DROP TABLE IF EXISTS `Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Request` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `debug` tinyint NOT NULL DEFAULT '0' COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `version` tinyint NOT NULL DEFAULT '1' COMMENT 'GET,HEAD可用任意结构访问任意开放内容，不需要这个字段。\n其它的操作因为写入了结构和内容，所以都需要，按照不同的version选择对应的structure。\n\n自动化版本管理：\nRequest JSON最外层可以传  “version”:Integer 。\n1.未传或 <= 0，用最新版。 “@order”:”version-“\n2.已传且 > 0，用version以上的可用版本的最低版本。 “@order”:”version+”, “version{}”:”>={version}”',
  `method` varchar(10) DEFAULT 'GETS' COMMENT '只限于GET,HEAD外的操作方法。',
  `tag` varchar(30) NOT NULL COMMENT '标签',
  `structure` json NOT NULL COMMENT '结构。\nTODO 里面的 PUT 改为 UPDATE，避免和请求 PUT 搞混。',
  `detail` varchar(10000) DEFAULT NULL COMMENT '详细说明',
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1658229984299 DEFAULT CHARSET=utf8mb3 COMMENT='请求参数校验配置(必须)。\n最好编辑完后删除主键，这样就是只读状态，不能随意更改。需要更改就重新加上主键。\n\n每次启动服务器时加载整个表到内存。\n这个表不可省略，model内注解的权限只是客户端能用的，其它可以保证即便服务端代码错误时也不会误删数据。';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Request`
--

LOCK TABLES `Request` WRITE;
/*!40000 ALTER TABLE `Request` DISABLE KEYS */;
INSERT INTO `Request` VALUES (1,0,1,'POST','register','{\"User\": {\"MUST\": \"name\", \"REFUSE\": \"id\", \"UPDATE\": {\"id@\": \"Privacy/id\"}}, \"Privacy\": {\"MUST\": \"_password,phone\", \"REFUSE\": \"id\", \"UNIQUE\": \"phone\", \"VERIFY\": {\"phone~\": \"PHONE\"}}}','UNIQUE校验phone是否已存在。VERIFY校验phone是否符合手机号的格式','2017-02-01 11:19:51'),(2,0,1,'POST','Moment','{\"INSERT\": {\"@role\": \"OWNER\", \"pictureList\": [], \"praiseUserIdList\": []}, \"REFUSE\": \"id\", \"UPDATE\": {\"verifyIdList-()\": \"verifyIdList(praiseUserIdList)\", \"verifyURLList-()\": \"verifyURLList(pictureList)\"}}','INSERT当没传pictureList和praiseUserIdList时用空数组[]补全，保证不会为null','2017-02-01 11:19:51'),(3,0,1,'POST','Comment','{\"MUST\": \"momentId,content\", \"REFUSE\": \"id\", \"UPDATE\": {\"@role\": \"OWNER\"}}','必须传userId,momentId,content，不允许传id','2017-02-01 11:19:51'),(4,0,1,'PUT','User','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"phone\"}','必须传id，不允许传phone。INSERT当没传@role时用OWNER补全','2017-02-01 11:19:51'),(5,0,1,'DELETE','Moment','{\"Moment\": {\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"commentCount()\": \"deleteCommentOfMoment(id)\"}}}',NULL,'2017-02-01 11:19:51'),(6,0,1,'DELETE','Comment','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"childCount()\": \"deleteChildComment(id)\"}}','disallow没必要用于DELETE','2017-02-01 11:19:51'),(8,0,1,'PUT','User-phone','{\"User\": {\"MUST\": \"id,phone,_password\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\", \"UPDATE\": {\"@combine\": \"_password\"}}}','! 表示其它所有，这里指necessary所有未包含的字段','2017-02-01 11:19:51'),(14,0,1,'POST','Verify','{\"MUST\": \"phone,verify\", \"REFUSE\": \"!\"}','必须传phone,verify，其它都不允许传','2017-02-18 14:20:43'),(15,0,1,'GETS','Verify','{\"MUST\": \"phone\"}','必须传phone','2017-02-18 14:20:43'),(16,0,1,'HEADS','Verify','{}','允许任意内容','2017-02-18 14:20:43'),(17,0,1,'PUT','Moment','{\"MUST\": \"id\", \"REFUSE\": \"userId,date\", \"UPDATE\": {\"@role\": \"OWNER\", \"verifyIdList-()\": \"verifyIdList(praiseUserIdList)\", \"verifyURLList-()\": \"verifyURLList(pictureList)\"}}',NULL,'2017-02-01 11:19:51'),(21,0,1,'HEADS','Login','{\"MUST\": \"userId,type\", \"REFUSE\": \"!\"}',NULL,'2017-02-18 14:20:43'),(22,0,1,'GETS','User','{}','允许传任何内容，除了表对象','2017-02-18 14:20:43'),(23,0,1,'PUT','Privacy','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}','INSERT当没传@role时用OWNER补全','2017-02-01 11:19:51'),(25,0,1,'PUT','Praise','{\"MUST\": \"id\"}','必须传id','2017-02-01 11:19:51'),(26,0,1,'DELETE','Comment[]','{\"Comment\": {\"MUST\": \"id{}\", \"INSERT\": {\"@role\": \"OWNER\"}}}','DISALLOW没必要用于DELETE','2017-02-01 11:19:51'),(27,0,1,'PUT','Comment[]','{\"Comment\": {\"MUST\": \"id{}\", \"INSERT\": {\"@role\": \"OWNER\"}}}','DISALLOW没必要用于DELETE','2017-02-01 11:19:51'),(28,0,1,'PUT','Comment','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}','这里省略了Comment，因为tag就是Comment，Parser.getCorrectRequest会自动补全','2017-02-01 11:19:51'),(29,0,1,'GETS','login','{\"Privacy\": {\"MUST\": \"phone,_password\", \"REFUSE\": \"id\"}}',NULL,'2017-10-15 10:04:52'),(30,0,1,'PUT','balance+','{\"Privacy\": {\"MUST\": \"id,balance+\", \"REFUSE\": \"!\", \"VERIFY\": {\"balance+&{}\": \">=1,<=100000\"}}}','验证balance+对应的值是否满足>=1且<=100000','2017-10-21 08:48:34'),(31,0,1,'PUT','balance-','{\"Privacy\": {\"MUST\": \"id,balance-,_password\", \"REFUSE\": \"!\", \"UPDATE\": {\"@combine\": \"_password\"}, \"VERIFY\": {\"balance-&{}\": \">=1,<=10000\"}}}','UPDATE强制把_password作为WHERE条件','2017-10-21 08:48:34'),(32,0,2,'GETS','Privacy','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"_password,_payPassword\"}',NULL,'2017-06-12 16:05:51'),(33,0,2,'GETS','Privacy-CIRCLE','{\"Privacy\": {\"MUST\": \"id\", \"REFUSE\": \"!\", \"UPDATE\": {\"@role\": \"CIRCLE\", \"@column\": \"phone\"}}}',NULL,'2017-06-12 16:05:51'),(35,0,2,'POST','Document','{\"Document\": {\"MUST\": \"name,url,request\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}, \"TestRecord\": {\"MUST\": \"response\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id,documentId\", \"UPDATE\": {\"documentId@\": \"Document/id\"}}}',NULL,'2017-11-26 08:34:41'),(36,1,2,'PUT','Document','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"userId\"}',NULL,'2017-11-26 08:35:15'),(37,1,2,'DELETE','Document','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\", \"UPDATE\": {\"Random\": {\"@role\": \"OWNER\", \"documentId@\": \"Method/id\"}, \"TestRecord\": {\"@role\": \"OWNER\", \"documentId@\": \"Document/id\"}}}',NULL,'2017-11-26 00:36:20'),(38,0,2,'POST','TestRecord','{\"MUST\": \"documentId,response\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2018-06-16 23:44:36'),(39,1,2,'POST','Method','{\"Method\": {\"MUST\": \"method,package\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}, \"TestRecord\": {\"MUST\": \"response\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id,documentId\", \"UPDATE\": {\"documentId@\": \"Method/id\"}}}',NULL,'2017-11-26 00:34:41'),(40,1,2,'PUT','Method','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"userId\"}',NULL,'2017-11-26 00:35:15'),(41,1,2,'DELETE','Method','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\"}',NULL,'2017-11-25 16:36:20'),(42,0,2,'POST','Random','{\"INSERT\": {\"@role\": \"OWNER\"}, \"Random\": {\"MUST\": \"documentId,name,config\"}, \"TestRecord\": {\"UPDATE\": {\"randomId@\": \"/Random/id\", \"documentId@\": \"/Random/documentId\"}}}',NULL,'2017-11-26 00:34:41'),(43,1,2,'PUT','Random','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"userId\"}',NULL,'2017-11-26 00:35:15'),(44,1,2,'DELETE','Random','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"TestRecord\": {\"@role\": \"OWNER\", \"randomId@\": \"/id\"}}}',NULL,'2017-11-25 16:36:20'),(45,0,2,'POST','Comment:[]','{\"TYPE\": {\"Comment[]\": \"OBJECT[]\"}, \"INSERT\": {\"@role\": \"OWNER\"}, \"Comment[]\": []}',NULL,'2020-03-01 05:40:04'),(46,0,2,'POST','Moment:[]','{\"INSERT\": {\"@role\": \"OWNER\"}, \"Moment[]\": []}',NULL,'2020-03-01 05:41:42'),(47,0,2,'PUT','Comment:[]','{\"INSERT\": {\"@role\": \"OWNER\"}, \"Comment[]\": []}',NULL,'2020-03-01 05:40:04'),(48,1,2,'DELETE','TestRecord','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(49,0,2,'POST','Input','{\"MUST\": \"deviceId,x,y\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(50,0,2,'POST','Device','{\"MUST\": \"brand,model\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(51,0,2,'POST','System','{\"MUST\": \"type,versionCode,versionName\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(52,0,2,'POST','Flow','{\"MUST\": \"deviceId,systemId,name\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(53,0,4,'GETS','Privacy','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\"}',NULL,'2017-06-12 16:05:51'),(54,0,2,'POST','Output','{\"MUST\": \"inputId\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2018-06-16 23:44:36'),(55,0,2,'DELETE','Output','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(56,0,3,'DELETE','Method','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\"}',NULL,'2017-11-25 16:36:20'),(57,0,4,'GETS','User[]','{\"User\": {\"INSERT\": {\"@role\": \"CIRCLE\"}}, \"REFUSE\": \"query\"}',NULL,'2021-10-21 16:29:32'),(58,0,1,'PUT','Moment-praiseUserIdList+','{\"Moment\": {\"MUST\": \"id\", \"REFUSE\": \"!\", \"UPDATE\": {\"@role\": \"CIRCLE\", \"newListWithCurUserId-()\": \"newListWithCurUserId(praiseUserIdList+)\"}}}','单独针对 Moment 点赞设置校验规则（允许圈子成员操作自己的数据）','2017-02-01 11:19:51'),(59,0,1,'PUT','Moment-praiseUserIdList-','{\"Moment\": {\"MUST\": \"id\", \"REFUSE\": \"!\", \"UPDATE\": {\"@role\": \"CIRCLE\", \"praiseUserIdList--()\": \"newListWithCurUserId()\"}}}','单独针对 Moment 取消点赞设置校验规则（允许圈子成员操作自己的数据）','2017-02-01 11:19:51'),(61,1,1,'POST','Request','{\"MUST\": \"method,tag,structure\", \"INSERT\": {\"@role\": \"LOGIN\"}, \"REFUSE\": \"!detail,!\"}',NULL,'2022-05-02 19:07:37'),(1651614346391,0,1,'GET','momentList','{\"MUST\": \"Moment[].page\", \"TYPE\": {\"format\": \"BOOLEAN\", \"Moment[].page\": \"NUMBER\", \"Moment[].count\": \"NUMBER\"}, \"REFUSE\": \"!Moment[].count,!format,!\"}','查询动态列表类 RESTful 简单接口','2022-05-03 21:46:04'),(1657562189773,0,1,'GET','moments','{\"MUST\": \"Moment[].page\", \"TYPE\": {\"format\": \"BOOLEAN\", \"Moment[].page\": \"NUMBER\", \"Moment[].count\": \"NUMBER\"}, \"REFUSE\": \"!Moment[].count,!format,!\"}','查动态列表类 RESTful 简单接口','2022-07-11 17:56:32'),(1657793230364,0,1,'GET','User[]','{\"MUST\": \"\", \"TYPE\": {}, \"REFUSE\": \"!\"}','随机配置 2022-07-14 18:07','2022-07-14 10:07:10'),(1658229984265,0,1,'GET','user','{\"MUST\": \"\", \"TYPE\": {}, \"REFUSE\": \"!\"}','随机配置 2022-07-19 19:26','2022-07-19 11:26:24'),(1658229984266,0,5,'POST','Activity','{}',NULL,'2017-11-26 00:34:41'),(1658229984267,0,5,'POST','Fragment','{}',NULL,'2017-11-26 00:34:41'),(1658229984268,0,5,'POST','View','{}',NULL,'2017-11-26 00:34:41'),(1658229984269,0,5,'POST','Activity:[]','{\"TYPE\": {\"Activity[]\": \"OBJECT[]\"}, \"INSERT\": {\"@role\": \"OWNER\"}, \"Activity[]\": []}',NULL,'2020-03-01 05:40:04'),(1658229984270,0,5,'POST','Fragment:[]','{\"TYPE\": {\"Fragment[]\": \"OBJECT[]\"}, \"INSERT\": {\"@role\": \"OWNER\"}, \"Fragment[]\": []}',NULL,'2020-03-01 05:40:04'),(1658229984271,0,5,'POST','View:[]','{\"TYPE\": {\"View[]\": \"OBJECT[]\"}, \"INSERT\": {\"@role\": \"OWNER\"}, \"View[]\": []}',NULL,'2020-03-01 05:40:04'),(1658229984274,0,5,'PUT','Activity','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:35:15'),(1658229984275,0,5,'PUT','Fragment','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:35:15'),(1658229984276,0,5,'PUT','View','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:35:15'),(1658229984277,0,5,'DELETE','Activity','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(1658229984278,0,5,'DELETE','Fragment','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(1658229984279,0,5,'DELETE','View','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(1658229984280,0,5,'DELETE','View[]','{\"View\": {\"MUST\": \"id{}\", \"INSERT\": {\"@role\": \"OWNER\"}}}','DISALLOW没必要用于DELETE','2017-02-01 11:19:51'),(1658229984282,0,5,'POST','Data','{}',NULL,'2022-12-10 20:58:27'),(1658229984283,0,5,'PUT','Data','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2022-12-10 20:58:27'),(1658229984284,0,5,'DELETE','Data','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2022-12-10 20:58:27'),(1658229984285,0,1,'POST','Script','{\"MUST\": \"name,script\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:34:41'),(1658229984286,0,1,'PUT','Script','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:34:41'),(1658229984287,0,1,'DELETE','Script','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:34:41'),(1658229984289,1,5,'PUT','Document-group','{\"Document\": {\"MUST\": \"url{},group{},group\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\", \"UPDATE\": {\"@key\": \"url:substr(url,1,length(url)-length(substring_index(url,\'/\',-1))-1)\", \"@raw\": \"@key\"}, \"IS_ID_CONDITION_MUST\": false}}',NULL,'2017-11-26 08:35:15'),(1658229984290,1,5,'PUT','Method-group','{\"Method\": {\"MUST\": \"package{},group{},group\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\", \"IS_ID_CONDITION_MUST\": false}}',NULL,'2017-11-26 08:35:15'),(1658229984291,0,2,'DELETE','Flow','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"Input\": {\"@try\": true, \"@role\": \"OWNER\", \"flowId@\": \"/id\"}, \"Output\": {\"@try\": true, \"@role\": \"OWNER\", \"flowId@\": \"/id\"}}}',NULL,'2017-11-25 16:36:20'),(1658229984292,0,2,'DELETE','Input','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"Output\": {\"@try\": true, \"@role\": \"OWNER\", \"inputId@\": \"/id\"}}}',NULL,'2017-11-25 16:36:20'),(1658229984293,0,1,'POST','Chain','{\"MUST\": \"groupId,groupName,documentId\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:34:41'),(1658229984294,0,1,'PUT','Chain','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:34:41'),(1658229984295,0,1,'DELETE','Chain','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-26 00:34:41'),(1658229984296,0,1,'POST','Chain-group','{\"Chain\": {\"MUST\": \"groupName\", \"INSERT\": {\"@role\": \"OWNER\"}}}',NULL,'2017-11-26 00:34:41'),(1658229984297,0,1,'PUT','Chain-group','{\"Chain\": {\"MUST\": \"groupId,groupName\", \"INSERT\": {\"@role\": \"OWNER\"}, \"IS_ID_CONDITION_MUST\": false}}',NULL,'2017-11-26 00:34:41'),(1658229984298,0,1,'DELETE','Chain-group','{\"Chain\": {\"MUST\": \"groupId\", \"INSERT\": {\"@role\": \"OWNER\"}, \"IS_ID_CONDITION_MUST\": false}}',NULL,'2017-11-26 00:34:41');
/*!40000 ALTER TABLE `Request` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping routines for database 'sys'
--
/*!50003 DROP FUNCTION IF EXISTS `extract_schema_from_file_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `extract_schema_from_file_name`(
        path VARCHAR(512)
    ) RETURNS varchar(64) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a raw file path, and attempts to extract the schema name from it.\n\nUseful for when interacting with Performance Schema data \nconcerning IO statistics, for example.\n\nCurrently relies on the fact that a table data file will be within a \nspecified database directory (will not work with partitions or tables\nthat specify an individual DATA_DIRECTORY).\n\nParameters\n-----------\n\npath (VARCHAR(512)):\n  The full file path to a data file to extract the schema name from.\n\nReturns\n-----------\n\nVARCHAR(64)\n\nExample\n-----------\n\nmysql> SELECT sys.extract_schema_from_file_name(''/var/lib/mysql/employees/employee.ibd'');\n+----------------------------------------------------------------------------+\n| sys.extract_schema_from_file_name(''/var/lib/mysql/employees/employee.ibd'') |\n+----------------------------------------------------------------------------+\n| employees                                                                  |\n+----------------------------------------------------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    RETURN LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(path, '\\', '/'), '/', -2), '/', 1), 64);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `extract_table_from_file_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `extract_table_from_file_name`(
        path VARCHAR(512)
    ) RETURNS varchar(64) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a raw file path, and extracts the table name from it.\n\nUseful for when interacting with Performance Schema data \nconcerning IO statistics, for example.\n\nParameters\n-----------\n\npath (VARCHAR(512)):\n  The full file path to a data file to extract the table name from.\n\nReturns\n-----------\n\nVARCHAR(64)\n\nExample\n-----------\n\nmysql> SELECT sys.extract_table_from_file_name(''/var/lib/mysql/employees/employee.ibd'');\n+---------------------------------------------------------------------------+\n| sys.extract_table_from_file_name(''/var/lib/mysql/employees/employee.ibd'') |\n+---------------------------------------------------------------------------+\n| employee                                                                  |\n+---------------------------------------------------------------------------+\n1 row in set (0.02 sec)\n'
BEGIN
    RETURN LEFT(SUBSTRING_INDEX(REPLACE(SUBSTRING_INDEX(REPLACE(path, '\\', '/'), '/', -1), '@0024', '$'), '.', 1), 64);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `format_bytes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `format_bytes`(
        -- We feed in and return TEXT here, as aggregates of
        -- bytes can return numbers larger than BIGINT UNSIGNED
        bytes TEXT
    ) RETURNS text CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a raw bytes value, and converts it to a human readable format.\n\nParameters\n-----------\n\nbytes (TEXT):\n  A raw bytes value.\n\nReturns\n-----------\n\nTEXT\n\nExample\n-----------\n\nmysql> SELECT sys.format_bytes(2348723492723746) AS size;\n+----------+\n| size     |\n+----------+\n| 2.09 PiB |\n+----------+\n1 row in set (0.00 sec)\n\nmysql> SELECT sys.format_bytes(2348723492723) AS size;\n+----------+\n| size     |\n+----------+\n| 2.14 TiB |\n+----------+\n1 row in set (0.00 sec)\n\nmysql> SELECT sys.format_bytes(23487234) AS size;\n+-----------+\n| size      |\n+-----------+\n| 22.40 MiB |\n+-----------+\n1 row in set (0.00 sec)\n'
BEGIN
  IF (bytes IS NULL) THEN
    RETURN NULL;
  ELSE
    RETURN format_bytes(bytes);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `format_path` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `format_path`(
        in_path VARCHAR(512)
    ) RETURNS varchar(512) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a raw path value, and strips out the datadir or tmpdir\nreplacing with @@datadir and @@tmpdir respectively.\n\nAlso normalizes the paths across operating systems, so backslashes\non Windows are converted to forward slashes\n\nParameters\n-----------\n\npath (VARCHAR(512)):\n  The raw file path value to format.\n\nReturns\n-----------\n\nVARCHAR(512) CHARSET UTF8MB4\n\nExample\n-----------\n\nmysql> select @@datadir;\n+-----------------------------------------------+\n| @@datadir                                     |\n+-----------------------------------------------+\n| /Users/mark/sandboxes/SmallTree/AMaster/data/ |\n+-----------------------------------------------+\n1 row in set (0.06 sec)\n\nmysql> select format_path(''/Users/mark/sandboxes/SmallTree/AMaster/data/mysql/proc.MYD'') AS path;\n+--------------------------+\n| path                     |\n+--------------------------+\n| @@datadir/mysql/proc.MYD |\n+--------------------------+\n1 row in set (0.03 sec)\n'
BEGIN
  DECLARE v_path VARCHAR(512);
  DECLARE v_undo_dir VARCHAR(1024);
  DECLARE path_separator CHAR(1) DEFAULT '/';
  IF @@global.version_compile_os LIKE 'win%' THEN
    SET path_separator = '\\';
  END IF;
  -- OSX hides /private/ in variables, but Performance Schema does not
  IF in_path LIKE '/private/%' THEN
    SET v_path = REPLACE(in_path, '/private', '');
  ELSE
    SET v_path = in_path;
  END IF;
  -- @@global.innodb_undo_directory is only set when separate undo logs are used
  SET v_undo_dir = IFNULL((SELECT VARIABLE_VALUE FROM performance_schema.global_variables WHERE VARIABLE_NAME = 'innodb_undo_directory'), '');
  IF v_path IS NULL THEN
    RETURN NULL;
  ELSEIF v_path LIKE CONCAT(@@global.datadir, IF(SUBSTRING(@@global.datadir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, @@global.datadir, CONCAT('@@datadir', IF(SUBSTRING(@@global.datadir, -1) = path_separator, path_separator, '')));
  ELSEIF v_path LIKE CONCAT(@@global.tmpdir, IF(SUBSTRING(@@global.tmpdir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, @@global.tmpdir, CONCAT('@@tmpdir', IF(SUBSTRING(@@global.tmpdir, -1) = path_separator, path_separator, '')));
  ELSEIF v_path LIKE CONCAT(@@global.replica_load_tmpdir, IF(SUBSTRING(@@global.replica_load_tmpdir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, @@global.replica_load_tmpdir, CONCAT('@@replica_load_tmpdir', IF(SUBSTRING(@@global.replica_load_tmpdir, -1) = path_separator, path_separator, '')));
  ELSEIF v_path LIKE CONCAT(@@global.innodb_data_home_dir, IF(SUBSTRING(@@global.innodb_data_home_dir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, @@global.innodb_data_home_dir, CONCAT('@@innodb_data_home_dir', IF(SUBSTRING(@@global.innodb_data_home_dir, -1) = path_separator, path_separator, '')));
  ELSEIF v_path LIKE CONCAT(@@global.innodb_log_group_home_dir, IF(SUBSTRING(@@global.innodb_log_group_home_dir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, @@global.innodb_log_group_home_dir, CONCAT('@@innodb_log_group_home_dir', IF(SUBSTRING(@@global.innodb_log_group_home_dir, -1) = path_separator, path_separator, '')));
  ELSEIF v_path LIKE CONCAT(v_undo_dir, IF(SUBSTRING(v_undo_dir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, v_undo_dir, CONCAT('@@innodb_undo_directory', IF(SUBSTRING(v_undo_dir, -1) = path_separator, path_separator, '')));
  ELSEIF v_path LIKE CONCAT(@@global.basedir, IF(SUBSTRING(@@global.basedir, -1) = path_separator, '%', CONCAT(path_separator, '%'))) ESCAPE '|' THEN
    SET v_path = REPLACE(v_path, @@global.basedir, CONCAT('@@basedir', IF(SUBSTRING(@@global.basedir, -1) = path_separator, path_separator, '')));
  END IF;
  RETURN v_path;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `format_statement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `format_statement`(
        statement LONGTEXT
    ) RETURNS longtext CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nFormats a normalized statement, truncating it if it is > 64 characters long by default.\n\nTo configure the length to truncate the statement to by default, update the `statement_truncate_len`\nvariable with `sys_config` table to a different value. Alternatively, to change it just for just \nyour particular session, use `SET @sys.statement_truncate_len := <some new value>`.\n\nUseful for printing statement related data from Performance Schema from \nthe command line.\n\nParameters\n-----------\n\nstatement (LONGTEXT): \n  The statement to format.\n\nReturns\n-----------\n\nLONGTEXT\n\nExample\n-----------\n\nmysql> SELECT sys.format_statement(digest_text)\n    ->   FROM performance_schema.events_statements_summary_by_digest\n    ->  ORDER by sum_timer_wait DESC limit 5;\n+-------------------------------------------------------------------+\n| sys.format_statement(digest_text)                                 |\n+-------------------------------------------------------------------+\n| CREATE SQL SECURITY INVOKER VI ... KE ? AND `variable_value` > ?  |\n| CREATE SQL SECURITY INVOKER VI ... ait` IS NOT NULL , `esc` . ... |\n| CREATE SQL SECURITY INVOKER VI ... ait` IS NOT NULL , `sys` . ... |\n| CREATE SQL SECURITY INVOKER VI ...  , `compressed_size` ) ) DESC  |\n| CREATE SQL SECURITY INVOKER VI ... LIKE ? ORDER BY `timer_start`  |\n+-------------------------------------------------------------------+\n5 rows in set (0.00 sec)\n'
BEGIN
  -- Check if we have the configured length, if not, init it
  IF @sys.statement_truncate_len IS NULL THEN
      SET @sys.statement_truncate_len = sys_get_config('statement_truncate_len', 64);
  END IF;
  IF CHAR_LENGTH(statement) > @sys.statement_truncate_len THEN
      RETURN REPLACE(CONCAT(LEFT(statement, (@sys.statement_truncate_len/2)-2), ' ... ', RIGHT(statement, (@sys.statement_truncate_len/2)-2)), '\n', ' ');
  ELSE 
      RETURN REPLACE(statement, '\n', ' ');
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `format_time` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `format_time`(
-- We feed in and return TEXT here, as aggregates of
-- picoseconds can return numbers larger than BIGINT UNSIGNED
        picoseconds TEXT
    ) RETURNS text CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a raw picoseconds value, and converts it to a human readable form.\n\nPicoseconds are the precision that all latency values are printed in\nwithin Performance Schema, however are not user friendly when wanting\nto scan output from the command line.\n\nParameters\n-----------\n\npicoseconds (TEXT):\n  The raw picoseconds value to convert.\n\nReturns\n-----------\n\nTEXT CHARSET UTF8MB4\n\nExample\n-----------\n\nmysql> select format_time(342342342342345);\n+------------------------------+\n| format_time(342342342342345) |\n+------------------------------+\n| 00:05:42                     |\n+------------------------------+\n1 row in set (0.00 sec)\n\nmysql> select format_time(342342342);\n+------------------------+\n| format_time(342342342) |\n+------------------------+\n| 342.34 us              |\n+------------------------+\n1 row in set (0.00 sec)\n\nmysql> select format_time(34234);\n+--------------------+\n| format_time(34234) |\n+--------------------+\n| 34.23 ns           |\n+--------------------+\n1 row in set (0.00 sec)\n'
BEGIN
  IF picoseconds IS NULL THEN RETURN NULL;
  ELSEIF picoseconds >= 604800000000000000 THEN RETURN CONCAT(ROUND(picoseconds / 604800000000000000, 2), ' w');
  ELSEIF picoseconds >= 86400000000000000 THEN RETURN CONCAT(ROUND(picoseconds / 86400000000000000, 2), ' d');
  ELSEIF picoseconds >= 3600000000000000 THEN RETURN CONCAT(ROUND(picoseconds / 3600000000000000, 2), ' h');
  ELSEIF picoseconds >= 60000000000000 THEN RETURN CONCAT(ROUND(picoseconds / 60000000000000, 2), ' m');
  ELSEIF picoseconds >= 1000000000000 THEN RETURN CONCAT(ROUND(picoseconds / 1000000000000, 2), ' s');
  ELSEIF picoseconds >= 1000000000 THEN RETURN CONCAT(ROUND(picoseconds / 1000000000, 2), ' ms');
  ELSEIF picoseconds >= 1000000 THEN RETURN CONCAT(ROUND(picoseconds / 1000000, 2), ' us');
  ELSEIF picoseconds >= 1000 THEN RETURN CONCAT(ROUND(picoseconds / 1000, 2), ' ns');
  ELSE RETURN CONCAT(picoseconds, ' ps');
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `list_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `list_add`(
        in_list TEXT,
        in_add_value TEXT
    ) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a list, and a value to add to the list, and returns the resulting list.\n\nUseful for altering certain session variables, like sql_mode or optimizer_switch for instance.\n\nParameters\n-----------\n\nin_list (TEXT):\n  The comma separated list to add a value to\n\nin_add_value (TEXT):\n  The value to add to the input list\n\nReturns\n-----------\n\nTEXT\n\nExample\n--------\n\nmysql> select @@sql_mode;\n+-----------------------------------------------------------------------------------+\n| @@sql_mode                                                                        |\n+-----------------------------------------------------------------------------------+\n| ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |\n+-----------------------------------------------------------------------------------+\n1 row in set (0.00 sec)\n\nmysql> set sql_mode = sys.list_add(@@sql_mode, ''ANSI_QUOTES'');\nQuery OK, 0 rows affected (0.06 sec)\n\nmysql> select @@sql_mode;\n+-----------------------------------------------------------------------------------------------+\n| @@sql_mode                                                                                    |\n+-----------------------------------------------------------------------------------------------+\n| ANSI_QUOTES,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |\n+-----------------------------------------------------------------------------------------------+\n1 row in set (0.00 sec)\n\n'
BEGIN
    IF (in_add_value IS NULL) THEN
        SIGNAL SQLSTATE '02200'
           SET MESSAGE_TEXT = 'Function sys.list_add: in_add_value input variable should not be NULL',
               MYSQL_ERRNO = 1138;
    END IF;
    IF (in_list IS NULL OR LENGTH(in_list) = 0) THEN
        -- return the new value as a single value list
        RETURN in_add_value;
    END IF;
    RETURN (SELECT CONCAT(TRIM(BOTH ',' FROM TRIM(in_list)), ',', in_add_value));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `list_drop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `list_drop`(
        in_list TEXT,
        in_drop_value TEXT
    ) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a list, and a value to attempt to remove from the list, and returns the resulting list.\n\nUseful for altering certain session variables, like sql_mode or optimizer_switch for instance.\n\nParameters\n-----------\n\nin_list (TEXT):\n  The comma separated list to drop a value from\n\nin_drop_value (TEXT):\n  The value to drop from the input list\n\nReturns\n-----------\n\nTEXT\n\nExample\n--------\n\nmysql> select @@sql_mode;\n+-----------------------------------------------------------------------------------------------+\n| @@sql_mode                                                                                    |\n+-----------------------------------------------------------------------------------------------+\n| ANSI_QUOTES,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |\n+-----------------------------------------------------------------------------------------------+\n1 row in set (0.00 sec)\n\nmysql> set sql_mode = sys.list_drop(@@sql_mode, ''ONLY_FULL_GROUP_BY'');\nQuery OK, 0 rows affected (0.03 sec)\n\nmysql> select @@sql_mode;\n+----------------------------------------------------------------------------+\n| @@sql_mode                                                                 |\n+----------------------------------------------------------------------------+\n| ANSI_QUOTES,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |\n+----------------------------------------------------------------------------+\n1 row in set (0.00 sec)\n\n'
BEGIN
    IF (in_drop_value IS NULL) THEN
        SIGNAL SQLSTATE '02200'
           SET MESSAGE_TEXT = 'Function sys.list_drop: in_drop_value input variable should not be NULL',
               MYSQL_ERRNO = 1138;
    END IF;
    IF (in_list IS NULL OR LENGTH(in_list) = 0) THEN
        -- return the list as it was passed in
        RETURN in_list;
    END IF;
    -- ensure that leading / trailing commas are remove, support values with either spaces or not between commas
    RETURN (SELECT TRIM(BOTH ',' FROM REPLACE(REPLACE(CONCAT(',', in_list), CONCAT(',', in_drop_value), ''), CONCAT(', ', in_drop_value), '')));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_is_account_enabled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_is_account_enabled`(
        in_host VARCHAR(255), 
        in_user VARCHAR(32)
    ) RETURNS enum('YES','NO') CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDetermines whether instrumentation of an account is enabled \nwithin Performance Schema.\n\nParameters\n-----------\n\nin_host VARCHAR(255): \n  The hostname of the account to check.\nin_user VARCHAR(32):\n  The username of the account to check.\n\nReturns\n-----------\n\nENUM(''YES'', ''NO'', ''PARTIAL'')\n\nExample\n-----------\n\nmysql> SELECT sys.ps_is_account_enabled(''localhost'', ''root'');\n+------------------------------------------------+\n| sys.ps_is_account_enabled(''localhost'', ''root'') |\n+------------------------------------------------+\n| YES                                            |\n+------------------------------------------------+\n1 row in set (0.01 sec)\n'
BEGIN
    RETURN IF(EXISTS(SELECT 1
                       FROM performance_schema.setup_actors
                      WHERE (`HOST` = '%' OR in_host LIKE `HOST`)
                        AND (`USER` = '%' OR `USER` = in_user)
                        AND (`ENABLED` = 'YES')
                    ),
              'YES', 'NO'
           );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_is_consumer_enabled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_is_consumer_enabled`(
        in_consumer varchar(64)
   ) RETURNS enum('YES','NO') CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDetermines whether a consumer is enabled (taking the consumer hierarchy into consideration)\nwithin the Performance Schema.\n\nAn exception with errno 3047 is thrown if an unknown consumer name is passed to the function.\nA consumer name of NULL returns NULL.\n\nParameters\n-----------\n\nin_consumer VARCHAR(64): \n  The name of the consumer to check.\n\nReturns\n-----------\n\nENUM(''YES'', ''NO'')\n\nExample\n-----------\n\nmysql> SELECT sys.ps_is_consumer_enabled(''events_stages_history'');\n+-----------------------------------------------------+\n| sys.ps_is_consumer_enabled(''events_stages_history'') |\n+-----------------------------------------------------+\n| NO                                                  |\n+-----------------------------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    DECLARE v_is_enabled ENUM('YES', 'NO') DEFAULT NULL;
    DECLARE v_error_msg VARCHAR(128);
    -- Return NULL for a NULL argument.
    IF (in_consumer IS NULL) THEN
        RETURN NULL;
    END IF;
    SET v_is_enabled = (
        SELECT (CASE
                   WHEN c.NAME = 'global_instrumentation' THEN c.ENABLED
                   WHEN c.NAME = 'thread_instrumentation' THEN IF(cg.ENABLED = 'YES' AND c.ENABLED = 'YES', 'YES', 'NO')
                   WHEN c.NAME LIKE '%\_digest'           THEN IF(cg.ENABLED = 'YES' AND c.ENABLED = 'YES', 'YES', 'NO')
                   WHEN c.NAME LIKE '%\_current'          THEN IF(cg.ENABLED = 'YES' AND ct.ENABLED = 'YES' AND c.ENABLED = 'YES', 'YES', 'NO')
                   ELSE IF(cg.ENABLED = 'YES' AND ct.ENABLED = 'YES' AND c.ENABLED = 'YES'
                           AND ( SELECT cc.ENABLED FROM performance_schema.setup_consumers cc WHERE NAME = CONCAT(SUBSTRING_INDEX(c.NAME, '_', 2), '_current')
                               ) = 'YES', 'YES', 'NO')
                END) AS IsEnabled
          FROM performance_schema.setup_consumers c
               INNER JOIN performance_schema.setup_consumers cg
               INNER JOIN performance_schema.setup_consumers ct
         WHERE cg.NAME       = 'global_instrumentation'
               AND ct.NAME   = 'thread_instrumentation'
               AND c.NAME    = in_consumer
        );
    IF (v_is_enabled IS NOT NULL) THEN
        RETURN v_is_enabled;
    ELSE
        -- A value of NULL here means it is an unknown consumer name that was passed as an argument.
        -- Only an input value of NULL is allowed to return a NULL result value, to throw a signal instead.
        SET v_error_msg = CONCAT('Invalid argument error: ', in_consumer, ' in function sys.ps_is_consumer_enabled.');
        SIGNAL SQLSTATE 'HY000'
           SET MESSAGE_TEXT = v_error_msg,
               MYSQL_ERRNO  = 3047;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_is_instrument_default_enabled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_is_instrument_default_enabled`(
        in_instrument VARCHAR(128)
    ) RETURNS enum('YES','NO') CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns whether an instrument is enabled by default in this version of MySQL.\n\nParameters\n-----------\n\nin_instrument VARCHAR(128): \n  The instrument to check.\n\nReturns\n-----------\n\nENUM(''YES'', ''NO'')\n\nExample\n-----------\n\nmysql> SELECT sys.ps_is_instrument_default_enabled(''statement/sql/select'');\n+--------------------------------------------------------------+\n| sys.ps_is_instrument_default_enabled(''statement/sql/select'') |\n+--------------------------------------------------------------+\n| YES                                                          |\n+--------------------------------------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    DECLARE v_enabled ENUM('YES', 'NO');
    IF (in_instrument LIKE 'stage/%') THEN
    BEGIN
      /* Stages are enabled by default if the progress property is set. */
      SET v_enabled = (SELECT
                        IF(find_in_set("progress", PROPERTIES) != 0, 'YES', 'NO')
                        FROM performance_schema.setup_instruments
                        WHERE NAME = in_instrument);
      SET v_enabled = IFNULL(v_enabled, 'NO');
    END;
    ELSE
      SET v_enabled = IF(in_instrument LIKE 'wait/synch/%'
                         OR in_instrument LIKE 'wait/io/socket/%'
                        ,
                         'NO',
                         'YES'
                      );
    END IF;
    RETURN v_enabled;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_is_instrument_default_timed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_is_instrument_default_timed`(
        in_instrument VARCHAR(128)
    ) RETURNS enum('YES','NO') CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns whether an instrument is timed by default in this version of MySQL.\n\nParameters\n-----------\n\nin_instrument VARCHAR(128): \n  The instrument to check.\n\nReturns\n-----------\n\nENUM(''YES'', ''NO'')\n\nExample\n-----------\n\nmysql> SELECT sys.ps_is_instrument_default_timed(''statement/sql/select'');\n+------------------------------------------------------------+\n| sys.ps_is_instrument_default_timed(''statement/sql/select'') |\n+------------------------------------------------------------+\n| YES                                                        |\n+------------------------------------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    DECLARE v_timed ENUM('YES', 'NO');
    IF (in_instrument LIKE 'stage/%') THEN
    BEGIN
      -- Stages are timed by default if the progress property is set.
      SET v_timed = (SELECT
                      IF(find_in_set("progress", PROPERTIES) != 0, 'YES', 'NO')
                      FROM performance_schema.setup_instruments
                      WHERE NAME = in_instrument);
      SET v_timed = IFNULL(v_timed, 'NO');
    END;
    ELSE
      -- Mutex, rwlock, prlock, sxlock, cond are not timed by default
      -- Memory instruments are never timed.
      SET v_timed = IF(in_instrument LIKE 'wait/synch/%'
                       OR in_instrument LIKE 'memory/%'
                      ,
                       'NO',
                       'YES'
                    );
    END IF;
    RETURN v_timed;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_is_thread_instrumented` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_is_thread_instrumented`(
        in_connection_id BIGINT UNSIGNED
    ) RETURNS enum('YES','NO','UNKNOWN') CHARSET utf8mb4
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nChecks whether the provided connection id is instrumented within Performance Schema.\n\nParameters\n-----------\n\nin_connection_id (BIGINT UNSIGNED):\n  The id of the connection to check.\n\nReturns\n-----------\n\nENUM(''YES'', ''NO'', ''UNKNOWN'')\n\nExample\n-----------\n\nmysql> SELECT sys.ps_is_thread_instrumented(CONNECTION_ID());\n+------------------------------------------------+\n| sys.ps_is_thread_instrumented(CONNECTION_ID()) |\n+------------------------------------------------+\n| YES                                            |\n+------------------------------------------------+\n'
BEGIN
    DECLARE v_enabled ENUM('YES', 'NO', 'UNKNOWN');
    IF (in_connection_id IS NULL) THEN
        RETURN NULL;
    END IF;
    SELECT INSTRUMENTED INTO v_enabled
      FROM performance_schema.threads 
     WHERE PROCESSLIST_ID = in_connection_id;
    IF (v_enabled IS NULL) THEN
        RETURN 'UNKNOWN';
    ELSE
        RETURN v_enabled;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_thread_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_thread_account`(
        in_thread_id BIGINT UNSIGNED
    ) RETURNS text CHARSET utf8mb4
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturn the user@host account for the given Performance Schema thread id.\n\nParameters\n-----------\n\nin_thread_id (BIGINT UNSIGNED):\n  The id of the thread to return the account for.\n\nExample\n-----------\n\nmysql> select thread_id, processlist_user, processlist_host from performance_schema.threads where type = ''foreground'';\n+-----------+------------------+------------------+\n| thread_id | processlist_user | processlist_host |\n+-----------+------------------+------------------+\n|        23 | NULL             | NULL             |\n|        30 | root             | localhost        |\n|        31 | msandbox         | localhost        |\n|        32 | msandbox         | localhost        |\n+-----------+------------------+------------------+\n4 rows in set (0.00 sec)\n\nmysql> select sys.ps_thread_account(31);\n+---------------------------+\n| sys.ps_thread_account(31) |\n+---------------------------+\n| msandbox@localhost        |\n+---------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    RETURN (SELECT IF(
                      type = 'FOREGROUND',
                      CONCAT(processlist_user, '@', processlist_host),
                      type
                     ) AS account
              FROM `performance_schema`.`threads`
             WHERE thread_id = in_thread_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_thread_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_thread_id`(
        in_connection_id BIGINT UNSIGNED
    ) RETURNS bigint unsigned
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturn the Performance Schema THREAD_ID for the specified connection ID.\n\nParameters\n-----------\n\nin_connection_id (BIGINT UNSIGNED):\n  The id of the connection to return the thread id for. If NULL, the current\n  connection thread id is returned.\n\nExample\n-----------\n\nmysql> SELECT sys.ps_thread_id(79);\n+----------------------+\n| sys.ps_thread_id(79) |\n+----------------------+\n|                   98 |\n+----------------------+\n1 row in set (0.00 sec)\n\nmysql> SELECT sys.ps_thread_id(CONNECTION_ID());\n+-----------------------------------+\n| sys.ps_thread_id(CONNECTION_ID()) |\n+-----------------------------------+\n|                                98 |\n+-----------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
  IF (in_connection_id IS NULL) THEN
    RETURN ps_current_thread_id();
  ELSE
    RETURN ps_thread_id(in_connection_id);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_thread_stack` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_thread_stack`(
        thd_id BIGINT UNSIGNED,
        debug BOOLEAN
    ) RETURNS longtext CHARSET latin1
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nOutputs a JSON formatted stack of all statements, stages and events\nwithin Performance Schema for the specified thread.\n\nParameters\n-----------\n\nthd_id (BIGINT UNSIGNED):\n  The id of the thread to trace. This should match the thread_id\n  column from the performance_schema.threads table.\nin_verbose (BOOLEAN):\n  Include file:lineno information in the events.\n\nExample\n-----------\n\n(line separation added for output)\n\nmysql> SELECT sys.ps_thread_stack(37, FALSE) AS thread_stack\\G\n*************************** 1. row ***************************\nthread_stack: {"rankdir": "LR","nodesep": "0.10","stack_created": "2014-02-19 13:39:03",\n"mysql_version": "5.7.3-m13","mysql_user": "root@localhost","events": \n[{"nesting_event_id": "0", "event_id": "10", "timer_wait": 256.35, "event_info": \n"sql/select", "wait_info": "select @@version_comment limit 1\\nerrors: 0\\nwarnings: 0\\nlock time:\n...\n'
BEGIN
    DECLARE json_objects LONGTEXT;
    -- Do not track the current thread, it will kill the stack
    UPDATE performance_schema.threads
       SET instrumented = 'NO'
     WHERE processlist_id = CONNECTION_ID();
    SET SESSION group_concat_max_len=@@global.max_allowed_packet;
    -- Select the entire stack of events
    SELECT GROUP_CONCAT(CONCAT( '{'
              , CONCAT_WS( ', '
              , CONCAT('"nesting_event_id": "', IF(nesting_event_id IS NULL, '0', nesting_event_id), '"')
              , CONCAT('"event_id": "', event_id, '"')
              -- Convert from picoseconds to microseconds
              , CONCAT( '"timer_wait": ', ROUND(timer_wait/1000000, 2))  
              , CONCAT( '"event_info": "'
                  , CASE
                        WHEN event_name NOT LIKE 'wait/io%' THEN REPLACE(SUBSTRING_INDEX(event_name, '/', -2), '\\', '\\\\')
                        WHEN event_name NOT LIKE 'wait/io/file%' OR event_name NOT LIKE 'wait/io/socket%' THEN REPLACE(SUBSTRING_INDEX(event_name, '/', -4), '\\', '\\\\')
                        ELSE event_name
                    END
                  , '"'
              )
              -- Always dump the extra wait information gathered for statements
              , CONCAT( '"wait_info": "', IFNULL(wait_info, ''), '"')
              -- If debug is enabled, add the file:lineno information for waits
              , CONCAT( '"source": "', IF(true AND event_name LIKE 'wait%', IFNULL(wait_info, ''), ''), '"')
              -- Depending on the type of event, name it appropriately
              , CASE 
                     WHEN event_name LIKE 'wait/io/file%'      THEN '"event_type": "io/file"'
                     WHEN event_name LIKE 'wait/io/table%'     THEN '"event_type": "io/table"'
                     WHEN event_name LIKE 'wait/io/socket%'    THEN '"event_type": "io/socket"'
                     WHEN event_name LIKE 'wait/synch/mutex%'  THEN '"event_type": "synch/mutex"'
                     WHEN event_name LIKE 'wait/synch/cond%'   THEN '"event_type": "synch/cond"'
                     WHEN event_name LIKE 'wait/synch/rwlock%' THEN '"event_type": "synch/rwlock"'
                     WHEN event_name LIKE 'wait/lock%'         THEN '"event_type": "lock"'
                     WHEN event_name LIKE 'statement/%'        THEN '"event_type": "stmt"'
                     WHEN event_name LIKE 'stage/%'            THEN '"event_type": "stage"'
                     WHEN event_name LIKE '%idle%'             THEN '"event_type": "idle"'
                     ELSE '' 
                END                   
            )
            , '}'
          )
          ORDER BY event_id ASC SEPARATOR ',') event
    INTO json_objects
    FROM (
          -- Select all statements, with the extra tracing information available
          (SELECT thread_id, event_id, event_name, timer_wait, timer_start, nesting_event_id, 
                  CONCAT(sql_text, '\\n',
                         'errors: ', errors, '\\n',
                         'warnings: ', warnings, '\\n',
                         'lock time: ', ROUND(lock_time/1000000, 2),'us\\n',
                         'rows affected: ', rows_affected, '\\n',
                         'rows sent: ', rows_sent, '\\n',
                         'rows examined: ', rows_examined, '\\n',
                         'tmp tables: ', created_tmp_tables, '\\n',
                         'tmp disk tables: ', created_tmp_disk_tables, '\\n',
                         'select scan: ', select_scan, '\\n',
                         'select full join: ', select_full_join, '\\n',
                         'select full range join: ', select_full_range_join, '\\n',
                         'select range: ', select_range, '\\n',
                         'select range check: ', select_range_check, '\\n', 
                         'sort merge passes: ', sort_merge_passes, '\\n',
                         'sort rows: ', sort_rows, '\\n',
                         'sort range: ', sort_range, '\\n',
                         'sort scan: ', sort_scan, '\\n',
                         'no index used: ', IF(no_index_used, 'TRUE', 'FALSE'), '\\n',
                         'no good index used: ', IF(no_good_index_used, 'TRUE', 'FALSE'), '\\n'
                         ) AS wait_info
             FROM performance_schema.events_statements_history_long WHERE thread_id = thd_id)
          UNION 
          -- Select all stages
          (SELECT thread_id, event_id, event_name, timer_wait, timer_start, nesting_event_id, null AS wait_info
             FROM performance_schema.events_stages_history_long WHERE thread_id = thd_id) 
          UNION
          -- Select all events, adding information appropriate to the event
          (SELECT thread_id, event_id, 
                  CONCAT(event_name , 
                         IF(event_name NOT LIKE 'wait/synch/mutex%', IFNULL(CONCAT(' - ', operation), ''), ''), 
                         IF(number_of_bytes IS NOT NULL, CONCAT(' ', number_of_bytes, ' bytes'), ''),
                         IF(event_name LIKE 'wait/io/file%', '\\n', ''),
                         IF(object_schema IS NOT NULL, CONCAT('\\nObject: ', object_schema, '.'), ''), 
                         IF(object_name IS NOT NULL, 
                            IF (event_name LIKE 'wait/io/socket%',
                                -- Print the socket if used, else the IP:port as reported
                                CONCAT(IF (object_name LIKE ':0%', @@socket, object_name)),
                                object_name),
                            ''),
                         IF(index_name IS NOT NULL, CONCAT(' Index: ', index_name), ''),'\\n'
                         ) AS event_name,
                  timer_wait, timer_start, nesting_event_id, source AS wait_info
             FROM performance_schema.events_waits_history_long WHERE thread_id = thd_id)) events 
    ORDER BY event_id;
    RETURN CONCAT('{', 
                  CONCAT_WS(',', 
                            '"rankdir": "LR"',
                            '"nodesep": "0.10"',
                            CONCAT('"stack_created": "', NOW(), '"'),
                            CONCAT('"mysql_version": "', VERSION(), '"'),
                            CONCAT('"mysql_user": "', CURRENT_USER(), '"'),
                            CONCAT('"events": [', IFNULL(json_objects,''), ']')
                           ),
                  '}');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ps_thread_trx_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `ps_thread_trx_info`(
        in_thread_id BIGINT UNSIGNED
    ) RETURNS longtext CHARSET utf8mb4
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns a JSON object with info on the given threads current transaction, \nand the statements it has already executed, derived from the\nperformance_schema.events_transactions_current and\nperformance_schema.events_statements_history tables (so the consumers \nfor these also have to be enabled within Performance Schema to get full\ndata in the object).\n\nWhen the output exceeds the default truncation length (65535), a JSON error\nobject is returned, such as:\n\n{ "error": "Trx info truncated: Row 6 was cut by GROUP_CONCAT()" }\n\nSimilar error objects are returned for other warnings/and exceptions raised\nwhen calling the function.\n\nThe max length of the output of this function can be controlled with the\nps_thread_trx_info.max_length variable set via sys_config, or the\n@sys.ps_thread_trx_info.max_length user variable, as appropriate.\n\nParameters\n-----------\n\nin_thread_id (BIGINT UNSIGNED):\n  The id of the thread to return the transaction info for.\n\nExample\n-----------\n\nSELECT sys.ps_thread_trx_info(48)\\G\n*************************** 1. row ***************************\nsys.ps_thread_trx_info(48): [\n  {\n    "time": "790.70 us",\n    "state": "COMMITTED",\n    "mode": "READ WRITE",\n    "autocommitted": "NO",\n    "gtid": "AUTOMATIC",\n    "isolation": "REPEATABLE READ",\n    "statements_executed": [\n      {\n        "sql_text": "INSERT INTO info VALUES (1, ''foo'')",\n        "time": "471.02 us",\n        "schema": "trx",\n        "rows_examined": 0,\n        "rows_affected": 1,\n        "rows_sent": 0,\n        "tmp_tables": 0,\n        "tmp_disk_tables": 0,\n        "sort_rows": 0,\n        "sort_merge_passes": 0\n      },\n      {\n        "sql_text": "COMMIT",\n        "time": "254.42 us",\n        "schema": "trx",\n        "rows_examined": 0,\n        "rows_affected": 0,\n        "rows_sent": 0,\n        "tmp_tables": 0,\n        "tmp_disk_tables": 0,\n        "sort_rows": 0,\n        "sort_merge_passes": 0\n      }\n    ]\n  },\n  {\n    "time": "426.20 us",\n    "state": "COMMITTED",\n    "mode": "READ WRITE",\n    "autocommitted": "NO",\n    "gtid": "AUTOMATIC",\n    "isolation": "REPEATABLE READ",\n    "statements_executed": [\n      {\n        "sql_text": "INSERT INTO info VALUES (2, ''bar'')",\n        "time": "107.33 us",\n        "schema": "trx",\n        "rows_examined": 0,\n        "rows_affected": 1,\n        "rows_sent": 0,\n        "tmp_tables": 0,\n        "tmp_disk_tables": 0,\n        "sort_rows": 0,\n        "sort_merge_passes": 0\n      },\n      {\n        "sql_text": "COMMIT",\n        "time": "213.23 us",\n        "schema": "trx",\n        "rows_examined": 0,\n        "rows_affected": 0,\n        "rows_sent": 0,\n        "tmp_tables": 0,\n        "tmp_disk_tables": 0,\n        "sort_rows": 0,\n        "sort_merge_passes": 0\n      }\n    ]\n  }\n]\n1 row in set (0.03 sec)\n'
BEGIN
    DECLARE v_output LONGTEXT DEFAULT '{}';
    DECLARE v_msg_text TEXT DEFAULT '';
    DECLARE v_signal_msg TEXT DEFAULT '';
    DECLARE v_mysql_errno INT;
    DECLARE v_max_output_len BIGINT;
    -- Capture warnings/errors such as group_concat truncation
    -- and report as JSON error objects
    DECLARE EXIT HANDLER FOR SQLWARNING, SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_msg_text = MESSAGE_TEXT,
            v_mysql_errno = MYSQL_ERRNO;
        IF v_mysql_errno = 1260 THEN
            SET v_signal_msg = CONCAT('{ "error": "Trx info truncated: ', v_msg_text, '" }');
        ELSE
            SET v_signal_msg = CONCAT('{ "error": "', v_msg_text, '" }');
        END IF;
        RETURN v_signal_msg;
    END;
    -- Set configuration options
    IF (@sys.ps_thread_trx_info.max_length IS NULL) THEN
        SET @sys.ps_thread_trx_info.max_length = sys.sys_get_config('ps_thread_trx_info.max_length', 65535);
    END IF;
    IF (@sys.ps_thread_trx_info.max_length != @@session.group_concat_max_len) THEN
        SET @old_group_concat_max_len = @@session.group_concat_max_len;
        -- Convert to int value for the SET, and give some surrounding space
        SET v_max_output_len = (@sys.ps_thread_trx_info.max_length - 5);
        SET SESSION group_concat_max_len = v_max_output_len;
    END IF;
    SET v_output = (
        SELECT CONCAT('[', IFNULL(GROUP_CONCAT(trx_info ORDER BY event_id), ''), '\n]') AS trx_info
          FROM (SELECT trxi.thread_id, 
                       trxi.event_id,
                       GROUP_CONCAT(
                         IFNULL(
                           CONCAT('\n  {\n',
                                  '    "time": "', IFNULL(format_pico_time(trxi.timer_wait), ''), '",\n',
                                  '    "state": "', IFNULL(trxi.state, ''), '",\n',
                                  '    "mode": "', IFNULL(trxi.access_mode, ''), '",\n',
                                  '    "autocommitted": "', IFNULL(trxi.autocommit, ''), '",\n',
                                  '    "gtid": "', IFNULL(trxi.gtid, ''), '",\n',
                                  '    "isolation": "', IFNULL(trxi.isolation_level, ''), '",\n',
                                  '    "statements_executed": [', IFNULL(s.stmts, ''), IF(s.stmts IS NULL, ' ]\n', '\n    ]\n'),
                                  '  }'
                           ), 
                           '') 
                         ORDER BY event_id) AS trx_info
                  FROM (
                        (SELECT thread_id, event_id, timer_wait, state,access_mode, autocommit, gtid, isolation_level
                           FROM performance_schema.events_transactions_current
                          WHERE thread_id = in_thread_id
                            AND end_event_id IS NULL)
                        UNION
                        (SELECT thread_id, event_id, timer_wait, state,access_mode, autocommit, gtid, isolation_level
                           FROM performance_schema.events_transactions_history
                          WHERE thread_id = in_thread_id)
                       ) AS trxi
                  LEFT JOIN (SELECT thread_id,
                                    nesting_event_id,
                                    GROUP_CONCAT(
                                      IFNULL(
                                        CONCAT('\n      {\n',
                                               '        "sql_text": "', IFNULL(sys.format_statement(REPLACE(sql_text, '\\', '\\\\')), ''), '",\n',
                                               '        "time": "', IFNULL(format_pico_time(timer_wait), ''), '",\n',
                                               '        "schema": "', IFNULL(current_schema, ''), '",\n',
                                               '        "rows_examined": ', IFNULL(rows_examined, ''), ',\n',
                                               '        "rows_affected": ', IFNULL(rows_affected, ''), ',\n',
                                               '        "rows_sent": ', IFNULL(rows_sent, ''), ',\n',
                                               '        "tmp_tables": ', IFNULL(created_tmp_tables, ''), ',\n',
                                               '        "tmp_disk_tables": ', IFNULL(created_tmp_disk_tables, ''), ',\n',
                                               '        "sort_rows": ', IFNULL(sort_rows, ''), ',\n',
                                               '        "sort_merge_passes": ', IFNULL(sort_merge_passes, ''), '\n',
                                               '      }'), '') ORDER BY event_id) AS stmts
                               FROM performance_schema.events_statements_history
                              WHERE sql_text IS NOT NULL
                                AND thread_id = in_thread_id
                              GROUP BY thread_id, nesting_event_id
                            ) AS s 
                    ON trxi.thread_id = s.thread_id 
                   AND trxi.event_id = s.nesting_event_id
                 WHERE trxi.thread_id = in_thread_id
                 GROUP BY trxi.thread_id, trxi.event_id
                ) trxs
          GROUP BY thread_id
    );
    IF (@old_group_concat_max_len IS NOT NULL) THEN
        SET SESSION group_concat_max_len = @old_group_concat_max_len;
    END IF;
    RETURN v_output;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `quote_identifier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `quote_identifier`(in_identifier TEXT) RETURNS text CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes an unquoted identifier (schema name, table name, etc.) and\nreturns the identifier quoted with backticks.\n\nParameters\n-----------\n\nin_identifier (TEXT):\n  The identifier to quote.\n\nReturns\n-----------\n\nTEXT CHARSET UTF8MB4\n\nExample\n-----------\n\nmysql> SELECT sys.quote_identifier(''my_identifier'') AS Identifier;\n+-----------------+\n| Identifier      |\n+-----------------+\n| `my_identifier` |\n+-----------------+\n1 row in set (0.00 sec)\n\nmysql> SELECT sys.quote_identifier(''my`idenfier'') AS Identifier;\n+----------------+\n| Identifier     |\n+----------------+\n| `my``idenfier` |\n+----------------+\n1 row in set (0.00 sec)\n'
BEGIN
    RETURN CONCAT('`', REPLACE(in_identifier, '`', '``'), '`');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `sys_get_config` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `sys_get_config`(
        in_variable_name VARCHAR(128),
        in_default_value VARCHAR(128)
    ) RETURNS varchar(128) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns the value for the requested variable using the following logic:\n\n   1. If the option exists in sys.sys_config return the value from there.\n   2. Else fall back on the provided default value.\n\nNotes for using sys_get_config():\n\n   * If the default value argument to sys_get_config() is NULL and case 2. is reached, NULL is returned.\n     It is then expected that the caller is able to handle NULL for the given configuration option.\n   * The convention is to name the user variables @sys.<name of variable>. It is <name of variable> that\n     is stored in the sys_config table and is what is expected as the argument to sys_get_config().\n   * If you want to check whether the configuration option has already been set and if not assign with\n     the return value of sys_get_config() you can use IFNULL(...) (see example below). However this should\n     not be done inside a loop (e.g. for each row in a result set) as for repeated calls where assignment\n     is only needed in the first iteration using IFNULL(...) is expected to be significantly slower than\n     using an IF (...) THEN ... END IF; block (see example below).\n\nParameters\n-----------\n\nin_variable_name (VARCHAR(128)):\n  The name of the config option to return the value for.\n\nin_default_value (VARCHAR(128)):\n  The default value to return if the variable does not exist in sys.sys_config.\n\nReturns\n-----------\n\nVARCHAR(128)\n\nExample\n-----------\n\n-- Get the configuration value from sys.sys_config falling back on 128 if the option is not present in the table.\nmysql> SELECT sys.sys_get_config(''statement_truncate_len'', 128) AS Value;\n+-------+\n| Value |\n+-------+\n| 64    |\n+-------+\n1 row in set (0.00 sec)\n\n-- Check whether the option is already set, if not assign - IFNULL(...) one liner example.\nmysql> SET @sys.statement_truncate_len = IFNULL(@sys.statement_truncate_len, sys.sys_get_config(''statement_truncate_len'', 64));\nQuery OK, 0 rows affected (0.00 sec)\n\n-- Check whether the option is already set, if not assign - IF ... THEN ... END IF example.\nIF (@sys.statement_truncate_len IS NULL) THEN\n    SET @sys.statement_truncate_len = sys.sys_get_config(''statement_truncate_len'', 64);\nEND IF;\n'
BEGIN
    DECLARE v_value VARCHAR(128) DEFAULT NULL;
    -- Check if we have the variable in the sys.sys_config table
    SET v_value = (SELECT value FROM sys.sys_config WHERE variable = in_variable_name);
    -- Protection against the variable not existing in sys_config
    IF (v_value IS NULL) THEN
        SET v_value = in_default_value;
    END IF;
    RETURN v_value;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `version_major` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `version_major`() RETURNS tinyint unsigned
    NO SQL
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns the major version of MySQL Server.\n\nReturns\n-----------\n\nTINYINT UNSIGNED\n\nExample\n-----------\n\nmysql> SELECT VERSION(), sys.version_major();\n+--------------------------------------+---------------------+\n| VERSION()                            | sys.version_major() |\n+--------------------------------------+---------------------+\n| 5.7.9-enterprise-commercial-advanced | 5                   |\n+--------------------------------------+---------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    RETURN SUBSTRING_INDEX(SUBSTRING_INDEX(VERSION(), '-', 1), '.', 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `version_minor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `version_minor`() RETURNS tinyint unsigned
    NO SQL
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns the minor (release series) version of MySQL Server.\n\nReturns\n-----------\n\nTINYINT UNSIGNED\n\nExample\n-----------\n\nmysql> SELECT VERSION(), sys.server_minor();\n+--------------------------------------+---------------------+\n| VERSION()                            | sys.version_minor() |\n+--------------------------------------+---------------------+\n| 5.7.9-enterprise-commercial-advanced | 7                   |\n+--------------------------------------+---------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    RETURN SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(VERSION(), '-', 1), '.', 2), '.', -1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `version_patch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` FUNCTION `version_patch`() RETURNS tinyint unsigned
    NO SQL
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReturns the patch release version of MySQL Server.\n\nReturns\n-----------\n\nTINYINT UNSIGNED\n\nExample\n-----------\n\nmysql> SELECT VERSION(), sys.version_patch();\n+--------------------------------------+---------------------+\n| VERSION()                            | sys.version_patch() |\n+--------------------------------------+---------------------+\n| 5.7.9-enterprise-commercial-advanced | 9                   |\n+--------------------------------------+---------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    RETURN SUBSTRING_INDEX(SUBSTRING_INDEX(VERSION(), '-', 1), '.', -1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_synonym_db` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `create_synonym_db`(
        IN in_db_name VARCHAR(64), 
        IN in_synonym VARCHAR(64)
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes a source database name and synonym name, and then creates the \nsynonym database with views that point to all of the tables within\nthe source database.\n\nUseful for creating a "ps" synonym for "performance_schema",\nor "is" instead of "information_schema", for example.\n\nParameters\n-----------\n\nin_db_name (VARCHAR(64)):\n  The database name that you would like to create a synonym for.\nin_synonym (VARCHAR(64)):\n  The database synonym name.\n\nExample\n-----------\n\nmysql> SHOW DATABASES;\n+--------------------+\n| Database           |\n+--------------------+\n| information_schema |\n| mysql              |\n| performance_schema |\n| sys                |\n| test               |\n+--------------------+\n5 rows in set (0.00 sec)\n\nmysql> CALL sys.create_synonym_db(''performance_schema'', ''ps'');\n+---------------------------------------+\n| summary                               |\n+---------------------------------------+\n| Created 74 views in the `ps` database |\n+---------------------------------------+\n1 row in set (8.57 sec)\n\nQuery OK, 0 rows affected (8.57 sec)\n\nmysql> SHOW DATABASES;\n+--------------------+\n| Database           |\n+--------------------+\n| information_schema |\n| mysql              |\n| performance_schema |\n| ps                 |\n| sys                |\n| test               |\n+--------------------+\n6 rows in set (0.00 sec)\n\nmysql> SHOW FULL TABLES FROM ps;\n+------------------------------------------------------+------------+\n| Tables_in_ps                                         | Table_type |\n+------------------------------------------------------+------------+\n| accounts                                             | VIEW       |\n| cond_instances                                       | VIEW       |\n| events_stages_current                                | VIEW       |\n| events_stages_history                                | VIEW       |\n...\n'
BEGIN
    DECLARE v_done bool DEFAULT FALSE;
    DECLARE v_db_name_check VARCHAR(64);
    DECLARE v_db_err_msg TEXT;
    DECLARE v_table VARCHAR(64);
    DECLARE v_views_created INT DEFAULT 0;
    DECLARE db_doesnt_exist CONDITION FOR SQLSTATE '42000';
    DECLARE db_name_exists CONDITION FOR SQLSTATE 'HY000';
    DECLARE c_table_names CURSOR FOR 
        SELECT TABLE_NAME 
          FROM INFORMATION_SCHEMA.TABLES 
         WHERE TABLE_SCHEMA = in_db_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    -- Check if the source database exists
    SELECT SCHEMA_NAME INTO v_db_name_check
      FROM INFORMATION_SCHEMA.SCHEMATA
     WHERE SCHEMA_NAME = in_db_name;
    IF v_db_name_check IS NULL THEN
        SET v_db_err_msg = CONCAT('Unknown database ', in_db_name);
        SIGNAL SQLSTATE 'HY000'
            SET MESSAGE_TEXT = v_db_err_msg;
    END IF;
    -- Check if a database of the synonym name already exists
    SELECT SCHEMA_NAME INTO v_db_name_check
      FROM INFORMATION_SCHEMA.SCHEMATA
     WHERE SCHEMA_NAME = in_synonym;
    IF v_db_name_check = in_synonym THEN
        SET v_db_err_msg = CONCAT('Can\'t create database ', in_synonym, '; database exists');
        SIGNAL SQLSTATE 'HY000'
            SET MESSAGE_TEXT = v_db_err_msg;
    END IF;
    -- All good, create the database and views
    SET @create_db_stmt := CONCAT('CREATE DATABASE ', sys.quote_identifier(in_synonym));
    PREPARE create_db_stmt FROM @create_db_stmt;
    EXECUTE create_db_stmt;
    DEALLOCATE PREPARE create_db_stmt;
    SET v_done = FALSE;
    OPEN c_table_names;
    c_table_names: LOOP
        FETCH c_table_names INTO v_table;
        IF v_done THEN
            LEAVE c_table_names;
        END IF;
        SET @create_view_stmt = CONCAT(
            'CREATE SQL SECURITY INVOKER VIEW ',
            sys.quote_identifier(in_synonym),
            '.',
            sys.quote_identifier(v_table),
            ' AS SELECT * FROM ',
            sys.quote_identifier(in_db_name),
            '.',
            sys.quote_identifier(v_table)
        );
        PREPARE create_view_stmt FROM @create_view_stmt;
        EXECUTE create_view_stmt;
        DEALLOCATE PREPARE create_view_stmt;
        SET v_views_created = v_views_created + 1;
    END LOOP;
    CLOSE c_table_names;
    SELECT CONCAT(
        'Created ', v_views_created, ' view',
        IF(v_views_created != 1, 's', ''), ' in the ',
        sys.quote_identifier(in_synonym), ' database'
    ) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `diagnostics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `diagnostics`(
        IN in_max_runtime int unsigned, IN in_interval int unsigned,
        IN in_auto_config enum ('current', 'medium', 'full')
    )
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nCreate a report of the current status of the server for diagnostics purposes. Data collected includes (some items depends on versions and settings):\n\n   * The GLOBAL VARIABLES\n   * Several sys schema views including metrics or equivalent (depending on version and settings)\n   * Queries in the 95th percentile\n   * Several ndbinfo views for MySQL Cluster\n   * Replication (both master and slave) information.\n\nSome of the sys schema views are calculated as initial (optional), overall, delta:\n\n   * The initial view is the content of the view at the start of this procedure.\n     This output will be the same as the the start values used for the delta view.\n     The initial view is included if @sys.diagnostics.include_raw = ''ON''.\n   * The overall view is the content of the view at the end of this procedure.\n     This output is the same as the end values used for the delta view.\n     The overall view is always included.\n   * The delta view is the difference from the beginning to the end. Note that for min and max values\n     they are simply the min or max value from the end view respectively, so does not necessarily reflect\n     the minimum/maximum value in the monitored period.\n     Note: except for the metrics views the delta is only calculation between the first and last outputs.\n\nRequires the SUPER privilege for "SET sql_log_bin = 0;".\n\nParameters\n-----------\n\nin_max_runtime (INT UNSIGNED):\n  The maximum time to keep collecting data.\n  Use NULL to get the default which is 60 seconds, otherwise enter a value greater than 0.\nin_interval (INT UNSIGNED):\n  How long to sleep between data collections.\n  Use NULL to get the default which is 30 seconds, otherwise enter a value greater than 0.\nin_auto_config (ENUM(''current'', ''medium'', ''full''))\n  Automatically enable Performance Schema instruments and consumers.\n  NOTE: The more that are enabled, the more impact on the performance.\n  Supported values are:\n     * current - use the current settings.\n     * medium - enable some settings. This requires the SUPER privilege.\n     * full - enables all settings. This will have a big impact on the\n              performance - be careful using this option. This requires\n              the SUPER privilege.\n  If another setting the ''current'' is chosen, the current settings\n  are restored at the end of the procedure.\n\n\nConfiguration Options\n----------------------\n\nsys.diagnostics.allow_i_s_tables\n  Specifies whether it is allowed to do table scan queries on information_schema.TABLES. This can be expensive if there\n  are many tables. Set to ''ON'' to allow, ''OFF'' to not allow.\n  Default is ''OFF''.\n\nsys.diagnostics.include_raw\n  Set to ''ON'' to include the raw data (e.g. the original output of "SELECT * FROM sys.metrics").\n  Use this to get the initial values of the various views.\n  Default is ''OFF''.\n\nsys.statement_truncate_len\n  How much of queries in the process list output to include.\n  Default is 64.\n\nsys.debug\n  Whether to provide debugging output.\n  Default is ''OFF''. Set to ''ON'' to include.\n\n\nExample\n--------\n\nTo create a report and append it to the file diag.out:\n\nmysql> TEE diag.out;\nmysql> CALL sys.diagnostics(120, 30, ''current'');\n...\nmysql> NOTEE;\n'
BEGIN
    DECLARE v_start, v_runtime, v_iter_start, v_sleep DECIMAL(20,2) DEFAULT 0.0;
    DECLARE v_has_innodb, v_has_ndb, v_has_ps, v_has_replication, v_has_ps_replication VARCHAR(8) CHARSET utf8mb4 DEFAULT 'NO';
    DECLARE v_this_thread_enabled  ENUM('YES', 'NO');
    DECLARE v_table_name, v_banner VARCHAR(64) CHARSET utf8mb4;
    DECLARE v_sql_status_summary_select, v_sql_status_summary_delta, v_sql_status_summary_from, v_no_delta_names TEXT;
    DECLARE v_output_time, v_output_time_prev DECIMAL(20,3) UNSIGNED;
    DECLARE v_output_count, v_count, v_old_group_concat_max_len INT UNSIGNED DEFAULT 0;
    -- The width of each of the status outputs in the summery
    DECLARE v_status_summary_width TINYINT UNSIGNED DEFAULT 50;
    DECLARE v_done BOOLEAN DEFAULT FALSE;
    -- Do not include the following ndbinfo views:
    --    'blocks'                    Static
    --    'config_params'             Static
    --    'dict_obj_types'            Static
    --    'disk_write_speed_base'     Can generate lots of output - only include aggregate views here
    --    'memory_per_fragment'       Can generate lots of output
    --    'memoryusage'               Handled separately
    --    'operations_per_fragment'   Can generate lots of output
    --    'threadblocks'              Only needed once
    DECLARE c_ndbinfo CURSOR FOR
        SELECT TABLE_NAME
          FROM information_schema.TABLES
         WHERE TABLE_SCHEMA = 'ndbinfo'
               AND TABLE_NAME NOT IN (
                  'blocks',
                  'config_params',
                  'dict_obj_types',
                  'disk_write_speed_base',
                  'memory_per_fragment',
                  'memoryusage',
                  'operations_per_fragment',
                  'threadblocks'
               );
    DECLARE c_sysviews_w_delta CURSOR FOR
        SELECT table_name
          FROM tmp_sys_views_delta
         ORDER BY table_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    -- Do not track the current thread - no reason to clutter the output
    SELECT INSTRUMENTED INTO v_this_thread_enabled FROM performance_schema.threads WHERE PROCESSLIST_ID = CONNECTION_ID();
    IF (v_this_thread_enabled = 'YES') THEN
        CALL sys.ps_setup_disable_thread(CONNECTION_ID());
    END IF;
    -- Check options are sane
    IF (in_max_runtime < in_interval) THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'in_max_runtime must be greater than or equal to in_interval';
    END IF;
    IF (in_max_runtime = 0) THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'in_max_runtime must be greater than 0';
    END IF;
    IF (in_interval = 0) THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'in_interval must be greater than 0';
    END IF;
    -- Set configuration options
    IF (@sys.diagnostics.allow_i_s_tables IS NULL) THEN
        SET @sys.diagnostics.allow_i_s_tables = sys.sys_get_config('diagnostics.allow_i_s_tables', 'OFF');
    END IF;
    IF (@sys.diagnostics.include_raw IS NULL) THEN
        SET @sys.diagnostics.include_raw      = sys.sys_get_config('diagnostics.include_raw'     , 'OFF');
    END IF;
    IF (@sys.debug IS NULL) THEN
        SET @sys.debug                        = sys.sys_get_config('debug'                       , 'OFF');
    END IF;
    IF (@sys.statement_truncate_len IS NULL) THEN
        SET @sys.statement_truncate_len       = sys.sys_get_config('statement_truncate_len'      , '64' );
    END IF;
    -- Temporary table are used - disable sql_log_bin if necessary to prevent them replicating
    SET @log_bin := @@sql_log_bin;
    IF ((@log_bin = 1) AND (@@binlog_format = 'STATEMENT')) THEN
        SET sql_log_bin = 0;
    END IF;
    -- Some metrics variables doesn't make sense in delta and rate calculations even if they are numeric
    -- as they really are more like settings or "current" status.
    SET v_no_delta_names = CONCAT('s%{COUNT}.Variable_name NOT IN (',
        '''innodb_buffer_pool_pages_total'', ',
        '''innodb_page_size'', ',
        '''last_query_cost'', ',
        '''last_query_partial_plans'', ',
        '''qcache_total_blocks'', ',
        '''slave_last_heartbeat'', ',
        '''ssl_ctx_verify_depth'', ',
        '''ssl_ctx_verify_mode'', ',
        '''ssl_session_cache_size'', ',
        '''ssl_verify_depth'', ',
        '''ssl_verify_mode'', ',
        '''ssl_version'', ',
        '''buffer_flush_lsn_avg_rate'', ',
        '''buffer_flush_pct_for_dirty'', ',
        '''buffer_flush_pct_for_lsn'', ',
        '''buffer_pool_pages_total'', ',
        '''lock_row_lock_time_avg'', ',
        '''lock_row_lock_time_max'', ',
        '''innodb_page_size''',
    ')');
    IF (in_auto_config <> 'current') THEN
        IF (@sys.debug = 'ON') THEN
            SELECT CONCAT('Updating Performance Schema configuration to ', in_auto_config) AS 'Debug';
        END IF;
        CALL sys.ps_setup_save(0);
        IF (in_auto_config = 'medium') THEN
            -- Enable all consumers except %history and %history_long
            UPDATE performance_schema.setup_consumers
                SET ENABLED = 'YES'
            WHERE NAME NOT LIKE '%\_history%';
            -- Enable all instruments except wait/synch/%
            UPDATE performance_schema.setup_instruments
                SET ENABLED = 'YES',
                    TIMED   = 'YES'
            WHERE NAME NOT LIKE 'wait/synch/%';
        ELSEIF (in_auto_config = 'full') THEN
            UPDATE performance_schema.setup_consumers
                SET ENABLED = 'YES';
            UPDATE performance_schema.setup_instruments
                SET ENABLED = 'YES',
                    TIMED   = 'YES';
        END IF;
        -- Enable all threads except this one
        UPDATE performance_schema.threads
           SET INSTRUMENTED = 'YES'
         WHERE PROCESSLIST_ID <> CONNECTION_ID();
    END IF;
    SET v_start        = UNIX_TIMESTAMP(NOW(2)),
        in_interval    = IFNULL(in_interval, 30),
        in_max_runtime = IFNULL(in_max_runtime, 60);
    -- Get a quick ref with hostname, server UUID, and the time for the report.
    SET v_banner = REPEAT(
                      '-',
                      LEAST(
                         GREATEST(
                            36,
                            CHAR_LENGTH(VERSION()),
                            CHAR_LENGTH(@@global.version_comment),
                            CHAR_LENGTH(@@global.version_compile_os),
                            CHAR_LENGTH(@@global.version_compile_machine),
                            CHAR_LENGTH(@@global.socket),
                            CHAR_LENGTH(@@global.datadir)
                         ),
                         64
                      )
                   );
    SELECT 'Hostname' AS 'Name', @@global.hostname AS 'Value'
    UNION ALL
    SELECT 'Port' AS 'Name', @@global.port AS 'Value'
    UNION ALL
    SELECT 'Socket' AS 'Name', @@global.socket AS 'Value'
    UNION ALL
    SELECT 'Datadir' AS 'Name', @@global.datadir AS 'Value'
    UNION ALL
    SELECT 'Server UUID' AS 'Name', @@global.server_uuid AS 'Value'
    UNION ALL
    SELECT REPEAT('-', 23) AS 'Name', v_banner AS 'Value'
    UNION ALL
    SELECT 'MySQL Version' AS 'Name', VERSION() AS 'Value'
    UNION ALL
    SELECT 'Sys Schema Version' AS 'Name', (SELECT sys_version FROM sys.version) AS 'Value'
    UNION ALL
    SELECT 'Version Comment' AS 'Name', @@global.version_comment AS 'Value'
    UNION ALL
    SELECT 'Version Compile OS' AS 'Name', @@global.version_compile_os AS 'Value'
    UNION ALL
    SELECT 'Version Compile Machine' AS 'Name', @@global.version_compile_machine AS 'Value'
    UNION ALL
    SELECT REPEAT('-', 23) AS 'Name', v_banner AS 'Value'
    UNION ALL
    SELECT 'UTC Time' AS 'Name', UTC_TIMESTAMP() AS 'Value'
    UNION ALL
    SELECT 'Local Time' AS 'Name', NOW() AS 'Value'
    UNION ALL
    SELECT 'Time Zone' AS 'Name', @@global.time_zone AS 'Value'
    UNION ALL
    SELECT 'System Time Zone' AS 'Name', @@global.system_time_zone AS 'Value'
    UNION ALL
    SELECT 'Time Zone Offset' AS 'Name', TIMEDIFF(NOW(), UTC_TIMESTAMP()) AS 'Value';
    -- Are the InnoDB, NDBCluster, and Performance Schema storage engines present?
    SET v_has_innodb         = IFNULL((SELECT SUPPORT FROM information_schema.ENGINES WHERE ENGINE = 'InnoDB'), 'NO'),
        v_has_ndb            = IFNULL((SELECT SUPPORT FROM information_schema.ENGINES WHERE ENGINE = 'NDBCluster'), 'NO'),
        v_has_ps             = IFNULL((SELECT SUPPORT FROM information_schema.ENGINES WHERE ENGINE = 'PERFORMANCE_SCHEMA'), 'NO'),
        v_has_ps_replication = v_has_ps,
        v_has_replication    = IF(v_has_ps_replication = 'YES', IF((SELECT COUNT(*) FROM performance_schema.replication_connection_status) > 0, 'YES', 'NO'),
                                  IF(@@master_info_repository = 'TABLE', IF((SELECT COUNT(*) FROM mysql.slave_master_info) > 0, 'YES', 'NO'),
                                     IF(@@relay_log_info_repository = 'TABLE', IF((SELECT COUNT(*) FROM mysql.slave_relay_log_info) > 0, 'YES', 'NO'),
                                        'MAYBE')));
    IF (@sys.debug = 'ON') THEN
       SELECT v_has_innodb AS 'Has_InnoDB', v_has_ndb AS 'Has_NDBCluster',
              v_has_ps AS 'Has_Performance_Schema',
              v_has_ps_replication 'AS Has_P_S_Replication', v_has_replication AS 'Has_Replication';
    END IF;
    IF (v_has_innodb IN ('DEFAULT', 'YES')) THEN
        -- Need to use prepared statement as just having the query as a plain command
        -- will generate an error if the InnoDB storage engine is not present
        SET @sys.diagnostics.sql = 'SHOW ENGINE InnoDB STATUS';
        PREPARE stmt_innodb_status FROM @sys.diagnostics.sql;
    END IF;
    IF (v_has_ps = 'YES') THEN
        -- Need to use prepared statement as just having the query as a plain command
        -- will generate an error if the InnoDB storage engine is not present
        SET @sys.diagnostics.sql = 'SHOW ENGINE PERFORMANCE_SCHEMA STATUS';
        PREPARE stmt_ps_status FROM @sys.diagnostics.sql;
    END IF;
    IF (v_has_ndb IN ('DEFAULT', 'YES')) THEN
        -- Need to use prepared statement as just having the query as a plain command
        -- will generate an error if the NDBCluster storage engine is not present
        SET @sys.diagnostics.sql = 'SHOW ENGINE NDBCLUSTER STATUS';
        PREPARE stmt_ndbcluster_status FROM @sys.diagnostics.sql;
    END IF;
    SET @sys.diagnostics.sql_gen_query_template = 'SELECT CONCAT(
           ''SELECT '',
           GROUP_CONCAT(
               CASE WHEN (SUBSTRING(TABLE_NAME, 3), COLUMN_NAME) IN (
                                (''io_global_by_file_by_bytes'', ''total''),
                                (''io_global_by_wait_by_bytes'', ''total_requested'')
                         )
                         THEN CONCAT(''format_bytes('', COLUMN_NAME, '') AS '', COLUMN_NAME)
                    WHEN COLUMN_NAME LIKE ''%latency''
                         THEN CONCAT(''format_pico_time('', COLUMN_NAME, '') AS '', COLUMN_NAME)
                    WHEN SUBSTRING(COLUMN_NAME, -7) = ''_memory'' OR SUBSTRING(COLUMN_NAME, -17) = ''_memory_allocated''
                         OR ((SUBSTRING(COLUMN_NAME, -5) = ''_read'' OR SUBSTRING(COLUMN_NAME, -8) = ''_written'' OR SUBSTRING(COLUMN_NAME, -6) = ''_write'') AND SUBSTRING(COLUMN_NAME, 1, 6) <> ''COUNT_'')
                         THEN CONCAT(''format_bytes('', COLUMN_NAME, '') AS '', COLUMN_NAME)
                    ELSE COLUMN_NAME
               END
               ORDER BY ORDINAL_POSITION
               SEPARATOR '',\n       ''
           ),
           ''\n  FROM tmp_'', SUBSTRING(TABLE_NAME FROM 3), ''_%{OUTPUT}''
       ) AS Query INTO @sys.diagnostics.sql_select
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = ''sys'' AND TABLE_NAME = ?
 GROUP BY TABLE_NAME';
    SET @sys.diagnostics.sql_gen_query_delta = 'SELECT CONCAT(
           ''SELECT '',
           GROUP_CONCAT(
               CASE WHEN FIND_IN_SET(COLUMN_NAME COLLATE utf8mb3_general_ci, diag.pk)
                         THEN COLUMN_NAME
                    WHEN diag.TABLE_NAME = ''io_global_by_file_by_bytes'' AND COLUMN_NAME COLLATE utf8mb3_general_ci = ''write_pct''
                         THEN CONCAT(''IFNULL(ROUND(100-(((e.total_read-IFNULL(s.total_read, 0))'',
                                     ''/NULLIF(((e.total_read-IFNULL(s.total_read, 0))+(e.total_written-IFNULL(s.total_written, 0))), 0))*100), 2), 0.00) AS '',
                                     COLUMN_NAME)
                    WHEN (diag.TABLE_NAME, COLUMN_NAME) IN (
                                (''io_global_by_file_by_bytes'', ''total''),
                                (''io_global_by_wait_by_bytes'', ''total_requested'')
                         )
                         THEN CONCAT(''format_bytes(e.'', COLUMN_NAME, ''-IFNULL(s.'', COLUMN_NAME, '', 0)) AS '', COLUMN_NAME)
                    WHEN SUBSTRING(COLUMN_NAME, 1, 4) IN (''max_'', ''min_'') AND SUBSTRING(COLUMN_NAME, -8) = ''_latency''
                         THEN CONCAT(''format_pico_time(e.'', COLUMN_NAME, '') AS '', COLUMN_NAME)
                    WHEN COLUMN_NAME COLLATE utf8mb3_general_ci = ''avg_latency''
                         THEN CONCAT(''format_pico_time((e.total_latency - IFNULL(s.total_latency, 0))'',
                                     ''/NULLIF(e.total - IFNULL(s.total, 0), 0)) AS '', COLUMN_NAME)
                    WHEN SUBSTRING(COLUMN_NAME, -12) = ''_avg_latency''
                         THEN CONCAT(''format_pico_time((e.'', SUBSTRING(COLUMN_NAME FROM 1 FOR CHAR_LENGTH(COLUMN_NAME)-12), ''_latency - IFNULL(s.'', SUBSTRING(COLUMN_NAME FROM 1 FOR CHAR_LENGTH(COLUMN_NAME)-12), ''_latency, 0))'',
                                     ''/NULLIF(e.'', SUBSTRING(COLUMN_NAME FROM 1 FOR CHAR_LENGTH(COLUMN_NAME)-12), ''s - IFNULL(s.'', SUBSTRING(COLUMN_NAME FROM 1 FOR CHAR_LENGTH(COLUMN_NAME)-12), ''s, 0), 0)) AS '', COLUMN_NAME)
                    WHEN COLUMN_NAME LIKE ''%latency''
                         THEN CONCAT(''format_pico_time(e.'', COLUMN_NAME, '' - IFNULL(s.'', COLUMN_NAME, '', 0)) AS '', COLUMN_NAME)
                    WHEN COLUMN_NAME IN (''avg_read'', ''avg_write'', ''avg_written'')
                         THEN CONCAT(''format_bytes(IFNULL((e.total_'', IF(COLUMN_NAME = ''avg_read'', ''read'', ''written''), ''-IFNULL(s.total_'', IF(COLUMN_NAME = ''avg_read'', ''read'', ''written''), '', 0))'',
                                     ''/NULLIF(e.count_'', IF(COLUMN_NAME = ''avg_read'', ''read'', ''write''), ''-IFNULL(s.count_'', IF(COLUMN_NAME = ''avg_read'', ''read'', ''write''), '', 0), 0), 0)) AS '',
                                     COLUMN_NAME)
                    WHEN SUBSTRING(COLUMN_NAME, -7) = ''_memory'' OR SUBSTRING(COLUMN_NAME, -17) = ''_memory_allocated''
                         OR ((SUBSTRING(COLUMN_NAME, -5) = ''_read'' OR SUBSTRING(COLUMN_NAME, -8) = ''_written'' OR SUBSTRING(COLUMN_NAME, -6) = ''_write'') AND SUBSTRING(COLUMN_NAME, 1, 6) <> ''COUNT_'')
                         THEN CONCAT(''format_bytes(e.'', COLUMN_NAME, '' - IFNULL(s.'', COLUMN_NAME, '', 0)) AS '', COLUMN_NAME)
                    ELSE CONCAT(''(e.'', COLUMN_NAME, '' - IFNULL(s.'', COLUMN_NAME, '', 0)) AS '', COLUMN_NAME)
               END
               ORDER BY ORDINAL_POSITION
               SEPARATOR '',\n       ''
           ),
           ''\n  FROM tmp_'', diag.TABLE_NAME, ''_end e
       LEFT OUTER JOIN tmp_'', diag.TABLE_NAME, ''_start s USING ('', diag.pk, '')''
       ) AS Query INTO @sys.diagnostics.sql_select
  FROM tmp_sys_views_delta diag
       INNER JOIN information_schema.COLUMNS c ON c.TABLE_NAME COLLATE utf8mb3_general_ci = CONCAT(''x$'', diag.TABLE_NAME)
 WHERE c.TABLE_SCHEMA = ''sys'' AND diag.TABLE_NAME = ?
 GROUP BY diag.TABLE_NAME';
    IF (v_has_ps = 'YES') THEN
        -- Create temporary table with the ORDER BY clauses. Will be required both for the initial (if included) and end queries
        DROP TEMPORARY TABLE IF EXISTS tmp_sys_views_delta;
        CREATE TEMPORARY TABLE tmp_sys_views_delta (
            TABLE_NAME varchar(64) NOT NULL,
            order_by text COMMENT 'ORDER BY clause for the initial and overall views',
            order_by_delta text COMMENT 'ORDER BY clause for the delta views',
            where_delta text COMMENT 'WHERE clause to use for delta views to only include rows with a "count" > 0',
            limit_rows int unsigned COMMENT 'The maximum number of rows to include for the view',
            pk varchar(128) COMMENT 'Used with the FIND_IN_SET() function so use comma separated list without whitespace',
            PRIMARY KEY (TABLE_NAME)
        );
        -- %{OUTPUT} will be replace by the suffix used for the output.
        IF (@sys.debug = 'ON') THEN
            SELECT 'Populating tmp_sys_views_delta' AS 'Debug';
        END IF;
        INSERT INTO tmp_sys_views_delta
        VALUES ('host_summary'                       , '%{TABLE}.statement_latency DESC',
                                                       '(e.statement_latency-IFNULL(s.statement_latency, 0)) DESC',
                                                       '(e.statements - IFNULL(s.statements, 0)) > 0', NULL, 'host'),
               ('host_summary_by_file_io'            , '%{TABLE}.io_latency DESC',
                                                       '(e.io_latency-IFNULL(s.io_latency, 0)) DESC',
                                                       '(e.ios - IFNULL(s.ios, 0)) > 0', NULL, 'host'),
               ('host_summary_by_file_io_type'       , '%{TABLE}.host, %{TABLE}.total_latency DESC',
                                                       'e.host, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'host,event_name'),
               ('host_summary_by_stages'             , '%{TABLE}.host, %{TABLE}.total_latency DESC',
                                                       'e.host, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'host,event_name'),
               ('host_summary_by_statement_latency'  , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'host'),
               ('host_summary_by_statement_type'     , '%{TABLE}.host, %{TABLE}.total_latency DESC',
                                                       'e.host, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'host,statement'),
               ('io_by_thread_by_latency'            , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'user,thread_id,processlist_id'),
               ('io_global_by_file_by_bytes'         , '%{TABLE}.total DESC',
                                                       '(e.total-IFNULL(s.total, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', 100, 'file'),
               ('io_global_by_file_by_latency'       , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', 100, 'file'),
               ('io_global_by_wait_by_bytes'         , '%{TABLE}.total_requested DESC',
                                                       '(e.total_requested-IFNULL(s.total_requested, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'event_name'),
               ('io_global_by_wait_by_latency'       , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'event_name'),
               ('schema_index_statistics'            , '(%{TABLE}.select_latency+%{TABLE}.insert_latency+%{TABLE}.update_latency+%{TABLE}.delete_latency) DESC',
                                                       '((e.select_latency+e.insert_latency+e.update_latency+e.delete_latency)-IFNULL(s.select_latency+s.insert_latency+s.update_latency+s.delete_latency, 0)) DESC',
                                                       '((e.rows_selected+e.insert_latency+e.rows_updated+e.rows_deleted)-IFNULL(s.rows_selected+s.rows_inserted+s.rows_updated+s.rows_deleted, 0)) > 0',
                                                       100, 'table_schema,table_name,index_name'),
               ('schema_table_statistics'            , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) > 0', 100, 'table_schema,table_name'),
               ('schema_tables_with_full_table_scans', '%{TABLE}.rows_full_scanned DESC',
                                                       '(e.rows_full_scanned-IFNULL(s.rows_full_scanned, 0)) DESC',
                                                       '(e.rows_full_scanned-IFNULL(s.rows_full_scanned, 0)) > 0', 100, 'object_schema,object_name'),
               ('user_summary'                       , '%{TABLE}.statement_latency DESC',
                                                       '(e.statement_latency-IFNULL(s.statement_latency, 0)) DESC',
                                                       '(e.statements - IFNULL(s.statements, 0)) > 0', NULL, 'user'),
               ('user_summary_by_file_io'            , '%{TABLE}.io_latency DESC',
                                                       '(e.io_latency-IFNULL(s.io_latency, 0)) DESC',
                                                       '(e.ios - IFNULL(s.ios, 0)) > 0', NULL, 'user'),
               ('user_summary_by_file_io_type'       , '%{TABLE}.user, %{TABLE}.latency DESC',
                                                       'e.user, (e.latency-IFNULL(s.latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'user,event_name'),
               ('user_summary_by_stages'             , '%{TABLE}.user, %{TABLE}.total_latency DESC',
                                                       'e.user, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'user,event_name'),
               ('user_summary_by_statement_latency'  , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'user'),
               ('user_summary_by_statement_type'     , '%{TABLE}.user, %{TABLE}.total_latency DESC',
                                                       'e.user, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'user,statement'),
               ('wait_classes_global_by_avg_latency' , 'IFNULL(%{TABLE}.total_latency / NULLIF(%{TABLE}.total, 0), 0) DESC',
                                                       'IFNULL((e.total_latency-IFNULL(s.total_latency, 0)) / NULLIF((e.total - IFNULL(s.total, 0)), 0), 0) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'event_class'),
               ('wait_classes_global_by_latency'     , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'event_class'),
               ('waits_by_host_by_latency'           , '%{TABLE}.host, %{TABLE}.total_latency DESC',
                                                       'e.host, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'host,event'),
               ('waits_by_user_by_latency'           , '%{TABLE}.user, %{TABLE}.total_latency DESC',
                                                       'e.user, (e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'user,event'),
               ('waits_global_by_latency'            , '%{TABLE}.total_latency DESC',
                                                       '(e.total_latency-IFNULL(s.total_latency, 0)) DESC',
                                                       '(e.total - IFNULL(s.total, 0)) > 0', NULL, 'events')
        ;
    END IF;
    SELECT '

=======================

     Configuration

=======================

' AS '';
    -- Get the configuration.
    SELECT 'GLOBAL VARIABLES' AS 'The following output is:';
    SELECT LOWER(VARIABLE_NAME) AS Variable_name, VARIABLE_VALUE AS Variable_value FROM performance_schema.global_variables ORDER BY VARIABLE_NAME;
    IF (v_has_ps = 'YES') THEN
        -- Overview of the Performance Schema dynamic settings used for this report.
        SELECT 'Performance Schema Setup - Actors' AS 'The following output is:';
        SELECT * FROM performance_schema.setup_actors;
        SELECT 'Performance Schema Setup - Consumers' AS 'The following output is:';
        SELECT NAME AS Consumer, ENABLED, sys.ps_is_consumer_enabled(NAME) AS COLLECTS
          FROM performance_schema.setup_consumers;
        SELECT 'Performance Schema Setup - Instruments' AS 'The following output is:';
        SELECT SUBSTRING_INDEX(NAME, '/', 2) AS 'InstrumentClass',
               ROUND(100*SUM(IF(ENABLED = 'YES', 1, 0))/COUNT(*), 2) AS 'EnabledPct',
               ROUND(100*SUM(IF(TIMED = 'YES', 1, 0))/COUNT(*), 2) AS 'TimedPct'
          FROM performance_schema.setup_instruments
         GROUP BY SUBSTRING_INDEX(NAME, '/', 2)
         ORDER BY SUBSTRING_INDEX(NAME, '/', 2);
        SELECT 'Performance Schema Setup - Objects' AS 'The following output is:';
        SELECT * FROM performance_schema.setup_objects;
        SELECT 'Performance Schema Setup - Threads' AS 'The following output is:';
        SELECT `TYPE` AS ThreadType, COUNT(*) AS 'Total', ROUND(100*SUM(IF(INSTRUMENTED = 'YES', 1, 0))/COUNT(*), 2) AS 'InstrumentedPct'
          FROM performance_schema.threads
        GROUP BY TYPE;
    END IF;
    IF (v_has_replication = 'NO') THEN
        SELECT 'No Replication Configured' AS 'Replication Status';
    ELSE
        -- No guarantee that replication is actually configured, but we can't really know
        SELECT CONCAT('Replication Configured: ', v_has_replication, ' - Performance Schema Replication Tables: ', v_has_ps_replication) AS 'Replication Status';
        IF (v_has_ps_replication = 'YES') THEN
            SELECT 'Replication - Connection Configuration' AS 'The following output is:';
            SELECT * FROM performance_schema.replication_connection_configuration ORDER BY CHANNEL_NAME;
        END IF;
        IF (v_has_ps_replication = 'YES') THEN
            SELECT 'Replication - Applier Configuration' AS 'The following output is:';
            SELECT * FROM performance_schema.replication_applier_configuration ORDER BY CHANNEL_NAME;
        END IF;
        IF (@@master_info_repository = 'TABLE') THEN
            SELECT 'Replication - Master Info Repository Configuration' AS 'The following output is:';
            -- Can't just do SELECT *  as the password may be present in plain text
            -- Don't include binary log file and position as that will be determined in each iteration as well
            SELECT Channel_name, Host, User_name, Port, Connect_retry,
                   Enabled_ssl, Ssl_ca, Ssl_capath, Ssl_cert, Ssl_cipher, Ssl_key, Ssl_verify_server_cert,
                   Heartbeat, Bind, Ignored_server_ids, Uuid, Retry_count, Ssl_crl, Ssl_crlpath,
                   Tls_version, Enabled_auto_position
              FROM mysql.slave_master_info ORDER BY Channel_name;
        END IF;
        IF (@@relay_log_info_repository = 'TABLE') THEN
            SELECT 'Replication - Relay Log Repository Configuration' AS 'The following output is:';
            SELECT Channel_name, Sql_delay, Number_of_workers, Id
              FROM mysql.slave_relay_log_info ORDER BY Channel_name;
        END IF;
    END IF;
    IF (v_has_ndb IN ('DEFAULT', 'YES')) THEN
       SELECT 'Cluster Thread Blocks' AS 'The following output is:';
       SELECT * FROM ndbinfo.threadblocks;
    END IF;
    -- For a number of sys views as well as events_statements_summary_by_digest,
    -- just get the start data and then at the end output the overall and delta values
    IF (v_has_ps = 'YES') THEN
        IF (@sys.diagnostics.include_raw = 'ON') THEN
            SELECT '

========================

     Initial Status

========================

' AS '';
        END IF;
        DROP TEMPORARY TABLE IF EXISTS tmp_digests_start;
        CALL sys.statement_performance_analyzer('create_tmp', 'tmp_digests_start', NULL);
        CALL sys.statement_performance_analyzer('snapshot', NULL, NULL);
        CALL sys.statement_performance_analyzer('save', 'tmp_digests_start', NULL);
        -- Loop over the sys views where deltas should be calculated.
        IF (@sys.diagnostics.include_raw = 'ON') THEN
            SET @sys.diagnostics.sql = REPLACE(@sys.diagnostics.sql_gen_query_template, '%{OUTPUT}', 'start');
            IF (@sys.debug = 'ON') THEN
                SELECT 'The following query will be used to generate the query for each sys view' AS 'Debug';
                SELECT @sys.diagnostics.sql AS 'Debug';
            END IF;
            PREPARE stmt_gen_query FROM @sys.diagnostics.sql;
        END IF;
        SET v_done = FALSE;
        OPEN c_sysviews_w_delta;
        c_sysviews_w_delta_loop: LOOP
            FETCH c_sysviews_w_delta INTO v_table_name;
            IF v_done THEN
                LEAVE c_sysviews_w_delta_loop;
            END IF;
            IF (@sys.debug = 'ON') THEN
                SELECT CONCAT('The following queries are for storing the initial content of ', v_table_name) AS 'Debug';
            END IF;
            CALL sys.execute_prepared_stmt(CONCAT('DROP TEMPORARY TABLE IF EXISTS `tmp_', v_table_name, '_start`'));
            CALL sys.execute_prepared_stmt(CONCAT('CREATE TEMPORARY TABLE `tmp_', v_table_name, '_start` SELECT * FROM `sys`.`x$', v_table_name, '`'));
            IF (@sys.diagnostics.include_raw = 'ON') THEN
                SET @sys.diagnostics.table_name = CONCAT('x$', v_table_name);
                EXECUTE stmt_gen_query USING @sys.diagnostics.table_name;
                -- If necessary add ORDER BY and LIMIT
                SELECT CONCAT(@sys.diagnostics.sql_select,
                              IF(order_by IS NOT NULL, CONCAT('\n ORDER BY ', REPLACE(order_by, '%{TABLE}', CONCAT('tmp_', v_table_name, '_start'))), ''),
                              IF(limit_rows IS NOT NULL, CONCAT('\n LIMIT ', limit_rows), '')
                       )
                  INTO @sys.diagnostics.sql_select
                  FROM tmp_sys_views_delta
                 WHERE TABLE_NAME COLLATE utf8mb4_0900_as_ci = v_table_name;
                SELECT CONCAT('Initial ', v_table_name) AS 'The following output is:';
                CALL sys.execute_prepared_stmt(@sys.diagnostics.sql_select);
            END IF;
        END LOOP;
        CLOSE c_sysviews_w_delta;
        IF (@sys.diagnostics.include_raw = 'ON') THEN
            DEALLOCATE PREPARE stmt_gen_query;
        END IF;
    END IF;
    -- If in_include_status_summary is TRUE then a temporary table is required to store the data
    SET v_sql_status_summary_select = 'SELECT Variable_name',
        v_sql_status_summary_delta  = '',
        v_sql_status_summary_from   = '';
    -- Start the loop
    REPEAT
        SET v_output_count = v_output_count + 1;
        IF (v_output_count > 1) THEN
            -- Don't sleep on the first execution
            SET v_sleep = in_interval-(UNIX_TIMESTAMP(NOW(2))-v_iter_start);
            SELECT NOW() AS 'Time', CONCAT('Going to sleep for ', v_sleep, ' seconds. Please do not interrupt') AS 'The following output is:';
            DO SLEEP(in_interval);
        END IF;
        SET v_iter_start = UNIX_TIMESTAMP(NOW(2));
        SELECT NOW(), CONCAT('Iteration Number ', IFNULL(v_output_count, 'NULL')) AS 'The following output is:';
        -- Even in 5.7 there is no way to get all the info from SHOW MASTER|SLAVE STATUS using the Performance Schema or
        -- other tables, so include them even though they are no longer optimal solutions and if present get the additional
        -- information from the other tables available.
        IF (@@log_bin = 1) THEN
            SELECT 'SHOW MASTER STATUS' AS 'The following output is:';
            SHOW MASTER STATUS;
        END IF;
        IF (v_has_replication <> 'NO') THEN
            SELECT 'SHOW SLAVE STATUS' AS 'The following output is:';
            SHOW SLAVE STATUS;
            IF (v_has_ps_replication = 'YES') THEN
                SELECT 'Replication Connection Status' AS 'The following output is:';
                SELECT * FROM performance_schema.replication_connection_status;
                SELECT 'Replication Applier Status' AS 'The following output is:';
                SELECT * FROM performance_schema.replication_applier_status ORDER BY CHANNEL_NAME;
                SELECT 'Replication Applier Status - Coordinator' AS 'The following output is:';
                SELECT * FROM performance_schema.replication_applier_status_by_coordinator ORDER BY CHANNEL_NAME;
                SELECT 'Replication Applier Status - Worker' AS 'The following output is:';
                SELECT * FROM performance_schema.replication_applier_status_by_worker ORDER BY CHANNEL_NAME, WORKER_ID;
            END IF;
            IF (@@master_info_repository = 'TABLE') THEN
                SELECT 'Replication - Master Log Status' AS 'The following output is:';
                SELECT Master_log_name, Master_log_pos FROM mysql.slave_master_info;
            END IF;
            IF (@@relay_log_info_repository = 'TABLE') THEN
                SELECT 'Replication - Relay Log Status' AS 'The following output is:';
                SELECT sys.format_path(Relay_log_name) AS Relay_log_name, Relay_log_pos, Master_log_name, Master_log_pos FROM mysql.slave_relay_log_info;
                SELECT 'Replication - Worker Status' AS 'The following output is:';
                SELECT Id, sys.format_path(Relay_log_name) AS Relay_log_name, Relay_log_pos, Master_log_name, Master_log_pos,
                       sys.format_path(Checkpoint_relay_log_name) AS Checkpoint_relay_log_name, Checkpoint_relay_log_pos,
                       Checkpoint_master_log_name, Checkpoint_master_log_pos, Checkpoint_seqno, Checkpoint_group_size,
                       HEX(Checkpoint_group_bitmap) AS Checkpoint_group_bitmap, Channel_name
                  FROM mysql.slave_worker_info
              ORDER BY Channel_name, Id;
            END IF;
        END IF;
        -- We need one table per output as a temporary table cannot be opened twice in the same query, and we need to
        -- join the outputs in the summary at the end.
        SET v_table_name = CONCAT('tmp_metrics_', v_output_count);
        CALL sys.execute_prepared_stmt(CONCAT('DROP TEMPORARY TABLE IF EXISTS ', v_table_name));
        -- Currently information_schema.GLOBAL_STATUS has VARIABLE_VALUE as varchar(1024)
        CALL sys.execute_prepared_stmt(CONCAT('CREATE TEMPORARY TABLE ', v_table_name, ' (
  Variable_name VARCHAR(193) NOT NULL,
  Variable_value VARCHAR(1024),
  Type VARCHAR(225) NOT NULL,
  Enabled ENUM(''YES'', ''NO'', ''PARTIAL'') NOT NULL,
  PRIMARY KEY (Type, Variable_name)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4'));
        SET @sys.diagnostics.sql = CONCAT(
            'INSERT INTO ', v_table_name,
            ' SELECT Variable_name, REPLACE(Variable_value, ''\n'', ''\\\\n'') AS Variable_value, Type, Enabled FROM sys.metrics'
        );
        CALL sys.execute_prepared_stmt(@sys.diagnostics.sql);
        -- Prepare the query to retrieve the summary
        CALL sys.execute_prepared_stmt(
            CONCAT('(SELECT Variable_value INTO @sys.diagnostics.output_time FROM ', v_table_name, ' WHERE Type = ''System Time'' AND Variable_name = ''UNIX_TIMESTAMP()'')')
        );
        SET v_output_time = @sys.diagnostics.output_time;
        -- Limit each value to v_status_summary_width chars (when v_has_ndb = TRUE the values can be very wide - refer to the output here for the full values)
        -- v_sql_status_summary_select, v_sql_status_summary_delta, v_sql_status_summary_from
        SET v_sql_status_summary_select = CONCAT(v_sql_status_summary_select, ',
       CONCAT(
           LEFT(s', v_output_count, '.Variable_value, ', v_status_summary_width, '),
           IF(', REPLACE(v_no_delta_names, '%{COUNT}', v_output_count), ' AND s', v_output_count, '.Variable_value REGEXP ''^[0-9]+(\\\\.[0-9]+)?$'', CONCAT('' ('', ROUND(s', v_output_count, '.Variable_value/', v_output_time, ', 2), ''/sec)''), '''')
       ) AS ''Output ', v_output_count, ''''),
            v_sql_status_summary_from   = CONCAT(v_sql_status_summary_from, '
',
                                                    IF(v_output_count = 1, '  FROM ', '       INNER JOIN '),
                                                    v_table_name, ' s', v_output_count,
                                                    IF (v_output_count = 1, '', ' USING (Type, Variable_name)'));
        IF (v_output_count > 1) THEN
            SET v_sql_status_summary_delta  = CONCAT(v_sql_status_summary_delta, ',
       IF(', REPLACE(v_no_delta_names, '%{COUNT}', v_output_count), ' AND s', (v_output_count-1), '.Variable_value REGEXP ''^[0-9]+(\\\\.[0-9]+)?$'' AND s', v_output_count, '.Variable_value REGEXP ''^[0-9]+(\\\\.[0-9]+)?$'',
          CONCAT(IF(s', (v_output_count-1), '.Variable_value REGEXP ''^[0-9]+\\\\.[0-9]+$'' OR s', v_output_count, '.Variable_value REGEXP ''^[0-9]+\\\\.[0-9]+$'',
                    ROUND((s', v_output_count, '.Variable_value-s', (v_output_count-1), '.Variable_value), 2),
                    (s', v_output_count, '.Variable_value-s', (v_output_count-1), '.Variable_value)
                   ),
                 '' ('', ROUND((s', v_output_count, '.Variable_value-s', (v_output_count-1), '.Variable_value)/(', v_output_time, '-', v_output_time_prev, '), 2), ''/sec)''
          ),
          ''''
       ) AS ''Delta (', (v_output_count-1), ' -> ', v_output_count, ')''');
        END IF;
        SET v_output_time_prev = v_output_time;
        IF (@sys.diagnostics.include_raw = 'ON') THEN
            SELECT 'SELECT * FROM sys.metrics' AS 'The following output is:';
            -- Ensures that the output here is the same as the one used in the status summary at the end
            CALL sys.execute_prepared_stmt(CONCAT('SELECT Type, Variable_name, Enabled, Variable_value FROM ', v_table_name, ' ORDER BY Type, Variable_name'));
        END IF;
        -- InnoDB
        IF (v_has_innodb IN ('DEFAULT', 'YES')) THEN
            SELECT 'SHOW ENGINE INNODB STATUS' AS 'The following output is:';
            EXECUTE stmt_innodb_status;
            SELECT 'InnoDB - Transactions' AS 'The following output is:';
            SELECT * FROM information_schema.INNODB_TRX;
        END IF;
        -- NDBCluster
        IF (v_has_ndb IN ('DEFAULT', 'YES')) THEN
            SELECT 'SHOW ENGINE NDBCLUSTER STATUS' AS 'The following output is:';
            EXECUTE stmt_ndbcluster_status;
            SELECT 'ndbinfo.memoryusage' AS 'The following output is:';
            SELECT node_id, memory_type, format_bytes(used) AS used, used_pages, format_bytes(total) AS total, total_pages,
                   ROUND(100*(used/total), 2) AS 'Used %'
            FROM ndbinfo.memoryusage;
            -- Loop over the ndbinfo tables (except memoryusage which was handled separately above).
            -- The exact tables available are version dependent, so get the list from the Information Schema.
            SET v_done = FALSE;
            OPEN c_ndbinfo;
            c_ndbinfo_loop: LOOP
                FETCH c_ndbinfo INTO v_table_name;
                IF v_done THEN
                LEAVE c_ndbinfo_loop;
                END IF;
                SELECT CONCAT('SELECT * FROM ndbinfo.', v_table_name) AS 'The following output is:';
                CALL sys.execute_prepared_stmt(CONCAT('SELECT * FROM `ndbinfo`.`', v_table_name, '`'));
            END LOOP;
            CLOSE c_ndbinfo;
            SELECT * FROM information_schema.FILES;
        END IF;
        SELECT 'SELECT * FROM sys.processlist' AS 'The following output is:';
        SELECT processlist.* FROM sys.processlist;
        IF (v_has_ps = 'YES') THEN
            -- latest_file_io
            IF (sys.ps_is_consumer_enabled('events_waits_history_long') = 'YES') THEN
                SELECT 'SELECT * FROM sys.latest_file_io' AS 'The following output is:';
                SELECT * FROM sys.latest_file_io;
            END IF;
            -- current memory usage
            IF (EXISTS(SELECT 1 FROM performance_schema.setup_instruments WHERE NAME LIKE 'memory/%' AND ENABLED = 'YES')) THEN
                SELECT 'SELECT * FROM sys.memory_by_host_by_current_bytes' AS 'The following output is:';
                SELECT * FROM sys.memory_by_host_by_current_bytes;
                SELECT 'SELECT * FROM sys.memory_by_thread_by_current_bytes' AS 'The following output is:';
                SELECT * FROM sys.memory_by_thread_by_current_bytes;
                SELECT 'SELECT * FROM sys.memory_by_user_by_current_bytes' AS 'The following output is:';
                SELECT * FROM sys.memory_by_user_by_current_bytes;
                SELECT 'SELECT * FROM sys.memory_global_by_current_bytes' AS 'The following output is:';
                SELECT * FROM sys.memory_global_by_current_bytes;
            END IF;
        END IF;
        SET v_runtime = (UNIX_TIMESTAMP(NOW(2)) - v_start);
    UNTIL (v_runtime + in_interval >= in_max_runtime) END REPEAT;
    -- Get Performance Schema status
    IF (v_has_ps = 'YES') THEN
        SELECT 'SHOW ENGINE PERFORMANCE_SCHEMA STATUS' AS 'The following output is:';
        EXECUTE stmt_ps_status;
    END IF;
    -- Deallocate prepared statements
    IF (v_has_innodb IN ('DEFAULT', 'YES')) THEN
        DEALLOCATE PREPARE stmt_innodb_status;
    END IF;
    IF (v_has_ps = 'YES') THEN
        DEALLOCATE PREPARE stmt_ps_status;
    END IF;
    IF (v_has_ndb IN ('DEFAULT', 'YES')) THEN
        DEALLOCATE PREPARE stmt_ndbcluster_status;
    END IF;
    SELECT '

============================

     Schema Information

============================

' AS '';
    SELECT COUNT(*) AS 'Total Number of Tables' FROM information_schema.TABLES;
    -- The cost of information_schema.TABLES.DATA_LENGTH depends mostly on the number of tables
    IF (@sys.diagnostics.allow_i_s_tables = 'ON') THEN
        SELECT 'Storage Engine Usage' AS 'The following output is:';
        SELECT ENGINE, COUNT(*) AS NUM_TABLES,
                format_bytes(SUM(DATA_LENGTH)) AS DATA_LENGTH,
                format_bytes(SUM(INDEX_LENGTH)) AS INDEX_LENGTH,
                format_bytes(SUM(DATA_LENGTH+INDEX_LENGTH)) AS TOTAL
            FROM information_schema.TABLES
            GROUP BY ENGINE;
        SELECT 'Schema Object Overview' AS 'The following output is:';
        SELECT * FROM sys.schema_object_overview;
        SELECT 'Tables without a PRIMARY KEY' AS 'The following output is:';
        SELECT TABLES.TABLE_SCHEMA, ENGINE, COUNT(*) AS NumTables
          FROM information_schema.TABLES
               LEFT OUTER JOIN information_schema.STATISTICS ON STATISTICS.TABLE_SCHEMA = TABLES.TABLE_SCHEMA
                                                                AND STATISTICS.TABLE_NAME = TABLES.TABLE_NAME
                                                                AND STATISTICS.INDEX_NAME = 'PRIMARY'
         WHERE STATISTICS.TABLE_NAME IS NULL
               AND TABLES.TABLE_SCHEMA NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys')
               AND TABLES.TABLE_TYPE = 'BASE TABLE'
         GROUP BY TABLES.TABLE_SCHEMA, ENGINE;
    END IF;
    IF (v_has_ps = 'YES') THEN
        SELECT 'Unused Indexes' AS 'The following output is:';
        SELECT object_schema, COUNT(*) AS NumUnusedIndexes
          FROM performance_schema.table_io_waits_summary_by_index_usage
         WHERE index_name IS NOT NULL
               AND count_star = 0
               AND object_schema NOT IN ('mysql', 'sys')
               AND index_name != 'PRIMARY'
         GROUP BY object_schema;
    END IF;
    IF (v_has_ps = 'YES') THEN
        SELECT '

=========================

     Overall Status

=========================

' AS '';
        SELECT 'CALL sys.ps_statement_avg_latency_histogram()' AS 'The following output is:';
        CALL sys.ps_statement_avg_latency_histogram();
        CALL sys.statement_performance_analyzer('snapshot', NULL, NULL);
        CALL sys.statement_performance_analyzer('overall', NULL, 'with_runtimes_in_95th_percentile');
        SET @sys.diagnostics.sql = REPLACE(@sys.diagnostics.sql_gen_query_template, '%{OUTPUT}', 'end');
        IF (@sys.debug = 'ON') THEN
            SELECT 'The following query will be used to generate the query for each sys view' AS 'Debug';
            SELECT @sys.diagnostics.sql AS 'Debug';
        END IF;
        PREPARE stmt_gen_query FROM @sys.diagnostics.sql;
        SET v_done = FALSE;
        OPEN c_sysviews_w_delta;
        c_sysviews_w_delta_loop: LOOP
            FETCH c_sysviews_w_delta INTO v_table_name;
            IF v_done THEN
                LEAVE c_sysviews_w_delta_loop;
            END IF;
            IF (@sys.debug = 'ON') THEN
                SELECT CONCAT('The following queries are for storing the final content of ', v_table_name) AS 'Debug';
            END IF;
            CALL sys.execute_prepared_stmt(CONCAT('DROP TEMPORARY TABLE IF EXISTS `tmp_', v_table_name, '_end`'));
            CALL sys.execute_prepared_stmt(CONCAT('CREATE TEMPORARY TABLE `tmp_', v_table_name, '_end` SELECT * FROM `sys`.`x$', v_table_name, '`'));
            SET @sys.diagnostics.table_name = CONCAT('x$', v_table_name);
            EXECUTE stmt_gen_query USING @sys.diagnostics.table_name;
            -- If necessary add ORDER BY and LIMIT
            SELECT CONCAT(@sys.diagnostics.sql_select,
                            IF(order_by IS NOT NULL, CONCAT('\n ORDER BY ', REPLACE(order_by, '%{TABLE}', CONCAT('tmp_', v_table_name, '_end'))), ''),
                            IF(limit_rows IS NOT NULL, CONCAT('\n LIMIT ', limit_rows), '')
                    )
                INTO @sys.diagnostics.sql_select
                FROM tmp_sys_views_delta
                WHERE TABLE_NAME COLLATE utf8mb4_0900_as_ci = v_table_name;
            SELECT CONCAT('Overall ', v_table_name) AS 'The following output is:';
            CALL sys.execute_prepared_stmt(@sys.diagnostics.sql_select);
        END LOOP;
        CLOSE c_sysviews_w_delta;
        DEALLOCATE PREPARE stmt_gen_query;
        SELECT '

======================

     Delta Status

======================

' AS '';
        CALL sys.statement_performance_analyzer('delta', 'tmp_digests_start', 'with_runtimes_in_95th_percentile');
        CALL sys.statement_performance_analyzer('cleanup', NULL, NULL);
        DROP TEMPORARY TABLE tmp_digests_start;
        -- @sys.diagnostics.sql_gen_query_delta is defined near the to together with @sys.diagnostics.sql_gen_query_template
        IF (@sys.debug = 'ON') THEN
            SELECT 'The following query will be used to generate the query for each sys view delta' AS 'Debug';
            SELECT @sys.diagnostics.sql_gen_query_delta AS 'Debug';
        END IF;
        PREPARE stmt_gen_query_delta FROM @sys.diagnostics.sql_gen_query_delta;
        SET v_old_group_concat_max_len = @@session.group_concat_max_len;
        SET @@session.group_concat_max_len = 2048;
        SET v_done = FALSE;
        OPEN c_sysviews_w_delta;
        c_sysviews_w_delta_loop: LOOP
            FETCH c_sysviews_w_delta INTO v_table_name;
            IF v_done THEN
                LEAVE c_sysviews_w_delta_loop;
            END IF;
            SET @sys.diagnostics.table_name = v_table_name;
            EXECUTE stmt_gen_query_delta USING @sys.diagnostics.table_name;
            -- If necessary add WHERE, ORDER BY, and LIMIT
            SELECT CONCAT(@sys.diagnostics.sql_select,
                            IF(where_delta IS NOT NULL, CONCAT('\n WHERE ', where_delta), ''),
                            IF(order_by_delta IS NOT NULL, CONCAT('\n ORDER BY ', order_by_delta), ''),
                            IF(limit_rows IS NOT NULL, CONCAT('\n LIMIT ', limit_rows), '')
                    )
                INTO @sys.diagnostics.sql_select
                FROM tmp_sys_views_delta
                WHERE TABLE_NAME COLLATE utf8mb4_0900_as_ci = v_table_name;
            SELECT CONCAT('Delta ', v_table_name) AS 'The following output is:';
            CALL sys.execute_prepared_stmt(@sys.diagnostics.sql_select);
            CALL sys.execute_prepared_stmt(CONCAT('DROP TEMPORARY TABLE `tmp_', v_table_name, '_end`'));
            CALL sys.execute_prepared_stmt(CONCAT('DROP TEMPORARY TABLE `tmp_', v_table_name, '_start`'));
        END LOOP;
        CLOSE c_sysviews_w_delta;
        SET @@session.group_concat_max_len = v_old_group_concat_max_len;
        DEALLOCATE PREPARE stmt_gen_query_delta;
        DROP TEMPORARY TABLE tmp_sys_views_delta;
    END IF;
    SELECT 'SELECT * FROM sys.metrics' AS 'The following output is:';
    CALL sys.execute_prepared_stmt(
        CONCAT(v_sql_status_summary_select, v_sql_status_summary_delta, ', Type, s1.Enabled', v_sql_status_summary_from,
               '
 ORDER BY Type, Variable_name'
        )
    );
    -- Remove all the metrics temporary tables again
    SET v_count = 0;
    WHILE (v_count < v_output_count) DO
        SET v_count = v_count + 1;
        SET v_table_name = CONCAT('tmp_metrics_', v_count);
        CALL sys.execute_prepared_stmt(CONCAT('DROP TEMPORARY TABLE IF EXISTS ', v_table_name));
    END WHILE;
    IF (in_auto_config <> 'current') THEN
        CALL sys.ps_setup_reload_saved();
        IF ((@log_bin = 1) AND (@@binlog_format = 'STATEMENT')) THEN
            SET sql_log_bin = @log_bin;
        END IF;
    END IF;
    -- Reset the @sys.diagnostics.% user variables internal to this procedure
    SET @sys.diagnostics.output_time            = NULL,
        @sys.diagnostics.sql                    = NULL,
        @sys.diagnostics.sql_gen_query_delta    = NULL,
        @sys.diagnostics.sql_gen_query_template = NULL,
        @sys.diagnostics.sql_select             = NULL,
        @sys.diagnostics.table_name             = NULL;
    -- Restore INSTRUMENTED for this thread
    IF (v_this_thread_enabled = 'YES') THEN
        CALL sys.ps_setup_enable_thread(CONNECTION_ID());
    END IF;
    IF ((@log_bin = 1) AND (@@binlog_format = 'STATEMENT')) THEN
        SET sql_log_bin = @log_bin;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `execute_prepared_stmt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `execute_prepared_stmt`(
        IN in_query longtext CHARACTER SET UTF8MB4
    )
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTakes the query in the argument and executes it using a prepared statement. The prepared statement is deallocated,\nso the procedure is mainly useful for executing one off dynamically created queries.\n\nThe sys_execute_prepared_stmt prepared statement name is used for the query and is required not to exist.\n\n\nParameters\n-----------\n\nin_query (longtext CHARACTER SET UTF8MB4):\n  The query to execute.\n\n\nConfiguration Options\n----------------------\n\nsys.debug\n  Whether to provide debugging output.\n  Default is ''OFF''. Set to ''ON'' to include.\n\n\nExample\n--------\n\nmysql> CALL sys.execute_prepared_stmt(''SELECT * FROM sys.sys_config'');\n+------------------------+-------+---------------------+--------+\n| variable               | value | set_time            | set_by |\n+------------------------+-------+---------------------+--------+\n| statement_truncate_len | 64    | 2015-06-30 13:06:00 | NULL   |\n+------------------------+-------+---------------------+--------+\n1 row in set (0.00 sec)\n\nQuery OK, 0 rows affected (0.00 sec)\n'
BEGIN
    -- Set configuration options
    IF (@sys.debug IS NULL) THEN
        SET @sys.debug = sys.sys_get_config('debug', 'OFF');
    END IF;
    -- Verify the query exists
    -- The shortest possible query is "DO 1"
    IF (in_query IS NULL OR LENGTH(in_query) < 4) THEN
       SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = "The @sys.execute_prepared_stmt.sql must contain a query";
    END IF;
    SET @sys.execute_prepared_stmt.sql = in_query;
    IF (@sys.debug = 'ON') THEN
        SELECT @sys.execute_prepared_stmt.sql AS 'Debug';
    END IF;
    PREPARE sys_execute_prepared_stmt FROM @sys.execute_prepared_stmt.sql;
    EXECUTE sys_execute_prepared_stmt;
    DEALLOCATE PREPARE sys_execute_prepared_stmt;
    SET @sys.execute_prepared_stmt.sql = NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_disable_background_threads` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_disable_background_threads`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDisable all background thread instrumentation within Performance Schema.\n\nParameters\n-----------\n\nNone.\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_disable_background_threads();\n+--------------------------------+\n| summary                        |\n+--------------------------------+\n| Disabled 18 background threads |\n+--------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    UPDATE performance_schema.threads
       SET instrumented = 'NO'
     WHERE type = 'BACKGROUND';
    SELECT CONCAT('Disabled ', @rows := ROW_COUNT(), ' background thread', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_disable_consumer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_disable_consumer`(
        IN consumer VARCHAR(128)
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDisables consumers within Performance Schema \nmatching the input pattern.\n\nParameters\n-----------\n\nconsumer (VARCHAR(128)):\n  A LIKE pattern match (using "%consumer%") of consumers to disable\n\nExample\n-----------\n\nTo disable all consumers:\n\nmysql> CALL sys.ps_setup_disable_consumer('''');\n+--------------------------+\n| summary                  |\n+--------------------------+\n| Disabled 15 consumers    |\n+--------------------------+\n1 row in set (0.02 sec)\n\nTo disable just the event_stage consumers:\n\nmysql> CALL sys.ps_setup_disable_comsumers(''stage'');\n+------------------------+\n| summary                |\n+------------------------+\n| Disabled 3 consumers   |\n+------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    UPDATE performance_schema.setup_consumers
       SET enabled = 'NO'
     WHERE name LIKE CONCAT('%', consumer, '%');
    SELECT CONCAT('Disabled ', @rows := ROW_COUNT(), ' consumer', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_disable_instrument` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_disable_instrument`(
        IN in_pattern VARCHAR(128)
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDisables instruments within Performance Schema \nmatching the input pattern.\n\nParameters\n-----------\n\nin_pattern (VARCHAR(128)):\n  A LIKE pattern match (using "%in_pattern%") of events to disable\n\nExample\n-----------\n\nTo disable all mutex instruments:\n\nmysql> CALL sys.ps_setup_disable_instrument(''wait/synch/mutex'');\n+--------------------------+\n| summary                  |\n+--------------------------+\n| Disabled 155 instruments |\n+--------------------------+\n1 row in set (0.02 sec)\n\nTo disable just a specific TCP/IP based network IO instrument:\n\nmysql> CALL sys.ps_setup_disable_instrument(''wait/io/socket/sql/server_tcpip_socket'');\n+------------------------+\n| summary                |\n+------------------------+\n| Disabled 1 instruments |\n+------------------------+\n1 row in set (0.00 sec)\n\nTo disable all instruments:\n\nmysql> CALL sys.ps_setup_disable_instrument('''');\n+--------------------------+\n| summary                  |\n+--------------------------+\n| Disabled 547 instruments |\n+--------------------------+\n1 row in set (0.01 sec)\n'
BEGIN
    UPDATE performance_schema.setup_instruments
       SET enabled = 'NO', timed = 'NO'
     WHERE name LIKE CONCAT('%', in_pattern, '%');
    SELECT CONCAT('Disabled ', @rows := ROW_COUNT(), ' instrument', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_disable_thread` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_disable_thread`(
        IN in_connection_id BIGINT
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDisable the given connection/thread in Performance Schema.\n\nParameters\n-----------\n\nin_connection_id (BIGINT):\n  The connection ID (PROCESSLIST_ID from performance_schema.threads\n  or the ID shown within SHOW PROCESSLIST)\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_disable_thread(3);\n+-------------------+\n| summary           |\n+-------------------+\n| Disabled 1 thread |\n+-------------------+\n1 row in set (0.01 sec)\n\nTo disable the current connection:\n\nmysql> CALL sys.ps_setup_disable_thread(CONNECTION_ID());\n+-------------------+\n| summary           |\n+-------------------+\n| Disabled 1 thread |\n+-------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    UPDATE performance_schema.threads
       SET instrumented = 'NO'
     WHERE processlist_id = in_connection_id;
    SELECT CONCAT('Disabled ', @rows := ROW_COUNT(), ' thread', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_enable_background_threads` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_enable_background_threads`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nEnable all background thread instrumentation within Performance Schema.\n\nParameters\n-----------\n\nNone.\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_enable_background_threads();\n+-------------------------------+\n| summary                       |\n+-------------------------------+\n| Enabled 18 background threads |\n+-------------------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    UPDATE performance_schema.threads
       SET instrumented = 'YES'
     WHERE type = 'BACKGROUND';
    SELECT CONCAT('Enabled ', @rows := ROW_COUNT(), ' background thread', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_enable_consumer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_enable_consumer`(
        IN consumer VARCHAR(128)
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nEnables consumers within Performance Schema \nmatching the input pattern.\n\nParameters\n-----------\n\nconsumer (VARCHAR(128)):\n  A LIKE pattern match (using "%consumer%") of consumers to enable\n\nExample\n-----------\n\nTo enable all consumers:\n\nmysql> CALL sys.ps_setup_enable_consumer('''');\n+-------------------------+\n| summary                 |\n+-------------------------+\n| Enabled 10 consumers    |\n+-------------------------+\n1 row in set (0.02 sec)\n\nQuery OK, 0 rows affected (0.02 sec)\n\nTo enable just "waits" consumers:\n\nmysql> CALL sys.ps_setup_enable_consumer(''waits'');\n+-----------------------+\n| summary               |\n+-----------------------+\n| Enabled 3 consumers   |\n+-----------------------+\n1 row in set (0.00 sec)\n\nQuery OK, 0 rows affected (0.00 sec)\n'
BEGIN
    UPDATE performance_schema.setup_consumers
       SET enabled = 'YES'
     WHERE name LIKE CONCAT('%', consumer, '%');
    SELECT CONCAT('Enabled ', @rows := ROW_COUNT(), ' consumer', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_enable_instrument` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_enable_instrument`(
        IN in_pattern VARCHAR(128)
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nEnables instruments within Performance Schema \nmatching the input pattern.\n\nParameters\n-----------\n\nin_pattern (VARCHAR(128)):\n  A LIKE pattern match (using "%in_pattern%") of events to enable\n\nExample\n-----------\n\nTo enable all mutex instruments:\n\nmysql> CALL sys.ps_setup_enable_instrument(''wait/synch/mutex'');\n+-------------------------+\n| summary                 |\n+-------------------------+\n| Enabled 155 instruments |\n+-------------------------+\n1 row in set (0.02 sec)\n\nQuery OK, 0 rows affected (0.02 sec)\n\nTo enable just a specific TCP/IP based network IO instrument:\n\nmysql> CALL sys.ps_setup_enable_instrument(''wait/io/socket/sql/server_tcpip_socket'');\n+-----------------------+\n| summary               |\n+-----------------------+\n| Enabled 1 instruments |\n+-----------------------+\n1 row in set (0.00 sec)\n\nQuery OK, 0 rows affected (0.00 sec)\n\nTo enable all instruments:\n\nmysql> CALL sys.ps_setup_enable_instrument('''');\n+-------------------------+\n| summary                 |\n+-------------------------+\n| Enabled 547 instruments |\n+-------------------------+\n1 row in set (0.01 sec)\n\nQuery OK, 0 rows affected (0.01 sec)\n'
BEGIN
    UPDATE performance_schema.setup_instruments
       SET enabled = 'YES', timed = 'YES'
     WHERE name LIKE CONCAT('%', in_pattern, '%');
    SELECT CONCAT('Enabled ', @rows := ROW_COUNT(), ' instrument', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_enable_thread` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_enable_thread`(
        IN in_connection_id BIGINT
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nEnable the given connection/thread in Performance Schema.\n\nParameters\n-----------\n\nin_connection_id (BIGINT):\n  The connection ID (PROCESSLIST_ID from performance_schema.threads\n  or the ID shown within SHOW PROCESSLIST)\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_enable_thread(3);\n+------------------+\n| summary          |\n+------------------+\n| Enabled 1 thread |\n+------------------+\n1 row in set (0.01 sec)\n\nTo enable the current connection:\n\nmysql> CALL sys.ps_setup_enable_thread(CONNECTION_ID());\n+------------------+\n| summary          |\n+------------------+\n| Enabled 1 thread |\n+------------------+\n1 row in set (0.00 sec)\n'
BEGIN
    UPDATE performance_schema.threads
       SET instrumented = 'YES'
     WHERE processlist_id = in_connection_id;
    SELECT CONCAT('Enabled ', @rows := ROW_COUNT(), ' thread', IF(@rows != 1, 's', '')) AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_reload_saved` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_reload_saved`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nReloads a saved Performance Schema configuration,\nso that you can alter the setup for debugging purposes, \nbut restore it to a previous state.\n\nUse the companion procedure - ps_setup_save(), to \nsave a configuration.\n\nRequires the SUPER privilege for "SET sql_log_bin = 0;".\n\nParameters\n-----------\n\nNone.\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_save();\nQuery OK, 0 rows affected (0.08 sec)\n\nmysql> UPDATE performance_schema.setup_instruments SET enabled = ''YES'', timed = ''YES'';\nQuery OK, 547 rows affected (0.40 sec)\nRows matched: 784  Changed: 547  Warnings: 0\n\n/* Run some tests that need more detailed instrumentation here */\n\nmysql> CALL sys.ps_setup_reload_saved();\nQuery OK, 0 rows affected (0.32 sec)\n'
BEGIN
    DECLARE v_done bool DEFAULT FALSE;
    DECLARE v_lock_result INT;
    DECLARE v_lock_used_by BIGINT;
    DECLARE v_signal_message TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE VALUE '90001'
           SET MESSAGE_TEXT = 'An error occurred, was sys.ps_setup_save() run before this procedure?';
    END;
    SET @log_bin := @@sql_log_bin;
    SET sql_log_bin = 0;
    SELECT IS_USED_LOCK('sys.ps_setup_save') INTO v_lock_used_by;
    IF (v_lock_used_by != CONNECTION_ID()) THEN
        SET v_signal_message = CONCAT('The sys.ps_setup_save lock is currently owned by ', v_lock_used_by);
        SIGNAL SQLSTATE VALUE '90002'
           SET MESSAGE_TEXT = v_signal_message;
    END IF;
    DELETE FROM performance_schema.setup_actors;
    INSERT INTO performance_schema.setup_actors SELECT * FROM tmp_setup_actors;
    BEGIN
        -- Workaround for http://bugs.mysql.com/bug.php?id=70025
        DECLARE v_name varchar(64);
        DECLARE v_enabled enum('YES', 'NO');
        DECLARE c_consumers CURSOR FOR SELECT NAME, ENABLED FROM tmp_setup_consumers;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
        SET v_done = FALSE;
        OPEN c_consumers;
        c_consumers_loop: LOOP
            FETCH c_consumers INTO v_name, v_enabled;
            IF v_done THEN
               LEAVE c_consumers_loop;
            END IF;
            UPDATE performance_schema.setup_consumers
               SET ENABLED = v_enabled
             WHERE NAME = v_name;
         END LOOP;
         CLOSE c_consumers;
    END;
    UPDATE performance_schema.setup_instruments
     INNER JOIN tmp_setup_instruments USING (NAME)
       SET performance_schema.setup_instruments.ENABLED = tmp_setup_instruments.ENABLED,
           performance_schema.setup_instruments.TIMED   = tmp_setup_instruments.TIMED;
    BEGIN
        -- Workaround for http://bugs.mysql.com/bug.php?id=70025
        DECLARE v_thread_id bigint unsigned;
        DECLARE v_instrumented enum('YES', 'NO');
        DECLARE c_threads CURSOR FOR SELECT THREAD_ID, INSTRUMENTED FROM tmp_threads;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
        SET v_done = FALSE;
        OPEN c_threads;
        c_threads_loop: LOOP
            FETCH c_threads INTO v_thread_id, v_instrumented;
            IF v_done THEN
               LEAVE c_threads_loop;
            END IF;
            UPDATE performance_schema.threads
               SET INSTRUMENTED = v_instrumented
             WHERE THREAD_ID = v_thread_id;
        END LOOP;
        CLOSE c_threads;
    END;
    UPDATE performance_schema.threads
       SET INSTRUMENTED = IF(PROCESSLIST_USER IS NOT NULL,
                             sys.ps_is_account_enabled(PROCESSLIST_HOST, PROCESSLIST_USER),
                             'YES')
     WHERE THREAD_ID NOT IN (SELECT THREAD_ID FROM tmp_threads);
    DROP TEMPORARY TABLE tmp_setup_actors;
    DROP TEMPORARY TABLE tmp_setup_consumers;
    DROP TEMPORARY TABLE tmp_setup_instruments;
    DROP TEMPORARY TABLE tmp_threads;
    SELECT RELEASE_LOCK('sys.ps_setup_save') INTO v_lock_result;
    SET sql_log_bin = @log_bin; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_reset_to_default` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_reset_to_default`(
       IN in_verbose BOOLEAN
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nResets the Performance Schema setup to the default settings.\n\nParameters\n-----------\n\nin_verbose (BOOLEAN):\n  Whether to print each setup stage (including the SQL) whilst running.\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_reset_to_default(true)\\G\n*************************** 1. row ***************************\nstatus: Resetting: setup_actors\nDELETE\nFROM performance_schema.setup_actors\n WHERE NOT (HOST = ''%'' AND USER = ''%'' AND `ROLE` = ''%'')\n1 row in set (0.00 sec)\n\n*************************** 1. row ***************************\nstatus: Resetting: setup_actors\nINSERT IGNORE INTO performance_schema.setup_actors\nVALUES (''%'', ''%'', ''%'')\n1 row in set (0.00 sec)\n...\n\nmysql> CALL sys.ps_setup_reset_to_default(false)\\G\nQuery OK, 0 rows affected (0.00 sec)\n'
BEGIN
    SET @query = 'DELETE
                    FROM performance_schema.setup_actors
                   WHERE NOT (HOST = ''%'' AND USER = ''%'' AND `ROLE` = ''%'')';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: setup_actors\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
    SET @query = 'INSERT IGNORE INTO performance_schema.setup_actors
                  VALUES (''%'', ''%'', ''%'', ''YES'', ''YES'')';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: setup_actors\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
    SET @query = 'UPDATE performance_schema.setup_instruments
                     SET ENABLED = sys.ps_is_instrument_default_enabled(NAME),
                         TIMED   = sys.ps_is_instrument_default_timed(NAME)';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: setup_instruments\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
    SET @query = 'UPDATE performance_schema.setup_consumers
                     SET ENABLED = IF(NAME IN (''events_statements_current'', ''events_transactions_current'', ''global_instrumentation'', ''thread_instrumentation'', ''statements_digest''), ''YES'', ''NO'')';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: setup_consumers\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
    SET @query = 'DELETE
                    FROM performance_schema.setup_objects
                   WHERE NOT (OBJECT_TYPE IN (''EVENT'', ''FUNCTION'', ''PROCEDURE'', ''TABLE'', ''TRIGGER'') AND OBJECT_NAME = ''%'' 
                     AND (OBJECT_SCHEMA = ''mysql''              AND ENABLED = ''NO''  AND TIMED = ''NO'' )
                      OR (OBJECT_SCHEMA = ''performance_schema'' AND ENABLED = ''NO''  AND TIMED = ''NO'' )
                      OR (OBJECT_SCHEMA = ''information_schema'' AND ENABLED = ''NO''  AND TIMED = ''NO'' )
                      OR (OBJECT_SCHEMA = ''%''                  AND ENABLED = ''YES'' AND TIMED = ''YES''))';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: setup_objects\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
    SET @query = 'INSERT IGNORE INTO performance_schema.setup_objects
                  VALUES (''EVENT''    , ''mysql''             , ''%'', ''NO'' , ''NO'' ),
                         (''EVENT''    , ''performance_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''EVENT''    , ''information_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''EVENT''    , ''%''                 , ''%'', ''YES'', ''YES''),
                         (''FUNCTION'' , ''mysql''             , ''%'', ''NO'' , ''NO'' ),
                         (''FUNCTION'' , ''performance_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''FUNCTION'' , ''information_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''FUNCTION'' , ''%''                 , ''%'', ''YES'', ''YES''),
                         (''PROCEDURE'', ''mysql''             , ''%'', ''NO'' , ''NO'' ),
                         (''PROCEDURE'', ''performance_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''PROCEDURE'', ''information_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''PROCEDURE'', ''%''                 , ''%'', ''YES'', ''YES''),
                         (''TABLE''    , ''mysql''             , ''%'', ''NO'' , ''NO'' ),
                         (''TABLE''    , ''performance_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''TABLE''    , ''information_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''TABLE''    , ''%''                 , ''%'', ''YES'', ''YES''),
                         (''TRIGGER''  , ''mysql''             , ''%'', ''NO'' , ''NO'' ),
                         (''TRIGGER''  , ''performance_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''TRIGGER''  , ''information_schema'', ''%'', ''NO'' , ''NO'' ),
                         (''TRIGGER''  , ''%''                 , ''%'', ''YES'', ''YES'')';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: setup_objects\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
    SET @query = 'UPDATE performance_schema.threads
                     SET INSTRUMENTED = ''YES''';
    IF (in_verbose) THEN
        SELECT CONCAT('Resetting: threads\n', REPLACE(@query, '  ', '')) AS status;
    END IF;
    PREPARE reset_stmt FROM @query;
    EXECUTE reset_stmt;
    DEALLOCATE PREPARE reset_stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_save`(
        IN in_timeout INT
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nSaves the current configuration of Performance Schema, \nso that you can alter the setup for debugging purposes, \nbut restore it to a previous state.\n\nUse the companion procedure - ps_setup_reload_saved(), to \nrestore the saved config.\n\nThe named lock "sys.ps_setup_save" is taken before the\ncurrent configuration is saved. If the attempt to get the named\nlock times out, an error occurs.\n\nThe lock is released after the settings have been restored by\ncalling ps_setup_reload_saved().\n\nRequires the SUPER privilege for "SET sql_log_bin = 0;".\n\nParameters\n-----------\n\nin_timeout INT\n  The timeout in seconds used when trying to obtain the lock.\n  A negative timeout means infinite timeout.\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_save(-1);\nQuery OK, 0 rows affected (0.08 sec)\n\nmysql> UPDATE performance_schema.setup_instruments \n    ->    SET enabled = ''YES'', timed = ''YES'';\nQuery OK, 547 rows affected (0.40 sec)\nRows matched: 784  Changed: 547  Warnings: 0\n\n/* Run some tests that need more detailed instrumentation here */\n\nmysql> CALL sys.ps_setup_reload_saved();\nQuery OK, 0 rows affected (0.32 sec)\n'
BEGIN
    DECLARE v_lock_result INT;
    SET @log_bin := @@sql_log_bin;
    SET sql_log_bin = 0;
    SELECT GET_LOCK('sys.ps_setup_save', in_timeout) INTO v_lock_result;
    IF v_lock_result THEN
        DROP TEMPORARY TABLE IF EXISTS tmp_setup_actors;
        DROP TEMPORARY TABLE IF EXISTS tmp_setup_consumers;
        DROP TEMPORARY TABLE IF EXISTS tmp_setup_instruments;
        DROP TEMPORARY TABLE IF EXISTS tmp_threads;
        CREATE TEMPORARY TABLE tmp_setup_actors SELECT * FROM performance_schema.setup_actors LIMIT 0;
        CREATE TEMPORARY TABLE tmp_setup_consumers LIKE performance_schema.setup_consumers;
        CREATE TEMPORARY TABLE tmp_setup_instruments LIKE performance_schema.setup_instruments;
        CREATE TEMPORARY TABLE tmp_threads (THREAD_ID bigint unsigned NOT NULL PRIMARY KEY, INSTRUMENTED enum('YES','NO') NOT NULL);
        INSERT INTO tmp_setup_actors SELECT * FROM performance_schema.setup_actors;
        INSERT INTO tmp_setup_consumers SELECT * FROM performance_schema.setup_consumers;
        INSERT INTO tmp_setup_instruments SELECT * FROM performance_schema.setup_instruments;
        INSERT INTO tmp_threads SELECT THREAD_ID, INSTRUMENTED FROM performance_schema.threads;
    ELSE
        SIGNAL SQLSTATE VALUE '90000'
           SET MESSAGE_TEXT = 'Could not lock the sys.ps_setup_save user lock, another thread has a saved configuration';
    END IF;
    SET sql_log_bin = @log_bin;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_show_disabled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_show_disabled`(
        IN in_show_instruments BOOLEAN,
        IN in_show_threads BOOLEAN
    )
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nShows all currently disable Performance Schema configuration.\n\nDisabled users is only available for MySQL 5.7.6 and later.\nIn earlier versions it was only possible to enable users.\n\nParameters\n-----------\n\nin_show_instruments (BOOLEAN):\n  Whether to print disabled instruments (can print many items)\n\nin_show_threads (BOOLEAN):\n  Whether to print disabled threads\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_show_disabled(TRUE, TRUE);\n+----------------------------+\n| performance_schema_enabled |\n+----------------------------+\n|                          1 |\n+----------------------------+\n1 row in set (0.00 sec)\n\n+--------------------+\n| disabled_users     |\n+--------------------+\n| ''mark''@''localhost'' |\n+--------------------+\n1 row in set (0.00 sec)\n\n+-------------+----------------------+---------+-------+\n| object_type | objects              | enabled | timed |\n+-------------+----------------------+---------+-------+\n| EVENT       | mysql.%              | NO      | NO    |\n| EVENT       | performance_schema.% | NO      | NO    |\n| EVENT       | information_schema.% | NO      | NO    |\n| FUNCTION    | mysql.%              | NO      | NO    |\n| FUNCTION    | performance_schema.% | NO      | NO    |\n| FUNCTION    | information_schema.% | NO      | NO    |\n| PROCEDURE   | mysql.%              | NO      | NO    |\n| PROCEDURE   | performance_schema.% | NO      | NO    |\n| PROCEDURE   | information_schema.% | NO      | NO    |\n| TABLE       | mysql.%              | NO      | NO    |\n| TABLE       | performance_schema.% | NO      | NO    |\n| TABLE       | information_schema.% | NO      | NO    |\n| TRIGGER     | mysql.%              | NO      | NO    |\n| TRIGGER     | performance_schema.% | NO      | NO    |\n| TRIGGER     | information_schema.% | NO      | NO    |\n+-------------+----------------------+---------+-------+\n15 rows in set (0.00 sec)\n\n+----------------------------------+\n| disabled_consumers               |\n+----------------------------------+\n| events_stages_current            |\n| events_stages_history            |\n| events_stages_history_long       |\n| events_statements_history        |\n| events_statements_history_long   |\n| events_transactions_history      |\n| events_transactions_history_long |\n| events_waits_current             |\n| events_waits_history             |\n| events_waits_history_long        |\n+----------------------------------+\n10 rows in set (0.00 sec)\n\nEmpty set (0.00 sec)\n\n+---------------------------------------------------------------------------------------+-------+\n| disabled_instruments                                                                  | timed |\n+---------------------------------------------------------------------------------------+-------+\n| wait/synch/mutex/sql/TC_LOG_MMAP::LOCK_tc                                             | NO    |\n| wait/synch/mutex/sql/LOCK_des_key_file                                                | NO    |\n| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_commit                                       | NO    |\n...\n| memory/sql/servers_cache                                                              | NO    |\n| memory/sql/udf_mem                                                                    | NO    |\n| wait/lock/metadata/sql/mdl                                                            | NO    |\n+---------------------------------------------------------------------------------------+-------+\n547 rows in set (0.00 sec)\n\nQuery OK, 0 rows affected (0.01 sec)\n'
BEGIN
    SELECT @@performance_schema AS performance_schema_enabled;
    SELECT CONCAT('\'', user, '\'@\'', host, '\'') AS disabled_users
      FROM performance_schema.setup_actors
     WHERE enabled = 'NO'
     ORDER BY disabled_users;
    SELECT object_type,
           CONCAT(object_schema, '.', object_name) AS objects,
           enabled,
           timed
      FROM performance_schema.setup_objects
     WHERE enabled = 'NO'
     ORDER BY object_type, objects;
    SELECT name AS disabled_consumers
      FROM performance_schema.setup_consumers
     WHERE enabled = 'NO'
     ORDER BY disabled_consumers;
    IF (in_show_threads) THEN
        SELECT IF(name = 'thread/sql/one_connection', 
                  CONCAT(processlist_user, '@', processlist_host), 
                  REPLACE(name, 'thread/', '')) AS disabled_threads,
        TYPE AS thread_type
          FROM performance_schema.threads
         WHERE INSTRUMENTED = 'NO'
         ORDER BY disabled_threads;
    END IF;
    IF (in_show_instruments) THEN
        SELECT name AS disabled_instruments,
               timed
          FROM performance_schema.setup_instruments
         WHERE enabled = 'NO'
         ORDER BY disabled_instruments;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_show_disabled_consumers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_show_disabled_consumers`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nShows all currently disabled consumers.\n\nParameters\n-----------\n\nNone\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_show_disabled_consumers();\n\n+---------------------------+\n| disabled_consumers        |\n+---------------------------+\n| events_statements_current |\n| global_instrumentation    |\n| thread_instrumentation    |\n| statements_digest         |\n+---------------------------+\n4 rows in set (0.05 sec)\n'
BEGIN
    SELECT name AS disabled_consumers
      FROM performance_schema.setup_consumers
     WHERE enabled = 'NO'
     ORDER BY disabled_consumers;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_show_disabled_instruments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_show_disabled_instruments`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nShows all currently disabled instruments.\n\nParameters\n-----------\n\nNone\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_show_disabled_instruments();\n'
BEGIN
    SELECT name AS disabled_instruments, timed
      FROM performance_schema.setup_instruments
     WHERE enabled = 'NO'
     ORDER BY disabled_instruments;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_show_enabled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_show_enabled`(
        IN in_show_instruments BOOLEAN,
        IN in_show_threads BOOLEAN
    )
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nShows all currently enabled Performance Schema configuration.\n\nParameters\n-----------\n\nin_show_instruments (BOOLEAN):\n  Whether to print enabled instruments (can print many items)\n\nin_show_threads (BOOLEAN):\n  Whether to print enabled threads\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_show_enabled(TRUE, TRUE);\n+----------------------------+\n| performance_schema_enabled |\n+----------------------------+\n|                          1 |\n+----------------------------+\n1 row in set (0.00 sec)\n\n+---------------+\n| enabled_users |\n+---------------+\n| ''%''@''%''       |\n+---------------+\n1 row in set (0.01 sec)\n\n+-------------+---------+---------+-------+\n| object_type | objects | enabled | timed |\n+-------------+---------+---------+-------+\n| EVENT       | %.%     | YES     | YES   |\n| FUNCTION    | %.%     | YES     | YES   |\n| PROCEDURE   | %.%     | YES     | YES   |\n| TABLE       | %.%     | YES     | YES   |\n| TRIGGER     | %.%     | YES     | YES   |\n+-------------+---------+---------+-------+\n5 rows in set (0.01 sec)\n\n+---------------------------+\n| enabled_consumers         |\n+---------------------------+\n| events_statements_current |\n| global_instrumentation    |\n| thread_instrumentation    |\n| statements_digest         |\n+---------------------------+\n4 rows in set (0.05 sec)\n\n+---------------------------------+-------------+\n| enabled_threads                 | thread_type |\n+---------------------------------+-------------+\n| sql/main                        | BACKGROUND  |\n| sql/thread_timer_notifier       | BACKGROUND  |\n| innodb/io_ibuf_thread           | BACKGROUND  |\n| innodb/io_log_thread            | BACKGROUND  |\n| innodb/io_read_thread           | BACKGROUND  |\n| innodb/io_read_thread           | BACKGROUND  |\n| innodb/io_write_thread          | BACKGROUND  |\n| innodb/io_write_thread          | BACKGROUND  |\n| innodb/page_cleaner_thread      | BACKGROUND  |\n| innodb/srv_lock_timeout_thread  | BACKGROUND  |\n| innodb/srv_error_monitor_thread | BACKGROUND  |\n| innodb/srv_monitor_thread       | BACKGROUND  |\n| innodb/srv_master_thread        | BACKGROUND  |\n| innodb/srv_purge_thread         | BACKGROUND  |\n| innodb/srv_worker_thread        | BACKGROUND  |\n| innodb/srv_worker_thread        | BACKGROUND  |\n| innodb/srv_worker_thread        | BACKGROUND  |\n| innodb/buf_dump_thread          | BACKGROUND  |\n| innodb/dict_stats_thread        | BACKGROUND  |\n| sql/signal_handler              | BACKGROUND  |\n| sql/compress_gtid_table         | FOREGROUND  |\n| root@localhost                  | FOREGROUND  |\n+---------------------------------+-------------+\n22 rows in set (0.01 sec)\n\n+-------------------------------------+-------+\n| enabled_instruments                 | timed |\n+-------------------------------------+-------+\n| wait/io/file/sql/map                | YES   |\n| wait/io/file/sql/binlog             | YES   |\n...\n| statement/com/Error                 | YES   |\n| statement/com/                      | YES   |\n| idle                                | YES   |\n+-------------------------------------+-------+\n210 rows in set (0.08 sec)\n\nQuery OK, 0 rows affected (0.89 sec)\n'
BEGIN
    SELECT @@performance_schema AS performance_schema_enabled;
    SELECT CONCAT('\'', user, '\'@\'', host, '\'') AS enabled_users
      FROM performance_schema.setup_actors
     WHERE enabled = 'YES'
     ORDER BY enabled_users;
    SELECT object_type,
           CONCAT(object_schema, '.', object_name) AS objects,
           enabled,
           timed
      FROM performance_schema.setup_objects
     WHERE enabled = 'YES'
     ORDER BY object_type, objects;
    SELECT name AS enabled_consumers
      FROM performance_schema.setup_consumers
     WHERE enabled = 'YES'
     ORDER BY enabled_consumers;
    IF (in_show_threads) THEN
        SELECT IF(name = 'thread/sql/one_connection', 
                  CONCAT(processlist_user, '@', processlist_host), 
                  REPLACE(name, 'thread/', '')) AS enabled_threads,
        TYPE AS thread_type
          FROM performance_schema.threads
         WHERE INSTRUMENTED = 'YES'
         ORDER BY enabled_threads;
    END IF;
    IF (in_show_instruments) THEN
        SELECT name AS enabled_instruments,
               timed
          FROM performance_schema.setup_instruments
         WHERE enabled = 'YES'
         ORDER BY enabled_instruments;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_show_enabled_consumers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_show_enabled_consumers`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nShows all currently enabled consumers.\n\nParameters\n-----------\n\nNone\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_show_enabled_consumers();\n\n+---------------------------+\n| enabled_consumers         |\n+---------------------------+\n| events_statements_current |\n| global_instrumentation    |\n| thread_instrumentation    |\n| statements_digest         |\n+---------------------------+\n4 rows in set (0.05 sec)\n'
BEGIN
    SELECT name AS enabled_consumers
      FROM performance_schema.setup_consumers
     WHERE enabled = 'YES'
     ORDER BY enabled_consumers;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_setup_show_enabled_instruments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_setup_show_enabled_instruments`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nShows all currently enabled instruments.\n\nParameters\n-----------\n\nNone\n\nExample\n-----------\n\nmysql> CALL sys.ps_setup_show_enabled_instruments();\n'
BEGIN
    SELECT name AS enabled_instruments, timed
      FROM performance_schema.setup_instruments
     WHERE enabled = 'YES'
     ORDER BY enabled_instruments;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_statement_avg_latency_histogram` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_statement_avg_latency_histogram`()
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nOutputs a textual histogram graph of the average latency values\nacross all normalized queries tracked within the Performance Schema\nevents_statements_summary_by_digest table.\n\nCan be used to show a very high level picture of what kind of \nlatency distribution statements running within this instance have.\n\nParameters\n-----------\n\nNone.\n\nExample\n-----------\n\nmysql> CALL sys.ps_statement_avg_latency_histogram()\\G\n*************************** 1. row ***************************\nPerformance Schema Statement Digest Average Latency Histogram:\n\n  . = 1 unit\n  * = 2 units\n  # = 3 units\n\n(0 - 38ms)     240 | ################################################################################\n(38 - 77ms)    38  | ......................................\n(77 - 115ms)   3   | ...\n(115 - 154ms)  62  | *******************************\n(154 - 192ms)  3   | ...\n(192 - 231ms)  0   |\n(231 - 269ms)  0   |\n(269 - 307ms)  0   |\n(307 - 346ms)  0   |\n(346 - 384ms)  1   | .\n(384 - 423ms)  1   | .\n(423 - 461ms)  0   |\n(461 - 499ms)  0   |\n(499 - 538ms)  0   |\n(538 - 576ms)  0   |\n(576 - 615ms)  1   | .\n\n  Total Statements: 350; Buckets: 16; Bucket Size: 38 ms;\n'
BEGIN
SELECT CONCAT('\n',
       '\n  . = 1 unit',
       '\n  * = 2 units',
       '\n  # = 3 units\n',
       @label := CONCAT(@label_inner := CONCAT('\n(0 - ',
                                               ROUND((@bucket_size := (SELECT ROUND((MAX(avg_us) - MIN(avg_us)) / (@buckets := 16)) AS size
                                                                         FROM sys.x$ps_digest_avg_latency_distribution)) / (@unit_div := 1000)),
                                                (@unit := 'ms'), ')'),
                        REPEAT(' ', (@max_label_size := ((1 + LENGTH(ROUND((@bucket_size * 15) / @unit_div)) + 3 + LENGTH(ROUND(@bucket_size * 16) / @unit_div)) + 1)) - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us <= @bucket_size), 0)),
       REPEAT(' ', (@max_label_len := (@max_label_size + LENGTH((@total_queries := (SELECT SUM(cnt) FROM sys.x$ps_digest_avg_latency_distribution)))) + 1) - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < (@one_unit := 40), '.', IF(@count_in_bucket < (@two_unit := 80), '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND(@bucket_size / @unit_div), ' - ', ROUND((@bucket_size * 2) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size AND b1.avg_us <= @bucket_size * 2), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 2) / @unit_div), ' - ', ROUND((@bucket_size * 3) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 2 AND b1.avg_us <= @bucket_size * 3), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 3) / @unit_div), ' - ', ROUND((@bucket_size * 4) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 3 AND b1.avg_us <= @bucket_size * 4), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 4) / @unit_div), ' - ', ROUND((@bucket_size * 5) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 4 AND b1.avg_us <= @bucket_size * 5), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 5) / @unit_div), ' - ', ROUND((@bucket_size * 6) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 5 AND b1.avg_us <= @bucket_size * 6), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 6) / @unit_div), ' - ', ROUND((@bucket_size * 7) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 6 AND b1.avg_us <= @bucket_size * 7), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 7) / @unit_div), ' - ', ROUND((@bucket_size * 8) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 7 AND b1.avg_us <= @bucket_size * 8), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 8) / @unit_div), ' - ', ROUND((@bucket_size * 9) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 8 AND b1.avg_us <= @bucket_size * 9), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 9) / @unit_div), ' - ', ROUND((@bucket_size * 10) / @unit_div), @unit, ')'),
                         REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                         @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                       FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                      WHERE b1.avg_us > @bucket_size * 9 AND b1.avg_us <= @bucket_size * 10), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 10) / @unit_div), ' - ', ROUND((@bucket_size * 11) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 10 AND b1.avg_us <= @bucket_size * 11), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 11) / @unit_div), ' - ', ROUND((@bucket_size * 12) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 11 AND b1.avg_us <= @bucket_size * 12), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 12) / @unit_div), ' - ', ROUND((@bucket_size * 13) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 12 AND b1.avg_us <= @bucket_size * 13), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 13) / @unit_div), ' - ', ROUND((@bucket_size * 14) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 13 AND b1.avg_us <= @bucket_size * 14), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 14) / @unit_div), ' - ', ROUND((@bucket_size * 15) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 14 AND b1.avg_us <= @bucket_size * 15), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       @label := CONCAT(@label_inner := CONCAT('\n(', ROUND((@bucket_size * 15) / @unit_div), ' - ', ROUND((@bucket_size * 16) / @unit_div), @unit, ')'),
                        REPEAT(' ', @max_label_size - LENGTH(@label_inner)),
                        @count_in_bucket := IFNULL((SELECT SUM(cnt)
                                                      FROM sys.x$ps_digest_avg_latency_distribution AS b1 
                                                     WHERE b1.avg_us > @bucket_size * 15 AND b1.avg_us <= @bucket_size * 16), 0)),
       REPEAT(' ', @max_label_len - LENGTH(@label)), '| ',
       IFNULL(REPEAT(IF(@count_in_bucket < @one_unit, '.', IF(@count_in_bucket < @two_unit, '*', '#')), 
       	             IF(@count_in_bucket < @one_unit, @count_in_bucket,
       	             	IF(@count_in_bucket < @two_unit, @count_in_bucket / 2, @count_in_bucket / 3))), ''),
       '\n\n  Total Statements: ', @total_queries, '; Buckets: ', @buckets , '; Bucket Size: ', ROUND(@bucket_size / @unit_div) , ' ', @unit, ';\n'
      ) AS `Performance Schema Statement Digest Average Latency Histogram`;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_trace_statement_digest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_trace_statement_digest`(
        IN in_digest VARCHAR(64),
        IN in_runtime INT,
        IN in_interval DECIMAL(2,2),
        IN in_start_fresh BOOLEAN,
        IN in_auto_enable BOOLEAN
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTraces all instrumentation within Performance Schema for a specific\nStatement Digest.\n\nWhen finding a statement of interest within the\nperformance_schema.events_statements_summary_by_digest table, feed\nthe DIGEST value in to this procedure, set how long to poll for,\nand at what interval to poll, and it will generate a report of all\nstatistics tracked within Performance Schema for that digest for the\ninterval.\n\nIt will also attempt to generate an EXPLAIN for the longest running\nexample of the digest during the interval. Note this may fail, as:\n\n   * Performance Schema truncates long SQL_TEXT values (and hence the\n     EXPLAIN will fail due to parse errors)\n   * the default schema is sys (so tables that are not fully qualified\n     in the query may not be found)\n   * some queries such as SHOW are not supported in EXPLAIN.\n\nWhen the EXPLAIN fails, the error will be ignored and no EXPLAIN\noutput generated.\n\nRequires the SUPER privilege for "SET sql_log_bin = 0;".\n\nParameters\n-----------\n\nin_digest (VARCHAR(64)):\n  The statement digest identifier you would like to analyze\nin_runtime (INT):\n  The number of seconds to run analysis for\nin_interval (DECIMAL(2,2)):\n  The interval (in seconds, may be fractional) at which to try\n  and take snapshots\nin_start_fresh (BOOLEAN):\n  Whether to TRUNCATE the events_statements_history_long and\n  events_stages_history_long tables before starting\nin_auto_enable (BOOLEAN):\n  Whether to automatically turn on required consumers\n\nExample\n-----------\n\nmysql> call ps_trace_statement_digest(''891ec6860f98ba46d89dd20b0c03652c'', 10, 0.1, true, true);\n+--------------------+\n| SUMMARY STATISTICS |\n+--------------------+\n| SUMMARY STATISTICS |\n+--------------------+\n1 row in set (9.11 sec)\n\n+------------+-----------+-----------+-----------+---------------+------------+------------+\n| executions | exec_time | lock_time | rows_sent | rows_examined | tmp_tables | full_scans |\n+------------+-----------+-----------+-----------+---------------+------------+------------+\n|         21 | 4.11 ms   | 2.00 ms   |         0 |            21 |          0 |          0 |\n+------------+-----------+-----------+-----------+---------------+------------+------------+\n1 row in set (9.11 sec)\n\n+------------------------------------------+-------+-----------+\n| event_name                               | count | latency   |\n+------------------------------------------+-------+-----------+\n| stage/sql/checking query cache for query |    16 | 724.37 us |\n| stage/sql/statistics                     |    16 | 546.92 us |\n| stage/sql/freeing items                  |    18 | 520.11 us |\n| stage/sql/init                           |    51 | 466.80 us |\n...\n| stage/sql/cleaning up                    |    18 | 11.92 us  |\n| stage/sql/executing                      |    16 | 6.95 us   |\n+------------------------------------------+-------+-----------+\n17 rows in set (9.12 sec)\n\n+---------------------------+\n| LONGEST RUNNING STATEMENT |\n+---------------------------+\n| LONGEST RUNNING STATEMENT |\n+---------------------------+\n1 row in set (9.16 sec)\n\n+-----------+-----------+-----------+-----------+---------------+------------+-----------+\n| thread_id | exec_time | lock_time | rows_sent | rows_examined | tmp_tables | full_scan |\n+-----------+-----------+-----------+-----------+---------------+------------+-----------+\n|    166646 | 618.43 us | 1.00 ms   |         0 |             1 |          0 |         0 |\n+-----------+-----------+-----------+-----------+---------------+------------+-----------+\n1 row in set (9.16 sec)\n\n// Truncated for clarity...\n+-----------------------------------------------------------------+\n| sql_text                                                        |\n+-----------------------------------------------------------------+\n| select hibeventhe0_.id as id1382_, hibeventhe0_.createdTime ... |\n+-----------------------------------------------------------------+\n1 row in set (9.17 sec)\n\n+------------------------------------------+-----------+\n| event_name                               | latency   |\n+------------------------------------------+-----------+\n| stage/sql/init                           | 8.61 us   |\n| stage/sql/Waiting for query cache lock   | 453.23 us |\n| stage/sql/init                           | 331.07 ns |\n| stage/sql/checking query cache for query | 43.04 us  |\n...\n| stage/sql/freeing items                  | 30.46 us  |\n| stage/sql/cleaning up                    | 662.13 ns |\n+------------------------------------------+-----------+\n18 rows in set (9.23 sec)\n\n+----+-------------+--------------+-------+---------------+-----------+---------+-------------+------+-------+\n| id | select_type | table        | type  | possible_keys | key       | key_len | ref         | rows | Extra |\n+----+-------------+--------------+-------+---------------+-----------+---------+-------------+------+-------+\n|  1 | SIMPLE      | hibeventhe0_ | const | fixedTime     | fixedTime | 775     | const,const |    1 | NULL  |\n+----+-------------+--------------+-------+---------------+-----------+---------+-------------+------+-------+\n1 row in set (9.27 sec)\n\nQuery OK, 0 rows affected (9.28 sec)\n'
BEGIN
    DECLARE v_start_fresh BOOLEAN DEFAULT false;
    DECLARE v_auto_enable BOOLEAN DEFAULT false;
    DECLARE v_explain     BOOLEAN DEFAULT true;
    DECLARE v_this_thread_enabed ENUM('YES', 'NO');
    DECLARE v_runtime INT DEFAULT 0;
    DECLARE v_start INT DEFAULT 0;
    DECLARE v_found_stmts INT;
    SET @log_bin := @@sql_log_bin;
    SET sql_log_bin = 0;
    -- Do not track the current thread, it will kill the stack
    SELECT INSTRUMENTED INTO v_this_thread_enabed FROM performance_schema.threads WHERE PROCESSLIST_ID = CONNECTION_ID();
    CALL sys.ps_setup_disable_thread(CONNECTION_ID());
    DROP TEMPORARY TABLE IF EXISTS stmt_trace;
    CREATE TEMPORARY TABLE stmt_trace (
        thread_id BIGINT UNSIGNED,
        timer_start BIGINT UNSIGNED,
        event_id BIGINT UNSIGNED,
        sql_text longtext,
        timer_wait BIGINT UNSIGNED,
        lock_time BIGINT UNSIGNED,
        errors BIGINT UNSIGNED,
        mysql_errno INT,
        rows_sent BIGINT UNSIGNED,
        rows_affected BIGINT UNSIGNED,
        rows_examined BIGINT UNSIGNED,
        created_tmp_tables BIGINT UNSIGNED,
        created_tmp_disk_tables BIGINT UNSIGNED,
        no_index_used BIGINT UNSIGNED,
        PRIMARY KEY (thread_id, timer_start)
    );
    DROP TEMPORARY TABLE IF EXISTS stmt_stages;
    CREATE TEMPORARY TABLE stmt_stages (
       event_id BIGINT UNSIGNED,
       stmt_id BIGINT UNSIGNED,
       event_name VARCHAR(128),
       timer_wait BIGINT UNSIGNED,
       PRIMARY KEY (event_id)
    );
    SET v_start_fresh = in_start_fresh;
    IF v_start_fresh THEN
        TRUNCATE TABLE performance_schema.events_statements_history_long;
        TRUNCATE TABLE performance_schema.events_stages_history_long;
    END IF;
    SET v_auto_enable = in_auto_enable;
    IF v_auto_enable THEN
        CALL sys.ps_setup_save(0);
        UPDATE performance_schema.threads
           SET INSTRUMENTED = IF(PROCESSLIST_ID IS NOT NULL, 'YES', 'NO');
        -- Only the events_statements_history_long and events_stages_history_long tables and their ancestors are needed
        UPDATE performance_schema.setup_consumers
           SET ENABLED = 'YES'
         WHERE NAME NOT LIKE '%\_history'
               AND NAME NOT LIKE 'events_wait%'
               AND NAME NOT LIKE 'events_transactions%'
               AND NAME <> 'statements_digest';
        UPDATE performance_schema.setup_instruments
           SET ENABLED = 'YES',
               TIMED   = 'YES'
         WHERE NAME LIKE 'statement/%' OR NAME LIKE 'stage/%';
    END IF;
    WHILE v_runtime < in_runtime DO
        SELECT UNIX_TIMESTAMP() INTO v_start;
        INSERT IGNORE INTO stmt_trace
        SELECT thread_id, timer_start, event_id, sql_text, timer_wait, lock_time, errors, mysql_errno, 
               rows_sent, rows_affected, rows_examined, created_tmp_tables, created_tmp_disk_tables, no_index_used
          FROM performance_schema.events_statements_history_long
        WHERE digest = in_digest;
        INSERT IGNORE INTO stmt_stages
        SELECT stages.event_id, stmt_trace.event_id,
               stages.event_name, stages.timer_wait
          FROM performance_schema.events_stages_history_long AS stages
          JOIN stmt_trace ON stages.nesting_event_id = stmt_trace.event_id;
        SELECT SLEEP(in_interval) INTO @sleep;
        SET v_runtime = v_runtime + (UNIX_TIMESTAMP() - v_start);
    END WHILE;
    SELECT "SUMMARY STATISTICS";
    SELECT COUNT(*) executions,
           format_pico_time(SUM(timer_wait)) AS exec_time,
           format_pico_time(SUM(lock_time)) AS lock_time,
           SUM(rows_sent) AS rows_sent,
           SUM(rows_affected) AS rows_affected,
           SUM(rows_examined) AS rows_examined,
           SUM(created_tmp_tables) AS tmp_tables,
           SUM(no_index_used) AS full_scans
      FROM stmt_trace;
    SELECT event_name,
           COUNT(*) as count,
           format_pico_time(SUM(timer_wait)) as latency
      FROM stmt_stages
     GROUP BY event_name
     ORDER BY SUM(timer_wait) DESC;
    SELECT "LONGEST RUNNING STATEMENT";
    SELECT thread_id,
           format_pico_time(timer_wait) AS exec_time,
           format_pico_time(lock_time) AS lock_time,
           rows_sent,
           rows_affected,
           rows_examined,
           created_tmp_tables AS tmp_tables,
           no_index_used AS full_scan
      FROM stmt_trace
     ORDER BY timer_wait DESC LIMIT 1;
    SELECT sql_text
      FROM stmt_trace
     ORDER BY timer_wait DESC LIMIT 1;
    SELECT sql_text, event_id INTO @sql, @sql_id
      FROM stmt_trace
    ORDER BY timer_wait DESC LIMIT 1;
    IF (@sql_id IS NOT NULL) THEN
        SELECT event_name,
               format_pico_time(timer_wait) as latency
          FROM stmt_stages
         WHERE stmt_id = @sql_id
         ORDER BY event_id;
    END IF;
    DROP TEMPORARY TABLE stmt_trace;
    DROP TEMPORARY TABLE stmt_stages;
    IF (@sql IS NOT NULL) THEN
        SET @stmt := CONCAT("EXPLAIN FORMAT=JSON ", @sql);
        BEGIN
            -- Not all queries support EXPLAIN, so catch the cases that are
            -- not supported. Currently that includes cases where the table
            -- is not fully qualified and is not in the default schema for this
            -- procedure as it's not possible to change the default schema inside
            -- a procedure.
            --
            -- Errno = 1064: You have an error in your SQL syntax
            -- Errno = 1146: Table '...' doesn't exist
            DECLARE CONTINUE HANDLER FOR 1064, 1146 SET v_explain = false;
            PREPARE explain_stmt FROM @stmt;
        END;
        IF (v_explain) THEN
            EXECUTE explain_stmt;
            DEALLOCATE PREPARE explain_stmt;
        END IF;
    END IF;
    IF v_auto_enable THEN
        CALL sys.ps_setup_reload_saved();
    END IF;
    -- Restore INSTRUMENTED for this thread
    IF (v_this_thread_enabed = 'YES') THEN
        CALL sys.ps_setup_enable_thread(CONNECTION_ID());
    END IF;
    SET sql_log_bin = @log_bin;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_trace_thread` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_trace_thread`(
        IN in_thread_id BIGINT UNSIGNED,
        IN in_outfile VARCHAR(255),
        IN in_max_runtime DECIMAL(20,2),
        IN in_interval DECIMAL(20,2),
        IN in_start_fresh BOOLEAN,
        IN in_auto_setup BOOLEAN,
        IN in_debug BOOLEAN
    )
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nDumps all data within Performance Schema for an instrumented thread,\nto create a DOT formatted graph file. \n\nEach resultset returned from the procedure should be used for a complete graph\n\nRequires the SUPER privilege for "SET sql_log_bin = 0;".\n\nParameters\n-----------\n\nin_thread_id (BIGINT UNSIGNED):\n  The thread that you would like a stack trace for\nin_outfile  (VARCHAR(255)):\n  The filename the dot file will be written to\nin_max_runtime (DECIMAL(20,2)):\n  The maximum time to keep collecting data.\n  Use NULL to get the default which is 60 seconds.\nin_interval (DECIMAL(20,2)): \n  How long to sleep between data collections. \n  Use NULL to get the default which is 1 second.\nin_start_fresh (BOOLEAN):\n  Whether to reset all Performance Schema data before tracing.\nin_auto_setup (BOOLEAN):\n  Whether to disable all other threads and enable all consumers/instruments. \n  This will also reset the settings at the end of the run.\nin_debug (BOOLEAN):\n  Whether you would like to include file:lineno in the graph\n\nExample\n-----------\n\nmysql> CALL sys.ps_trace_thread(25, CONCAT(''/tmp/stack-'', REPLACE(NOW(), '' '', ''-''), ''.dot''), NULL, NULL, TRUE, TRUE, TRUE);\n+-------------------+\n| summary           |\n+-------------------+\n| Disabled 1 thread |\n+-------------------+\n1 row in set (0.00 sec)\n\n+---------------------------------------------+\n| Info                                        |\n+---------------------------------------------+\n| Data collection starting for THREAD_ID = 25 |\n+---------------------------------------------+\n1 row in set (0.03 sec)\n\n+-----------------------------------------------------------+\n| Info                                                      |\n+-----------------------------------------------------------+\n| Stack trace written to /tmp/stack-2014-02-16-21:18:41.dot |\n+-----------------------------------------------------------+\n1 row in set (60.07 sec)\n\n+-------------------------------------------------------------------+\n| Convert to PDF                                                    |\n+-------------------------------------------------------------------+\n| dot -Tpdf -o /tmp/stack_25.pdf /tmp/stack-2014-02-16-21:18:41.dot |\n+-------------------------------------------------------------------+\n1 row in set (60.07 sec)\n\n+-------------------------------------------------------------------+\n| Convert to PNG                                                    |\n+-------------------------------------------------------------------+\n| dot -Tpng -o /tmp/stack_25.png /tmp/stack-2014-02-16-21:18:41.dot |\n+-------------------------------------------------------------------+\n1 row in set (60.07 sec)\n\n+------------------+\n| summary          |\n+------------------+\n| Enabled 1 thread |\n+------------------+\n1 row in set (60.32 sec)\n'
BEGIN
    DECLARE v_done bool DEFAULT FALSE;
    DECLARE v_start, v_runtime DECIMAL(20,2) DEFAULT 0.0;
    DECLARE v_min_event_id bigint unsigned DEFAULT 0;
    DECLARE v_this_thread_enabed ENUM('YES', 'NO');
    DECLARE v_event longtext;
    DECLARE c_stack CURSOR FOR
        SELECT CONCAT(IF(nesting_event_id IS NOT NULL, CONCAT(nesting_event_id, ' -> '), ''), 
                    event_id, '; ', event_id, ' [label="',
                    -- Convert from picoseconds to microseconds
                    '(', format_pico_time(timer_wait), ') ',
                    IF (event_name NOT LIKE 'wait/io%', 
                        SUBSTRING_INDEX(event_name, '/', -2), 
                        IF (event_name NOT LIKE 'wait/io/file%' OR event_name NOT LIKE 'wait/io/socket%',
                            SUBSTRING_INDEX(event_name, '/', -4),
                            event_name)
                        ),
                    -- Always dump the extra wait information gathered for transactions and statements
                    IF (event_name LIKE 'transaction', IFNULL(CONCAT('\\n', wait_info), ''), ''),
                    IF (event_name LIKE 'statement/%', IFNULL(CONCAT('\\n', wait_info), ''), ''),
                    -- If debug is enabled, add the file:lineno information for waits
                    IF (in_debug AND event_name LIKE 'wait%', wait_info, ''),
                    '", ', 
                    -- Depending on the type of event, style appropriately
                    CASE WHEN event_name LIKE 'wait/io/file%' THEN 
                           'shape=box, style=filled, color=red'
                         WHEN event_name LIKE 'wait/io/table%' THEN 
                           'shape=box, style=filled, color=green'
                         WHEN event_name LIKE 'wait/io/socket%' THEN
                           'shape=box, style=filled, color=yellow'
                         WHEN event_name LIKE 'wait/synch/mutex%' THEN
                           'style=filled, color=lightskyblue'
                         WHEN event_name LIKE 'wait/synch/cond%' THEN
                           'style=filled, color=darkseagreen3'
                         WHEN event_name LIKE 'wait/synch/rwlock%' THEN
                           'style=filled, color=orchid'
                         WHEN event_name LIKE 'wait/synch/sxlock%' THEN
                           'style=filled, color=palevioletred' 
                         WHEN event_name LIKE 'wait/lock%' THEN
                           'shape=box, style=filled, color=tan'
                         WHEN event_name LIKE 'statement/%' THEN
                           CONCAT('shape=box, style=bold',
                                  -- Style statements depending on COM vs SQL
                                  CASE WHEN event_name LIKE 'statement/com/%' THEN
                                         ' style=filled, color=darkseagreen'
                                       ELSE
                                         -- Use long query time from the server to
                                         -- flag long running statements in red
                                         IF((timer_wait/1000000000000) > @@long_query_time, 
                                            ' style=filled, color=red', 
                                            ' style=filled, color=lightblue')
                                  END
                           )
                         WHEN event_name LIKE 'transaction' THEN
                           'shape=box, style=filled, color=lightblue3'
                         WHEN event_name LIKE 'stage/%' THEN
                           'style=filled, color=slategray3'
                         -- IDLE events are on their own, call attention to them
                         WHEN event_name LIKE '%idle%' THEN
                           'shape=box, style=filled, color=firebrick3'
                         ELSE '' END,
                     '];\n'
                   ) event, event_id
        FROM (
             -- Select all transactions
             (SELECT thread_id, event_id, event_name, timer_wait, timer_start, nesting_event_id,
                     CONCAT('trx_id: ',  IFNULL(trx_id, ''), '\\n',
                            'gtid: ', IFNULL(gtid, ''), '\\n',
                            'state: ', state, '\\n',
                            'mode: ', access_mode, '\\n',
                            'isolation: ', isolation_level, '\\n',
                            'autocommit: ', autocommit, '\\n',
                            'savepoints: ', number_of_savepoints, '\\n'
                     ) AS wait_info
                FROM performance_schema.events_transactions_history_long
               WHERE thread_id = in_thread_id AND event_id > v_min_event_id)
             UNION
             -- Select all statements, with the extra tracing information available
             (SELECT thread_id, event_id, event_name, timer_wait, timer_start, nesting_event_id, 
                     CONCAT('statement: ', sql_text, '\\n',
                            'errors: ', errors, '\\n',
                            'warnings: ', warnings, '\\n',
                            'lock time: ', format_pico_time(lock_time),'\\n',
                            'rows affected: ', rows_affected, '\\n',
                            'rows sent: ', rows_sent, '\\n',
                            'rows examined: ', rows_examined, '\\n',
                            'tmp tables: ', created_tmp_tables, '\\n',
                            'tmp disk tables: ', created_tmp_disk_tables, '\\n'
                            'select scan: ', select_scan, '\\n',
                            'select full join: ', select_full_join, '\\n',
                            'select full range join: ', select_full_range_join, '\\n',
                            'select range: ', select_range, '\\n',
                            'select range check: ', select_range_check, '\\n', 
                            'sort merge passes: ', sort_merge_passes, '\\n',
                            'sort rows: ', sort_rows, '\\n',
                            'sort range: ', sort_range, '\\n',
                            'sort scan: ', sort_scan, '\\n',
                            'no index used: ', IF(no_index_used, 'TRUE', 'FALSE'), '\\n',
                            'no good index used: ', IF(no_good_index_used, 'TRUE', 'FALSE'), '\\n'
                     ) AS wait_info
                FROM performance_schema.events_statements_history_long
               WHERE thread_id = in_thread_id AND event_id > v_min_event_id)
             UNION
             -- Select all stages
             (SELECT thread_id, event_id, event_name, timer_wait, timer_start, nesting_event_id, null AS wait_info
                FROM performance_schema.events_stages_history_long 
               WHERE thread_id = in_thread_id AND event_id > v_min_event_id)
             UNION 
             -- Select all events, adding information appropriate to the event
             (SELECT thread_id, event_id, 
                     CONCAT(event_name, 
                            IF(event_name NOT LIKE 'wait/synch/mutex%', IFNULL(CONCAT(' - ', operation), ''), ''), 
                            IF(number_of_bytes IS NOT NULL, CONCAT(' ', number_of_bytes, ' bytes'), ''),
                            IF(event_name LIKE 'wait/io/file%', '\\n', ''),
                            IF(object_schema IS NOT NULL, CONCAT('\\nObject: ', object_schema, '.'), ''), 
                            IF(object_name IS NOT NULL, 
                               IF (event_name LIKE 'wait/io/socket%',
                                   -- Print the socket if used, else the IP:port as reported
                                   CONCAT('\\n', IF (object_name LIKE ':0%', @@socket, object_name)),
                                   object_name),
                               ''
                            ),
                            IF(index_name IS NOT NULL, CONCAT(' Index: ', index_name), ''), '\\n'
                     ) AS event_name,
                     timer_wait, timer_start, nesting_event_id, source AS wait_info
                FROM performance_schema.events_waits_history_long
               WHERE thread_id = in_thread_id AND event_id > v_min_event_id)
           ) events 
       ORDER BY event_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    SET @log_bin := @@sql_log_bin;
    SET sql_log_bin = 0;
    -- Do not track the current thread, it will kill the stack
    SELECT INSTRUMENTED INTO v_this_thread_enabed FROM performance_schema.threads WHERE PROCESSLIST_ID = CONNECTION_ID();
    CALL sys.ps_setup_disable_thread(CONNECTION_ID());
    IF (in_auto_setup) THEN
        CALL sys.ps_setup_save(0);
        -- Ensure only the thread to create the stack trace for is instrumented and that we instrument everything.
        DELETE FROM performance_schema.setup_actors;
        UPDATE performance_schema.threads
           SET INSTRUMENTED = IF(THREAD_ID = in_thread_id, 'YES', 'NO');
        -- only the %_history_long tables and it ancestors are needed
        UPDATE performance_schema.setup_consumers
           SET ENABLED = 'YES'
         WHERE NAME NOT LIKE '%\_history';
        UPDATE performance_schema.setup_instruments
           SET ENABLED = 'YES',
               TIMED   = 'YES';
    END IF;
    IF (in_start_fresh) THEN
        TRUNCATE performance_schema.events_transactions_history_long;
        TRUNCATE performance_schema.events_statements_history_long;
        TRUNCATE performance_schema.events_stages_history_long;
        TRUNCATE performance_schema.events_waits_history_long;
    END IF;
    DROP TEMPORARY TABLE IF EXISTS tmp_events;
    CREATE TEMPORARY TABLE tmp_events (
      event_id bigint unsigned NOT NULL,
      event longblob,
      PRIMARY KEY (event_id)
    );
    -- Print headers for a .dot file
    INSERT INTO tmp_events VALUES (0, CONCAT('digraph events { rankdir=LR; nodesep=0.10;\n',
                                             '// Stack created .....: ', NOW(), '\n',
                                             '// MySQL version .....: ', VERSION(), '\n',
                                             '// MySQL hostname ....: ', @@hostname, '\n',
                                             '// MySQL port ........: ', @@port, '\n',
                                             '// MySQL socket ......: ', @@socket, '\n',
                                             '// MySQL user ........: ', CURRENT_USER(), '\n'));
    SELECT CONCAT('Data collection starting for THREAD_ID = ', in_thread_id) AS 'Info';
    SET v_min_event_id = 0,
        v_start        = UNIX_TIMESTAMP(),
        in_interval    = IFNULL(in_interval, 1.00),
        in_max_runtime = IFNULL(in_max_runtime, 60.00);
    WHILE (v_runtime < in_max_runtime
           AND (SELECT INSTRUMENTED FROM performance_schema.threads WHERE THREAD_ID = in_thread_id) = 'YES') DO
        SET v_done = FALSE;
        OPEN c_stack;
        c_stack_loop: LOOP
            FETCH c_stack INTO v_event, v_min_event_id;
            IF v_done THEN
                LEAVE c_stack_loop;
            END IF;
            IF (LENGTH(v_event) > 0) THEN
                INSERT INTO tmp_events VALUES (v_min_event_id, v_event);
            END IF;
        END LOOP;
        CLOSE c_stack;
        SELECT SLEEP(in_interval) INTO @sleep;
        SET v_runtime = (UNIX_TIMESTAMP() - v_start);
    END WHILE;
    INSERT INTO tmp_events VALUES (v_min_event_id+1, '}');
    SET @query = CONCAT('SELECT event FROM tmp_events ORDER BY event_id INTO OUTFILE ''', in_outfile, ''' FIELDS ESCAPED BY '''' LINES TERMINATED BY ''''');
    PREPARE stmt_output FROM @query;
    EXECUTE stmt_output;
    DEALLOCATE PREPARE stmt_output;
    SELECT CONCAT('Stack trace written to ', in_outfile) AS 'Info';
    SELECT CONCAT('dot -Tpdf -o /tmp/stack_', in_thread_id, '.pdf ', in_outfile) AS 'Convert to PDF';
    SELECT CONCAT('dot -Tpng -o /tmp/stack_', in_thread_id, '.png ', in_outfile) AS 'Convert to PNG';
    DROP TEMPORARY TABLE tmp_events;
    -- Reset the settings for the performance schema
    IF (in_auto_setup) THEN
        CALL sys.ps_setup_reload_saved();
    END IF;
    -- Restore INSTRUMENTED for this thread
    IF (v_this_thread_enabed = 'YES') THEN
        CALL sys.ps_setup_enable_thread(CONNECTION_ID());
    END IF;
    SET sql_log_bin = @log_bin;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_truncate_all_tables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `ps_truncate_all_tables`(
        IN in_verbose BOOLEAN
    )
    MODIFIES SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTruncates all summary tables within Performance Schema, \nresetting all aggregated instrumentation as a snapshot.\n\nParameters\n-----------\n\nin_verbose (BOOLEAN):\n  Whether to print each TRUNCATE statement before running\n\nExample\n-----------\n\nmysql> CALL sys.ps_truncate_all_tables(false);\n+---------------------+\n| summary             |\n+---------------------+\n| Truncated 44 tables |\n+---------------------+\n1 row in set (0.10 sec)\n\nQuery OK, 0 rows affected (0.10 sec)\n'
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_total_tables INT DEFAULT 0;
    DECLARE v_ps_table VARCHAR(64);
    DECLARE ps_tables CURSOR FOR
        SELECT table_name 
          FROM INFORMATION_SCHEMA.TABLES 
         WHERE table_schema = 'performance_schema' 
           AND (table_name LIKE '%summary%' 
            OR table_name LIKE '%history%');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    OPEN ps_tables;
    ps_tables_loop: LOOP
        FETCH ps_tables INTO v_ps_table;
        IF v_done THEN
          LEAVE ps_tables_loop;
        END IF;
        SET @truncate_stmt := CONCAT('TRUNCATE TABLE performance_schema.', v_ps_table);
        IF in_verbose THEN
            SELECT CONCAT('Running: ', @truncate_stmt) AS status;
        END IF;
        PREPARE truncate_stmt FROM @truncate_stmt;
        EXECUTE truncate_stmt;
        DEALLOCATE PREPARE truncate_stmt;
        SET v_total_tables = v_total_tables + 1;
    END LOOP;
    CLOSE ps_tables;
    SELECT CONCAT('Truncated ', v_total_tables, ' tables') AS summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `statement_performance_analyzer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `statement_performance_analyzer`(
        IN in_action ENUM('snapshot', 'overall', 'delta', 'create_table', 'create_tmp', 'save', 'cleanup'),
        IN in_table VARCHAR(129),
        IN in_views SET ('with_runtimes_in_95th_percentile', 'analysis', 'with_errors_or_warnings', 'with_full_table_scans', 'with_sorting', 'with_temp_tables', 'custom')
    )
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nCreate a report of the statements running on the server.\n\nThe views are calculated based on the overall and/or delta activity.\n\nRequires the SUPER privilege for "SET sql_log_bin = 0;".\n\nParameters\n-----------\n\nin_action (ENUM(''snapshot'', ''overall'', ''delta'', ''create_tmp'', ''create_table'', ''save'', ''cleanup'')):\n  The action to take. Supported actions are:\n    * snapshot      Store a snapshot. The default is to make a snapshot of the current content of\n                    performance_schema.events_statements_summary_by_digest, but by setting in_table\n                    this can be overwritten to copy the content of the specified table.\n                    The snapshot is stored in the sys.tmp_digests temporary table.\n    * overall       Generate analyzis based on the content specified by in_table. For the overall analyzis,\n                    in_table can be NOW() to use a fresh snapshot. This will overwrite an existing snapshot.\n                    Use NULL for in_table to use the existing snapshot. If in_table IS NULL and no snapshot\n                    exists, a new will be created.\n                    See also in_views and @sys.statement_performance_analyzer.limit.\n    * delta         Generate a delta analysis. The delta will be calculated between the reference table in\n                    in_table and the snapshot. An existing snapshot must exist.\n                    The action uses the sys.tmp_digests_delta temporary table.\n                    See also in_views and @sys.statement_performance_analyzer.limit.\n    * create_table  Create a regular table suitable for storing the snapshot for later use, e.g. for\n                    calculating deltas.\n    * create_tmp    Create a temporary table suitable for storing the snapshot for later use, e.g. for\n                    calculating deltas.\n    * save          Save the snapshot in the table specified by in_table. The table must exists and have\n                    the correct structure.\n                    If no snapshot exists, a new is created.\n    * cleanup       Remove the temporary tables used for the snapshot and delta.\n\nin_table (VARCHAR(129)):\n  The table argument used for some actions. Use the format ''db1.t1'' or ''t1'' without using any backticks (`)\n  for quoting. Periods (.) are not supported in the database and table names.\n\n  The meaning of the table for each action supporting the argument is:\n\n    * snapshot      The snapshot is created based on the specified table. Set to NULL or NOW() to use\n                    the current content of performance_schema.events_statements_summary_by_digest.\n    * overall       The table with the content to create the overall analyzis for. The following values\n                    can be used:\n                      - A table name - use the content of that table.\n                      - NOW()        - create a fresh snapshot and overwrite the existing snapshot.\n                      - NULL         - use the last stored snapshot.\n    * delta         The table name is mandatory and specified the reference view to compare the currently\n                    stored snapshot against. If no snapshot exists, a new will be created.\n    * create_table  The name of the regular table to create.\n    * create_tmp    The name of the temporary table to create.\n    * save          The name of the table to save the currently stored snapshot into.\n\nin_views (SET (''with_runtimes_in_95th_percentile'', ''analysis'', ''with_errors_or_warnings'',\n               ''with_full_table_scans'', ''with_sorting'', ''with_temp_tables'', ''custom''))\n  Which views to include:\n\n    * with_runtimes_in_95th_percentile  Based on the sys.statements_with_runtimes_in_95th_percentile view\n    * analysis                          Based on the sys.statement_analysis view\n    * with_errors_or_warnings           Based on the sys.statements_with_errors_or_warnings view\n    * with_full_table_scans             Based on the sys.statements_with_full_table_scans view\n    * with_sorting                      Based on the sys.statements_with_sorting view\n    * with_temp_tables                  Based on the sys.statements_with_temp_tables view\n    * custom                            Use a custom view. This view must be specified in @sys.statement_performance_analyzer.view to an existing view or a query\n\nDefault is to include all except ''custom''.\n\n\nConfiguration Options\n----------------------\n\nsys.statement_performance_analyzer.limit\n  The maximum number of rows to include for the views that does not have a built-in limit (e.g. the 95th percentile view).\n  If not set the limit is 100.\n\nsys.statement_performance_analyzer.view\n  Used together with the ''custom'' view. If the value contains a space, it is considered a query, otherwise it must be\n  an existing view querying the performance_schema.events_statements_summary_by_digest table. There cannot be any limit\n  clause including in the query or view definition if @sys.statement_performance_analyzer.limit > 0.\n  If specifying a view, use the same format as for in_table.\n\nsys.debug\n  Whether to provide debugging output.\n  Default is ''OFF''. Set to ''ON'' to include.\n\n\nExample\n--------\n\nTo create a report with the queries in the 95th percentile since last truncate of performance_schema.events_statements_summary_by_digest\nand the delta for a 1 minute period:\n\n   1. Create a temporary table to store the initial snapshot.\n   2. Create the initial snapshot.\n   3. Save the initial snapshot in the temporary table.\n   4. Wait one minute.\n   5. Create a new snapshot.\n   6. Perform analyzis based on the new snapshot.\n   7. Perform analyzis based on the delta between the initial and new snapshots.\n\nmysql> CALL sys.statement_performance_analyzer(''create_tmp'', ''mydb.tmp_digests_ini'', NULL);\nQuery OK, 0 rows affected (0.08 sec)\n\nmysql> CALL sys.statement_performance_analyzer(''snapshot'', NULL, NULL);\nQuery OK, 0 rows affected (0.02 sec)\n\nmysql> CALL sys.statement_performance_analyzer(''save'', ''mydb.tmp_digests_ini'', NULL);\nQuery OK, 0 rows affected (0.00 sec)\n\nmysql> DO SLEEP(60);\nQuery OK, 0 rows affected (1 min 0.00 sec)\n\nmysql> CALL sys.statement_performance_analyzer(''snapshot'', NULL, NULL);\nQuery OK, 0 rows affected (0.02 sec)\n\nmysql> CALL sys.statement_performance_analyzer(''overall'', NULL, ''with_runtimes_in_95th_percentile'');\n+-----------------------------------------+\n| Next Output                             |\n+-----------------------------------------+\n| Queries with Runtime in 95th Percentile |\n+-----------------------------------------+\n1 row in set (0.05 sec)\n\n...\n\nmysql> CALL sys.statement_performance_analyzer(''delta'', ''mydb.tmp_digests_ini'', ''with_runtimes_in_95th_percentile'');\n+-----------------------------------------+\n| Next Output                             |\n+-----------------------------------------+\n| Queries with Runtime in 95th Percentile |\n+-----------------------------------------+\n1 row in set (0.03 sec)\n\n...\n\n\nTo create an overall report of the 95th percentile queries and the top 10 queries with full table scans:\n\nmysql> CALL sys.statement_performance_analyzer(''snapshot'', NULL, NULL);\nQuery OK, 0 rows affected (0.01 sec)\n\nmysql> SET @sys.statement_performance_analyzer.limit = 10;\nQuery OK, 0 rows affected (0.00 sec)\n\nmysql> CALL sys.statement_performance_analyzer(''overall'', NULL, ''with_runtimes_in_95th_percentile,with_full_table_scans'');\n+-----------------------------------------+\n| Next Output                             |\n+-----------------------------------------+\n| Queries with Runtime in 95th Percentile |\n+-----------------------------------------+\n1 row in set (0.01 sec)\n\n...\n\n+-------------------------------------+\n| Next Output                         |\n+-------------------------------------+\n| Top 10 Queries with Full Table Scan |\n+-------------------------------------+\n1 row in set (0.09 sec)\n\n...\n\n\nUse a custom view showing the top 10 query sorted by total execution time refreshing the view every minute using\nthe watch command in Linux.\n\nmysql> CREATE OR REPLACE VIEW mydb.my_statements AS\n    -> SELECT sys.format_statement(DIGEST_TEXT) AS query,\n    ->        SCHEMA_NAME AS db,\n    ->        COUNT_STAR AS exec_count,\n    ->        format_pico_time(SUM_TIMER_WAIT) AS total_latency,\n    ->        format_pico_time(AVG_TIMER_WAIT) AS avg_latency,\n    ->        ROUND(IFNULL(SUM_ROWS_SENT / NULLIF(COUNT_STAR, 0), 0)) AS rows_sent_avg,\n    ->        ROUND(IFNULL(SUM_ROWS_EXAMINED / NULLIF(COUNT_STAR, 0), 0)) AS rows_examined_avg,\n    ->        ROUND(IFNULL(SUM_ROWS_AFFECTED / NULLIF(COUNT_STAR, 0), 0)) AS rows_affected_avg,\n    ->        DIGEST AS digest\n    ->   FROM performance_schema.events_statements_summary_by_digest\n    -> ORDER BY SUM_TIMER_WAIT DESC;\nQuery OK, 0 rows affected (0.01 sec)\n\nmysql> CALL sys.statement_performance_analyzer(''create_table'', ''mydb.digests_prev'', NULL);\nQuery OK, 0 rows affected (0.10 sec)\n\nshell$ watch -n 60 "mysql sys --table -e "\n> SET @sys.statement_performance_analyzer.view = ''mydb.my_statements'';\n> SET @sys.statement_performance_analyzer.limit = 10;\n> CALL statement_performance_analyzer(''snapshot'', NULL, NULL);\n> CALL statement_performance_analyzer(''delta'', ''mydb.digests_prev'', ''custom'');\n> CALL statement_performance_analyzer(''save'', ''mydb.digests_prev'', NULL);\n> ""\n\nEvery 60.0s: mysql sys --table -e "                                                                                                   ...  Mon Dec 22 10:58:51 2014\n\n+----------------------------------+\n| Next Output                      |\n+----------------------------------+\n| Top 10 Queries Using Custom View |\n+----------------------------------+\n+-------------------+-------+------------+---------------+-------------+---------------+-------------------+-------------------+----------------------------------+\n| query             | db    | exec_count | total_latency | avg_latency | rows_sent_avg | rows_examined_avg | rows_affected_avg | digest                           |\n+-------------------+-------+------------+---------------+-------------+---------------+-------------------+-------------------+----------------------------------+\n...\n'
BEGIN
    DECLARE v_table_exists, v_tmp_digests_table_exists, v_custom_view_exists ENUM('', 'BASE TABLE', 'VIEW', 'TEMPORARY') DEFAULT '';
    DECLARE v_this_thread_enabled ENUM('YES', 'NO');
    DECLARE v_force_new_snapshot BOOLEAN DEFAULT FALSE;
    DECLARE v_digests_table VARCHAR(133);
    DECLARE v_quoted_table, v_quoted_custom_view VARCHAR(133) DEFAULT '';
    DECLARE v_table_db, v_table_name, v_custom_db, v_custom_name VARCHAR(64);
    DECLARE v_digest_table_template, v_checksum_ref, v_checksum_table text;
    DECLARE v_sql longtext;
    -- Maximum supported length for MESSAGE_TEXT with the SIGNAL command is 128 chars.
    DECLARE v_error_msg VARCHAR(128);
    DECLARE v_old_group_concat_max_len INT UNSIGNED DEFAULT 0;
    -- Don't instrument this thread
    SELECT INSTRUMENTED INTO v_this_thread_enabled FROM performance_schema.threads WHERE PROCESSLIST_ID = CONNECTION_ID();
    IF (v_this_thread_enabled = 'YES') THEN
        CALL sys.ps_setup_disable_thread(CONNECTION_ID());
    END IF;
    -- Temporary table are used - disable sql_log_bin if necessary to prevent them replicating
    SET @log_bin := @@sql_log_bin;
    IF ((@log_bin = 1) AND (@@binlog_format = 'STATEMENT')) THEN
        SET sql_log_bin = 0;
    END IF;
    -- Set configuration options
    IF (@sys.statement_performance_analyzer.limit IS NULL) THEN
        SET @sys.statement_performance_analyzer.limit = sys.sys_get_config('statement_performance_analyzer.limit', '100');
    END IF;
    IF (@sys.debug IS NULL) THEN
        SET @sys.debug                                = sys.sys_get_config('debug'                               , 'OFF');
    END IF;
    -- If in_table is set, break in_table into a db and table component and check whether it exists
    -- in_table = NOW() is considered like it's not set.
    IF (in_table = 'NOW()') THEN
        SET v_force_new_snapshot = TRUE,
            in_table             = NULL;
    ELSEIF (in_table IS NOT NULL) THEN
        IF (NOT INSTR(in_table, '.')) THEN
            -- No . in the table name - use current database
            -- DATABASE() will be the database of the procedure
            SET v_table_db   = DATABASE(),
                v_table_name = in_table;
        ELSE
            SET v_table_db   = SUBSTRING_INDEX(in_table, '.', 1);
            SET v_table_name = SUBSTRING(in_table, CHAR_LENGTH(v_table_db)+2);
        END IF;
        SET v_quoted_table = CONCAT('`', v_table_db, '`.`', v_table_name, '`');
        IF (@sys.debug = 'ON') THEN
            SELECT CONCAT('in_table is: db = ''', v_table_db, ''', table = ''', v_table_name, '''') AS 'Debug';
        END IF;
        IF (v_table_db = DATABASE() AND (v_table_name = 'tmp_digests' OR v_table_name = 'tmp_digests_delta')) THEN
            SET v_error_msg = CONCAT('Invalid value for in_table: ', v_quoted_table, ' is reserved table name.');
            SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = v_error_msg;
        END IF;
        CALL sys.table_exists(v_table_db, v_table_name, v_table_exists);
        IF (@sys.debug = 'ON') THEN
            SELECT CONCAT('v_table_exists = ', v_table_exists) AS 'Debug';
        END IF;
        IF (v_table_exists = 'BASE TABLE') THEN
            SET v_old_group_concat_max_len = @@session.group_concat_max_len;
            SET @@session.group_concat_max_len = 2048;
            -- Verify that the table has the correct table definition
            -- This can only be done for base tables as temporary aren't in information_schema.COLUMNS.
            -- This also minimises the risk of using a production table.
            SET v_checksum_ref = (
                 SELECT GROUP_CONCAT(CONCAT(COLUMN_NAME, COLUMN_TYPE) ORDER BY ORDINAL_POSITION) AS Checksum
                   FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = 'performance_schema' AND TABLE_NAME = 'events_statements_summary_by_digest'
                ),
                v_checksum_table = (
                 SELECT GROUP_CONCAT(CONCAT(COLUMN_NAME, COLUMN_TYPE) ORDER BY ORDINAL_POSITION) AS Checksum
                   FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = v_table_db AND TABLE_NAME = v_table_name
                );
            SET @@session.group_concat_max_len = v_old_group_concat_max_len;
            IF (v_checksum_ref <> v_checksum_table) THEN
                -- The table does not have the correct definition, so abandon
                SET v_error_msg = CONCAT('The table ',
                                         IF(CHAR_LENGTH(v_quoted_table) > 93, CONCAT('...', SUBSTRING(v_quoted_table, -90)), v_quoted_table),
                                         ' has the wrong definition.');
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = v_error_msg;
            END IF;
        END IF;
    END IF;
    IF (in_views IS NULL OR in_views = '') THEN
        -- Set to default
        SET in_views = 'with_runtimes_in_95th_percentile,analysis,with_errors_or_warnings,with_full_table_scans,with_sorting,with_temp_tables';
    END IF;
    -- Validate settings
    CALL sys.table_exists(DATABASE(), 'tmp_digests', v_tmp_digests_table_exists);
    IF (@sys.debug = 'ON') THEN
        SELECT CONCAT('v_tmp_digests_table_exists = ', v_tmp_digests_table_exists) AS 'Debug';
    END IF;
    CASE
        WHEN in_action IN ('snapshot', 'overall') THEN
            -- in_table must be NULL, NOW(), or an existing table
            IF (in_table IS NOT NULL) THEN
                IF (NOT v_table_exists IN ('TEMPORARY', 'BASE TABLE')) THEN
                    SET v_error_msg = CONCAT('The ', in_action, ' action requires in_table to be NULL, NOW() or specify an existing table.',
                                             ' The table ',
                                             IF(CHAR_LENGTH(v_quoted_table) > 16, CONCAT('...', SUBSTRING(v_quoted_table, -13)), v_quoted_table),
                                             ' does not exist.');
                    SIGNAL SQLSTATE '45000'
                       SET MESSAGE_TEXT = v_error_msg;
                END IF;
            END IF;
        WHEN in_action IN ('delta', 'save') THEN
            -- in_table must be an existing table
            IF (v_table_exists NOT IN ('TEMPORARY', 'BASE TABLE')) THEN
                SET v_error_msg = CONCAT('The ', in_action, ' action requires in_table to be an existing table.',
                                         IF(in_table IS NOT NULL, CONCAT(' The table ',
                                             IF(CHAR_LENGTH(v_quoted_table) > 39, CONCAT('...', SUBSTRING(v_quoted_table, -36)), v_quoted_table),
                                             ' does not exist.'), ''));
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = v_error_msg;
            END IF;
            IF (in_action = 'delta' AND v_tmp_digests_table_exists <> 'TEMPORARY') THEN
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = 'An existing snapshot generated with the statement_performance_analyzer() must exist.';
            END IF;
        WHEN in_action = 'create_tmp' THEN
            -- in_table must not exists as a temporary table
            IF (v_table_exists = 'TEMPORARY') THEN
                SET v_error_msg = CONCAT('Cannot create the table ',
                                         IF(CHAR_LENGTH(v_quoted_table) > 72, CONCAT('...', SUBSTRING(v_quoted_table, -69)), v_quoted_table),
                                         ' as it already exists.');
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = v_error_msg;
            END IF;
        WHEN in_action = 'create_table' THEN
            -- in_table must not exists at all
            IF (v_table_exists <> '') THEN
                SET v_error_msg = CONCAT('Cannot create the table ',
                                         IF(CHAR_LENGTH(v_quoted_table) > 52, CONCAT('...', SUBSTRING(v_quoted_table, -49)), v_quoted_table),
                                         ' as it already exists',
                                         IF(v_table_exists = 'TEMPORARY', ' as a temporary table.', '.'));
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = v_error_msg;
            END IF;
        WHEN in_action = 'cleanup' THEN
            -- doesn't use any of the arguments
            DO (SELECT 1);
        ELSE
            SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'Unknown action. Supported actions are: cleanup, create_table, create_tmp, delta, overall, save, snapshot';
    END CASE;
    SET v_digest_table_template = 'CREATE %{TEMPORARY}TABLE %{TABLE_NAME} (
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,
  `DIGEST` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_CPU_TIME` bigint unsigned NOT NULL,
  `MAX_CONTROLLED_MEMORY` bigint unsigned NOT NULL,
  `MAX_TOTAL_MEMORY` bigint unsigned NOT NULL,
  `COUNT_SECONDARY` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp(6) NULL DEFAULT NULL,
  `LAST_SEEN` timestamp(6) NULL DEFAULT NULL,
  `QUANTILE_95` bigint unsigned NOT NULL,
  `QUANTILE_99` bigint unsigned NOT NULL,
  `QUANTILE_999` bigint unsigned NOT NULL,
  `QUERY_SAMPLE_TEXT` longtext,
  `QUERY_SAMPLE_SEEN` timestamp(6) NULL DEFAULT NULL,
  `QUERY_SAMPLE_TIMER_WAIT` bigint unsigned NOT NULL,
  INDEX (SCHEMA_NAME, DIGEST)
) DEFAULT CHARSET=utf8mb4';
    -- Do the action
    -- The actions snapshot, ... requires a fresh snapshot - create it now
    IF (v_force_new_snapshot
           OR in_action = 'snapshot'
           OR (in_action = 'overall' AND in_table IS NULL)
           OR (in_action = 'save' AND v_tmp_digests_table_exists <> 'TEMPORARY')
       ) THEN
        IF (v_tmp_digests_table_exists = 'TEMPORARY') THEN
            IF (@sys.debug = 'ON') THEN
                SELECT 'DROP TEMPORARY TABLE IF EXISTS tmp_digests' AS 'Debug';
            END IF;
            DROP TEMPORARY TABLE IF EXISTS tmp_digests;
        END IF;
        CALL sys.execute_prepared_stmt(REPLACE(REPLACE(v_digest_table_template, '%{TEMPORARY}', 'TEMPORARY '), '%{TABLE_NAME}', 'tmp_digests'));
        SET v_sql = CONCAT('INSERT INTO tmp_digests SELECT * FROM ',
                           IF(in_table IS NULL OR in_action = 'save', 'performance_schema.events_statements_summary_by_digest', v_quoted_table));
        CALL sys.execute_prepared_stmt(v_sql);
    END IF;
    -- Go through the remaining actions
    IF (in_action IN ('create_table', 'create_tmp')) THEN
        IF (in_action = 'create_table') THEN
            CALL sys.execute_prepared_stmt(REPLACE(REPLACE(v_digest_table_template, '%{TEMPORARY}', ''), '%{TABLE_NAME}', v_quoted_table));
        ELSE
            CALL sys.execute_prepared_stmt(REPLACE(REPLACE(v_digest_table_template, '%{TEMPORARY}', 'TEMPORARY '), '%{TABLE_NAME}', v_quoted_table));
        END IF;
    ELSEIF (in_action = 'save') THEN
        CALL sys.execute_prepared_stmt(CONCAT('DELETE FROM ', v_quoted_table));
        CALL sys.execute_prepared_stmt(CONCAT('INSERT INTO ', v_quoted_table, ' SELECT * FROM tmp_digests'));
    ELSEIF (in_action = 'cleanup') THEN
        DROP TEMPORARY TABLE IF EXISTS sys.tmp_digests;
        DROP TEMPORARY TABLE IF EXISTS sys.tmp_digests_delta;
    ELSEIF (in_action IN ('overall', 'delta')) THEN
        -- These are almost the same - for delta calculate the delta in tmp_digests_delta and use that instead of tmp_digests.
        -- And overall allows overriding the table to use.
        IF (in_action = 'overall') THEN
            IF (in_table IS NULL) THEN
                SET v_digests_table = 'tmp_digests';
            ELSE
                SET v_digests_table = v_quoted_table;
            END IF;
        ELSE
            SET v_digests_table = 'tmp_digests_delta';
            DROP TEMPORARY TABLE IF EXISTS tmp_digests_delta;
            CREATE TEMPORARY TABLE tmp_digests_delta LIKE tmp_digests;
            SET v_sql = CONCAT('INSERT INTO tmp_digests_delta
SELECT `d_end`.`SCHEMA_NAME`,
       `d_end`.`DIGEST`,
       `d_end`.`DIGEST_TEXT`,
       `d_end`.`COUNT_STAR`-IFNULL(`d_start`.`COUNT_STAR`, 0) AS ''COUNT_STAR'',
       `d_end`.`SUM_TIMER_WAIT`-IFNULL(`d_start`.`SUM_TIMER_WAIT`, 0) AS ''SUM_TIMER_WAIT'',
       `d_end`.`MIN_TIMER_WAIT` AS ''MIN_TIMER_WAIT'',
       IFNULL((`d_end`.`SUM_TIMER_WAIT`-IFNULL(`d_start`.`SUM_TIMER_WAIT`, 0))/NULLIF(`d_end`.`COUNT_STAR`-IFNULL(`d_start`.`COUNT_STAR`, 0), 0), 0) AS ''AVG_TIMER_WAIT'',
       `d_end`.`MAX_TIMER_WAIT` AS ''MAX_TIMER_WAIT'',
       `d_end`.`SUM_LOCK_TIME`-IFNULL(`d_start`.`SUM_LOCK_TIME`, 0) AS ''SUM_LOCK_TIME'',
       `d_end`.`SUM_ERRORS`-IFNULL(`d_start`.`SUM_ERRORS`, 0) AS ''SUM_ERRORS'',
       `d_end`.`SUM_WARNINGS`-IFNULL(`d_start`.`SUM_WARNINGS`, 0) AS ''SUM_WARNINGS'',
       `d_end`.`SUM_ROWS_AFFECTED`-IFNULL(`d_start`.`SUM_ROWS_AFFECTED`, 0) AS ''SUM_ROWS_AFFECTED'',
       `d_end`.`SUM_ROWS_SENT`-IFNULL(`d_start`.`SUM_ROWS_SENT`, 0) AS ''SUM_ROWS_SENT'',
       `d_end`.`SUM_ROWS_EXAMINED`-IFNULL(`d_start`.`SUM_ROWS_EXAMINED`, 0) AS ''SUM_ROWS_EXAMINED'',
       `d_end`.`SUM_CREATED_TMP_DISK_TABLES`-IFNULL(`d_start`.`SUM_CREATED_TMP_DISK_TABLES`, 0) AS ''SUM_CREATED_TMP_DISK_TABLES'',
       `d_end`.`SUM_CREATED_TMP_TABLES`-IFNULL(`d_start`.`SUM_CREATED_TMP_TABLES`, 0) AS ''SUM_CREATED_TMP_TABLES'',
       `d_end`.`SUM_SELECT_FULL_JOIN`-IFNULL(`d_start`.`SUM_SELECT_FULL_JOIN`, 0) AS ''SUM_SELECT_FULL_JOIN'',
       `d_end`.`SUM_SELECT_FULL_RANGE_JOIN`-IFNULL(`d_start`.`SUM_SELECT_FULL_RANGE_JOIN`, 0) AS ''SUM_SELECT_FULL_RANGE_JOIN'',
       `d_end`.`SUM_SELECT_RANGE`-IFNULL(`d_start`.`SUM_SELECT_RANGE`, 0) AS ''SUM_SELECT_RANGE'',
       `d_end`.`SUM_SELECT_RANGE_CHECK`-IFNULL(`d_start`.`SUM_SELECT_RANGE_CHECK`, 0) AS ''SUM_SELECT_RANGE_CHECK'',
       `d_end`.`SUM_SELECT_SCAN`-IFNULL(`d_start`.`SUM_SELECT_SCAN`, 0) AS ''SUM_SELECT_SCAN'',
       `d_end`.`SUM_SORT_MERGE_PASSES`-IFNULL(`d_start`.`SUM_SORT_MERGE_PASSES`, 0) AS ''SUM_SORT_MERGE_PASSES'',
       `d_end`.`SUM_SORT_RANGE`-IFNULL(`d_start`.`SUM_SORT_RANGE`, 0) AS ''SUM_SORT_RANGE'',
       `d_end`.`SUM_SORT_ROWS`-IFNULL(`d_start`.`SUM_SORT_ROWS`, 0) AS ''SUM_SORT_ROWS'',
       `d_end`.`SUM_SORT_SCAN`-IFNULL(`d_start`.`SUM_SORT_SCAN`, 0) AS ''SUM_SORT_SCAN'',
       `d_end`.`SUM_NO_INDEX_USED`-IFNULL(`d_start`.`SUM_NO_INDEX_USED`, 0) AS ''SUM_NO_INDEX_USED'',
       `d_end`.`SUM_NO_GOOD_INDEX_USED`-IFNULL(`d_start`.`SUM_NO_GOOD_INDEX_USED`, 0) AS ''SUM_NO_GOOD_INDEX_USED'',
       `d_end`.`SUM_CPU_TIME`-IFNULL(`d_start`.`SUM_CPU_TIME`, 0) AS ''SUM_CPU_TIME'',
       `d_end`.`MAX_CONTROLLED_MEMORY` AS ''MAX_CONTROLLED_MEMORY'',
       `d_end`.`MAX_TOTAL_MEMORY` AS ''MAX_TOTAL_MEMORY'',
       `d_end`.`COUNT_SECONDARY`-IFNULL(`d_start`.`COUNT_SECONDARY`, 0) AS ''COUNT_SECONDARY'',
       `d_end`.`FIRST_SEEN`,
       `d_end`.`LAST_SEEN`,
       `d_end`.`QUANTILE_95`,
       `d_end`.`QUANTILE_99`,
       `d_end`.`QUANTILE_999`,
       `d_end`.`QUERY_SAMPLE_TEXT`,
       `d_end`.`QUERY_SAMPLE_SEEN`,
       `d_end`.`QUERY_SAMPLE_TIMER_WAIT`
  FROM tmp_digests d_end
       LEFT OUTER JOIN ', v_quoted_table, ' d_start ON `d_start`.`DIGEST` = `d_end`.`DIGEST`
                                                    AND (`d_start`.`SCHEMA_NAME` = `d_end`.`SCHEMA_NAME`
                                                          OR (`d_start`.`SCHEMA_NAME` IS NULL AND `d_end`.`SCHEMA_NAME` IS NULL)
                                                        )
 WHERE `d_end`.`COUNT_STAR`-IFNULL(`d_start`.`COUNT_STAR`, 0) > 0');
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
        IF (FIND_IN_SET('with_runtimes_in_95th_percentile', in_views)) THEN
            SELECT 'Queries with Runtime in 95th Percentile' AS 'Next Output';
            DROP TEMPORARY TABLE IF EXISTS tmp_digest_avg_latency_distribution1;
            DROP TEMPORARY TABLE IF EXISTS tmp_digest_avg_latency_distribution2;
            DROP TEMPORARY TABLE IF EXISTS tmp_digest_95th_percentile_by_avg_us;
            CREATE TEMPORARY TABLE tmp_digest_avg_latency_distribution1 (
              cnt bigint unsigned NOT NULL,
              avg_us decimal(21,0) NOT NULL,
              PRIMARY KEY (avg_us)
            ) ENGINE=InnoDB;
            SET v_sql = CONCAT('INSERT INTO tmp_digest_avg_latency_distribution1
SELECT COUNT(*) cnt,
       ROUND(avg_timer_wait/1000000) AS avg_us
  FROM ', v_digests_table, '
 GROUP BY avg_us');
            CALL sys.execute_prepared_stmt(v_sql);
            CREATE TEMPORARY TABLE tmp_digest_avg_latency_distribution2 LIKE tmp_digest_avg_latency_distribution1;
            INSERT INTO tmp_digest_avg_latency_distribution2 SELECT * FROM tmp_digest_avg_latency_distribution1;
            CREATE TEMPORARY TABLE tmp_digest_95th_percentile_by_avg_us (
              avg_us decimal(21,0) NOT NULL,
              percentile decimal(46,4) NOT NULL,
              PRIMARY KEY (avg_us)
            ) ENGINE=InnoDB;
            SET v_sql = CONCAT('INSERT INTO tmp_digest_95th_percentile_by_avg_us
SELECT s2.avg_us avg_us,
       IFNULL(SUM(s1.cnt)/NULLIF((SELECT COUNT(*) FROM ', v_digests_table, '), 0), 0) percentile
  FROM tmp_digest_avg_latency_distribution1 AS s1
       JOIN tmp_digest_avg_latency_distribution2 AS s2 ON s1.avg_us <= s2.avg_us
 GROUP BY s2.avg_us
HAVING percentile > 0.95
 ORDER BY percentile
 LIMIT 1');
            CALL sys.execute_prepared_stmt(v_sql);
            SET v_sql =
                REPLACE(
                    REPLACE(
                        (SELECT VIEW_DEFINITION
                           FROM information_schema.VIEWS
                          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'statements_with_runtimes_in_95th_percentile'
                        ),
                        '`performance_schema`.`events_statements_summary_by_digest`',
                        v_digests_table
                    ),
                    'sys.x$ps_digest_95th_percentile_by_avg_us',
                    '`sys`.`x$ps_digest_95th_percentile_by_avg_us`'
              );
            CALL sys.execute_prepared_stmt(v_sql);
            DROP TEMPORARY TABLE tmp_digest_avg_latency_distribution1;
            DROP TEMPORARY TABLE tmp_digest_avg_latency_distribution2;
            DROP TEMPORARY TABLE tmp_digest_95th_percentile_by_avg_us;
        END IF;
        IF (FIND_IN_SET('analysis', in_views)) THEN
            SELECT CONCAT('Top ', @sys.statement_performance_analyzer.limit, ' Queries Ordered by Total Latency') AS 'Next Output';
            SET v_sql =
                REPLACE(
                    (SELECT VIEW_DEFINITION
                       FROM information_schema.VIEWS
                      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'statement_analysis'
                    ),
                    '`performance_schema`.`events_statements_summary_by_digest`',
                    v_digests_table
                );
            IF (@sys.statement_performance_analyzer.limit > 0) THEN
                SET v_sql = CONCAT(v_sql, ' LIMIT ', @sys.statement_performance_analyzer.limit);
            END IF;
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
        IF (FIND_IN_SET('with_errors_or_warnings', in_views)) THEN
            SELECT CONCAT('Top ', @sys.statement_performance_analyzer.limit, ' Queries with Errors') AS 'Next Output';
            SET v_sql =
                REPLACE(
                    (SELECT VIEW_DEFINITION
                       FROM information_schema.VIEWS
                      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'statements_with_errors_or_warnings'
                    ),
                    '`performance_schema`.`events_statements_summary_by_digest`',
                    v_digests_table
                );
            IF (@sys.statement_performance_analyzer.limit > 0) THEN
                SET v_sql = CONCAT(v_sql, ' LIMIT ', @sys.statement_performance_analyzer.limit);
            END IF;
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
        IF (FIND_IN_SET('with_full_table_scans', in_views)) THEN
            SELECT CONCAT('Top ', @sys.statement_performance_analyzer.limit, ' Queries with Full Table Scan') AS 'Next Output';
            SET v_sql =
                REPLACE(
                    (SELECT VIEW_DEFINITION
                       FROM information_schema.VIEWS
                      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'statements_with_full_table_scans'
                    ),
                    '`performance_schema`.`events_statements_summary_by_digest`',
                    v_digests_table
                );
            IF (@sys.statement_performance_analyzer.limit > 0) THEN
                SET v_sql = CONCAT(v_sql, ' LIMIT ', @sys.statement_performance_analyzer.limit);
            END IF;
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
        IF (FIND_IN_SET('with_sorting', in_views)) THEN
            SELECT CONCAT('Top ', @sys.statement_performance_analyzer.limit, ' Queries with Sorting') AS 'Next Output';
            SET v_sql =
                REPLACE(
                    (SELECT VIEW_DEFINITION
                       FROM information_schema.VIEWS
                      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'statements_with_sorting'
                    ),
                    '`performance_schema`.`events_statements_summary_by_digest`',
                    v_digests_table
                );
            IF (@sys.statement_performance_analyzer.limit > 0) THEN
                SET v_sql = CONCAT(v_sql, ' LIMIT ', @sys.statement_performance_analyzer.limit);
            END IF;
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
        IF (FIND_IN_SET('with_temp_tables', in_views)) THEN
            SELECT CONCAT('Top ', @sys.statement_performance_analyzer.limit, ' Queries with Internal Temporary Tables') AS 'Next Output';
            SET v_sql =
                REPLACE(
                    (SELECT VIEW_DEFINITION
                       FROM information_schema.VIEWS
                      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'statements_with_temp_tables'
                    ),
                    '`performance_schema`.`events_statements_summary_by_digest`',
                    v_digests_table
                );
            IF (@sys.statement_performance_analyzer.limit > 0) THEN
                SET v_sql = CONCAT(v_sql, ' LIMIT ', @sys.statement_performance_analyzer.limit);
            END IF;
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
        IF (FIND_IN_SET('custom', in_views)) THEN
            SELECT CONCAT('Top ', @sys.statement_performance_analyzer.limit, ' Queries Using Custom View') AS 'Next Output';
            IF (@sys.statement_performance_analyzer.view IS NULL) THEN
                SET @sys.statement_performance_analyzer.view = sys.sys_get_config('statement_performance_analyzer.view', NULL);
            END IF;
            IF (@sys.statement_performance_analyzer.view IS NULL) THEN
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = 'The @sys.statement_performance_analyzer.view user variable must be set with the view or query to use.';
            END IF;
            IF (NOT INSTR(@sys.statement_performance_analyzer.view, ' ')) THEN
                -- No spaces, so can't be a query
                IF (NOT INSTR(@sys.statement_performance_analyzer.view, '.')) THEN
                    -- No . in the table name - use current database
                    -- DATABASE() will be the database of the procedure
                    SET v_custom_db   = DATABASE(),
                        v_custom_name = @sys.statement_performance_analyzer.view;
                ELSE
                    SET v_custom_db   = SUBSTRING_INDEX(@sys.statement_performance_analyzer.view, '.', 1);
                    SET v_custom_name = SUBSTRING(@sys.statement_performance_analyzer.view, CHAR_LENGTH(v_custom_db)+2);
                END IF;
                CALL sys.table_exists(v_custom_db, v_custom_name, v_custom_view_exists);
                IF (v_custom_view_exists <> 'VIEW') THEN
                    SIGNAL SQLSTATE '45000'
                       SET MESSAGE_TEXT = 'The @sys.statement_performance_analyzer.view user variable is set but specified neither an existing view nor a query.';
                END IF;
                SET v_sql =
                    REPLACE(
                        (SELECT VIEW_DEFINITION
                           FROM information_schema.VIEWS
                          WHERE TABLE_SCHEMA = v_custom_db AND TABLE_NAME = v_custom_name
                        ),
                        '`performance_schema`.`events_statements_summary_by_digest`',
                        v_digests_table
                    );
            ELSE
                SET v_sql = REPLACE(@sys.statement_performance_analyzer.view, '`performance_schema`.`events_statements_summary_by_digest`', v_digests_table);
            END IF;
            IF (@sys.statement_performance_analyzer.limit > 0) THEN
                SET v_sql = CONCAT(v_sql, ' LIMIT ', @sys.statement_performance_analyzer.limit);
            END IF;
            CALL sys.execute_prepared_stmt(v_sql);
        END IF;
    END IF;
    -- Restore INSTRUMENTED for this thread
    IF (v_this_thread_enabled = 'YES') THEN
        CALL sys.ps_setup_enable_thread(CONNECTION_ID());
    END IF;
    IF ((@log_bin = 1) AND (@@binlog_format = 'STATEMENT')) THEN
        SET sql_log_bin = @log_bin;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `table_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysql.sys`@`localhost` PROCEDURE `table_exists`(
        IN in_db VARCHAR(64), IN in_table VARCHAR(64),
        OUT out_exists ENUM('', 'BASE TABLE', 'VIEW', 'TEMPORARY')
    )
    SQL SECURITY INVOKER
    COMMENT '\nDescription\n-----------\n\nTests whether the table specified in in_db and in_table exists either as a regular\ntable, or as a temporary table. The returned value corresponds to the table that\nwill be used, so if there''s both a temporary and a permanent table with the given\nname, then ''TEMPORARY'' will be returned.\n\nParameters\n-----------\n\nin_db (VARCHAR(64)):\n  The database name to check for the existance of the table in.\n\nin_table (VARCHAR(64)):\n  The name of the table to check the existance of.\n\nout_exists ENUM('''', ''BASE TABLE'', ''VIEW'', ''TEMPORARY''):\n  The return value: whether the table exists. The value is one of:\n    * ''''           - the table does not exist neither as a base table, view, nor temporary table.\n    * ''BASE TABLE'' - the table name exists as a permanent base table table.\n    * ''VIEW''       - the table name exists as a view.\n    * ''TEMPORARY''  - the table name exists as a temporary table.\n\nExample\n--------\n\nmysql> CREATE DATABASE db1;\nQuery OK, 1 row affected (0.07 sec)\n\nmysql> use db1;\nDatabase changed\nmysql> CREATE TABLE t1 (id INT PRIMARY KEY);\nQuery OK, 0 rows affected (0.08 sec)\n\nmysql> CREATE TABLE t2 (id INT PRIMARY KEY);\nQuery OK, 0 rows affected (0.08 sec)\n\nmysql> CREATE view v_t1 AS SELECT * FROM t1;\nQuery OK, 0 rows affected (0.00 sec)\n\nmysql> CREATE TEMPORARY TABLE t1 (id INT PRIMARY KEY);\nQuery OK, 0 rows affected (0.00 sec)\n\nmysql> CALL sys.table_exists(''db1'', ''t1'', @exists); SELECT @exists;\nQuery OK, 0 rows affected (0.00 sec)\n\n+------------+\n| @exists    |\n+------------+\n| TEMPORARY  |\n+------------+\n1 row in set (0.00 sec)\n\nmysql> CALL sys.table_exists(''db1'', ''t2'', @exists); SELECT @exists;\nQuery OK, 0 rows affected (0.00 sec)\n\n+------------+\n| @exists    |\n+------------+\n| BASE TABLE |\n+------------+\n1 row in set (0.01 sec)\n\nmysql> CALL sys.table_exists(''db1'', ''v_t1'', @exists); SELECT @exists;\nQuery OK, 0 rows affected (0.00 sec)\n\n+---------+\n| @exists |\n+---------+\n| VIEW    |\n+---------+\n1 row in set (0.00 sec)\n\nmysql> CALL sys.table_exists(''db1'', ''t3'', @exists); SELECT @exists;\nQuery OK, 0 rows affected (0.01 sec)\n\n+---------+\n| @exists |\n+---------+\n|         |\n+---------+\n1 row in set (0.00 sec)\n'
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR 1050 SET v_error = TRUE;
    DECLARE CONTINUE HANDLER FOR 1146 SET v_error = TRUE;
    SET out_exists = '';
    -- Verify whether the table name exists as a normal table
    IF (EXISTS(SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = in_db AND TABLE_NAME = in_table)) THEN
        -- Unfortunately the only way to determine whether there is also a temporary table is to try to create
        -- a temporary table with the same name. If it succeeds the table didn't exist as a temporary table.
        SET @sys.tmp.table_exists.SQL = CONCAT('CREATE TEMPORARY TABLE `', in_db, '`.`', in_table, '` (id INT PRIMARY KEY)');
        PREPARE stmt_create_table FROM @sys.tmp.table_exists.SQL;
        EXECUTE stmt_create_table;
        DEALLOCATE PREPARE stmt_create_table;
        IF (v_error) THEN
            SET out_exists = 'TEMPORARY';
        ELSE
            -- The temporary table was created, i.e. it didn't exist. Remove it again so we don't leave garbage around.
            SET @sys.tmp.table_exists.SQL = CONCAT('DROP TEMPORARY TABLE `', in_db, '`.`', in_table, '`');
            PREPARE stmt_drop_table FROM @sys.tmp.table_exists.SQL;
            EXECUTE stmt_drop_table;
            DEALLOCATE PREPARE stmt_drop_table;
            SET out_exists = (SELECT TABLE_TYPE FROM information_schema.TABLES WHERE TABLE_SCHEMA = in_db AND TABLE_NAME = in_table);
        END IF;
    ELSE
        -- Check whether a temporary table exists with the same name.
        -- If it does it's possible to SELECT from the table without causing an error.
        -- If it does not exist even a PREPARE using the table will fail.
        SET @sys.tmp.table_exists.SQL = CONCAT('SELECT COUNT(*) FROM `', in_db, '`.`', in_table, '`');
        PREPARE stmt_select FROM @sys.tmp.table_exists.SQL;
        IF (NOT v_error) THEN
            DEALLOCATE PREPARE stmt_select;
            SET out_exists = 'TEMPORARY';
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-28 23:39:15
