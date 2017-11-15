package ielab.util;

import ielab.hibernate.DAO;
import ielab.hibernate.DcData;
import ielab.hibernate.DcExperiments;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.Axis;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.labels.StandardCategoryToolTipGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.DatasetRenderingOrder;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.ValueMarker;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.chart.renderer.category.CategoryItemRenderer;
import org.jfree.chart.renderer.category.CategoryStepRenderer;
import org.jfree.chart.renderer.xy.XYBarRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.chart.renderer.xy.XYStepRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.xy.IntervalXYDataset;
import org.jfree.data.xy.XYDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.ui.RectangleAnchor;
import org.jfree.ui.TextAnchor;

public class DisplayChart_R_Total_AllRetailers extends HttpServlet {
	private static final String CONTENT_TYPE = "text/html; charset=GBK";
	private String expId = null;

	DcExperiments exp = new DcExperiments();
	private ArrayList<DcData> list_history = null;
	private ArrayList<DcExperiments> list_exp = null;

	// Initialize global variables
	public void init() throws ServletException {
	}

	// service
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		if (StringUtils.isNotEmpty(req.getParameter("expId"))) {
			expId = req.getParameter("expId");
		} else {
			return;
		}

		// 取得画图对应的实验
		String strsql = "from DcExperiments where id=" + expId;
		DAO DAO=new DAO();
		list_exp = DAO.selectByHOL(strsql);
		if (list_exp.size() == 1) {
			exp = list_exp.get(0);
		} else {
			return;
		}

		JFreeChart chart = createChart();

		ChartUtilities.writeChartAsJPEG(res.getOutputStream(), 0.9f, chart, 988, 300, null);
	}

	private JFreeChart createChart() {

		// 定义横坐标
		NumberAxis Xaxis = new NumberAxis("期数");
		Xaxis.setTickUnit(new NumberTickUnit(exp.getDcParameters().getTotalCycle() / 20));
		Xaxis.setAutoRange(true);
		Xaxis.setLowerBound(0);
		Xaxis.setUpperBound(exp.getDcParameters().getTotalCycle());

		// 定义数据坐标，即纵坐标
		NumberAxis Yaxis = new NumberAxis("总资产");

		// 定义数据集和renderer
		XYDataset xydataset = createDataset1();
		XYLineAndShapeRenderer renderer = new XYLineAndShapeRenderer();
		// XYBarRenderer xybarrenderer = new XYBarRenderer();

		// 第一个图，Barchart
		XYPlot xyplot = new XYPlot(xydataset, Xaxis, Yaxis, renderer);

		// 设置xyplot格式
		xyplot.mapDatasetToRangeAxis(2, 1);
		xyplot.setDatasetRenderingOrder(DatasetRenderingOrder.FORWARD);
		xyplot.setOrientation(PlotOrientation.VERTICAL);

		return new JFreeChart("各零售商总资产走势图", JFreeChart.DEFAULT_TITLE_FONT, xyplot, true);
	}

	private XYDataset createDataset1() {
		XYSeriesCollection xyseriescollection = new XYSeriesCollection();
		for (int i = 1; i <= exp.getDcParameters().getNumberofRetailer(); i++) {
			// 取得画图的所有数据
			String strsql = " from DcData as model where model.dcExperiments.id=" + expId + " and model.retailerId="
					+ i + " and model.tag=2 order by model.cycle";
			DAO DAO=new DAO();
			list_history = DAO.selectByHOL(strsql);
			if (list_history.size() == 0) {
				return xyseriescollection;
			}
			XYSeries xyseries = new XYSeries("零售商" + i);
			double x = 0, y = 0;
			for (DcData d : list_history) {
				x = d.getCycle();
				y = d.getTotal();
				xyseries.add(x, y);
			}
			xyseriescollection.addSeries(xyseries);
		}
		return xyseriescollection;
	}

	// Clean up resources
	public void destroy() {
	}

}
