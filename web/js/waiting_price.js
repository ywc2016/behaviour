function timer()
{
	send_request("GET",basePath+"studentpage/waiting_price_ajax.jsp?action=timer&time="+ Math.random(),null,"text",pushData);
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
						var obj= document.getElementById("timer");
						var remainingTime=returnObj.remainingTime;	
			 			obj.innerHTML= Trim(remainingTime);
			 			
			 			obj= document.getElementById("waitingRetailers");
						var remainingRetailers=returnObj.remainingRetailers;	
			 			obj.innerHTML= Trim(remainingRetailers);
					}else if(status=="updating"){
						var obj= document.getElementById("timer");
			 			obj.innerHTML= " ";
			 			
			 			obj= document.getElementById("waitingRetailers");
			 			obj.innerHTML= "";
					}
				}else{
					alert("出现未定义action！");
				}
			} catch (e) {
				alert(http_request.responseText);
			}			
		}else { //页面不正常
			alert(" ");
		}
	}
}