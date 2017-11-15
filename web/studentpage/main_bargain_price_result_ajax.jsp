<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.*" %>
<%@page import="ielab.hibernate.*" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.util.Date" %>
<%@include file="../comm.jsp" %>
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

    String identity = null;
    BargainMatch bargainMatch = null;
    BargainData bargainData = null;
    BargainParameter bargainParameter = null;

    if (bargainExperiments.getExperimentState() == 0) {
        bargainMatch = bargainMatchDao.findByKey(bargainParticipant.getMatchId());

        identity = bargainMatch.getParticipantId().equals(bargainParticipant.getId()) ? "first" : "second";

        bargainData = bargainDataDao.findByKey(bargainMatch.getCurrentDataId());

        bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId());
    }
    //处理不同的action
    if (action.equals("timer")) {

        int status = bargainExperiments.getExperimentState();
        String participantStatus = bargainParticipant.getStatus();

        JSONObject J_return = new JSONObject();
        J_return.put("action", action);

        if (bargainExperiments.getExperimentState() == 0) {//未结束
            //	int participantId = (int) session
            //			.getAttribute("participantId");
            if (bargainParticipant.getStatus().equals("离线")) {
                J_return.put("status", "离线");
            } else if (bargainParticipant.getStatus().equals("空闲中")) {
                J_return.put("status", "空闲中");
            } else if (bargainParticipant.getStatus().equals("谈判中")) {

                if (identity.equals("first")) {
                    if (bargainMatch.getParticipantStatus().equals("出价中")) {
                        J_return.put("status", "出价中");
                    } else if (bargainMatch.getParticipantStatus().equals("出价完毕")) {
                        J_return.put("status", "出价完毕");

                    } else if (bargainMatch.getParticipantStatus().equals("回应出价")) {
                        J_return.put("status", "回应出价");
                    }
                } else {//第二出价者
                    if (bargainMatch.getSecomdParticipantStatus().equals("出价中")) {
                        J_return.put("status", "出价中");
                    } else if (bargainMatch.getSecomdParticipantStatus().equals("出价完毕")) {
                        J_return.put("status", "出价完毕");

                    } else if (bargainMatch.getSecomdParticipantStatus().equals("回应出价")) {
                        J_return.put("status", "回应出价");
                    }
                }

            }

            //倒计时提示
            if (bargainMatch.getBeginTime() != null) {
                long leftSeconds = (bargainParameter.getOneRoundTime()
                        - (new Date().getTime() - bargainMatch.getBeginTime().getTime()) / 1000) >= 0
                        ? (bargainParameter.getOneRoundTime()
                        - (new Date().getTime() - bargainMatch.getBeginTime().getTime()) / 1000)
                        : 0;
                J_return.put("leftSeconds", leftSeconds);
            }

        } else {//已结束
            J_return.put("status", "谈判完毕");
        }
        out.clear();
        out.println(J_return);
        return;

    } else if (action.equals("finishCheck")) {
        if (identity.equals("first")) {
            bargainMatch.setParticipantStatus("匹配结束");
        } else if (identity.equals("second")) {
            bargainMatch.setSecomdParticipantStatus("匹配结束");
        }
        //检查match的状态
        if (bargainMatch.getParticipantStatus().equals("匹配结束")
                && bargainMatch.getSecomdParticipantStatus().equals("匹配结束")) {
            bargainMatch.setStatus("已完成");
        }

        bargainParticipant.setStatus("空闲中");
        bargainParticipant.setMatchId(null);
        bargainParticipantDao.update(bargainParticipant);

        bargainMatchDao.update(bargainMatch);

		/* //判断该用户是否已经完成所有的谈判,若是则修改该用户的status为谈判完毕
		if (bargainMatchDao.isParticipantFinishAllMatch(bargainParticipant.getId(),
				bargainExperiments.getId())) {
			bargainParticipant.setStatus("谈判完毕");
			bargainParticipantDao.update(bargainParticipant);
		} */

        //判断整个实验是否结束
        if (bargainExperimentsDao.isFinished(bargainExperiments.getId())) {
            bargainExperiments.setExperimentState(1);//代表已结束
            bargainExperimentsDao.update(bargainExperiments);

            JSONObject J_return = new JSONObject();
            J_return.put("action", action);
            J_return.put("status", "谈判完毕");
            out.clear();
            out.println(J_return);
        }

        JSONObject J_return = new JSONObject();
        J_return.put("action", action);
        out.clear();
        out.println(J_return);
    } else {
        out.clear();
        out.println("错误的操作参数！");
        return;
    }
%>