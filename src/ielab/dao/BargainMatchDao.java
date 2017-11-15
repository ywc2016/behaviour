package ielab.dao;

import ielab.hibernate.BargainExperiments;
import ielab.hibernate.BargainMatch;
import ielab.hibernate.BargainParameter;
import ielab.hibernate.BargainParticipant;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.Date;
import java.sql.Timestamp;
import java.util.Iterator;
import java.util.List;

public class BargainMatchDao extends BaseDao<BargainMatch> {

    public static void main(String[] args) {
        // new BargainMatchDao().initBargainMatch(1);
        // BargainMatch bargainMatch = new BargainMatchDao().findMatch(1, 1);
        // System.out.println(bargainMatch.getId());
        System.out.println(new BargainMatchDao().isParticipantFinishAllMatch(20, 4));
    }

    /**
     * 初始化谈判匹配
     *
     * @param experimentId   实验id
     * @param numberOfRandom 随机需求的个数
     */
    public void initBargainMatch(int experimentId, int numberOfRandom) {
        BargainMatchDao bargainMatchDao = new BargainMatchDao();
        BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
        BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
        BargainExperiments bargainExperiments = bargainExperimentsDao.findByKey(experimentId);
        if (bargainExperiments == null) {
            return;
        }

        BargainParameter bargainParameter = bargainExperimentsDao.findBargainParameterByExperimentId(experimentId);
        int numOfParticipants = bargainParameter.getNumberOfPerson();

        // 初始化参与者信息,写入数据库

        for (int i = 0; i < numOfParticipants; i++) {
            BargainParticipant bargainParticipant = new BargainParticipant();
            bargainParticipant.setExperimentId(experimentId);
            bargainParticipant.setNumber(i + 1);// 设置编号
            bargainParticipant.setStatus("空闲中");
            bargainParticipant.setCurrentCycle(0);
            bargainParticipantDao.save(bargainParticipant);
        }

        List<BargainParticipant> bargainParticipants = bargainParticipantDao.findByPropertyEqual("experimentId",
                experimentId + "", "int");
        // 将匹配分组信息写入数据库

        for (int i = 0; i < numOfParticipants; i++) {
            for (int j = 0; j < numOfParticipants; j++) {
                if (i == j) {
                    continue;
                }
                int participantId = bargainParticipants.get(i).getId();
                int secondParticipantId = bargainParticipants.get(j).getId();
                String status = "未完成";

                BargainMatch bargainMatch = new BargainMatch();
                bargainMatch.setExperimentId(experimentId);
                bargainMatch.setParticipantId(participantId);
                bargainMatch.setSecondParticipantId(secondParticipantId);
                bargainMatch.setStatus(status);
                bargainMatch.setParticipantStatus("未开始");
                bargainMatch.setSecomdParticipantStatus("未开始");

                bargainMatchDao.save(bargainMatch);
            }
        }

        // 生成随机需求,写入数据库
        int a = bargainParameter.getA();
        int b = bargainParameter.getB();
        StringBuilder randomNeed = new StringBuilder();
        for (int i = 0; i < numberOfRandom; i++) {
            int d = (int) (Math.random() * (b - a)) + a;
            randomNeed.append(d + ",");
        }
        randomNeed.deleteCharAt(randomNeed.length() - 1);// 删除最后一个,
        bargainExperiments.setRandomNeed(randomNeed.toString());
        bargainExperimentsDao.update(bargainExperiments);
    }

