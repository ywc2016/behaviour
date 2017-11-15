package ielab.util;

import ielab.hibernate.DcData;

import java.math.BigDecimal;
import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
/**
 *  allocation scheme
 * @author Sifeng Lin
 */
public class Allocation {
	private static Log logger = LogFactory.getLog("lab.util.*");
	public static ArrayList<DcData> allocation(int CurrentCycle, int scheme, float guessBonus,
			ArrayList<DcData> list_current,float dcInventory)
	{
		//when number of retailer is smaller than the number of cycle	
		CurrentCycle=CurrentCycle%(list_current.size()-1)+1;
		int N=list_current.size()-1;
	//	CurrentCycle=(CurrentCycle+list_current.size()/2-1)%N;
		int dcOrderIn;
		int retailer[]=new int[2];
	//	retailer[0]=CurrentCycle;
	//	retailer[1]=(CurrentCycle+N-1)>N?
	//			((CurrentCycle+N-1)%N):(CurrentCycle+N-1);
		
		for(int i=1;i<=list_current.size()/2;i++)
		{
			ArrayList<DcData> competition=new ArrayList<DcData>();
			if(i<list_current.size()/2)
			{
			//	retailer[0]=(retailer[0]+1)>N?
			//			((retailer[0]+1)%N):(retailer[0]+1);
			//	retailer[1]=(retailer[1]+N-1)>N?
			//			((retailer[1]+N-1)%N):(retailer[1]+N-1);
				retailer[0]=(CurrentCycle-i>0) ? (CurrentCycle-i) : (CurrentCycle-i+N);
				retailer[1]=(CurrentCycle+i>N) ? (CurrentCycle+i-N) : (CurrentCycle+i);
				retailer[0]--;
				retailer[1]--;
			}
			else
			{
				retailer[0]=CurrentCycle-1;
			//	retailer[1]=(CurrentCycle+list_current.size()/2-1>=list_current.size())? 
			//			CurrentCycle-list_current.size()/2-1:CurrentCycle+list_current.size()/2-1;
				retailer[1]=list_current.size()-1;
			}
			competition.add(list_current.get(retailer[0]));
			competition.add(list_current.get(retailer[1]));
			dcOrderIn=competition.get(0).getOrderOut()+competition.get(1).getOrderOut();
			if(dcOrderIn<=dcInventory)
			{
				competition.get(0).setInventory(competition.get(0).getOrderOut());
				competition.get(1).setInventory(competition.get(1).getOrderOut());
				competition.get(0).setGoodsIn(competition.get(0).getOrderOut());
				competition.get(1).setGoodsIn(competition.get(1).getOrderOut());
			}
			else
			{
				if(scheme==1)
					competition=Allocation.proportational(competition, dcOrderIn, dcInventory);
				else if(scheme==2)
					competition=Allocation.linear(competition, dcOrderIn, dcInventory);
				else if(scheme==3)
					competition=Allocation.uniform(competition, dcOrderIn, dcInventory);
				else if(scheme==4)
					competition=Allocation.SOF(competition, dcOrderIn, dcInventory);
				else if(scheme==5)
					competition=Allocation.LOF(competition, dcOrderIn, dcInventory);
			}
			list_current.get(retailer[0]).setInventory(competition.get(0).getInventory());
			list_current.get(retailer[0]).setGoodsIn(competition.get(0).getGoodsIn());
			
			list_current.get(retailer[1]).setInventory(competition.get(1).getInventory());
			list_current.get(retailer[1]).setGoodsIn(competition.get(1).getGoodsIn());
			
			list_current.get(retailer[0]).setCompetitor(retailer[1]+1);
			list_current.get(retailer[1]).setCompetitor(retailer[0]+1);
			
			list_current.get(retailer[0]).setBacklogCost(list_current.get(retailer[1]).getOrderOut());
			list_current.get(retailer[1]).setBacklogCost(list_current.get(retailer[0]).getOrderOut());
			
			list_current.get(retailer[0]).setGuessBonus(
					Allocation.calculateGuessBonus(
							guessBonus, competition.get(0).getGuess(), competition.get(1).getOrderOut()));
			list_current.get(retailer[1]).setGuessBonus(
					Allocation.calculateGuessBonus(
							guessBonus, competition.get(1).getGuess(), competition.get(0).getOrderOut()));
	//		if(competition.get(0).getGuess()==competition.get(1).getOrderOut())
	//			list_current.get(retailer[0]).setGuessBonus(guessBonus);
	//		if(competition.get(1).getGuess()==competition.get(0).getOrderOut())
	//			list_current.get(retailer[1]).setGuessBonus(guessBonus);
	//		logger.error(list_current.get(retailer[0]).getBacklog()+" vs "+retailer[1]+1);
	//		logger.error(list_current.get(retailer[1]).getBacklog()+" vs "+retailer[0]+1);
		}
		return list_current;				
	}
	
