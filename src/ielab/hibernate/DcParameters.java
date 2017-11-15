package ielab.hibernate;

import java.util.HashSet;
import java.util.Set;

/**
 * DcParameters entity.
 * 
 * @author MyEclipse Persistence Tools
 */

public class DcParameters implements java.io.Serializable {

	// Fields

	private Integer id;
	private Integer initialPurchasePrice;
	private Integer initialSellingPrice;
	private Integer demand;
	private Integer dcinitialInventory;
	private Integer infoDegree;
	private Integer cycleTime;
	private Integer numberofRetailer;
	private Integer totalCycle;
	private Integer distributionScheme;
	private String name;

	private Set dcExperimentses = new HashSet(0);

	// Constructors

	/** default constructor */
	public DcParameters() {
	}

	/** full constructor */
	public DcParameters(Integer initialPurchasePrice,
			Integer initialSellingPrice, Integer demand,
			Integer dcinitialInventory, Integer infoDegree, Integer cycleTime,
			Integer numberofRetailer, Integer totalCycle,
			Integer distributionScheme, String name, Set dcExperimentses) {
		this.initialPurchasePrice = initialPurchasePrice;
		this.initialSellingPrice = initialSellingPrice;
		this.demand = demand;
		this.dcinitialInventory = dcinitialInventory;
		this.infoDegree = infoDegree;
		this.cycleTime = cycleTime;
		this.numberofRetailer = numberofRetailer;
		this.totalCycle = totalCycle;
		this.distributionScheme = distributionScheme;
		this.name = name;
		this.dcExperimentses = dcExperimentses;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getInitialPurchasePrice() {
		return this.initialPurchasePrice;
	}

	public void setInitialPurchasePrice(Integer initialPurchasePrice) {
		this.initialPurchasePrice = initialPurchasePrice;
	}

	public Integer getInitialSellingPrice() {
		return this.initialSellingPrice;
	}

	public void setInitialSellingPrice(Integer initialSellingPrice) {
		this.initialSellingPrice = initialSellingPrice;
	}

	public Integer getDcinitialInventory() {
		return this.dcinitialInventory;
	}

	public void setDcinitialInventory(Integer dcinitialInventory) {
		this.dcinitialInventory = dcinitialInventory;
	}

	public Integer getInfoDegree() {
		return this.infoDegree;
	}

	public void setInfoDegree(Integer infoDegree) {
		this.infoDegree = infoDegree;
	}

	public Integer getCycleTime() {
		return this.cycleTime;
	}

	public void setCycleTime(Integer cycleTime) {
		this.cycleTime = cycleTime;
	}

	public Integer getNumberofRetailer() {
		return this.numberofRetailer;
	}

	public void setNumberofRetailer(Integer numberofRetailer) {
		this.numberofRetailer = numberofRetailer;
	}

	public Integer getTotalCycle() {
		return this.totalCycle;
	}

	public void setTotalCycle(Integer totalCycle) {
		this.totalCycle = totalCycle;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Set getDcExperimentses() {
		return this.dcExperimentses;
	}

	public void setDcExperimentses(Set dcExperimentses) {
		this.dcExperimentses = dcExperimentses;
	}

	public Integer getDemand() {
		return demand;
	}

	public void setDemand(Integer demand) {
		this.demand = demand;
	}

	public Integer getDistributionScheme() {
		return distributionScheme;
	}

	public void setDistributionScheme(Integer distributionScheme) {
		this.distributionScheme = distributionScheme;
	}

}