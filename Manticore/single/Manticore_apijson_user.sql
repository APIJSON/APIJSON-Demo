-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: 47.122.25.116    Database: sys
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
-- Table structure for table `apijson_user`
--

DROP TABLE IF EXISTS `apijson_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apijson_user` (
  `id` bigint,
  `sex` integer,
  `name` text,
  `tag` text,
  `head` text,
  `contactIdList` json,
  `pictureList` json,
  `date` timestamp
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apijson_user`
--

LOCK TABLES `apijson_user` WRITE;
/*!40000 ALTER TABLE `apijson_user` DISABLE KEYS */;
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (38710,0,'TommyLemon','Android&Java','https://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000','[82003, 82005, 90814, 82004, 82009, 82002, 82044, 93793, 70793]','[\"https://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000\", \"https://common.cnblogs.com/images/icon_weibo_24.png\"]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (70793,0,'Strong','djdj','https://static.oschina.net/uploads/user/585/1170143_50.jpg?t=1390226446000','[38710, 82002]','[\"https://static.oschina.net/uploads/img/201604/22172508_eGDi.jpg\", \"https://static.oschina.net/uploads/img/201604/22172507_rrZ5.jpg\", \"https://camo.githubusercontent.com/788c0a7e11a\", \"https://camo.githubusercontent.com/f513f67\"]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (82001,1,'Test User','dev','https://static.oschina.net/uploads/user/1174/2348263_50.png?t=1439773471000','[82034, 82005, 82030, 82046, 1493748615711, 38710, 82054, 82002]','[\"https://common.cnblogs.com/images/icon_weibo_24.png\"]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (82002,1,'Jan','iOS','https://static.oschina.net/uploads/user/1174/2348263_50.png?t=1439773471000','[82005, 38710]','[]','2017-02-01 11:21:50'),(82003,0,'Wechat','test','https://common.cnblogs.com/images/wechat.png','[93793]','[]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (82004,0,'Tommy','fasef','https://static.oschina.net/uploads/user/1200/2400261_50.png?t=1439638750000','[]','[]','2017-02-01 11:21:50'),(82005,1,'Jan','AG','https://avatars.githubusercontent.com/u/41146037?v=4','[82001, 38710, 1532439021068]','[]','2017-02-01 11:21:50');
/*!40000 ALTER TABLE `apijson_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-16  0:37:20
