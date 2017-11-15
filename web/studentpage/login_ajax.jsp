<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.hibernate.*" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="org.hibernate.Query" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%
    //取得action参数
    DAO DAO = new DAO();

    String action = null;
    try {
        if (StringUtils.isNotEmpty(request.getParameter("action"))) {
            action = request.getParameter("action");
        } else {
            out.clear();
            out.println("获取操作参数失败！");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.clear();
        out.println("取得request值失败!");
        return;
    }

    if (action.equals("getRetailer")) {
        try {
            String expId = StringUtils.trim(request.getParameter("expId"));
            String HQL = "from DcExperiments as model where model.id=" + expId;
            Session session2 = DAO.getSession();
            session2.beginTransaction();
            Query query = session2.createQuery(HQL);
            ArrayList<DcExperiments> list = (ArrayList<DcExperiments>) query.list();
            session2.getTransaction().commit();
            if (list.size() == 1) {
                DcExperiments exp = list.get(0);

                JSONObject J_return = new JSONObject();
                JSONArray rs = new JSONArray();
                for (int i = 1; i <= exp.getDcParameters().getNumberofRetailer(); i++) {
                    JSONObject r = new JSONObject();
                    r.put("id", i);
                    r.put("name", "第" + i + "号零售商");
                    rs.add(r);
                }

                J_return.put("action", action);
                J_return.put("retailers", rs);

                out.clear();
                out.println(J_return);
                return;
            } else {
                out.clear();
                out.println("获取该实验的零售商失败!");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("获取该实验的零售商失败!");
            return;
        }
    } else if (action.equals("getBargainParticipants")) {
        try {
            String expId = StringUtils.trim(request.getParameter("expId"));
            BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
            BargainParameter bargainParameter = bargainExperimentsDao
                    .findBargainParameterByExperimentId(Integer.valueOf(Integer.valueOf(expId)));

            BargainExperiments bargainExperiments = bargainExperimentsDao.findByKey(Integer.parseInt(expId));

            BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
            List<BargainParticipant> bargainParticipants = bargainParticipantDao
                    .findByPropertyEqual("experimentId", expId, "int");

            if (bargainParameter != null) {

                JSONObject J_return = new JSONObject();
                JSONArray rs = new JSONArray();
                for (int i = 0; i < bargainParticipants.size(); i++) {
                    JSONObject r = new JSONObject();
                    r.put("id", bargainParticipants.get(i).getId());
                    r.put("name", "第" + bargainParticipants.get(i).getNumber() + "号参与者");
                    rs.add(r);
                }

                J_return.put("action", action);
                J_return.put("participants", rs);

                out.clear();
                out.println(J_return);
                return;
            } else {
                out.clear();
                out.println("获取该实验的参与者失败!");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("获取该实验的参与者失败!");
            return;
        }
    } else if (action.equals("getExperimentType")) {//获取实验
        try {
            String experimentType = StringUtils.trim(request.getParameter("experimentType"));
            if (experimentType.equals("game")) {

                Date nowDay = new Date(System.currentTimeMillis());
                String HQL = "from DcExperiments as model where model.experimentState=1 and model.beginTime<=:now and model.overTime>=:now";

                Session session2 = DAO.getSession();
                session2.beginTransaction();
                Query query = session2.createQuery(HQL);
                query.setTimestamp("now", nowDay);
                ArrayList<DcExperiments> list = (ArrayList<DcExperiments>) query.list();
                session2.getTransaction().commit();

                if (list.size() != 0) {
                    JSONObject J_return = new JSONObject();
                    JSONArray rs = new JSONArray();
                    for (int i = 0; i < list.size(); i++) {
                        JSONObject r = new JSONObject();
                        r.put("id", list.get(i).getId());
                        r.put("name", list.get(i).getExperimentName());
                        rs.add(r);
                    }

                    J_return.put("action", action);
                    J_return.put("experiments", rs);

                    out.clear();
                    out.println(J_return);
                    return;
                } else {
                    out.clear();
                    out.println("没有创建实验!");
                    return;
                }
            } else if (experimentType.equals("bargain")) {

                Date nowDay = new Date(System.currentTimeMillis());
                String HQL = "from BargainExperiments as model where model.beginTime<=:now and model.overTime>=:now";

                Session session2 = DAO.getSession();
                session2.beginTransaction();
                Query query = session2.createQuery(HQL);
                query.setTimestamp("now", nowDay);
                ArrayList<BargainExperiments> list = (ArrayList<BargainExperiments>) query.list();
                session2.getTransaction().commit();

                if (list.size() != 0) {
                    JSONObject J_return = new JSONObject();
                    JSONArray rs = new JSONArray();
                    for (int i = 0; i < list.size(); i++) {
                        JSONObject r = new JSONObject();
                        r.put("id", list.get(i).getId());
                        r.put("name", list.get(i).getExperimentName());
                        rs.add(r);
                    }

                    J_return.put("action", action);
                    J_return.put("experiments", rs);

                    out.clear();
                    out.println(J_return);
                    return;
                } else {
                    out.clear();
                    out.println("没有创建实验!");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("获取该实验失败!");
            return;
        }
    } else if (action.equals("login")) {
        String experimentType = request.getParameter("experimentType");
        if (experimentType.equals("game")) {
            try {
                String expId = StringUtils.trim(request.getParameter("expId"));
                String retailerId = StringUtils.trim(request.getParameter("retailerId"));
                String password = StringUtils.trim(request.getParameter("password"));

                String HQL = "from DcExperiments as model where model.id=" + expId;
                Query query = DAO.getSession().createQuery(HQL);
                ArrayList<DcExperiments> list = (ArrayList<DcExperiments>) query.list();

                JSONObject J_return = new JSONObject();
                J_return.put("action", action);

                if (list.size() == 1) {
                    DcExperiments exp = list.get(0);
                    String DcParametersName = exp.getDcParameters().getName();//让hibernate加载DcParameter
                    //System.out.print("初始化实验使用的参数:"+DcParametersName);

                    String psw = exp.getRetailerPassword().trim() + retailerId.trim();
                    if (psw.equals(password)) {
                        J_return.put("loginstatus", "success");
                        J_return.put("experimentType", experimentType);
                        //将该实验的实验参数和零售商id存入session中
                        session.setAttribute("exp", exp);
                        session.setAttribute("retailerId", retailerId);
                        session.setAttribute("experimentType", experimentType);

                    } else {
                        J_return.put("loginstatus", "login failed!\npassword is not right!");
                    }

                    out.clear();
                    out.println(J_return);
                    return;
                } else {
                    J_return.put("loginstatus", "login failed!\nusername is not right!");
                    out.clear();
                    out.println(J_return);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.clear();
                out.println("登陆失败!");
                return;
            }
        }

        if (experimentType.equals("bargain")) {//是谈判的实验
            try {
                String expId = StringUtils.trim(request.getParameter("expId"));
                String participantId = StringUtils.trim(request.getParameter("retailerId"));
                String password = StringUtils.trim(request.getParameter("password"));

				/* 	String HQL = "from DcExperiments as model where model.id="
					+ expId;
					Query query = DAO.getSession().createQuery(HQL);
					ArrayList<DcExperiments> list = (ArrayList<DcExperiments>) query
					.list(); */
                BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
                BargainExperiments bargainExperiments = bargainExperimentsDao
                        .findByKey(Integer.parseInt(expId));

                BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
                BargainParticipant bargainParticipant = bargainParticipantDao
                        .findByKey(Integer.parseInt(participantId));

                JSONObject J_return = new JSONObject();
                J_return.put("action", action);

                if (bargainExperiments != null) {
                    String bargainExperimentName = bargainExperiments.getExperimentName();
                    String psw = bargainExperiments.getRetailerPassword().trim()
                            + bargainParticipant.getNumber();//密码是实验密码+参与者编号

                    if (psw.equals(password)) {
                        J_return.put("loginstatus", "success");
                        J_return.put("experimentType", experimentType);
                        //将该实验的实验参数和参与者id存入session中
                        session.setAttribute("experimentType", experimentType);
                        session.setAttribute("exp", bargainExperiments);
                        session.setAttribute("participantId", participantId);
                    } else {
                        J_return.put("loginstatus", "login failed!\npassword is not right!");
                    }

                    out.clear();
                    out.println(J_return);
                    return;
                } else {
                    J_return.put("loginstatus", "login failed!\nusername is not right!");
                    out.clear();
                    out.println(J_return);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.clear();
                out.println("登陆失败!");
                return;
            }

        }

    } else {
        out.clear();
        out.println("错误的操作参数！");
        return;
    }
%>