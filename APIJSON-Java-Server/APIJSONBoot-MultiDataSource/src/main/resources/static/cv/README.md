<h1 align="center" style="text-align:center;">
  CVAuto
</h1>
 
<p align="center">👁 <b>零代码零标注 CV AI 自动化测试平台</b> 🚀 <br><b>零代码快速自动化测试 CV 计算机视觉 AI 人工智能图像识别算法的功能、效果、性能</b><br>适合 算法 应用/开发 工程师/专家、算法测试 工程师/专家、AI/机器学习/算法 工程师/专家/研究员/科学家 等</p>

<p align="center" >
  <a href="https://deepwiki.com/TommyLemon/CVAuto">English</a>
  <a href="https://github.com/TommyLemon/CVAuto#%E5%BF%AB%E9%80%9F%E4%B8%8A%E6%89%8B">快速上手</a>
  <a href="https://search.bilibili.com/all?keyword=APIAuto">视频教程</a>
  <a href="http://apijson.cn:8080/cv/index.html">在线体验</a>
  <a href="https://deepwiki.com/TommyLemon/CVAuto">AI 问答</a>
</p>


---

**不用提前标注画框及标签**等作为 Ground Truth 这种工作量巨大的人工手动繁琐耗时操作， <br/>
**只需上传测试图片**，一键通过 HTTP API 调用算法模型得到推理后返回的 JSON 响应结果， <br/>
然后**自动在图上绘制** label 标签、box 画框、line 连线、point 关键点、polygon 多边形等， <br/>
**自动断言**画框是否正确，**可点边框附近来调整 ✓ 对 X 错**，一键上传可作为基准的本次结果， <br/>
**自动统计**正确数、误报数、漏检数、召回率、精准率、F1 Score 等指标，**自动对比前后效果**。 <br/>

