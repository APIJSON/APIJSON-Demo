--
-- Table structure for table `Response`
--


DROP TABLE IF EXISTS `Response`;
CREATE TABLE `Response` (
  `id` UInt64 COMMENT '唯一标识',
  `method` String DEFAULT 'GET' COMMENT '方法',
  `model` String  COMMENT '表名，table是SQL关键词不能用',
  `structure` String COMMENT '结构',
  `detail` Nullable(String) COMMENT '详细说明',
  `date`  DateTime DEFAULT now() COMMENT '创建日期'
)ENGINE = MergeTree PRIMARY KEY id COMMENT '返回结果处理配置(目前未用上)\n每次启动服务器时加载整个表到内存。';


--
-- Dumping data for table `Response`
--

INSERT INTO `Response` VALUES (1,'GET','User','{\"put\": {\"extra\": \"Response works! Test:He(She) is lazy and wrote nothing here\"}, \"remove\": \"phone\"}',NULL,'2017-05-22 12:36:47'),(2,'DELETE','Comment','{\"remove\": \"Comment:child\"}',NULL,'2017-05-03 17:51:26'),(3,'DELETE','Moment','{\"remove\": \"Comment\"}',NULL,'2017-05-03 17:51:26');
