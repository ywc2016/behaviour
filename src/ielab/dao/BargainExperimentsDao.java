package ielab.dao;

import java.util.List;

import ielab.hibernate.BargainExperiments;
import ielab.hibernate.BargainParameter;
import ielab.hibernate.BargainParticipant;

public class BargainExperimentsDao extends BaseDao<BargainExperiments> {

	/**
	 * 根据id查找对应的参数
	 * 
	 * @param id
	 * @return
	 */
	public BargainParameter findBargainParameterByExperimentId(int id) {
		BargainExperiments bargainExperiments = findByKey(id);

		BargainParameterDao bargainParameterDao = new BargainParameterDao();
		BargainParameter bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId().intValue());
		return bargainParameter;

	}

	/**
	 * 整个实验是否结束
	 * 
	 * @param experimentId
	 * @return
	 */
	public boolean isFinished(int experimentId) {
		BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
		BargainParameterDao bargainParameterDao = new BargainParameterDao();
		List<BargainParticipant> bargainParticipantList = bargainParticipantDao.findByPropertyEqual("experimentId",
				experimentId + "", "int");
		BargainExperiments bargainExperiments = findByKey(experimentId);
		BargainParameter bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId());
		if (bargainExperiments.getCurrentCycle() != (bargainParameter.getNumberOfPerson() - 1) * 2) {// 实验还未到最大轮数
			return false;
		}

		for (BargainParticipant bargainParticipant : bargainParticipantList) {
			if (!bargainParticipant.getCurrentCycle().equals(bargainExperiments.getCurrentCycle())
					|| !bargainParticipant.getStatus().equals("空闲中")) {
				return false;
			}
		}
		return true;
	}
}
