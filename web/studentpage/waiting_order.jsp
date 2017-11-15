<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<%@page import="ielab.hibernate.DcExperiments"%>
<%@page import="ielab.util.StringUtils"%>
<%@include file="../comm.jsp"%>
<%
	DcExperiments exp = null;
	String retailerId = "";
	int CurrentCycle = 1;

	try {
		if (StringUtils.isEmpty(session.getAttribute("exp"))) {
			out.println("读取session数据失败，");
			response.sendRedirect(basePath + "studentpage/login.jsp");
			return;
		}
		exp = (DcExperiments) session.getAttribute("exp");
		retailerId = (String) session.getAttribute("retailerId");
		CurrentCycle = (Integer) session.getAttribute("CurrentCycle");
	} catch (Exception e) {
		out.println("读取session数据失败，");
		response.sendRedirect(basePath + "studentpage/login.jsp");
		return;
	}

	String title = "";

	try {
		title = "你好，零售商" + retailerId + "，恭喜你登陆成功，进入实验界面，";
		title += "目前为实验的第" + CurrentCycle + "期。";
		//	title+="目前为实验的第"+CurrentCycle+"期,实验总共有"+exp.getDcParameters().getTotalCycle()+"期。";
		title += "请耐心等待其它用户提交订单。";
	} catch (Exception e) {
		out.println("生成页面数据失败，");
		response.sendRedirect(basePath + "studentpage/login.jsp");
		return;
	}
%>
<html>
<head>
<base href="<%=basePath%>">
<title>DC等待页面－发送订单等待页面</title>
<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
<!-- 加载时就执行timer()函数定时刷新页面 -->
<body onload="timer()">
	<table width="1000" border="0" align="center" cellpadding="0"
		cellspacing="0" background="images/top_back.jpg" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-41" data-genuitec-path="/behaviourDC/WebRoot/studentpage/waiting_order.jsp">
		<tr>
			<td><img src="images/top.jpg" width="1000" height="67" /></td>
		</tr>
	</table>
	<table width="1000" height="27" border="0" align="center"
		cellpadding="0" cellspacing="0" background="images/top_menu.gif">
		<tr>
			<td width="88" background="images/top_menu_3.gif">
				<div align="center">
					<a href="servlet/transform"><span class="black">实验主页面</span> </a>
				</div>
			</td>
			<td width="2"><img src="images/top_menu4.gif" width="2"
				height="24" /></td>
			<td width="88">
				<div align="center">
					<a href="studentpage/historyData.jsp"><span class="black">查看历史数据</span>
					</a>
				</div>
			</td>
			<td width="2"><img src="images/top_menu4.gif" width="2"
				height="24" /></td>
			<td width="2">&nbsp;</td>
			<td width="61">&nbsp;</td>
			<td width="2">&nbsp;</td>
			<td width="61">&nbsp;</td>
			<td width="2">&nbsp;</td>
			<td width="88">&nbsp;</td>
			<td width="2">&nbsp;</td>
			<td width="88">&nbsp;</td>
			<td width="2">&nbsp;</td>
			<td width="88">&nbsp;</td>
			<td width="2">&nbsp;</td>
			<td width="250">&nbsp;</td>
			<td width="78"><a href="studentpage/logout.jsp"><img
					src="images/exit.gif" width="69" height="16" /></a></td>
		</tr>
	</table>
	<table width="1000" height="34" border="0" align="center"
		cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
		<tbody>
			<tr>
				<td width="70%">
					<div align="left" id="title">
						<%=title%>
					</div>
				</td>
				<td width="30%">
					<div align="right" id="timer"
						style="font: bold;color: red;font-size: 20px;"></div>
				</td>
			</tr>
		</tbody>
	</table>
	<table width="1000" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td height="3"></td>
		</tr>
	</table>
	<table width="1000" height="450" border="0" align="center"
		cellpadding="0" cellspacing="5" class="table19">
		<tr>
			<td valign="top">
				<div id="waitingRetailers"
					style="height:200;font: large;color: red;"></div>
				<div id="waitingImage">
					<img src="images/wait.gif"></img>
				</div>
			</td>
		</tr>
	</table>
	<table width="1000" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td height="7"></td>
		</tr>
	</table>
	<table width="1000" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td height="3" bgcolor="#CCCCCC"></td>
		</tr>
		<tr>
			<td height="40">
				<div align="center">
					Copyright 2008-2009 All Right Reserved | 清华大学工业工程系 北京林森科技有限公司 <br />

				</div>
			</td>
		</tr>
	</table>
	<p></p>
</body>
<script language="javascript" src="js/waiting_order.js"></script>
</html>