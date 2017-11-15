function orderby(orderby_name){
	document.getElementById("action").value="order";
	document.getElementById("orderby").value=orderby_name;					
	document.form1.submit();
}

function pager(pagerAction){
	document.getElementById("action").value="pager";
	document.getElementById("pagerAction").value=pagerAction;
	document.form1.submit();
}

function timer()
{
	send_request("GET",basePath+"studentpage/historyData_ajax.jsp?action=timer&time="+ Math.random(),null,"text",pushData);
	//每1秒刷新一次页面
	setTimeout("timer()", 1000);
}

function pushData() {
	if (http_request.readyState == 4) { // 判断对象状态
		if (http_request.status == 200) { // 信息已经成功返回，开始处理信息		
			try {
				var returnObj = eval("("+http_request.responseText+")");
				var action = returnObj.action;			
				if(action=="timer"){
					var status=returnObj.status;					
					if(status=="finished"){
						window.location.href=basePath+"servlet/transform"
					}else if(status=="unfinished"){
						var remainingTime=returnObj.remainingTime;
						var obj= document.getElementById("timer");
			 			obj.innerHTML= Trim(remainingTime);
					}else if(status=="updating"){
						var obj= document.getElementById("timer");
			 			obj.innerHTML= "正在更新本周期数据，请稍候...";
					}else{
						alert(status);
					}
				}else{
					alert("出现未定义action！");
				}
			} catch (e) {
				alert(http_request.responseText);
			}			
		}else { //页面不正常
			alert("您所请求的页面有异常。或者服务器连接失败，请检查网络是否连接！");
		}
	}
}