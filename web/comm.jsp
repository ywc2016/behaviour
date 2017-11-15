<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="ielab.dao.*" %>
<%@ page import="ielab.hibernate.BargainExperiments" %>
<%@ page import="ielab.hibernate.BargainParticipant" %>
<%@ page import="ielab.util.StringUtils" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    out.print("<script type='text/javascript'>var basePath='" + basePath + "';</script>");
%>

<%--登录是否过期验证--%>
<%
    BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
    BargainMatchDao bargainMatchDao = new BargainMatchDao();
    BargainDataDao bargainDataDao = new BargainDataDao();
    BargainParameterDao bargainParameterDao = new BargainParameterDao();
    BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();

    BargainExperiments bargainExperiments = null;
    String participantId = "";
    BargainParticipant bargainParticipant = null;

    String uri = request.getRequestURI().toString();


    if (!"/".equals(uri) && !"/studentpage/login.jsp".equals(uri) && !"/studentpage/logout.jsp".equals(uri)
            && !uri.startsWith("/adminpage/")) {//不过滤登录页面和管理页面和博弈的页面
        try {
            if (StringUtils.isEmpty(session.getAttribute("experimentType").toString())) {
                out.println("读取session数据失败，请重新登陆.");
                response.sendRedirect(basePath + "studentpage/login.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("读取session数据失败，请重新登陆.");
            response.sendRedirect(basePath + "studentpage/login.jsp");
            return;
        }
        if (!"game".equals(session.getAttribute("experimentType").toString())) {//只处理bargain
            try {
                if (StringUtils.isEmpty(session.getAttribute("exp"))) {
                    out.println("读取session数据失败，请重新登陆.");
                    response.sendRedirect(basePath + "studentpage/login.jsp");
                    return;
                } else if (StringUtils.isEmpty(session.getAttribute("participantId"))) {
                    out.println("读取session数据失败，请重新登录.");
                    response.sendRedirect(basePath + "studentpage/login.jsp");
                    return;
                }
                bargainExperiments = (BargainExperiments) session.getAttribute("exp");
                participantId = (String) session.getAttribute("participantId");
                bargainParticipant = bargainParticipantDao.findByKey(Integer.parseInt(participantId));

            } catch (Exception e) {
                e.printStackTrace();
                out.println("读取session数据失败，请重新登陆.");
                response.sendRedirect(basePath + "studentpage/login.jsp");
                return;
            }
        }
    }
%>
<base href="<%=basePath%>" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-16"
      data-genuitec-path="/behaviourDC/WebRoot/comm.jsp"/>
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="cache-control" content=
        "no-cache"/>
<meta http-equiv="expires" content="0"/>
<meta http-equiv="keywords"
      content="物流,实验室,网络实验室,物流网络实验室,实验平台,实验,博弈,网络博弈,清华,清华大学,工业工程系,开发,hibernate,j2EE,proxool"/>
<meta http-equiv="description" content="物流网络博弈实验平台"/>

<link rel="stylesheet" href="./css/css.css" type="text/css"/>
<script language="JavaScript" src="js/ajax_func.js"
        type="text/JavaScript"></script>
<script language="javascript" src="js/comm.js" type="text/JavaScript"></script>
<script language="javascript" src="js/jsMonthView1.1_cn.js"
        type="text/JavaScript"></script>
<!-- <script language="javascript" src="js/calendar.js"
type="text/JavaScript"></script> -->
<!-- <script language="javascript" src="js/printpage.js"
type="text/JavaScript"></script> -->
<!-- <script language="JavaScript" src="js/checkForm.js"
type="text/JavaScript"></script> -->
<script language="JavaScript" src="js/table.js" type="text/JavaScript"></script>
<script type="text/javascript" src="./js/lib/jquery.min.js"></script>
