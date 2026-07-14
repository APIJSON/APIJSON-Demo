DROP TABLE IF EXISTS `Document`;

CREATE TABLE `Document` (
  `id` bigint,
  `debug` tinyint,
  `from` tinyint,
  `userId` bigint,
  `project` varchar(100),
  `testAccountId` bigint,
  `version` tinyint,
  `group` varchar(45),
  `name` varchar(100),
  `operation` varchar(45),
  `method` varchar(7),
  `type` varchar(5),
  `url` varchar(250),
  `request` text,
  `apijson` text,
  `sqlauto` text,
  `standard` text,
  `header` text,
  `date` datetime,
  `path` varchar(45),
  `detail` text
);

LOCK TABLES `Document` WRITE;
INSERT INTO `Document` VALUES (2,0,0,82001,'APIJSON.cn',0,1,NULL,'注册(先获取验证码type:1)','REGISTER','POST','JSON','/register','{}',NULL,NULL,NULL,NULL,'2026-07-15 01:59:00.000',NULL,NULL);
UNLOCK TABLES;												