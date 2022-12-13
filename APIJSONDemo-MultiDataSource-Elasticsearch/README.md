# APIJSONDemo

## 1、支持多数据源

数据源解析顺序: 

- [ ] 对象@datasource

- [ ] 全局 @datasource

- [ ] 应用默认 @datasource

  ```json
  {
    // "@datasource": "db2" 全局
  	"@post": {
  		"User:aa": {
  			 "@datasource": "db2" // 对象
  		},
  		"User_address[]": {
  			 "@datasource": "db2"
  		}
  	},
      "User:aa":{
          "username":"test-3",
          "password": "233223",
  		"state": 1
      },
      "ES_blog:a": {
          "@datasource": "elasticSearch",
          "title.keyword": "test-2"
      },
      "User_address[]": [
      	{
      	"user_id@": "User:aa/id",
      	"addr": "ddd",
      	"count@": "ES_blog:a/count"
      	},
      	{
      	"user_id@": "User:aa/id",
      	"addr": "ddd1",
      	"count@": "ES_blog:a/count"
      	}
      ],
      "@explain": true
  }
  ```

  ![image-20221213105328227](/Users/xy/Library/Application Support/typora-user-images/image-20221213105328227.png)

## 2、集成elasticsearch-sql

换成xpack, 也一样

应用导入: elasticsearch-sql-7.17.5.0.jar

## 3、apijson支持elasticsearch功能点

新增、修改、删除、查询

## 4、elasticsearch-sql不支持RLIKE

![image-20221213141141037](/Users/xy/Library/Application Support/typora-user-images/image-20221213141141037.png)

## 5、apijson支持字段 .keyword

```
{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    "title.keyword$": "%test-2",
		"content": "u-c-2",
		"url": "u-u-2",
		"postdate": "2008-12-11",
		"count": 1
    },
    "tag": "ES_blog",
    "@explain": true
}
```



## 4、示例

### 单条插入

```
http://localhost:8080/post

{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
        "title":"test-1",
        "author": "a-1",
		"content": "c-1",
		"url": "u-1",
		"postdate": "2018-12-11",
		"count": 1
    },
    "tag": "ES_blog",
    "@explain": true
}

```

![image-20221213105649445](/Users/xy/Library/Application Support/typora-user-images/image-20221213105649445.png)



elasticsearch查询插入的数据:

GET /es_blog/_doc/5b77b103-0231-42c3-a6cf-a0cb933d3dda

![image-20221213105850231](/Users/xy/Library/Application Support/typora-user-images/image-20221213105850231.png)

### 批量插入

```json
http://localhost:8080/post

{
	"@datasource": "elasticSearch",
    "ES_blog:aa[]": [
        {
            "title":"test-1",
	        "author": "a-1",
			"content": "c-1",
			"url": "u-1",
			"postdate": "2018-12-11",
			"count": 1
        },
        {
            "title":"test-2",
	        "author": "a-2",
			"content": "c-2",
			"url": "u-2",
			"postdate": "2018-12-11",
			"count": 2
        },
        {
            "title":"test-3",
	        "author": "a-3",
			"content": "c-3",
			"url": "u-3",
			"postdate": "2018-12-11",
			"count": 3
        }
    ],
    "tag": "ES_blog[]",
    "@explain": true
}

```

![image-20221213104938108](/Users/xy/Library/Application Support/typora-user-images/image-20221213104938108.png)

elasticsearch查询插入的数据:

GET /es_blog/_search

![image-20221213105443909](/Users/xy/Library/Application Support/typora-user-images/image-20221213105443909.png)

### id修改

```json
http://localhost:8080/put

{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    	"id": "5b77b103-0231-42c3-a6cf-a0cb933d3dda",
        "title":"u-test-1",
        "author": "u-a-1",
		"content": "u-c-1",
		"url": "u-u-1",
		"postdate": "2018-12-10",
		"count": 9
    },
    "tag": "ES_blog",
    "@explain": true
}
```

![image-20221213110113376](/Users/xy/Library/Application Support/typora-user-images/image-20221213110113376.png)



