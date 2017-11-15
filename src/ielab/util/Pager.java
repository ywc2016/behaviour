package ielab.util;

/**
 * 
 * Pager holds the page info.
 * 
 */

public class Pager {

	private int totalRows = 0; // 记录总数

	private int totalPages = 0; // 总页数

	private int pageSize = 4000; // 每页显示数据条数，默认为10条记录

	private int currentPage = 1; // 当前页数

	private boolean hasPrevious = false; // 是否有上一页

	private boolean hasNext = false; // 是否有下一页

	public int getSearchFrom() {

		return (currentPage - 1) * pageSize;

	}

	public Pager() {

	}

	/**
	 * 
	 * Initialize Pager
	 * 
	 * @param totalRows
	 *            total record rows
	 * 
	 * @param pageSize
	 *            total record is hold by every page
	 * 
	 */

	public void init(int totalRows) {

		this.totalRows = totalRows;

		this.totalPages = ((totalRows + pageSize) - 1) / pageSize;

		refresh(); // 刷新当前页面信息

	}

	/**
	 * 
	 * @return Returns the currentPage.
	 * 
	 */

	public int getCurrentPage() {

		return currentPage;

	}

	/**
	 * 
	 * @param currentPage
	 *            current page
	 * 
	 */

	public void setCurrentPage(int currentPage) {

		this.currentPage = currentPage;

		refresh();

	}

	/**
	 * 
	 * @return Returns the pageSize.
	 * 
	 */

	public int getPageSize() {

		return pageSize;

	}

	/**
	 * 
	 * @param pageSize
	 *            The pageSize to set.
	 * 
	 */

	public void setPageSize(int pageSize) {

		this.pageSize = pageSize;

		refresh();

	}

	/**
	 * 
	 * @return Returns the totalPages.
	 * 
	 */

	public int getTotalPages() {

		return totalPages;

	}

	/**
	 * 
	 * @param totalPages
	 *            The totalPages to set.
	 * 
	 */

	public void setTotalPages(int totalPages) {

		this.totalPages = totalPages;

		refresh();

	}

	/**
	 * 
	 * @return Returns the totalRows.
	 * 
	 */

	public int getTotalRows() {

		return totalRows;

	}

	/**
	 * 
	 * @param totalRows
	 *            The totalRows to set.
	 * 
	 */

	public void setTotalRows(int totalRows) {

		this.totalRows = totalRows;

		refresh();

	}

	// 跳到第一页

	public void first() {

		currentPage = 1;

		this.setHasPrevious(false);

		refresh();

	}

	// 取得上一页（重新设定当前页面即可）

	public void previous() {

		if (currentPage > 1) {

			currentPage--;

		}

		refresh();

	}

	// 取得下一页

	public void next() {

		//System.out.println("next: totalPages: " + totalPages + " currentPage : " + currentPage);

		if (currentPage < totalPages) {

			currentPage++;

		}

		refresh();

	}

	// 跳到最后一页

	public void last() {

		currentPage = totalPages;

		this.setHasNext(false);

		refresh();

	}

	public boolean isHasNext() {

		return hasNext;

	}

	/**
	 * 
	 * @param hasNext
	 *            The hasNext to set.
	 * 
	 */

	public void setHasNext(boolean hasNext) {

		this.hasNext = hasNext;

	}

	public boolean isHasPrevious() {

		return hasPrevious;

	}

	/**
	 * 
	 * @param hasPrevious
	 *            The hasPrevious to set.
	 * 
	 */

	public void setHasPrevious(boolean hasPrevious) {

		this.hasPrevious = hasPrevious;

	}

	// 刷新当前页面信息

	public void refresh() {

		if (totalPages <= 1) {

			hasPrevious = false;

			hasNext = false;

		} else if (currentPage == 1) {

			hasPrevious = false;

			hasNext = true;

		} else if (currentPage == totalPages) {

			hasPrevious = true;

			hasNext = false;

		} else {

			hasPrevious = true;

			hasNext = true;

		}

	}

}
