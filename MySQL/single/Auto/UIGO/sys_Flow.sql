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
-- Table structure for table `Flow`
--

DROP TABLE IF EXISTS `Flow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Flow` (
  `id` bigint(15) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `userId` bigint(15) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT '名称',
  `deviceId` bigint(15) NOT NULL COMMENT '机型 id',
  `systemId` bigint(15) NOT NULL COMMENT '系统 id',
  `imei` varchar(100) DEFAULT NULL COMMENT '设备 IMEI 号',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `screencapUrl` varchar(1000) DEFAULT NULL COMMENT '录屏链接',
  `logUrl` varchar(1000) DEFAULT NULL COMMENT '日志链接',
  `accountId` varchar(45) DEFAULT NULL,
  `accountName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1712141511131 DEFAULT CHARSET=utf8 COMMENT='操作流程';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flow`
--

LOCK TABLES `Flow` WRITE;
/*!40000 ALTER TABLE `Flow` DISABLE KEYS */;
INSERT INTO `Flow` VALUES (1602060059581,82001,'测试用例',1602084643610,1602494649560,NULL,'2020-10-07 08:40:59',NULL,'',NULL,NULL),(1602060270989,82001,'测试分割线轨迹',1602084643610,1602494649560,NULL,'2020-10-07 08:44:30',NULL,'',NULL,NULL),(1602066287834,82001,'测试横竖屏切换',1602084643610,1602494649560,NULL,'2020-10-07 10:24:47',NULL,'',NULL,NULL),(1602067871901,82001,'横竖屏切换，各种滑动',1601930618601,1601930423250,NULL,'2020-10-07 10:51:11',NULL,'',NULL,NULL),(1602084332313,82001,'step & time',1601930618601,1601930423250,NULL,'2020-10-07 15:25:32',NULL,'',NULL,NULL),(1602089560395,82001,'操作流程 skip step',1601930618601,1601930423250,NULL,'2020-10-07 16:52:40',NULL,'',NULL,NULL),(1602089630561,82001,'操作流程 Simple',1601930618601,1601930423250,NULL,'2020-10-07 16:53:50',NULL,'',NULL,NULL),(1602090095268,82001,'操作流程 short',1601930618601,1601930423250,NULL,'2020-10-07 17:01:35',NULL,'',NULL,NULL),(1602493112287,82001,'1035 steps',1601930618601,1601930423250,NULL,'2020-10-12 08:58:32',NULL,'',NULL,NULL),(1602495177971,82001,'操作流程 MI MIX3 9.0',1601930618601,1601930423250,NULL,'2020-10-12 09:32:57',NULL,'',NULL,NULL),(1603041790596,82001,'操作流程 waite HTTP',1601929575137,1601929575252,NULL,'2020-10-18 17:23:10',NULL,'http://apijson.cn/log/Apache-License-2.0.txt',NULL,NULL),(1603101612162,82001,'操作流程 Auto Wait-failed 2 events',1601929575137,1601929575252,NULL,'2020-10-19 10:00:12',NULL,'http://apijson.cn/log/CHANGES.txt',NULL,NULL),(1616424998705,82001,'操作流程 由 小米 MIX 3 录制',0,0,NULL,'2021-03-22 14:56:38',NULL,NULL,NULL,NULL),(1616600489244,82001,'操作流程 由 华为 Mate 10 Pro 录制',0,0,NULL,'2021-03-24 15:41:29',NULL,NULL,NULL,NULL),(1682040826734,82001,'竖屏操作',0,0,NULL,'2023-04-21 01:33:46',NULL,NULL,NULL,NULL),(1682160079956,82001,'APIJSONApp，带弹窗 华为畅想9S  2340*1080',0,0,NULL,'2023-04-22 10:41:19',NULL,NULL,NULL,NULL),(1682161239220,82001,'APIJSONApp 华为畅享9S 2340*1080',0,0,NULL,'2023-04-22 11:00:39',NULL,NULL,NULL,NULL),(1682162508339,82001,'APIJSONApp 小米 12 Pro 3200*1440',0,0,NULL,'2023-04-22 11:21:48',NULL,NULL,NULL,NULL),(1682174035424,82001,'Test 小米 12 Pro 3200*1440',0,0,NULL,'2023-04-22 14:33:55',NULL,NULL,NULL,NULL),(1682236259834,82001,'APIJSONApp 小米 12Pro 3200*1440 不涉及弹窗',0,0,NULL,'2023-04-23 07:50:59',NULL,NULL,NULL,NULL),(1682299131353,82003,'APIJSONApp MI 12Pro 3200*1440 simple',0,0,NULL,'2023-04-24 01:18:51',NULL,NULL,NULL,NULL),(1691975558332,82001,'APIJSONApp 无键盘输入',0,0,NULL,'2023-08-14 01:12:38',NULL,NULL,NULL,NULL),(1700495467621,82002,'下拉刷新、键盘输入等',0,0,NULL,'2023-11-20 15:51:07',NULL,NULL,NULL,NULL),(1700530525671,82002,'App下拉、上拉、滑动、输入、点击等',0,0,NULL,'2023-11-21 01:35:25',NULL,NULL,NULL,NULL),(1700533722731,82002,'下拉、上拉、弹窗、输入、滑动、点击等',0,0,NULL,'2023-11-21 02:28:42',NULL,NULL,NULL,NULL),(1700805506715,82001,'82001 复杂列表下拉刷新、上拉加载',0,0,NULL,'2023-11-24 05:58:26',NULL,NULL,NULL,NULL),(1701110111010,82001,'搜狗输入框编辑',0,0,NULL,'2023-11-27 18:35:11',NULL,NULL,NULL,NULL),(1701110424718,82001,'搜狗输入框编辑2',0,0,NULL,'2023-11-27 18:40:24',NULL,NULL,NULL,NULL),(1701859570971,82001,'82001-Pixel2-1080x1920',0,0,NULL,'2023-12-06 10:46:10',NULL,NULL,NULL,NULL),(1701860599235,82001,'82001-Pixel2-1080x1920-pull,input,scroll',0,0,NULL,'2023-12-06 11:03:19',NULL,NULL,NULL,NULL),(1701861086879,82001,'82001-Pixel2-1080x1920-input,pull,scroll..',0,0,NULL,'2023-12-06 11:11:26',NULL,NULL,NULL,NULL),(1701861645072,82001,'82001-Pixel2-1080x1920-bottom,right,center..',0,0,NULL,'2023-12-06 11:20:45',NULL,NULL,NULL,NULL),(1701885099420,82001,'82001-Nexus4-10-768x1280-pull-scroll..',0,0,NULL,'2023-12-06 17:51:39',NULL,NULL,NULL,NULL),(1701887236172,82001,'Nexus7-10-1200x1920',0,0,NULL,'2023-12-06 18:27:16',NULL,NULL,NULL,NULL),(1701939133757,82001,'Pixel2-1080x1920-click-corners',0,0,NULL,'2023-12-07 08:52:13',NULL,NULL,NULL,NULL),(1701946325622,82001,'小米12Pro-1440x3200 点击四角',0,0,NULL,'2023-12-07 10:52:05',NULL,NULL,NULL,NULL),(1701946938832,82001,'小米12Pro-1440x3200-点击四角',0,0,NULL,'2023-12-07 11:02:18',NULL,NULL,NULL,NULL),(1701954230335,82001,'Pixel2-1080x1920-click corners',0,0,NULL,'2023-12-07 13:03:50',NULL,NULL,NULL,NULL),(1701958350955,82001,'小米12Pro-1440x3200-拖拽、滑动、输入等',0,0,NULL,'2023-12-07 14:12:30',NULL,NULL,NULL,NULL),(1701960466782,82001,'Pixel2-1080x1920-click,scroll..',0,0,NULL,'2023-12-07 14:47:46',NULL,NULL,NULL,NULL),(1701961712921,82001,'小米12Pro-1440x3200-各处点击',0,0,NULL,'2023-12-07 15:08:32',NULL,NULL,NULL,NULL),(1701962547588,82001,'Pixel6-1080x2400-click corners',0,0,NULL,'2023-12-07 15:22:27',NULL,NULL,NULL,NULL),(1701977441930,82001,'搜狗网页搜索',0,0,NULL,'2023-12-07 19:30:41',NULL,NULL,NULL,NULL),(1702548643400,82001,'搜狗网页搜索-反复输入-精准模拟编辑',0,0,NULL,'2023-12-14 10:10:43',NULL,NULL,NULL,NULL),(1702569528340,82001,'开源中国网页首页输入、搜索、返回等',0,0,NULL,'2023-12-14 15:58:48',NULL,NULL,NULL,NULL),(1702702831529,82001,'开源中国网页登录后编辑收货信息',0,0,NULL,'2023-12-16 05:00:31',NULL,NULL,NULL,NULL),(1702731798335,82001,'开源中国网页首页搜索+编辑个人资料',0,0,NULL,'2023-12-16 13:03:18',NULL,NULL,NULL,NULL),(1702739159875,82001,'82001-小米MIX3-刷新、加载、输入等',0,0,NULL,'2023-12-16 15:05:59',NULL,NULL,NULL,NULL),(1702790614680,82001,'82001-小米MIX3-1080x2340-列表滑动点击',0,0,NULL,'2023-12-17 05:23:34',NULL,NULL,NULL,NULL),(1702791328085,82001,'82001-小米MIX-列表滑动、点击',0,0,NULL,'2023-12-17 05:35:28',NULL,NULL,NULL,NULL),(1702975771941,82001,'82001-Pixel2-1080x1920-scroll and click',0,0,NULL,'2023-12-19 08:49:31',NULL,NULL,NULL,NULL),(1702982879140,82001,'82001-小米12P-1440x3200-列表滑动精准点击',0,0,NULL,'2023-12-19 10:47:59',NULL,NULL,NULL,NULL),(1702998363129,82001,'82001-小米12P-1440x3200-列表滑动精准点击',0,0,NULL,'2023-12-19 15:06:03',NULL,NULL,NULL,NULL),(1703217109714,82001,'82001-Pixel6-1080x2400-scroll list and click',0,0,NULL,'2023-12-22 03:51:49',NULL,NULL,NULL,NULL),(1703223262950,82001,'82001-小米12P-1440x3200-列表滑动、精准点击',0,0,NULL,'2023-12-22 05:34:22',NULL,NULL,NULL,NULL),(1703234270049,82001,'82001-小米12P-1440x3200-列表滑动、精准点击',0,0,NULL,'2023-12-22 08:37:50',NULL,NULL,NULL,NULL),(1703235231339,82001,'82001-小米12P-1440x3200-列表滑动、精准点击',0,0,NULL,'2023-12-22 08:53:51',NULL,NULL,NULL,NULL),(1703236099949,82001,'82001-小米12P-滑动列表、精准点击',0,0,NULL,'2023-12-22 09:08:19',NULL,NULL,NULL,NULL),(1703237240942,82001,'82001-小米12P-1440x3200-滑动列表、精准点击',0,0,NULL,'2023-12-22 09:27:20',NULL,NULL,NULL,NULL),(1703238728614,82001,'82001-MI12P-1440x3200-各种滑动、输入、点击、弹窗',0,0,NULL,'2023-12-22 09:52:08',NULL,NULL,NULL,NULL),(1703247000678,82001,'开源中国网页点击、输入-小米12P-1440x3200',0,0,NULL,'2023-12-22 12:10:00',NULL,NULL,NULL,NULL),(1703260073846,82001,'82001-MIX3-1080x2340-各种滑动、点击、输入、弹窗等',0,0,NULL,'2023-12-22 15:47:53',NULL,NULL,NULL,NULL),(1703316398717,82001,'82001-MI12P-1440x3200-反复上下滑动列表、精准点击',0,0,NULL,'2023-12-23 07:26:38',NULL,NULL,NULL,NULL),(1703325907105,82001,'82001-MI12P-1440x3200-滑动列表并精准点击',0,0,NULL,'2023-12-23 10:05:07',NULL,NULL,NULL,NULL),(1703327478123,82001,'开源中国输入、点击等-MIX3-1080x2340',0,0,NULL,'2023-12-23 10:31:18',NULL,NULL,NULL,NULL),(1703390485792,82001,'82001-MI12P-导航栏-滑动列表，精准点击',0,0,NULL,'2023-12-24 04:01:25',NULL,NULL,NULL,NULL),(1705831839365,82001,'Pixel2-1080X1920-click center',0,0,NULL,'2024-01-21 10:10:39',NULL,NULL,NULL,NULL),(1705831995798,82001,'Pixel2-1080X1920-Click center',0,0,NULL,'2024-01-21 10:13:15',NULL,NULL,NULL,NULL),(1705833189688,82001,'Pixel2-1080X1920-click center points',0,0,NULL,'2024-01-21 10:33:09',NULL,NULL,NULL,NULL),(1705833502052,82001,'Pixel2-1080x1920-click centers',0,0,NULL,'2024-01-21 10:38:22',NULL,NULL,NULL,NULL),(1705834093487,82001,'Pixel2-1080x1920-click center & center coners',0,0,NULL,'2024-01-21 10:48:13',NULL,NULL,NULL,NULL),(1705848953863,82001,'MIX3-1080x2340-点击居中按钮',0,0,NULL,'2024-01-21 14:55:53',NULL,NULL,NULL,NULL),(1705998231034,82001,'操作流程 Temp',0,0,NULL,'2024-01-23 08:23:51',NULL,NULL,NULL,NULL),(1705999214790,82001,'Pixel2-14-1080x1920-Ratio-click-main-tab',0,0,NULL,'2024-01-23 08:40:14',NULL,NULL,NULL,NULL),(1706180971515,82001,'操作流程 Temp',0,0,NULL,'2024-01-25 11:09:31',NULL,NULL,NULL,NULL),(1706776743643,82001,'Pixel2-1080x1920-click wallter center',0,0,NULL,'2024-02-01 08:39:03',NULL,NULL,NULL,NULL),(1706848485875,82001,'MIX3-1080X2340-键盘不同高度',0,0,NULL,'2024-02-02 04:34:45',NULL,NULL,NULL,NULL),(1706854374988,82001,'MI12P-1440X3200-点击钱包居中按钮',0,0,NULL,'2024-02-02 06:12:55',NULL,NULL,NULL,NULL),(1706854766916,82001,'MIMIP-1440X3200-点击钱包居中按钮',0,0,NULL,'2024-02-02 06:19:26',NULL,NULL,NULL,NULL),(1706855241443,82001,'Pixel2-1080X1920-click wallet center buttons',0,0,NULL,'2024-02-02 06:27:21',NULL,NULL,NULL,NULL),(1706894501892,82001,'MIX3-1080x2340-点击首页地步 tab，不同重心',0,0,NULL,'2024-02-02 17:21:41',NULL,NULL,NULL,NULL),(1707125503071,82001,'MI12P-1440X3200-各种弹窗、输入、滑动、点击',0,0,NULL,'2024-02-05 09:31:43',NULL,NULL,NULL,NULL),(1707127960092,82001,'MIX3-1080X2340-82001-弹窗、输入、滑动、点击等',0,0,NULL,'2024-02-05 10:12:40',NULL,NULL,NULL,NULL),(1707129093626,82001,'MI12P-1440X3200-82001-弹窗、输入、滑动、点击等',0,0,NULL,'2024-02-05 10:31:33',NULL,NULL,NULL,NULL),(1707147888491,82001,'MI12P-1440X3200-双指缩放网页中图片',0,0,NULL,'2024-02-05 15:44:48',NULL,NULL,NULL,NULL),(1707148139457,82001,'MIX3-1080X2340-双指缩放网页图片',0,0,NULL,'2024-02-05 15:48:59',NULL,NULL,NULL,NULL),(1707214187312,82001,'Pixel6-1080X2400-click setting item top_left & bottom_right',0,0,NULL,'2024-02-06 10:09:47',NULL,NULL,NULL,NULL),(1707214358776,82001,'Pixel2-1080X1920-click setting item top_left & bottom_right',0,0,NULL,'2024-02-06 10:12:38',NULL,NULL,NULL,NULL),(1707217017731,82001,'Pixel6-1080X2400-click & scroll from main corner',0,0,NULL,'2024-02-06 10:56:57',NULL,NULL,NULL,NULL),(1707228958168,82001,'Pixel6-1080X2400-click main corners',0,0,NULL,'2024-02-06 14:15:58',NULL,NULL,NULL,NULL),(1707236154415,82001,'Pixel6-1080X2400-click & scroll from main corners',0,0,NULL,'2024-02-06 16:15:54',NULL,NULL,NULL,NULL),(1707279677891,82001,'Pixel6-1080X2400-scroll & click main blind spot',0,0,NULL,'2024-02-07 04:21:17',NULL,NULL,NULL,NULL),(1707321379510,82001,'MI12P-1440X3200-82001-首页盲区触控',0,0,NULL,'2024-02-07 15:56:19',NULL,NULL,NULL,NULL),(1707355013693,82001,'MI12P-1440X3200-82001-滑动首页并精准点击',0,0,NULL,'2024-02-08 01:16:53',NULL,NULL,NULL,NULL),(1707357304953,82001,'MIX3-1080X2340-首页滑动和精准点击',0,0,NULL,'2024-02-08 01:55:04',NULL,NULL,NULL,NULL),(1707358982312,82001,'MIX3-1080X2340-导航键-各种弹窗、输入、滑动、点击',0,0,NULL,'2024-02-08 02:23:02',NULL,NULL,NULL,NULL),(1708248277954,82001,'MIX3-测试 id 校准',0,0,NULL,'2024-02-18 09:24:37',NULL,NULL,NULL,NULL),(1708309008369,82001,'MI12P-1440X3200-82001-各种弹窗、输入、精准滑动与点击等',0,0,NULL,'2024-02-19 02:16:48',NULL,NULL,NULL,NULL),(1708313916535,82001,'MIX3-1080X2340-导航键-82001-各种弹窗、输入、精准滑动与点击',0,0,NULL,'2024-02-19 03:38:36',NULL,NULL,NULL,NULL),(1708482117164,82001,'操作流程 Temp',0,0,NULL,'2024-02-21 02:21:57',NULL,NULL,NULL,NULL),(1708482323291,82001,'MI12P-1440X3200-首页快速乱滑',0,0,NULL,'2024-02-21 02:25:23',NULL,NULL,NULL,NULL),(1708482610647,82001,'MIX3-1080X2340-首页乱滑',0,0,NULL,'2024-02-21 02:30:10',NULL,NULL,NULL,NULL),(1708482851651,82001,'MI12P-1440X3200-乱滑乱缩放图片',0,0,NULL,'2024-02-21 02:34:11',NULL,NULL,NULL,NULL),(1708504877508,82001,'MI12P-1440X3200-Test-各种滑动、点击、长按、横竖屏切换等',0,0,NULL,'2024-02-21 08:41:17',NULL,NULL,NULL,NULL),(1708616359019,82001,'MIX3-1080X2340-Test-各种滑动、旋屏、点击',0,0,NULL,'2024-02-22 15:39:19',NULL,NULL,NULL,NULL),(1708651766392,82001,'MIX3-1080X2340-Test-简单点击',0,0,NULL,'2024-02-23 01:29:26',NULL,NULL,NULL,NULL),(1708652228553,82001,'MI12P-1080X2340-Test-带 id 各种滑动、旋屏、点击等',0,0,NULL,'2024-02-23 01:37:08',NULL,NULL,NULL,NULL),(1708652767675,82001,'MIX3-1080x2340-Test-各种滑动、旋屏、长按、点击',0,0,NULL,'2024-02-23 01:46:07',NULL,NULL,NULL,NULL),(1708685658665,82001,'MI12P-1440X3200-Test-各种旋屏、滑动、长按、点击等',0,0,NULL,'2024-02-23 10:54:18',NULL,NULL,NULL,NULL),(1708689169584,82001,'MIX3-1080x2340-Test-各种旋屏、滑动、长按、点击',0,0,NULL,'2024-02-23 11:52:49',NULL,NULL,NULL,NULL),(1708693502460,82001,'MI12P-1440x3200-Test-各种旋屏、滑动、长按、点击',0,0,NULL,'2024-02-23 13:05:02',NULL,NULL,NULL,NULL),(1708704540888,82001,'MIX3-1080x2340-Test-各种旋屏、输入、滑动、长按、点击',0,0,NULL,'2024-02-23 16:09:00',NULL,NULL,NULL,NULL),(1708929244728,82001,'MIX3-1080X2340-导航栏-弹窗内外各种点击',0,0,NULL,'2024-02-26 06:34:04',NULL,NULL,NULL,NULL),(1708930350151,82001,'MI12P-1440X3200-弹窗内外各种点击',0,0,NULL,'2024-02-26 06:52:30',NULL,NULL,NULL,NULL),(1708930722776,82001,'MI12P-1440X3200-弹窗内外各种点按',0,0,NULL,'2024-02-26 06:58:42',NULL,NULL,NULL,NULL),(1708934270362,82001,'MI12P-1440X3200-各种弹窗、输入、滑动、点击等',0,0,NULL,'2024-02-26 07:57:50',NULL,NULL,NULL,NULL),(1708936368591,82001,'MIX3-1080X2340-各种弹窗、输入、滑动、点击等',0,0,NULL,'2024-02-26 08:32:48',NULL,NULL,NULL,NULL),(1708963940940,82001,'MIX3-1080X2340-各种弹窗、输入、滑动、点击等',0,0,NULL,'2024-02-26 16:12:20',NULL,NULL,NULL,NULL),(1708964606518,82001,'MIX3 用户详情底部菜单居中二维码按钮',0,0,NULL,'2024-02-26 16:23:26',NULL,NULL,NULL,NULL),(1709017509805,82001,'MI12P-1440X3200-82001-首页精准点击文本高亮 SpannableString 区域',0,0,NULL,'2024-02-27 07:05:09',NULL,NULL,NULL,NULL),(1709018868209,82001,'操作流程 Temp',0,0,NULL,'2024-02-27 07:27:48',NULL,NULL,NULL,NULL),(1709028669753,82001,'MIX3-1080x2340-首页快速乱滑、网页图片快速乱缩放',0,0,NULL,'2024-02-27 10:11:09',NULL,NULL,NULL,NULL),(1709043340606,82001,'MI12P-1440X3200-首页快速乱滑',0,0,NULL,'2024-02-27 14:15:40',NULL,NULL,NULL,NULL),(1709045140046,82001,'MI12P-1440X3200-网页图片快速乱拖拽乱缩放',0,0,NULL,'2024-02-27 14:45:40',NULL,NULL,NULL,NULL),(1709052304749,82001,'MIX3-1080X2340-82001-首页点击各种 SpannableString',0,0,NULL,'2024-02-27 16:45:04',NULL,NULL,NULL,NULL),(1709131087683,82001,'MIX3-1080X2340-82001-首页精准点击 SpannableString',0,0,NULL,'2024-02-28 14:38:07',NULL,NULL,NULL,NULL),(1709137755692,82003,'MIX3-1080x2340-82003-首页精准点击 SpannableString',0,0,NULL,'2024-02-28 16:29:15',NULL,NULL,NULL,NULL),(1709361304626,82003,'MI12P-1440X3200-82003-首页精准滑动和点击',1709361301606,1709361304524,NULL,'2024-03-02 06:35:04',NULL,NULL,NULL,NULL),(1709392824112,82003,'MIX3-1080x2340-82003-各种弹窗、输入、滑动、点击',1709392823856,1709392823972,NULL,'2024-03-02 15:20:24',NULL,NULL,NULL,NULL),(1709393524747,82003,'MIX3-1080x2340-82003-弹窗、输入、滑动、点击等',1709393524557,1709393524651,NULL,'2024-03-02 15:32:04',NULL,NULL,NULL,NULL),(1709394497309,82003,'MIX3-1080x2340-82003-各种弹窗、输入、滑动、点击等',1709394497052,1709394497188,NULL,'2024-03-02 15:48:17',NULL,NULL,NULL,NULL),(1709395464890,82003,'MI12P-1440X3200-82003-各种弹窗、输入、滑动、点击等',1709395464613,1709395464761,NULL,'2024-03-02 16:04:24',NULL,NULL,NULL,NULL),(1709457866440,82003,'MI12P-1440X3200-82003-各种弹窗、输入、滑动、点击等',1709457866245,1709457866355,NULL,'2024-03-03 09:24:26',NULL,NULL,NULL,NULL),(1709721404489,82003,'MIX3-1080x2340-82003-首页滑动精准点击(带 childIndex)',1709721404205,1709721404351,NULL,'2024-03-06 10:36:44',NULL,NULL,NULL,NULL),(1709725389743,82003,'MI12P-1440X3200-82003-childIndex',1709725389422,1709725389637,NULL,'2024-03-06 11:43:09',NULL,NULL,NULL,NULL),(1709743502924,82003,'MIX3-1080x2340-82003-首页精准滑动、点击',1709743502724,1709743502815,NULL,'2024-03-06 16:45:02',NULL,NULL,NULL,NULL),(1709744321234,82003,'MI12P-1440X3200-82003-首页精准滑动和点击',1709744320934,1709744321105,NULL,'2024-03-06 16:58:41',NULL,NULL,NULL,NULL),(1709744954220,82003,'MI12P-1440X3200-82003-首页精准滑动、点击',1709744953971,1709744954121,NULL,'2024-03-06 17:09:14',NULL,NULL,NULL,NULL),(1709918916376,82003,'MIX3-1080x2340-82003-各种弹窗、输入、滑动、点击等',1709918916157,1709918916288,NULL,'2024-03-08 17:28:36',NULL,NULL,NULL,NULL),(1709919630423,82003,'MIX3-1080x2340-82003-各种弹窗、输入、滑动、点击等',1709919630258,1709919630347,NULL,'2024-03-08 17:40:30',NULL,NULL,NULL,NULL),(1710349491666,82003,'MIX3-1080x2340-82003-首页精准滑动和点击',1710349491454,1710349491556,NULL,'2024-03-13 17:04:51',NULL,NULL,NULL,NULL),(1710410921508,82003,'操作流程 2024年3月14日 18:08:38',1710410921180,1710410921386,NULL,'2024-03-14 10:08:41',NULL,NULL,NULL,NULL),(1711176308062,82003,'Nexus9-82003-Main scroll and click',1711176307876,1711176307991,NULL,'2024-03-23 06:45:08',NULL,NULL,NULL,NULL),(1711176970922,82003,'Nexus9-82003-Main Page scroll and click',1711176970797,1711176970861,NULL,'2024-03-23 06:56:10',NULL,NULL,NULL,NULL),(1711176970923,82001,'操作流程 2024年3月23日 22:47:06',1711176970798,1711176970862,NULL,'2024-03-23 14:49:58',NULL,NULL,NULL,NULL),(1711176970924,82001,'操作流程 2024年3月23日 23:03:03',1711176970799,1711176970863,NULL,'2024-03-23 15:03:04',NULL,NULL,NULL,NULL),(1711176970925,82001,'MIX3-1080x2340-82003-各种操作，记录 View Tree',1711176970800,1711176970864,NULL,'2024-03-24 14:30:56',NULL,NULL,NULL,NULL),(1711176970926,82001,'操作流程 2024年3月24日 22:36:50',1711176970801,1711176970865,NULL,'2024-03-24 14:36:52',NULL,NULL,NULL,NULL),(1711339030193,82001,'操作流程 2024年3月27日 15:28:12',1711339030051,1711339030127,NULL,'2024-03-27 07:28:19',NULL,NULL,NULL,NULL),(1711339030194,82001,'操作流程 2024年3月28日 11:56:08',1711339030052,1711339030128,NULL,'2024-03-28 03:56:11',NULL,NULL,NULL,NULL),(1711339030195,82001,'操作流程 2024年3月28日 12:11:42',1711339030053,1711339030129,NULL,'2024-03-28 04:11:44',NULL,NULL,NULL,NULL),(1712124114470,82001,'操作流程 Temp',0,0,NULL,'2024-04-03 06:01:54',NULL,NULL,NULL,NULL),(1712141507954,82001,'操作流程 Temp',0,0,NULL,'2024-04-03 10:51:47',NULL,NULL,NULL,NULL),(1712141511117,82001,'操作流程 Temp',0,0,NULL,'2024-04-03 10:51:51',NULL,NULL,NULL,NULL),(1712141511118,82002,'82003-各种滑动、弹窗、点击等',1712141510963,1712141511039,NULL,'2024-06-02 11:36:10',NULL,NULL,NULL,NULL),(1712141511119,82002,'82003 2024年6月3日 09:35:24',1712141510964,1712141511040,NULL,'2024-06-03 01:35:49',NULL,NULL,NULL,NULL),(1712141511120,82002,'82003-修改设置开关',1712141510965,1712141511041,NULL,'2024-06-03 11:57:24',NULL,NULL,NULL,NULL),(1712141511121,82002,'82003-扫描二维码',1712141510966,1712141511042,NULL,'2024-06-03 11:58:39',NULL,NULL,NULL,NULL),(1712141511122,82002,'82003-钱包 充值、提现',1712141510967,1712141511043,NULL,'2024-06-03 12:01:41',NULL,NULL,NULL,NULL),(1712141511123,82002,'82003-编辑用户资料',1712141510968,1712141511044,NULL,'2024-06-03 12:04:26',NULL,NULL,NULL,NULL),(1712141511124,82002,'82003-查看本人二维码',1712141510969,1712141511045,NULL,'2024-06-03 12:07:19',NULL,NULL,NULL,NULL),(1712141511125,82002,'82003-搜索用户列表、查看详情',1712141510970,1712141511046,NULL,'2024-06-03 12:09:28',NULL,NULL,NULL,NULL),(1712141511126,82002,'82003-各种弹窗',1712141510971,1712141511047,NULL,'2024-06-03 12:20:08',NULL,NULL,NULL,NULL),(1712141511127,82002,'操作流程 2024年6月8日 13:12:14',1712141510972,1712141511048,NULL,'2024-06-08 05:13:38',NULL,NULL,NULL,NULL),(1712141511128,82001,'各种弹窗、输入、滑动、点击等',1712141510973,1712141511049,NULL,'2024-06-09 08:14:38',NULL,NULL,NULL,NULL),(1712141511129,82001,'首页各种滑动和精确点击',1712141510974,1712141511050,NULL,'2024-06-09 17:04:52',NULL,NULL,NULL,NULL),(1712141511130,82001,'82003-首页精准滑动、点击',1712141510975,1712141511051,NULL,'2024-06-09 17:51:24',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Flow` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-16  0:37:19