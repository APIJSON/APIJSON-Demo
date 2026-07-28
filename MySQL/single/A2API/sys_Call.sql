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
-- Table structure for table `Call`
--

DROP TABLE IF EXISTS `Call`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Call` (
  `id` bigint NOT NULL COMMENT '主键，客户端/服务端分配（如 Date.now()）',
  `userId` bigint DEFAULT NULL COMMENT '调用用户 id（APIJSON visitor）',
  `submitter` varchar(80) DEFAULT NULL COMMENT '提交人标识 / 登录名',
  `sessionId` varchar(80) DEFAULT NULL COMMENT '会话 id',
  `requestId` varchar(80) DEFAULT NULL COMMENT '业务 requestId（propose/HITL）',
  `source` varchar(40) NOT NULL DEFAULT 'unknown' COMMENT '来源：chat-demo/bound/data-api/admin/approve',
  `operation` varchar(20) NOT NULL COMMENT 'APIJSON 方法：get/head/gets/heads/post/put/delete',
  `method` varchar(10) NOT NULL DEFAULT 'POST' COMMENT 'HTTP Method，APIJSON 一般为 POST',
  `type` varchar(10) NOT NULL DEFAULT 'JSON' COMMENT '请求体类型：JSON/PARAM/FORM',
  `url` varchar(250) NOT NULL COMMENT '完整请求 URL',
  `bizTable` varchar(50) DEFAULT NULL COMMENT '主业务表别名',
  `tag` varchar(50) DEFAULT NULL COMMENT '请求 tag',
  `role` varchar(20) DEFAULT NULL COMMENT '实际/期望角色',
  `request` text COMMENT '请求体 JSON 文本（可截断）',
  `response` text COMMENT '响应体 JSON 文本（可截断）',
  `ok` tinyint NOT NULL DEFAULT '0' COMMENT '是否成功：1-是，0-否',
  `code` int DEFAULT NULL COMMENT 'APIJSON code 或 HTTP status',
  `durationMs` int DEFAULT NULL COMMENT '耗时毫秒',
  `usedLlm` tinyint NOT NULL DEFAULT '0' COMMENT '该次是否经过 LLM：1-是，0-否',
  `error` text COMMENT '失败信息',
  `detail` text COMMENT '备注',
  `date` datetime DEFAULT NULL COMMENT '调用时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='A2API APIJSON 调用日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Call`
--

LOCK TABLES `Call` WRITE;
/*!40000 ALTER TABLE `Call` DISABLE KEYS */;
INSERT INTO `Call` VALUES (9100001,82001,'alice','sess_a1','r_get_moments','chat-demo','get','POST','JSON','http://localhost:8080/get','Moment',NULL,'LOGIN','{\"[]\":{\"count\":3,\"Moment\":{\"@order\":\"date-\"}}}','{\"code\":200,\"[]\":[{\"Moment\":{\"id\":12}}]}',1,200,48,1,NULL,'Bootstrap list moments','2026-07-20 09:01:00'),(9100002,82001,'alice','sess_a1','r_get_moments','bound','get','POST','JSON','http://localhost:8080/get','Moment',NULL,'LOGIN','{\"[]\":{\"count\":3,\"Moment\":{\"@order\":\"date-\"},\"page\":1}}','{\"code\":200,\"[]\":[{\"Moment\":{\"id\":12}}]}',1,200,32,0,NULL,'Steady-state page change','2026-07-20 09:01:20'),(9100003,82001,'alice','sess_a1','r_user_detail','chat-demo','get','POST','JSON','http://localhost:8080/get','User',NULL,'LOGIN','{\"User\":{\"id\":38710}}','{\"code\":200,\"User\":{\"id\":38710,\"name\":\"Tommy\"}}',1,200,41,1,NULL,'User detail','2026-07-20 09:05:00'),(9100004,82002,'bob','sess_b1','r_put_user','chat-demo','put','POST','JSON','http://localhost:8080/put','User','User','OWNER','{\"User\":{\"id\":38710,\"name\":\"Bob\"},\"tag\":\"User\"}','{\"code\":400,\"msg\":\"no Request row for PUT tag=\\\"User\\\"\"}',0,400,55,0,'no Request row for PUT tag=\"User\"','Permission gate → Apply','2026-07-21 10:00:00'),(9100005,82002,'bob','sess_b1','r_post_moment','data-api','post','POST','JSON','http://localhost:8080/post','Moment','Moment','OWNER','{\"Moment\":{\"content\":\"hi\"},\"tag\":\"Moment\"}','{\"code\":200,\"Moment\":{\"id\":99}}',1,200,67,0,NULL,'Data API create','2026-07-21 10:12:00'),(9100006,82001,'alice','sess_a2','r_del_comment','chat-demo','delete','POST','JSON','http://localhost:8080/delete','Comment','Comment','OWNER','{\"Comment\":{\"id\":12},\"tag\":\"Comment\"}',NULL,0,0,120,0,'awaiting admin approval','Sensitive delete queued','2026-07-22 11:00:00'),(9100007,NULL,'admin-ui',NULL,'apply_9002008','approve','post','POST','JSON','http://localhost:8080/post','Request','Request','ADMIN','{\"Request\":{\"method\":\"POST\",\"tag\":\"Moment\",\"structure\":{}},\"tag\":\"Request\"}','{\"code\":200,\"Request\":{\"id\":9002010}}',1,200,88,0,NULL,'Approve wrote Request','2026-07-23 16:00:05'),(9100008,82003,'carol','sess_c1','r_gets_privacy','chat-demo','gets','POST','JSON','http://localhost:8080/gets','Privacy','Privacy','OWNER','{\"Privacy\":{\"id\":82001},\"tag\":\"Privacy\",\"version\":2}','{\"code\":401,\"msg\":\"请登录或注册\"}',0,401,28,1,'请登录或注册','Private read without session','2026-07-23 18:30:00'),(9100009,82001,'alice','sess_a3','r_comments','bound','get','POST','JSON','http://localhost:8080/get','Comment',NULL,'LOGIN','{\"[]\":{\"count\":20,\"Comment\":{\"momentId\":12}}}','{\"code\":200,\"[]\":[]}',1,200,36,0,NULL,'List comments under moment','2026-07-24 08:00:00'),(9100010,82001,'alice','sess_a3','r_post_comment','chat-demo','post','POST','JSON','http://localhost:8080/post','Comment','Comment','OWNER','{\"Comment\":{\"momentId\":12,\"content\":\"nice\"},\"tag\":\"Comment\"}','{\"code\":200,\"Comment\":{\"id\":44}}',1,200,72,0,NULL,'Create comment','2026-07-24 08:01:00'),(9100011,82004,'dave','sess_d1','r_get_fail','data-api','get','POST','JSON','http://localhost:8080/get','Moment',NULL,'UNKNOWN','{\"Moment\":{\"id\":-1}}','{\"code\":200,\"Moment\":null}',1,200,22,0,NULL,'Empty hit still code 200','2026-07-24 20:15:00'),(9100012,82001,'alice','sess_a4','r_put_moment','bound','put','POST','JSON','http://localhost:8080/put','Moment','Moment','OWNER','{\"Moment\":{\"id\":12,\"content\":\"edited\"},\"tag\":\"Moment\"}','{\"code\":200,\"Moment\":{\"id\":12}}',1,200,59,0,NULL,'Edit moment after Access grant','2026-07-25 01:10:00');
/*!40000 ALTER TABLE `Call` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-29  1:32:49
