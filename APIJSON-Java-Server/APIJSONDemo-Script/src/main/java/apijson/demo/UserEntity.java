package apijson.demo;

import java.util.Date;
import lombok.Data;

@Data
public class UserEntity {
	// 用户编号
	private String id;
	// 用户名
	private String username;
	// 密码
	private String password;

	// 状态 已删除：-1,私有：0,公开：1,仅好友可见：2
	private Integer state;
	// 创建时间
	private Date createTime;
	// 最近更新时间
	private Date updateTime;
}
