<!--#include file="../config.asp"-->
<%
'**************************************************
' ASP-Client to UCenter-Server ͨ��Ӧ�÷���
' ************************************************
' ���ϵ�һЩ����ų�UCenter ����ASp�����Ǵ󲿷ֶ�û��һ��ʵ����ֻ��һ�����ܽ��ܺ������ܶ������޷����������ʵ��Ӧ�á�
' ��˾��վ��Ŀ--�������ǣ�������asp��ucenter���о���һ��UCenter��д���������������Ȼֻ��д�˵�½��ע�Ჿ�ֹ��ܵ�ʵ�֣�����ģ������������«��ư��
' ���򷢲���QQ��59466966 
'**************************************************

Dim tget, ttime, code, action
code = Request.QueryString("code")
code = uc_authcode(code,"DECODE",UC_KEY)

Set tget = parse_str(code)
If Len(code) < 5 Then
    Response.write "Invalid Request"
	Response.End()
End If
ttime = tget("time")
If Not IsNumeric(ttime) Or ttime = "" Then
    Response.write "Invalid Request"
	Response.End()
End If
ttime = DateAdd("s",ttime,"1970-01-01 08:00:00")
ttime = DateDiff("s",ttime,Now())
If CInt(ttime) > 60 Then 'һ��������Ч��Ҫ��������ϵ�ʱ�����ܳ���1����
    Response.write "Authorization has expiried"
	Response.End()
End If
'��֤���֣������޸� ����
action = tget("action")
Dim ids, uid, oldusername, newusername, username, password, orgpassword, salt
Select Case action
    Case "test"
        Response.write 1
    Case "synlogin"  '��¼
		Response.Addheader "P3P","CP=""CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"""
	    '���¿��޸ı�Ӧ�õĵ�¼����ʽ���룬��ȡ��
		session("login_user") = tget("username")

        Response.write 1  '��󷵻� �ɹ�
	Case "synlogout" '�˳�
		Response.Addheader "P3P","CP=""CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"""
	    '���¿��޸ı�Ӧ�õ��˳�����ʽ����
		session.Abandon()
        Response.write 1  '��󷵻� �ɹ�
End Select


Function parse_str(str)
    Dim objData, aryData, i, aryT
    Set objData = Server.CreateObject("Scripting.Dictionary")
    aryData = Split(str,"&")
    For i = 0 To UBound(aryData)
        aryT = Split(aryData(i), "=")
        If UBound(aryT) > 0 Then
            objData.add aryT(0), aryT(1)
        Else
            objData.add aryT(0), ""
        End If
    Next
    Set parse_str = objData
    Set objData = Nothing
End Function

%>