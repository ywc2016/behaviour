<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page import="ielab.hibernate.Admin"%>
<%@page import="java.util.Date"%>
<%@page import="ielab.hibernate.DAO"%>
<%@page import="ielab.util.StringUtils"%>
<%@include file="../comm.jsp"%>
<%
	Admin admin=null;
	DAO DAO=new DAO();
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
%>
<%
	String errors = "";
	String reqestStr ="";
	
	reqestStr = request.getParameter("username");
	if ((reqestStr == null)||(reqestStr == "")) {
		errors += "<tr><th width=\"40%\">用户名：</th><td width=\"60%\">用户名为空</td></tr>";
	}else{
		admin.setUsername(reqestStr);
	}
	
	reqestStr = request.getParameter("password2");
	if (!(reqestStr.equals(request.getParameter("password")))) {
		errors += "<tr><th width=\"40%\">确认密码：</th><td width=\"60%\">确认密码与密码不符</td></tr>";
	}else{
		admin.setPassword(reqestStr);
	}
	
	reqestStr = request.getParameter("name");
	if (reqestStr == null) {
		errors += "<tr><th width=\"40%\">姓名：</th><td width=\"60%\">姓名为空</td></tr>";
	}else{
		admin.setName(reqestStr);
	}
	
	reqestStr = request.getParameter("school");
	if (reqestStr == null) {
		errors += "<tr><th width=\"40%\">学校：</th><td width=\"60%\">学校为空</td></tr>";
	}else{
		admin.setUniversity(reqestStr);
	}
	
	String EL = "^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$";
	reqestStr = request.getParameter("email");
	if ((reqestStr == null) || (reqestStr == "")) {//判断email地址的有效性
		errors += "<tr><th width=\"40%\">Email地址：" + reqestStr + "</th><td width=\"60%\">Email地址不能为空</td></tr>";
	} else if (!(reqestStr.matches(EL))) {//判断email地址的有效性
		errors += "<tr><th width=\"40%\">Email地址：" + reqestStr + "</th><td width=\"60%\">Email地址格式不正确</td></TR>";
	}else{
		admin.setEmail(reqestStr.toString());
	}
	
	reqestStr = request.getParameter("tel");
	if (reqestStr == null) {
		errors += "<tr><th width=\"40%\">联系电话：</th><td width=\"60%\">联系电话为空</td></tr>";
	}else{
		admin.setTel(reqestStr);
	}
	
	if (errors == "") {
		admin.setRegistertime(new Date());
		admin.setSupadmin(new Byte("0"));
		try{
			DAO.update(admin);
		}catch(Exception e){
			errors += "<tr><th width=\"40%\">保存至数据库失败：</th><td width=\"60%\">"+e.toString()+"</td></tr>";
		}
	}
%>
<html>
	<head>
		<title>DC实验管理界面－修改管理员信息</title>
	<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
		
	<body>
		<%@include file="head.jsp"%>
		<script type="text/javascript" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-3" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminChangePsw_do.jsp">
			var v=document.getElementById("adminChangePsw");
			v.className="menuSelected";
		</script>
		<table width="1000" height="34" border="0" align="center" cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
			<tbody>
				<tr>
					<td width="70%">
						<div align="left" id="title">
							<%
							if (errors != "") {
								out.print("修改失败");
							}else{
								out.print("修改成功");
							}
							 %>
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
						<%
						if (errors != "") {
							out.print("修改失败信息");
						}else{
							out.print("修改后的管理员信息");
						}
						 %>
					</span>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<table style="width: 300" border="0" cellpadding="0" cellspacing="0" class="dataBorderedTable">
						<%
						if (errors != "") {
							out.print(errors);
						}else{
						%>
						<tr>
							<th width="40%">
								用户名：
							</th>
							<td width="60%">
								<input readonly="readonly" value="<%=admin.getUsername().toString()%>" id="username" name="username" style="width: 12em" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<th width="5%">
								密&nbsp;&nbsp;&nbsp;码：
							</th>
							<td>
								<input readonly="readonly" value="<%=admin.getPassword().toString()%>" type="password" id="password" name="password" style="width: 12em" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<th width="5%">
								姓&nbsp;&nbsp;&nbsp;名：
							</th>
							<td>
								<input readonly="readonly" value="<%=admin.getName().toString()%>" id="name" name="name" style="width: 12em" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<th width="5%">
								学&nbsp;&nbsp;&nbsp;校：
							</th>
							<td>
								<input readonly="readonly" value="<%=admin.getUniversity().toString()%>" id="school" name="school" style="width: 12em" maxlength="50"/>
							</td>
						</tr>
						<tr>
							<th width="5%">
								Email地址：
							</th>
							<td>
								<input readonly="readonly" value="<%=admin.getEmail().toString()%>" id="email" name="email" style="width: 12em" maxlength="100"/>
							</td>
						</tr>
						<tr>
							<th width="5%">
								联系电话：
							</th>
							<td>
								<input readonly="readonly" value="<%=admin.getTel().toString()%>" id="tel" name="tel" style="width: 12em" maxlength="30"/>
							</td>
						</tr>
						<%
						}
						%>
					</table>
					<table>
						<tr>
							<th class="tablebg7" colspan="2">
							<%
							if (errors != "") {
							%>
							<a href="javascript:history.go(-1);">返回重新修改</a>
							<%
							}else{
							%>
							<a href="<%=basePath+"adminpage/adminLogin.jsp"%>">转入登陆页面</a>
							<%
							}
							%>
							</th>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<%@include file="foot.jsp"%>
	</body>
</html>