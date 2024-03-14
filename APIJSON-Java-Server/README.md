[English](https://github.com/APIJSON/APIJSON-Demo/blob/master/APIJSON-Java-Server/README-English.md)

# APIJSON后端上手 - Java
### JDBC Demo：
[APIJSONDemo](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo) 为 APIJSON + SpringBoot + MySQL + PostgreSQL 的最简单的初级使用 Demo，通过 DemoSQLConfig 代码配置数据库； <br />
[APIJSONBoot](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot) 为 APIJSON + SpringBoot + MySQL + PostgreSQL + SQLServer + TDengine 的接近生产环境成品的 Demo，通过 DemoSQLConfig 代码配置数据库； <br />
[APIJSONFinal](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONFinal) 为 APIJSON + JFinal + MySQL + PostgreSQL  的接近生产环境成品的 Demo，通过 DemoSQLConfig 代码配置数据库； <br />
[APIJSONSimpleDemo-SpringBoot3](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONSimpleDemo-SpringBoot3) 为 APIJSON + SpringBoot3 + HikariCP + MySQL 的复杂度介于 APIJSONBoot 和 APIJSONDemo 之间的 Demo，完成了一些常用配置，包括简单鉴权、多数据源等，通过 application.yml 文件配置数据库； <br />

### 连接池 Demo
[APIJSONDemo-Druid](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-Druid) 为 APIJSON + SpringBoot + Druid + MySQL + PostgreSQL 的简单初级使用 Demo，通过 application.yml 文件配置数据库； <br />
[APIJSONDemo-HikariCP](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-HikariCP) 为 APIJSON + SpringBoot + HikariCP + MySQL + PostgreSQL 的简单初级使用 Demo，通过 application.yml 文件配置数据库； <br />
[APIJSONBoot-MultiDataSource](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource) 为 APIJSON + SpringBoot + Druid + HikariCP + Redis + PostgreSQL + SQLServer + TDengine + 达梦 的接近生产环境成品的多数据源 Demo， <br />
通过 application.yml 文件配置数据库，并且把 [APIAuto](https://github.com/TommyLemon/APIAuto) 的源码放到了 [src/main/resources/static](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource/src/main/resources/static) 目录，可以用浏览器打开本地主页 http://localhost:8080 来调试。 <br />

### 分库分表 Demo
[APIJSONDemo-ShardingSphere](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-ShardingSphere) 为 APIJSON + SpringBoot + ShardingSphere + MySQL + PostgreSQL 的简单初级使用 Demo，通过 application.yml, application-sharding-databases.properties 等 文件配置数据库。 <br />

### 大数据与 OLAP 的 Demo
[APIJSONDemo-Presto](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-Presto) 为 APIJSON + SpringBoot + Presto 的最简单的初级使用 Demo； <br />
[APIJSONDemo-Elasticsearch](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-Elasticsearch) 为 APIJSON + SpringBoot + Elasticsearch 的最简单的初级使用 Demo； <br />
[APIJSONDemo-MultiDataSource-Elasticsearch](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-MultiDataSource-Elasticsearch) 为 APIJSON + SpringBoot + Elasticsearch 的最简单的初级使用 Demo； <br />
[APIJSONBoot-BigData](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-BigData) 为 APIJSON + SpringBoot + Presto + Trino + Elasticsearch 等的接近生产环境成品的 Demo。 <br />

### 缓存 Demo
[APIJSONDemo-Redis](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-Redis) 为 APIJSON + SpringBoot + MySQL + Redis 的最简单的初级使用 Demo； <br />
[APIJSONBoot-MultiDataSource](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource) 为 APIJSON + SpringBoot + Druid + HikariCP + Redis + PostgreSQL + SQLServer + TDengine + 达梦 的接近生产环境成品的多数据源 Demo。 <br />

### 消息队列 Demo
[APIJSONDemo-MultiDataSource-Kafka](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-MultiDataSource-Kafka) 为 APIJSON + SpringBoot + MySQL + Kafka 的最简单的初级使用 Demo。 <br />

### 动态脚本 Demo
[APIJSONDemo-Script](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-Script) 为 APIJSON + SpringBoot + MySQL + JavaScript + Lua 的最简单的初级使用 Demo。 <br />

<br />

**其中 APIJSONDemo 系列 [关闭了权限校验](https://github.com/APIJSON/APIJSON-Demo/blob/master/APIJSON-Java-Server/APIJSONDemo/src/main/java/apijson/demo/DemoController.java#L52-L54) ，不需要配置权限即可体验 /get 这个万能查询接口。<br />
新手建议先从 APIJSONDemo 入手体验，然后再转用 APIJSONBoot/APIJSONFinal。**

Oracle, SQLServer 的 JDBC 驱动用了 GPL 类协议，所以示例项目的 pom.xml 都没有加它们的 Maven 依赖，需要自己加。<br />
<br />
以下简要地说明了上手步骤，也可以看 [图文入门教程](https://github.com/Tencent/APIJSON/blob/master/%E8%AF%A6%E7%BB%86%E7%9A%84%E8%AF%B4%E6%98%8E%E6%96%87%E6%A1%A3.md) 或 [视频入门教程](https://space.bilibili.com/39652511)


#### 用现成的开箱即用 jar包 极速部署 见
https://github.com/TommyLemon/StaticResources/tree/master/APIJSONServer
<br />
<br />

### 1.下载后解压APIJSON-Demo工程

[打开APIJSON-Demo的GitHub主页](https://github.com/APIJSON/APIJSON-Demo) &gt; Clone or download &gt; [Download ZIP](https://github.com/APIJSON/APIJSON-Demo/archive/master.zip) &gt; 解压到一个路径并记住这个路径。


<br />

### 2.导入表文件到数据库<h3/>

后端需要MySQL Server和MySQLWorkbench，没有安装的都先下载安装一个。<br />
我的配置是Windows 7 + MySQL Community Server 5.7.16 + MySQLWorkbench 6.3.7 和 OSX EI Capitan + MySQL Community Server 5.7.16 + MySQLWorkbench 6.3.8 + Postgre 2.1.5，其中系统和软件都是64位的。

#### 使用 Navicat
启动Navicat &gt; 双击 localhost &gt; 双击 postgres &gt; 右键 postgres &gt; <br /> 如果没有 sys 模式则先右键新建一个 &gt; 运行 SQL 文件 &gt; 根据你使用的数据库类型来选择刚才解压路径下的 APIJSON-Demo-Master 里的 MySQL/PostgreSQL/Oracle 等 <br />
&gt; 开始 &gt; 右键 postgres 里的 sys &gt; 刷新， sys/表 会出现添加的表。

#### 使用 MySQLWorkbench（仅限MySQL）
启动MySQLWorkbench &gt; 进入一个Connection &gt; 如果没有 sys Schema则先右键新建一个 &gt; 点击Server菜单 &gt; Data Import &gt; 选择刚才解压路径下的APIJSON-Demo-Master/MySQL &gt; Start Import &gt; 刷新SCHEMAS， 左下方 sys/tables 会出现添加的表。

配置你自己的表请参考：
[3步创建APIJSON后端新表及配置](https://my.oschina.net/tommylemon/blog/889074)

<br />

### 3.用 IntellIJ IDEA Ultimate 或 Eclipse for JavaEE 运行后端工程

如果以上编辑器一个都没安装，运行前先下载安装一个。<br />
我的配置是 Windows 7 + JDK 1.7.0_71 + IntellIJ 2016.3 + Eclipse 4.6.1 和 OSX EI Capitan + JDK 1.8.0_91 + IntellIJ 2016.2.5 + Eclipse 4.6.1


#### IntellIJ IDEA Ultimate

<h5>1)打开项目</h5>
Open > 选择刚才解压路径下的 APIJSON-Demo-Master/APIJSON-Java-Server 里面的 APIJSONDemo(简单Demo) 或 APIJSONBoot(实际项目) > OK

<h5>2)配置依赖库 </h5>
其中 apijson-orm, apijson-framework 默认使用 Maven 远程依赖仓库，等待自动下载完成， <br />
具体见 https://github.com/APIJSON/apijson-orm 和 https://github.com/APIJSON/apijson-framework <br />
如果依赖下载不了，注释掉报错的 apijson-orm, apijson-framework 依赖代码， <br />
然后右键 libs (APIJSONBoot 内，其它项目需要拷贝过去)里面的 apijson-orm.jar > Add as Library > OK <br />
同样按照以上步骤来依赖 libs 目录内的其它所有 jar 包。 <br />

<h5>3)配置数据库(如果完成下方步骤 4，导入 APIJSON 的表，则可跳过) </h5>
打开 DemoSQLConfig 类，编辑 getDBUri，getDBAccount，getDBPassword，getSchema 的返回值为你自己数据库的配置。<br />

<h5>4)运行项目</h5>
APIJSONDemo/APIJSONBoot: 右键 DemoApplication > Run DemoApplication.main <br />
APIJSONFinal: 右键 DemoAppConfig > Run DemoAppConfig.main

<h4>运行后会出现 APIJSON 的测试日志，最后显示 "APIJSON 已启动" ，说明已启动完成。</h4>

如果是 Address already in use，说明 8080 端口被占用，<br />
可以关闭占用这个端口的程序(可能就是已运行的 APIJSON 工程) <br />
或者 改下 APIJSON 工程的端口号，参考 [SpringBoot 改端口](https://segmentfault.com/a/1190000021639114)。<br />
其它问题请谷歌或百度。


#### Eclipse for JavaEE

<h5>1)打开项目</h5>
顶部菜单 File > Import > Maven > Existing Maven Projects > Next > Browse <br />
> 选择刚才解压路径下的 APIJSON-Demo-Master/APIJSON-Java-Server 里面的 APIJSONDemo(简单Demo) 或 APIJSONBoot(实际项目) > OK
> 勾选 /pom.xml ... apijson-demo 或 apijson-boot > Finish

<h5>2)配置依赖库 </h5>
其中 apijson-orm, apijson-framework 默认使用 Maven 远程依赖仓库，等待自动下载完成， <br />
具体见 https://github.com/APIJSON/apijson-orm 和 https://github.com/APIJSON/apijson-framework <br />
如果依赖下载不了，注释掉报错的 apijson-orm, apijson-framework 依赖代码， <br />
然后右键 libs (APIJSONBoot 内，其它项目需要拷贝过去)里面的 apijson-orm.jar > Build Path > Add to Build Path <br />
同样按照以上步骤来依赖 libs 目录内的其它所有 jar 包。 <br />

<h5>3)配置数据库(如果完成下方步骤 4，导入 APIJSON 的表，则可跳过) </h5>
打开 DemoSQLConfig 类，编辑 getDBUri，getDBAccount，getDBPassword，getSchema 的返回值为你自己数据库的配置。<br />

<h5>4)运行项目</h5>
APIJSONDemo/APIJSONBoot: 右键 DemoApplication > Run As > Java Application <br />
APIJSONFinal: 右键 DemoAppConfig > Run As > Java Application

<br />

### 4.测试连接<br />
在浏览器输入 [http://localhost:8080/get/{}](http://localhost:8080/get/{}) <br />
如果出现
```json
{
  "code": 200,
  "msg": "success"
}
```
则说明已连接上。<br />

如果是404 Not Found，请把防火墙关闭，以便外网能够访问你的电脑或服务器。<br />
其它问题请谷歌或百度。

<br />


### 5.测试接口<br />
直接使用 [APIAuto-机器学习 HTTP 接口工具](http://apijson.cn/api) 或 Postman 等其它 HTTP 接口工具，格式为 HTTP POST JSON，具体示例参考通用文档 <br />
https://github.com/Tencent/APIJSON/blob/master/Document.md
<br />
