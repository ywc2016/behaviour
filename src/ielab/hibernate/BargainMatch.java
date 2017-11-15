package ielab.hibernate;

import java.sql.Timestamp;

/**
 * BargainMatch entity. @author MyEclipse Persistence Tools
 */

public class BargainMatch implements java.io.Serializable {

	// Fields

	private Integer id;
	private Integer experimentId;
	private Integer participantId;
	private Integer secondParticipantId;
	private String status;
	private String participantStatus;
	private String secomdParticipantStatus;
	private Integer currentDataId;
	private Integer lastDataId;
	private Double supplierProfits;
	private Double retailerProfits;
	private Timestamp beginTime;
	private Timestamp endTime;
	private Integer cycle;

	// Constructors

	/** default constructor */
	public BargainMatch() {
	}

	/** full constructor */
	public BargainMatch(Integer experimentId, Integer participantId, Integer secondParticipantId, String status,
			String participantStatus, String secomdParticipantStatus, Integer currentDataId, Integer lastDataId,
			Double supplierProfits, Double retailerProfits, Timestamp beginTime, Timestamp endTime, Integer cycle) {
		this.experimentId = experimentId;
		this.participantId = participantId;
		this.secondParticipantId = secondParticipantId;
		this.status = status;
		this.participantStatus = participantStatus;
		this.secomdParticipantStatus = secomdParticipantStatus;
		this.currentDataId = currentDataId;
		this.lastDataId = lastDataId;
		this.supplierProfits = supplierProfits;
		this.retailerProfits = retailerProfits;
		this.beginTime = beginTime;
		this.endTime = endTime;
		this.cycle = cycle;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getExperimentId() {
		return this.experimentId;
	}

	public void setExperimentId(Integer experimentId) {
		this.experimentId = experimentId;
	}

	public Integer getParticipantId() {
		return this.participantId;
	}

	public void setParticipantId(Integer participantId) {
		this.participantId = participantId;
	}

	public Integer getSecondParticipantId() {
		return this.secondParticipantId;
	}

	public void setSecondParticipantId(Integer secondParticipantId) {
		this.secondParticipantId = secondParticipantId;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getParticipantStatus() {
		return this.participantStatus;
	}

	public void setParticipantStatus(String participantStatus) {
		this.participantStatus = participantStatus;
	}

	public String getSecomdParticipantStatus() {
		return this.secomdParticipantStatus;
	}

	public void setSecomdParticipantStatus(String secomdParticipantStatus) {
		this.secomdParticipantStatus = secomdParticipantStatus;
	}

	public Integer getCurrentDataId() {
		return this.currentDataId;
	}

	public void setCurrentDataId(Integer currentDataId) {
		this.currentDataId = currentDataId;
	}

	public Integer getLastDataId() {
		return this.lastDataId;
	}

	public void setLastDataId(Integer lastDataId) {
		this.lastDataId = lastDataId;
	}

	public Double getSupplierProfits() {
		return this.supplierProfits;
	}

	public void setSupplierProfits(Double supplierProfits) {
		this.supplierProfits = supplierProfits;
	}

	public Double getRetailerProfits() {
		return this.retailerProfits;
	}

	public void setRetailerProfits(Double retailerProfits) {
		this.retailerProfits = retailerProfits;
	}

	public Timestamp getBeginTime() {
		return this.beginTime;
	}

	public void setBeginTime(Timestamp beginTime) {
		this.beginTime = beginTime;
	}

	public Timestamp getEndTime() {
		return this.endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public Integer getCycle() {
		return this.cycle;
	}

	public void setCycle(Integer cycle) {
		this.cycle = cycle;
	}

}