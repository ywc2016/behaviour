package ielab.hibernate;

import java.io.Serializable;
import java.security.interfaces.RSAKey;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.mysql.jdbc.EscapeTokenizer;
import com.mysql.jdbc.Statement;

/**
 * 使用Hibernate编写通用数据库操作代码
 */
public class DAO {
	private static final Log log = LogFactory.getLog(DAO.class);

	public DAO() {
	}

	public Session getSession() {
		// HibernateSessionFactory.beginTransaction();
		// return HibernateSessionFactory.getSession();
		return HibernateSessionFactory.getSessionFactory().getCurrentSession();
	}

	// insert方法
	public void insert(Object o) {
		Session session = getSession();
		session.beginTransaction();
		try {
			session.save(o);
			log.debug("save successful");
		} catch (RuntimeException re) {
			log.error("save failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			session.getTransaction().commit();
		}
		// try {
		// getSession().save(o);
		// log.debug("save successful");
		// } catch (RuntimeException re) {
		// log.error("save failed", re);
		// throw re;
		// }
	}

	// delete方法
	public void delete(Object o, Serializable id) {
		Session session = getSession();
		session.beginTransaction();
		try {

			o = session.get(o.getClass(), id);
			if (o != null) {
				session.delete(o);
			}
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			session.getTransaction().commit();
		}
		// try {
		// o = getSession().get(o.getClass(),id);
		// if(o!=null){
		// getSession().delete(o);
		// }
		// log.debug("delete successful");
		// } catch (RuntimeException re) {
		// log.error("delete failed", re);
		// throw re;
		// }
	}

	// update方法
	public void update(Object o) {
		Session session = getSession();
		session.beginTransaction();
		try {
			session.update(o);
			log.debug("update successful");
		} catch (RuntimeException re) {
			log.error("update failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			session.getTransaction().commit();
		}

		// try {
		// getSession().update(o);
		// log.debug("update successful");
		// } catch (RuntimeException re) {
		// log.error("update failed", re);
		// throw re;
		// }
	}

	// 基于HQL的通用select方法
	public ArrayList selectByHOL(String o) {
		Session session = getSession();
		session.beginTransaction();
		try {
			Query query = session.createQuery(o);
			List list = query.list();
			log.debug("select successful");
			return (ArrayList) list;
		} catch (RuntimeException re) {
			log.error("select failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			session.getTransaction().commit();
		}
	}

	// 基于SQL的通用select方法
	public ArrayList selectBySQL(String sql) throws Exception {
		Session session = getSession();
		session.beginTransaction();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = session.connection();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			Hashtable ht = null;
			ArrayList array = new ArrayList();
			while (rs.next()) {
				ht = new Hashtable();
				for (int i = 0; i < rsmd.getColumnCount(); i++) {
					ht.put(rsmd.getColumnName(i + 1), rs.getObject(i + 1));
				}
				array.add(ht);
			}
			log.debug("select successful");
			return array;
		} catch (RuntimeException re) {
			log.error("select failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			try {
				rs.close();
				pstmt.close();
				con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			session.getTransaction().commit();
		}
	}

	public void executeBySQL(String sql) throws Exception {
		Session session = getSession();
		session.beginTransaction();
		try {
			Connection con = session.connection();
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.executeUpdate();
		} catch (RuntimeException re) {
			log.error("select failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			session.getTransaction().commit();
		}
	}

	// 基于HQL的select方法,用于分页查询
	public ArrayList selectLimitByHOL(String o, int fistR, int MaxR) {
		Session session = getSession();
		session.beginTransaction();
		try {
			Query query = session.createQuery(o);
			query.setFirstResult(fistR);
			query.setMaxResults(MaxR);
			List list = query.list();
			log.debug("select successful");
			return (ArrayList) list;
		} catch (RuntimeException re) {
			log.error("select failed", re);
			session.getTransaction().rollback();
			throw re;
		} finally {
			session.getTransaction().commit();
		}
	}
}
