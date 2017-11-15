<%@page import="ielab.hibernate.BargainParameter" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="ielab.hibernate.DAO" %>
<%@page import="ielab.hibernate.Admin" %>
<%@page import="ielab.hibernate.DcParameters" %>
<%@include file="../comm.jsp" %>
<%
    String experimentType;
    if (StringUtils.isEmpty(request.getParameter("experimentType"))) {
        experimentType = "博弈";
    } else {
        experimentType = request.getParameter("experimentType");
        if (experimentType.equals("game")) {
            experimentType = "博弈";
        }
        if (experimentType.equals("bargain")) {
            experimentType = "谈判";
        }
    }

    Admin admin = null;
    ArrayList list_par = new ArrayList<DcParameters>();
    DAO DAO = new DAO();
    try {
        if (StringUtils.isEmpty(session.getAttribute("admin"))) {
            out.println("读取session数据失败，");
            response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
            return;
        }
        admin = (Admin) session.getAttribute("admin");

        if (experimentType.equals("博弈")) {
            list_par = DAO.selectByHOL("from DcParameters as model");
        } else if (experimentType.equals("谈判")) {
            list_par = DAO.selectByHOL("from BargainParameter as a");
        }

    } catch (Exception e) {
        out.println("读取session数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }

    String title = "";
    String expTitle = "";

    try {
        title = "你好，管理员：<font color=\"red\">" + admin.getName() + "</font>，恭喜你登陆成功，进入实验参数管理界面。";
        expTitle += "目前已创建<font color=\"red\">" + list_par.size() + "</font>组实验参数，以下为各组参数的详细信息。";
    } catch (Exception e) {
        out.println("生成页面数据失败，");
        response.sendRedirect(basePath + "adminpage/adminLogin.jsp");
        return;
    }
%>
<html>
<head>
    <title>DC实验管理界面－实验参数配置</title>
    <style type="text/css">
        <!--
        .view {
            width: 7em;
        }

        .addNew {
            width: 7em;
        }

        -->
    </style>
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
       data-genuitec-file-id="wc1-11" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminParameter.jsp">
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

<table style="width: 1000" border="0" align="center" cellpadding="0"
       cellspacing="0" class="dataBorderedTable">

    <tr>
        <td valign="bottom" height="20"><span> 实验类型: </span> <span>
					<select style="width: 12em" id="experimentType"
                            name="experimentType" onchange="changeType();">
						<%
                            String[] types = {"博弈", "谈判"};
                            String[] values = {"game", "bargain"};
                            for (int i = 0; i < types.length; i++) {
                                if (types[i].equals(experimentType)) {
                                    out.println("<option selected=\"selected\" value=\"" + values[i] + "\">" + types[i] + "</option>");
                                } else {
                                    out.println("<option value=\"" + values[i] + "\">" + types[i] + "</option>");
                                }
                            }
                        %>
				</select>
			</span> <span style="font:bold;color:green;"> 已创建实验参数列表： </span> <span>
					<%=expTitle%>
			</span></td>
    </tr>
    <tr>
        <td valign="top">
            <%
                if (experimentType.equals("博弈")) {
            %>
            <table style="width: 1000" border="0" align="center" cellpadding="0"
                   cellspacing="0" class="dataBorderedTable">
                <tr>
                    <th width="2%" style="display: none;"><input type="checkbox"
                                                                 id="checkallitems" name="checkallitems"
                                                                 onclick="checkall('checkeditem','checkallitems');changeAllColor('checkeditem','checkallitems');"/>
                    </th>
                    <th width="9%"><a href="javascript:void(0);">参数名称</a></th>
                    <th width="9%"><a href="javascript:void(0);">实验总期数</a></th>
                    <th width="9%"><a href="javascript:void(0);">每期决策时间</a></th>


                    <th width="9%"><a href="javascript:void(0);">分配方案</a></th>
                    <th width="8%"><a href="javascript:void(0);">供应商库存</a></th>

                    <th width="8%"><a href="javascript:void(0);">零售商数量</a></th>
                    <th width="8%"><a href="javascript:void(0);">购入价格</a></th>
                    <th width="11%"><a href="javascript:void(0);">出售价格</a></th>
                    <th width="11%"><a href="javascript:void(0);">市场需求</a></th>

                    <th colspan="3"><a href="javascript:void(0);">操作</a></th>
                </tr>
                <%
                    for (Object obj : list_par) {
                        DcParameters exp = (DcParameters) obj;
                        String expParament = exp.getId() + "$";
                        expParament += exp.getName() + "$";
                        expParament += exp.getDistributionScheme() + "$";
                        expParament += exp.getNumberofRetailer() + "$";
                        expParament += exp.getTotalCycle() + "$";
                        expParament += exp.getDcinitialInventory() + "$";
                        expParament += exp.getInitialPurchasePrice() + "$";
                        expParament += exp.getCycleTime() / 1000 + "$";
                        expParament += exp.getInfoDegree() + "$";
                        expParament += exp.getInitialSellingPrice() + "$";
                        expParament += exp.getDemand();
                %>
                <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
                    onMouseOut="mouseOutColor(this);">
                    <td style="display: none;"><input name="checkeditem"
                                                      id="checkeditem<%=exp.getId()%>" type="checkbox"
                                                      value="<%=expParament%>" onClick="selectChangeColor(this);"/></td>
                    <td><%=exp.getName()%>
                    </td>
                    <td><%=exp.getTotalCycle()%>
                    </td>
                    <td><%=exp.getCycleTime() / 1000 + "秒"%>
                    </td>

                    <td>
                        <%
                            if (exp.getDistributionScheme().equals(1)) {
                        %> 按比例分配 <%
                    } else if (exp.getDistributionScheme().equals(2)) {
                    %> 线性分配 <%
                    } else if (exp.getDistributionScheme().equals(3)) {
                    %> 统一分配 <%
                    } else if (exp.getDistributionScheme().equals(4)) {
                    %> 小订单优先 <%
                    } else if (exp.getDistributionScheme().equals(5)) {
                    %> 大订单优先 <%
                        }
                    %>
                    </td>
                    <td><%=exp.getDcinitialInventory()%>
                    </td>
                    <td><%=exp.getNumberofRetailer()%>
                    </td>
                    <td><%=exp.getInitialPurchasePrice()%>
                    </td>
                    <td><%=exp.getInitialSellingPrice()%>
                    </td>
                    <td><%=exp.getDemand()%>
                    </td>
                    <td width="7%"><a id="onview" href="javascript:void(0);"
                                      onclick="onview('<%=exp.getId()%>');">查看参数信息</a></td>
                    <td width="10%"><a id="<%="usingconfirm" + exp.getId()%>"
                                       href="<%=basePath + "adminpage/adminAddNewExp.jsp?experimentType=game&parId=" + exp.getId()%>">创建实验</a>
                    </td>
                    <td width="11%"><a id="<%="deleteconfirm" + exp.getId()%>"
                                       href="javascript:void(0);"
                                       onclick="deleteitem('<%=exp.getId()%>','game');">删除</a></td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
                }
            %> <%
            if (experimentType.equals("谈判")) {
        %>

            <table style="width: 1000" border="0" align="center" cellpadding="0"
                   cellspacing="0" class="dataBorderedTable">
                <tr>
                    <th width="2%" style="display: none;">
                        <input type="checkbox"
                               id="checkallitems" name="checkallitems"
                               onclick="checkall('checkeditem','checkallitems');changeAllColor('checkeditem','checkallitems');"/>
                    </th>
                    <th><a href="javascript:void(0);">参数名称</a></th>
                    <th><a href="javascript:void(0);">谈判时间</a></th>
                    <th><a href="javascript:void(0);">每轮时间</a></th>
                    <th><a href="javascript:void(0);">实验人数</a></th>
                    <!-- <th><a href="javascript:void(0);">制造商市场容量MA</a></th>
                    <th><a href="javascript:void(0);">零售商市场容量MB</a></th> -->
                    <th><a href="javascript:void(0);">总产量k</a></th>
                    <th><a href="javascript:void(0);">单位成本c</a></th>
                    <th><a href="javascript:void(0);">最小需求a</a></th>
                    <th><a href="javascript:void(0);">最大需求b</a></th>
                    <th><a href="javascript:void(0);">市场价格p</a></th>
                    <th colspan="3"><a href="javascript:void(0);">操作</a></th>
                </tr>
                <%
                    for (Object obj : list_par) {
                        BargainParameter bargainParameter = (BargainParameter) obj;
                        String expParament = bargainParameter.getId() + "$";
                        expParament += bargainParameter.getName() + "$";
                        expParament += bargainParameter.getNumberOfPerson() + "$";
                        expParament += bargainParameter.getDecisionTime() + "$";
								/* 	expParament += bargainParameter.getMa();
									expParament += bargainParameter.getMb(); */
                        expParament += bargainParameter.getK();
                        expParament += bargainParameter.getC();
                %>
                <tr class="noBgColor" onMouseOver="mouseOverColor(this);"
                    onMouseOut="mouseOutColor(this);">
                    <td style="display: none;"><input name="checkeditem"
                                                      id="checkeditem<%=bargainParameter.getId()%>" type="checkbox"
                                                      value="<%=expParament%>" onClick="selectChangeColor(this);"/></td>
                    <td><%=bargainParameter.getName()%>
                    </td>
                    <td><%=bargainParameter.getDecisionTime().intValue() + "秒"%>
                    </td>
                    <td><%= bargainParameter.getOneRoundTime() == null ? null : bargainParameter.getOneRoundTime().intValue() + "秒"%>
                    </td>
                    <td><%=bargainParameter.getNumberOfPerson()%>
                    </td>
                    <%-- 		<td><%=bargainParameter.getMa()%></td>
                    <td><%=bargainParameter.getMb()%></td> --%>
                    <td><%=bargainParameter.getK()%>
                    </td>
                    <td><%=bargainParameter.getC()%>
                    </td>
                    <td><%=bargainParameter.getA()%>
                    </td>
                    <td><%=bargainParameter.getB()%>
                    </td>
                    <td><%=bargainParameter.getP()%>
                    </td>
                    <td><a id="onview" href="javascript:void(0);"
                           onclick="onview('<%=bargainParameter.getId()%>');">查看参数信息</a></td>
                    <td><a id="<%="usingconfirm" + bargainParameter.getId()%>"
                           href="<%=basePath + "adminpage/adminAddNewExp.jsp?experimentType=bargain&parId="
							+ bargainParameter.getId()%>">创建实验</a>
                    </td>
                    <td><a id="<%="deleteconfirm" + bargainParameter.getId()%>"
                           href="javascript:void(0);"
                           onclick="deleteitem('<%=bargainParameter.getId()%>','bargain');">删除</a></td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
                }
            %>

            <div id="operation" class="buttonBar1">
                <input type="button" style="margin-right:10px;" value="新添加一组参数"
                       onClick="onadd();"/>
            </div>

            <div id="view" class="listTable"
                 style="display:none; width: 1000px;">
                <input type="hidden" id="v_id" name="v_id"/>
                <table border="0" align="left" cellpadding="0" cellspacing="1">
                    <tr>
                        <td colspan="1">
                            <div align="left" class="tablebg2">
                                <strong> 查看详细实验参数 </strong>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td height="24">
                            <div align="left">
                                <table width="990" border="0" cellspacing="" cellpadding="0">
                                    <tr>
                                        <td width="110" class="tablebg6">参数名称:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view" id="v_name"
                                                       name="v_name"/>
                                            </div>
                                        </td>
                                        <td width="110" class="tablebg6">零售商数量:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <select disabled="disabled" class="view"
                                                        id="v_numberofRetailer" name="v_numberofRetailer">
                                                    <%
                                                        for (int i = 1; i <= 10; i++) {
                                                            out.println("<option value=\"" + i + "\">" + i + "</option>");
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </td>


                                        <td class="tablebg6">信息透明度:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <select disabled="disabled" class="view" id="v_infoDegree"
                                                        name="v_infoDegree">
                                                    <option value="3">完全透明</option>
                                                </select>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                    </tr>
                                    <tr>
                                        <td width="110" class="tablebg6">分配方案:</td>

                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <select disabled="disabled" class="view"
                                                        id="v_distributionScheme" name="v_distributionScheme"/>
                                                <option value="1">按比例分配</option>
                                                <option value="2">线性分配</option>
                                                <option value="3">统一分配</option>
                                                <option value="4">小订单优先</option>
                                                <option value="5">大订单优先</option>
                                                </select>
                                            </div>
                                        </td>
                                        <td class="tablebg6">每期决策时间（秒）:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view" id="v_cycleTime"
                                                       name="v_cycleTime"/>
                                            </div>
                                        </td>
                                        <td width="40" class="tablebg7"></td>

                                        <td class="tablebg6">供应商库存:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view"
                                                       id="v_dcinitialInventory" name="v_dcinitialInventory"/>
                                            </div>
                                        </td>

                                        <td class="tablebg6">实验总期数:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view" id="v_totalCycle"
                                                       name="v_totalCycle"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td class="tablebg7"></td>
                                        <td width="40" class="tablebg7"></td>
                                        <td class="tablebg6">X:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view"
                                                       id="v_initialPurchasePrice" name="v_initialPurchasePrice"/>
                                            </div>
                                        </td>
                                        <td width="40" class="tablebg7"></td>
                                        <td class="tablebg6">Y:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view"
                                                       id="v_initialSellingPrice" name="v_initialSellingPrice"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                        <td class="tablebg6">市场需求:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input disabled="disabled" class="view" id="v_demand"
                                                       name="v_demand"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="tablebg7">
                            <div style="margin-right:10px;text-align: right;">
                                <input id="quxiao_1" name="quxiao_1" type="button"
                                       class="button2" value="关闭" onclick="displayhiden('view')"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

            <div id="addNew" class="listTable"
                 style="display:none; width: 1000px;">

                <%
                    if (experimentType.equals("博弈")) {
                %>
                <table border="0" align="left" cellpadding="0" cellspacing="1">
                    <tr>
                        <td colspan="1">
                            <div align="left" class="tablebg2">
                                <strong> 新添加一组实验参数： </strong>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td height="24">
                            <div align="left">
                                <table width="990" border="0" cellspacing="" cellpadding="0">
                                    <tr>
                                        <td width="110" class="tablebg6">参数名称:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_name" name="a_name"
                                                       check="^[\s\S]+" warning="参数名称不能为空！"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                        <td width="110" class="tablebg6">零售商数量:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">

                                                <input class="addNew" id="a_numberofRetailer"
                                                       name="a_numberofRetailer" check="^[0-9]*[1-9][0-9]*$"
                                                       warning="零售商数量应该为正整数！"/>
                                            </div>
                                        </td>

                                        <td width="40" class="tablebg7"></td>

                                        <td class="tablebg6">决策时间（秒）:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_cycleTime" name="a_cycleTime"
                                                       check="^[0-9]*[1-9][0-9]*$" warning="决策时间应该为正整数！"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>

                                        <td class="tablebg7"></td>
                                    </tr>
                                    <tr>
                                        <td class="tablebg6">分配方案:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <select class="addNew" id="a_distributionScheme"
                                                        name="a_distributionScheme">
                                                    <option value="3">统一分配</option>
                                                    <option value="2">线性分配</option>
                                                    <option value="1">按比例分配</option>
                                                    <option value="4">小订单优先</option>
                                                    <option value="5">大订单优先</option>
                                                </select>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>

                                        <td class="tablebg6">供应商库存:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_dcinitialInventory"
                                                       name="a_dcinitialInventory" check="^\d+$"
                                                       warning="供应商库存量应该为非负整数！"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                        <td class="tablebg6">实验总期数:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_totalCycle" name="a_totalCycle"
                                                       check="^\d+$" warning="供应商库存量应该为非负整数！"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tablebg6">信息透明度:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <select class="addNew" id="a_infoDegree"
                                                        name="a_infoDegree">
                                                    <option value="3">完全透明</option>
                                                </select>
                                            </div>
                                        </td>

                                        <td class="tablebg7"></td>

                                        <td class="tablebg6">X:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_initialPurchasePrice"
                                                       name="a_initialPurchasePrice" check="^[0-9]*[1-9][0-9]*$"
                                                       warning="初始进货价格应该为正整数！"/>
                                            </div>
                                        </td>

                                        <td class="tablebg7"></td>
                                        <td class="tablebg6">Y:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_initialSellingPrice"
                                                       name="a_initialSellingPrice" check="^[0-9]*[1-9][0-9]*$"
                                                       warning="出售价格应该为正整数！"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                        <td class="tablebg6">市场需求:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_demand" name="a_demand"
                                                       check="^[0-9]*[1-9][0-9]*$" warning="市场需求量应该为正整数！"/>
                                            </div>
                                        </td>
                                        <td class="tablebg7"></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="tablebg7">
                            <div style="margin-right:10px;text-align: right;">
                                <input id="addNewconfirm" name="addNewconfirm" type="button"
                                       class="button2" value="添加新实验参数" onclick="addNew();"/> <input
                                    id="quxiao_2" name="quxiao_2" type="button" class="button2"
                                    value="取消" onclick="displayhiden('addNew')"/>
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
                <table border="0" align="left" cellpadding="0" cellspacing="1">
                    <tr>
                        <td colspan="1">
                            <div align="left" class="tablebg2">
                                <strong> 新添加一组实验参数： </strong>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td height="24">
                            <div align="left">
                                <table width="990" border="0" cellspacing="" cellpadding="0">
                                    <tr>

                                        <td width="110" class="tablebg6">参数名称:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_name" name="a_name"
                                                       check="^[\s\S]+" warning="参数名称不能为空！"/>
                                            </div>
                                        </td>

                                        <td width="110" class="tablebg6">参与者数量:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">

                                                <input class="addNew" id="a_numberOfPerson"
                                                       name="a_numberOfPerson" check="^[0-9]*[1-9][0-9]*$"
                                                       warning="参与者数量应该为正整数！"/>
                                            </div>
                                        </td>

                                        <td width="110px" class="tablebg6">决策时间（秒）:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="a_cycleTime" name="a_cycleTime"
                                                       check="^[0-9]*[1-9][0-9]*$" warning="决策时间应该为正整数！"/>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>

                                        <!-- <td width="110" class="tablebg6">制造商市场容量MA:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="MA" name="MA"
                                                    check="^[0-9]*[1-9][0-9]*$" warning="MA应该为正整数！" />
                                            </div>
                                        </td>

                                        <td width="110" class="tablebg6">零售商市场容量MB:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="MB" name="MB"
                                                    check="^[0-9]*[1-9][0-9]*$" warning="MB应该为正整数！" />
                                            </div>
                                        </td> -->

                                        <td width="110" class="tablebg6">总产量k:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="k" name="k" check="^\d+(\.\d+)?$"
                                                       warning="k应该为非负实数！"/>
                                            </div>
                                        </td>

                                        <td width="110" class="tablebg6">单位成本c:</td>
                                        <td width="100" class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="c" name="c" check="^\d+(\.\d+)?$"
                                                       warning="c应该为非负实数！"/>
                                            </div>

                                        </td>

                                        <td width="110px" class="tablebg6">每轮时间（秒）:</td>
                                        <td class="tablebg7">
                                            <div align="left">
                                                <input class="addNew" id="oneRoundTime" name="oneRoundTime"
                                                       check="^[0-9]*[1-9][0-9]*$" warning="时间应该为正整数！"/>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>

                                        <td width="110" class="tablebg8">最小需求a:</td>
                                        <td width="100" class="tablebg9">
                                            <div align="left">
                                                <input class="addNew" id="a" name="a"
                                                       check="^[0-9]*[1-9][0-9]*$" warning="a应该为正整数！"/>
                                            </div>
                                        </td>

                                        <td width="110" class="tablebg10">最大需求b:</td>
                                        <td width="100" class="tablebg11">
                                            <div align="left">
                                                <input class="addNew" id="b" name="b"
                                                       check="^[0-9]*[1-9][0-9]*$" warning="b应该为正整数！"/>
                                            </div>
                                        </td>

                                        <td width="110" class="tablebg12">市场价格p:</td>
                                        <td width="100" class="tablebg13">
                                            <div align="left">
                                                <input class="addNew" id="p" name="p" check="^\d+(\.\d+)?$"
                                                       warning="p应该为非负实数！"/>
                                            </div>
                                        </td>

                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="tablebg7">
                            <div style="margin-right:10px;text-align: right;">
                                <input id="addNewconfirm" name="addNewconfirm" type="button"
                                       class="button2" value="添加新实验参数"
                                       onclick="addNewBargainParameter();"/>
                                <input id="quxiao_2"
                                       name="quxiao_2" type="button"
                                       class="button2" value="取消"
                                       onclick="displayhiden('addNew')"/>
                            </div>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>
            </div>

        </td>
    </tr>
</table>
<%@include file="foot.jsp" %>
</body>
<script language="javascript" src="js/adminParameter.js"></script>
<script type="text/javascript">
    var v = document.getElementById("adminParameter");
    v.className = "menuSelected";
</script>
</html>