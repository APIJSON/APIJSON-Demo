DROP TABLE IF EXISTS `apijson_user`;

CREATE TABLE `apijson_user` (
  `id` bigint,
  `sex` tinyint,
  `name` varchar(20),
  `tag` varchar(45),
  `head` varchar(300),
  `contactIdList` json,
  `pictureList` json,
  `date` datetime
);

LOCK TABLES `apijson_user` WRITE;
INSERT INTO `apijson_user` VALUES (38710,0,'TommyLemon','Android&Java','https://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000','[82003, 82005, 90814, 82004, 82009, 82002, 82044, 93793, 70793]','[\"https://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000\", \"https://common.cnblogs.com/images/icon_weibo_24.png\"]','2017-02-01 11:21:50'),(70793,0,'Strong','djdj','https://static.oschina.net/uploads/user/585/1170143_50.jpg?t=1390226446000','[38710, 82002]','[\"https://static.oschina.net/uploads/img/201604/22172508_eGDi.jpg\", \"https://static.oschina.net/uploads/img/201604/22172507_rrZ5.jpg\", \"https://camo.githubusercontent.com/788c0a7e11a\", \"https://camo.githubusercontent.com/f513f67\"]','2017-02-01 11:21:50'),(82001,1,'Test User',NULL,'https://static.oschina.net/uploads/user/1/3064_50.jpg?t=1449566001000','[82034, 82005, 82030, 82046, 1493748615711, 82054, 82026, 82012]','[\"https://common.cnblogs.com/images/icon_weibo_24.png\"]','2017-02-01 11:21:50'),(82002,0,'Jan',NULL,'https://avatars.githubusercontent.com/u/41146037?v=4','[82001, 82003]','[]','2017-02-01 11:21:50'),(82003,0,'Wechat','Test','https://common.cnblogs.com/images/wechat.png','[93793, 82036]','[]','2017-02-01 11:21:50'),(82005,1,'CV Test','AG','https://avatars.githubusercontent.com/u/41146037?v=4','[82001, 1532439021068]','[]','2017-02-01 11:21:50'),(82012,0,'Steve','FEWE','https://static.oschina.net/uploads/user/1/3064_50.jpg?t=1449566001000','[82004, 82002, 93793]','[]','2017-02-01 11:21:50'),(82020,0,'ORANGE',NULL,'https://static.oschina.net/uploads/user/48/96289_50.jpg?t=1452751699000','[]','[]','2017-02-01 11:21:50'),(82021,1,'Tommy',NULL,'https://static.oschina.net/uploads/user/19/39085_50.jpg','[]','[]','2017-02-01 11:21:50'),(82022,0,'Internet',NULL,'https://static.oschina.net/uploads/user/1332/2664107_50.jpg?t=1457405500000','[]','[]','2017-02-01 11:21:50'),(82023,0,'No1',NULL,'https://static.oschina.net/uploads/user/1385/2770216_50.jpg?t=1464405516000','[]','[]','2017-02-01 11:21:50'),(82024,0,'Lemon',NULL,'https://static.oschina.net/uploads/user/427/855532_50.jpg?t=1435030876000','[]','[]','2017-02-01 11:21:50');
UNLOCK TABLES;