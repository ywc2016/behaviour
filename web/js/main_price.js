function submitform(){
	var price= document.getElementById("price").value;
	var filter=/^\d+$/;	
	if (!filter.exec(price)){
		alert(" ");
		return;
	}
	send_request("GET",basePath+"studentpage/main_price_ajax.jsp?action=price&price="+price+"&time="+ Math.random(),null,"text",pushData);
}

function timer()
{
	send_request("GET",basePath+"studentpage/main_price_ajax.jsp?action=timer&time="+ Math.random(),null,"text",pushData);
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
						window.location.href=basePath+"servlet/transform";
					}else if(status=="unfinished"){
						var remainingTime=returnObj.remainingTime;
						var obj= document.getElementById("timer");
			 			obj.innerHTML= Trim(remainingTime);
					}else if(status=="updating"){
						var obj= document.getElementById("timer");
			 			obj.innerHTML= " ";
					}else{
						alert(status);
					}			
				}else if(action=="price"){
					var status=returnObj.status;
	 				if(status=="success"){
						window.location.href=basePath+"servlet/transform";
	 				}else{
	 					alert(loginstatus);
	 				}
				}else{
					alert(" ");
				}
			} catch (e) {
				alert(http_request.responseText);
			}			
		}else { //页面不正常
			alert(" ");
		}
	}
}