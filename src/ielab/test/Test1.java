package ielab.test;

import ielab.hibernate.DAO;

import java.util.List;

public class Test1 {
	public static void main(String[] args) {
		DAO dao = new DAO();
		try {
			List list_par = dao.selectByHOL("from BargainParameter as a");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
