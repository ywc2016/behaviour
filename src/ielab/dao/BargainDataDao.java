package ielab.dao;

import ielab.hibernate.BargainData;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;
import java.util.Map;

public class BargainDataDao extends BaseDao<BargainData> {

    public List<BargainData> findByMultiProperties(Map<String, Object> conditions) {

        try {
            String queryString = "from " + typeClass().getCanonicalName() + " where 1=1 ";
            if (conditions.containsKey("experimentId")) {
                queryString += " and experimentId = :experimentId ";
            }
            if (conditions.containsKey("participantId")) {
                queryString += " and participantId = :participantId ";
            }
            if (conditions.containsKey("cycle")) {
                queryString += " and cycle = :cycle ";
            }

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);

            if (conditions.containsKey("experimentId")) {
                query.setInteger("experimentId", (Integer) conditions.get("experimentId"));
            }
            if (conditions.containsKey("participantId")) {
                query.setInteger("participantId", (Integer) conditions.get("participantId"));
            }
            if (conditions.containsKey("cycle")) {
                query.setInteger("cycle", (Integer) conditions.get("cycle"));
            }

            List<BargainData> pojos = (List<BargainData>) query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 根据match id查找历史数据 按日期从大到小排列
     *
     * @param matchId
     */
    public List<BargainData> findHistory(int matchId) {
        try {
            String queryString = "from BargainData where 1=1 and matchId = " + matchId
                    + " order by beginTime asc";

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);

            List<BargainData> pojos = (List<BargainData>) query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

}
