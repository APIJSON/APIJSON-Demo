--
-- Table structure for table `Test`
--
DROP TABLE IF EXISTS `Test`;
CREATE TABLE `Test` (
  `id` UInt64
)ENGINE = MergeTree PRIMARY KEY id COMMENT '测试及验证用的表，可以用 SELECT condition替代 SELECT * FROM Test WHERE condition，这样就不需要这张表了';

--
-- Dumping data for table `Test`
--

INSERT INTO `Test` VALUES (1);