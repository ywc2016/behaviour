package ielab.util;

import ielab.hibernate.DAO;
import ielab.hibernate.DcData;
import ielab.hibernate.DcExperiments;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.plot.DatasetRenderingOrder;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYBarRenderer;
import org.jfree.data.xy.IntervalXYDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

public class DisplayChart_R_NetIncome extends HttpServlet {
	private static final String CONTENT_TYPE = "text/html; charset=GBK";
	private String expId=null;
	private String retailerId="";
	
	DcExperiments exp=new DcExperiments();
	private ArrayList<DcData> list_history=null;
	private ArrayList<DcExperiments> list_exp=null;

	// Initialize global variables
	public void init() throws ServletException {
	}

	// service
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException,
			IOException {

		if (StringUtils.isNotEmpty(req.getParameter("expId"))
				&& StringUtils.isNotEmpty(req.getParameter("retailerId"))) {
			expId = req.getParameter("expId");
			retailerId = req.getParameter("retailerId");
		} else {
			return;
		}
		DAO DAO=new DAO();
		//取得画图的所有数据
		String strsql="from DcExperiments where id="+expId;
		list_exp=DAO.selectByHOL(strsql);
		if (list_exp.size() == 1){
			exp=list_exp.get(0);
		}else{
			return;
		}
		
		strsql = " from DcData as model where model.dcExperiments.id=" + expId + " and model.retailerId=" +retailerId+" and model.tag=2";
		list_history= DAO.selectByHOL(strsql);
		if (list_history.size() == 0){
			return;
		}else{
			//System.out.println(list.size());
		}
		
		JFreeChart chart = createChart();

		ChartUtilities.writeChartAsJPEG(res.getOutputStream(), 0.9f, chart, 988, 300, null);

	}

	private JFreeChart createChart() {

		// 定义横坐标
		NumberAxis Xaxis = new NumberAxis("");
		Xaxis.setTickUnit(new NumberTickUnit(exp.getDcParameters().getTotalCycle()/20));
		Xaxis.setAutoRange(true);
		Xaxis.setLowerBound(0);
		Xaxis.setUpperBound(exp.getDcParameters().getTotalCycle());

		// 定义数据坐标，即纵坐标
		NumberAxis Yaxis = new NumberAxis("");

		// 定义数据集和renderer
		IntervalXYDataset intervalxydataset = createDataset1();
		XYBarRenderer xybarrenderer = new XYBarRenderer(0.3);
		//XYBarRenderer xybarrenderer = new XYBarRenderer();
		
		// 第一个图，Barchart
		XYPlot xyplot = new XYPlot(intervalxydataset, Xaxis, Yaxis, xybarrenderer);

		// 设置xyplot格式
		xyplot.mapDatasetToRangeAxis(2, 1);
		xyplot.setDatasetRenderingOrder(DatasetRenderingOrder.FORWARD);
		xyplot.setOrientation(PlotOrientation.VERTICAL);

		return new JFreeChart("零售商"+retailerId+"各期净收益图", JFreeChart.DEFAULT_TITLE_FONT,
				xyplot, true);
	}

	private IntervalXYDataset createDataset1() {
		IntervalXYDataset intervalxydataset1 = null;
		XYSeries xyseries1 = new XYSeries("各期净收益");
		double x = 0, y = 0;
		for (DcData d : list_history) {
			x = d.getCycle();
			y = d.getNetIncome();
			xyseries1.add(x, y);
		}
		intervalxydataset1 = new XYSeriesCollection(xyseries1);
		return intervalxydataset1;
	}
	
	// Clean up resources
	public void destroy() {
	}
}
