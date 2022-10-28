## <h2 id="2">2.Server-side deployment<h2/>
	
### JDBC Demo:
[APIJSONDemo](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo) is a simple demo for testing with APIJSON + SpringBoot, configure database in DemoSQLConfig; <br />
[APIJSONBoot](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot) is a complex demo for production with APIJSON + SpringBoot, configure database in DemoSQLConfig; <br />
[APIJSONFinal](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONFinal) is a complex demo for production with APIJSON + SpringBoot, configure database in DemoSQLConfig. <br />

### Connection Pool Demo:
[APIJSONDemo-Druid](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-Druid) is a simple demo for testing with APIJSON + SpringBoot + Druid, configure database in application.yml； <br />
[APIJSONDemo-HikariCP](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-HikariCP) is a simple demo for testing with APIJSON + SpringBoot + HikariCP, configure database in application.yml； <br />
[APIJSONBoot-MultiDataSource](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource) is a complex demo for production with multi data sources, configure database in application.yml, <br />
and the [APIAuto](https://github.com/TommyLemon/APIAuto) source code is in [src/main/resources/static](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-MultiDataSource/src/main/resources/static), you can test APIs after open http://localhost:8080 with a browser. <br />

### Sharding Demo:
[APIJSONDemo-ShardingSphere](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONDemo-ShardingSphere) is a simple demo for testing with APIJSON + SpringBoot + ShardingSphere, configure database in application.yml, application-sharding-databases.properties, etc. <br />
	
### BigData & OLAP Demo
[APIJSONBoot-BigData](https://github.com/APIJSON/APIJSON-Demo/tree/master/APIJSON-Java-Server/APIJSONBoot-BigData) is a complex demo for production with APIJSON + SpringBoot + Presto + Trino + Elasticsearch.
	
<br />
	
**You can use either Eclipse for JavaEE or IntelllJ IDEA Ultimate to make installation. <br />
For both, first [download the project](https://github.com/APIJSON/APIJSON-Demo/archive/master.zip) and save it to a path.** <br />

<br />
	
### <h3 id="2.1">2.1 Requirements<h3/>
JDK(Java Development Kit): 1.8+ <br />
[Maven](https://maven.apache.org/download.cgi): 3.0+ <br />
Database: MySQL/PostgreSQL/Oracle/DB2/SQLServer/TiDB/ClickHouse/TDengine ..  <br />

<br />

### <h3 id="2.2">2.2 Import MySQL table files<h3/>

This Server project needs [MySQL Server](https://dev.mysql.com/downloads/mysql/) and [MySQLWorkbench](https://www.mysql.com/products/workbench/). Please make sure that both of them are installed.<br />

My config is Windows 7 + MySQL Community Server 5.7.16 + MySQLWorkbench 6.3.7 and OSX EI Capitan + MySQL Community Server 5.7.16 + MySQLWorkbench 6.3.8. Systems and softwares are all 64 bit.

Start *MySQLWorkbench > Enter a connection > Click Server menu > Data Import > Select the path of your .sql file > Start Import > Refresh SCHEMAS*. Now you should see tables are added successfully.

<br />
	
### <h3 id="2.3">2.3 Installing with Eclipse<h3/>

#### <h4 id="2.3.1">2.3.1 prerequisites<h4/>
[Eclipse Java EE IDE](https://www.eclipse.org/downloads/) for Web Developers 4.5.1+

#### <h4 id="2.3.2">2.3.2 Opening the project with Eclipse<h4/>
  
Open Eclipse> *File > Import > Maven > Existing Maven Projects > Next > Browse > Select the path of the project you saved / APIJSON-Java-Server / APIJSONBoot > check pom.xml...apijson-demo > Finish*
  
#### <h4 id="2.3.3">2.3.3 Preparing the library used in demo<h4/>
  
In the menu at the right, click libs, right click apijson-orm.jar, click add as library. Apply the same to the rest *.jar* files in libs.

#### <h4 id="2.3.4">2.3.4 Configuration<h4/>
  
Open apijson.demo.server.DemoSQLConfig. In line 40-61, change return values of `getDBUri`,`getDBAccount`,`getDBPassword`,`getSchema` to your own database.<br/>

```java
	static {
		DEFAULT_DATABASE = DATABASE_MYSQL;  // TODO
		DEFAULT_SCHEMA = "sys";  // TODO  defaults: MySQL: sys, PostgreSQL: public, SQL Server: dbo, Oracle: 
	}
	
	@Override
	public String getDBVersion() {
		return "5.7.22";  // "8.0.11";  // TODO
	}
	
	@JSONField(serialize = false)
	@Override
	public String getDBUri() {
		// add userSSL=false for MySQL 8.0+  return "jdbc:mysql://localhost:3306?userSSL=false&serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8";
		// for MySQL not greater than 5.7
		return "jdbc:mysql://localhost:3306?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8"; // TODO TiDB can be used as MySQL, its defaut port is 4000
	}
	
	@JSONField(serialize = false)
	@Override
	public String getDBAccount() {
		return "root";  // TODO
	}
	
	@JSONField(serialize = false)
	@Override
	public String getDBPassword() {
		return "apijson"; // TODO TiDB can be used as MySQL, its defaut password is an empty string ""
	}
```

**Note**: Instead of this step, you can also [import your database](#2.2).
  
#### <h4 id="2.3.5">2.3.5 Running the application<h4/>

In Eclipse, in the menu on the top, click *Run>Run As>Java Application>choose APIJSONApplication>OK*

	
### <h3 id="2.4">2.4 Installing with IntellIJ IDEA Ultimate<h3/>
  
#### <h4 id="2.4.1">2.4.1 Opening the project<h4/>

*Open > Select the path of the project/APIJSON-Java-Server/APIJSONBoot > OK*

#### <h4 id="2.4.2">2.4.2 Preparing the library used in demo<h4/>  
  
In libs, right-click *apijson-orm.jar >Add as Library>OK*. Apply this to all *.jar* files in libs.

#### <h4 id="2.4.3">2.4.3 Configuration<h4/>
  
Open apijson.demo.server.DemoSQLConfig. In line 40-61, change return values of `getDBUri`,`getDBAccount`,`getDBPassword`,`getSchema` to your own database.<br/>

```java
	static {
		DEFAULT_DATABASE = DATABASE_MYSQL;  // TODO
		DEFAULT_SCHEMA = "sys";  // TODO  defaults: MySQL: sys, PostgreSQL: public, SQL Server: dbo, Oracle: 
	}
	
	@Override
	public String getDBVersion() {
		return "5.7.22";  // "8.0.11";  // TODO
	}
	
	@JSONField(serialize = false)
	@Override
	public String getDBUri() {
		// add userSSL=false for MySQL 8.0+  return "jdbc:mysql://localhost:3306?userSSL=false&serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8";
		// for MySQL not greater than 5.7
		return "jdbc:mysql://localhost:3306?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8"; // TODO TiDB can be used as MySQL, its defaut port is 4000
	}
	
	@JSONField(serialize = false)
	@Override
	public String getDBAccount() {
		return "root";  // TODO
	}
	
	@JSONField(serialize = false)
	@Override
	public String getDBPassword() {
		return "apijson"; // TODO TiDB can be used as MySQL, its defaut password is an empty string ""
	}
```
#### <h4 id="2.4.4">2.4.4 Running the application<h4/>
  
In the menu on the top: *Run > Run > Edit Configurations > + > Application > Configuration*<br />
In *Main class* , choose *APIJSONApplication*;<br />
In *Use classpath of module* , choose *apijson-demo*.<br />
Click *Run* in the bottom.

<br /><br />	
	
**Note**: After running, you should see APIJSON test logs and in the last, it would show ‘APIJSON已启动’. If it shows ‘address already in use’, that means port 8080 has been used . You need tochange the port. See [how to change ports for a Spring Boot Application.](https://stackoverflow.com/questions/21083170/how-to-configure-port-for-a-spring-boot-application)

<br />	
	
### 2.5.Test connection<br />
Open [http://localhost:8080/get/{}](http://localhost:8080/get/{}) with a browser<br />
If it shows:
```json
{
  "code": 200,
  "msg": "success"
}
```
Then it's a success.<br />

If it shows '404 Not Found', please close the firewall of your machine.<br />
Google other quetions if they appear.

<br />


### 2.6.Test APIs<br />
Use [APIAuto](http://apijson.cn/api), Postman or another HTTP API test tool, the request form is HTTP POST JSON, see more on the Document <br />
https://github.com/Tencent/APIJSON/blob/master/Document-English.md

<br />

