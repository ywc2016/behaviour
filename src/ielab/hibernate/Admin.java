package ielab.hibernate;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Admin entity.
 * 
 * @author MyEclipse Persistence Tools
 */

public class Admin implements java.io.Serializable {

	// Fields

	private Integer id;
	private String username;
	private String password;
	private Byte supadmin;
	private String name;
	private String university;
	private String authority;
	private String email;
	private String tel;
	private Date registertime;
	private Date overtime;
	private String description;
	private Set dcExperimentses = new HashSet(0);

	// Constructors

	/** default constructor */
	public Admin() {
	}

	/** minimal constructor */
	public Admin(String username, Byte supadmin) {
		this.username = username;
		this.supadmin = supadmin;
	}

	/** full constructor */
	public Admin(String username, String password, Byte supadmin, String name,
			String university, String authority, String email, String tel,
			Date registertime, Date overtime, String description,
			Set dcExperimentses) {
		this.username = username;
		this.password = password;
		this.supadmin = supadmin;
		this.name = name;
		this.university = university;
		this.authority = authority;
		this.email = email;
		this.tel = tel;
		this.registertime = registertime;
		this.overtime = overtime;
		this.description = description;
		this.dcExperimentses = dcExperimentses;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Byte getSupadmin() {
		return this.supadmin;
	}

	public void setSupadmin(Byte supadmin) {
		this.supadmin = supadmin;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUniversity() {
		return this.university;
	}

	public void setUniversity(String university) {
		this.university = university;
	}

	public String getAuthority() {
		return this.authority;
	}

	public void setAuthority(String authority) {
		this.authority = authority;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTel() {
		return this.tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public Date getRegistertime() {
		return this.registertime;
	}

	public void setRegistertime(Date registertime) {
		this.registertime = registertime;
	}

	public Date getOvertime() {
		return this.overtime;
	}

	public void setOvertime(Date overtime) {
		this.overtime = overtime;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Set getDcExperimentses() {
		return this.dcExperimentses;
	}

	public void setDcExperimentses(Set dcExperimentses) {
		this.dcExperimentses = dcExperimentses;
	}

}