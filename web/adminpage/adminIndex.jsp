<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page import="ielab.util.StringUtils"%>
<%@page import="ielab.hibernate.Admin"%>
<%@include file="../comm.jsp"%>
<%
	Admin admin=null;
	try{
		if(StringUtils.isEmpty(session.getAttribute("admin"))){
			out.println("读取session数据失败，");
			response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
			return;
		}
		admin=(Admin)session.getAttribute("admin");
	}catch(Exception e){
		out.println("读取session数据失败，");
		response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
		return;
	}

	String title="";

	try{
		title="你好，管理员：<font color=\"red\">"+admin.getName()+"</font>，恭喜你登陆成功，进入实验管理界面。";
	}catch(Exception e){
		out.println("生成页面数据失败，");
		response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
		return;
	}
%>
<html>
	<head>	
		<title>DC实验管理界面－管理员主页面</title>
	<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
	<body>
		<%@include file="head.jsp"%>
		<script type="text/javascript" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-7" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminIndex.jsp">
			var v=document.getElementById("adminIndex");
			v.className="menuSelected";
		</script>
		<table width="1000" height="34" border="0" align="center" cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
			<tbody>
				<tr>
					<td width="70%">
						<div align="left" id="title">
							<%=title%>
						</div>
					</td>
					<td width="30%">
					</td>
				</tr>
			</tbody>
		</table>
		<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td height="3"></td>
			</tr>
		</table>
		<table width="1000" height="450" border="0" align="center" cellpadding="0" cellspacing="0" class="table19">
			<tr height="420px">
				<td align="center">
					<img src="images/admin-introduction.jpg"></img>
				</td>
			</tr>
		</table>		
		<%@include file="foot.jsp"%>
	</body>
</html>