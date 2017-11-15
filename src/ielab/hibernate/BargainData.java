package ielab.hibernate;

import java.sql.Timestamp;

/**
 * BargainData entity. @author MyEclipse Persistence Tools
 */

public class BargainData implements java.io.Serializable {

	// Fields

	private Integer id;
	private Integer matchId;
	private Timestamp beginTime;
	private Timestamp finishTime;
	private Integer acceptStatus;
	private Integer quantity;
	private Double price;
	private Integer participantId;

	// Constructors

	/** default constructor */
	public BargainData() {
	}

	/** full constructor */
	public BargainData(Integer matchId, Timestamp beginTime, Timestamp finishTime, Integer acceptStatus,
			Integer quantity, Double price, Integer participantId) {
		this.matchId = matchId;
		this.beginTime = beginTime;
		this.finishTime = finishTime;
		this.acceptStatus = acceptStatus;
		this.quantity = quantity;
		this.price = price;
		this.participantId = participantId;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getMatchId() {
		return this.matchId;
	}

	public void setMatchId(Integer matchId) {
		this.matchId = matchId;
	}

	public Timestamp getBeginTime() {
		return this.beginTime;
	}

	public void setBeginTime(Timestamp beginTime) {
		this.beginTime = beginTime;
	}

	public Timestamp getFinishTime() {
		return this.finishTime;
	}

	public void setFinishTime(Timestamp finishTime) {
		this.finishTime = finishTime;
	}

	public Integer getAcceptStatus() {
		return this.acceptStatus;
	}

	public void setAcceptStatus(Integer acceptStatus) {
		this.acceptStatus = acceptStatus;
	}

	public Integer getQuantity() {
		return this.quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Double getPrice() {
		return this.price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Integer getParticipantId() {
		return this.participantId;
	}

	public void setParticipantId(Integer participantId) {
		this.participantId = participantId;
	}

}