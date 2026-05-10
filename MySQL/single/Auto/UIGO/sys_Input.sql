-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
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
-- Table structure for table `Input`
--

DROP TABLE IF EXISTS `Input`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Input` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `toId` bigint NOT NULL DEFAULT '0',
  `userId` bigint NOT NULL,
  `disable` tinyint NOT NULL DEFAULT '0',
  `step` int NOT NULL,
  `chainGroupId` bigint NOT NULL DEFAULT '0',
  `chainId` bigint NOT NULL DEFAULT '0',
  `flowId` bigint NOT NULL COMMENT '操作流程 id',
  `name` varchar(100) DEFAULT NULL,
  `tagName` varchar(100) DEFAULT NULL,
  `className` varchar(100) DEFAULT NULL,
  `viewType` varchar(200) DEFAULT NULL,
  `xpath` varchar(1000) DEFAULT NULL,
  `source` int NOT NULL DEFAULT '0' COMMENT '来源：手动触屏，自动触发，虚拟键盘，外置设备等',
  `deviceId` bigint NOT NULL DEFAULT '0' COMMENT '设备 id。这个和表 Device 的 id 不一样，它是 InputEvent 给的输入设备 id',
  `type` varchar(45) NOT NULL DEFAULT '0' COMMENT '输入事件类型： 0 - 触屏, 1 - 按键 KeyEvent, 2-界面切换, 3-HTTP',
  `jsType` varchar(45) DEFAULT NULL,
  `action` int NOT NULL DEFAULT '0' COMMENT '动作：当 type = 0 时： 0 - DOWN, 1 - MOVE, 2 - UP',
  `jsAction` varchar(45) DEFAULT NULL,
  `downTime` bigint NOT NULL DEFAULT '0',
  `eventTime` bigint NOT NULL DEFAULT '0',
  `keyName` varchar(45) DEFAULT NULL,
  `keyCode` int NOT NULL DEFAULT '0' COMMENT '当 type = 1 时：BACK, HOME, MENU, ENTER 等按键 KEY_CODE',
  `jsKeyCode` varchar(45) DEFAULT NULL,
  `x` double NOT NULL COMMENT 'X 坐标',
  `y` double NOT NULL COMMENT 'Y 坐标',
  `rawX` int DEFAULT NULL COMMENT 'X 坐标',
  `rawY` int DEFAULT NULL COMMENT 'Y 坐标',
  `x2` double DEFAULT NULL COMMENT '第二个手指 X 坐标',
  `y2` double DEFAULT NULL COMMENT '第二个手指 Y 坐标',
  `rawX2` int DEFAULT NULL COMMENT '第二个手指原始 X 坐标',
  `rawY2` int DEFAULT NULL COMMENT '第二个手指原始 Y 坐标',
  `splitX` double NOT NULL,
  `splitX2` double NOT NULL DEFAULT '0',
  `splitY` double NOT NULL,
  `splitY2` double NOT NULL DEFAULT '0',
  `top` double NOT NULL DEFAULT '0' COMMENT 'Activity 顶部高度。如果被状态栏顶下，则为状态栏高度；否则为 0。\\\\n因为这个可以在运行 App 时设备上动态调整，所以没有放到 Device 里。',
  `bottom` double NOT NULL DEFAULT '0' COMMENT 'Activity 底部高度。如果显示了底部虚拟导航栏，则为导航栏起始高度；否则为屏幕高度。\\\\n因为这个可以在运行 App 时设备上动态调整，所以没有放到 Device 里。',
  `time` bigint NOT NULL DEFAULT '0' COMMENT '创建时间',
  `orientation` tinyint NOT NULL DEFAULT '0' COMMENT '屏幕方向：0-纵向；1-横向',
  `windowX` double NOT NULL DEFAULT '0',
  `windowY` double NOT NULL DEFAULT '0',
  `windowWidth` double NOT NULL COMMENT 'X 坐标',
  `windowHeight` double NOT NULL COMMENT 'X 坐标',
  `decorX` double NOT NULL DEFAULT '0',
  `decorY` double NOT NULL DEFAULT '0',
  `decorWidth` double NOT NULL DEFAULT '0',
  `decorHeight` double NOT NULL DEFAULT '0',
  `statusHeight` double NOT NULL DEFAULT '0',
  `keyboardHeight` double NOT NULL DEFAULT '0' COMMENT '键盘高度',
  `navigationHeight` double NOT NULL DEFAULT '0',
  `contentX` double NOT NULL DEFAULT '0',
  `contentY` double NOT NULL DEFAULT '0',
  `contentWidth` double NOT NULL DEFAULT '0',
  `contentHeight` double NOT NULL DEFAULT '0',
  `pointerCount` int NOT NULL DEFAULT '1',
  `pointerIds` text,
  `pointers` json DEFAULT NULL,
  `metaState` int NOT NULL DEFAULT '0',
  `xPrecision` double NOT NULL DEFAULT '1',
  `yPrecision` double NOT NULL DEFAULT '1',
  `pressure` double NOT NULL DEFAULT '1',
  `size` double NOT NULL DEFAULT '1',
  `edgeFlags` int NOT NULL DEFAULT '0',
  `scanCode` int NOT NULL DEFAULT '0',
  `repeatCount` int NOT NULL DEFAULT '0',
  `flags` int NOT NULL DEFAULT '0',
  `activity` varchar(100) DEFAULT NULL,
  `fragment` varchar(100) DEFAULT NULL,
  `method` varchar(45) DEFAULT NULL,
  `format` varchar(45) DEFAULT NULL,
  `host` varchar(45) DEFAULT NULL,
  `url` varchar(1000) DEFAULT NULL,
  `query` text,
  `header` text,
  `request` text,
  `reqHeader` text,
  `status` varchar(100) DEFAULT NULL,
  `response` longtext,
  `resHeader` text,
  `compare` json DEFAULT NULL,
  `standard` text,
  `when` int DEFAULT NULL,
  `text` text,
  `hint` varchar(100) DEFAULT NULL,
  `start` int DEFAULT NULL,
  `length` int DEFAULT NULL,
  `after` int DEFAULT NULL,
  `edit` int DEFAULT NULL,
  `s` text,
  `target` text,
  `targetId` int DEFAULT NULL,
  `targetIdName` varchar(100) DEFAULT NULL,
  `targetWebId` varchar(100) DEFAULT NULL,
  `targetType` varchar(100) DEFAULT NULL,
  `childIndex` int DEFAULT NULL,
  `childCount` int DEFAULT NULL,
  `isSplit2Show` tinyint DEFAULT NULL,
  `gravityX` tinyint DEFAULT NULL,
  `gravityY` tinyint DEFAULT NULL,
  `gravityViewId` bigint DEFAULT NULL,
  `gravityViewIdName` varchar(200) DEFAULT NULL,
  `ballGravity` tinyint DEFAULT NULL,
  `ballGravity2` tinyint DEFAULT NULL,
  `focusId` int DEFAULT NULL,
  `focusIdName` varchar(100) DEFAULT NULL,
  `focusWebId` varchar(100) DEFAULT NULL,
  `focusType` varchar(100) DEFAULT NULL,
  `focusChildIndex` int DEFAULT NULL,
  `focusChildCount` int DEFAULT NULL,
  `parentId` int DEFAULT NULL,
  `parentIdName` varchar(100) DEFAULT NULL,
  `parentWebId` varchar(100) DEFAULT NULL,
  `parentType` varchar(100) DEFAULT NULL,
  `parentChildIndex` int DEFAULT NULL,
  `parentChildCount` int DEFAULT NULL,
  `timeout` bigint DEFAULT NULL COMMENT '等待超时时间',
  `fragmentX` double DEFAULT NULL,
  `fragmentY` double DEFAULT NULL,
  `fragmentWidth` double DEFAULT NULL,
  `fragmentHeight` double DEFAULT NULL,
  `dialog` varchar(100) DEFAULT NULL,
  `dialogX` double DEFAULT NULL,
  `dialogY` double DEFAULT NULL,
  `dialogWidth` double DEFAULT NULL,
  `dialogHeight` double DEFAULT NULL,
  `popupWindow` varchar(100) DEFAULT NULL,
  `textIndex` int DEFAULT NULL,
  `leftText` text,
  `rightText` text,
  `jsModifiers` json DEFAULT NULL,
  `uri` varchar(1000) DEFAULT NULL,
  `href` varchar(1000) DEFAULT NULL,
  `requestCode` int DEFAULT NULL,
  `resultCode` int DEFAULT NULL,
  `intent` json DEFAULT NULL,
  `package` varchar(100) DEFAULT NULL,
  `throw` varchar(100) DEFAULT NULL,
  `exception` varchar(1000) DEFAULT NULL,
  `routeParams` json DEFAULT NULL,
  `popupWindowX` double DEFAULT NULL,
  `popupWindowY` double DEFAULT NULL,
  `popupWindowWidth` double DEFAULT NULL,
  `popupWindowHeight` double DEFAULT NULL,
  `count` int DEFAULT NULL,
  `config` varchar(5000) DEFAULT NULL COMMENT '配置',
  `img` longtext,
  `file` varchar(200) DEFAULT NULL,
  `fileSize` bigint NOT NULL DEFAULT '0',
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `rank` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_time` (`time`),
  KEY `index_flowId` (`flowId`)
) ENGINE=InnoDB AUTO_INCREMENT=1711339086158 DEFAULT CHARSET=utf8mb3 COMMENT='输入事件，包括 屏幕触摸事件 MotionEvent, 按键事件 KeyEvent，界面切换, HTTP 请求';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11  6:54:41