![image-20221213110132755](/Users/xy/Library/Application Support/typora-user-images/image-20221213110132755.png)

### 非id修改

```
http://localhost:8080/put
{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    	"title~":"u-test-1",
        "author": "u1-a-2",
		"content": "u1-c-2",
		"url": "u1-u-2",
		"postdate": "2028-12-11",
		"count": 1
    },
    "tag": "ES_blog",
    "@explain": true
}


{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    	"title~":"test-3",
        "author~": "u3-a-2",
		"content": "u1-c-2",
		"url": "u1-u-2",
		"postdate": "2028-12-11",
		"count": 1,
		"@combine":"title~ | author~"
    },
    "tag": "ES_blog",
    "@explain": true
}

{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    	"count{}":[1,4],
		"content": "u-c-2",
		"url": "u-u-2",
		"postdate": "2008-12-11",
		"count": 1
    },
    "tag": "ES_blog",
    "@explain": true
}

{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    	"title$": "%test",
		"content": "u-c-2",
		"url": "u-u-2",
		"postdate": "2008-12-11",
		"count": 1
    },
    "tag": "ES_blog",
    "@explain": true
}


{
	"@datasource": "elasticSearch",
    "ES_blog:aa":{
    	"postdate%":"2007-10-01,2018-10-01",
		"content": "u-c-2",
		"url": "u-u-2",
		"postdate": "2008-12-11",
		"count": 1
    },
    "tag": "ES_blog",
    "@explain": true
}
```

![image-20221213120359815](/Users/xy/Library/Application Support/typora-user-images/image-20221213120359815.png)

### 批量修改

```
http://localhost:8080/put
{
	"@datasource": "elasticSearch",
    "ES_blog:aa[]": [
        {
	        "title~":"test-1",
	        "author": "u3-a-2",
			"content": "u3-c-2",
			"url": "u3-u-2",
			"postdate": "2038-12-11",
			"count": 1
        },
        {
	    	"title~":"test-2",
	        "author": "u-a-3",
			"content": "u-c-3",
			"url": "u-u-3",
			"postdate": "2008-12-11",
			"count": 4
        }
    ],
    "tag": "ES_blog[]",
    "explain": true
}
```

### id删除

```
{
	"@datasource": "elasticSearch",
    "ES_blog:del": {
        "id": "043a7511-296b-43b5-9f12-966dd86299d1"
    },
    "tag": "ES_blog",
    "explain": true
}
```



### 非id条件删除

```
http://localhost:8080/delete

{
	"@datasource": "elasticSearch",
    "ES_blog:del": {
        "title": "test-2"
    },
    "tag": "ES_blog",
    "explain": true
}

{
	"@datasource": "elasticSearch",
    "ES_blog:del": {
        "count{}":[2,4]
    },
    "tag": "ES_blog",
    "explain": true
}
```

![image-20221213115535006](/Users/xy/Library/Application Support/typora-user-images/image-20221213115535006.png)

### 批量删除

```
{
	"@datasource": "elasticSearch",
    "ES_blog:del": {
        "id{}": ["f41e3010-c410-45a0-b41a-33afbc1e4ef8","d765de31-2fc8-40e5-9430-277bf7e5f91b"]
    },
    "tag": "ES_blog",
    "explain": true
}
```

### 查询单条记录

```
{
    "ES_blog:a": {
        "@datasource": "elasticSearch",
        "id": "4862927d-9a38-47c9-9cfc-5b3e9db38d30"
    },
    "@explain": true
}
```

### 分页查询

```
{
  "[]": {
    "ES_blog": {
    	"@datasource": "elasticSearch"
    },
    "page": 0,
    "count": 2,
    "query": 2
  },
  "total@": "/[]/total"
}

```

![image-20221213140810462](/Users/xy/Library/Application Support/typora-user-images/image-20221213140810462.png)

### 分组查询

```
{
	 "@datasource": "elasticSearch",
	"[]": {
		"count": 5,
		"ES_blog":{
			"@column":"count;sum(count):sum",
			"@group":"count"
		}
	}
}
```

![image-20221213140933538](/Users/xy/Library/Application Support/typora-user-images/image-20221213140933538.png)
