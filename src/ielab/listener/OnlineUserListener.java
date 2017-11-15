package ielab.listener;

import ielab.dao.BargainParticipantDao;
import ielab.hibernate.BargainExperiments;
import ielab.hibernate.BargainParticipant;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class OnlineUserListener implements HttpSessionListener {
	public void sessionCreated(HttpSessionEvent event) {
	}

	public void sessionDestroyed(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		ServletContext application = session.getServletContext();
		if (session.getAttribute("experimentType") != null) {
			if (session.getAttribute("experimentType").toString()
					.equals("bargain")) {// 是谈判,注销用户
				BargainExperiments bargainExperiments = (BargainExperiments) session
						.getAttribute("exp");
				int participantId = Integer.parseInt(session
						.getAttribute("participantId").toString());

//				BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
//				BargainParticipant bargainParticipant = bargainParticipantDao
//						.findByKey(participantId);
//				bargainParticipant.setStatus("离线");
//				bargainParticipantDao.update(bargainParticipant);
			}
		}
		// 取得登录的用户名
		String username = (String) session.getAttribute("participantId");
		// 从在线列表中删除用户名
		// List onlineUserList = (List)
		// application.getAttribute("onlineUserList");
		// onlineUserList.remove(username);
		System.out.println(username + "超时退出");
	}
}