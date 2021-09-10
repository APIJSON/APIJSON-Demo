--
-- Table structure for table `_Visit`
--

DROP TABLE IF EXISTS `_Visit`;
CREATE TABLE `_Visit` (
  `model` String ,
  `id` UInt64,
  `operate` UInt64 COMMENT '1-增\n2-删\n3-改\n4-查',
  `date` DateTime DEFAULT now()
)ENGINE = MergeTree PRIMARY KEY id;

