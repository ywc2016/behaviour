<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page import="ielab.hibernate.Admin"%>
<%@page import="ielab.util.StringUtils"%>
<%@include file="../comm.jsp"%>
<html>
	<head>
		<title>DC实验管理界面－管理员修改信息</title>
	<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
	<script type="text/javascript">
	function checkform(){
		var filter=/^[A-Za-z0-9_]+$/;
		
		var username=document.getElementById("username").value;
		if (!filter.exec(username)){
			alert("用户名输入错误，只能包含大小写英文字母，数字和下划线！");
			document.getElementById("username").focus();
			return false;
		}
		
		var password=document.getElementById("password").value;
		var password2=document.getElementById("password2").value;
		if(password!=password2){
			alert("密码与确认密码不符，请重新输入！");
			document.getElementById("password2").focus();
			return false;
		}
		
		var school=document.getElementById("school").value;
		if (school==""){
			alert("学校不能为空，请重新输入！");
			document.getElementById("school").focus();
			return false;
		}
		
		filter=/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/
		var email=document.getElementById("email").value;
		if (!filter.exec(email)){
			alert("Eail地址格式错误，请重新输入！");
			document.getElementById("email").focus();
			return false;
		}
		
		var tel=document.getElementById("tel").value;
		if (tel==""){
			alert("联系电话不能为空，请重新输入！");
			document.getElementById("tel").focus();
			return false;
		}
	}
	
	
	</script>
<%
	Admin admin=null;
	String title="";
	try{
		if(StringUtils.isEmpty(session.getAttribute("admin"))){
			out.println("读取session数据失败，");
			response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
			return;
		}
		admin=(Admin)session.getAttribute("admin");
		title="你好，管理员：<font color=\"red\">"+admin.getName()+"</font>";
	}catch(Exception e){
		out.println("读取session数据失败，");
		response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
		return;
	}
%>	
	<body>
		<%@include file="head.jsp"%>
		<script type="text/javascript" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-2" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminChangePsw.jsp">
			var v=document.getElementById("adminChangePsw");
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
			<tr>
				<td valign="bottom" height="20">
					<span style="font:bold;color:green;">
						修改管理员信息
					</span>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<form action="<%=basePath+"adminpage/adminChangePsw_do.jsp"%>" method="post" onsubmit="return checkform();">
						<table style="width: 300" border="0" cellpadding="0" cellspacing="0" class="dataBorderedTable">
							<tr>
								<th width="40%">
									用户名：
								</th>
								<td width="60%">
									<input value="<%=admin.getUsername()%>" id="username" name="username" style="width: 12em" maxlength="20"/>
								</td>
							</tr>
							<tr>
								<th width="5%">
									密&nbsp;&nbsp;&nbsp;码：
								</th>
								<td>
									<input value="<%=admin.getPassword()%>" type="password" id="password" name="password" style="width: 12em" maxlength="20"/>
								</td>
							</tr>
							<tr>
								<th width="5%">
									确认密码：
								</th>
								<td>
									<input value="<%=admin.getPassword()%>" type="password" id="password2" name="password2" style="width: 12em" maxlength="20"/>
								</td>
							</tr>
							<tr>
								<th width="5%">
									姓&nbsp;&nbsp;&nbsp;名：
								</th>
								<td>
									<input value="<%=admin.getName()%>" id="name" name="name" style="width: 12em" maxlength="20"/>
								</td>
							</tr>
							<tr>
								<th width="5%">
									学&nbsp;&nbsp;&nbsp;校：
								</th>
								<td>
									<input value="<%=admin.getUniversity()%>" id="school" name="school" style="width: 12em" maxlength="50"/>
								</td>
							</tr>
							<tr>
								<th width="5%">
									Email地址：
								</th>
								<td>
									<input value="<%=admin.getEmail()%>" id="email" name="email" style="width: 12em" maxlength="100"/>
								</td>
							</tr>
							<tr>
								<th width="5%">
									联系电话：
								</th>
								<td>
									<input value="<%=admin.getTel()%>" id="tel" name="tel" style="width: 12em" maxlength="30"/>
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<th class="tablebg7" colspan="2">
									<input class="button2" type="submit" style="margin-right:10px;" value="修改"/>
									<input class="button2" type="reset" style="margin-right:10px;" value="重置"/>
								</th>
							</tr>
						</table>
					</form>	
				</td>
			</tr>
		</table>
		<%@include file="foot.jsp"%>
	</body>
</html>