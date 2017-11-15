package ielab.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.*;
import ielab.hibernate.HibernateSessionFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CloseSessionFilter implements Filter {
	Log logger = LogFactory.getLog(this.getClass());
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	protected FilterConfig config;
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		this.config = arg0;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	public void doFilter(
		ServletRequest request,
		ServletResponse response,
		FilterChain chain)
		throws IOException, ServletException {
		// TODO Auto-generated method stub
		try{
			chain.doFilter((HttpServletRequest)request, (HttpServletResponse)response);
		}
		finally{
			try{
				HibernateSessionFactory.commitTransaction();
				//System.out.println("commit ok");
			}catch (Exception e){
				HibernateSessionFactory.rollbackTransaction();
			}finally{
				HibernateSessionFactory.closeSession();
			}   
		}
	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
		this.config = null;
	}

}
