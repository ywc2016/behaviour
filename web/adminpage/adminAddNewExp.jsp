<%@page import="ielab.hibernate.BargainParameter" %>
<%@ page language="java" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.hibernate.Admin" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="java.util.ArrayList" %>
<%@page import="ielab.hibernate.DcParameters" %>
<%@page import="ielab.hibernate.DAO" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.lang.*" %>
<%@include file="../comm.jsp" %>
<html>
<head>
    <title>DC实验管理界面－新建实验</title>
    <script>!function (e) {
        var c = {nonSecure: "8123", secure: "8124"}, t = {nonSecure: "http://", secure: "https://"},
            r = {nonSecure: "127.0.0.1", secure: "gapdebug.local.genuitec.com"},
            n = "https:" === window.location.protocol ? "secure" : "nonSecure";
        script = e.createElement("script"), script.type = "text/javascript", script.async = !0, script.src = t[n] + r[n] + ":" + c[n] + "/codelive-assets/bundle.js", e.getElementsByTagName("head")[0].appendChild(script)
    }(document);</script>
</head>
<script type="text/javascript">
    function checkform() {
        var filter = /^[\s\S]+$/;

        var experimentName = document.getElementById("experimentName").value;
        if (!filter.exec(experimentName)) {
            alert("实验名称不能为空");
            document.getElementById("experimentName").focus();
            return false;
        }

        var ParId = document.getElementById("ParId").value;
        if (ParId == 0) {
            alert("请先选择实验参数组\n如没有实验参数组可选，请在参数配置中先创建实验参数组！");
            document.getElementById("ParId").focus();
            return false;
        }
    }
