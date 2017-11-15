<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.util.List" %>
<%@ page import="ielab.hibernate.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="lombok.NonNull" %>
<%@ page language="java" pageEncoding="UTF-8"
         contentType="text/html; charset=UTF-8" %>
<%@include file="../comm.jsp" %>

<%


    String experimentId = request.getParameter("experimentId").toString();
    String participantId1 = request.getParameter("participantId1").toString();

    BargainParticipantDao barParticipantDao = new BargainParticipantDao();
    SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm:ss");

    //创建HSSFWorkbook对象(excel的文档对象)
    XSSFWorkbook wb = new XSSFWorkbook();
//建立新的sheet对象（excel的表单）
    XSSFSheet sheet = wb.createSheet("data");
//在sheet里创建第一行，参数为行索引(excel的行)，可以是0～65535之间的任何一个
    XSSFRow row1 = sheet.createRow(0);
//创建单元格（excel的单元格，参数为列索引，可以是0～255之间的任何一个
    row1.createCell(0).setCellValue("实验轮数");
    row1.createCell(1).setCellValue("供应商");
    row1.createCell(2).setCellValue("零售商");
    row1.createCell(3).setCellValue("谈判状态");
    row1.createCell(4).setCellValue("供应商利润");
    row1.createCell(5).setCellValue("零售商利润");
    row1.createCell(6).setCellValue("开始时间");
    row1.createCell(7).setCellValue("结束时间");
    row1.createCell(8).setCellValue("");
    row1.createCell(9).setCellValue("");
    row1.createCell(10).setCellValue("谈判价格");
    row1.createCell(11).setCellValue("谈判数量");
    row1.createCell(12).setCellValue("出价者");
    row1.createCell(13).setCellValue("对方回应");
    row1.createCell(14).setCellValue("开始时间");
    row1.createCell(15).setCellValue("结束时间");

    String strorderby = "cycle";
    int currentPage = 0;
    List rsList = bargainMatchDao.findMatchForpagination(Integer.parseInt(experimentId),
            Integer.parseInt(participantId1), strorderby, currentPage + "", "4000");
    int cellRowInd = 1;
    BargainExperiments bargainExperiments2 = bargainExperimentsDao.findByKey(Integer.parseInt(experimentId));

    int curCycle = 0;

    for (Object object : rsList) {
        Object[] objects = (Object[]) object;
        BargainMatch bargainMatch = (BargainMatch) objects[0];
        BargainParticipant bargainParticipant1 = (BargainParticipant) objects[1];
        BargainParticipant bargainParticipant2 = (BargainParticipant) objects[2];
        BargainData bargainData2 = bargainMatch.getCurrentDataId() == null
                ? null
                : bargainDataDao.findByKey(bargainMatch.getCurrentDataId());

        int cellColInd = 0;
        XSSFRow row = sheet.createRow(cellRowInd++);
        if (bargainMatch.getCycle() != null && bargainMatch.getCycle() != curCycle) {
            curCycle = bargainMatch.getCycle();
            row.createCell(cellColInd++).setCellValue(curCycle);
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainParticipant1.getNumber() != null) {
            row.createCell(cellColInd++).setCellValue(bargainParticipant1.getNumber());
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainParticipant2.getNumber() != null) {
            row.createCell(cellColInd++).setCellValue(bargainParticipant2.getNumber());
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainMatch.getStatus() != null) {
            row.createCell(cellColInd++).setCellValue(bargainMatch.getStatus());
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainMatch.getSupplierProfits() != null) {
            row.createCell(cellColInd++).setCellValue(bargainMatch.getSupplierProfits());
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainMatch.getRetailerProfits() != null) {
            row.createCell(cellColInd++).setCellValue(bargainMatch.getRetailerProfits());
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainMatch.getBeginTime() != null) {
            row.createCell(cellColInd++).setCellValue(sdf.format(bargainMatch.getBeginTime()));
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }
        if (bargainMatch.getEndTime() != null) {
            row.createCell(cellColInd++).setCellValue(sdf.format(bargainMatch.getEndTime()));
        } else {
            row.createCell(cellColInd++).setCellValue("");
        }

        //写入该次match的多次data


        List<BargainData> bargainDataList = bargainDataDao.findByPropertyEqual("matchId", bargainMatch.getId().toString(), "long");
        for (BargainData bargainData : bargainDataList) {
            XSSFRow row2 = sheet.createRow(cellRowInd++);
            cellColInd = 10;
            if (bargainData.getPrice() != null) {
                row2.createCell(cellColInd++).setCellValue(bargainData.getPrice());
            } else {
                row.createCell(cellColInd++).setCellValue("");
            }
            if (bargainData.getQuantity() != null) {
                row2.createCell(cellColInd++).setCellValue(bargainData.getQuantity());

            } else {
                row.createCell(cellColInd++).setCellValue("");

            }
            if (bargainData.getParticipantId() != null && bargainParticipantDao
                    .findByKey(bargainData.getParticipantId()).getNumber() != null) {
                row2.createCell(cellColInd++).setCellValue(bargainParticipantDao
                        .findByKey(bargainData.getParticipantId()).getNumber());

            } else {
                row.createCell(cellColInd++).setCellValue("");

            }
            if (bargainData.getAcceptStatus() != null) {
                row2.createCell(cellColInd++).setCellValue(bargainData.getAcceptStatus() == 1 ? "接受出价" :
                        (bargainData.getAcceptStatus() == 2 ? "继续谈判" : "终止谈判"));

            } else {
                row.createCell(cellColInd++).setCellValue("");

            }
            if (bargainData.getBeginTime() != null) {
                row2.createCell(cellColInd++).setCellValue(sdf.format(bargainData.getBeginTime()));

            } else {
                row.createCell(cellColInd++).setCellValue("");

            }
            if (bargainData.getFinishTime() != null) {
                row2.createCell(cellColInd++).setCellValue(sdf.format(bargainData.getFinishTime()));

            } else {
                row.createCell(cellColInd++).setCellValue("");

            }

        }

    }

//输出Excel文件

    try {
        // 清空response
        response.reset();
        // 设置response的Header
        response.addHeader("Content-Disposition", "attachment;filename="
                + bargainExperiments2.getExperimentName() + ".xlsx");
        OutputStream toClient = new BufferedOutputStream(
                response.getOutputStream());
        response.setContentType("application/vnd.ms-excel;charset=gb2312");
        wb.write(toClient);
        toClient.flush();
        toClient.close();
    } catch (IOException ex) {
        ex.printStackTrace();
    }
%>