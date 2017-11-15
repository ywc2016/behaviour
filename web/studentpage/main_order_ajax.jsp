<%@page import="ielab.hibernate.BargainParticipant"%>
<%@page import="ielab.dao.BargainParticipantDao"%>
<%@page import="ielab.hibernate.BargainExperiments"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="ielab.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ielab.hibernate.DcExperiments"%>
<%@page import="java.util.Date"%>
<%@page import="ielab.hibernate.DAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="ielab.hibernate.DcData"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="ielab.util.UpdateCycle"%>
<%
	Log logger = LogFactory.getLog("lab.util.*");
	//取得action参数
	String action = null;
	try {
		if (StringUtils.isNotEmpty(request.getParameter("action"))) {
	action = request.getParameter("action");
		} else {
	out.clear();
	out.println("获取操作参数失败！");
	return;
		}
	} catch (Exception e) {
		out.clear();
		out.println("取得request值失败!");
		return;
	}
	DAO DAO=new DAO();
	DcExperiments exp = null;
	String retailerId = "";
	int CurrentCycle = 1;
	
	BargainExperiments bargainExperiments =null;
	
	String experimentType = session.getAttribute("experimentType").toString();
	
	try {
		if (StringUtils.isEmpty(session.getAttribute("exp"))) {
	out.clear();
	out.println("读取session数据失败，session过期，请重新登陆！");
	return;
		} else {
	
	if(experimentType.equals("game")){
		
		exp = (DcExperiments) session.getAttribute("exp");
		retailerId = session.getAttribute("retailerId").toString();
		CurrentCycle = (Integer) session.getAttribute("CurrentCycle");
	}else if(experimentType.equals("bargain")){
		bargainExperiments = (BargainExperiments)session.getAttribute("exp");
		String participantId = session.getAttribute("participantId").toString();
		
	}
		}
	} catch (Exception e) {
		out.clear();
		out.println("读取session数据失败，session过期，请重新登陆！");
		return;
	}

	//处理不同的action
	if (action.equals("order")) {
		try {
	String order = StringUtils.trim(request.getParameter("order"));
	

	//取得当前周期零售商的数据
	DcData data_current = null;
	ArrayList<DcData> list = DAO
	.selectByHOL("from DcData as model where model.retailerId="
	+ retailerId + " and model.dcExperiments.id=" + exp.getId()
	+ " and model.cycle=" + CurrentCycle);
	if (list.size() == 1) {
		data_current = (DcData) list.get(0);
	} else {
		out.clear();
		out.println("读取该零售商数据失败!");
		return;
	}

	if (data_current.getTag() == 0) {
		data_current.setOrderOut(Integer.parseInt(order));			
		
		data_current.setBegainTime2(new Date(System.currentTimeMillis()));
		data_current.setTag(1);
		DAO.update(data_current);
		
	}
	JSONObject J_return = new JSONObject();
	J_return.put("action", action);
	J_return.put("status", "success");
	out.clear();
	out.println(J_return);
	return;
		} catch (Exception e) {
	out.clear();
	out.println("提交订单失败，请重新提交!");
	return;
		}
	} else if (action.equals("timer")) {
		if(experimentType.equals("game")){
	DcData data_current = null;
	String status = "";
	String remainingTime = "";
	try {
		ArrayList<DcData> list = null;
		//取得本周期的数据
		String strHQL = "from DcData as model where model.retailerId=" + retailerId
		+ " and model.dcExperiments.id=" + exp.getId() + " and model.cycle="+ CurrentCycle;
		list = DAO.selectByHOL(strHQL);
	
		if (list.size() == 1) {
	data_current = list.get(0);
		} else {
	out.clear();
	out.println("取到的零售商数据错误！");
	return;
		}
	
		if (data_current.getTag() == 1) {//如果当前周期该用户已经提交了订单信息，则输出finished
	status = "finished";
		} else if (CurrentCycle > 1) {//如果当前周期大于第一周期，则计算还剩多少时间
	Date nowDay = new Date(System.currentTimeMillis() - exp.getDcParameters().getCycleTime());
	if (nowDay.before(data_current.getBegainTime1())) {//如果该周期的时间还未到，则输出还剩多少秒
		long remain = (data_current.getBegainTime1().getTime() - nowDay
		.getTime()) / 1000;
		status = "unfinished";
		remainingTime = "还剩" + remain / 60 + "分"
		+ (remain - (remain / 60) * 60) + "秒";
	} else {//该周期实验时间到，则计算机默认提交本期数据，调用UpdateCycle更新本期数据
		//UpdateCycle,该函数更新所有的实验数据,该函数返回一个string型参数，分别为finished和updating
		//		data_current.setBegainTime2(new Date(System.currentTimeMillis()));
		if(data_current.getTag()==0){
	//logger.error("零售商"+data_current.getRetailerId()+"在主页面中，检测到状态为0，负责更新数据。");
	status = UpdateCycle.updateNowCycle_order(exp, CurrentCycle);
		}else{
		 	status = "finished";
		}
	}
		} else {//如果当前周期为第一周期，则不限时间，输出为limitless
	status = "unfinished";
	remainingTime = "（第一期不限时间）";
		}
	
		JSONObject J_return = new JSONObject();
		J_return.put("action", action);
		J_return.put("status", status);
		J_return.put("remainingTime", remainingTime);
	
		out.clear();
		out.println(J_return);
		return;
	
	} catch (Exception e) {
		out.clear();
		out.println("获取本期实验剩余时间失败!");
		return;
	}
		}else if(experimentType.equals("bargain")){
		
	int status =bargainExperiments.getExperimentState();
		
	JSONObject J_return = new JSONObject();
	J_return.put("action", action);
	
	if(status == 0){//未结束
		int participantId = (int)session.getAttribute("participantId");		
		BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
		BargainParticipant bargainParticipant = bargainParticipantDao.findByKey(participantId);
		
		if(bargainParticipant.getStatus().equals("离线")){
			bargainParticipant.setStatus("空闲中");
			bargainParticipantDao.update(bargainParticipant);
			J_return.put("status", "空闲中");
		}else if(bargainParticipant.getStatus().equals("空闲中")){
			J_return.put("status", "空闲中");
		}else if(bargainParticipant.getStatus().equals("谈判中")){
			J_return.put("status", "谈判中");
			//J_return.put("remainingTime", remainingTime);
		}
	
	}else{
	
	}
	out.clear();
	out.println(J_return);                                
	return;
		}
	} else {
		out.clear();
		out.println("错误的操作参数！");
		return;
	}
%>