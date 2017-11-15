package ielab.util;

import ielab.util.RandomGenerator;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import ielab.hibernate.Admin;
import ielab.hibernate.DAO;
import ielab.hibernate.DcData;
import ielab.hibernate.DcExperiments;
import ielab.hibernate.HibernateSessionFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.Session;

public class initialDcData {
	private static Log logger = LogFactory.getLog("ielab.util.*");

	/**
	 * @param args
	 * @throws ParseException
	 */
	public void main(String[] args) throws ParseException {
		// find();
		// getexp();
		// insertDCexperiment();
		// insertDCData();
		// testlog4j();
		initialDCData(1);
	}

	public void testlog4j() {
		Log logger = LogFactory.getLog("org.hibernate.");
		logger.error("dasfds");
	}

	public void find() {

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String Datetime = df.format(new Date());
		System.out.println(Datetime);
		DAO DAO = new DAO();
		Date nowDay = new Date(System.currentTimeMillis());

		SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ITALIAN);
		System.out.println(sdft.format(nowDay));

		Session session = DAO.getSession();
		session.beginTransaction();
		String HQL = "from DcExperiments as model where model.experimentState=1 and model.admin.id=:id and model.beginTime<=:now and model.overTime>=:now";
		Query query = session.createQuery(HQL);
		query.setTimestamp("now", nowDay);
		query.setInteger("id", 2);
		List list = query.list();
		session.getTransaction().commit();
		// List adminList = DAO.selectByHOL("from Admin as model where
		// model.supadmin=" + (byte) 0);
		// adminList=DAO.selectByHOL("from DcData as model where
		// model.dcExperiments.id=3");
		for (int i = 0; i < list.size(); i++) {
			Integer tc = ((DcExperiments) list.get(i)).getId();
			System.out.print(tc);

		}
		try {
			HibernateSessionFactory.commitTransaction();
		} catch (Exception e) {
			HibernateSessionFactory.rollbackTransaction();
		} finally {
			HibernateSessionFactory.closeSession();
		}
	}

	public void insertDCexperiment() {
		DAO DAO = new DAO();
		List adminList = DAO.selectByHOL("from Admin");
		Admin admin = (Admin) adminList.get(0);
		admin.setName("卢稳岩");
		DcExperiments dcexperiment = new DcExperiments(admin);

		dcexperiment.setBeginTime(new Date());
		dcexperiment.getDcParameters().setDcinitialInventory(400);
		dcexperiment.setExperimentName("第二组实验");
		dcexperiment.setExperimentState(0);
		dcexperiment.getDcParameters().setInfoDegree(3);
		dcexperiment.getDcParameters().setInitialPurchasePrice(80);
		dcexperiment.getDcParameters().setInitialSellingPrice(120);
		dcexperiment.getDcParameters().setNumberofRetailer(5);
		dcexperiment.setOverTime(new Date());
		dcexperiment.setRetailerPassword("llllll");
		dcexperiment.getDcParameters().setTotalCycle(100);
		DAO.insert(dcexperiment);
		try {
			HibernateSessionFactory.commitTransaction();
		} catch (Exception e) {
			HibernateSessionFactory.rollbackTransaction();
		} finally {
			HibernateSessionFactory.closeSession();
		}
	}

	public void getexp() {
		String AdminId = "2";
		String printout = "";
		DAO DAO = new DAO();
		if (AdminId != null) {
			try {
				List adminList = DAO.selectByHOL("from Admin as model where model.id=" + Integer.parseInt(AdminId));
				Set set = ((Admin) adminList.get(0)).getDcExperimentses();
				List list = new ArrayList(set);
				for (int i = 0; i < list.size(); i++) {
					String name = ((DcExperiments) list.get(i)).getExperimentName();
					String value = ((DcExperiments) list.get(i)).getId().toString();
					printout += value + "**" + name + "$$";
				}
				System.out.print(printout);
			} catch (Exception e) {
				System.out.print(e.toString());
			}
		}
	}

	public String initialDCData(int expId) {
		DAO DAO = new DAO();
		try {
			List expList = DAO.selectByHOL("from DcExperiments as model where model.id=" + expId);
			if (expList.size() == 0) {
				return "初始化失败，不存在该实验！";
			}
			DcExperiments exp = (DcExperiments) expList.get(0);

			String DcParametersName = exp.getDcParameters().getName();
			// System.out.print("初始化实验使用的参数:"+DcParametersName);

			DAO.executeBySQL("delete from dc_data where ExperimentID=" + expId);

			for (int i = 1; i <= exp.getDcParameters().getTotalCycle() + 1; i++) {
				int orderIn = (int) RandomGenerator.nextNormal(30, 36);
				for (int j = 0; j <= exp.getDcParameters().getNumberofRetailer(); j++) {
					DcData dcData = new DcData();
					dcData.setDcExperiments(exp);
					dcData.setRetailerId(j);
					dcData.setCycle(i);

					dcData.setInventory((float) 0);
					dcData.setCompetitor(0);
					dcData.setBacklogCost((float) 0);
					dcData.setGoodsCost((float) 0);
					dcData.setGoodsIn((float) 0);
					dcData.setGoodsIncome((float) 0);
					dcData.setGoodsOut((float) 0);
					dcData.setId(0);
					dcData.setGuessBonus((float) 0);
					dcData.setNetIncome((float) 0);
					dcData.setOrderIn(0);
					dcData.setOrderOut(0);
					dcData.setGuess(0);
					dcData.setTotal(exp.getShowFee());

					dcData.setTag(0);
					if (j == 0) {// 如果为供应商
						dcData.setPurchasePrice((int) (exp.getDcParameters().getInitialPurchasePrice() / 2));// DC的购买价格为出货价格的一半
						dcData.setSellingPrice(exp.getDcParameters().getInitialPurchasePrice());// DC的默认出货价格即为零售商的默认进货价格
					} else {// 如果为零售商
						dcData.setPurchasePrice(exp.getDcParameters().getInitialPurchasePrice());
						dcData.setSellingPrice(exp.getDcParameters().getInitialSellingPrice());
						dcData.setOrderIn(orderIn);// 设置第一期初始订单量
					}

					if (i == 1) {// 如果是第一期，则设置初始库存量
						dcData.setCompetitor(0);
						dcData.setBegainTime1(new Date());
						dcData.setBegainTime2(new Date());

						if (j == 0) {// 如果为供应商
							dcData.setInventory(exp.getDcParameters().getDcinitialInventory());
							dcData.setGoodsIn(0);
						} else {// 如果为零售商
							dcData.setInventory(0);
						}
					}
					DAO.insert(dcData);
				}

				if (i % 20 == 0) {
					// 20，与JDBC批量设置相同
					// 将本批插入的对象立即写入数据库并释放内存
					DAO.getSession().flush();
					DAO.getSession().clear();
				}
			}

			exp.setExperimentState(1);
			DAO.update(exp);

			return "initialexpsuccess";
		} catch (Exception e) {
			System.out.print(e.toString());
			return "初始化失败，失败原因：\n" + e.toString();
		} finally {
			try {
				HibernateSessionFactory.commitTransaction();
			} catch (Exception e) {
				HibernateSessionFactory.rollbackTransaction();
			} finally {
				HibernateSessionFactory.closeSession();
			}
		}
	}
}
