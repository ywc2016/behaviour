<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="ielab.util.StringUtils"%>
<%@page import="ielab.hibernate.DAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ielab.hibernate.Admin"%>
<%@page import="ielab.util.initialDcData"%>
<%
	SimpleDateFormat dateFm = new SimpleDateFormat("yyyy-MM-dd");
	dateFm.setLenient(false);
	DAO DAO=new DAO();
	Admin admin=null;
	try{
		if(StringUtils.isEmpty(session.getAttribute("admin"))){
			out.clear();
			out.println("session过期，请重新登陆");
			return;
		}
		admin=(Admin)session.getAttribute("admin");
	}catch(Exception e){
		out.clear();
		out.println("session过期，请重新登陆");
		return;
	}
	
	//取得action参数
	String action = null;
	try{
		if (StringUtils.isNotEmpty(request.getParameter("action"))){
			action = request.getParameter("action");
		} else {
			out.clear();
			out.println("获取操作参数失败！");
			return;
		}
	}catch(Exception e){
		out.clear();
		out.println("取得request值失败!");
		return;
	}
	
	if(action.equals("delete")){
		try{
			String deleteid = StringUtils.trim(request.getParameter("deleteid"));
			String sqlStrpD = "DELETE FROM dc_data where ExperimentID="+deleteid;
			String sqlStrpE = "DELETE FROM dc_experiments where id="+deleteid;
			try {
				DAO.executeBySQL(sqlStrpD);
				DAO.executeBySQL(sqlStrpE);
			} catch (Exception e) {
				e.printStackTrace();
			}
			out.clear();
			out.println("deletesuccess");
			return;
			
		}catch(Exception e){
			out.clear();
			out.println("删除失败!");
			return;
		}
	}else if(action.equals("initialexp")){
		//对给定实验id的实验进行初始化
		//初始化的过程现在已经加到添加实验中
		//如果以后有需求需要对已经正在进行，或者已经完成的实验进行初始化，可以用该段程序来进行初始化，只需要在界面中加一个链接，用ajax的方法指向该段程序
		String expid = StringUtils.trim(request.getParameter("expid"));
		initialDcData initialDcData=new initialDcData();
		String returnStr=initialDcData.initialDCData(Integer.parseInt(expid));
		
		out.clear();
		out.println(returnStr);
		return;
	
	}else{
		out.clear();
		out.println("错误的操作参数！");
		return;	
	}
%>