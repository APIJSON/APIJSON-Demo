# APIJSONDemo

## 支持多数据源-消息队列

示例：kafka

原理说明：

Access表名 = 消息队列 topic

Access表配置说明：
![image](https://user-images.githubusercontent.com/12228225/210956299-204115a7-433c-4f18-af27-5120068dab2e.png)
Request表配置post权限
![image](https://user-images.githubusercontent.com/12228225/210956378-be095589-0ced-4317-bb46-6b296538f26e.png)

apijson发送mq消息：
单条<br/>
{
    "@datasource": "kafka",
    "Topic_User":{
        "message":"test-101"
    },
    "tag": "Topic_User",
    "@explain": false
}<br/>
多条<br/>
{
    "Topic_User[]": [
        {
           "message":"test-100"
        },
        {
            "message":"test-101"
        }
    ],
    "tag": "Topic_User[]",
    "@datasource": "kafka",
    "@explain": true
}

客户端接收消息：

offset = 47, key = null, value = test-101<br/>
offset = 48, key = null, value = test-100<br/>
offset = 49, key = null, value = test-101<br/>


用java代码方式，获取具体数据源，调用即可
