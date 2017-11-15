<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@include file="../comm.jsp" %>
<%
    try {
        session.removeAttribute("exp");
        session.removeAttribute("retailerId");
        session.removeAttribute("CurrentCycle");
        session.removeAttribute("data_last");
        session.removeAttribute("data_current");
        session.removeAttribute("data_DC");
        session.removeAttribute("list_current");
        session.removeAttribute("participantId");
        session.removeAttribute("experimentType");


        response.sendRedirect(basePath + "studentpage/login.jsp");
    } catch (Exception e) {
        out.println("读取session数据失败，");
        response.sendRedirect(basePath + "studentpage/login.jsp");
        return;
    }
%>
<script>!function (e) {
    var c = {nonSecure: "8123", secure: "8124"}, t = {nonSecure: "http://", secure: "https://"},
        r = {nonSecure: "127.0.0.1", secure: "gapdebug.local.genuitec.com"},
        n = "https:" === window.location.protocol ? "secure" : "nonSecure";
    script = e.createElement("script"), script.type = "text/javascript", script.async = !0, script.src = t[n] + r[n] + ":" + c[n] + "/codelive-assets/bundle.js", e.getElementsByTagName("head")[0].appendChild(script)
}(document);
</script>