<%@ page language="java" pageEncoding="UTF-8"%>
<%@include file="../comm.jsp"%>
<html>
	<head>
		<title>DC实验管理员登录页面</title>
		<script language="javascript" src="js/adminLogin.js"></script>
	<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
	<body onkeypress="enterHandler(event);">
		<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0"
			background="images/top_back.jpg" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-8" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminLogin.jsp">
			<tr>
				<td>
					<img src="images/top.jpg" width="1000" height="67" />
				</td>
			</tr>
		</table>
		<table width="1000" height="27" border="0" align="center" cellpadding="0" cellspacing="0"
			background="images/top_menu.gif">
			<tr>
				<td width="88" background="images/top_menu_3.gif">
					<div align="center">
						<a href="javascript:void(0);"><span class="black">管理员登录</span> </a>
					</div>
				</td>
				<td width="2">
					<img src="images/top_menu4.gif" width="2" height="24" />
				</td>
				<td width="88">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="61">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="61">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="61">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="88">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="88">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="88">
					&nbsp;
				</td>
				<td width="2">
					&nbsp;
				</td>
				<td width="212">
					&nbsp;
				</td>
				<td width="78">
					&nbsp;
				</td>
				<td width="57">
					&nbsp;
				</td>
			</tr>
		</table>
		<table width="1000" height="34" border="0" align="center" cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
			<tbody>
				<tr>
					<td width="70%">
						<div align="left" id="title">
							您好，欢迎您进入实验管理界面，请输入您的账号和密码登录。
						</div>
					</td>
					<td width="30%">
					</td>
				</tr>
			</tbody>
		</table>
		<table width="1000" height="450" align="center" background="images/adminlogin.jpg">
			<tr>
				<td width="5%">
				</td>
				<td>
					<table width="216" border="0" cellpadding="0" cellspacing="1">
						<tr>
							<td height="25">
								<div align="center">
									用户名：
								</div>
							</td>
							<td height="25">
								<div align="left">
									<input style="width: 10em;" type="text" id="username" name="username">
								</div>
							</td>
						</tr>
						<tr>
							<td height="25">
								<div align="center">
									密&nbsp;&nbsp;&nbsp;码：
								</div>
							</td>
							<td height="25">
								<div align="left">
									<input style="width: 10em;" type="password" id="password" name="password">
								</div>
							</td>
						</tr>
						<tr>
							<td height="30" colspan="2" align="center">
								<div align="center">
									<input id="denglu" name="denglu" type="button" class="button2" value="登 陆" onclick="submitform();"/>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
		<%@include file="foot.jsp"%>
	</body>
</html>