    /**
     * 根据参与者id和实验id返回匹配结果,如果结束则返回null
     *
     * @param participantId
     * @return
     */
    public BargainMatch findMatch(int participantId, int experimentId) {
        synchronized (this.getClass()) {
            BargainParameterDao bargainParameterDao = new BargainParameterDao();
            BargainExperimentsDao bargainExperimentsDao = new BargainExperimentsDao();
            BargainMatchDao bargainMatchDao = new BargainMatchDao();

            BargainExperiments bargainExperiments = bargainExperimentsDao.findByKey(experimentId);
            BargainParameter bargainParameter = bargainParameterDao.findByKey(bargainExperiments.getParId());
            try {
                String queryString = "from " + typeClass().getCanonicalName()
                        + " as a ,BargainParticipant as b,BargainParticipant as c "
                        + " where a.participantId = b.id and a.experimentId = b.experimentId and "
                        + " a.secondParticipantId = c.id and a.experimentId = c.experimentId"
                        + " and b.status = '空闲中' and c.status = '空闲中'"
                        + " and a.experimentId = :experimentId and a.participantId = :participantId and a.status = '未完成'";
                Session session = sessionFactory.getCurrentSession();
                session.beginTransaction();
                Query query = session.createQuery(queryString);
                query.setInteger("experimentId", experimentId);
                query.setInteger("participantId", participantId);
                List pojos = query.list();
                session.getTransaction().commit();

                if (pojos.size() == 0) {
                    return null;
                }

                // 必须匹配到符合当前周期的用户

                Iterator iterator = pojos.iterator();
                for (; iterator.hasNext(); ) {
                    Object[] objects = (Object[]) iterator.next();
                    BargainMatch bargainMatch = (BargainMatch) objects[0];
                    BargainParticipant bargainParticipant1 = (BargainParticipant) objects[1];
                    BargainParticipant bargainParticipant2 = (BargainParticipant) objects[2];

                    if (bargainParticipant1.getStatus().equals("空闲中")
                            && bargainParticipant1.getCurrentCycle() < bargainExperiments.getCurrentCycle()
                            && bargainParticipant2.getStatus().equals("空闲中")
                            && bargainParticipant2.getCurrentCycle() < bargainExperiments.getCurrentCycle()) {// 符合周期条件
                        // 设置用户的状态
                        BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
                        bargainParticipant1.setStatus("谈判中");
                        bargainParticipant1.setCurrentCycle(bargainParticipant1.getCurrentCycle() + 1);//周期往后推1

                        bargainParticipant2.setStatus("谈判中");
                        bargainParticipant2.setCurrentCycle(bargainParticipant2.getCurrentCycle() + 1);//周期往后推1

                        bargainParticipant1.setMatchId(bargainMatch.getId());
                        bargainParticipant2.setMatchId(bargainMatch.getId());
                        bargainParticipantDao.update(bargainParticipant1);
                        bargainParticipantDao.update(bargainParticipant2);

                        //设置这轮的开始时间
                        bargainMatch.setBeginTime(new Timestamp(new Date().getTime()));
                        bargainMatch.setCycle(bargainExperiments.getCurrentCycle());
                        bargainMatchDao.update(bargainMatch);

                        return bargainMatch;
                    }

                }
                return null;
            } catch (RuntimeException re) {
                throw re;
            }
        }
    }

    /**
     * 判断某个参与者是否已经结束了所有的谈判配对
     *
     * @param participantId
     * @param experimentId
     * @return
     */
    public boolean isParticipantFinishAllMatch(int participantId, int experimentId) {

        BargainParticipantDao bargainParticipantDao = new BargainParticipantDao();
        BargainParticipant bargainParticipant = bargainParticipantDao.findByKey(participantId);

        try {
            String queryString = "from " + typeClass().getCanonicalName() + " where experimentId = " + experimentId
                    + " and status = '未完成' and (participantId = " + participantId + "or secondParticipantId = "
                    + participantId + ")";

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);
            List pojos = query.list();
            session.getTransaction().commit();
            if (pojos.size() == 0) {
                return true;
            }
        } catch (RuntimeException re) {
            throw re;
        }

        return false;
    }

    /**
     * 分页查询实验数据,只显示匹配信息
     *
     * @param experimentId
     * @param order
     * @param page
     * @param rows
     * @return
     */
    public List findMatchForpagination(int experimentId, int participantId, String order, String page,
                                       String rows) {
        order = ielab.util.StringUtils.isEmpty(order) ? "id" : order;
        int intPage = ielab.util.StringUtils.isEmpty(page) ? 1 : Integer.parseInt(page);
        int intRows = ielab.util.StringUtils.isEmpty(rows) ? 20 : Integer.parseInt(rows);

        try {

            // String queryString = experimentId == 0 ? "from " +
            // typeClass().getCanonicalName()
            // + " as a, BargainParticipant as b , BargainParticipant as c where
            // a.experimentId <> " + experimentId
            // + " and a.participantId = b.id and a.secondParticipantId = c.id
            // order by a." + order + " asc"
            // : "from " + typeClass().getCanonicalName()
            // + " as a, BargainParticipant as b , BargainParticipant as c where
            // a.experimentId = "
            // + experimentId + " and a.participantId = b.id and
            // a.secondParticipantId = c.id order by a."
            // + order + " asc";

            String queryString = "from BargainMatch"
                    + " as a, BargainParticipant as b , BargainParticipant as c where a.participantId = b.id "
                    + "and a.secondParticipantId = c.id ";

            if (experimentId != 0) {
                queryString += " and a.experimentId = " + experimentId;
            }

            if (participantId != 0) {
                queryString += " and (a.participantId = " + participantId + " or a.secondParticipantId ="
                        + participantId + " )";
            }

            queryString += " order by a." + order + " asc";

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);
            query.setFirstResult((intPage - 1) * intRows);
            query.setMaxResults(intRows);

            List pojos = query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 查询匹配总数
     *
     * @param experimentId
     * @return
     */
    public long countRowsByParameter(int experimentId) {

        try {
            String queryString = experimentId == 0 ? "select count(*) from " + typeClass().getCanonicalName()
                    : "select count(*) from " + typeClass().getCanonicalName() + " where experimentId = "
                    + experimentId;

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);

            List pojos = query.list();
            session.getTransaction().commit();
            return (long) pojos.get(0);
        } catch (RuntimeException re) {
            throw re;
        }
    }
}
