# APIJSONDemo

## 支持多数据源-rediSQL

redis table 表名规范: REDIS_TABLE_* <br/>
开发人员可自行控制 <br/>
JedisBuildData <br/>
public static final String REDIS_TABLE_KEY = "REDIS_TABLE_"; // rediSql table prefix <br/>

Access、Request配置 访问操作权限 <br/>

rediSQL安装使用 <br/>
https://github.com/RedBeardLab/rediSQL

官方docker安装 <br/>
docker pull dalongrong/redisql
docker run -itd --name redisql -p 6399:6379  dalongrong/redisql

rediSQL注意事项 <br/>
rediSQL免费版有后遥控制,每个小时会发送 redist info 统计信息<br/>
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/12228225/219613765-e8d4d963-035b-4352-9552-1ce3a14093e4.png">

可以配host ,弄一个nginx 本地代理 解决,或者 项目自己重新打包<br/>

rediSQL java:<br/>
https://github.com/RedBeardLab/JRediSQL<br/>
https://www.youtube.com/watch?v=YRusC-AIq_g

rediSQL 创建数据库表命令 <br/>
```
REDISQL.EXEC DB "CREATE TABLE REDIS_TABLE_A(id TEXT, A INT, B TEXT, C TEXT, userId TEXT);"

REDISQL.EXEC DB "INSERT INTO REDIS_TABLE_A(id,A,B,C,userId) VALUES('1', 3, '1c', 'bar','1');"


REDISQL.EXEC DB "SELECT * FROM REDIS_TABLE_A;"

REDISQL.EXEC DB "drop table REDIS_TABLE_A;"
```

测试用例<br/>
```
{
	"@datasource": "redisCluster",
    "REDIS_TABLE_A":{
        "A": 1,
        "B": "B",
        "C": "C"
    },
    "tag": "REDIS_TABLE_A",
    "@explain": true,
    "format": true
}

{
    "REDIS_TABLE_A[]": [
        {
            "A": 5,
            "B": "5B",
            "C": "5C"
        },
        {
            "A": 6,
            "B": "6B",
            "C": "6C"
        },
        {
            "A": 7,
            "B": "7B",
            "C": "7C"
        }
    ],
    "tag": "REDIS_TABLE_A[]",
    "@datasource": "redisCluster",
    "@explain": true,
    "format": true
}

{
    "@datasource": "redisCluster",
    "REDIS_TABLE_A": {
        "id": "f2621698-99fa-4698-9fb0-8c7b585da403",
        "A": 1,
        "B": "1B"
    },
    "tag": "REDIS_TABLE_A",
    "@explain": true,
    "format": true
}

Request 表配置 
{"REDIS_TABLE_A[]": [{"MUST": "A,B", "REFUSE": "id"}], "INSERT": {"@role": "OWNER,ADMIN","@combine": "A | B"}}

{
    "@datasource": "redisCluster",
    "REDIS_TABLE_A": {
        "A": 1,
        "B": "1B",
        "C": "1-1-1C"
    },
    "tag": "REDIS_TABLE_A",
    "@explain": true,
    "format": true
}

{
    "@datasource": "redisCluster",
    "REDIS_TABLE_A:a": {
        "@column":"a,b,c",
        "b$": "7B%"
    },
    "@explain": true,
    "format": true
}

{
    "@datasource": "redisCluster",
    "REDIS_TABLE_A:a[]": {
        "REDIS_TABLE_A": {
            "@column":"a,b,c"
            //"b$": "1%"
        },
        "page":0,
        "count":3,
        "query": 2
    },
    "total@": "/REDIS_TABLE_A:a[]/total",
    "@explain": true,
    "format": true
}

{
    "@datasource": "redisCluster",
    "REDIS_TABLE_A": {
        "id": "f2621698-99fa-4698-9fb0-8c7b585da403"
    },
    "tag": "REDIS_TABLE_A",
    "@explain": true,
    "format": true
}

{
    "@datasource": "redisCluster",
    "REDIS_TABLE_A:a": {
        "id{}": ["1","eb3dd7c9-bab6-410c-b70a-cbbc3bd12896", "c83b3cfa-034e-4a9e-b2cf-83520db1ce05"]
    },
    "tag": "REDIS_TABLE_A[]",
    "@explain": true,
    "format": true
}
```
