<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.hibernate.DAO" %>
<%@include file="../comm.jsp" %>
<%
    DAO DAO = new DAO();
    //获取实验类型
    String[] experimentTypes = {"game", "bargain"};
    String[] expimentTypesName = {"博弈", "谈判"};
    String experiment_types = "";
    for (int i = 0; i < experimentTypes.length; i++) {
        //if(experimentTypes[i].equals("game")){
        //	experiment_types += "<option selected='selected' value=\"" + experimentTypes[i] + "\">";
        //	experiment_types += expimentTypesName[i];
        //	experiment_types += "</option>";
        //}else{
        experiment_types += "<option value=\"" + experimentTypes[i] + "\">";
        experiment_types += expimentTypesName[i];
        experiment_types += "</option>";
        //}
    }

	
/* 	try {
		Date nowDay = new Date(System.currentTimeMillis());
		String HQL = "from BargainExperiments as model where model.experimentState=1 and model.beginTime<=:now and model.overTime>=:now";
		Query query = DAO.getSession().createQuery(HQL);
		query.setTimestamp("now", nowDay);
		List<BargainExperiments> list = (List<BargainExperiments>) query.list();
		for (BargainExperiments a : list) {
			experiment_types += "<option value=\"" + a.getId() + "\">";
			experiment_types += a.getExperimentName();
			experiment_types += "</option>";
		}
	} catch (Exception e) {
		out.println("读取实验数据失败！");
	} */

    //获取实验名称
    String options_t = "";
	
	/* try {
		Date nowDay = new Date(System.currentTimeMillis());
		String HQL = "from DcExperiments as model where model.experimentState=1 and model.beginTime<=:now and model.overTime>=:now";
		Query query = DAO.getSession().createQuery(HQL);
		query.setTimestamp("now", nowDay);
		ArrayList<DcExperiments> list = (ArrayList<DcExperiments>) query
		.list();
		options_t = "";
		for (DcExperiments a : list) {
			options_t += "<option value=\"" + a.getId() + "\">";
			options_t += a.getExperimentName();
			options_t += "</option>";
		}
	} catch (Exception e) {
		out.println("读取实验数据失败！");
	} */

    if (session.getAttribute("experimentType") != null
            && session.getAttribute("exp") != null
            && session.getAttribute("participantId") != null) {//已经有登陆过的session
        System.out.println(111);
        response.sendRedirect(basePath + "/servlet/bargainTransform");
    }
%>
<html>
<head>
    <title>DC实验登陆页面</title>
    <script>!function (e) {
        var c = {nonSecure: "8123", secure: "8124"}, t = {nonSecure: "http://", secure: "https://"},
            r = {nonSecure: "127.0.0.1", secure: "gapdebug.local.genuitec.com"},
            n = "https:" === window.location.protocol ? "secure" : "nonSecure";
        script = e.createElement("script"), script.type = "text/javascript", script.async = !0, script.src = t[n] + r[n] + ":" + c[n] + "/codelive-assets/bundle.js", e.getElementsByTagName("head")[0].appendChild(script)
    }(document);</script>
</head>
<body onkeypress="enterHandler(event);">
<table width="1000" height="27" border="0" align="center"
       cellpadding="0" cellspacing="0" background="images/top_menu.gif">
    <tr>
        <td width="88" background="images/top_menu_3.gif">
            <div align="center">
                <a href="javascript:void(0);"><span class="black">实验登陆</span> </a>
            </div>
        </td>
        <td width="2">&nbsp;</td>
        <td width="88">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="61">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="61">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="61">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="88">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="88">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="88">&nbsp;</td>
        <td width="2">&nbsp;</td>
        <td width="212">&nbsp;</td>
        <td width="78">&nbsp;</td>
        <td width="57">&nbsp;</td>
    </tr>
</table>
<table width="1000" height="495" align="center"
       background="images/retailerlogin.jpg">
    <tr height="210">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td width="60%"></td>
        <td>
            <table width="216" border="0" cellpadding="0" cellspacing="1">
                <tr>
                    <td height="25">
                        <div align="center">选择实验种类：</div>
                    </td>
                    <td height="25">
                        <div align="left">
                            <select style="width: 10em;" name="experimentType"
                                    id="experimentType" onchange="getExperimentType()">
                                <option value="-1">请选择实验种类</option>
                                <%=experiment_types%>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td height="25">
                        <div align="center">选择实验名称：</div>
                    </td>
                    <td height="25">
                        <div align="left">
                            <select style="width: 10em;" name="expId" id="expId"
                                    onchange="getRetailer()">
                                <option value="0">请选择实验</option>
                                <%=options_t%>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td height="25">
                        <div align="center">选择节点：</div>
                    </td>
                    <td height="25">
                        <div align="left">
                            <select style="width: 10em;" name="retailerId" id="retailerId">
                                <option value="0">请先选择实验</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td height="25">
                        <div align="center">输入密码：</div>
                    </td>
                    <td height="25">
                        <div align="left">
                            <input style="width: 10em;" type="password" id="password"
                                   name="password">
                        </div>
                    </td>
                </tr>

                <tr>
                    <td height="30" align="center">&nbsp;</td>
                    <td height="30" align="left">
                        <div align="left">
                            <a href="javascript:submitform();"><img
                                    src="images/denglu.gif" width="75" height="25" border="0"/></a>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<jsp:include page="../foot.jsp"/>
<script language="javascript" src="js/login.js"></script>
</html>