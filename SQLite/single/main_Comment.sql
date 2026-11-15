# DROP TABLE IF EXISTS `Comment`;

CREATE TABLE `Comment` (
  `id` bigint,
  `toId` bigint,
  `userId` bigint,
  `momentId` bigint,
  `date` timestamp,
  `content` text
);


INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (4,0,38710,470,'2017-02-01 11:20:50','This is a Content...-4');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (13,0,82005,58,'2017-02-01 11:20:50','This is a Content...-13');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (22,221,82001,470,'2017-02-01 11:20:50','修改');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (44,0,82003,170,'2017-02-01 11:20:50','This is a Content...-44');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (45,0,93793,301,'2017-02-01 11:20:50','This is a Content...-45');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (47,4,70793,470,'2017-02-01 11:20:50','This is a Content...-47');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (51,45,82003,301,'2017-02-01 11:20:50','This is a Content...-51');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (54,0,82004,170,'2017-02-01 11:20:50','This is a Content...-54');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (68,0,82005,371,'2017-02-01 11:20:50','This is a Content...-68');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (76,45,93793,301,'2017-02-01 11:20:50','This is a Content...-76');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (77,13,93793,58,'2017-02-01 11:20:50','This is a Content...-77');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (97,13,82006,58,'2017-02-01 11:20:50','This is a Content...-97');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (99,44,70793,170,'2017-02-01 11:20:50','This is a Content...-99');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (110,0,93793,371,'2017-02-01 11:23:24','This is a Content...-110');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (114,0,82001,371,'2017-03-02 05:56:06','test multi put');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (115,0,38710,371,'2017-03-02 05:56:06','This is a Content...-115');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (116,0,70793,371,'2017-03-02 05:56:06','This is a Content...-116');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (120,0,93793,301,'2017-03-02 05:56:06','This is a Content...-110');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (124,0,82001,301,'2017-03-02 05:56:06','test multi put');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (157,0,93793,371,'2017-02-01 11:20:50','This is a Content...-157');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (158,0,93793,301,'2018-07-12 17:28:23','This is a Content...-157');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (160,0,82001,235,'2017-03-02 05:56:06','This is a Content...-160');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (162,0,93793,12,'2017-03-06 05:03:45','This is a Content...-162');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (163,0,82001,235,'2017-03-02 05:56:06','This is a Content...-163');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (164,0,93793,12,'2017-03-06 05:03:45','This is a Content...-164');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (167,0,82001,58,'2017-03-25 11:48:41','Nice!');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (168,1490442545077,82001,235,'2017-03-25 11:49:14','???');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (172,162,82001,12,'2017-03-25 12:22:58','OK');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (173,0,38710,58,'2017-03-25 12:25:13','Good');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (175,0,38710,12,'2017-03-25 12:26:53','Java is the best program language!');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (178,0,38710,511,'2017-03-25 12:30:55','wbw');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (182,110,82001,371,'2017-03-26 06:12:52','hahaha');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (188,97,82001,58,'2017-03-26 07:21:32','1646');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (190,0,82001,58,'2017-03-26 07:22:13','dbdj');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (206,54,82001,170,'2017-03-29 03:04:23','ejej');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (209,13,82001,58,'2017-03-29 03:05:59','hehj');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (300,97,82001,58,'2017-03-29 03:06:07','hj');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (301,194,82001,235,'2017-03-29 03:06:24','jj');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (4001,0,82001,58,'2017-03-29 08:39:52','I would like to say …');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490776944301,0,82001,58,'2017-03-29 08:42:24','hello');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490776966828,173,82001,58,'2017-03-29 08:42:46','me too');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490777905437,0,82001,543,'2017-03-29 08:58:25','rr');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490778122719,175,82001,12,'2017-03-29 09:02:02','Yeah! I think so!');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490778494751,1490778122719,82001,12,'2017-03-29 09:08:14','reply Android82001');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490778681337,166,82001,12,'2017-03-29 09:11:21','gg');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490780759866,99,82001,170,'2017-03-29 09:45:59','99');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781009548,51,82001,301,'2017-03-29 09:50:09','3');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781032005,45,82001,301,'2017-03-29 09:50:32','93793');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781817044,209,38710,58,'2017-03-29 10:03:37','82001');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781850893,1490776966828,38710,58,'2017-03-29 10:04:10','haha!');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781857242,190,38710,58,'2017-03-29 10:04:17','nice');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781865407,1490781857242,38710,58,'2017-03-29 10:04:25','wow');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490781899147,197,38710,12,'2017-03-29 10:04:59','kaka');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794439561,1490778681337,82001,12,'2017-03-29 13:33:59','gg?');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794610632,172,82001,12,'2017-03-29 13:36:50','All right');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794937137,1490794919957,82001,12,'2017-03-29 13:42:17','All right ok ok');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490794953438,1490794937137,82001,12,'2017-03-29 13:42:33','All right ok ok ll');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490796241178,0,38710,58,'2017-03-29 14:04:01','Anything else?');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490796629591,175,38710,12,'2017-03-29 14:10:29','well');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490798710678,110,38710,371,'2017-03-29 14:45:10','110');
INSERT INTO `Comment`(`id`, `toId`, `userId`, `momentId`, `date`, `content`) VALUES (1490800971064,175,38710,12,'2017-03-29 15:22:51','I do');