	private static float calculateGuessBonus(float guessBonus, int guess, int orderOut)
	{
		float value;		
		if(guess<=orderOut)
		{
			value=(float)Math.max(0, 1-(orderOut-guess)/6.0)*guessBonus;
			return value;
		}
		else
		{
			value=(float)Math.max(0, 1-(guess-orderOut)/6.0)*guessBonus;
			return value;
		}	
	}
	
	private static ArrayList<DcData> proportational(ArrayList<DcData> list_current, float dcOrderIn, float dcInventory)
	{
		int dcGoodsOut = 0;
		for (DcData Retailer: list_current) {
			float goodsInF = (Retailer.getOrderOut() / dcOrderIn * dcInventory);						
			Retailer.setGoodsIn(goodsInF);
			//should be the current inventory+ the allocated goods?
			Retailer.setInventory(goodsInF);
			dcGoodsOut += goodsInF;
		}
		return list_current;
		
	}
	
	/**
	 * linear allocation
	 * 
	 * @param dou
	 *            
	 * @return
	 */
	
	private static ArrayList<DcData> linear(ArrayList<DcData> list_current, float dcOrderIn, float dcInventory)
	{
		int dcGoodsOut = 0;
	//	float dcInventory=exp.getDcParameters().getDcinitialInventory();
    //	float SumOrder=dcOrderIn;    	
    //	logger.error("K="+K+" SumOrder="+SumOrder); 
    	
    	Integer N=list_current.size();
   // 	logger.error("Algorithm2: Linear Allocation!");
    	float[][] RetailorX=new float[2][N];
  //  	logger.error("Algorithm2: Linear Allocation！-3");
    	//RetailorX赋值
    	Integer m=0;
    	for (DcData Retailer: list_current) {
    		RetailorX[0][m]=Retailer.getOrderOut();
    		RetailorX[1][m]=m;
    		m++;
   // 		logger.error("Algorithm2: Linear Allocation！-3" + m);
    	}
    	
	    float[][] sortedX=new float[2][N]; 
	    sortedX=Sort(RetailorX,N);
	    
	    float AvShortage=(dcOrderIn-dcInventory)/N;
	    Integer j=0;
	//    logger.error("Algorithm2: Linear Allocation！-4");
	    while (AvShortage>sortedX[0][j]&& j<N){
	        dcOrderIn=dcOrderIn-sortedX[0][j];
	        j=j+1;
//	        logger.error("Algorithm2: Linear Allocation！-4" + j+"  "+(N+1-j));
//	        AvShortage=(dcOrderIn-dcInventory)/(N+1-j);
	        AvShortage=(dcOrderIn-dcInventory)/(N-j);	        	        
	    }
//	    logger.error("Algorithm2: Linear Allocation！-5");
	    float[][] Xplan=new float [2][N];
	    for(int i=0;i<N;i++){
	    	Xplan[0][i]=sortedX[0][i]-AvShortage;
//	    	logger.error("Linear Allocation！ before max Xplan[0]["+i+"]="+Xplan[0][i]);
	    	Xplan[1][i]=sortedX[1][i];
	    	Xplan[0][i]=Math.max(Xplan[0][i],0);
//	    	logger.error("Linear Allocation！ after max Xplan[0]["+i+"]="+Xplan[0][i]);
	    }
	    m=0;
	    Xplan=UnSort(Xplan,N);
//	    logger.error("Algorithm2: Linear Allocation！-3");
	    //错误估计在这个地方开始：
		for (DcData Retailer: list_current) {					
			Retailer.setGoodsIn(Xplan[0][m]);
//			logger.error("the planned goods are "+m+": "+Xplan[0][m]);
			Retailer.setInventory(Xplan[0][m]);
			dcGoodsOut += Xplan[0][m];
			m++;
		}
		return list_current;
	}
	
	/**
	 * uniform allocation
	 * 
	 * @param dou
	 *            
	 * @return
	 */
	
