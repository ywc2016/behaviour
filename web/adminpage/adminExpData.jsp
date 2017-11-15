<%@page import="ielab.dao.BargainDataDao" %>
<%@page import="ielab.hibernate.BargainData" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.hibernate.BargainExperiments" %>
<%@page import="ielab.hibernate.BargainParticipant" %>
<%@page import="ielab.hibernate.BargainMatch" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.hibernate.DcExperiments" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="ielab.hibernate.DAO" %>
<%@page import="ielab.hibernate.Admin" %>
<%@page import="ielab.hibernate.DcData" %>
<%@page import="ielab.util.Pager" %>
<%@include file="../comm.jsp" %>
<%
    String experimentType = request.getParameter("experimentType") == null
            ? "博弈"
            : request.getParameter("experimentType");
    List list_exp = null;
    List participantList = null;
    Pager pager = new Pager();
    String title = "";
    String expId = "1";
    String participantId1 = "0";
    String retailerId = "0";//默认显示所有零售商的数据，用0表示
    String experimentId = "0";
    int numberofRetailer = 5;
    List list_expData = null;
    Admin admin = null;

    DAO DAO = new DAO();

    try {
        if (StringUtils.isEmpty(session.getAttribute("admin"))) {
            out.println("读取session数据失败，");
            response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
            return;
        }
        admin = (Admin) session.getAttribute("admin");

        if (experimentType.equals("博弈")) {
            list_exp = DAO.selectByHOL("from DcExperiments as model");
            if (list_exp.size() > 0) {
                expId = ((DcExperiments) list_exp.get(0)).getId().toString();
            }
        } else if (experimentType.equals("谈判")) {
            list_exp = bargainExperimentsDao.findAll();
        }

        if (StringUtils.isNotEmpty(request.getParameter("id"))) {
            expId = request.getParameter("id");
        }
        if (StringUtils.isNotEmpty(request.getParameter("expId"))) {
            expId = request.getParameter("expId");
        }
        if (StringUtils.isNotEmpty(request.getParameter("retailerId"))) {
            retailerId = request.getParameter("retailerId");
        }
        if (StringUtils.isNotEmpty(request.getParameter("experimentId"))) {
            experimentId = request.getParameter("experimentId");
        }
        if (StringUtils.isNotEmpty(request.getParameter("participantId1"))) {
            participantId1 = request.getParameter("participantId1");
        }

        title = "你好，管理员：<font color=\"red\">" + admin.getName() + "</font>";
    } catch (Exception e) {
        e.printStackTrace();
        out.println("读取session数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }

    if (experimentType.equals("博弈")) {

        String selectValue = "";
        String strsql = "";
        if (retailerId.equals("0")) {
            strsql = " from DcData as model where model.dcExperiments.id=" + expId + " and model.retailerId<>"
                    + retailerId + " and model.tag=2";
        } else {
            strsql = " from DcData as model where model.dcExperiments.id=" + expId + " and model.retailerId="
                    + retailerId + " and model.tag=2";
        }
        String strorderby = "  order by model.id desc ";

        try {
            if (StringUtils.isEmpty(request.getParameter("action"))) {

            } else if (request.getParameter("action").equals("pager")) {
                //如果action为空，则直接显示数据即可,默认按id号排序
                if (StringUtils.isNotEmpty(session.getAttribute("pagersqlstr"))) {
                    strsql = session.getAttribute("pagersqlstr").toString();
                }

                if (StringUtils.isNotEmpty(session.getAttribute("pagersqlorderby"))) {
                    strorderby = session.getAttribute("pagersqlorderby").toString();
                }

                if (StringUtils.isNotEmpty(request.getParameter("currentPage"))) {
                    pager.setCurrentPage(Integer.parseInt(request.getParameter("currentPage")));
                }

                int totalRows = ((Integer) DAO.selectByHOL("select count(*) " + strsql).iterator().next())
                        .intValue();
                pager.init(totalRows);

                if (StringUtils.isEmpty(request.getParameter("pagerAction"))) {
                } else if (request.getParameter("pagerAction").equals("nextpager")) {
                    pager.next();
                    //out.println(pager.getCurrentPage());
                } else if (request.getParameter("pagerAction").equals("previouspager")) {
                    pager.previous();
                } else if (request.getParameter("pagerAction").equals("firstpager")) {
                    pager.first();
                } else if (request.getParameter("pagerAction").equals("lastpager")) {
                    pager.last();
                }
            } else if (request.getParameter("action").equals("order")) {
                if (StringUtils.isNotEmpty(session.getAttribute("pagersqlstr"))) {
                    strsql = session.getAttribute("pagersqlstr").toString();
                }
                if (StringUtils.isNotEmpty(request.getParameter("orderby"))) {
                    strorderby = " order by model." + request.getParameter("orderby").toString();
                }
                //out.println(strsql);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("action操作失败!");
            return;
        }

        int totalRows = ((Integer) DAO.selectByHOL("select count(*) " + strsql).iterator().next()).intValue();
        pager.init(totalRows);

        try {
            session.setAttribute("pagersqlstr", strsql);
            session.setAttribute("pagersqlorderby", strorderby);
            strorderby += " ,model.id desc ";
            list_expData = DAO.selectLimitByHOL(selectValue + strsql + strorderby, pager.getSearchFrom(),
                    pager.getPageSize());
        } catch (Exception e) {
            e.printStackTrace();
            out.println("action操作失败!");
            return;
        }
    } else if (experimentType.equals("谈判")) {

        String strorderby = "id";
        int currentPage = 0;
        try {
            if (StringUtils.isEmpty(request.getParameter("action"))) {
                //如果action为空，则直接显示数据即可,默认按id号排序

            } else if (request.getParameter("action").equals("pager")) {

                if (StringUtils.isNotEmpty(request.getParameter("currentPage"))) {
                    currentPage = Integer.parseInt(request.getParameter("currentPage"));
                }

                long totalRows = bargainMatchDao.countRowsByParameter(Integer.parseInt(experimentId));

                if (StringUtils.isEmpty(request.getParameter("pagerAction"))) {
                } else if (request.getParameter("pagerAction").equals("nextpager")) {
                } else if (request.getParameter("pagerAction").equals("previouspager")) {
                } else if (request.getParameter("pagerAction").equals("firstpager")) {
                } else if (request.getParameter("pagerAction").equals("lastpager")) {
                }
            } else if (request.getParameter("action").equals("order")) {
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("action操作失败!");
            return;
        }
        if (!experimentId.equals("0")) {
            participantList = bargainParticipantDao.findByPropertyEqual("experimentId", experimentId, "int");
        }

        try {
            list_expData = bargainMatchDao.findMatchForpagination(Integer.parseInt(experimentId),
                    Integer.parseInt(participantId1), strorderby, currentPage + "", "4000");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("action操作失败!");
            return;
        }

    }
%>

<html>
<head>
    <title>管理员界面－查看实验数据</title>
    <%-- <script>!function (e) {
         var c = {nonSecure: "8123", secure: "8124"}, t = {nonSecure: "http://", secure: "https://"},
             r = {nonSecure: "127.0.0.1", secure: "gapdebug.local.genuitec.com"},
             n = "https:" === window.location.protocol ? "secure" : "nonSecure";
         script = e.createElement("script"), script.type = "text/javascript", script.async = !0, script.src = t[n] + r[n] + ":" + c[n] + "/codelive-assets/bundle.js", e.getElementsByTagName("head")[0].appendChild(script)
     }(document);</script>--%>
</head>
<body>
<%@include file="head.jsp" %>
<form action="" name="form1" method="post" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-5"
      data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminExpData.jsp"/>
<input type="hidden" id="action" name="action" value="">
<input type="hidden" id="orderby" name="orderby" value="id desc ">
<input type="hidden" id="pagerAction" name="pagerAction" value="">
<input type="hidden" id="currentPage" name="currentPage"
       value="<%=pager.getCurrentPage()%>">


<table width="1000" height="34" border="0" align="center"
       cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
    <tbody>
    <tr>
        <td width="50%">
            <div align="left" id="title">
                <%=title%>
            </div>
        </td>
        <td width="50%">
            <button onclick="exportData(<%=experimentId%>,<%=participantId1%>);">导出数据</button>
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
<table width="1000" border="0" align="center" cellpadding="0"
       cellspacing="0" class="table19">

    <tr>
        <td width="10%"><span style="font:bold;color:green;">
					实验类型： </span></td>
        <td valign="top" align="left"><span
                style="font:bold;color:green;"><select style="width: 10em"
                                                       id="experimentType" name="experimentType" onchange="submit()">
						<%
                            String[] types = {"博弈", "谈判"};
                            for (int i = 0; i < types.length; i++) {
                                if (types[i].equals(experimentType)) {
                                    out.println("<option selected=\"selected\" value=\"" + types[i] + "\">" + types[i] + "</option>");
                                } else {
                                    out.println("<option value=\"" + types[i] + "\">" + types[i] + "</option>");
                                }
                            }
                        %>
				</select></td>
    </tr>
    <%
        if (experimentType.equals("博弈")) {
    %>
    <tr>
        <td width="10%"><span style="font:bold;color:green;">
					请选择实验： </span></td>
        <td valign="top" align="left"><span
                style="font:bold;color:green;"> <select style="width: 10em;"
                                                        name="expId" id="expId" onchange="submit()">
						<%
                            for (Object object : list_exp) {
                                DcExperiments exp = (DcExperiments) object;
                                if (expId.equals(exp.getId().toString())) {
                                    out.println("<option value=\"" + exp.getId() + "\" selected=\"selected\" >"
                                            + exp.getExperimentName() + "</option>");
                                    numberofRetailer = exp.getDcParameters().getNumberofRetailer();
                                } else {
                                    out.println("<option value=\"" + exp.getId() + "\" >" + exp.getExperimentName() + "</option>");
                                }
                            }
                        %>
				</select>
			</span></td>
    </tr>
    <%
    } else if (experimentType.equals("谈判")) {
    %>
    <tr>
        <td width="10%"><span style="font:bold;color:green;">
					请选择实验： </span></td>
        <td valign="top" align="left"><span
                style="font:bold;color:green;"> <select style="width: 10em;"
                                                        name="experimentId" id="experimentId" onchange="submit()">
						<%
                            out.println("<option value=\"" + 0 + "\" >" + "---所有实验---" + "</option>");
                            for (Object object : list_exp) {
                                BargainExperiments exp = (BargainExperiments) object;
                                if (experimentId.equals(exp.getId().toString())) {
                                    out.println("<option value=\"" + exp.getId() + "\" selected=\"selected\" >"
                                            + exp.getExperimentName() + "</option>");
                                } else {
                                    out.println("<option value=\"" + exp.getId() + "\" >" + exp.getExperimentName() + "</option>");
                                }
                            }
                        %>
				</select>
			</span></td>
    </tr>
    <%
        }
    %>

    <%
        if (experimentType.equals("博弈")) {
    %>

    <tr>
        <td><span style="font:bold;color:green;"> 请选择参与者： </span></td>
        <td valign="top" align="left"><span
                style="font:bold;color:green;"> <select style="width: 10em;"
                                                        name="retailerId" id="retailerId" onchange="submit()">
						<option value="0" selected="selected">所有参与者</option>
						<%
                            for (int i = 1; i <= numberofRetailer; i++) {
                                if (Integer.parseInt(participantId1) == i) {
                                    out.println("<option value=\"" + i + "\" selected=\"selected\" >参与者" + i + "号</option>");
                                } else {
                                    out.println("<option value=\"" + i + "\" >参与者" + i + "号</option>");
                                }
                            }
                        %>
				</select>
			</span></td>
    </tr>
    <%
    } else if (experimentType.equals("谈判")) {
    %>

    <tr>
        <td><span style="font:bold;color:green;"> 请选择生产商或者零售商： </span></td>
        <td valign="top" align="left"><span
                style="font:bold;color:green;"> <select style="width: 10em;"
                                                        name="participantId1" id="participantId1" onchange="submit()">
						<%
                            if (experimentId.equals("0")) {
                                out.println("<option value=\"" + 0 + "\" >---所有参与者---</option>");
                            } else {
                                out.println("<option value=\"" + 0 + "\" >---所有参与者---</option>");
                                for (Object object : participantList) {
                                    BargainParticipant bargainParticipant1 = (BargainParticipant) object;
                                    if (Integer.parseInt(participantId1) == bargainParticipant1.getId()) {
                                        out.println("<option value=\"" + bargainParticipant1.getId()
                                                + "\" selected=\"selected\" >参与者" + bargainParticipant1.getNumber() + "号</option>");
                                    } else {
                                        out.println("<option value=\"" + bargainParticipant1.getId() + "\" >参与者"
                                                + bargainParticipant1.getNumber() + "号</option>");
                                    }
                                }
                            }
                        %>
				</select>
			</span></td>
    </tr>
    <%
        }
    %>
    <tr>
        <td valign="top" colspan="2" height="400px">
            <%
                if (experimentType.equals("博弈")) {
            %>
            <table style="width: 1000px;" cellpadding="0" cellspacing="0"
                   class="dataBorderedTable">
                <tr>
                    <th><a href="javascript:orderby('cycle desc');"><font
                            color="black" style="font-weight: normal">周期</font></a></th>
                    <th><a href="javascript:orderby('retailerId');"><font
                            color="black" style="font-weight: normal">零售商号</font></a></th>
                    <th style="background-color: skyblue"><a
                            href="javascript:orderby('orderOut');"><font color="black"
                                                                         style="font-weight: normal">提交订单量</font></a>
                    </th>
                    <th style="background-color: skyblue"><a
                            href="javascript:orderby('orderOut');"><font color="black"
                                                                         style="font-weight: normal">对手订单量</font></a>
                    </th>
                    <th style="background-color: skyblue"><a
                            href="javascript:orderby('goodsIn');"><font color="black"
                                                                        style="font-weight: normal">分配货物量</font></a>
                    </th>
                    <th style="background-color: skyblue"><font color="black"
                                                                style="font-weight: normal">需求</font></th>
                    <th style="background-color: khaki"><a
                            href="javascript:orderby('purchasePrice');"><font
                            color="black" style="font-weight: normal">进货价格</font></a></th>
                    <th style="background-color: khaki"><a
                            href="javascript:orderby('sellingPrice');"><font
                            color="black" style="font-weight: normal">售货价格</font></a></th>
                    <th style="background-color: khaki"><a
                            href="javascript:orderby('netIncome');"><font color="black">净收益</font></a>
                    </th>
                    <th style="background-color: pink"><a
                            href="javascript:orderby('netIncome');"><font color="black">对手订单预测</font></a>
                    </th>
                    <th style="background-color: pink"><a
                            href="javascript:orderby('netIncome');"><font color="black">预测奖励</font></a>
                    </th>
                    <th style="background-color: red"><a><font color="black">累计总得分</font></a>
                    </th>
                    <th style="background-color: gray">对手</th>
                    <th style="background-color: gray">决策时间</th>
                </tr>
                <%
                    if ((list_expData != null) && (list_expData.size() > 0)) {
                        for (Object object : list_expData) {
                            DcData d = (DcData) object;
                %>
                <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
                    onMouseOut="mouseOutColor(this);">
                    <td><%=d.getCycle()%>
                    </td>
                    <td><%=d.getRetailerId()%>
                    </td>
                    <td><%=d.getOrderOut()%>
                    </td>
                    <td><%=d.getBacklogCost()%>
                    </td>
                    <td><%=d.getGoodsIn()%>
                    </td>
                    <td><%=d.getOrderIn()%>
                    </td>
                    <td><%=d.getPurchasePrice()%>
                    </td>
                    <td><%=d.getSellingPrice()%>
                    </td>
                    <td><%=d.getNetIncome()%>
                    </td>
                    <td><%=d.getGuess()%>
                    </td>
                    <td><%=d.getGuessBonus()%>
                    </td>
                    <td><%=d.getTotal()%>
                    </td>
                    <td><%=d.getCompetitor()%>
                    </td>
                    <td><%=(d.getBegainTime2().getTime() - d.getBegainTime1().getTime()) / 1000%>
                    </td>
                </tr>
                <%
                        }
                    }
                %>

                <%
                    if (pager.getTotalPages() > 1) {
                %>
                <tr>
                    <td colspan="16">
                        <div class="buttonBar1">
                            <label> 第<%=pager.getCurrentPage()%>页/共<%=pager.getTotalPages()%>页（<%=pager.getTotalRows()%>
                                条数据）
                            </label> <input type="button" value="第一页" onclick="pager('firstpager')"/>
                            <input type="button" value="上一页"
                                    <%
                                        if (!pager.isHasPrevious())
                                            out.print("disabled='disabled'");
                                    %>
                                   onclick="pager('previouspager')"/> <input type="button"
                                                                             value="下一页"
                                <%
                                    if (!pager.isHasNext())
                                        out.print("disabled='disabled'");
                                %>
                                                                             onclick="pager('nextpager')"/> <input
                                type="button"
                                value="最后一页" onclick="pager('lastpager')"/>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
                if ((list_expData != null) && (list_expData.size() > 0)) {
            %>
            <fieldset>
                <legend> 总资产走势图</legend>
                <center>
                    <%
                        if (retailerId.equals("0")) {
                    %>
                    <IMG
                            src="servlet/DisplayChart_R_Total_AllRetailers?expId=<%=expId%>"
                            BORDER=1/>
                    <%
                    } else {
                    %>
                    <IMG
                            src="servlet/DisplayChart_R_Total?expId=<%=expId%>&retailerId=<%=retailerId%>"
                            BORDER=1/>
                    <%
                        }
                    %>
                </center>
            </fieldset>
            <fieldset>
                <legend> 各期净收益图</legend>
                <center>
                    <%
                        if (retailerId.equals("0")) {
                    %>
                    <IMG
                            src="servlet/DisplayChart_R_NetIncome_AllRetailers?expId=<%=expId%>"
                            BORDER=1/>
                    <%
                    } else {
                    %>
                    <IMG
                            src="servlet/DisplayChart_R_NetIncome?expId=<%=expId%>&retailerId=<%=retailerId%>"
                            BORDER=1/>
                    <%
                        }
                    %>
                </center>
            </fieldset>
            <%
                }
            %> <%
            }
        %> <%
            if (experimentType.equals("谈判")) {
        %>

            <table style="width: 1000px;" cellpadding="0" cellspacing="0"
                   class="dataBorderedTable">
                <tr>
                    <th><a href="javascript:orderby('cycle desc');"><font
                            color="black" style="font-weight: normal">实验名称</font></a></th>
                    <th><a href="javascript:orderby('cycle desc');"><font
                            color="black" style="font-weight: normal">生产商编号</font></a></th>
                    <th><a href="javascript:orderby('retailerId');"><font
                            color="black" style="font-weight: normal">零售商编号</font></a></th>
                    <th style="background-color: skyblue"><a
                            href="javascript:orderby('orderOut');"><font color="black"
                                                                         style="font-weight: normal">生产商谈判状态</font></a>
                    </th>
                    <th style="background-color: skyblue"><a
                            href="javascript:orderby('goodsIn');"><font color="black"
                                                                        style="font-weight: normal">销售商谈判状态</font></a>
                    </th>
                    <th style="background-color: skyblue"><font color="black"
                                                                style="font-weight: normal">谈判价格</font></th>
                    <th style="background-color: khaki"><a><font
                            color="black" style="font-weight: normal">谈判数量</font></a></th>
                    <th style="background-color: skyblue"><font color="black"
                                                                style="font-weight: normal">生产商利润</font></th>
                    <th style="background-color: khaki"><a
                            href="javascript:orderby('purchasePrice');"><font
                            color="black" style="font-weight: normal">零售商利润</font></a></th>
                </tr>
                <%
                    if ((list_expData != null) && (list_expData.size() > 0)) {
                        for (Object object : list_expData) {
                            Object[] objects = (Object[]) object;
                            BargainMatch bargainMatch = (BargainMatch) objects[0];
                            BargainParticipant bargainParticipant1 = (BargainParticipant) objects[1];
                            BargainParticipant bargainParticipant2 = (BargainParticipant) objects[2];
                            BargainExperiments bargainExperiments2 = bargainExperimentsDao
                                    .findByKey(bargainMatch.getExperimentId());
                            BargainData bargainData2 = bargainMatch.getCurrentDataId() == null
                                    ? null
                                    : bargainDataDao.findByKey(bargainMatch.getCurrentDataId());
                %>
                <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
                    onMouseOut="mouseOutColor(this);">
                    <td><%=bargainExperiments2 == null ? "" : bargainExperiments2.getExperimentName()%>
                    </td>
                    <td><%=bargainParticipant1.getNumber()%>
                    </td>
                    <td><%=bargainParticipant2.getNumber()%>
                    </td>
                    <td><%=bargainMatch.getParticipantStatus() == null
                            ? "未开始"
                            : bargainMatch.getParticipantStatus()%>
                    </td>
                    <td><%=bargainMatch.getSecomdParticipantStatus() == null
                            ? "未开始"
                            : bargainMatch.getSecomdParticipantStatus()%>
                    </td>
                    <td><%=(bargainData2 == null || bargainData2.getPrice() == null)
                            ? "谈判尚未结束"
                            : bargainData2.getPrice()%>
                    </td>
                    <td><%=(bargainData2 == null || bargainData2.getQuantity() == null)
                            ? "谈判尚未结束"
                            : bargainData2.getQuantity()%>
                    </td>
                    <td><%=bargainMatch.getSupplierProfits() == null
                            ? "谈判尚未结束"
                            : bargainMatch.getSupplierProfits()%>
                    </td>
                    <td><%=bargainMatch.getRetailerProfits() == null
                            ? "谈判尚未结束"
                            : bargainMatch.getRetailerProfits()%>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </table>
            <%
                }
            %>

        </td>
    </tr>
</table>
<%@include file="foot.jsp" %>
</body>
<script language="javascript" src="js/finished.js"></script>
<script type="text/javascript">
    var v = document.getElementById("adminExpData");
    v.className = "menuSelected";
</script>
</html>