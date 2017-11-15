package ielab.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.Random;
import java.util.TreeMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ielab.hibernate.DAO;
import ielab.hibernate.DcData;
import ielab.hibernate.DcExperiments;
import ielab.hibernate.HibernateSessionFactory;

public class UpdateCycle {

	private static Log logger = LogFactory.getLog("lab.util.*");

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		// logger.error(updateNowCycle_order(1, 1));
	}
	
	/**
	 * 当所有零售商都已经提交订单后，或者该期实验提交订单的时间已经到达，则更新实验周期的数据，根据各个零售商提交的订单数据，分配供应商的库存。
	 * 
	 * @param exp
	 *            目前正在进行的实验
	 * @param currentCycle
	 *            要更新的周期
	 * @return 返回更新情况
	 */
	public static String updateNowCycle_order(DcExperiments exp, int CurrentCycle) {

		// 需要更新的数据
		ArrayList<DcData> list_last =null;
		ArrayList<DcData> list_current =null;
		ArrayList<DcData> list_next =null;
		DcData data_DC_last=null;
		DcData data_DC_current=null;
		DcData data_DC_next=null;
		DcData data_DC_next_leadTime=null;
		DAO DAO=new DAO();
		
		// 取得该周期实验数据的更新状态，如果已经更新，则返回finished，如果正在更新则返回updating，否则，由该用户负责更新该期实验
		// 更新前现将tag设置为3，标志该周期实验正在进行更新。
		try{
			list_current = DAO.selectByHOL("from DcData as model where model.dcExperiments.id=" + exp.getId()
					+ " and model.cycle=" + CurrentCycle + " order by model.retailerId");
			int tag = list_current.get(0).getTag();// 取得本期实验的运行情况。是结束了，还是正在更新，还是没开始更新
			if (tag == 1) {// 该周期提交订单的数据已经更新，可以转入
				return "finished";
			} else if (tag == 3) {// 已经有其它用户负责更新该周期的数据，继续等待其更新完毕
				// 以后可能 需要判断一下 更新成功否，如果没有，则转由该用户来更新
				return "updating";
			} else if (tag == 0) {// 如果没有其它用户更新该周期的数据，则该用户负责更新。先将tag置为3，后调用更新函数
				data_DC_current = list_current.get(0);
				list_current.remove(0);
				data_DC_current.setTag(3);
				try {
					DAO.update(data_DC_current);// 将tag标签变为3，标志该周期数据已经有用户在负责更新
					HibernateSessionFactory.commitTransaction();
				} catch (Exception e) {
					HibernateSessionFactory.rollbackTransaction();
					logger.error(e.toString());
				}
			}else{
				logger.error("目前状态为："+tag+"，该状态不应该出现在updateNowCycle_order函数中");
				return "finished";
			}
		}catch(Exception e){
			logger.error("取得该周期实验数据的更新状态失败，或者改变更新状态为正在更更新失败！");
			logger.error(e.toString());
			return "finished";
		}
			
		//取下面的数据干什么？
		
		
		
		// 如果不是第一周期，取到上一周期的实验数据，包括供应商和零售商的数据
		// 取到下周期实验的数据，包括供应商和零售商的数据
		try {
			if(CurrentCycle>1){
				list_last = DAO.selectByHOL("from DcData as model where model.dcExperiments.id=" + exp.getId()
						+ " and model.cycle=" + (CurrentCycle-1) + " order by model.retailerId");
				data_DC_last = list_last.get(0);
				list_last.remove(0);
			}
			
			list_next = DAO.selectByHOL("from DcData as model where model.dcExperiments.id=" + exp.getId()
					+ " and model.cycle=" + (CurrentCycle+1) + " order by model.retailerId");
			data_DC_next = list_next.get(0);
			list_next.remove(0);
			
			//leadtime=1
			data_DC_next_leadTime=data_DC_next;

		} catch (Exception e) {
			//下面一段的代码是为了防止该用户更新发生错误，一旦发生错误，即将tag变为0.可以由其他用户负责更新
			// data_DC_current.setTag(0);
			try {
				// DAO.update(data_DC_current);// 更新失败，将tag标签变回0，标志该周期数据需要重新更新
				HibernateSessionFactory.commitTransaction();
			} catch (Exception e_1) {
				HibernateSessionFactory.rollbackTransaction();
			}
			logger.error("取得上周期，下周期，提前期后的周期数据失败！");
			logger.error(e.toString());
			return "finished";
		}
		

		/*
		 * 下面开始更新本周期的数据，根据各个零售商提交的订单数据，分配供应商的库存。并确定更新当前的库存量 
		 * 逻辑顺序为：
		 * 1. DC每期初，库存更新为K
		 * 2. 对还没有来得及决策的零售商采取系统默认提交方式进行处理，并取得所有零售商的订单量，存入dc该周期的总订单量中。
		 * 3. 根据各零售商提交上来的订单量，分配货物，如果当前库存小于总的订货量，则按比例分配库存，如果大于总订货量，则满足全部订单量
		 * 4. 计算库存和成本，并更新本周期和下周期的数据
		 * 5. 调用DAO更新数据，返回值
		 */
		logger.error("开始更新第"+CurrentCycle+"周期的订货数据：");		
		/*
		 * 第一步，DC更新库存为K，写入提前期后的周期中
		 */
		try {
			//取得所有零售商的订货量和？？？
			String HQLstr="select sum(model.goodsIn) from DcData as model where model.retailerId=0 and model.dcExperiments.id=" + exp.getId()
				+ " and model.cycle>=" + (CurrentCycle+1)+ " and model.cycle<=" + (CurrentCycle+1);
			//以下可能会有问题
			data_DC_current.setOrderOut(exp.getDcParameters().getDcinitialInventory());
			data_DC_next_leadTime.setGoodsIn(exp.getDcParameters().getDcinitialInventory());
			
			logger.error("第一步完成");
		} catch (Exception e) {
			logger.error("更新第一步失败！");
			logger.error(e.toString());
			return "finished";
		}
		/*
		 * 第二步，对还没有来得及决策的零售商采取系统默认提交方式进行处理，并取得所有零售商的订单量
		 */
		try {
			for (int i = 0; i < list_current.size(); i++) {
				if(list_current.get(i).getTag()==0){
					if(CurrentCycle==1){
						list_current.get(i).setOrderOut(10);
					}else {
						list_current.get(i).setBegainTime2(new Date(System.currentTimeMillis()));
					}
					list_current.get(i).setTag(1);
				}
				data_DC_current.setOrderIn(data_DC_current.getOrderIn()+list_current.get(i).getOrderOut());
			}
			
			logger.error("第二步完成");
		} catch (Exception e) {
			logger.error("更新第二步失败！");
			logger.error(e.toString());
			return "finished";
		}
		/*
		 * 第三步，根据各零售商提交上来的订单量，分配货物.
		 * 
		 */
		try {
		//	float dcOrderIn=data_DC_current.getOrderIn();
			float dcInventory = exp.getDcParameters().getDcinitialInventory();
			data_DC_current.setGoodsOut(dcInventory);
			list_current=Allocation.allocation(CurrentCycle, exp.getDcParameters().getDistributionScheme(), 
					exp.getGuessBonus(),list_current, dcInventory);						
			logger.error("第三步完成");
		} catch (Exception e) {
			logger.error("更新第三步失败！");
			logger.error(e.toString());
			return "finished";
		}
		/*
		 * 第四步，计算库存和成本，并更新本周期和下周期的数据
		 */
		try {
			//下周期DC的售出价格为InitialPurchasePrice，库存为K
			data_DC_next.setInventory(exp.getDcParameters().getDcinitialInventory());
			
			data_DC_next.setSellingPrice(exp.getDcParameters().getInitialPurchasePrice());
			
			for (DcData Retailer: list_next) {
				Retailer.setPurchasePrice(data_DC_next.getSellingPrice());
			}
			
			//下面计算DC该周期的成本和收益
			
			if(data_DC_current.getGoodsIn()>0){
				data_DC_current.setGoodsCost((int)data_DC_current.getGoodsIn()*data_DC_current.getPurchasePrice());
			}
			
			data_DC_current.setGoodsIncome((int)data_DC_current.getGoodsOut()*data_DC_current.getSellingPrice());
			data_DC_current.setNetIncome((int)(data_DC_current.getGoodsIncome()));
			data_DC_current.setTotal((int)(data_DC_current.getTotal()+data_DC_current.getNetIncome()));
			
			//设置下周期的初始资金，即位本周期初始资金加上本周期的纯利润
			data_DC_next.setTotal(data_DC_current.getTotal());	
			
			/////下面计算零售商 该周期的成本和收益
			for (int i = 0; i < list_current.size(); i++) {
				
				list_current.get(i).setOrderIn(exp.getDcParameters().getDemand());
				list_current.get(i).setGoodsOut(Math.min(exp.getDcParameters().getDemand(), list_current.get(i).getGoodsIn()));
			
				list_current.get(i).setNetIncome(100
						-list_current.get(i).getPurchasePrice()
							*Math.max(50-list_current.get(i).getGoodsIn(),0)
						-list_current.get(i).getSellingPrice()
							*Math.max(list_current.get(i).getGoodsIn()-50,0)
				);
				
				list_current.get(i).setTotal(list_current.get(i).getTotal()+exp.getExchangeRate()*
						list_current.get(i).getNetIncome());
				//设置下周期的初始资金，即位本周期初始资金加上本周期的纯利润
				list_next.get(i).setTotal(list_current.get(i).getTotal());			
			}
			
			logger.error("第四步完成");
		} catch (Exception e) {
			logger.error("更新第四步失败！");
			logger.error(e.toString());
			return "finished";
		}
		/*
		 * 第五步，调用DAO更新数据，返回值
		 */
		try {
			//设置零售商本期定价格的开始时间
			Date now = new Date();
			for (int i = 0; i < list_current.size(); i++) {
				//本周期零售商数据更新完成，将tag设置为2.标志该期实验，该零售商已经完成
				list_current.get(i).setTag(2);
				DAO.update(list_current.get(i));
			
				//设置下一期实验的开始时间
				list_next.get(i).setBegainTime1(now);
				DAO.update(list_next.get(i));
			}
			
			//本周期更新完成，将tag设置为2.标志该期实验已经完成
			data_DC_current.setTag(2);
			DAO.update(data_DC_current);
			//设置下一期实验的开始时间
			data_DC_next.setBegainTime1(now);
			DAO.update(data_DC_next);
			
			HibernateSessionFactory.commitTransaction();
			logger.error("第五步完成");
			logger.error("更新第"+CurrentCycle+"周期的订货数据完毕!");
			return "finished";
		} catch (Exception e) {
			HibernateSessionFactory.rollbackTransaction();
			logger.error("更新第五步失败！");
			logger.error(e.toString());
			return "finished";
		}
	}	
}
