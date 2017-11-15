package ielab.hibernate;

import java.util.Date;

/**
 * DcData entity.
 * 
 * @author MyEclipse Persistence Tools
 */

public class DcData implements java.io.Serializable {

	// Fields

	private Integer id;
	private DcExperiments dcExperiments;
	private Integer retailerId;
	private Integer cycle;
	private Date begainTime1;
	private Date begainTime2;
	private float inventory;
	private Integer purchasePrice;
	private Integer sellingPrice;
	private Integer Competitor;
	private Integer orderOut;
	private Integer orderIn;
	private float goodsOut;
	private float goodsIn;
	private Integer Guess;
	private float guessBonus;
	private float backlogCost;
	private float goodsCost;
	private float goodsIncome;
	private float netIncome;
	private float total;
	private Integer tag;//用来标示在类UpdateCycle中的数据是否更新的状态

	// Constructors

	/** default constructor */
	public DcData() {
	}

	/** minimal constructor */
	public DcData(DcExperiments dcExperiments) {
		this.dcExperiments = dcExperiments;
	}

	/** full constructor */
	public DcData(DcExperiments dcExperiments, Integer retailerId,
			Integer cycle, Date begainTime1, Date begainTime2,
			float inventory, Integer purchasePrice, Integer sellingPrice,
			Integer Competitor, Integer orderOut, Integer orderIn,
			float goodsOut, float goodsIn, Integer Guess,
			float guessBonus, float backlogCost, float goodsCost,
			float goodsIncome, float netIncome, Integer total, Integer tag) {
		this.dcExperiments = dcExperiments;
		this.retailerId = retailerId;
		this.cycle = cycle;
		this.begainTime1 = begainTime1;
		this.begainTime2 = begainTime2;
		this.inventory = inventory;
		this.purchasePrice = purchasePrice;
		this.sellingPrice = sellingPrice;
		this.Competitor = Competitor;
		this.orderOut = orderOut;
		this.orderIn = orderIn;
		this.goodsOut = goodsOut;
		this.goodsIn = goodsIn;
		this.Guess = Guess;
		this.guessBonus = guessBonus;
		this.backlogCost = backlogCost;
		this.goodsCost = goodsCost;
		this.goodsIncome = goodsIncome;
		this.netIncome = netIncome;
		this.total = total;
		this.tag = tag;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public DcExperiments getDcExperiments() {
		return this.dcExperiments;
	}

	public void setDcExperiments(DcExperiments dcExperiments) {
		this.dcExperiments = dcExperiments;
	}

	public Integer getRetailerId() {
		return this.retailerId;
	}

	public void setRetailerId(Integer retailerId) {
		this.retailerId = retailerId;
	}

	public Integer getCycle() {
		return this.cycle;
	}

	public void setCycle(Integer cycle) {
		this.cycle = cycle;
	}

	public Date getBegainTime1() {
		return this.begainTime1;
	}

	public void setBegainTime1(Date begainTime1) {
		this.begainTime1 = begainTime1;
	}

	public Date getBegainTime2() {
		return this.begainTime2;
	}

	public void setBegainTime2(Date begainTime2) {
		this.begainTime2 = begainTime2;
	}

	public float getInventory() {
		return this.inventory;
	}

	public void setInventory(float inventory) {
		this.inventory = inventory;
	}
	

	public Integer getPurchasePrice() {
		return this.purchasePrice;
	}

	public void setPurchasePrice(Integer purchasePrice) {
		this.purchasePrice = purchasePrice;
	}

	public Integer getSellingPrice() {
		return this.sellingPrice;
	}

	public void setSellingPrice(Integer sellingPrice) {
		this.sellingPrice = sellingPrice;
	}

	public Integer getCompetitor() {
		return this.Competitor;
	}

	public void setCompetitor(Integer Competitor) {
		this.Competitor = Competitor;
	}

	public Integer getOrderOut() {
		return this.orderOut;
	}

	public void setOrderOut(Integer orderOut) {
		this.orderOut = orderOut;
	}

	public Integer getOrderIn() {
		return this.orderIn;
	}

	public void setOrderIn(Integer orderIn) {
		this.orderIn = orderIn;
	}

	public float getGoodsOut() {
		return this.goodsOut;
	}

	public void setGoodsOut(float goodsOut) {
		this.goodsOut = goodsOut;
	}

	public float getGoodsIn() {
		return this.goodsIn;
	}

	public void setGoodsIn(float goodsIn) {
		this.goodsIn = goodsIn;
	}

	public Integer getGuess() {
		return this.Guess;
	}

	public void setGuess(Integer Guess) {
		this.Guess = Guess;
	}

	public float getGuessBonus() {
		return this.guessBonus;
	}

	public void setGuessBonus(float guessBonus) {
		this.guessBonus = guessBonus;
	}

	public float getBacklogCost() {
		return this.backlogCost;
	}

	public void setBacklogCost(float backlogCost) {
		this.backlogCost = backlogCost;
	}

	public float getGoodsCost() {
		return this.goodsCost;
	}

	public void setGoodsCost(float goodsCost) {
		this.goodsCost = goodsCost;
	}

	public float getGoodsIncome() {
		return this.goodsIncome;
	}

	public void setGoodsIncome(float goodsIncome) {
		this.goodsIncome = goodsIncome;
	}

	public float getNetIncome() {
		return this.netIncome;
	}

	public void setNetIncome(float netIncome) {
		this.netIncome = netIncome;
	}

	public float getTotal() {
		return this.total;
	}

	public void setTotal(float total) {
		this.total = total;
	}

	public Integer getTag() {
		return this.tag;
	}

	public void setTag(Integer tag) {
		this.tag = tag;
	}

}