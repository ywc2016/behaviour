package ielab.util;

import java.math.BigDecimal;
/**
 * 对数字进行各种模式的舍入，如四舍五入等
 * @author Lu Wen-yan
 */
public class Decimal {
	/**
	 * 返回一定小数数位
	 * 
	 * @param value
	 *            待舍入的数字
	 * @param length
	 *            返回的BigDecimal对象的标度（scale）
	 
	 * @return
	 */
	public static float getDecimal(float value,int length)
	{	
		float returnValue;
		BigDecimal b=new BigDecimal(value);
		returnValue=b.setScale(1,BigDecimal.ROUND_HALF_UP).floatValue();
		return returnValue;
	}
	
	public static double getDecimal(double value,int length)
	{	
		double returnValue;
		BigDecimal b=new BigDecimal(value);
		returnValue=b.setScale(1,BigDecimal.ROUND_HALF_UP).doubleValue();
		return returnValue;
	}

}
