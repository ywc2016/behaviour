package ielab.util;

import java.math.BigDecimal;
import java.util.Random;


/**
 * 各种随机数生成器
 * @author Lu Wen-yan
 */
public class RandomGenerator {
	/**
	 * @param rnd
	 * 			java随机数生成类
	 */
	static Random rnd = new Random();
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		for (int i = 0; i < 10; i++) {
			double r=nextLognormal(10,1);
			
			System.out.println(r);
		}		
	}
	
	/**
	 * 要求返回指定均值和方差的正态分布随机数
	 * 
	 * @param mu
	 *            均值
	 * @param sigma
	 * 			  方差
	 * @return
	 */
	public static double nextNormal(double mu, double sigma) {
		double returnValue=rnd.nextGaussian()*Math.sqrt(sigma)+mu;
		while(returnValue<0){//保证大于0
			returnValue=rnd.nextGaussian()*Math.sqrt(sigma)+mu;
		}
		return returnValue;
	 }	 
	
	/**
	 * 要求返回指定上界和下界的均匀分布随机数
	 * 
	 * @param min
	 *            下界
	 * @param max
	 * 			  上界
	 * @return
	 */
	public static double nextUniform(double min, double max) {
		double returnValue=rnd.nextDouble()*(max - min) +min;
		return returnValue;
	 }

	/**
	 * 要求返回指定期望值的指数分布随机数
	 * 
	 * @param beta
	 *            期望值
	 * @return
	 */
	public static double nextExpo(double beta) {
		double returnValue=-beta*Math.log(rnd.nextDouble());
		return returnValue;
	 }
	
	/**
	 * 要求返回指定均值和方差的对数正态分布随机数
	 * 
	 * @param mu
	 *            均值
	 * @param sigma
	 * 			  方差
	 * @return
	 */
	public static double nextLognormal(double mu, double sigma) {
		double returnValue=Math.exp(nextNormal(mu, sigma));
		return returnValue;
		
	 }
}
