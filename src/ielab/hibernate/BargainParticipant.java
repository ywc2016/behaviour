package ielab.hibernate;

/**
 * BargainParticipant entity. @author MyEclipse Persistence Tools
 */

public class BargainParticipant implements java.io.Serializable {

	// Fields

	private Integer id;
	private Integer number;
	private String status;
	private Integer experimentId;
	private Integer matchId;
	private Integer currentCycle;

	// Constructors

	/** default constructor */
	public BargainParticipant() {
	}

	/** full constructor */
	public BargainParticipant(Integer number, String status, Integer experimentId, Integer matchId,
			Integer currentCycle) {
		this.number = number;
		this.status = status;
		this.experimentId = experimentId;
		this.matchId = matchId;
		this.currentCycle = currentCycle;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getNumber() {
		return this.number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getExperimentId() {
		return this.experimentId;
	}

	public void setExperimentId(Integer experimentId) {
		this.experimentId = experimentId;
	}

	public Integer getMatchId() {
		return this.matchId;
	}

	public void setMatchId(Integer matchId) {
		this.matchId = matchId;
	}

	public Integer getCurrentCycle() {
		return this.currentCycle;
	}

	public void setCurrentCycle(Integer currentCycle) {
		this.currentCycle = currentCycle;
	}

}