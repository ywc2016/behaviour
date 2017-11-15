package ielab.dao;

import ielab.hibernate.HibernateSessionFactory;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;

import java.lang.reflect.ParameterizedType;
import java.util.List;

/**
 * Dao的基本类，用户设置一些公共属性和方法，每一个Dao类必须继承该类
 */
public class BaseDao<T> {
    public SessionFactory sessionFactory = HibernateSessionFactory.getSessionFactory();

    /**
     * 取得泛型实现类型
     */
    @SuppressWarnings("unchecked")
    protected Class<T> typeClass() {
        return (Class<T>) ((ParameterizedType) getClass()
                .getGenericSuperclass()).getActualTypeArguments()[0];
    }

    /**
     * 保存一条记录
     *
     * @param pojo
     */
    public void save(T pojo) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            session.save(pojo);
            session.getTransaction().commit();
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 更新一条记录
     *
     * @param pojo
     */
    public void update(T pojo) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            session.update(pojo);
            session.getTransaction().commit();
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 使用openTransaction
     *
     * @param pojo
     */
    public void updateUseOpenTransaction(T pojo) {
        try {
            Session session = sessionFactory.openSession();
            session.beginTransaction();
            session.update(pojo);
            session.getTransaction().commit();
            session.close();
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 保存或者更新一条记录，如果确定知道是保存还是更新，请调用save或者update方法
     *
     * @param pojo
     */
    public void saveOrUpdate(T pojo) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            session.saveOrUpdate(pojo);
            session.getTransaction().commit();
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 删除一条记录
     */
    public void delete(T pojo) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            session.delete(pojo);
            session.getTransaction().commit();
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 根据主键或属性删除一条或多条记录
     */
    public void deleteByKeys(String key, String[] ids, String type) {
        try {
            String queryString = "delete " + typeClass().getCanonicalName()
                    + " where";
            for (int i = 0; i < ids.length; i++) {
                queryString += " " + key + "= ? or";
            }
            queryString = StringUtils.removeEnd(queryString, "or");

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();

            Query query = session.createQuery(queryString);
            for (int i = 0; i < ids.length; i++) {
                if (type.equals("String")) {
                    query.setString(i, ids[i]);
                } else if (type.equals("long")) {
                    query.setLong(i, Long.parseLong(ids[i]));
                } else if (type.equals("int")) {
                    query.setInteger(i, Integer.parseInt(ids[i]));
                }
            }
            query.executeUpdate();
            session.getTransaction().commit();
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 根据主键查询一条或多条记录
     */
    public List<T> findByKeys(String key, String[] ids, String type) {
        try {
            String queryString = "from " + typeClass().getCanonicalName()
                    + " where ";
            for (int i = 0; i < ids.length; i++) {
                queryString += " " + key + "= ? or";
            }
            queryString = StringUtils.removeEnd(queryString, "or");
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);
            for (int i = 0; i < ids.length; i++) {
                if (type.equals("String")) {
                    query.setString(i, ids[i]);
                } else if (type.equals("long")) {
                    query.setLong(i, Long.parseLong(ids[i]));
                } else if (type.equals("int")) {
                    query.setInteger(i, Integer.parseInt(ids[i]));
                }
            }
            List<T> pojos = (List<T>) query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 根据long型主键查询一条记录
     */
    @SuppressWarnings("unchecked")
    public T findByKey(long id) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            T pojo = (T) session.get(typeClass(), id);
            session.getTransaction().commit();
            return pojo;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 根据int型主键查询一条记录
     */
    @SuppressWarnings("unchecked")
    public T findByKey(int id) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            T pojo = (T) session.get(typeClass(), id);
            session.getTransaction().commit();
            return pojo;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 根据string型主键查询一条记录
     */
    @SuppressWarnings("unchecked")
    public T findByKey(String id) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            T pojo = (T) session.get(typeClass(), id);
            session.getTransaction().commit();
            return pojo;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 单属性相等查询
     */
    @SuppressWarnings("unchecked")
    public List<T> findByPropertyEqual(String propertyName, String value,
                                       String type) {
        try {
            String queryString = "from " + typeClass().getCanonicalName()
                    + " as model where model." + propertyName + "= ?";

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();

            Query query = session.createQuery(queryString);
            if (type.equals("String")) {
                query.setString(0, value.toLowerCase());
            } else if (type.equals("long")) {
                query.setLong(0, Long.parseLong(value));
            } else if (type.equals("int")) {
                query.setInteger(0, Integer.parseInt(value));
            }
            List<T> pojos = query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 单属性相等查询
     */
    @SuppressWarnings("unchecked")
    public List<T> findByPropertyEqualWithOrder(String propertyName,
                                                String value, String type, String orderName, String sort) {
        try {
            StringBuilder queryString = new StringBuilder();
            queryString.append("from ");
            queryString.append(typeClass().getCanonicalName());
            queryString.append(" as model where model.");
            queryString.append(propertyName);
            queryString.append("=? order by model.");
            queryString.append(orderName);
            queryString.append(" ");
            queryString.append(sort);

            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString.toString());
            session.getTransaction().commit();
            if (type.equals("String")) {
                query.setString(0, value.toLowerCase());
            } else if (type.equals("long")) {
                query.setLong(0, Long.parseLong(value));
            } else if (type.equals("int")) {
                query.setInteger(0, Integer.parseInt(value));
            }
            List<T> pojos = query.list();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 单属性模糊查询
     */
    @SuppressWarnings("unchecked")
    public List<T> findByPropertyLike(String propertyName, String value) {
        try {
            String queryString = " from " + typeClass().getCanonicalName()
                    + " as model where LOWER(model." + propertyName
                    + ") like ?";
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);
            query.setString(0, "%" + String.valueOf(value).toLowerCase() + "%");
            List<T> pojos = query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 查询所有记录
     */
    @SuppressWarnings("unchecked")
    public List<T> findAll() {
        try {
            String queryString = "from " + typeClass().getCanonicalName();
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Query query = session.createQuery(queryString);
            List<T> pojos = query.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

    /**
     * 查询所有记录，排序输出
     */
    @SuppressWarnings("unchecked")
    public List<T> findAllWithOrder(String sort, String order) {
        try {
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            Criteria criteria = session.createCriteria(typeClass());
            if (order != null && order.equals("asc") && sort != null) {
                criteria.addOrder(Order.asc(sort));
            }
            if (order != null && order.equals("desc") && sort != null) {
                criteria.addOrder(Order.desc(sort));
            }
            List<T> pojos = criteria.list();
            session.getTransaction().commit();
            return pojos;
        } catch (RuntimeException re) {
            throw re;
        }
    }

}
