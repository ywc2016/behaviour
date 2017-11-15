function deleteitem(id) {
	try {
		if (confirm("确定要删除该实验？\n删除后所有实验数据将不存在！") == true) {
			document.getElementById("deleteconfirm" + id).disabled = "disabled";
			var content = "action=delete";
			content += "&deleteid=" + id;
			send_request("POST", basePath + "adminpage/adminExp_ajax.jsp?",
					content, "text", pushData);
		} else {
			return;
		}
	} catch (e) {
		alert(e.name + ": " + e.message);
	}
}

function onadd() {
	window.location.href = basePath + "adminpage/adminAddNewExp.jsp";
}

function initialexp(id) {
	try {
		if (confirm("确定要重新初始化该实验？\n初始化后已经完成周期的实验数据将不存在！") == true) {
			// document.getElementById("initialexp"+id).disabled="disabled";
			var content = "action=initialexp";
			content += "&expid=" + id;
			send_request("POST", basePath + "adminpage/adminExp_ajax.jsp?",
					content, "text", pushData);
		} else {
			return;
		}
	} catch (e) {
		alert(e.name + ": " + e.message);
	}
}

function pushData() {
	if (http_request.readyState == 4) { // 判断对象状态
		if (http_request.status == 200) { // 信息已经成功返回，开始处理信息

			var responseText = Trim(http_request.responseText);
			if ((responseText != null) && (responseText != "")) {
				if (responseText == "deletesuccess") {
					alert("删除实验成功！");
					window.location.href = window.location.href;
				} else if (responseText == "initialexpsuccess") {
					alert("重新初始化实验成功！");
					// window.location.href=window.location.href;
				} else {
					alert(responseText);
				}
			} else {
				alert("链接服务器失败！");
			}
		}
	}
}

function changeExperimentType() {
	var obj = document.getElementById("experimentType");
	var index = obj.selectedIndex;
	var text = obj.options[index].value;
	location.href = basePath + "adminpage/adminExp.jsp?experimentType="
			+ text;
}