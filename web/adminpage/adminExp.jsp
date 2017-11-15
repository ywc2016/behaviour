<%@page import="ielab.dao.DCParametersDao" %>
<%@page import="ielab.hibernate.DcParameters" %>
<%@page import="ielab.dao.BargainParameterDao" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.hibernate.BargainExperiments" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.hibernate.DcExperiments" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="ielab.hibernate.DAO" %>
<%@page import="ielab.hibernate.Admin" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@include file="../comm.jsp" %>
<%
    String experimentType = request.getParameter("experimentType") == null
            ? "博弈"
            : request.getParameter("experimentType");

    Admin admin = null;
    DAO DAO = new DAO();
    List list_exp = null;

    try {
        if (StringUtils.isEmpty(session.getAttribute("admin"))) {
            out.println("读取session数据失败，");
            response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
            return;
        }
        admin = (Admin) session.getAttribute("admin");
        if (experimentType.equals("博弈")) {
            list_exp = DAO.selectByHOL("from DcExperiments as model");
        } else if (experimentType.equals("谈判")) {
            list_exp = (List<BargainExperiments>) bargainExperimentsDao.findAll();
        }
    } catch (Exception e) {
        out.println("读取session数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }

    String title = "";
    String expTitle = "";

    try {
        title = "你好，管理员：<font color=\"red\">" + admin.getName() + "</font>，恭喜你登陆成功，进入实验管理界面。";
        expTitle += "目前已创建<font color=\"red\">" + list_exp.size() + "</font>个实验，以下为各实验的详细信息。";
    } catch (Exception e) {
        out.println("生成页面数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }
%>
<html>
<head>
    <title>DC实验管理界面－实验管理</title>

    <script>!function (e) {
        var c = {nonSecure: "8123", secure: "8124"}, t = {nonSecure: "http://", secure: "https://"},
            r = {nonSecure: "127.0.0.1", secure: "gapdebug.local.genuitec.com"},
            n = "https:" === window.location.protocol ? "secure" : "nonSecure";
        script = e.createElement("script"), script.type = "text/javascript", script.async = !0, script.src = t[n] + r[n] + ":" + c[n] + "/codelive-assets/bundle.js", e.getElementsByTagName("head")[0].appendChild(script)
    }(document);</script>
</head>
<body>
<%@include file="head.jsp" %>
<table width="1000" height="34" border="0" align="center"
       cellpadding="4" cellspacing="0" background="images/top_menu2.gif" data-genuitec-lp-enabled="false"
       data-genuitec-file-id="wc1-4" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminExp.jsp">
    <tbody>
    <tr>
        <td width="70%">
            <div align="left" id="title">
                <%=title%>
            </div>
        </td>
        <td width="30%"><span> 实验类型: </span><select style="width: 12em"
                                                    id="experimentType" name="experimentType"
                                                    onchange="changeExperimentType();">
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
    </tbody>
</table>
<table width="1000" border="0" align="center" cellpadding="0"
       cellspacing="0">
    <tr>
        <td height="3"></td>
    </tr>
</table>

<%
    if (experimentType.equals("博弈")) {
%>
<table width="1000" height="450" border="0" align="center"
       cellpadding="0" cellspacing="0" class="table19">
    <tr>
        <td valign="bottom" height="20"><span
                style="font:bold;color:green;"> 已创建实验列表： </span> <span> <%=expTitle%>
			</span></td>
    </tr>
    <tr>
        <td valign="top">
            <table style="width: 1000px;" border="0" cellpadding="0"
                   cellspacing="0" class="dataBorderedTable">
                <tr>
                    <th width="14%"><a href="javascript:void(0);">实验名称</a></th>
                    <th width="14%"><a href="javascript:void(0);">实验参数</a></th>
                    <th width="14%"><a href="javascript:void(0);">实验登陆密码</a></th>
                    <th width="14%"><a href="javascript:void(0);">实验开始时间</a></th>
                    <th width="14%"><a href="javascript:void(0);">实验结束时间</a></th>
                    <th width="30%" colspan="3"><a href="javascript:void(0);">操作</a>
                    </th>
                </tr>
                <%
                    DCParametersDao dcParametersDao = new DCParametersDao();
                    SimpleDateFormat dateFm = new SimpleDateFormat("yyyy-MM-dd");
                    dateFm.setLenient(false);
                    for (Object object : list_exp) {
                        DcExperiments exp = (DcExperiments) object;
                %>
                <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
                    onMouseOut="mouseOutColor(this);">
                    <td><%=exp.getExperimentName()%>
                    </td>
                    <td><%=exp.getDcParameters().getName()%>
                    </td>
                    <td><%=exp.getRetailerPassword()%>
                    </td>
                    <td><%=dateFm.format(exp.getBeginTime())%>
                    </td>
                    <td><%=dateFm.format(exp.getOverTime())%>
                    </td>
                    <td><a
                            href="<%=basePath + "adminpage/adminExpData.jsp?id=" + exp.getId()%>">查看实验数据</a>
                    </td>
                    <td><a id="<%="deleteconfirm" + exp.getId()%>"
                           href="javascript:void(0);"
                           onclick="deleteitem('<%=exp.getId()%>');">删除实验</a></td>
                    <td><a id="<%="initialexp" + exp.getId()%>"
                           href="javascript:void(0);"
                           onclick="initialexp('<%=exp.getId()%>');">重新初始化实验</a></td>
                </tr>
                <%
                    }
                %>
            </table>
            <div id="operation" class="buttonBar1">
                <input type="button" style="margin-right:10px;" value="添加新实验"
                       onClick="onadd();"/>
            </div>
        </td>
    </tr>
</table>

<%
    }
%>

<%
    if (experimentType.equals("谈判")) {
%>
<table width="1000" height="450" border="0" align="center"
       cellpadding="0" cellspacing="0" class="table19">
    <tr>
        <td valign="bottom" height="20"><span
                style="font:bold;color:green;"> 已创建实验列表： </span> <span> <%=expTitle%>
			</span></td>
    </tr>
    <tr>
        <td valign="top">
            <table style="width: 1000px;" border="0" cellpadding="0"
                   cellspacing="0" class="dataBorderedTable">
                <tr>
                    <th width="12%"><a href="javascript:void(0);">实验名称</a></th>
                    <th width="12%"><a href="javascript:void(0);">实验参数</a></th>
                    <th width="12%"><a href="javascript:void(0);">实验登陆密码</a></th>
                    <th width="12%"><a href="javascript:void(0);">实验开始时间</a></th>
                    <th width="12%"><a href="javascript:void(0);">实验结束时间</a></th>
                    <th width="12%"><a href="javascript:void(0);">实验状态</a></th>
                    <th width="28%" colspan="3"><a href="javascript:void(0);">操作</a>
                    </th>
                </tr>
                <%
                    SimpleDateFormat dateFm = new SimpleDateFormat("yyyy-MM-dd");
                    dateFm.setLenient(false);
                    for (Object object : list_exp) {
                        BargainExperiments exp = (BargainExperiments) object;
                %>
                <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
                    onMouseOut="mouseOutColor(this);">
                    <td><%=exp.getExperimentName()%>
                    </td>
                    <td><%=bargainParameterDao.findByKey(exp.getParId()).getName()%>
                    </td>
                    <td><%=exp.getRetailerPassword()%>
                    </td>
                    <td><%=dateFm.format(exp.getBeginTime())%>
                    </td>
                    <td><%=dateFm.format(exp.getOverTime())%>
                    </td>
                    <td><%=exp.getExperimentState() == 0 ? "未结束" : "已结束"%>
                    </td>
                    <td><a
                            href="<%=basePath + "adminpage/adminBargainData.jsp?id=" + exp.getId()%>">查看实验数据</a>
                    </td>
                    <td><a id="<%="deleteconfirm" + exp.getId()%>"
                           href="javascript:void(0);"
                           onclick="deleteitem('<%=exp.getId()%>');">删除实验</a></td>
                    <td><a id="<%="initialexp" + exp.getId()%>"
                           href="javascript:void(0);"
                           onclick="initialexp('<%=exp.getId()%>');">重新初始化实验</a></td>
                </tr>
                <%
                    }
                %>
            </table>
            <div id="operation" class="buttonBar1">
                <input type="button" style="margin-right:10px;" value="添加新实验"
                       onClick="onadd();"/>
            </div>
        </td>
    </tr>
</table>

<%
    }
%>


<%@include file="foot.jsp" %>
</body>
<script language="javascript" src="js/adminExp.js"></script>
<script type="text/javascript">
    var v = document.getElementById("adminExp");
    v.className = "menuSelected";
</script>
</html>