
function timer() {
	send_request("GET", basePath + "studentpage/waiting_order_ajax.jsp?action=timer&time=" + Math.random(), null, "text", pushData);
	//每1秒刷新一次页面
	setTimeout("timer()", 1000);
}
function pushData() {
	if (http_request.readyState == 4) { // 判断对象状态
		if (http_request.status == 200) { // 信息已经成功返回，开始处理信息		
			try {
				var returnObj = eval("(" + http_request.responseText + ")");
				var action = returnObj.action;
				if (action == "timer") {
					var status = returnObj.status;
					if (status == "finished") {
						window.location.href = basePath + "servlet/transform";
					} else {
						if (status == "unfinished") {
							var obj = document.getElementById("timer");
							var remainingTime = returnObj.remainingTime;
							obj.innerHTML = Trim(remainingTime);
							obj = document.getElementById("waitingRetailers");
							var remainingRetailers = returnObj.remainingRetailers;
							obj.innerHTML = Trim(remainingRetailers);
						} else {
							if (status == "updating") {
								var obj = document.getElementById("timer");
								obj.innerHTML = "\xe6\xa3\xe5\x9c\xa8\xe6\x9b\xb4\xe6\x96\xb0\xe6\x9c\xac\xe5\x91\xa8\xe6\x9c\x9f\xe6\x95\xb0\xe6\x8d\xae\xef\xbc\x8c\xe8\xaf\xb7\xe7\xa8\x8d\xe5\x80\x99...";
								obj = document.getElementById("waitingRetailers");
								obj.innerHTML = "";
							}
						}
					}
				} else {
					alert("\xe5\x87\xba\xe7\x8e\xb0\xe6\x9c\xaa\xe5\xae\x9a\xe4\xb9\x89action\xef\xbc\x81");
				}
			}
			catch (e) {
				alert(http_request.responseText);
			}
		} else { //页面不正常
			alert("\xe6\x82\xa8\xe6\x89\x80\xe8\xaf\xb7\xe6\xb1\x82\xe7\x9a\x84\xe9\xa1\xb5\xe9\x9d\xa2\xe6\x9c\x89\xe5\xbc\x82\xe5\xb8\xb8\xe3\x80\x82\xe6\x88\x96\xe8\x80\x85\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe8\xbf\x9e\xe6\x8e\xa5\xe5\xa4\xb1\xe8\xb4\xa5\xef\xbc\x8c\xe8\xaf\xb7\xe6\xa3\x80\xe6\x9f\xa5\xe7\xbd\x91\xe7\xbb\x9c\xe6\x98\xaf\xe5\x90\xa6\xe8\xbf\x9e\xe6\x8e\xa5\xef\xbc\x81");
		}
	}
}

