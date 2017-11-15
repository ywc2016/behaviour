<%@ page contentType="image/jpeg" import="java.awt.*, java.awt.image.*,java.util.*,javax.imageio.*"
         pageEncoding="UTF-8" %>
<%@ page import="java.io.OutputStream" %>
<%@page import="ielab.util.StringUtils" %>
<%
    try {
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        int width = 50, height = 100, h = 1, maxh = 1;
        if ((StringUtils.isNotEmpty(request.getParameter("h"))) && (StringUtils.isNotEmpty(request.getParameter("maxh")))) {
            h = Integer.parseInt(request.getParameter("h"));
            maxh = Integer.parseInt(request.getParameter("maxh"));
            if (maxh > 0) {
                height = Math.max(height * h / maxh, 1);
            }
        }
        Color c = Color.BLUE;
        if (StringUtils.isNotEmpty(request.getParameter("type"))) {
            if (request.getParameter("type").equals("2")) {
                c = Color.RED;
            } else if (request.getParameter("type").equals("3")) {
                c = Color.YELLOW;
            } else {
                c = Color.GREEN;
            }
        }

        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        OutputStream os = response.getOutputStream();
        Graphics g = image.getGraphics();
        g.setColor(c);
        g.fillRect(0, 0, width, height);
        g.dispose();

        ImageIO.write(image, "JPEG", os);
        os.flush();
        os.close();
        os = null;
        response.flushBuffer();
        out.clear();
        out = pageContext.pushBody();
    } catch (IllegalStateException e) {
        System.out.println(e.getMessage());
        e.printStackTrace();
    }%>