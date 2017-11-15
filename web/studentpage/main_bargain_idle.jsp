<%@page import="ielab.hibernate.BargainMatch" %>
<%@ page language="java" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@include file="../comm.jsp" %>
<%

    String participantStatus = null;
    participantStatus = bargainParticipant.getStatus();


    BargainMatch bargainMatch = null;
    String identity = null;
    if (participantStatus.equals("谈判中")) {
        //BargainMatchDao bargainMatchDao = new BargainMatchDao();
        //bargainMatch = bargainMatchDao.findByKey(bargainParticipant.getMatchId());
        //判断是第一参与者还是第二参与者
        //if(bargainMatch.getParticipantId().equals(bargainParticipant.getId())){
        //identity = "first";
        //	}else{
        //identity = "second";
        //	}
    }

    String title = "";

    try {
        title = "你好，"/* +bargainParticipant.getNumber()+ */ + "你已经登陆成功，即将开始实验……";
        //title+="目前为实验的第"+CurrentCycle+"期。";
        //	title+="目前为实验的第"+CurrentCycle+"期,实验总共有"+exp.getDcParameters().getTotalCycle()+"期。";
    } catch (Exception e) {
        out.println("生成页面数据失败，");
        response.sendRedirect(basePath + "studentpage/login.jsp");
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
            <div align="left" id="title" class="infoFont">
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
<table width="1000px" border="0" align="center" cellpadding="5"
       cellspacing="6" class="table19">
    <tr>
        <td valign="top">
            <div id="decision" align="center" style="margin-top:2em;">
                <%
                    if (participantStatus.equals("空闲中") || participantStatus.equals("离线")) {
                %>

                <div class="myFont1">正在匹配谈判者...请稍候</div>

                <%
                    }
                %>

                <%
                    if (participantStatus.equals("谈判中")) {
                %>
                <div class="myFont1">即将进入谈判页面...请稍候</div>

                <%
                    }
                %>
            </div>
        </td>
    </tr>
</table>

<jsp:include page="../foot.jsp"/>

</body>
<script language="javascript" src="js/main_bargain_idle.js"></script>
</html>