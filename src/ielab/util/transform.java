package ielab.util;

import ielab.hibernate.DcExperiments;
import ielab.hibernate.DAO;
import ielab.hibernate.DcData;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Currency;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 * 功能描述：
 * 根据其它页面传过来的实验参数（exp）和零售商id号（retailerId），（均存在session中，如果session中没有该值或取session值出现错误，则转入登陆页面。重新登陆。）
 * 找到该实验到目前位置已经进行到的周期数，将现在的周期数存到session中
 * 找到对应的retailer的实验状态
 * 普通retailer（1,2,3,4,5）的状态有3种：0，1，2
 * 0：该周期实验还没开始，既没有向供应商提交订单。又没有向顾客发布售价。
 * 1：表示该周期该零售商已经向供应商提交了订单，还没有向顾客发布售价，该状态应该转发到提交订单等待页面。
 * 2：表示该周期该零售商已经向供应商提交了订单，并且也已经向顾客发布了售价，该状态应该转发到发布售价等待页面。
 * 表示供应商的retailer（0）的状态标志该期实验的状态，有四种
 * 0：表示该期实验还没开始，至少有一位零售商，既没有向供应商提交订单。又没有向顾客发布售价。
 * 1：表示该周期所有零售商已经向供应商提交了订单，零售商还没有向顾客发布售价。
 * 2：表示该周期所有零售商已经向供应商提交了订单，并且也已经向顾客发布了售价，即表示该期实验已经完成。
 * 3：表示该周期所有零售商都已经提交订单，或者提交订单时间已经到达。某个零售商正在进行数据更新。由某个零售商负责更新数据，其它零售商在等待。更新完成后状态变为1，并进入提交售价界面。
 * 4：表示该周期所有零售商都已经提交售价，或者提交售价时间已经到达。某个零售商正在进行数据更新。由某个零售商负责更新数据，其它零售商在等待。更新完成后状态变为2，并进入下一周期。
 */
public class transform extends HttpServlet {

	public transform() {
		super();
	}

	public void destroy() {
		super.destroy();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
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

		DcExperiments exp = null;
		String retailerId = "";
		String strHQL = "";

		int CurrentCycle = 1;
		ArrayList<DcData> list_current = null;
		DcData data_last = null;
		DcData data_current = null;
		DcData data_DC = null;
		DAO DAO = new DAO();
		try {
			exp = (DcExperiments) session.getAttribute("exp");
			retailerId = session.getAttribute("retailerId").toString();

			// 取得该实验已经完成的期数。
			strHQL = "select count(*) from DcData as model where model.dcExperiments.id="
					+ exp.getId() + " and model.retailerId=0 and model.tag=2";
			CurrentCycle += ((Integer) DAO.selectByHOL(strHQL).iterator()
					.next()).intValue();

			// 取出当前周期数据，判断该retailer是否已经提交订单
			ArrayList<DcData> list = null;
			// 取得上周期和本周期的数据，如果为第一周期，则没有上周期数据
			strHQL = "from DcData as model where model.retailerId="
					+ retailerId + " and model.dcExperiments.id=" + exp.getId()
					+ " and model.cycle>=" + (CurrentCycle - 1)
					+ " and model.cycle<=" + (CurrentCycle);
			list = DAO.selectByHOL(strHQL);
			if (CurrentCycle == 1) {
				if (list.size() == 1) {
					data_current = list.get(0);
				} else {
					out.println("取到的零售商数据错误！第一周期的数据");
					return;
				}
			} else {
				if (list.size() == 2) {
					data_last = list.get(0);
					data_current = list.get(1);
				} else {
					out.println("取到的零售商数据错误！大于两周期的数据");
					return;
				}
			}

			// 取得本周期其它零售商的数据，包括DC的数据
			strHQL = "from DcData as model where model.dcExperiments.id="
					+ exp.getId() + " and model.cycle=" + CurrentCycle
					+ " order by model.retailerId";
			list = DAO.selectByHOL(strHQL);
			if (list.size() == (exp.getDcParameters().getNumberofRetailer() + 1)) {
				data_DC = list.get(0);
				list.remove(0);
				list_current = list;
			} else {
				out.println("取到的其它零售商数据错误！包括DC的数据");
				return;
			}

			// 将数据存到session中。
			session.setAttribute("exp", exp);
			session.setAttribute("retailerId", retailerId);
			session.setAttribute("CurrentCycle", CurrentCycle);
			session.setAttribute("data_last", data_last);
			session.setAttribute("data_current", data_current);
			session.setAttribute("data_DC", data_DC);
			session.setAttribute("list_current", list_current);

			// 根据各个状态进行转发
			if (CurrentCycle > exp.getDcParameters().getTotalCycle()) {
				// 实验结束
				CurrentCycle = exp.getDcParameters().getTotalCycle();
				session.setAttribute("CurrentCycle", CurrentCycle);
				response.sendRedirect(basePath + "studentpage/finished.jsp");
				return;
			}

			if (data_current.getTag() == 0) {
				// 如果状态为0，该周期实验还没开始，既没有向供应商提交订单。又没有向顾客发布售价。转入下订单页面
				response.sendRedirect(basePath + "studentpage/main_order.jsp");
				return;
			} else if (data_current.getTag() == 1) {
				// 如果状态为1，表示该周期该零售商已经向供应商提交了订单，还没有向顾客发布售价
				if (data_DC.getTag() == 1) {
					// 如果该周期提交订单数据已经更新完毕，该状态应该转发到提交售价页面。
					response.sendRedirect(basePath
							+ "studentpage/main_order.jsp");// wangxiaofang 跳过售价
					return;
				} else {
					// 如果该周期提交订单数据没有更新完毕，该状态应该转发到提交订单等待页面。
					response.sendRedirect(basePath
							+ "studentpage/waiting_order.jsp");
					return;
				}
			} else if (data_current.getTag() == 2) {
				// 如果状态为2，表示该周期该零售商已经向供应商提交了订单，并且也已经向顾客发布了售价，该状态应该转发到发布售价等待页面。
				response.sendRedirect(basePath
						+ "studentpage/waiting_price.jsp");
				return;
			}

		} catch (Exception e) {
			response.sendRedirect(basePath + "studentpage/login.jsp");
		}
		out.flush();
		out.close();
	}

	public void init() throws ServletException {
	}
}
