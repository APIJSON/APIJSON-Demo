-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: apijson.cn    Database: sys
-- ------------------------------------------------------
-- Server version	5.7.43-log

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
-- Table structure for table `Document`
--

DROP TABLE IF EXISTS `Document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Document` (
  `id` bigint(15) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `debug` tinyint(2) NOT NULL DEFAULT '0' COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `from` tinyint(3) NOT NULL DEFAULT '0' COMMENT '来源：0-接口工具；1-CI/CD；2-流量录制',
  `userId` bigint(15) NOT NULL COMMENT '管理员用户id。\n需要先建Admin表，新增登录等相关接口。',
  `project` varchar(100) DEFAULT 'APIJSON',
  `testAccountId` bigint(15) NOT NULL DEFAULT '0' COMMENT '测试账号id。0-不限',
  `version` tinyint(4) NOT NULL DEFAULT '3' COMMENT '接口版本号\n<=0 - 不限制版本，任意版本都可用这个接口；\n>0 - 在这个版本添加的接口。\n\n可在给新版文档前调高默认值，新增的测试用例就不用手动设置版本号了。',
  `group` varchar(45) DEFAULT NULL COMMENT '分组名称',
  `name` varchar(100) NOT NULL COMMENT '接口名称',
  `operation` varchar(45) DEFAULT NULL COMMENT '增删改查等操作类别：：INSERT, SELECT, UPDATE, DELETE, LOGIN, REGISTER, GET_VERIFY, EDIT_PASSWORD …',
  `method` varchar(7) DEFAULT NULL COMMENT 'HTTP Method: GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS, TRACE，值为 NULL 时根据 type 来自动判断',
  `type` varchar(5) NOT NULL DEFAULT 'JSON' COMMENT 'PARAM - GET  ?a=1&b=c&key=value; JSON - POST  application/json; FORM - POST  application/www-x-form-url-encoded; DATA - POST multi-part/form-data',
  `url` varchar(250) NOT NULL COMMENT '请求地址',
  `request` text NOT NULL COMMENT '请求\n用json格式会导致强制排序，而请求中引用赋值只能引用上面的字段，必须有序。',
  `apijson` text COMMENT '从 request 映射为实际的 APIJSON 请求 JSON',
  `sqlauto` text COMMENT '为 SQLAuto 留的字段，格式为\\\\\\\\n{“sql”:”SELECT * FROM `sys`.`Comment` LIMIT ${limit}”,”arg”:”limit: 3”}',
  `standard` text,
  `header` text COMMENT '请求头 Request Header：\nkey: value  //注释',
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `path` varchar(45) DEFAULT NULL COMMENT 'CVAuto 的图片 JSON key 路径',
  `detail` text COMMENT '详细的说明，可以是普通文本或 Markdown 格式文本',
  PRIMARY KEY (`id`),
  KEY `index_url` (`url`),
  KEY `index_date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=1753811912906 DEFAULT CHARSET=utf8 COMMENT='测试用例文档\n后端开发者在测试好后，把选好的测试用例上传，这样就能共享给前端/客户端开发者';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-03 19:46:05
