<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page import="ielab.hibernate.DcExperiments"%>
<%@page import="ielab.util.StringUtils"%>
<%@page import="ielab.hibernate.DcData"%>
<%@page import="ielab.hibernate.DAO"%>
<%@page import="ielab.util.Pager"%>
<%@page import="ielab.util.Decimal"%>
<%@include file="../comm.jsp"%>
<%DAO DAO=new DAO();
	DcExperiments exp=null;
	String retailerId="";
	int CurrentCycle=1;
	ArrayList<DcData> list_history=null;
	
	try{
		if(StringUtils.isEmpty(session.getAttribute("exp"))){
			out.println("读取session数据失败，");
			response.sendRedirect(basePath+"studentpage/login.jsp");
			return;
		}
		exp=(DcExperiments)session.getAttribute("exp");
		retailerId=(String)session.getAttribute("retailerId");
		CurrentCycle=(Integer)session.getAttribute("CurrentCycle");
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
<%
	Pager pager = new Pager();

	String selectValue = "";
	String strsql = " from DcData as model where model.dcExperiments.id=" + exp.getId() + " and model.retailerId=" +retailerId+" and model.tag=2";
	String strorderby = "  order by model.id desc ";

	try{
		if (StringUtils.isEmpty(request.getParameter("action"))) {
			
		}else if(request.getParameter("action").equals("pager")){
			//如果action为空，则直接显示数据即可,默认按id号排序	
			if (StringUtils.isNotEmpty(session.getAttribute("pagersqlstr"))) {
				strsql = session.getAttribute("pagersqlstr").toString();
			}
	
			if (StringUtils.isNotEmpty(session.getAttribute("pagersqlorderby"))) {
				strorderby = session.getAttribute("pagersqlorderby").toString();
			}
	
			if (StringUtils.isNotEmpty(request.getParameter("currentPage"))) {
				pager.setCurrentPage(Integer.parseInt(request.getParameter("currentPage")));
			}
	
			int totalRows = ((Integer) DAO.selectByHOL("select count(*) " + strsql)
					.iterator().next()).intValue();
			pager.init(totalRows);
	
			if (StringUtils.isEmpty(request.getParameter("pagerAction"))) {
			} else if (request.getParameter("pagerAction").equals("nextpager")) {
				pager.next();
				//out.println(pager.getCurrentPage());
			} else if (request.getParameter("pagerAction").equals("previouspager")) {
				pager.previous();
			} else if (request.getParameter("pagerAction").equals("firstpager")) {
				pager.first();
			} else if (request.getParameter("pagerAction").equals("lastpager")) {
				pager.last();
			}
		} else if (request.getParameter("action").equals("order")) {	
			if (StringUtils.isNotEmpty(session.getAttribute("pagersqlstr"))) {
				strsql = session.getAttribute("pagersqlstr").toString();
			}
			if (StringUtils.isNotEmpty(request.getParameter("orderby"))) {
				strorderby = " order by model." + request.getParameter("orderby").toString();
			}
			//out.println(strsql);
		}
	}catch(Exception e){
		out.println("action操作失败!");
		return;
	}
	
	int totalRows = ((Integer) DAO.selectByHOL("select count(*) " + strsql)
			.iterator().next()).intValue();
	pager.init(totalRows);
	
	try{
		session.setAttribute("pagersqlstr", strsql);
		session.setAttribute("pagersqlorderby", strorderby);
		strorderby+=" ,model.id desc ";
		list_history = DAO.selectLimitByHOL(selectValue+strsql+strorderby, pager.getSearchFrom(), pager
				.getPageSize());
	}catch(Exception e){
		out.println("action操作失败!");
		return;
	}
%>
<html>
	<head>
		<base href="<%=basePath%>">
		<title>DC查看历史数据页面</title>
		<script language="javascript" src="js/historyData.js"></script>
	<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
	<body onload="timer()">
		<form action="" name="form1" method="post"  data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-23" data-genuitec-path="/behaviourDC/WebRoot/studentpage/historyData.jsp"/>
		<input type="hidden" id="action" name="action" value="">
		<input type="hidden" id="orderby" name="orderby" value="id desc">
		<input type="hidden" id="pagerAction" name="pagerAction" value="">
		<input type="hidden" id="currentPage" name="currentPage" value="<%=pager.getCurrentPage()%>">
		<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0" background="images/top_back.jpg">
			<tr>
				<td>
					<img src="images/top.jpg" width="1000" height="67" />
				</td>
			</tr>
		</table>
		<table width="1000" height="27" border="0" align="center" cellpadding="0" cellspacing="0" background="images/top_menu.gif">
			<tr>
				<td width="88">
					<div align="center">
						<a href="servlet/transform"><span class="black">实验主页面</span>
						</a>
					</div>
				</td>
				<td width="2">
					<img src="images/top_menu4.gif" width="2" height="24" />
				</td>
				<td width="88" background="images/top_menu_3.gif">
					<div align="center">
						<a href="studentpage/historyData.jsp"><span class="black">查看历史数据</span>
						</a>
					</div>
				</td>
				<td width="2">
					<img src="images/top_menu4.gif" width="2" height="24" />
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
				<td width="250">
					&nbsp;
				</td>
				<td width="78">
					<a href="studentpage/logout.jsp"><img src="images/exit.gif" width="69" height="16" /></a>
				</td>
			</tr>
		</table>
		<table width="1000" height="34" border="0" align="center" cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
			<tbody>
				<tr>
					<td width="70%">						
						<div align="left" id="title">
							<%=title%>
						</div>
					</td>
					<td width="30%">						
						<div align="right" id="timer" style="font: bold;color: red;font-size: 20px;">
	
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td height="3"></td>
			</tr>
		</table>
		<table width="1000" height="380" border="0" align="center" cellpadding="0" cellspacing="0" class="table19">
			<tr>
				<td valign="top">
					<table cellpadding="0" cellspacing="0" class="dataBorderedTable" width="1000" height="351">
						
						<tr>
							<td width="450" align="left"><font size="5"> 
								本期得分=100-<%=exp.getDcParameters().getInitialPurchasePrice()%>&times;缺货量-<%=exp.getDcParameters().getInitialSellingPrice()%>&times;剩货量 
							</font></td>							
						</tr>
						<tr>
							<td valign="top">
								<div id="lastCycleData" align="center">
									<strong><span style="color: green;"> 
										<font size="4">实验数据</font>
									</span></strong>
									<table cellpadding="0" cellspacing="0" class="dataBorderedTable" style="width:1000px;">
										<tr>
											<th>
												<a href="javascript:orderby('cycle desc');"><font color="black" style="font-weight: normal">周期</font></a>
											</th>
											<th style="background-color: skyblue">
												<a href="javascript:orderby('orderOut');"><font color="black" style="font-weight: normal">提交订单量</font></a>
											</th>
											<th style="background-color: skyblue">
												<a href="javascript:orderby('Guess');"><font color="black"  style="font-weight: normal">对手订单</font></a>
											</th>
											<th style="background-color: rgb(66, 180, 189);">
												<a href="javascript:orderby('goodsIn');"><font color="black" style="font-weight: normal">收货量</font></a>
											</th>
											<th style="background-color: rgb(66, 180, 189);">
												<a href="javascript:orderby('orderIn');"><font color="black" style="font-weight: normal">需求量</font></a>
											</th>											
											<th style="background-color: rgb(66, 180, 189);">
												<font color="black" style="font-weight: normal">缺货量</font>
											</th>
											<th style="background-color: rgb(66, 180, 189);">
												<font color="black" style="font-weight: normal">剩货量</font>
											</th>
											<th style="background-color: khaki">
												<a href="javascript:orderby('netIncome');"><font color="black">本期得分</font></a>
											</th>	
											
									</tr>
										<%
											if ((list_history != null) && (list_history.size() > 0)) {
												for (DcData d : list_history) {
										%>
										<tr class="noBgColor" onMouseOver="mouseOverColor(this);" onMouseOut="mouseOutColor(this);">
											<td><%=d.getCycle()%></td>
											<td><%=d.getOrderOut()%></td>
											<td><%=d.getBacklogCost()%></td>
											<td><%=Decimal.getDecimal(d.getGoodsIn(),1)%></td>
											<td><%=d.getOrderIn()%></td>
											<% if(Math.max(0,d.getOrderIn()-d.getGoodsIn())>0){
						
											 %>											
											<td><strong><font color="#ff0000"><%=Decimal.getDecimal(Math.max(0,d.getOrderIn()-d.getGoodsIn()),1)%></font><br></strong></td>
											<%}else{ %>					
											<td><%=Decimal.getDecimal(Math.max(0,d.getOrderIn()-d.getGoodsIn()),1)%></td>
											<%} %>
											<% if(Math.max(0,d.getGoodsIn()-d.getOrderIn())>0){						
											 %>											
											<td><strong><font color="#ff0000"><%=Decimal.getDecimal(Math.max(0,d.getGoodsIn()-d.getOrderIn()),1)%></font><br></strong></td>
											<%}else{ %>
											<td><%=Decimal.getDecimal(Math.max(0,d.getGoodsIn()-d.getOrderIn()),1)%></td>
											<%} %>											
											<td><%=Decimal.getDecimal(d.getNetIncome(),1)%></td>
										</tr>
										<%
											}
											}
										%>
							
										<%
											if (pager.getTotalPages() > 1) {
										%>
										<tr>
											<td colspan="15">
												<div class="buttonBar1">
													<label>
														第<%=pager.getCurrentPage()%>页/共<%=pager.getTotalPages()%>页（<%=pager.getTotalRows()%>条数据）
													</label>
													<input type="button" value="第一页" onclick="pager('firstpager')" />
													<input type="button" value="上一页"
														<%if(!pager.isHasPrevious())out.print( "disabled='disabled'");%>
														onclick="pager('previouspager')" />
													<input type="button" value="下一页"
														<%if(!pager.isHasNext())out.print( "disabled='disabled'");%> onclick="pager('nextpager')" />
													<input type="button" value="最后一页" onclick="pager('lastpager')" />
												</div>
											</td>
										</tr>
										<%
											}
										%>
									</table>
								</div>
							</td>
						</tr>
					</table>									
				</td>
			</tr>
		</table>	
		<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td height="7"></td>
			</tr>
		</table>
		<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td height="3" bgcolor="#CCCCCC"></td>
			</tr>
			<tr>
				<td height="40">
					<div align="center">
						Copyright 2008-2009 All Right Reserved | 清华大学工业工程系　北京林森科技有限公司
						<br />
						Designed By LWY 20080108
					</div>
				</td>
			</tr>
		</table>
		<p></p>
	</body>
</html>