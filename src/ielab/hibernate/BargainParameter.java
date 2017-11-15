package ielab.hibernate;

/**
 * BargainParameter entity. @author MyEclipse Persistence Tools
 */

public class BargainParameter implements java.io.Serializable {

	// Fields

	private Integer id;
	private Integer decisionTime;
	private String name;
	private Integer numberOfPerson;
	private Double ma;
	private Double mb;
	private Double k;
	private Double c;
	private Integer a;
	private Integer b;
	private Double p;
	private Integer oneRoundTime;

	// Constructors

	/** default constructor */
	public BargainParameter() {
	}

	/** full constructor */
	public BargainParameter(Integer decisionTime, String name, Integer numberOfPerson, Double ma, Double mb, Double k,
			Double c, Integer a, Integer b, Double p, Integer oneRoundTime) {
		this.decisionTime = decisionTime;
		this.name = name;
		this.numberOfPerson = numberOfPerson;
		this.ma = ma;
		this.mb = mb;
		this.k = k;
		this.c = c;
		this.a = a;
		this.b = b;
		this.p = p;
		this.oneRoundTime = oneRoundTime;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getDecisionTime() {
		return this.decisionTime;
	}

	public void setDecisionTime(Integer decisionTime) {
		this.decisionTime = decisionTime;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getNumberOfPerson() {
		return this.numberOfPerson;
	}

	public void setNumberOfPerson(Integer numberOfPerson) {
		this.numberOfPerson = numberOfPerson;
	}

	public Double getMa() {
		return this.ma;
	}

	public void setMa(Double ma) {
		this.ma = ma;
	}

	public Double getMb() {
		return this.mb;
	}

	public void setMb(Double mb) {
		this.mb = mb;
	}

	public Double getK() {
		return this.k;
	}

	public void setK(Double k) {
		this.k = k;
	}

	public Double getC() {
		return this.c;
	}

	public void setC(Double c) {
		this.c = c;
	}

	public Integer getA() {
		return this.a;
	}

	public void setA(Integer a) {
		this.a = a;
	}

	public Integer getB() {
		return this.b;
	}

	public void setB(Integer b) {
		this.b = b;
	}

	public Double getP() {
		return this.p;
	}

	public void setP(Double p) {
		this.p = p;
	}

	public Integer getOneRoundTime() {
		return this.oneRoundTime;
	}

	public void setOneRoundTime(Integer oneRoundTime) {
		this.oneRoundTime = oneRoundTime;
	}

}