	private static ArrayList<DcData> uniform(ArrayList<DcData> list_current, float dcOrderIn, float dcInventory)
	{
		int dcGoodsOut = 0;
	//	float K=exp.getDcParameters().getDcinitialInventory();
    //	float SumOrder=dcOrderIn;
    	Integer N=list_current.size();
    	float[][] RetailorX =new float [2][N];
    	//RetailorX赋值
    	Integer m=0;
    	for (DcData Retailer: list_current) {
    		RetailorX[0][m]=Retailer.getOrderOut();
    		RetailorX[1][m]=m;
    		m++;
    	}
//    	logger.error("Algorithm3: Uniform Allocation！-1");    
	    float[][] sortedX=new float [2][N];
	    sortedX=Sort(RetailorX,N);	        	    
	  
	    Integer j=0;// The numbers of zero
	    
	     float RemainCap=dcInventory;
	     float RemainNum=N;  
	     float AvK=RemainCap/RemainNum;
	  //   j=0;
	     
	     while (AvK>=sortedX[0][j]){
	         RemainCap=RemainCap-sortedX[0][j];
	         RemainNum=RemainNum-1;
	         j=j+1;
	         AvK=RemainCap/RemainNum;
	     }
//	     logger.error("Algorithm3: Uniform Allocation！-2");	  
	    float[][] Xplan=new float [2][N];
	    for(int i=0;i<N;i++){
	    	Xplan[1][i]=sortedX[1][i];
	    	Xplan[0][i]=Math.min(sortedX[0][i],AvK);
	    }
	    m=0;
	    Xplan=UnSort(Xplan,N);
		for (DcData Retailer: list_current) {
			Retailer.setGoodsIn(Xplan[0][m]);
			
			Retailer.setInventory(Xplan[0][m]);
			dcGoodsOut += Xplan[0][m];
			m++;
		}
//		logger.error("Algorithm3: Uniform Allocation-3！");
		return list_current;
	}
	/**
	 * smallest order first
	 * 
	 * @param dou
	 *            
	 * @return
	 */
	private static ArrayList<DcData> SOF(ArrayList<DcData> list_current, float dcOrderIn, float dcInventory)
	{
		int dcGoodsOut = 0;
		//Algorithm4: Smallest Order First Allocation
//    	logger.error("Algorithm4: Smallest Order First Allocation！");
   // 	float K=exp.getDcParameters().getDcinitialInventory();
    //	float SumOrder=dcOrderIn;
    	Integer N=list_current.size();
    	float[][] RetailorX =new float [2][N];
    	//RetailorX赋值
    	Integer m=0;
    	for (DcData Retailer: list_current) {
    		RetailorX[0][m]=Retailer.getOrderOut();
    		RetailorX[1][m]=m;
    		m++;
    	}
//    	logger.error("Algorithm4: SOF！");    
	    float[][] sortedX=new float [2][N];
	    sortedX=Sort(RetailorX,N);        
	    
	     float RemainCap=dcInventory;
	     float RemainNum=N;
	     int[] record=new int[N];//record the number of same order
	     //更新record的值
	     for(int i=0;i<N;)
	     {
	    	record[i]=1;
	    	int k=i;
	    	
	    	while(k<N-1&&sortedX[0][i]==sortedX[0][k+1])
	    	{
	    			record[i]++;
	    			k++;
	    	}
	    	i=i+record[i];
	    			
	     }

	     float[][] Xplan=new float [2][N];
	     int j=0;
	     
	     while (RemainCap>0){

	         for(int i=0;i<record[j];)
	         {
	        	 Xplan[0][j+i]=Math.min(sortedX[0][j],RemainCap/record[j]);
	        	 Xplan[1][j+i]=sortedX[1][j+i];

	        	 i++;
	         }
	         RemainCap=RemainCap-Xplan[0][j]*record[j];

	         j=j+record[j];
	     }

	     while(j<N)
	     {
	    	 Xplan[0][j]=0;
	    	 Xplan[1][j]=sortedX[1][j];
	    	 j++;
	     }
	    m=0;
	    Xplan=UnSort(Xplan,N);
		for (DcData Retailer: list_current) {
			Retailer.setGoodsIn(Xplan[0][m]);
			Retailer.setInventory(Xplan[0][m]);
			dcGoodsOut += Xplan[0][m];
			m++;
		}
		return list_current;
	}
	