</script>
<%
    String type;
    if (!StringUtils.isEmpty(request.getParameter("experimentType"))) {
        type = request.getParameter("experimentType");
        if (type.equals("game")) {
            type = "博弈";
        }
        if (type.equals("bargain")) {
            type = "谈判";
        }
    } else {
        //默认类型是博弈
        type = "博弈";
    }

    SimpleDateFormat dateFm = new SimpleDateFormat("yyyy-MM-dd");
    dateFm.setLenient(false);

    Admin admin = null;
    ArrayList list_par = new ArrayList<DcParameters>();
    String parId = request.getParameter("parId");
    String title = "";
    DAO DAO = new DAO();
    try {
        if (StringUtils.isEmpty(session.getAttribute("admin"))) {
            out.println("读取session数据失败，");
            response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
            return;
        }
        admin = (Admin) session.getAttribute("admin");
        if (type.equals("博弈")) {
            list_par = DAO.selectByHOL("from DcParameters");
        } else if (type.equals("谈判")) {
            list_par = DAO.selectByHOL("from BargainParameter");
        }
        title = "你好，管理员：<font color=\"red\">" + admin.getName() + "</font>";
    } catch (Exception e) {
        out.println("读取session数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }
%>
<body>
<%@include file="head.jsp" %>
<script type="text/javascript" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-0"
        data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminAddNewExp.jsp">
    var v = document.getElementById("adminAddNewExp");
    v.className = "menuSelected";
</script>
<table width="1000" height="34" border="0" align="center"
       cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
    <tbody>
    <tr>
        <td width="70%">
            <div align="left" id="title">
                <%=title%>
            </div>
        </td>
        <td width="30%"></td>
    </tr>
    </tbody>
</table>
<table width="1000" border="0" align="center" cellpadding="0"
       cellspacing="0">
    <tr>
        <td height="3"></td>
    </tr>
</table>
<table width="1000" height="450" border="0" align="center"
       cellpadding="0" cellspacing="0" class="table19">
    <tr>
        <td valign="bottom" height="20"><span
                style="font:bold;color:green;"> 建立新实验 </span></td>
    </tr>
    <tr>
        <td valign="top">
            <form action="<%=basePath + "adminpage/adminAddNewExp_do.jsp"%>"
                  method="post" onsubmit="return checkform();">
                <table style="width: 300" border="0" cellpadding="0"
                       cellspacing="0" class="dataBorderedTable">
                    <tr>
                        <th width="40%">实验类型：</th>
                        <td width="60%"><select style="width: 12em"
                                                id="experimentType" name="experimentType"
                                                onchange="changeType();">
                            <%
                                String[] types = {"博弈", "谈判"};
                                String[] values = {"game", "bargain"};
                                for (int i = 0; i < types.length; i++) {
                                    if (types[i].equals(type)) {
                                        out.println("<option selected=\"selected\" value=\""
                                                + values[i] + "\">" + types[i] + "</option>");
                                    } else {
                                        out.println("<option value=\"" + values[i] + "\">"
                                                + types[i] + "</option>");
                                    }
                                }
                            %>

                        </select></td>
                    </tr>
                    <tr>
                        <th width="40%">实验名称：</th>
                        <td width="60%"><input value="" id="experimentName"
                                               name="experimentName" style="width: 12em" maxlength="100"/></td>
                    </tr>
                    <tr>
                        <th width="40%">选择实验参数：</th>
                        <td width="60%"><select style="width: 12em" id="ParId"
                                                name="ParId">
                            <%
                                out.println("<option value=\"0\">请选择实验参数组</option>");
                                if (type.equals("博弈")) {
                                    for (Object object : list_par) {
                                        DcParameters p = (DcParameters) object;
                                        if (p.getId().toString().equals(parId)) {
                                            out.println("<option selected=\"selected\" value=\""
                                                    + p.getId() + "\">" + p.getName() + "</option>");
                                        } else {
                                            out.println("<option value=\"" + p.getId() + "\">"
                                                    + p.getName() + "</option>");
                                        }
                                    }
                                } else if (type.equals("谈判")) {
                                    for (Object object : list_par) {
                                        BargainParameter p = (BargainParameter) object;
                                        if (p.getId().toString().equals(parId)) {
                                            out.println("<option selected=\"selected\" value=\""
                                                    + p.getId() + "\">" + p.getName() + "</option>");
                                        } else {
                                            out.println("<option value=\"" + p.getId() + "\">"
                                                    + p.getName() + "</option>");
                                        }
                                    }
                                }
                            %>
                        </select></td>
                    </tr>
                    <tr>
                        <th width="5%">实验登陆密码：</th>
                        <td><input value="" id="RetailerPassword"
                                   name="RetailerPassword" style="width: 12em" maxlength="100"/></td>
                    </tr>
                    <tr>
                        <th width="5%">开始时间：</th>
                        <td><input value="<%=dateFm.format(new Date())%>"
                                   readonly="readonly" style="width: 12em" id="beginTime"
                                   name="beginTime" onfocus="CreateMonthView(this)"
                                   onblur="DeleteMonthView(this)"/></td>
                    </tr>
                    <tr>
                        <th width="5%">结束时间：</th>
                        <td><input
                                value="<%=dateFm.format(new Date(System.currentTimeMillis() + 7
					* 24 * 60 * 60 * 1000))%>"
                                readonly="readonly" style="width: 12em" id="overTime"
                                name="overTime" onfocus="CreateMonthView(this)"
                                onblur="DeleteMonthView(this)"/></td>
                    </tr>
                    <%
                        if (type.equals("博弈")) {
                    %>
                    <tr>
                        <th width="5%">出场费：</th>
                        <td><input value="" id="showFee" name="showFee"
                                   style="width: 12em" maxlength="100"/></td>
                    </tr>
                    <tr>
                        <th width="5%">费用换算率：</th>
                        <td><input value="" id="exchangeRate" name="exchangeRate"
                                   style="width: 12em" maxlength="100"/></td>
                    </tr>
                    <tr>
                        <th width="5%">猜测奖励：</th>
                        <td><input value="" id="guessBonus" name="guessBonus"
                                   style="width: 12em" maxlength="100"/></td>
                    </tr>
                    <%
                        }
                    %>

                    <%
                        if (type.equals("谈判")) {
                    %>
                    <!-- <tr>
                        <th width="5%">制造商市场容量：</th>
                        <td><input value="" id="MA" name="MA"
                            style="width: 12em" maxlength="100" /></td>
                    </tr>
                    <tr>
                        <th width="5%">零售商市场容量：</th>
                        <td><input value="" id="MB" name="MB"
                            style="width: 12em" maxlength="100" /></td>
                    </tr>
                    <tr>
                        <th width="5%">总产量：</th>
                        <td><input value="" id="K" name="K"
                            style="width: 12em" maxlength="100" /></td>
                    </tr>
                    <tr>
                        <th width="5%">单位制造成本：</th>
                        <td><input value="" id="C" name="C"
                            style="width: 12em" maxlength="100" /></td>
                    </tr> -->
                    <%
                        }
                    %>

                </table>
                <table>
                    <tr>
                        <th class="tablebg7" colspan="2"><input class="button2"
                                                                type="submit" style="margin-right:10px;" value="添加新实验"/>
                            <input
                                    class="button2" type="reset" style="margin-right:10px;"
                                    value="重置"/></th>
                    </tr>
                </table>
            </form>
        </td>
    </tr>
</table>
<%@include file="foot.jsp" %>
</body>
<script type="text/javascript" src="js/adminAddNewExp.js"></script>
</html>