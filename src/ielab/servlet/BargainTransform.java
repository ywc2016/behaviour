package ielab.servlet;

import ielab.dao.BargainDataDao;
import ielab.dao.BargainMatchDao;
import ielab.dao.BargainParticipantDao;
import ielab.hibernate.BargainData;
import ielab.hibernate.BargainExperiments;
import ielab.hibernate.BargainMatch;
import ielab.hibernate.BargainParticipant;
import ielab.util.NetOption;
import ielab.util.StringUtils;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BargainTransform extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();

		String path = request.getContextPath();
		String basePath = request.getScheme() + "://" + request.getServerName()
				+ ":" + request.getServerPort() + path + "/";

		if (StringUtils.isEmpty(session.getAttribute("exp"))) {
			out.println("读取session数据失败，");
			response.sendRedirect(basePath + "studentpage/login.jsp");
			return;
		}

		// TODO 验证ip
		// if (!NetOption.ValidIP(request.getRemoteHost())) {
		// out.println("<script type=\"text/javascript\">"
		// + "alert(\"对不起，您的ip地址不在实验授权范围内，不能进行实验!\");"
		// + "window.location.href=\"" + basePath
		// + "studentpage/login.jsp\"" + "</script>");
		// return;
		// }

		String status = request.getParameter("status");
		int participantId = Integer.parseInt(session.getAttribute(
				"participantId").toString());
		BargainExperiments bargainExperiments = (BargainExperiments) session
				.getAttribute("exp");

		BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
		BargainParticipant bargainParticipant = bargainParticipantDao
				.findByKey(participantId);

		if (status == null) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_idle.jsp");
		} else if (status.equals("离线")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_idle.jsp");
		} else if (status.equals("空闲中")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_idle.jsp");
		} else if (status.equals("谈判中")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_price.jsp");
		} else if (status.equals("出价完毕")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_price_finish.jsp");
		} else if (status.equals("回应出价")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_reply_price.jsp");
		} else if (status.equals("查看结果")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_price_result.jsp");
		} else if (status.equals("reply3")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_price_result.jsp");
		} else if (status.equals("谈判完毕")) {
			response.sendRedirect(basePath
					+ "studentpage/main_bargain_all_finish.jsp");
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
}
