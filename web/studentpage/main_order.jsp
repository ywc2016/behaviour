<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<%@page import="ielab.hibernate.DcExperiments"%>
<%@page import="ielab.hibernate.DcData"%>
<%@page import="ielab.util.StringUtils"%>
<%@include file="../comm.jsp"%>
<%
	DcExperiments exp=null;
	String retailerId="";
	int CurrentCycle=1;
	DcData data_last=null;
	DcData data_current=null;
	DcData data_DC=null;
	ArrayList<DcData> list_current=null;
	
	try{
		if(StringUtils.isEmpty(session.getAttribute("exp"))){
	out.println("读取session数据失败，");
	response.sendRedirect(basePath+"studentpage/login.jsp");
	return;
		}
		exp=(DcExperiments)session.getAttribute("exp");
		retailerId=(String)session.getAttribute("retailerId");
		CurrentCycle=(Integer)session.getAttribute("CurrentCycle");
		data_last=(DcData)session.getAttribute("data_last");
		data_current=(DcData)session.getAttribute("data_current");
		data_DC=(DcData)session.getAttribute("data_DC");
		list_current=(ArrayList<DcData>)session.getAttribute("list_current");
	}catch(Exception e){
		out.println("读取session数据失败，");
		response.sendRedirect(basePath+"studentpage/login.jsp");
		return;
	}
	
	String title="";
	
	try{
		title="你好，零售商"+retailerId+"，恭喜你登陆成功，进入实验界面，";
		title+="目前为实验的第"+CurrentCycle+"期。";
	//	title+="目前为实验的第"+CurrentCycle+"期,实验总共有"+exp.getDcParameters().getTotalCycle()+"期。";		
	}catch(Exception e){
		out.println("生成页面数据失败，");
		response.sendRedirect(basePath+"studentpage/login.jsp");
		return;
	}
%>
<html>
<head>
<title>DC实验主页面－发送订单</title>

<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
<body onload="timer()">
	<table width="1000" border="0" align="center" cellpadding="0"
		cellspacing="0" background="images/top_back.jpg" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-39" data-genuitec-path="/behaviourDC/WebRoot/studentpage/main_order.jsp">
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
	<table width="1000" border="0" align="center" cellpadding="5"
		cellspacing="6" class="table19">
		<tr>
			<td valign="top">
				<div id="decision" align="center" style="margin-top:2em;">

					<table cellpadding="0" cellspacing="0"
						style="margin-bottom: 0.5em; margin-top: 1em;" width="360"
						height="137">

						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>

						<tr>
							<th height="3" align="left" style="line-height:50px;"><font
								size="5" color="#0000ff" face="黑体">请提交本期的订单量：</font></th>
							<td align="left"><input class="input1" size="12"
								maxlength="3" id="order" name="order"
								check="^[0-9]*[1-9][0-9]*$" warning="订单量应该为正整数！" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td align="right"><input class="button3"
								style="height:30px;width:80px" type="button" value="提交订单量"
								onclick="submitform()" /></td>
						</tr>
					</table>
					<br> <img alt="背景logo" src="images/dc-back.jpg" width="530"
						height="150">
				</div>
			</td>
		</tr>
		<tr>
			<td height="19" valign="top"></td>
			<td valign="top">
				<div id="backLogo" align="center"></div>
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
<script language="javascript" src="js/main_order.js"></script>
</html>