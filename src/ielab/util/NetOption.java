package ielab.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class NetOption {

	private static Log logger = LogFactory.getLog("lab.util.*");
	private final static String[] ips = new String[] {
			"166.111.0.0-166.111.255.255", "192.168.252.*",// 北邮世纪学院
			"59.66.*.*", "127.0.0.1","219.224.134.224"};

	public NetOption() {
	}

	public static void main(String[] args) {
		boolean v = NetOption.ValidIP("59.66.59.6");
		logger.warn(v);
	}

	/*
	 * 验证ip地址是否合法，只验证ipv4
	 */
	public static boolean IsIP(String StringIP) {
		try {
			String[] arr = StringIP.split("\\.");
			if (arr.length != 4) {
				logger.warn("ip地址格式不正确，不是4位ip:" + StringIP);
				return false;
			}
			for (String s : arr) {
				int i = Integer.parseInt(s);
				if (i < 0 || i > 255) {
					logger.warn("ip地址格式不正确，某一位大于255，或小于0:" + StringIP);
					return false;
				}
			}
		} catch (Exception e) {
			logger.warn("出现异常：");
			logger.error(e.toString());
			return false;
		}
		return true;
	}

	/*
	 * 比较两个IP地址的大小（IPV4，不能包含通配符） 若strIP1或strIP2不符合ip规则，返回-1 strIP1小于strIP2：则返回0;
	 * strIP1等于strIP2：则返回1; strIP1大于strIP2：则返回2;
	 */
	public static int CompareIP(String strIP1, String strIP2) {
		if ((!IsIP(strIP1)) || (!IsIP(strIP2))) {
			return -1;
		}

		String[] arr1 = strIP1.split("\\.");
		String[] arr2 = strIP2.split("\\.");

		for (int i = 0; i < arr1.length; i++) {
			int a1 = Integer.parseInt(arr1[i]);
			int a2 = Integer.parseInt(arr2[i]);
			if (a1 > a2) {
				logger.warn(a1 + ">" + a2);
				return 2;
			} else if (a1 < a2) {
				logger.warn(a1 + "<" + a2);
				return 0;
			}
		}

		return 1;
	}

	/*
	 * 验证SourceIP是否在某个IP地址范围之间(StartIP,EndIP)
	 */
	public static boolean ValidIPRange(String SourceIP, String StartIP,
			String EndIP) {
		if (NetOption.CompareIP(SourceIP, StartIP) >= 1
				&& NetOption.CompareIP(EndIP, SourceIP) >= 1) {
			return true;
		} else {
			return false;
		}
	}

	/*
	 * 验证SourceIP是否与strIP相匹配，strIP可以包含通配符 SourceIP必须为规则ip地址
	 */
	public static boolean ValidIPForm(String SourceIP, String strIP) {
		if (!IsIP(SourceIP)) {
			return false;
		}

		String[] arr_Source = SourceIP.split("\\.");
		String[] arr_str = strIP.split("\\.");

		for (int i = 0; i < arr_Source.length; i++) {
			if ((!arr_str[i].equals("*"))
					&& (!arr_Source[i].equals(arr_str[i]))) {
				return false;
			}
		}

		return true;
	}

	/*
	 * 验证SourceIP是否匹配ips SourceIP必须为规则ip地址
	 */
	public static boolean ValidIP(String SourceIP) {
		if(SourceIP.equals("0:0:0:0:0:0:0:1")){//允许本机
			return true;
		}
		
		if (!IsIP(SourceIP)) {
			return false;
		}

		for (String ip : ips) {
			String[] arr_ip = ip.split("-");

			if (arr_ip.length == 2) {
				String StartIP = arr_ip[0].trim();
				String EndIP = arr_ip[1].trim();
				if (ValidIPRange(SourceIP, StartIP, EndIP)) {
					return true;
				}
			} else {
				String strIP = arr_ip[0].trim();
				if (ValidIPForm(SourceIP, strIP)) {
					return true;
				}
			}
		}

		return false;
	}
}
