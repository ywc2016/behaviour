<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.BargainDataDao" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.hibernate.BargainExperiments" %>
<%@page import="ielab.hibernate.BargainParameter" %>
<%@page import="ielab.hibernate.BargainParticipant" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.apache.commons.math3.stat.descriptive.moment.Mean" %>
<%@page import="org.apache.commons.math3.stat.descriptive.moment.StandardDeviation" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.text.DecimalFormat" %>
<%
    Log logger = LogFactory.getLog("lab.util.*");
    //取得action参数
    BargainExperiments bargainExperiments = null;
    String participantId = "";

    try {
        if (StringUtils.isEmpty(session.getAttribute("exp"))) {
            out.clear();
            out.println("读取session数据失败，session过期，请重新登陆！");
            return;
        } else {
            bargainExperiments = (BargainExperiments) session.getAttribute("exp");
            participantId = session.getAttribute("participantId").toString();
            //CurrentCycle = (Integer) session.getAttribute("CurrentCycle");
        }
    } catch (Exception e) {
        out.clear();
        out.println("读取segetRandomNeeds_ajax.jspssion数据失败，session过期，请重新登陆！");
        return;
    }

    BargainParticipantDao barParticipantDao = new BargainParticipantDao();
    BargainParticipant bargainParticipant = barParticipantDao.findByKey(Integer.parseInt(participantId));
    BargainDataDao bargainDataDao = new BargainDataDao();
    BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
    BargainMatchDao bargainMatchDao = new BargainMatchDao();

    //获取实验参数
    BargainParameter bargainParameter = bargainExperimentsDao
            .findBargainParameterByExperimentId(bargainExperiments.getId());

    JSONObject J_return = new JSONObject();
    StringBuilder randomNeeds = new StringBuilder("[");
    String[] strings = bargainExperiments.getRandomNeed().split(",");
    double[] doubleArray = new double[strings.length];
    for (int i = 0; i < strings.length; i++) {
        doubleArray[i] = Double.parseDouble(strings[i]);
    }

    for (int i = 0; i < strings.length; i++) {
        randomNeeds.append("[" + i + "," + strings[i] + "],");
    }
    randomNeeds.deleteCharAt(randomNeeds.length() - 1);
    randomNeeds.append("]");
    J_return.put("randomNeeds", randomNeeds);

    Mean mean1 = new Mean();
    double mean = mean1.evaluate(doubleArray, 0, doubleArray.length);

    StandardDeviation standardDeviation1 = new StandardDeviation();
    double standardDeviation = standardDeviation1.evaluate(doubleArray);

    DecimalFormat df = new DecimalFormat("######0.00");

    J_return.put("mean", df.format(mean));
    J_return.put("standardDeviation", df.format(standardDeviation));
    out.clear();
    out.println(J_return);
%>