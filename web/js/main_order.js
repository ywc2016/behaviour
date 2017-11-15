function submitform() {
	var order = document.getElementById("order").value;

	if (order > 100) {
		alert("您提交的订单有误，请提交0到100的整数！")
		return;
	}

	var filter = /^\d+$/;
	if (!filter.exec(order)) {
		alert("您提交的订单有误，请提交0到100的整数！");
		return;
	}

	if (confirm("提交订单量：" + order + "\n您确定吗？")) {
		send_request("GET", basePath
				+ "studentpage/main_order_ajax.jsp?action=order&order=" + order
				+ "&time=" + Math.random(), null, "text", pushData);
	} else {
		return;
	}
}

function timer() {
	send_request("GET", basePath
			+ "studentpage/main_order_ajax.jsp?action=timer&time="
			+ Math.random(), null, "text", pushData);
	setTimeout("timer()", 1000);
}

function pushData() {
	if (http_request.readyState == 4) { // �0�2�0�8��0�3�0�2�0�2�0�2�0�4�0�1���0�3�0�4�0�0�0�9�0�3�0�0�0�1
		if (http_request.status == 200) { // �0�1�0�7�0�3�0�3�0�1�0�4�0�2���0�5�0�4�0�3�0�5�0�3�0�8�0�6�0�2�0�0�0�1���0�7�0�0�0�2�0�7�0�0�0�7�0�4�0�2�0�2�0�4�0�0�0�2��0�1�0�2��0�4�0�4�0�6�0�6�0�1�0�7�0�3�0�3�0�1�0�4
			try {
				var returnObj = eval("(" + http_request.responseText + ")");
				var action = returnObj.action;
				if (action == "timer") {
					var status = returnObj.status;
					if (status == "finished") {
						window.location.href = basePath + "servlet/transform"
					} else if (status == "unfinished") {
						var remainingTime = returnObj.remainingTime;
						var obj = document.getElementById("timer");
						obj.innerHTML = Trim(remainingTime);
					} else if (status == "updating") {
						var obj = document.getElementById("timer");
						obj.innerHTML = "";
					} else {
						alert(status);
					}
				} else if (action == "order") {
					var status = returnObj.status;
					if (status == "success") {
						window.location.href = basePath + "servlet/transform"
					} else {
						alert(status);
					}
				} else {
					alert("1");
				}
			} catch (e) {
				alert(http_request.responseText);
			}
		} else { // ���0�3�0�8���0�9�0�4�0�1�0�0�0�3�0�3�0�2�0�5�0�2�0�0�0�0
			alert("2");
		}
	}
}