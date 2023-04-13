# APIJSONBoot

APIJSON + SpringBoot 接近成品的 Demo

### 运行

右键 DemoApplication > Run As > Java Application

### 自定义 API 的说明（非 APIJSON 万能 API）
https://github.com/xlongwei/light4j/tree/master/apijson#apijson%E8%B4%A6%E6%88%B7%E7%AE%A1%E7%90%86

### 代理接口及录制流量
可使用 /delegate 接口来实现代理，解决 [前端 CORS 跨域问题](https://github.com/TommyLemon/APIAuto/issues/9)。 <br />
还可以使用这个接口来录制流量，导入到 Document/Method 及 TestRecord 表，<br />
https://github.com/APIJSON/APIJSON-Demo/blob/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource/src/main/java/apijson/boot/DemoController.java#L1188-L1641

然后使用 APIAuto/UnitAuto/SQLAuto 来测试：<br />

[APIAuto](https://github.com/TommyLemon/APIAuto) 敏捷开发最强大易用的接口工具，机器学习零代码测试、生成代码与静态检查、生成文档与光标悬浮注释

[UnitAuto](https://github.com/TommyLemon/UnitAuto) 机器学习零代码单元测试平台，零代码、全方位、自动化 测试 方法/函数 的正确性、可用性和性能

[SQLAuto](https://github.com/TommyLemon/SQLAuto) 智能零代码自动化测试 SQL 语句执行结果的数据库工具，一键批量生成参数组合、快速构造大量测试数据
