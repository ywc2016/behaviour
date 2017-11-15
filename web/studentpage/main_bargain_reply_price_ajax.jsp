<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="ielab.dao.BargainDataDao" %>
<%@page import="ielab.dao.BargainMatchDao" %>
<%@page import="ielab.dao.BargainParameterDao" %>
<%@page import="ielab.dao.BargainParticipantDao" %>
<%@page import="ielab.hibernate.*" %>
<%@page import="ielab.util.BargainPointCalculate" %>
<%@page import="ielab.util.StringUtils" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="java.util.Date" %>
<%@include file="../comm.jsp" %>

<%
    Log logger = LogFactory.getLog("lab.util.*");
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
        out.clear();
        out.println("取得request值失败!");
        return;
    }


    String identity = null;
    BargainMatch bargainMatch = null;
    BargainData bargainData = null;
    BargainParameter bargainParameter = null;

    if (bargainParticipant.getStatus().equals("谈判中")) {
        bargainMatch = bargainMatchDao.findByKey(bargainParticipant.getMatchId());

        identity = bargainMatch.getParticipantId().equals(bargainParticipant.getId()) ? "first" : "second";

        bargainData = bargainDataDao.findByKey(bargainMatch.getCurrentDataId());

        bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId());
    }
    //处理不同的action
    if (action.equals("bargain")) {//提交谈判价格和谈判数量
        try {
            String price = StringUtils.trim(request.getParameter("price"));
            String quantity = StringUtils.trim(request.getParameter("quantity"));

            // 保存提交的数据

            bargainData.setFinishTime(new Timestamp(new Date().getTime()));
            bargainData.setMatchId(bargainMatch.getId());
            bargainData.setPrice(Double.parseDouble(price));
            bargainData.setQuantity(Integer.parseInt(quantity));
            bargainData.setParticipantId(bargainParticipant.getId());
            bargainDataDao.update(bargainData);

            //将match的参与者状态修改为出价完毕
            if (identity.equals("first")) {
                bargainMatch.setParticipantStatus("出价完毕");
                bargainMatch.setSecomdParticipantStatus("回应出价");
            } else {
                bargainMatch.setSecomdParticipantStatus("出价完毕");
                bargainMatch.setParticipantStatus("回应出价");
            }

            bargainMatchDao.update(bargainMatch);

            JSONObject J_return = new JSONObject();
            J_return.put("action", action);
            J_return.put("status", "success");
            out.clear();
            out.println(J_return);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            out.clear();
            out.println("提交失败，请重新提交!");
            return;
        }
    } else if (action.equals("timer")) {

        int status = bargainExperiments.getExperimentState();

        JSONObject J_return = new JSONObject();
        J_return.put("action", action);

        if (status == 0) {//未结束
            //	int participantId = (int) session
            //			.getAttribute("participantId");
            if (bargainParticipant.getStatus().equals("离线")) {
                bargainParticipant.setStatus("空闲中");
                bargainParticipantDao.update(bargainParticipant);
                J_return.put("status", "空闲中");
            } else if (bargainParticipant.getStatus().equals("空闲中")) {
                J_return.put("status", "空闲中");
            } else if (bargainParticipant.getStatus().equals("谈判中")) {

                if (identity.equals("first")) {
                    if (bargainMatch.getParticipantStatus().equals("出价中")) {
                        J_return.put("status", "first");
                    } else {
                        J_return.put("status", "wait");

                    }
                } else {//第二出价者
                    if (bargainMatch.getSecomdParticipantStatus().equals("出价中")) {
                        J_return.put("status", "second");
                    } else {
                        J_return.put("status", "wait");

                    }
                }
                //J_return.put("remainingTime", remainingTime);
            }

            //倒计时提示
            if (bargainMatch.getBeginTime() != null) {
                long leftSeconds = (bargainParameter.getOneRoundTime()
                        - (new Date().getTime() - bargainMatch.getBeginTime().getTime()) / 1000) >= 0
                        ? (bargainParameter.getOneRoundTime()
                        - (new Date().getTime() - bargainMatch.getBeginTime().getTime()) / 1000)
                        : 0;
                J_return.put("leftSeconds", leftSeconds);

                if (bargainMatch.getEndTime() != null) {//本次谈判已经结束
                    J_return.put("action", "timeout");
                    out.clear();
                    out.println(J_return);
                    return;
                }

                if (leftSeconds == 0 && bargainMatch.getEndTime() == null) {//写入谈判终止时间

                    Date now = new Date();
                    //bargainMatch设置谈判结束时间
                    //超过最大时限 设置为最长谈判时间时间
                    bargainData.setFinishTime(new Timestamp(bargainData.getBeginTime().getTime()
                            + bargainParameter.getDecisionTime() * 1000));
                    bargainData.setAcceptStatus(3);
                    bargainDataDao.update(bargainData);

                    bargainMatch.setEndTime(new Timestamp(bargainMatch.getBeginTime().getTime()
                            + bargainParameter.getOneRoundTime() * 1000));

                    if (identity.equals("first")) {
                        bargainMatch.setParticipantStatus("出价完毕");
                    } else {
                        bargainMatch.setSecomdParticipantStatus("出价完毕");
                    }

                    BargainPointCalculate bargainPointCalculate = new BargainPointCalculate();

                    bargainMatch.setSupplierProfits(bargainPointCalculate.calculateDisagreeSupplier(bargainData.getPrice(),
                            bargainData.getQuantity(), bargainParameter.getK(), bargainParameter.getC(),
                            bargainParameter.getA(), bargainParameter.getB(), bargainParameter.getP(),
                            bargainExperiments.getRandomNeed()));

                    bargainMatch.setRetailerProfits(bargainPointCalculate.calculateDisagreeRetailer(bargainData.getPrice(),
                            bargainData.getQuantity(), bargainParameter.getK(), bargainParameter.getC(),
                            bargainParameter.getA(), bargainParameter.getB(), bargainParameter.getP(),
                            bargainExperiments.getRandomNeed()));

                    bargainMatch.setParticipantStatus("查看结果");
                    bargainMatch.setSecomdParticipantStatus("查看结果");
                    bargainMatchDao.update(bargainMatch);

                    J_return.put("action", "timeout");
                }
            }

//            if (bargainData.getBeginTime() != null) {
//                long leftDecisionSeconds = (bargainParameter.getDecisionTime()
//                        - (new Date().getTime() - bargainData.getBeginTime().getTime()) / 1000) >= 0
//                        ? (bargainParameter.getDecisionTime()
//                        - (new Date().getTime() - bargainData.getBeginTime().getTime()) / 1000)
//                        : 0;
//                J_return.put("leftDecisionSeconds", leftDecisionSeconds);
//
//                if (bargainData.getFinishTime() != null) {//本次谈判已经结束
//                    J_return.put("action", "decisionTimeout");
//                    out.clear();
//                    out.println(J_return);
//                    return;
//                }
//
//                if (leftDecisionSeconds == 0 && bargainData.getFinishTime() == null) {//写入决策终止时间
//
//                    Date now = new Date();
//                    //bargainData设置决策结束时间
//                    //超过最大时限 设置为最长谈判时间时间
//                    bargainData.setFinishTime(new Timestamp(bargainData.getBeginTime().getTime()
//                            + bargainParameter.getDecisionTime() * 1000));
//                    bargainData.setAcceptStatus(3);
//                    bargainDataDao.update(bargainData);
//
//                    if (identity.equals("first")) {
//                        bargainMatch.setParticipantStatus("出价完毕");
//                    } else {
//                        bargainMatch.setSecomdParticipantStatus("出价完毕");
//                    }
//
//                    BargainPointCalculate bargainPointCalculate = new BargainPointCalculate();
//
//                    bargainMatch.setSupplierProfits(bargainPointCalculate.calculateDisagreeSupplier(bargainData.getPrice(),
//                            bargainData.getQuantity(), bargainParameter.getK(), bargainParameter.getC(),
//                            bargainParameter.getA(), bargainParameter.getB(), bargainParameter.getP(),
//                            bargainExperiments.getRandomNeed()));
//
//                    bargainMatch.setRetailerProfits(bargainPointCalculate.calculateDisagreeRetailer(bargainData.getPrice(),
//                            bargainData.getQuantity(), bargainParameter.getK(), bargainParameter.getC(),
//                            bargainParameter.getA(), bargainParameter.getB(), bargainParameter.getP(),
//                            bargainExperiments.getRandomNeed()));
//
//                    bargainMatch.setParticipantStatus("查看结果");
//                    bargainMatch.setSecomdParticipantStatus("查看结果");
//                    bargainMatchDao.update(bargainMatch);
//
//                    J_return.put("action", "timeout");
//                }
//            }

        } else {//已结束
            J_return.put("status", "实验已结束");
        }
        out.clear();
        out.println(J_return);
        return;

    } else if (action.equals("reply2")) {//继续谈判
        bargainData.setAcceptStatus(2);
        bargainDataDao.update(bargainData);

        BargainData bargainData2 = new BargainData();
        bargainData2.setBeginTime(new Timestamp(new Date().getTime()));
        bargainData2.setMatchId(bargainMatch.getId());
        bargainDataDao.save(bargainData2);
        if (identity.equals("first")) {
            bargainMatch.setParticipantStatus("出价中");
        } else {
            bargainMatch.setSecomdParticipantStatus("出价中");
        }
        bargainMatch.setCurrentDataId(bargainData2.getId());
        bargainMatchDao.update(bargainMatch);

        JSONObject J_return = new JSONObject();
        J_return.put("action", action);
        out.clear();
        out.println(J_return);
        return;
    } else if (action.equals("reply1")) {//接受出价
        Date now = new Date();
        //bargainMatch设置谈判结束时间
        if (bargainParameter.getOneRoundTime() * 1000 - (now.getTime() - bargainMatch.getBeginTime().getTime()) > 0l) {
            bargainMatch.setEndTime(new Timestamp(now.getTime()));
        } else {//超过最大时限 设置为最长谈判时间时间
            bargainMatch.setEndTime(new Timestamp(bargainMatch.getBeginTime().getTime()
                    + bargainParameter.getOneRoundTime() * 1000));
        }
        // todo
        System.out.println("=============================" + bargainMatch.getEndTime());

        bargainData.setAcceptStatus(1);
        bargainDataDao.update(bargainData);

        if (identity.equals("first")) {
            bargainMatch.setParticipantStatus("出价完毕");
        } else {
            bargainMatch.setSecomdParticipantStatus("出价完毕");
        }

        BargainPointCalculate bargainPointCalculate = new BargainPointCalculate();

        bargainMatch.setSupplierProfits(
                bargainPointCalculate.calculateAgreeSupplier(bargainData.getPrice(), bargainData.getQuantity(),
                        bargainParameter.getK(), bargainParameter.getC(), bargainParameter.getA(),
                        bargainParameter.getB(), bargainParameter.getP(), bargainExperiments.getRandomNeed()));

        bargainMatch.setRetailerProfits(
                bargainPointCalculate.calculateAgreeRetailer(bargainData.getPrice(), bargainData.getQuantity(),
                        bargainParameter.getK(), bargainParameter.getC(), bargainParameter.getA(),
                        bargainParameter.getB(), bargainParameter.getP(), bargainExperiments.getRandomNeed()));

        bargainMatch.setParticipantStatus("查看结果");
        bargainMatch.setSecomdParticipantStatus("查看结果");
        bargainMatchDao.update(bargainMatch);

        //还原参与者状态
        JSONObject J_return = new JSONObject();
        J_return.put("action", action);
        out.clear();
        out.println(J_return);
        return;
    } else if (action.equals("reply3")) {//终止谈判

        //bargainMatch设置谈判结束时间
        Date now = new Date();
        if (bargainParameter.getOneRoundTime() - (now.getTime() - bargainMatch.getBeginTime().getTime()) > 0) {
            bargainMatch.setEndTime(new Timestamp(now.getTime()));
        } else {//超过最大时限 设置为最长谈判时间时间
            bargainMatch.setEndTime(new Timestamp(bargainMatch.getBeginTime().getTime()
                    + bargainParameter.getOneRoundTime() * 1000));
        }


        bargainData.setAcceptStatus(3);
        bargainDataDao.update(bargainData);

        if (identity.equals("first")) {
            bargainMatch.setParticipantStatus("出价完毕");
        } else {
            bargainMatch.setSecomdParticipantStatus("出价完毕");
        }

        BargainPointCalculate bargainPointCalculate = new BargainPointCalculate();

        bargainMatch.setSupplierProfits(bargainPointCalculate.calculateDisagreeSupplier(bargainData.getPrice(),
                bargainData.getQuantity(), bargainParameter.getK(), bargainParameter.getC(),
                bargainParameter.getA(), bargainParameter.getB(), bargainParameter.getP(),
                bargainExperiments.getRandomNeed()));

        bargainMatch.setRetailerProfits(bargainPointCalculate.calculateDisagreeRetailer(bargainData.getPrice(),
                bargainData.getQuantity(), bargainParameter.getK(), bargainParameter.getC(),
                bargainParameter.getA(), bargainParameter.getB(), bargainParameter.getP(),
                bargainExperiments.getRandomNeed()));

        bargainMatch.setParticipantStatus("查看结果");
        bargainMatch.setSecomdParticipantStatus("查看结果");
        bargainMatchDao.update(bargainMatch);

        //还原参与者状态
        JSONObject J_return = new JSONObject();
        J_return.put("action", action);
        out.clear();
        out.println(J_return);
        return;
    } else if (action.equals("finishCheck")) {
        if (identity.equals("first")) {
            bargainMatch.setParticipantStatus("匹配结束");
        } else if (identity.equals("second")) {
            bargainMatch.setSecomdParticipantStatus("匹配结束");
        }
        //检查match的状态
        if (bargainMatch.getParticipantStatus().equals("匹配结束")
                && bargainMatch.getSecomdParticipantStatus().equals("匹配结束")) {
            bargainMatch.setStatus("已完成");
        }

        bargainParticipant.setStatus("空闲中");
        bargainParticipant.setMatchId(null);
        bargainParticipantDao.update(bargainParticipant);

        bargainMatchDao.update(bargainMatch);

        JSONObject J_return = new JSONObject();
        J_return.put("action", action);
        out.clear();
        out.println(J_return);
    } else {
        out.clear();
        out.println("错误的操作参数！");
        return;
    }
%>