![CVAuto-with-AIServer](https://github.com/user-attachments/assets/847bff1c-bd7d-4ac9-ad7c-7b95f2fa9850)

上图左侧是工具网页，右侧是模拟被测试的 YOLO 检测、姿态、分割 等算法模型 Python AI 推理服务；<br/>
左侧分别有 本次、对比差异、之前 的推理后画框及标签等渲染图，差异中的 + 表示新增，- 表示减少；<br/>
本次 所有框 和 差异所有 + 框 都可**点框附近把默认的 ✓ 改为 X 表示推理误报**，各指标会马上自动更新；<br/>
当前图片确认无误后，**点击 \[对的，纠正] 按钮来上传本次结果**，点击 总计指标 来切换显示 数量/百分比。<br/>
**在之前图片右上角输入实际目标数量**；中间图片列表顶部 **点右上角 + 批量上传图片**，**点左侧 ↻ 回归测试**。 <br/>

### 支持算法
* **目标检测**：行人、车辆、异物、零部件 等
* **物体分类**：车型、快递、鲜花、动植物 等
* **文本识别**：书籍、网页、车牌、包装盒 等
* **姿态估计**：舞蹈、体操、人机交互游戏 等
* **图像分割**：抠图、路人消除、背景替换 等
* **人脸识别**：根据脸部特征 识别出具体是谁
* **旋转校正**：对有直边的物体 校正歪斜角度

**本项目基于 机器学习零代码自动化接口工具 APIAuto 定制，原理和使用可参考相关文档及视频** 

### 演讲稿件
[APIAuto-机器学习 HTTP 接口工具](https://github.com/TommyLemon/StaticResources/tree/master/APIAuto/Share) <br />
[QECon 大会-腾讯 Tommy-零代码开发和测试](https://github.com/TommyLemon/StaticResources/tree/master/APIAuto/Share)

### 视频教程
Bilibili：https://search.bilibili.com/all?keyword=APIAuto
<img width="1020" alt="image" src="https://github.com/TommyLemon/APIAuto/assets/5738175/662603f2-75a2-4480-b329-faebf303a13d">

<br />
优酷：https://i.youku.com/i/UNTg1NzI1MjQ4MA==
<img width="1207" alt="image" src="https://github.com/TommyLemon/APIAuto/assets/5738175/11ff5315-23a2-4301-8b67-83fac0b7a369">


### 相关推荐
[别再生成测试代码了！](https://mp.weixin.qq.com/s/G1GVNhhFbSX5GoyRU6GURg) <br />
[APIAuto: 最先进的HTTP接口工具](https://blog.csdn.net/Nifc666/article/details/141966487)


### 百度、搜狗、抖音公网接口调用演示<br />
因为这些接口不支持 CORS 跨域，所以需要开启托管服务代理。<br />
可以复制 Chrome 等浏览器、Charles 等抓包工具的请求文本，<br />
粘贴到 CVAuto 的 URL 输入框，会自动填充 URL, JSON, Header 等。<br />
https://github.com/TommyLemon/APIAuto/issues/16 

#### 百度
![APIAuto_request_thirdparty_api_baidu](https://user-images.githubusercontent.com/5738175/154853951-558b9ce0-b8a5-4f35-a811-3c3fbee1235a.gif)

#### 搜狗
![APIAuto_request_sogou_api](https://user-images.githubusercontent.com/5738175/154854769-dbb0da94-ce59-41a9-8e79-f500c61e17b3.gif)

#### 抖音
![APIAuto_request_douyin_api](https://user-images.githubusercontent.com/5738175/154854538-d21f22cc-d9f1-4f84-ae2f-8e63bfd02f8f.gif)

<br />

**还可以参考视频：APIAuto 测试请求第三方 HTTP API** <br />
https://www.bilibili.com/video/BV1JZ4y1d7c8
![image](https://user-images.githubusercontent.com/5738175/160234764-a8e02ca4-1d0e-407b-8ac7-2f85c9f200d6.png)


<br/>

### 快速上手

本项目是纯静态 SPA 网页，下载源码解压后：<br />
可以用浏览器打开 index.html，建议用 [Chrome](https://www.google.com/intl/zh-CN/chrome) 或 [Firefox](https://www.mozilla.org/zh-CN/firefox) (Safari、Edge、IE 等可能有兼容问题)，注意此方法不显示 svg 图标。<br />
也可以用 [IntelliJ Webstorm](https://www.jetbrains.com/webstorm/), [IntelliJ IDEA](https://www.jetbrains.com/idea/), [Eclipse](https://www.eclipse.org/) 等 IDE 来打开。<br />
也可以部署到服务器并用 [Nginx](https://www.jianshu.com/p/11fa3a1a6d65) 或 [Node](https://segmentfault.com/a/1190000039744899) 反向代理，或者 [把源码放到 SpringBoot 项目的 resources/static 目录](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server)。 <br />
还可以直接访问官方网站 http://apijson.cn:8080/cv/index.html <br />
<br />
把左侧 URL 输入框内基地址改为图片推理预测服务地址(例如 http://localhost:5000 )，<br />
然后在右上角 设置 下拉菜单内修改 数据库类型Database、数据库模式Schema。<br />
<br />
右上角登录的默认管理员账号为 13000082005 密码为 123456，<br />
右侧上方中间 3 个标签是默认的测试用户账号，点击登录/退出，左侧 - 删除，右侧 + 新增。<br />
<br />

**图片推理预测服务接口 可使用贵公司已部署的，或者在你的电脑部署本项目示例推理服务 AIServer：** <br /> 
https://github.com/TommyLemon/CVAuto/tree/main/AIServer

**自动生成文档、自动管理测试用例 这两个功能 需要部署 APIJSON 后端，建议用 APIJSONBoot 系列之一 Demo，见** <br /> 
https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server

**建议使用已 [内置 CVAuto](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource/src/main/resources/static) 的 [APIJSONBoot-MultiDataSource](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource)，可以避免以下常见问题 1, 3, 4**

<br />

### 新增测试用例

可以使用以下几种方式：

#### 1.从 Postman/Swagger/YApi/Rap 等其它接口工具/平台一键导入
点右上角登录 > 点右上角设置 > 导入第三方文档(平台 URL) > 如果默认设置不符你的需求，可以在弹窗内修改 > 点上传按钮

#### 2.从浏览器 Network 接口信息界面或 Charles 等抓包工具复制后粘贴到 URL 输入框
https://github.com/TommyLemon/CVAuto#%E7%99%BE%E5%BA%A6%E6%90%9C%E7%8B%97%E6%8A%96%E9%9F%B3%E5%85%AC%E7%BD%91%E6%8E%A5%E5%8F%A3%E8%B0%83%E7%94%A8%E6%BC%94%E7%A4%BA

#### 3.调用 /delegate 代理接口来录制请求的方法、参数、Header、响应等信息
https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource#%E4%BB%A3%E7%90%86%E6%8E%A5%E5%8F%A3%E5%8F%8A%E5%BD%95%E5%88%B6%E6%B5%81%E9%87%8F

#### 4.打开分享链接来自动填充 URL、参数 JSON、请求头、图片参数配置、设置项 等
例如：
http://apijson.cn/api/?send=true&type=JSON&url=http%3A%2F%2Fapijson.cn%3A8080%2Fget&json={%22[]%22:{%22Comment%22:{},%22User%22:{%22id@%22:%22%2FComment%2FuserId%22}}}

#### 5.在界面手动填写 URL、参数 JSON、请求头 等再点击上传/分享按钮
可点击分享按钮生成分享链接，用浏览器打开即可自动填充。 <br />
退出登录后可设置 使用的请求类型，全部类型为 PARAM,JSON,FORM,DATA,GRPC 

<br />

### 后台 Headless 无 UI 模式回归测试
Jenkins、蓝盾 等 CI/CD 等流水线不支持带 UI 测试，所以提供了这个模式， <br />
通过调用 HTTP API 即可执行用例和查看进度，方便集成到 CI/CD 流水线。
![image](https://user-images.githubusercontent.com/5738175/199452068-dee4cbcb-ca4c-484a-8953-84b6bd238982.png)
![image](https://user-images.githubusercontent.com/5738175/199453742-b1e897f5-6950-40e2-8bfc-80b826966c6b.png)

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
链接 host 后可以加上 /api，例如 http://localhost:3000/api/test/start，<br />
通过这个接口来放宽前端执行时查询测试用例、参数配置等列表的条数，一次可批量执行更多用例。

<br /><br />

### 常见问题

**本网页工具基本每个按钮/输入框等 UI 组件都有注释或悬浮文档等形式的操作提示，<br />
很多问题都不需要看文档/视频，可以直接通过把光标放上去等简单尝试来得到解答**

#### 1.无法访问接口
如果是 CVAuto 本身调用的后端接口，则一般是 Chrome 90+ 对 CORS 请求禁止携带 Cookie  <br />
或 Chrome 80-89 强制 same-site Cookie 的策略导致，打开以下链接查看解决方法 <br />
https://github.com/TommyLemon/APIAuto/issues/9

如果是其它接口，则一般是以上原因或者被接口不支持 CORS 跨域，可以改为支持， <br />
或者在 CVAuto 右上角设置开启托管服务器代理，通过后端代理访问接口， <br />
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

更多问题及解答 <br />
https://github.com/TommyLemon/APIAuto/issues

<br />

### 感谢开源
* jsonon
* editor.md
* vue.js

### 技术交流
##### 关于作者
[https://github.com/TommyLemon](https://github.com/TommyLemon)<br />
![TommyLemon-GItHub](https://github.com/user-attachments/assets/4c2d9e75-01f7-4072-bed3-cfbd10076512)

如果有什么问题或建议可以 [去 APIAuto 提 issue](https://github.com/TommyLemon/APIAuto/issues)，交流技术，分享经验。<br >
如果你解决了某些 bug，或者新增了一些功能，欢迎 [提 PR 贡献代码](https://github.com/Tencent/APIJSON/blob/master/CONTRIBUTING.md)，感激不尽。
<br />
<br />

### 生态项目

[APIJSON](https://github.com/Tencent/APIJSON) 🏆 腾讯实时 零代码、全功能、强安全 ORM 库 🚀 后端接口和文档零代码，前端(客户端) 定制返回 JSON 的数据和结构

[APIAuto](https://github.com/TommyLemon/APIAuto) ☔ 敏捷开发最强大易用的接口工具，零代码测试与 AI 问答、生成代码与静态检查、生成文档与光标悬浮注释，腾讯、华为、SHEIN、传音、工行等使用

[UnitAuto](https://github.com/TommyLemon/UnitAuto) ☀️ 最先进、最省事、ROI 最高的单元测试，零代码、全方位、自动化 测试 方法/函数，用户包含腾讯、快手、某 500 强巨头等

[SQLAuto](https://github.com/TommyLemon/SQLAuto) 智能零代码自动化测试 SQL 数据库工具，任意增删改查、任意 SQL 模板变量、一键批量生成参数组合、快速构造大量测试数据

[UIGO](https://github.com/TommyLemon/UIGO) 📱 零代码快准稳 UI 智能录制回放平台 🚀 3 像素内自动精准定位，2 毫秒内自动精准等待，用户包含腾讯，微信团队邀请分享

### 持续更新
https://github.com/TommyLemon/CVAuto/commits

### 我要赞赏
**创作不易、坚持更难，右上角点亮 ⭐ Star 收藏/支持下本项目吧，谢谢 ^_^** <br />
https://github.com/TommyLemon/CVAuto


