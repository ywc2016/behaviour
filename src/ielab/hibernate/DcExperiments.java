package ielab.hibernate;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * DcExperiments entity.
 * 
 * @author MyEclipse Persistence Tools
 */

public class DcExperiments implements java.io.Serializable {

	// Fields

	private Integer id;
	private DcParameters dcParameters;
	private Admin admin;
	private String experimentName;
	private String retailerPassword;
	private Date beginTime;
	private Date overTime;
	private Integer experimentState;
	private Float showFee;
	private Float exchangeRate;
	private Float guessBonus;
	private String type;
	private Set dcDatas = new HashSet(0);

	// Constructors

	/** default constructor */
	public DcExperiments() {
	}

	/** minimal constructor */
	public DcExperiments(Admin admin) {
		this.admin = admin;
	}

	/** full constructor */
	public DcExperiments(DcParameters dcParameters, Admin admin,
			String experimentName, String retailerPassword, Date beginTime,
			Date overTime, Integer experimentState, Set dcDatas) {
		this.dcParameters = dcParameters;
		this.admin = admin;
		this.experimentName = experimentName;
		this.retailerPassword = retailerPassword;
		this.beginTime = beginTime;
		this.overTime = overTime;
		this.experimentState = experimentState;
		this.dcDatas = dcDatas;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public DcParameters getDcParameters() {
		return this.dcParameters;
	}

	public void setDcParameters(DcParameters dcParameters) {
		this.dcParameters = dcParameters;
	}

	public Admin getAdmin() {
		return this.admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
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

	public Set getDcDatas() {
		return this.dcDatas;
	}

	public void setDcDatas(Set dcDatas) {
		this.dcDatas = dcDatas;
	}
	
	public Float getShowFee()
	{
		return this.showFee;
	}
	
	public void setShowFee(Float showFee)
	{
		this.showFee =showFee;
	}
	
	public Float getExchangeRate()
	{
		return exchangeRate;
	}
	
	public void setExchangeRate(Float exchangeRate)
	{
		this.exchangeRate =exchangeRate;
	}
	
	public Float getGuessBonus()
	{
		return guessBonus;
	}
	public void setGuessBonus(Float guessBonus)
	{
		this.guessBonus =guessBonus;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	

}