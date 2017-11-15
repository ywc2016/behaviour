package ielab.hibernate;

import java.util.Date;

/**
 * BargainExperiments entity. @author MyEclipse Persistence Tools
 */

public class BargainExperiments implements java.io.Serializable {

	// Fields

	private Integer id;
	private String experimentName;
	private String retailerPassword;
	private Date beginTime;
	private Date overTime;
	private Integer experimentState;
	private Integer parId;
	private String randomNeed;
	private Integer currentCycle;

	// Constructors

	/** default constructor */
	public BargainExperiments() {
	}

	/** full constructor */
	public BargainExperiments(String experimentName, String retailerPassword, Date beginTime, Date overTime,
			Integer experimentState, Integer parId, String randomNeed, Integer currentCycle) {
		this.experimentName = experimentName;
		this.retailerPassword = retailerPassword;
		this.beginTime = beginTime;
		this.overTime = overTime;
		this.experimentState = experimentState;
		this.parId = parId;
		this.randomNeed = randomNeed;
		this.currentCycle = currentCycle;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getExperimentName() {
		return this.experimentName;
	}

	public void setExperimentName(String experimentName) {
		this.experimentName = experimentName;
	}

	public String getRetailerPassword() {
		return this.retailerPassword;
	}

	public void setRetailerPassword(String retailerPassword) {
		this.retailerPassword = retailerPassword;
	}

	public Date getBeginTime() {
		return this.beginTime;
	}

	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}

	public Date getOverTime() {
		return this.overTime;
	}

	public void setOverTime(Date overTime) {
		this.overTime = overTime;
	}

	public Integer getExperimentState() {
		return this.experimentState;
	}

	public void setExperimentState(Integer experimentState) {
		this.experimentState = experimentState;
	}

	public Integer getParId() {
		return this.parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public String getRandomNeed() {
		return this.randomNeed;
	}

	public void setRandomNeed(String randomNeed) {
		this.randomNeed = randomNeed;
	}

	public Integer getCurrentCycle() {
		return this.currentCycle;
	}

	public void setCurrentCycle(Integer currentCycle) {
		this.currentCycle = currentCycle;
	}

}