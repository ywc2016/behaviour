<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.dao.BargainDataDao" %>
<%@page import="ielab.hibernate.BargainData" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.hibernate.BargainMatch" %>
<%@page import="ielab.hibernate.BargainParticipant" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.hibernate.BargainExperiments" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.hibernate.DcExperiments" %>
<%@page import="ielab.hibernate.DcData" %>
<%@page import="ielab.util.StringUtils" %>
<%@include file="../comm.jsp" %>
<%
    List<BargainParticipant> bargainParticipantList = null;
    List<BargainMatch> list_expData = null;

    String participantStatus = bargainParticipant.getStatus();

    BargainMatch bargainMatch = null;
    String identity = null;
    BargainData bargainData = null;
    List<BargainData> bargainDatas = null;
    if (participantStatus.equals("谈判中")) {
        bargainMatch = bargainMatchDao.findByKey(bargainParticipant.getMatchId());

        bargainData = bargainDataDao.findByKey(bargainMatch.getCurrentDataId());
        bargainDatas = bargainDataDao.findHistory(bargainMatch.getId().intValue());

        //判断是第一参与者还是第二参与者
        if (bargainMatch.getParticipantId().equals(bargainParticipant.getId())) {
            identity = "first";
        } else {
            identity = "second";
        }
    }

    String title = "";

    try {
        title = "你好，实验已经结束。";
        //title+="目前为实验的第"+CurrentCycle+"期。";
        //	title+="目前为实验的第"+CurrentCycle+"期,实验总共有"+exp.getDcParameters().getTotalCycle()+"期。";
    } catch (Exception e) {
        out.println("生成页面数据失败，");
        response.sendRedirect(basePath + "studentpage/login.jsp");
        return;
    }

    if (StringUtils.isNotEmpty(request.getParameter("participantId"))) {
        participantId = request.getParameter("participantId");
    }

    if (!bargainExperiments.getId().equals("0")) {
        bargainParticipantList = bargainParticipantDao.findByPropertyEqual("experimentId",
                bargainExperiments.getId().toString(), "int");
    }

    try {
        list_expData = bargainMatchDao.findMatchForpagination(bargainExperiments.getId(),
                Integer.parseInt(participantId), "", "1" + "", "4000");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("action操作失败!");
        return;
    }
%>
<html>
<head>
    <title>谈判实验主页面</title>
</head>
<body onload="timer()">
<jsp:include page="../head.jsp"/>
<table width="1000" border="0" align="center" cellpadding="4"
       cellspacing="0">
    <tbody>
    <tr>
        <td width="70%">
            <div align="left" id="title">
                <%=title%>
            </div>
        </td>
        <td width="30%">
            <div align="right" id="timer"
                 class="timerFont"></div>
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


<table style="width: 1000px;" cellpadding="0" cellspacing="0"
       class="dataBorderedTable" align="center">
    <tr>
        <!-- <th><a href="javascript:orderby('cycle desc');"><font
                color="black" style="font-weight: normal">实验名称</font></a></th> -->
        <!-- <th><a href="javascript:orderby('cycle desc');"><font
                color="black" style="font-weight: normal">生产商编号</font></a></th>
        <th><a href="javascript:orderby('retailerId');"><font
                color="black" style="font-weight: normal">零售商编号</font></a></th> -->
        <!-- <th style="background-color: skyblue"><a
            href="javascript:orderby('orderOut');"><font color="black"
                style="font-weight: normal">生产商谈判状态</font></a></th>
        <th style="background-color: skyblue"><a
            href="javascript:orderby('goodsIn');"><font color="black"
                style="font-weight: normal">销售商谈判状态</font></a></th> -->
        <th style="background-color: skyblue"><font color="black"
                                                    style="font-weight: normal">你的身份</font></th>
        <th style="background-color: skyblue"><font color="black"
                                                    style="font-weight: normal">谈判价格</font></th>
        <th style="background-color: khaki"><a><font color="black"
                                                     style="font-weight: normal">谈判数量</font></a></th>
        <th style="background-color: skyblue"><font color="black"
                                                    style="font-weight: normal">生产商利润</font></th>
        <th style="background-color: khaki"><a><font color="black"
                                                     style="font-weight: normal">零售商利润</font></a></th>
    </tr>
    <%
        if ((list_expData != null) && (list_expData.size() > 0)) {
            for (Object object : list_expData) {
                Object[] objects = (Object[]) object;
                BargainMatch bargainMatch1 = (BargainMatch) objects[0];
                BargainParticipant bargainParticipant1 = (BargainParticipant) objects[1];
                BargainParticipant bargainParticipant2 = (BargainParticipant) objects[2];
                BargainExperiments bargainExperiments1 = bargainExperimentsDao
                        .findByKey(bargainMatch1.getExperimentId());
                BargainData bargainData2 = bargainMatch1.getCurrentDataId() == null ? null
                        : bargainDataDao.findByKey(bargainMatch1.getCurrentDataId());
    %>
    <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
        onMouseOut="mouseOutColor(this);">
        <%-- <td><%=bargainExperiments1 == null ? "" : bargainExperiments1.getExperimentName()%></td>--%>
        <%-- <td><%=bargainParticipant1.getNumber()%></td>
        <td><%=bargainParticipant2.getNumber()%></td> --%>
        <%-- <td><%=bargainMatch1.getParticipantStatus() == null ? "未开始"
                        : bargainMatch1.getParticipantStatus()%></td>
        <td><%=bargainMatch1.getSecomdParticipantStatus() == null ? "未开始"
                        : bargainMatch1.getSecomdParticipantStatus()%></td> --%>
        <td><%=bargainMatch1.getParticipantId().equals(bargainParticipant.getId()) ? "生产商" : "零售商"%>
        </td>
        <td><%=(bargainData2 == null || bargainData2.getPrice() == null) ? "谈判尚未结束"
                : bargainData2.getPrice()%>
        </td>
        <td><%=(bargainData2 == null || bargainData2.getQuantity() == null) ? "谈判尚未结束"
                : bargainData2.getQuantity()%>
        </td>
        <td <%=bargainMatch1.getParticipantId().equals(bargainParticipant.getId()) ? "class='me'" : ""%> ><%=bargainMatch1.getSupplierProfits() == null ? "谈判尚未结束" : bargainMatch1.getSupplierProfits()%>
        </td>
        <td <%=bargainMatch1.getSecondParticipantId().equals(bargainParticipant.getId()) ? "class='me'" : ""%> ><%=bargainMatch1.getRetailerProfits() == null ? "谈判尚未结束" : bargainMatch1.getRetailerProfits()%>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>


<table width="1000" border="0" align="center" cellpadding="5"
       cellspacing="6" class="table19">
    <tr>
        <td valign="top">
            <div id="decision" align="center" style="margin-top:2em;"></div>
        </td>
    </tr>
    <tr>
        <td height="19" valign="top"></td>
        <td valign="top">
            <div id="backLogo" align="center"></div>
        </td>
    </tr>
</table>
<jsp:include page="../foot.jsp"/>
</body>
</html>