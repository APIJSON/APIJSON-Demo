package com.example.apijsondemo.model;

import java.util.List;

import com.alibaba.fastjson.annotation.JSONField;

import apijson.framework.BaseModel;
import apijson.orm.Visitor;

/**
 * 用户隐私信息
 * 
 * @author Lemon
 */
public class Privacy extends BaseModel implements Visitor<Long> {

	private static final long serialVersionUID = 1L;

	private String username; // 用户名
	private String password; // 登录密码，隐藏字段

	private List<Long> contactIdList; // 朋友列表

	public Privacy() {
		super();
	}

	public Privacy(long id) {
		this();
		setId(id);
	}

	public Privacy(String username, String password) {
		this();
		setUserName(username);
		setPassword(password);
	}

	// 默认会将属性设置为userName,想去掉大写的N，就要加注释
	@JSONField(name = "username")
	public String getUserName() {
		return username;
	}

	public Privacy setUserName(String username) {
		this.username = username;
		return this;
	}

	/**
	 * fastjson >= 1.2.70 的版本时，JSON.toJSONString 后，
	 * get__password, get_password 会分别转为 __password, password，
	 * 不像之前(例如 1.2.61 及以下)分别转为 _password, password，
	 * 如果 @JSONField(name="_password") 未生效，请勿使用 1.2.70-1.2.73，或调整数据库字段命名为 __password
	 * 
	 * @return
	 */

	@JSONField(name = "_password")
	public String get__password() {
		return password;
	}

	public Privacy setPassword(String password) {
		this.password = password;
		return this;
	}

	@Override
	public List<Long> getContactIdList() {
		return contactIdList;
	}

}
