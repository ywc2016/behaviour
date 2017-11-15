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
<%DAO DAO=new DAO();
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

	DcExperiments exp = null;
	String retailerId = "";
	int CurrentCycle = 1;
	try {
		if (StringUtils.isEmpty(session.getAttribute("exp"))) {
			out.clear();
			out.println("读取session数据失败，session过期，请重新登陆！");
			return;
		} else {
			exp = (DcExperiments) session.getAttribute("exp");
			retailerId = session.getAttribute("retailerId").toString();
			CurrentCycle = (Integer) session.getAttribute("CurrentCycle");
		}
	} catch (Exception e) {
		out.clear();
		out.println("读取session数据失败，session过期，请重新登陆！");
		return;
	}

	if (action.equals("timer")) {
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
		
			if (CurrentCycle > 1) {//如果当前周期大于第一周期，则计算还剩多少时间
				Date beginTime=data_current.getBegainTime1();
			//	if (StringUtils.isNotEmpty(data_current.getBegainTime2())) {//如果当前周期该用户已经提交了订单信息，则计算售价剩余时间
			//		beginTime=data_current.getBegainTime2();
			//	}
				Date nowDay = new Date(System.currentTimeMillis() - exp.getDcParameters().getCycleTime());
				if (nowDay.before(beginTime)) {//如果该周期的时间还未到，则输出还剩多少秒
					long remain = (beginTime.getTime() - nowDay
							.getTime()) / 1000;
					status = "unfinished";
					remainingTime = "还剩" + remain / 60 + "分"
							+ (remain - (remain / 60) * 60) + "秒";
				} else {//该周期实验时间到，则计算机默认提交本期数据，调用UpdateCycle更新本期数据
					 status = "finished";
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
	} else {
		out.clear();
		out.println("错误的操作参数！");
		return;
	}
%>