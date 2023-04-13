# APIJSONBoot

APIJSON + SpringBoot 接近成品的 Demo

### 运行

右键 DemoApplication > Run As > Java Application

### 自定义 API 的说明（非 APIJSON 万能 API）
https://github.com/xlongwei/light4j/tree/master/apijson#apijson%E8%B4%A6%E6%88%B7%E7%AE%A1%E7%90%86

### 代理接口及录制流量
可使用 /delegate 接口来实现代理，解决 [前端 CORS 跨域问题](https://github.com/TommyLemon/APIAuto/issues/9)。 <br />
还可以使用这个接口来录制流量，导入到 Document/Method/Random 及 TestRecord 表，<br />
https://github.com/APIJSON/APIJSON-Demo/blob/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource/src/main/java/apijson/boot/DemoController.java#L1188-L1641

然后使用 APIAuto/UnitAuto/SQLAuto 来测试：<br />

[APIAuto](https://github.com/TommyLemon/APIAuto) 敏捷开发最强大易用的接口工具，机器学习零代码测试、生成代码与静态检查、生成文档与光标悬浮注释

[UnitAuto](https://github.com/TommyLemon/UnitAuto) 机器学习零代码单元测试平台，零代码、全方位、自动化 测试 方法/函数 的正确性、可用性和性能

[SQLAuto](https://github.com/TommyLemon/SQLAuto) 智能零代码自动化测试 SQL 语句执行结果的数据库工具，一键批量生成参数组合、快速构造大量测试数据

如果原本就有一些使用 <br />
C/C++/C#/Go/Groovy/Java/JavaScript/Kotlin/Lua/Objective-C/PHP/Python/Rust/Scala/Swift/TypeScript <br />
等语言编写的 接口/单元/数据库 测试用例，<br />
可以在测试代码中调用 /delegate 接口来录制流量，<br />
生成 APIAuto/UnitAuto/SQLAuto 的对应测试用例：<br />
```
{HTTP Method 请求方法，根据实际调用接口来使用对应的 GET, POST, PUT, DELETE, HEAD, PATCH, OPTIONS, TRACE} /delegate
?$_record={录制类型，方便生成 APIAuto/UnitAuto/SQLAuto 文档，流量回放等：0-不录制；1-API；2-Unit；3-SQL}
&$_type={请求类型，可填 PARAM, JSON, FORM, DATA, GRPC}
&$_delegate_id={代理 ID，从本接口返回的 Response Header 中取 Apijson-Delegate-Id，用来关联代理服务保存的 Cookie，解决浏览器不允许传 Cookie 导致登录失效等问题}
&$_delegate_url={必填，实际被调用 URL，例如 http://apijson.cn:8080/get/User ，建议 encodeURIComponent 转义来避免特 & 等殊字符导致出错}
&$_headers={请求头，以换行分隔每个头的键值对，且键值对格式为 key: value ，建议 encodeURIComponent 转义来避免特 & 等殊字符导致出错}
&$_except_headers={排除请求头，格式和 $_headers 一样，如果 $_headers 未传，则通过 浏览器/接口工具 等发出的请求头 来排除指定请求头}
```
例如
```
POST /delegate?$_record=1&$_type=JSON&$_delegate_id=FEA2B2AE5ACE68C5557B127B57CEFB38&$_delegate_url=http%3A%2F%2Fapijson.cn%3A8080%2Fget%2FUser&$_headers=token%3A%20%20test%0AContent-Type%3A%20%20application%2Fjson
```
```json
{
   "id": 82001
}
```
