<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.BargainDataDao" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.hibernate.*" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
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

    //获取实验参数
    BargainParameter bargainParameter = bargainExperimentsDao
            .findBargainParameterByExperimentId(bargainExperiments.getId());

    //处理不同的action
    if (action.equals("timer")) {

        int status = bargainExperiments.getExperimentState();
        String participantStatus = bargainParticipant.getStatus();

        JSONObject J_return = new JSONObject();
        J_return.put("action", action);

        if (bargainExperiments.getExperimentState() == 0) {//未结束
            //	int participantId = (int) session
            //			.getAttribute("participantId");

            //判断整个实验是否结束
            if (bargainExperimentsDao.isFinished(bargainExperiments.getId())) {
                bargainExperiments.setExperimentState(1);//代表已结束
                bargainExperimentsDao.update(bargainExperiments);

                J_return.put("action", action);
                J_return.put("status", "谈判完毕");
                out.clear();
                out.println(J_return);
                return;
            }

            if (bargainParticipant.getStatus().equals("离线")) {
                bargainParticipant.setStatus("空闲中");
                bargainParticipantDao.update(bargainParticipant);
                J_return.put("status", "空闲中");
            } else if (bargainParticipant.getStatus().equals("空闲中")) {

                //首先判断当前谈判周期是否所有用户都进行了谈判
                List<BargainParticipant> bargainParticipantList = bargainParticipantDao
                        .findByPropertyEqual("experimentId", bargainExperiments.getId().toString(), "int");
                boolean flag = true;
                for (BargainParticipant bargainParticipant2 : bargainParticipantList) {
                    if (bargainParticipant2.getCurrentCycle() < bargainExperiments.getCurrentCycle()
                            || !bargainParticipant2.getStatus().equals("空闲中")) {
                        flag = false;
                    }
                }
                if (flag && bargainExperiments.getCurrentCycle() <= 2
                        * (bargainParameter.getNumberOfPerson() - 1)) {//都进行了谈判,且小于最大周期数,试验周期往后推1
                    bargainExperiments.setCurrentCycle(bargainExperiments.getCurrentCycle() + 1);
                    bargainExperimentsDao.update(bargainExperiments);
                    J_return.put("status", "空闲中");
                    out.clear();
                    out.println(J_return);
                    return;
                } else {
                    //判断当期谈判是否已经完成
                    if (bargainParticipant.getCurrentCycle() < bargainExperiments.getCurrentCycle()) {//当期还未完成
                        bargainParticipantDao.update(bargainParticipant);
                        // 匹配对手进行谈判,去数据库中搜索
                        bargainMatchDao = new BargainMatchDao();
                        BargainMatch bargainMatch = bargainMatchDao.findMatch(Integer.parseInt(participantId),
                                bargainExperiments.getId().intValue());
                        // TODO 查询判断所有的匹配是否已经结束,进入结束页面
                        if (bargainMatch == null) {//没有匹配结果,继续等待
                            // response.sendRedirect(basePath +
                            // "studentpage/main_bargain.jsp");
                            J_return.put("status", "空闲中");
                            out.clear();
                            out.println(J_return);
                            return;
                        }

                        //在控制台打印匹配到的参与者
                        BargainParticipant bargainParticipant1 = bargainParticipantDao
                                .findByKey(bargainMatch.getParticipantId());

                        BargainParticipant bargainParticipant2 = bargainParticipantDao
                                .findByKey(bargainMatch.getSecondParticipantId());

                        System.out.println("匹配成功!" + bargainParticipant1.getNumber() + "和"
                                + bargainParticipant2.getNumber());

                        bargainMatch.setStatus("谈判中");
                        bargainMatchDao.update(bargainMatch);

                        bargainParticipant = bargainParticipantDao.findByKey(Integer.parseInt(participantId));

                        bargainParticipantDao.update(bargainParticipant);

                        bargainMatch.setParticipantStatus("出价中");
                        bargainMatch.setSecomdParticipantStatus("等待对方出价");
                        // session.setAttribute("match", bargainMatch);

                        // 给match绑定数据
                        BargainData bargainData = new BargainData();
                        bargainData.setBeginTime(new Timestamp(new Date().getTime()));
                        bargainDataDao = new BargainDataDao();
                        bargainDataDao.save(bargainData);
                        bargainMatch.setCurrentDataId(bargainData.getId());
                        bargainMatchDao.update(bargainMatch);
                        session.setAttribute("match", bargainMatch);

                        J_return.put("status", "谈判中");
                        out.clear();
                        out.println(J_return);
                        return;
                    } else {
                        J_return.put("status", "空闲中");
                        out.clear();
                        out.println(J_return);
                        return;
                    }

                }

            } else if (bargainParticipant.getStatus().equals("谈判中")) {
                J_return.put("status", "谈判中");

                //J_return.put("remainingTime", remainingTime);
            }

        } else {//已结束
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