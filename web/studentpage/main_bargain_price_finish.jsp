<%@ page language="java" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.hibernate.BargainData" %>
<%@page import="ielab.hibernate.BargainMatch" %>
<%@page import="ielab.hibernate.BargainParameter" %>
<%@page import="java.util.List" %>
<%@include file="../comm.jsp" %>
<%
    BargainParameter bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId());

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
        title = "你好，你是<span class='me'>" + (identity.equals("first") ? "生产商" : "零售商")
                + "</span>，你的谈判对象是" + (identity.equals("first") ? "零售商" : "生产商") + "。<br/>"
                + (identity.equals("first")
                ? ("你的生产能力为<span class='me'>" + bargainParameter.getK() + "</span>， 单位生产成本为<span class='me'>" + bargainParameter.getC()
                + "。</span><br/> 你的市场需求如图所示，你和零售商销售到市场的价格都为<span class='me'>" + bargainParameter.getP()) + "</span>"
                : ("生产商的生产能力为" + bargainParameter.getK() + "， 单位生产成本为" + bargainParameter.getC()
                + "。<br/> 你的市场需求如图所示，你和生产商销售到市场的价格都为<span class='me'>" + bargainParameter.getP())) + "。</span>";
    } catch (Exception e) {
        out.println("生成页面数据失败，");
        response.sendRedirect(basePath + "studentpage/login.jsp");
        return;
    }
%>
<html>
<head>
    <title>出价结束页面</title>
    <script type="text/javascript" src="./js/lib/echarts.js"></script>
    <script type="text/javascript" src="./js/lib/ecStat.js"></script>
</head>
<body>

<jsp:include page="../head.jsp"/>
<table width="1000" border="0" align="center" cellpadding="4"
       cellspacing="0">
    <tbody>
    <tr>
        <td width="70%">
            <div class="infoFont" align="left" id="title">
                <%=title%>
            </div>
        </td>
        <td width="30%">
            <div align="right" id="timer"
                 class="timerFont "></div>
        </td>
    </tr>
    </tbody>
</table>
<table width="1000" border="0" align="center" cellpadding="5"
       cellspacing="6" class="table19">
    <tr>
        <td valign="top">

            <%
                if (participantStatus.equals("谈判中")
                        && (identity.equals("first") && bargainMatch.getParticipantStatus().equals("出价完毕")
                        || identity.equals("second") && bargainMatch.getSecomdParticipantStatus().equals("出价完毕"))) {
            %>

            <div class="myFont1" style="margin: 20px;">正在等待对方回应出价...请稍候</div>
            <%
                }
            %>
            <table class="myTableHistory" align="center">
                <tr align="center">
                    <td colspan="4"
                        class="titleFont1">出价历史
                    </td>
                </tr>
                <tr>
                    <td>出价顺序</td>
                    <td>出价者</td>
                    <td>价格</td>
                    <td>数量</td>
                </tr>

                <%
                    int i = 1;
                    for (BargainData bargainData2 : bargainDatas) {
                        if (bargainData2.getPrice() == null) {
                            continue;
                        }
                %>
                <tr <%=bargainData2.getParticipantId().equals(bargainParticipant.getId()) ? "class='me'" : ""%>>
                    <td><%=i++%>
                    </td>
                    <td><%=bargainData2.getParticipantId().equals(bargainParticipant.getId()) ? "我" : "对方"%>
                    </td>
                    <td><%=bargainData2.getPrice()%>
                    </td>
                    <td><%=bargainData2.getQuantity()%>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>
           <%-- <div style="float:left; width: 70%;height: 100%">
                <div align="center" class="myFont1">
                    均值:<a id="mean" class="myFont1"></a>&nbsp&nbsp
                    方差:<a id="standardDeviation" class="myFont1"></a>
                </div>
                <div id="echarts1" style="width: 100%;height: 500px;margin-top: 30px;"></div>
            </div>--%>
            <div class="clearFloat"></div>
        </td>
    </tr>
</table>
<jsp:include page="../foot.jsp"/>
</body>
<script language="javascript" src="js/main_bargain_price_finish.js"></script>
</html>