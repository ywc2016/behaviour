<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.BargainDataDao" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.dao.BargainParameterDao" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.hibernate.*" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.sql.Timestamp" %>
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

    if (bargainParticipant.getStatus().equals("谈判中")) {
        bargainMatch = bargainMatchDao.findByKey(bargainParticipant.getMatchId());

        identity = bargainMatch.getParticipantId().equals(bargainParticipant.getId()) ? "first" : "second";

        bargainData = bargainDataDao.findByKey(bargainMatch.getCurrentDataId());

        bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId());
    }
    //处理不同的action
    if (action.equals("bargain")) {//提交谈判价格和谈判数量
        try {
            String price = StringUtils.trim(request.getParameter("price"));
            String quantity = StringUtils.trim(request.getParameter("quantity"));

            // 保存提交的数据

            bargainData.setFinishTime(new Timestamp(new Date().getTime()));
            bargainData.setMatchId(bargainMatch.getId());
            bargainData.setPrice(Double.parseDouble(price));
            bargainData.setQuantity(Integer.parseInt(quantity));
            bargainData.setParticipantId(bargainParticipant.getId());
            bargainDataDao.update(bargainData);

            //将match的参与者状态修改为出价完毕
            if (identity.equals("first")) {
                bargainMatch.setParticipantStatus("出价完毕");
                bargainMatch.setSecomdParticipantStatus("回应出价");
            } else {
                bargainMatch.setSecomdParticipantStatus("出价完毕");
                bargainMatch.setParticipantStatus("回应出价");
            }

            bargainMatchDao.update(bargainMatch);

            JSONObject J_return = new JSONObject();
            J_return.put("action", action);
            J_return.put("status", "success");
            out.clear();
            out.println(J_return);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("提交失败，请重新提交!");
            return;
        }
    } else if (action.equals("timer")) {

        int status = bargainExperiments.getExperimentState();
        String participantStatus = bargainParticipant.getStatus();
        JSONObject J_return = new JSONObject();
        J_return.put("action", action);

        if (bargainExperiments.getExperimentState() == 0) {//未结束
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
                    } else if (bargainMatch.getParticipantStatus().equals("查看结果")) {
                        J_return.put("status", "查看结果");
                    }
                } else {//第二出价者
                    if (bargainMatch.getSecomdParticipantStatus().equals("出价中")) {
                        J_return.put("status", "出价中");
                    } else if (bargainMatch.getSecomdParticipantStatus().equals("出价完毕")) {
                        J_return.put("status", "出价完毕");

                    } else if (bargainMatch.getSecomdParticipantStatus().equals("回应出价")) {
                        J_return.put("status", "回应出价");
                    } else if (bargainMatch.getSecomdParticipantStatus().equals("查看结果")) {
                        J_return.put("status", "查看结果");
                    }
                }

                //J_return.put("remainingTime", remainingTime);
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
        } else {//该参与者谈判已结束
            J_return.put("status", "谈判完毕");
        }
        out.clear();
        out.println(J_return);
        return;

    } else {
        out.clear();
        out.println("错误的操作参数！");
        return;
    }
%>