	/**
	 * largest order first
	 * 
	 * @param dou
	 *            
	 * @return
	 */
	private static ArrayList<DcData> LOF(ArrayList<DcData> list_current, float dcOrderIn, float dcInventory)
	{
		int dcGoodsOut = 0;
    	Integer N=list_current.size();
    	float[][] RetailorX =new float [2][N];
    	//RetailorX赋值
    	Integer m=0;
    	for (DcData Retailer: list_current) {
    		RetailorX[0][m]=Retailer.getOrderOut();
    		RetailorX[1][m]=m;
    		m++;
    	}
	    float[][] sortedX=new float [2][N];
	    sortedX=Sort(RetailorX,N);
	    
	     float RemainCap=dcInventory;
	     float RemainNum=N;
	     int[] record=new int[N];//record the number of same order
	     //更新record的值
	     for(int i=N-1;i>=0;)
	     {

	    	record[i]=1;
	    	int k=i;

	    	while(k>0&&sortedX[0][i]==sortedX[0][k-1])
	    	{
	    		record[i]++;
	    		k--;
	    	}
//	    	logger.error("i is "+i);
	    	i=i-record[i];
	     }
//	     logger.error("after updating record");

	     float[][] Xplan=new float [2][N];
	     int j=N-1;
	     
	     while (RemainCap>0){
//	    	 logger.error("RemainCap before is "+RemainCap);
//	    	 logger.error("record["+j+"] is "+record[j]);
	         for(int i=0;i<record[j];)
	         {
	        	 Xplan[0][j-i]=Math.min(sortedX[0][j],RemainCap/record[j]);
//	        	 logger.error("sortedX for "+Xplan[1][j-i]+" is "+sortedX[0][j]);
	        	 Xplan[1][j-i]=sortedX[1][j-i];
//	        	 logger.error("Xplan "+Xplan[1][j-i]+" is "+Xplan[0][j-i]);
	        	 i++;
	         }
	         RemainCap=RemainCap-Xplan[0][j]*record[j];
//	         logger.error("RemainCap after "+j+" is "+RemainCap);
	         j=j-record[j];
	     }
//	     logger.error("after updating xplan 1");
	     while(j>=0)
	     {
	    	 Xplan[0][j]=0;
	    	 Xplan[1][j]=sortedX[1][j];
	    	 j--;
	     }
//	     logger.error("after updating xplan 2");

	    m=0;
	    Xplan=UnSort(Xplan,N);
		for (DcData Retailer: list_current) {
//			logger.error("Xplan "+Xplan[1][m]+" is "+Xplan[0][m]);
			Retailer.setGoodsIn(Xplan[0][m]);
			Retailer.setInventory(Xplan[0][m]);
			dcGoodsOut += Xplan[0][m];
			m++;
		}
		return list_current;
	}
	
	//排序算法
	private static float[][] Sort(float[][] src,Integer len){
		
//		logger.error("Sort-1");
		
//		logger.error("Sort-1-length:"+len);
		for(int i=0;i<len;i++)	{
			for(int j=len-1;j>i;j--)	{
				float temp[][]=new float [len][len];
				
				if(src[0][i]>src[0][j])
				{
//					logger.error("Sort-1-i-j" +" i:"+i+" j:"+j);
					temp[0][0]=src[0][j];
					temp[1][0]=src[1][j];
					src[0][j]=src[0][i];
					src[1][j]=src[1][i];
					src[0][i]=temp[0][0];
					src[1][i]=temp[1][0];
				} 
			}
	
		} 
//		logger.error("ending sorting");
		return src;
	}
	
	//排序算法逆反
	private static float[][] UnSort(float[][] src,Integer len){		
		for(int i=0;i<len;i++)	{
			for(int j=len-1;j>i;j--)	{
				float temp[][]=new float [len][len];
				if(src[1][i]>src[1][j])
				{
				/*	temp[1][0]=src[1][j];
					temp[0][0]=src[1][j];
					src[1][j]=src[1][i];
					src[0][j]=src[0][i];
					src[0][i]=temp[0][0];
					src[1][i]=temp[1][0];*/
					temp[1][0]=src[1][j];
					temp[0][0]=src[0][j];
					src[1][j]=src[1][i];
					src[0][j]=src[0][i];
					src[0][i]=temp[0][0];
					src[1][i]=temp[1][0];
				} 
			}	
		} 
		return src;
	}

}
