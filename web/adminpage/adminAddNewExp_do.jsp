<%@page import="ielab.hibernate.BargainParameter" %>
<%@page import="ielab.dao.BargainParameterDao" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.hibernate.BargainExperiments" %>
<%@ page language="java" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.hibernate.Admin" %>
<%@page import="ielab.hibernate.DAO" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="ielab.hibernate.DcExperiments" %>
<%@page import="java.util.ArrayList" %>
<%@page import="ielab.hibernate.DcParameters" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="ielab.util.initialDcData" %>
<%@include file="../comm.jsp" %>
<%
    DAO DAO = new DAO();
    SimpleDateFormat dateFm = new SimpleDateFormat("yyyy-MM-dd");
    dateFm.setLenient(false);

    Admin admin = null;
    try {
        if (StringUtils.isEmpty(session.getAttribute("admin"))) {
            out.println("读取session数据失败，");
            response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
            return;
        }
        admin = (Admin) session.getAttribute("admin");
    } catch (Exception e) {
        out.println("读取session数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }

    String errors = "";
    String reqestStr = "";
    String experimentType = request.getParameter("experimentType");
    String experimentName = request.getParameter("experimentName");
    if ((experimentName == null) || (experimentName == "")) {
        errors += "<tr><th width=\"40%\">实验名称：</th><td width=\"60%\">实验名称为空</td></tr>";
    }
	/* else{
		exp.setExperimentName(reqestStr);
	} */

    String parId = request.getParameter("ParId");
    if (parId == null) {
        errors += "<tr><th width=\"40%\">实验参数：</th><td width=\"60%\">实验参数为空</td></tr>";
    }

    DcExperiments exp = new DcExperiments();

    if (experimentType.equals("game")) {
        ArrayList<DcParameters> list_par = DAO
                .selectByHOL("from DcParameters as model where model.id=" + parId);
        if (list_par.size() > 0) {
            DcParameters par = list_par.get(0);
            exp.setDcParameters(par);
        } else {
            errors += "<tr><th width=\"40%\">实验参数：</th><td width=\"60%\">选中的实验参数组不存在</td></tr>";
        }
        exp.setExperimentName(experimentName);
        exp.setType(experimentType);
        reqestStr = request.getParameter("RetailerPassword");
        exp.setRetailerPassword(reqestStr);

        reqestStr = request.getParameter("beginTime");
        exp.setBeginTime(dateFm.parse(reqestStr));

        reqestStr = request.getParameter("overTime");
        exp.setOverTime(dateFm.parse(reqestStr));

        reqestStr = request.getParameter("showFee");
        exp.setShowFee(Float.parseFloat(reqestStr));

        reqestStr = request.getParameter("exchangeRate");
        exp.setExchangeRate(Float.parseFloat(reqestStr));

        reqestStr = request.getParameter("guessBonus");
        exp.setGuessBonus(Float.parseFloat(reqestStr));

        if (errors == "") {
            exp.setAdmin(admin);
            exp.setExperimentState(0);
            try {
                DAO.insert(exp);

                //对创建的实验进行初始化
                int expid = exp.getId();
                initialDcData initialDcData = new initialDcData();

                String returnStr = initialDcData.initialDCData(expid);
                if (!(returnStr.equals("initialexpsuccess"))) {
                    errors += "<tr><th width=\"40%\">初始化DCdata表失败：</th><td width=\"60%\">" + returnStr
                            + "</td></tr>";
                }
            } catch (Exception e) {
                errors += "<tr><th width=\"40%\">保存至数据库失败：</th><td width=\"60%\">" + e.toString()
                        + "</td></tr>";
            }
        }
    } else if (experimentType.equals("bargain")) {

        bargainExperiments = new BargainExperiments();

        bargainExperiments.setExperimentName(experimentName);
        bargainExperiments.setRetailerPassword(request.getParameter("RetailerPassword"));
        bargainExperiments.setBeginTime(dateFm.parse(request.getParameter("beginTime")));
        bargainExperiments.setOverTime(dateFm.parse(request.getParameter("overTime")));
        bargainExperiments.setExperimentState(0);
        bargainExperiments.setParId(Integer.parseInt(parId));
        //BargainParameter bargainParameter= bargainParameterDao.findByKey(Integer.parseInt(parId));
        bargainExperiments.setCurrentCycle(0);

        bargainExperimentsDao.save(bargainExperiments);

        bargainMatchDao.initBargainMatch(bargainExperiments.getId().intValue(), 100);//初始化匹配参数

        bargainExperiments = bargainExperimentsDao.findByKey(bargainExperiments.getId().intValue());//更新实验信息
    }
%>

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

<body>
<%@include file="head.jsp" %>
<script type="text/javascript" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-1"
        data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminAddNewExp_do.jsp">
    var v = document.getElementById("adminAddNewExp");
    v.className = "menuSelected";
</script>
<table width="1000" height="34" border="0" align="center"
       cellpadding="4" cellspacing="0" background="images/top_menu2.gif">
    <tbody>
    <tr>
        <td width="70%">
            <div align="left" id="title">
                <%
                    if (errors != "") {
                        out.print("新建实验失败");
                    } else {
                        out.print("新建实验成功");
                    }
                %>
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
                style="font:bold;color:green;"> <%
            if (errors != "") {
                out.print("新建实验失败信息");
            } else {
                out.print("新创建的实验信息");
            }
        %>
			</span></td>
    </tr>
    <tr>
        <td valign="top">
            <table style="width: 300" border="0" cellpadding="0" cellspacing="0"
                   class="dataBorderedTable">
                <%
                    if (errors != "") {
                        out.print(errors);
                    } else if (experimentType.equals("game")) {
                %>
                <tr>
                    <th width="40%">实验名称：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=exp.getExperimentName().toString()%>"
                                           id="experimentName" name="experimentName"
                                           style="width: 12em;border: 0;color:red" maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="40%">选择实验参数：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=exp.getDcParameters().getName()%>" id="ParId"
                                           name="ParId" style="width: 12em;border: 0;color:red"
                                           maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="5%">实验登陆密码：</th>
                    <td><input readonly="readonly"
                               value="<%=exp.getRetailerPassword().toString()%>"
                               id="RetailerPassword" name="RetailerPassword"
                               style="width: 12em;border: 0;color:red" maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="5%">开始时间：</th>
                    <td><input readonly="readonly"
                               value="<%=dateFm.format(exp.getBeginTime())%>"
                               style="width: 12em;border: 0;color:red" id="beginTime"
                               name="beginTime"/></td>
                </tr>
                <tr>
                    <th width="5%">结束时间：</th>
                    <td><input readonly="readonly"
                               value="<%=dateFm.format(exp.getOverTime())%>"
                               style="width: 12em;border: 0;color:red" id="overTime"
                               name="overTime"/></td>
                </tr>
                <tr>
                    <th width="40%">出场费：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=exp.getShowFee().toString()%>" id="showFee"
                                           name="showFee" style="width: 12em;border: 0;color:red"
                                           maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="40%">费用换算率：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=exp.getExchangeRate().toString()%>" id="exchangeRate"
                                           name="exchangeRate" style="width: 12em;border: 0;color:red"
                                           maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="40%">猜测奖励：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=exp.getGuessBonus().toString()%>" id="guessBonus"
                                           name="guessBonus" style="width: 12em;border: 0;color:red"
                                           maxlength="100"/></td>
                </tr>
                <%
                } else if (experimentType.equals("bargain")) {
                %>

                <tr>
                    <th width="40%">实验名称：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=bargainExperiments.getExperimentName().toString()%>"
                                           id="experimentName" name="experimentName"
                                           style="width: 12em;border: 0;color:red" maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="40%">实验参数：</th>
                    <td width="60%"><input readonly="readonly"
                                           value="<%=new BargainParameterDao().findByKey(bargainExperiments.getParId()).getName()%>"
                                           id="ParId" name="ParId" style="width: 12em;border: 0;color:red"
                                           maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="5%">实验登陆密码：</th>
                    <td><input readonly="readonly"
                               value="<%=bargainExperiments.getRetailerPassword().toString()%>"
                               id="RetailerPassword" name="RetailerPassword"
                               style="width: 12em;border: 0;color:red" maxlength="100"/></td>
                </tr>
                <tr>
                    <th width="5%">开始时间：</th>
                    <td><input readonly="readonly"
                               value="<%=dateFm.format(bargainExperiments.getBeginTime())%>"
                               style="width: 12em;border: 0;color:red" id="beginTime"
                               name="beginTime"/></td>
                </tr>
                <tr>
                    <th width="5%">结束时间：</th>
                    <td><input readonly="readonly"
                               value="<%=dateFm.format(bargainExperiments.getOverTime())%>"
                               style="width: 12em;border: 0;color:red" id="overTime"
                               name="overTime"/></td>
                </tr>

                <%
                    }
                %>
            </table>
            <table>
                <tr>
                    <th class="tablebg7" colspan="2">
                        <%
                            if (errors != "") {
                        %> <a href="javascript:history.go(-1);">返回重新添加新实验</a> <%
                    } else {
                    %> <a href="<%=basePath + "adminpage/adminAddNewExp.jsp"%>">继续添加新实验</a>
                        <a href="<%=basePath + "adminpage/adminExp.jsp"%>">进入实验管理页面</a> <%
                        }
                    %>
                    </th>
                </tr>
            </table>
        </td>
    </tr>
</table>
<%@include file="foot.jsp" %>
</body>
</html>