<!--#include file="./uc_client/client.asp"-->
<%
'**************************************************
' ASP-Client to UCenter-Server ͨ��Ӧ�÷���
' ************************************************
' ���ϵ�һЩ����ų�UCenter ����ASp�����Ǵ󲿷ֶ�û��һ��ʵ����ֻ��һ�����ܽ��ܺ������ܶ������޷����������ʵ��Ӧ�á�
' ��˾��վ��Ŀ--�������ǣ�������asp��ucenter���о���һ��UCenter��д���������������Ȼֻ��д�˵�½��ע�Ჿ�ֹ��ܵ�ʵ�֣�����ģ������������«��ư��
' ���򷢲���QQ��59466966 
'**************************************************

Dim username,password,email
username= request("username")
password= request("password")
email = request("email")


Dim act 
act= Trim(request("act"))
 
Select Case act
	case "login"
		'UCenter �û���¼�� Example ����
		Call U_Login()
	case "logout"
		'UCenter �û��˳��� Example ����
		Call U_Logout()
	case "register"
		'UCenter �û�ע��� Example ����
		Call U_Register_nodb()
	case "pmlist"
		'UCenter δ������Ϣ�б�� Example ����
		Call U_pmlist()
	case "pmwin"
		'UCenter ����Ϣ���ĵ� Example ����
		Call U_pmwin()
	case "friend"
		'UCenter ���ѵ� Example ����
		Call U_friend()
	case "avatar"
		'UCenter ����ͷ��� Example ����
		Call U_avatar()
	Case Else
		response.write "û�в���"
End Select 

response.write "<hr />"

If session("login_user")="" Then 
	'�û�δ��¼
	response.write "<a href='"&Request.ServerVariables("Script_Name") & "?act=login'>��¼</a> "
	response.write "<a href='"&Request.ServerVariables("Script_Name") & "?act=register'>ע��</a> "
 else 
	'�û��ѵ�¼
	response.write "<script src='ucexample.js'></script><div id='append_parent'></div>"
	response.write session("login_user") &" <a href='"&Request.ServerVariables("Script_Name") & "?act=logout'>�˳�</a> "
	response.write " <a href='"&Request.ServerVariables("Script_Name") & "?act=pmlist'>����Ϣ�б�</a> "
	if IsNull(newpm) Then response.write "<font color='red'>New!("&newpm&")</font> "
	response.write "<a href='###' onclick=""pmwin('open')"">�������Ϣ����</a>"
	response.write " <a href='"&Request.ServerVariables("Script_Name") & "?act=friend'>����</a> "
	response.write " <a href='"&Request.ServerVariables("Script_Name") & "?act=avatar'>ͷ��</a> "

End If 



Sub U_Login()
	if(isempty(request("submit"))) Then 
		'��¼��
		response.write "<form method='post' action='"&Request.ServerVariables("Script_Name")  & "?act=login'>"
		response.write "��¼:"
		response.write "<dl><dt>�û���</dt><dd><input name='username'></dd>"
		response.write "<dt>����</dt><dd><input name='password' type='password'></dd></dl>"
		response.write "<input name='submit' type='submit'> "
		response.write "</form>"
	else 
		Dim uid
		uid = Empty 
		'ͨ���ӿ��жϵ�¼�ʺŵ���ȷ�ԣ�����ֵΪ����
		XML_login = uc_user_login(username,password) ' ��Ҫxmlת����ȡ�������
		arr_login =  xml2array(XML_login)

		uid = arr_login(0)
		username= arr_login(1)
		password= arr_login(2)
		email = arr_login(3)

		If (uid > "0") Then 
			'�û���½�ɹ������õ�½�ɹ��ı�־�������Բ���Cookies�����½��Ϣ
			session("login_user") = username

			'����ͬ����¼�Ĵ���
			ucsynlogin = uc_user_synlogin(uid) '����javascript�ֱ���ø���Ӧ�ý��е�½
			response.write "��¼�ɹ�"& ucsynlogin & "��<a href='"&Request.ServerVariables("Script_Name")  & "'>����</a>"
		 elseif(uid = "-1") Then 
			response.write "�û�������,���߱�ɾ��"
		 elseif(uid = "-2") Then 
			response.write "�����"
		 else 
			response.write "δ����"
		End If 
	End If
End Sub 
'----------------------------------------
Sub U_Logout()
	session("login_user")=""
	response.write "�ɹ��˳�"
End Sub 
'----------------------------------------
Sub U_Register_nodb()
	If request("submit")="" then 
		'ע���
		response.write "<form method=""post"" action="""&Request.ServerVariables("Script_Name")&"?act=register"">"
		response.write "ע��:"
		response.write "<dl><dt>�û���</dt><dd><input name=""username""></dd>"
		response.write "<dt>����</dt><dd><input name=""password""></dd>"
		response.write "<dt>Email</dt><dd><input name=""email""></dd></dl>"
		response.write "<input name=""submit"" type=""submit"">"
		response.write "</form>"
	 else
		'��UCenterע���û���Ϣ
		uid = uc_user_register(username,password,email)

		if(uid <= 0) Then 
			if(uid = -1) Then  
				response.write "�û������Ϸ�"
			 elseif(uid = -2) Then
				response.write "����Ҫ����ע��Ĵ���"
			 elseif(uid = -3) Then
				response.write "�û����Ѿ�����"
			 elseif(uid = -4) Then
				response.write "Email ��ʽ����"
			 elseif(uid = -5) Then
				response.write "Email ������ע��"
			 elseif(uid = -6) Then
				response.write "�� Email �Ѿ���ע��"
			 else 
				response.write "δ����"
			End if
		 else 
			'ע��ɹ������� Cookie������ֱ���� uc_authcode �������û�ʹ���Լ��ĺ���
			session("login_user") = username
			response.write "ע��ɹ�<br><a href="""&Request.ServerVariables("Script_Name")&""">����</a>"
		End If 
	End If 

End Sub 

'----------------------------------------
Sub U_pmlist()
	response.write "��ģ��û�б�д,���������!"
End Sub 
'----------------------------------
Sub U_pmwin()
	response.write "��ģ��û�б�д,���������!"
End Sub 
'-----------------------------
Sub U_friend()
	response.write "��ģ��û�б�д,���������!"
End Sub 
'-----------------------------
Sub U_avatar()
	response.write "��ģ��û�б�д,���������!"
End Sub 

%>