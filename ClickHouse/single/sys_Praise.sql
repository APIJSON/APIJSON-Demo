
--
-- Table structure for table `Praise`
--

DROP TABLE IF EXISTS `Praise`;

CREATE TABLE `Praise` (
  `id` UInt64 COMMENT '动态id',
  `momentId` UInt64 COMMENT '唯一标识',
  `userId` UInt64 COMMENT '用户id',
  `date` DateTime DEFAULT now() COMMENT '点赞时间'
)ENGINE = MergeTree PRIMARY KEY id COMMENT '如果对Moment写安全要求高，可以将Moment内praiserUserIdList分离到Praise表中，作为userIdList。\n权限注解也改下：\n@MethodAccess(\n		PUT = {OWNER, ADMIN}\n		)\nclass Moment {\n       …\n}\n\n@MethodAccess(\n		PUT = {LOGIN, CONTACT, CIRCLE, OWNER, ADMIN}\n		)\n class Praise {\n       …\n }\n';;


--
-- Dumping data for table `Praise`
--

INSERT INTO `Praise` VALUES (1,12,82001,'2017-11-19 13:02:30'),(2,15,82002,'2017-11-19 13:02:30'),(3,32,82003,'2017-11-19 13:02:30'),(4,58,82004,'2017-11-19 13:02:30'),(5,170,82005,'2017-11-19 13:02:30'),(6,235,82006,'2017-11-19 13:02:30'),(7,301,82007,'2017-11-19 13:02:30'),(8,371,82008,'2017-11-19 13:02:30'),(9,470,82009,'2017-11-19 13:02:30'),(10,511,82010,'2017-11-19 13:02:30'),(11,543,82011,'2017-11-19 13:02:30'),(12,551,82012,'2017-11-19 13:02:30'),(13,594,82013,'2017-11-19 13:02:30'),(14,595,82014,'2017-11-19 13:02:30'),(15,704,82015,'2017-11-19 13:02:30'),(16,1491200468898,82016,'2017-11-19 13:02:30'),(17,1491277116776,82017,'2017-11-19 13:02:30'),(18,1493835799335,82018,'2017-11-19 13:02:30');


