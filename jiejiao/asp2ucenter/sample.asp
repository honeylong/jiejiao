<!--#include file="./uc_client/client.asp"-->
<%
'**************************************************
' ASP-Client to UCenter-Server 通信应用范例
' ************************************************
' 网上的一些代码号称UCenter 整合ASp，但是大部分都没有一个实例，只有一个加密解密函数，很多新手无法利用其进行实际应用。
' 公司网站项目--课堂无忧，需整合asp和ucenter，研究了一把UCenter，写了这个范例程序，虽然只简单写了登陆和注册部分功能的实现，其余模块您可以依葫芦画瓢。
' 程序发布人QQ：59466966 
'**************************************************

Dim username,password,email
username= request("username")
password= request("password")
email = request("email")


Dim act 
act= Trim(request("act"))
 
Select Case act
	case "login"
		'UCenter 用户登录的 Example 代码
		Call U_Login()
	case "logout"
		'UCenter 用户退出的 Example 代码
		Call U_Logout()
	case "register"
		'UCenter 用户注册的 Example 代码
		Call U_Register_nodb()
	case "pmlist"
		'UCenter 未读短消息列表的 Example 代码
		Call U_pmlist()
	case "pmwin"
		'UCenter 短消息中心的 Example 代码
		Call U_pmwin()
	case "friend"
		'UCenter 好友的 Example 代码
		Call U_friend()
	case "avatar"
		'UCenter 设置头像的 Example 代码
		Call U_avatar()
	Case Else
		response.write "没有操作"
End Select 

response.write "<hr />"

If session("login_user")="" Then 
	'用户未登录
	response.write "<a href='"&Request.ServerVariables("Script_Name") & "?act=login'>登录</a> "
	response.write "<a href='"&Request.ServerVariables("Script_Name") & "?act=register'>注册</a> "
 else 
	'用户已登录
	response.write "<script src='ucexample.js'></script><div id='append_parent'></div>"
	response.write session("login_user") &" <a href='"&Request.ServerVariables("Script_Name") & "?act=logout'>退出</a> "
	response.write " <a href='"&Request.ServerVariables("Script_Name") & "?act=pmlist'>短消息列表</a> "
	if IsNull(newpm) Then response.write "<font color='red'>New!("&newpm&")</font> "
	response.write "<a href='###' onclick=""pmwin('open')"">进入短消息中心</a>"
	response.write " <a href='"&Request.ServerVariables("Script_Name") & "?act=friend'>好友</a> "
	response.write " <a href='"&Request.ServerVariables("Script_Name") & "?act=avatar'>头像</a> "

End If 



Sub U_Login()
	if(isempty(request("submit"))) Then 
		'登录表单
		response.write "<form method='post' action='"&Request.ServerVariables("Script_Name")  & "?act=login'>"
		response.write "登录:"
		response.write "<dl><dt>用户名</dt><dd><input name='username'></dd>"
		response.write "<dt>密码</dt><dd><input name='password' type='password'></dd></dl>"
		response.write "<input name='submit' type='submit'> "
		response.write "</form>"
	else 
		Dim uid
		uid = Empty 
		'通过接口判断登录帐号的正确性，返回值为数组
		XML_login = uc_user_login(username,password) ' 需要xml转化提取数组出来
		arr_login =  xml2array(XML_login)

		uid = arr_login(0)
		username= arr_login(1)
		password= arr_login(2)
		email = arr_login(3)

		If (uid > "0") Then 
			'用户登陆成功，设置登陆成功的标志，您可以采用Cookies保存登陆信息
			session("login_user") = username

			'生成同步登录的代码
			ucsynlogin = uc_user_synlogin(uid) '返回javascript分别调用各个应用进行登陆
			response.write "登录成功"& ucsynlogin & "，<a href='"&Request.ServerVariables("Script_Name")  & "'>继续</a>"
		 elseif(uid = "-1") Then 
			response.write "用户不存在,或者被删除"
		 elseif(uid = "-2") Then 
			response.write "密码错"
		 else 
			response.write "未定义"
		End If 
	End If
End Sub 
'----------------------------------------
Sub U_Logout()
	session("login_user")=""
	response.write "成功退出"
End Sub 
'----------------------------------------
Sub U_Register_nodb()
	If request("submit")="" then 
		'注册表单
		response.write "<form method=""post"" action="""&Request.ServerVariables("Script_Name")&"?act=register"">"
		response.write "注册:"
		response.write "<dl><dt>用户名</dt><dd><input name=""username""></dd>"
		response.write "<dt>密码</dt><dd><input name=""password""></dd>"
		response.write "<dt>Email</dt><dd><input name=""email""></dd></dl>"
		response.write "<input name=""submit"" type=""submit"">"
		response.write "</form>"
	 else
		'在UCenter注册用户信息
		uid = uc_user_register(username,password,email)

		if(uid <= 0) Then 
			if(uid = -1) Then  
				response.write "用户名不合法"
			 elseif(uid = -2) Then
				response.write "包含要允许注册的词语"
			 elseif(uid = -3) Then
				response.write "用户名已经存在"
			 elseif(uid = -4) Then
				response.write "Email 格式有误"
			 elseif(uid = -5) Then
				response.write "Email 不允许注册"
			 elseif(uid = -6) Then
				response.write "该 Email 已经被注册"
			 else 
				response.write "未定义"
			End if
		 else 
			'注册成功，设置 Cookie，加密直接用 uc_authcode 函数，用户使用自己的函数
			session("login_user") = username
			response.write "注册成功<br><a href="""&Request.ServerVariables("Script_Name")&""">继续</a>"
		End If 
	End If 

End Sub 

'----------------------------------------
Sub U_pmlist()
	response.write "此模块没有编写,请自行完成!"
End Sub 
'----------------------------------
Sub U_pmwin()
	response.write "此模块没有编写,请自行完成!"
End Sub 
'-----------------------------
Sub U_friend()
	response.write "此模块没有编写,请自行完成!"
End Sub 
'-----------------------------
Sub U_avatar()
	response.write "此模块没有编写,请自行完成!"
End Sub 

%>