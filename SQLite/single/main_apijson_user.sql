CREATE TABLE `apijson_user` (
  `id` bigint,
  `sex` integer,
  `name` text,
  `tag` text,
  `head` text,
  `contactIdList` text,
  `pictureList` text,
  `date` timestamp
);

INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (38710,0,'TommyLemon','Android&Java','https://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000','[82003, 82005, 90814, 82004, 82009, 82002, 82044, 93793, 70793]','[\"https://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000\", \"https://common.cnblogs.com/images/icon_weibo_24.png\"]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (70793,0,'Strong','djdj','https://static.oschina.net/uploads/user/585/1170143_50.jpg?t=1390226446000','[38710, 82002]','[\"https://static.oschina.net/uploads/img/201604/22172508_eGDi.jpg\", \"https://static.oschina.net/uploads/img/201604/22172507_rrZ5.jpg\", \"https://camo.githubusercontent.com/788c0a7e11a\", \"https://camo.githubusercontent.com/f513f67\"]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (82001,1,'Test User','dev','https://static.oschina.net/uploads/user/1174/2348263_50.png?t=1439773471000','[82034, 82005, 82030, 82046, 1493748615711, 38710, 82054, 82002]','[\"https://common.cnblogs.com/images/icon_weibo_24.png\"]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (82002,1,'Jan','iOS','https://static.oschina.net/uploads/user/1174/2348263_50.png?t=1439773471000','[82005, 38710]','[]','2017-02-01 11:21:50'),(82003,0,'Wechat','test','https://common.cnblogs.com/images/wechat.png','[93793]','[]','2017-02-01 11:21:50');
INSERT INTO `apijson_user`(`id`, `sex`, `name`, `tag`, `head`, `contactIdList`, `pictureList`, `date`) VALUES (82004,0,'Tommy','fasef','https://static.oschina.net/uploads/user/1200/2400261_50.png?t=1439638750000','[]','[]','2017-02-01 11:21:50'),(82005,1,'Jan','AG','https://avatars.githubusercontent.com/u/41146037?v=4','[82001, 38710, 1532439021068]','[]','2017-02-01 11:21:50');
