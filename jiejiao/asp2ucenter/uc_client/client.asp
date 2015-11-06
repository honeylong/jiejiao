<!--#include file="config.asp"-->
<%

Function uc_api_post(module,action,arg)

	dim s,postdata
	s = arg
	postdata = uc_api_requestdata(module,action,s,"")
	uc_api_post =  uc_fopen2(UC_API & "/index.php", 500000, postdata, "", true, UC_IP, 20,true)
End Function

Function uc_user_synlogin(uid)
    uc_user_synlogin = uc_api_post("user", "synlogin", "uid="&uid)
End Function


Function uc_user_login(user,pwd)
	uc_user_login = uc_api_post("user","login","username="&user&"&password="&pwd&"&isuid=0&checkques=0&questionid=&answer=")
	'返回一个XML数组
End Function 

Function uc_user_register(user,pwd,eml)
	uc_user_register = uc_api_post("user","register","username="&user&"&password="&pwd&"&email="&email&"&questionid=&answer=&regip=")
End Function 

Function uc_api_requestdata(module,action,arg,extra)
	dim input
	input = uc_api_input(arg)
	uc_api_requestdata = "m="&module&"&a="&action&"&inajax=2&input="&input&"&appid="&UC_APPID&extra
	
End Function

Function uc_api_input(data)
'	Response.write "<br>"&data&"<br>"
	uc_api_input = Server.URLEncode(uc_authcode(data&"&agent="&Php_MD5(Request.ServerVariables ("HTTP_USER_AGENT"))&"&time="&php_time(), "ENCODE", UC_KEY))
End Function

Function uc_fopen(url, limit, post, cookie, bysocket, ip, stimeout, block)
	dim objXmlHttp
	set objXmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
	objXmlHttp.open "post",url,false
	objXmlHttp.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
    objXmlHttp.setRequestHeader "Accept", "*/*"   
    objXmlHttp.setRequestHeader "Accept-Language","zh-cn"   
  '  objXmlHttp.setRequestHeader "Content-Type","application/x-www-form-urlencoded"   
    objXmlHttp.setRequestHeader "User-Agent", Request.ServerVariables("HTTP_USER_AGENT")    
    objXmlHttp.setRequestHeader "Connection","Close"   
    objXmlHttp.setRequestHeader "Cache-Control","no-cache"   
	objXmlHttp.send(post)
	Dim binFileData
	binFileData = objXmlHttp.responseBody
	Dim ObjStream
	Set ObjStream = CreateObject("Adodb.Stream")
	With ObjStream
		.Type = 1
		.Mode = 3
		.Open
		.write binFileData
		.Position = 0
		.Type = 2
		.Charset = "gb2312"
		s = .ReadText
		.Close
	End With
	Set ObjStream = Nothing
	uc_fopen = s
End function


function uc_fopen2(url, limit, post, cookie,bysocket, ip , stimeout, block)
	Dim times
	if request("__times__")<>"" Then
		times = Cint(request("__times__")) + 1
	Else
		times =  1
	End If
	if times > 2 Then
		uc_fopen2 = ""
	End If
	If instr(url,"?")>0 Then
		url = url & "&__times__=" & times
	Else
		url = url & "?__times__=" & times
	End If
	uc_fopen2 = uc_fopen(url, limit, post, cookie, bysocket, ip, stimeout, block)
End Function


Function xml2array(xmldoc)
	Dim objdoc
	set objdoc=Server.CreateObject("msxml2.FreeThreadedDOMDocument.3.0")
	objdoc.async = false
	objdoc.LoadXml(xmldoc)
	Dim objNodeList
	Dim Counters(14)
	set objNodeList = objdoc.selectSingleNode("//root").childNodes
	For i = 0 To (objNodeList.length - 1)
		Counters(i)= objNodeList.Item(i).text
	Next
	xml2array = Counters
End Function 
%>