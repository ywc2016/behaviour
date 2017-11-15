package ielab.util;

import java.util.Arrays;
import java.util.List;

import ielab.dao.BargainExperimentsDao;
import ielab.hibernate.BargainExperiments;

/**
 * 计算谈判积分
 * <p>
 * 如果合作，制造商的利润为：p*min(min(K-Q,Q^*),d)+w*Q-c*min(Q+Q^*,K)
 * 零售商的利润为：p*min(d,Q)-w*Q；（注意：需要分别计算这个100个d值对应的利润，最后求均值）
 * </p>
 * <p>
 * 如果不合作，制造商的利润为：p*min(d,Q^*)-c*Q^*，
 * 其中Q^*=min(a+(b-a)*(p-c)/p，K)；零售商的利润为0；（注意：需要分别计算这个100个d值对应的利润，最后求均值）
 * </p>
 * 
 * @author ywc
 * 
 */
public class BargainPointCalculate {

	// private int numberOfRandom = 100;

	public static void main(String[] args) {

		double w = 22;
		int Q = 60;

		BargainPointCalculate bargainPointCalculate = new BargainPointCalculate();
		BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
		BargainExperiments bargainExperiments = bargainExperimentsDao.findByKey(15);
		double result1 = bargainPointCalculate.calculateAgreeSupplier(w, Q, 120, 10, 50, 100, 40,
				bargainExperiments.getRandomNeed());
		System.out.println(result1);
		double result2 = bargainPointCalculate.calculateAgreeRetailer(w, Q, 120, 10, 50, 100, 40,
				bargainExperiments.getRandomNeed());
		System.out.println(result2);
	}

	/**
	 * 达成协议的供应商(第一参与者)
	 * 
	 * @return
	 */
	public double calculateAgreeSupplier(double w, int Q, double K, double c, int a, int b, double p,
			String randomNeeds) {

		List<String> randomNeedsList = Arrays.asList(randomNeeds.split(","));

		double profits = 0;
		for (int i = 0; i < randomNeedsList.size(); i++) {
			int d = Integer.parseInt(randomNeedsList.get(i));
			profits += p * Math.min(d, Math.min(K - Q, Math.min(K, a + (b - a) * (p - c) / p))) + w * Q
					- c * Math.min(K, Q + Math.min(K, a + (b - a) * (p - c) / p));
		}
		return profits / randomNeedsList.size();
	}

	public double calculateAgreeRetailer(double w, int Q, double K, double c, int a, int b, double p,
			String randomNeeds) {

		List<String> randomNeedsList = Arrays.asList(randomNeeds.split(","));

		double profits = 0;
		for (int i = 0; i < randomNeedsList.size(); i++) {
			int d = Integer.parseInt(randomNeedsList.get(i));
			profits += p * Math.min(d, Q) - w * Q;
		}
		return profits / randomNeedsList.size();
	}

	/**
	 * 未达成协议
	 * 
	 * @param w
	 * @param Q
	 * @param MA
	 * @param MB
	 * @param K
	 * @param c
	 * @return
	 */
	public double calculateDisagreeSupplier(double w, int Q, double K, double c, int a, int b, double p,
			String randomNeeds) {

		List<String> randomNeedsList = Arrays.asList(randomNeeds.split(","));
		double profits = 0;
		for (int i = 0; i < randomNeedsList.size(); i++) {
			int d = Integer.parseInt(randomNeedsList.get(i));
			profits += p * Math.min(d, Math.min(K, a + (b - a) * (p - c) / p))
					- c * Math.min(K, a + (b - a) * (p - c) / p);
		}
		return profits / randomNeedsList.size();
	}

	public double calculateDisagreeRetailer(double w, int Q, double K, double c, int a, int b, double p,
			String randomNeeds) {
		return 0;
	}
}
