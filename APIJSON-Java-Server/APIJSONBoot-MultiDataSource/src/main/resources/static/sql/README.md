<h1 align="center" style="text-align:center;">
  SQLAuto
</h1>
 
<p align="center">☔ 智能零代码测试 SQL、任意增删改查、任意 SQL 模板变量、一键批量生成参数组合、快速构造大量测试数据。<br />用户包含 某市值 4000亿+ 500 强巨头、某营收数十亿企业、某热门数据库创业公司 等多家大中小企业。</p>


<p align="center" >
  <a href="https://github.com/TommyLemon/SQLAuto#%E5%BF%AB%E9%80%9F%E4%B8%8A%E6%89%8B">快速上手</a>
  <a href="https://space.bilibili.com/437134249/search/video?keyword=apiauto">视频教程</a>
  <a href="http://apijson.cn/sql">在线体验</a>
</p>

<img width="1440" alt="018AD342-6A7B-4D4E-ACC2-523196580221" src="https://user-images.githubusercontent.com/5738175/189524723-a178d4e8-c2ef-4adb-ac0a-9d4b627f42ad.png">
<img width="1440" alt="20E6AE40-DEC5-42A7-8978-6BA1C286FB9B" src="https://user-images.githubusercontent.com/5738175/189524745-06f26fa2-f5de-46a2-9811-a7e2690aa184.png">
<img width="1440" alt="8A127392-68FB-44A8-94A3-2EC6E629ED6D" src="https://user-images.githubusercontent.com/5738175/189524751-d780b050-b52b-4f97-9fff-d424eb47ad6f.png">
<img width="1440" alt="60F7F4E4-D0B7-44E1-8692-B24CB56D973A" src="https://user-images.githubusercontent.com/5738175/189524755-a6c109f1-9bfd-4a34-bded-21f0a55bd7fb.png">
<img width="1440" alt="79387E13-179C-4F16-9620-427AD9C526F9" src="https://user-images.githubusercontent.com/5738175/189524759-8c7b4ab8-1869-4304-b9f0-bc14c086b3f4.png">
<img width="1440" alt="6298F2D3-7894-4CEE-BDE1-5B8936DB0C90" src="https://user-images.githubusercontent.com/5738175/189524763-3cd43452-54b5-41a6-bcb6-9ff440e4fa42.png">
<img width="1440" alt="C6B0366D-DAEF-4C60-BCBB-70751E3832C6" src="https://user-images.githubusercontent.com/5738175/189524769-143fdfd0-eae2-43f7-92e7-87a241ee654b.png">
<img width="1440" alt="A7DEBE5A-8CBD-4B5F-AF1C-CC0CA5EE6F39" src="https://user-images.githubusercontent.com/5738175/189524772-d2068268-2cb2-479b-b9c0-373c18acce43.png">
<img width="1440" alt="018AD342-6A7B-4D4E-ACC2-523196580221" src="https://user-images.githubusercontent.com/5738175/189524723-a178d4e8-c2ef-4adb-ac0a-9d4b627f42ad.png">

如果 SQL 语句是 INSERT 插入语句，则可以快速生成 1000+ 条测试数据(表记录)，方便前后端联调接口，可按规则生成。
例如 
```sql
INSERT INTO sys.apijson_user(id, sex, name) VALUES(${id}, ${sex}, ${name})
```
1000 次参数注入 Random Test：
```js
id: new Date().getTime()  // 当前时间毫秒值
sex: RANDOM_IN(0, 1)  // 随机从 0, 1 中取值
name: 'Test ' + new Date().toLocaleTimeString()  // 通过代码自定义
```

<br />

### 快速上手

