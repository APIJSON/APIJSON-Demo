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
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` bigint,
  `toId` bigint,
  `userId` bigint,
  `momentId` bigint,
  `date` timestamp,
  `content` text
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (4,0,38710,470,'2017-02-01 11:20:50','This is a Content...-4');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (13,0,82005,58,'2017-02-01 11:20:50','This is a Content...-13');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (22,221,82001,470,'2017-02-01 11:20:50','修改');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (44,0,82003,170,'2017-02-01 11:20:50','This is a Content...-44');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (45,0,93793,301,'2017-02-01 11:20:50','This is a Content...-45');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (47,4,70793,470,'2017-02-01 11:20:50','This is a Content...-47');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (51,45,82003,301,'2017-02-01 11:20:50','This is a Content...-51');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (54,0,82004,170,'2017-02-01 11:20:50','This is a Content...-54');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (68,0,82005,371,'2017-02-01 11:20:50','This is a Content...-68');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (76,45,93793,301,'2017-02-01 11:20:50','This is a Content...-76');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (77,13,93793,58,'2017-02-01 11:20:50','This is a Content...-77');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (97,13,82006,58,'2017-02-01 11:20:50','This is a Content...-97');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (99,44,70793,170,'2017-02-01 11:20:50','This is a Content...-99');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (110,0,93793,371,'2017-02-01 11:23:24','This is a Content...-110');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (114,0,82001,371,'2017-03-02 05:56:06','test multi put');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (115,0,38710,371,'2017-03-02 05:56:06','This is a Content...-115');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (116,0,70793,371,'2017-03-02 05:56:06','This is a Content...-116');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (120,0,93793,301,'2017-03-02 05:56:06','This is a Content...-110');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (124,0,82001,301,'2017-03-02 05:56:06','test multi put');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (157,0,93793,371,'2017-02-01 11:20:50','This is a Content...-157');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (158,0,93793,301,'2018-07-12 17:28:23','This is a Content...-157');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (160,0,82001,235,'2017-03-02 05:56:06','This is a Content...-160');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (162,0,93793,12,'2017-03-06 05:03:45','This is a Content...-162');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (163,0,82001,235,'2017-03-02 05:56:06','This is a Content...-163');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (164,0,93793,12,'2017-03-06 05:03:45','This is a Content...-164');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (167,0,82001,58,'2017-03-25 11:48:41','Nice!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (168,1490442545077,82001,235,'2017-03-25 11:49:14','???');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (172,162,82001,12,'2017-03-25 12:22:58','OK');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (173,0,38710,58,'2017-03-25 12:25:13','Good');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (175,0,38710,12,'2017-03-25 12:26:53','Java is the best program language!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (178,0,38710,511,'2017-03-25 12:30:55','wbw');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (182,110,82001,371,'2017-03-26 06:12:52','hahaha');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (188,97,82001,58,'2017-03-26 07:21:32','1646');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (190,0,82001,58,'2017-03-26 07:22:13','dbdj');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (206,54,82001,170,'2017-03-29 03:04:23','ejej');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (209,13,82001,58,'2017-03-29 03:05:59','hehj');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (300,97,82001,58,'2017-03-29 03:06:07','hj');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (301,194,82001,235,'2017-03-29 03:06:24','jj');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (4001,0,82001,58,'2017-03-29 08:39:52','I would like to say …');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490776944301,0,82001,58,'2017-03-29 08:42:24','hello');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490776966828,173,82001,58,'2017-03-29 08:42:46','me too');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490777905437,0,82001,543,'2017-03-29 08:58:25','rr');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490778122719,175,82001,12,'2017-03-29 09:02:02','Yeah! I think so!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490778494751,1490778122719,82001,12,'2017-03-29 09:08:14','reply Android82001');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490778681337,166,82001,12,'2017-03-29 09:11:21','gg');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490780759866,99,82001,170,'2017-03-29 09:45:59','99');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781009548,51,82001,301,'2017-03-29 09:50:09','3');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781032005,45,82001,301,'2017-03-29 09:50:32','93793');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781817044,209,38710,58,'2017-03-29 10:03:37','82001');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781850893,1490776966828,38710,58,'2017-03-29 10:04:10','haha!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781857242,190,38710,58,'2017-03-29 10:04:17','nice');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781865407,1490781857242,38710,58,'2017-03-29 10:04:25','wow');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781899147,197,38710,12,'2017-03-29 10:04:59','kaka');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794439561,1490778681337,82001,12,'2017-03-29 13:33:59','gg?');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794610632,172,82001,12,'2017-03-29 13:36:50','All right');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794937137,1490794919957,82001,12,'2017-03-29 13:42:17','All right ok ok');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794953438,1490794937137,82001,12,'2017-03-29 13:42:33','All right ok ok ll');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490796241178,0,38710,58,'2017-03-29 14:04:01','Anything else?');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490796629591,175,38710,12,'2017-03-29 14:10:29','well');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490798710678,110,38710,371,'2017-03-29 14:45:10','110');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490800971064,175,38710,12,'2017-03-29 15:22:51','I do');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490848396072,175,82001,12,'2017-03-30 04:33:16','Lemon');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490848581424,166,82001,12,'2017-03-30 04:36:21','82001ejej');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490850764448,162,82001,12,'2017-03-30 05:12:44','-162');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490850844016,0,82001,12,'2017-03-30 05:14:04','I like it');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490850876656,1490800971064,82001,12,'2017-03-30 05:14:36','I do so');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490854894566,175,82001,12,'2017-03-30 06:21:34','it does be a good lang');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863443219,1490850844016,82002,12,'2017-03-30 08:44:03','me too!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863507114,4,82003,470,'2017-03-30 08:45:07','yes');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863563124,0,82003,704,'2017-03-30 08:46:03','I want one');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863651493,0,70793,595,'2017-03-30 08:47:31','wow');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863661426,1490780759866,70793,170,'2017-03-30 08:47:41','66');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863676989,0,70793,12,'2017-03-30 08:47:56','Shy');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863711703,0,70793,511,'2017-03-30 08:48:31','I hope I can join');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863717947,178,70793,511,'2017-03-30 08:48:37','what?');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863783276,1490863711703,93793,511,'2017-03-30 08:49:43','haha welcome');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863903900,0,82006,470,'2017-03-30 08:51:43','SOGA');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863915675,0,82006,235,'2017-03-30 08:51:55','Good boy');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863938712,0,82006,12,'2017-03-30 08:52:18','Handsome!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490863978239,1490796241178,82006,58,'2017-03-30 08:52:58','there still remains a question…');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864016738,0,82006,511,'2017-03-30 08:53:36','I want to have a try!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864023700,0,82006,543,'2017-03-30 08:53:43','oops');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864039264,0,82006,551,'2017-03-30 08:53:59','Wonderful!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864152008,0,82006,58,'2017-03-30 08:55:52','U R ugly( ´?` )');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864254400,1490863915675,82044,235,'2017-03-30 08:57:34','And I have no idea');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864276824,0,82044,12,'2017-03-30 08:57:56','Oh my God!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864292184,1490864152008,82044,58,'2017-03-30 08:58:12','haha!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864379424,1490863938712,82001,12,'2017-03-30 08:59:39','Thank you~');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490864400210,1490864276824,82001,12,'2017-03-30 09:00:00','Amazing, isnt it?');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490874908570,1490864023700,82055,543,'2017-03-30 11:55:08','yeah');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490874930994,1490777905437,82055,543,'2017-03-30 11:55:30','yy');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490874968779,0,82055,12,'2017-03-30 11:56:08','I love it');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490875033494,0,82055,301,'2017-03-30 11:57:13','More Comments');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490875040761,158,82055,301,'2017-03-30 11:57:20','157');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490875046704,120,82055,301,'2017-03-30 11:57:26','110');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490879678127,0,82001,543,'2017-03-30 13:14:38','Baby you are a firework!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490973736662,1490973715568,70793,170,'2017-03-31 15:22:16','Hello, I am a fresh man');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490973890875,1490864039264,93793,551,'2017-03-31 15:24:50','While I donot think so…');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491014830404,1490864016738,82001,511,'2017-04-01 02:47:10','Have a nice day!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491119615611,1490864023700,82001,543,'2017-04-02 07:53:35','$$');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491119670185,68,82001,371,'2017-04-02 07:54:30','Leave a word');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491119695580,0,82001,371,'2017-04-02 07:54:55','leave a word');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491130701902,0,38710,511,'2017-04-02 10:58:21','Thanks for your supports (-^?^-)');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491209763162,0,82001,1491200468898,'2017-04-03 08:56:03','How do you do');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491277552385,0,82001,58,'2017-04-04 03:45:52','Seven');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491312438951,1490863651493,82001,595,'2017-04-04 13:27:18','WaKaKa!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491709064513,0,82001,551,'2017-04-09 03:37:44','soga');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491740899179,0,82001,470,'2017-04-09 12:28:19','www');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491798370749,0,82002,551,'2017-04-10 04:26:10','Nice!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491798499667,115,82002,371,'2017-04-10 04:28:19','I do not understand…');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1491830543193,0,82001,170,'2017-04-10 13:22:23','What is the hell?');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1492932228287,1491209763162,38710,1491200468898,'2017-04-23 07:23:48','fine,thanks');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES 1493094307810,0,82001,551,'2017-04-25 04:25:04','删除或修改数据请先创建，不要动原来的，谢谢');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1493094307910,0,82001,551,'2017-04-25 04:26:04','用POST新增数据');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1493186363132,1490850764448,82001,12,'2017-04-26 05:59:23','sndnd');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1502632433970,0,82002,1493835799335,'2017-08-13 13:53:53','just have fun!');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1508053783278,0,82001,1508053762227,'2017-10-15 07:49:43','可以的');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1508072695833,0,82003,1508072633830,'2017-10-15 13:04:55','心疼地抱住自己(๑´ㅂ`๑)');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1508227498578,1491798370749,82001,551,'2017-10-17 08:04:58','g');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1508462026394,1490850844016,82001,12,'2017-10-20 01:13:46','欧');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1508492585904,1508462026394,82001,12,'2017-10-20 09:43:05','my god');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1509003045509,0,82001,1508072633830,'2017-10-26 07:30:45','hhh');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1509346549158,0,82001,170,'2017-10-30 06:55:49','呵呵');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1509346556395,0,82001,170,'2017-10-30 06:55:56','测试');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1510795816462,162,82001,12,'2017-11-16 01:30:16','赞');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1510813284894,0,82001,12,'2017-11-16 06:21:24','asdasdasdas');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1510813295700,162,82001,12,'2017-11-16 06:21:35','adsdasdasdasd');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1511374269759,99,82001,170,'2017-11-22 18:11:09','记录里');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1511374274194,0,82001,170,'2017-11-22 18:11:14','哦哦哦');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1511407695342,0,1511407581570,371,'2017-11-23 03:28:15','好的');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1511407702981,157,1511407581570,371,'2017-11-23 03:28:22','你好');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1511878024415,0,1511761906715,12,'2017-11-28 14:07:04','你今年');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1511878031610,1511878024415,1511761906715,12,'2017-11-28 14:07:11','不鸟你');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1512035094555,0,82001,12,'2017-11-30 09:44:54','呵呵呵');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1512035117021,0,82001,32,'2017-11-30 09:45:17','图片看不了啊');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1512039030970,1512035117021,82001,32,'2017-11-30 10:50:30','一般九宫格图片都是压缩图，分辨率在300*300左右，加载很快，点击放大后才是原图，1080P左右');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1512531859019,0,1512531601485,1512314438990,'2017-12-06 03:44:19','666'),(1512533520832,1512531859019,38710,1512314438990,'2017-12-06 04:12:00','嘿嘿');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1513656045399,0,82001,1508072633830,'2017-12-19 04:00:45','444444'),(1514425796195,0,82001,1513094436910,'2017-12-28 01:49:56','一起');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514473034425,1514425796195,93793,1513094436910,'2017-12-28 14:57:14','干啥？'),(1514478784653,0,82001,1513094436910,'2017-12-28 16:33:04','bug很多');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514506206319,1514478784653,38710,1513094436910,'2017-12-29 00:10:06','碰到哪些了呢？欢迎指出，尽快解决^_^'),(1514617131036,0,82005,1513094436910,'2017-12-30 06:58:51','口子');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514858592813,0,82001,1514858533480,'2018-01-02 02:03:12','铁人');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514858640958,0,38710,1514858533480,'2018-01-02 02:04:00','斯塔克工业');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514858707767,0,70793,1514858533480,'2018-01-02 02:05:07','壕友乎？');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514960713300,0,82001,1513094436910,'2018-01-03 06:25:13','1');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1514960744185,1512531859019,82001,1512314438990,'2018-01-03 06:25:44','哇');
INSERT INTO `comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1515057852156,0,82001,58,'2018-01-04 09:24:12','你说');

/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-16  0:39:18
