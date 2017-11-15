<%@page import="org.hibernate.Session"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="ielab.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.hibernate.Query"%>
<%@page import="ielab.hibernate.DAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="ielab.hibernate.Admin"%>
<%
	//取得action参数
	String action = null;
	DAO DAO = new DAO();
	try {
		if (StringUtils.isNotEmpty(request.getParameter("action"))) {
			action = request.getParameter("action");
		} else {
			out.clear();
			out.println("获取操作参数失败！");
			return;
		}
	} catch (Exception e) {
		out.clear();
		out.println("取得request值失败!");
		return;
	}

	if (action.equals("login")) {
		try {
			out.println("1");
			String username = StringUtils.trim(request.getParameter("username"));
			String password = StringUtils.trim(request.getParameter("password"));
			out.println("before HQL");
			String HQL = "from Admin as model where model.username='" + username + "'";

			Session session2 = DAO.getSession();
			session2.beginTransaction();
			Query query = session2.createQuery(HQL);
			ArrayList<Admin> list = (ArrayList<Admin>) query.list();
			session2.getTransaction().commit();
			out.println("after HQL");
			JSONObject J_return = new JSONObject();
			J_return.put("action", action);
			if (list.size() == 1) {
				Admin admin = list.get(0);
				String psw = admin.getPassword().trim();
				if (psw.equals(password)) {
					J_return.put("loginstatus", "success");
					//将该管理员存入session中
					session.setAttribute("admin", admin);
				} else {
					J_return.put("loginstatus", "登录失败\n密码不正确！");
				}

				out.clear();
				out.println(J_return);
				return;
			} else {
				J_return.put("loginstatus", "登录失败\n该用户名不存在！");
				out.clear();
				out.println(J_return);
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
			out.clear();
			out.println("登录失败!");
			return;
		}
	} else {
		out.clear();
		out.println("错误的操作参数！");
		return;
	}
%>