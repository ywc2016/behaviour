<%@ page language="java" pageEncoding="UTF-8"%>
<%@include file="../comm.jsp"%>
<%
	try{
		session.removeAttribute("admin");
		response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
	}catch(Exception e){
		out.println("读取session数据失败，");
		response.sendRedirect(basePath+"adminpage/adminLogin.jsp");
		return;
	}
%>
<html>
	<head>
	<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
	<body data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-10" data-genuitec-path="/behaviourDC/WebRoot/adminpage/adminLogout.jsp">
	</body>
</html>