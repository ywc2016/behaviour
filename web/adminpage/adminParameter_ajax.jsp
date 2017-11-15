<%@page import="ielab.hibernate.BargainExperiments" %>
<%@page import="java.util.List" %>
<%@page import="ielab.dao.BargainExperimentsDao" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.BargainParameterDao" %>
<%@page import="ielab.hibernate.BargainParameter" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="java.util.ArrayList" %>
<%@page import="ielab.hibernate.DAO" %>
<%@page import="ielab.hibernate.Admin" %>
<%@page import="ielab.hibernate.DcParameters" %>
<%
    Admin admin = null;
    DAO DAO = new DAO();
    try {
        if (StringUtils.isEmpty(session.getAttribute("admin"))) {
            out.clear();
            out.println("session过期，请重新登陆");
            return;
        }
        admin = (Admin) session.getAttribute("admin");
    } catch (Exception e) {
        out.clear();
        out.println("session过期，请重新登陆");
        return;
    }

    //取得action参数
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

    //获取实验类型参数
    String experimentType = null;
    if (StringUtils.isNotEmpty(request.getParameter("experimentType"))) {
        experimentType = request.getParameter("experimentType");
    } else {
        out.clear();
        out.println("获取操作参数失败！");
    }

    if (action.equals("addNew")) {
        try {
            String a_name = StringUtils.trim(request.getParameter("a_name").replaceAll("'", "''"));
            String a_distributionScheme = StringUtils.trim(request.getParameter("a_distributionScheme"));
            String a_numberofRetailer = StringUtils.trim(request.getParameter("a_numberofRetailer"));
            String a_totalCycle = StringUtils.trim(request.getParameter("a_totalCycle"));
            String a_demand = StringUtils.trim(request.getParameter("a_demand"));
            String a_initialPurchasePrice = StringUtils.trim(request.getParameter("a_initialPurchasePrice"));
            String a_initialSellingPrice = StringUtils.trim(request.getParameter("a_initialSellingPrice"));
            String a_dcinitialInventory = StringUtils.trim(request.getParameter("a_dcinitialInventory"));
            String a_infoDegree = StringUtils.trim(request.getParameter("a_infoDegree"));
            String a_cycleTime = StringUtils.trim(request.getParameter("a_cycleTime"));

            DcParameters a_exp_new = new DcParameters();

            a_exp_new.setName(a_name);
            a_exp_new.setDistributionScheme(Integer.parseInt(a_distributionScheme));
            a_exp_new.setNumberofRetailer(Integer.parseInt(a_numberofRetailer));
            a_exp_new.setTotalCycle(Integer.parseInt(a_totalCycle));
            //			a_exp_new.setTotalCycle(Integer.parseInt(a_numberofRetailer)-1);
            a_exp_new.setInitialPurchasePrice(Integer.parseInt(a_initialPurchasePrice));
            a_exp_new.setInitialSellingPrice(Integer.parseInt(a_initialSellingPrice));
            a_exp_new.setDcinitialInventory(Integer.parseInt(a_dcinitialInventory));
            a_exp_new.setInfoDegree(Integer.parseInt(a_infoDegree));
            a_exp_new.setCycleTime(Integer.parseInt(a_cycleTime) * 1000);
            a_exp_new.setDemand(Integer.parseInt(a_demand));

            DAO.insert(a_exp_new);

            out.clear();
            out.println("addsuccess");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("添加失败!");
            return;
        }
    } else if (action.equals("addNewBargainParameter")) {
        try {
            String a_name = StringUtils.trim(request.getParameter("a_name").replaceAll("'", "''"));
            String a_numberOfPerson = StringUtils.trim(request.getParameter("a_numberOfPerson"));
            String a_cycleTime = StringUtils.trim(request.getParameter("a_cycleTime"));
            //String ma = StringUtils.trim(request.getParameter("MA"));
            //454String mb = StringUtils.trim(request.getParameter("MB"));
            String k = StringUtils.trim(request.getParameter("k"));
            String c = StringUtils.trim(request.getParameter("c"));
            String a = StringUtils.trim(request.getParameter("a"));
            String b = StringUtils.trim(request.getParameter("b"));
            String p = StringUtils.trim(request.getParameter("p"));
            String oneRoundTime = StringUtils.trim(request.getParameter("oneRoundTime"));

            BargainParameter bargainParameter = new BargainParameter();

            bargainParameter.setName(a_name);
            bargainParameter.setNumberOfPerson(Integer.parseInt(a_numberOfPerson));
            bargainParameter.setDecisionTime(Integer.parseInt(a_cycleTime));
            //bargainParameter.setMa(Double.parseDouble(ma));
            //bargainParameter.setMb(Double.parseDouble(mb));
            bargainParameter.setK(Double.parseDouble(k));
            bargainParameter.setC(Double.parseDouble(c));
            bargainParameter.setA(Integer.parseInt(a));
            bargainParameter.setB(Integer.parseInt(b));
            bargainParameter.setP(Double.parseDouble(p));
            bargainParameter.setOneRoundTime(Integer.parseInt(oneRoundTime));

            BargainParameterDao bargainParameterDao = new BargainParameterDao();
            bargainParameterDao.save(bargainParameter);
            //DAO.insert(bargainParameter);
            out.clear();
            out.println("addsuccess");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("添加失败!");
            return;
        }
    } else if (action.equals("delete")) {
        if (experimentType.equals("game")) {
            try {
                String outStr = "deletesuccess";
                String deleteid = StringUtils.trim(request.getParameter("deleteid"));
                ArrayList<DcParameters> list_par = DAO
                        .selectByHOL("from DcParameters as model where model.id=" + deleteid);
                DcParameters par = new DcParameters();
                if (list_par.size() > 0) {
                    par = list_par.get(0);
                    if (par.getDcExperimentses().size() > 0) {
                        outStr = "删除失败\n该组实验参数已经用于创建实验，不允许删除！";
                    } else {
                        DAO.getSession().delete(par);
                    }
                } else {
                    outStr = "删除失败\n不存在该实验参数！";
                }

                out.clear();
                out.println(outStr);
                return;
            } catch (Exception e) {
                out.clear();
                out.println("删除失败\n" + e.toString());
                return;
            }
        } else if (experimentType.equals("bargain")) {
            String outStr = "deletesuccess";
            String deleteid = StringUtils.trim(request.getParameter("deleteid"));
            BargainParameterDao bargainParameterDao = new BargainParameterDao();
            BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();

            List<BargainExperiments> bargainExperiments = bargainExperimentsDao.findByPropertyEqual("parId",
                    deleteid, "int");
            if (bargainExperiments.size() > 0) {//有实验使用改组参数,不可删除
                outStr = "删除失败\n该组实验参数已经用于创建实验，不允许删除！";
            } else {
                bargainParameterDao.delete(bargainParameterDao.findByKey(Integer.parseInt(deleteid)));
            }

            out.clear();
            out.println(outStr);
            return;

        }
    } else {
        out.clear();
        out.println("错误的操作参数！");
        return;
    }
%>