**本项目前端工具是基于 [APIAuto](https://github.com/TommyLemon/APIAuto) 改造的纯静态 SPA 网页，下载源码解压后：** <br />
可以用浏览器打开 index.html，建议用 [Chrome](https://www.google.com/intl/zh-CN/chrome) 或 [Firefox](https://www.mozilla.org/zh-CN/firefox) (Safari、Edge、IE 等可能有兼容问题)，注意此方法不显示 svg 图标。<br />
也可以用 [IntelIJ Webstorm](https://www.jetbrains.com/webstorm/), [IntelliJ IDEA](https://www.jetbrains.com/idea/), [Eclipse](https://www.eclipse.org/) 等 IDE 来打开。<br />
也可以部署到服务器并用 [Nginx](https://www.jianshu.com/p/11fa3a1a6d65) 或 [Node](https://segmentfault.com/a/1190000039744899) 反向代理，或者 [把源码放到 SpringBoot 项目的 resources/static 目录](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server)。 <br />
还可以直接访问官方网站 http://apijson.cn/sql <br />
<br />
把左侧 URI 输入框内基地址改为你自己的数据库的连接地址(例如 jdbc:mysql://localhost:3306/sys )，<br />
然后在右上角 设置 下拉菜单内修改 数据库类型Database、数据库模式Schema。<br />
<br />
右上角登录的默认管理员账号为 13000082003 密码为 123456，<br />
右侧上方中间 3 个标签是默认的测试用户账号，点击登录/退出，左侧 - 删除，右侧 + 新增。<br />
<br />

**后端需要部署 APIJSON-Demo 5.2.5+ 的 APIJSONBoot-MultiDataSource** <br /> 
DemoSQLConfig<T, M, L> 改下 getDBAccount, getDBUri 等返回值，具体见 <br /> 
https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server

<br />

### 新增测试用例
可以使用以下几种方式：
#### 1.点击右侧数据字典文档表名后面的 SELECT INSERT UPDATE DELETE 来生成左侧 SQL 语句
http://apijson.cn/sql

#### 2.调用 /delegate 代理接口来录制请求的方法、参数、响应等信息
https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource#%E4%BB%A3%E7%90%86%E6%8E%A5%E5%8F%A3%E5%8F%8A%E5%BD%95%E5%88%B6%E6%B5%81%E9%87%8F

#### 3.打开分享链接来自动填充 数据库 URI、SQL 语句、预编译参数、设置项 等
例如：
http://apijson.cn/sql/?send=true&type=JSON&url=jdbc%3Amysql%3A%2F%2Flocalhost%3A3306%2Fsys&json=SELECT%20*%20FROM%20Comment%20LIMIT%2010&header=

#### 4.在界面手动填写 数据库 URI、SQL 语句、预编译参数 等再点击上传/分享按钮
可点击分享按钮生成分享链接，用浏览器打开即可自动填充。

<br />

### 后台 Headless 无 UI 模式回归测试
Jenkins、蓝盾 等 CI/CD 等流水线不支持带 UI 测试，所以提供了这个模式， <br />
通过调用 HTTP API 即可执行用例和查看进度，方便集成到 CI/CD 流水线。
![image](https://user-images.githubusercontent.com/5738175/199454264-b60de80d-ced0-4fbb-b531-366252697924.png)
![image](https://user-images.githubusercontent.com/5738175/199454455-6ce807bd-e3a6-4664-baa2-8db96f6fa765.png)

#### 1.配置 Node 环境及 NPM 包管理工具
https://nodejs.org

#### 2.安装相关依赖
https://koajs.com
```sh
nvm install 7
npm i koa
```

#### 3.使用后台 HTTP 服务
先启动 HTTP 服务
```sh
cd js
node server.js
```
如果运行报错 missing package xxx，说明缺少相关依赖，参考步骤 2 来执行
```sh
npm i xxx
```
然后再启动 HTTP 服务。<br />

启动成功后会有提示，点击链接或者复制到浏览器输入框打开即可。<br /><br />
如果托管服务是用 [APIJSONBoot-MultiDataSource](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource) 部署的，<br />
链接 host 后可以加上 /sql，例如 http://localhost:3002/sql/test/start <br />
通过这个接口来放宽前端执行时查询测试用例、参数配置等列表的条数，一次可批量执行更多用例。

<br /><br />

### 常见问题

**本网页工具基本每个按钮/输入框等 UI 组件都有注释或悬浮文档等形式的操作提示，<br />
很多问题都不需要看文档/视频，可以直接通过把光标放上去等简单尝试来得到解答**

#### 1.无法访问接口
如果是 SQLAuto 本身调用的后端接口，则一般是 Chrome 90+ 对 CORS 请求禁止携带 Cookie  <br />
或 Chrome 80-89 强制 same-site Cookie 的策略导致，打开以下链接查看解决方法 <br />
https://github.com/TommyLemon/APIAuto/issues/9

如果是其它接口，则一般是以上原因或者被接口不支持 CORS 跨域，可以改为支持， <br />
或者在 SQLAuto 右上角设置开启托管服务器代理，通过后端代理访问接口， <br />
注意默认是官网的托管服务器 http://apijson.cn:8080 ，仅支持公网， <br />
如果是贵公司内网，请按以上 [部署方法](https://github.com/TommyLemon/APIAuto#%E9%83%A8%E7%BD%B2%E6%96%B9%E6%B3%95) 文档来部署 APIJSON 后端到内网，并修改托管服务器地址。

#### 2.没有生成文档
右上角设置项与数据库实际配置不一致 等  <br />
https://github.com/Tencent/APIJSON/issues/85

#### 3.托管服务器访问不了
不能代理接口、不能展示文档、不能对断言结果纠错 等 <br />
https://github.com/TommyLemon/APIAuto/issues/12

#### 4.apijson.cn 访问不了
托管服务地址改为 http://47.98.196.224:8080  <br />
https://github.com/TommyLemon/APIAuto/issues/13

更多常见问题 <br />
https://github.com/TommyLemon/APIAuto/issues

<br />

### 感谢开源
* jsonon
* editor.md
* vue.js

### 技术交流
##### 关于作者
[https://github.com/TommyLemon](https://github.com/TommyLemon)<br />
<img width="1280" src="https://github.com/TommyLemon/UIGO/assets/5738175/ec77df98-ff9b-43aa-b2f1-2fce2549d276">

如果有什么问题或建议可以 [去 APIAuto 提 issue](https://github.com/TommyLemon/APIAuto/issues)，交流技术，分享经验。<br >
如果你解决了某些 bug，或者新增了一些功能，欢迎 [提 PR 贡献代码](https://github.com/Tencent/APIJSON/blob/master/CONTRIBUTING.md)，感激不尽。
<br />
<br />

### 其它项目

[APIJSON](https://github.com/Tencent/APIJSON) 🚀 腾讯零代码、全功能、强安全 ORM 库 🏆 后端接口和文档零代码，前端(客户端) 定制返回 JSON 的数据和结构

[APIAuto](https://github.com/TommyLemon/APIAuto) 敏捷开发最强大易用的 HTTP 接口工具，机器学习零代码测试、生成代码与静态检查、生成文档与光标悬浮注释，集 文档、测试、Mock、调试、管理 于一体的一站式体验

[UnitAuto](https://github.com/TommyLemon/UnitAuto) 机器学习单元测试平台，零代码、全方位、自动化 测试 方法/函数 的正确性和可用性

[UIGO](https://github.com/TommyLemon/UIGO) 📱 零代码快准稳 UI 智能录制回放平台 🚀 自动兼容任意宽高比分辨率屏幕，自动精准等待网络请求，录制回放快、准、稳！

[apijson-doc](https://github.com/vincentCheng/apijson-doc) APIJSON 官方文档，提供排版清晰、搜索方便的文档内容展示，包括设计规范、图文教程等

[APIJSONdocs](https://github.com/ruoranw/APIJSONdocs) APIJSON 英文文档，提供排版清晰的文档内容展示，包括详细介绍、设计规范、使用方式等

[apijson.org](https://github.com/APIJSON/apijson.org) APIJSON 官方网站，提供 APIJSON 的 功能简介、登记用户、作者与贡献者、相关链接 等

[APIJSON.NET](https://github.com/liaozb/APIJSON.NET) C# 版 APIJSON ，支持 MySQL, PostgreSQL, SQL Server, Oracle, SQLite

[apijson-go](https://github.com/glennliao/apijson-go) Go 版 APIJSON ， 基于Go(>=1.18) + GoFrame2, 支持查询、单表增删改、权限管理等
  
[apijson-go](https://gitee.com/tiangao/apijson-go) Go 版 APIJSON ，支持单表查询、数组查询、多表一对一关联查询、多表一对多关联查询 等

[apijson-hyperf](https://github.com/kvnZero/hyperf-APIJSON.git) PHP 版 APIJSON，基于 Hyperf 支持 MySQL

[APIJSON-php](https://github.com/xianglong111/APIJSON-php) PHP 版 APIJSON，基于 ThinkPHP，支持 MySQL, PostgreSQL, SQL Server, Oracle 等

[apijson-php](https://github.com/qq547057827/apijson-php) PHP 版 APIJSON，基于 ThinkPHP，支持 MySQL, PostgreSQL, SQL Server, Oracle 等

[apijson-node](https://github.com/kevinaskin/apijson-node) 字节跳动工程师开源的 Node.ts 版 APIJSON，提供 nestjs 和 typeorm 的 Demo 及后台管理

[uliweb-apijson](https://github.com/zhangchunlin/uliweb-apijson) Python 版 APIJSON，支持 MySQL, PostgreSQL, SQL Server, Oracle, SQLite 等

[apijson-practice](https://github.com/vcoolwind/apijson-practice) BAT 技术专家开源的 APIJSON 参数校验注解 Library 及相关 Demo

[Android-ZBLibrary](https://github.com/TommyLemon/Android-ZBLibrary) Android MVP 快速开发框架，Demo 全面，注释详细，使用简单，代码严谨

### 持续更新
https://github.com/TommyLemon/SQLAuto/commits/master


### 我要赞赏
创作不易，右上角点 ⭐Star 支持下本项目吧，谢谢 ^_^ <br />
https://gitee.com/TommyLemon/SQLAuto
