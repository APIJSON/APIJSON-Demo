# 环境

- SpringBoot 3
- Java 17
- APIJSON 7.1.0
- apijson-framework 7.1.5
  
> 使用的 apijson 版本较旧，可自行升级到最新的 apijson-springboot3 版本，因为没做测试，这里就先不升级了。

# 和其他例子的主要区别

- 复杂度介于 APIJSONBoot 和 APIJSONDemo 之间
- 完成了一些常用配置
  - 简单鉴权
  - samesite 策略
  - HikariCP 多数据源配置
  - 解决数字返回前端精度丢失问题