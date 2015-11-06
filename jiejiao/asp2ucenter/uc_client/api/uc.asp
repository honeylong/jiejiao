<!--#include file="../config.asp"-->
<%
'**************************************************
' ASP-Client to UCenter-Server 通信应用范例
' ************************************************
' 网上的一些代码号称UCenter 整合ASp，但是大部分都没有一个实例，只有一个加密解密函数，很多新手无法利用其进行实际应用。
' 公司网站项目--课堂无忧，需整合asp和ucenter，研究了一把UCenter，写了这个范例程序，虽然只简单写了登陆和注册部分功能的实现，其余模块您可以依葫芦画瓢。
' 程序发布人QQ：59466966 
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
If CInt(ttime) > 60 Then '一分钟内有效，要求服务器上的时间相差不能超过1分钟
    Response.write "Authorization has expiried"
	Response.End()
End If
'验证部分，不用修改 结束
action = tget("action")
Dim ids, uid, oldusername, newusername, username, password, orgpassword, salt
Select Case action
    Case "test"
        Response.write 1
    Case "synlogin"  '登录
		Response.Addheader "P3P","CP=""CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"""
	    '以下可修改本应用的登录处理方式代码，获取到
		session("login_user") = tget("username")

        Response.write 1  '最后返回 成功
	Case "synlogout" '退出
		Response.Addheader "P3P","CP=""CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"""
	    '以下可修改本应用的退出处理方式代码
		session.Abandon()
        Response.write 1  '最后返回 成功
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