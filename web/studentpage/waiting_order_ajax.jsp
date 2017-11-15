<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="ielab.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ielab.hibernate.DcExperiments"%>
<%@page import="java.util.Date"%>
<%@page import="ielab.hibernate.DAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="ielab.hibernate.DcData"%>
<%@page import="ielab.util.UpdateCycle"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%
	Log logger = LogFactory.getLog("lab.util.*");
	//取得action参数
	String action = null;
	DAO DAO=new DAO();
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

	//处理不同的action
	if (action.equals("timer")) {
		DcData data_current = null;
		String status = "";
		String remainingRetailers = "";
		String remainingTime = "";

		try {
			ArrayList<DcData> list = null;
			//取得本周期的数据
			String strHQL = "from DcData as model where model.retailerId=" + retailerId
					+ " and model.dcExperiments.id=" + exp.getId() + " and model.cycle="
					+ CurrentCycle;
			list = DAO.selectByHOL(strHQL);
			if (list.size() == 1) {
				data_current = list.get(0);
			} else {
				out.clear();
				out.println("取到本周期零售商数据错误！");
				return;
			}

			if (data_current.getTag() != 1) {//如果当前零售商状态不是处于等待其他用户提交订单，则输出finished，转入重新分配
				status = "finished";
			} else {
				if (CurrentCycle > 1) {//如果当前周期大于第一周期，则计算还剩多少时间
					Date nowDay = new Date(System.currentTimeMillis()
							- exp.getDcParameters().getCycleTime());
					if (nowDay.before(data_current.getBegainTime1())) {
						//如果该周期的时间还未到，则找出该期尚未决策的Retailer，并输出还剩多少时间。
						list = DAO
								.selectByHOL("from DcData as model where model.retailerId<>0 and model.tag=0 and model.dcExperiments.id="
										+ exp.getId()+ " and model.cycle="+ CurrentCycle);
						if (list.size() > 0) {//如果还有用户没有决策
							status = "unfinished";
							for (int i = 0; i < list.size(); i++) {
								remainingRetailers += "零售商" + list.get(i).getRetailerId()+ "<br>";
							}
							long remain = (data_current.getBegainTime1().getTime() - nowDay.getTime()) / 1000;
							remainingTime += "还剩" + remain / 60 + "分"	+ (remain - (remain / 60) * 60) + "秒";
						} else {//如果所有用户均已经决策，则调用函数更新本周期数据，进入下一周期
							//UpdateCycle该函数更新所有的实验数据,该函数返回一个string型参数，分别为finished和updating
							//logger.error("零售商"+data_current.getRetailerId()+"在等待页面中，所有用户均已提交，检测到状态为1，负责更新数据。");
							status = UpdateCycle.updateNowCycle_order(exp, CurrentCycle);
						}
					} else {//该周期实验结束，则调用函数更新本周期的数据，进入下一周期
						//UpdateCycle,该函数更新所有的实验数据,该函数返回一个string型参数，分别为finished和updating
						//logger.error("零售商"+data_current.getRetailerId()+"在等待页面中，时间到达，检测到状态为1，负责更新数据。");
						status = UpdateCycle.updateNowCycle_order(exp, CurrentCycle);
					}
				} else {//如果当前周期为第一周期，则不限时间。
					list = DAO
							.selectByHOL("from DcData as model where model.retailerId<>0 and model.tag=0 and model.dcExperiments.id="
									+ exp.getId() + " and model.cycle=" + CurrentCycle);
					if (list.size() > 0) {//如果还有用户没有决策
						status = "unfinished";
						for (int i = 0; i < list.size(); i++) {
							remainingRetailers += "零售商" + list.get(i).getRetailerId()	+ "<br>";
						}
						remainingTime = "（第一期不限时间）";
					} else {//如果所有用户均已经决策，则调用函数更新本周期数据，进入下一周期
						//UpdateCycle,该函数更新所有的实验数据,该函数返回一个string型参数，分别为finished和updating
						status = UpdateCycle.updateNowCycle_order(exp, CurrentCycle);
					}
				}
			}

			JSONObject J_return = new JSONObject();
			J_return.put("action", action);
			J_return.put("status", status);
			J_return.put("remainingRetailers", remainingRetailers);
			J_return.put("remainingTime", remainingTime);

			out.clear();
			out.println(J_return);
			return;
		} catch (Exception e) {
			out.clear();
			out.println("获取未提交订单的零售商和本期实验剩余时间失败!");
			return;
		}
	} else {
		out.clear();
		out.println("错误的操作参数！");
		return;
	}
%>