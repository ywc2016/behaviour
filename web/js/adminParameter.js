var content = "";

function addPar(parName) {
	var a_par = document.getElementById(parName);
	var reg = new RegExp(a_par.check);
	if (reg.test(a_par.value)) {
		content += "&" + parName + "=" + a_par.value;
		return true;
	} else {
		// 验证不通过,弹出提示warning
		alert(a_par.warning);
		// 该表单元素取得焦点,用通用返回函数
		a_par.focus();
		return false;
	}
}

function addNew() {
	try {
		content = "action=addNew";

		if (!addPar("a_name"))
			return false;
		if (!addPar("a_distributionScheme"))
			return false;
		if (!addPar("a_numberofRetailer"))
			return false;
		if (!addPar("a_totalCycle"))
			return false;
		if (!addPar("a_cycleTime"))
			return false;
		if (!addPar("a_infoDegree"))
			return false;
		if (!addPar("a_initialPurchasePrice"))
			return false;
		if (!addPar("a_initialSellingPrice"))
			return false;
		if (!addPar("a_dcinitialInventory"))
			return false;
		if (!addPar("a_demand"))
			return false;

		document.getElementById("addNewconfirm").disabled = "disabled";

		send_request("POST", basePath + "adminpage/adminParameter_ajax.jsp?",
			content, "text", pushData);
	} catch (e) {
		alert(e.name + ": " + e.message);
	}
}

function deleteitem(id, type) {
	try {
		if (confirm("确定要删除该组实验参数？") == true) {
			var content = "action=delete";
			content += "&deleteid=" + id;
			send_request("POST", basePath
			+ "adminpage/adminParameter_ajax.jsp?", "experimentType=" + type + "&" + content, "text",
				pushData);
		} else {
			return;
		}
	} catch (e) {
		alert(e.name + ": " + e.message);
	}
}

function onadd() {
	// 显示隐藏的添加div
	var a = document.getElementById("view");
	// a.style.display='none';
	a = document.getElementById("addNew");
	a.style.display = 'block';
}

function onview(id) {
	// 显示隐藏的查看实验参数的div，并将当前选中的实验参数信息填到div中
	var checkedvalue = document.getElementById("checkeditem" + id).value;

	var checkedvalues = checkedvalue.split("$");
	if (checkedvalues.length == 17) {
		document.getElementById("v_id").value = checkedvalues[0];
		document.getElementById("v_name").value = checkedvalues[1];
		document.getElementById("v_distributionScheme").value = checkedvalues[2];
		document.getElementById("v_numberofRetailer").value = checkedvalues[3];
		document.getElementById("v_totalCycle").value = checkedvalues[4];
		document.getElementById("v_dcinitialInventory").value = checkedvalues[5];
		document.getElementById("v_initialPurchasePrice").value = checkedvalues[6];
		document.getElementById("v_cycleTime").value = checkedvalues[7];
		document.getElementById("v_demand").value = checkedvalues[8];
		document.getElementById("v_infoDegree").value = checkedvalues[9];
		document.getElementById("v_initialSellingPrice").value = checkedvalues[10];

		// 显示隐藏div
		a = document.getElementById("addNew");
		// a.style.display='none';
		a = document.getElementById("view");
		a.style.dispaly = 'block';
	}
}

function pushData() {
	if (http_request.readyState == 4) { // 判断对象状态
		if (http_request.status == 200) { // 信息已经成功返回，开始处理信息

			var responseText = Trim(http_request.responseText);
			if ((responseText != null) && (responseText != "")) {
				if (responseText == "addsuccess") {
					alert("添加成功!");
					window.location.href = window.location.href;
				} else if (responseText == "deletesuccess") {
					alert("删除成功");
					window.location.href = window.location.href;
				} else {
					alert(responseText);
					document.getElementById("addNewconfirm").disabled = "";
				}
			} else {
				alert("添加失败!");
				document.getElementById("addNewconfirm").disabled = "";
			}
		}
	}
}

function changeType() {
	var obj = document.getElementById("experimentType");
	var index = obj.selectedIndex;
	var text = obj.options[index].value;
	location.href = basePath + "adminpage/adminParameter.jsp?experimentType="
		+ text;
}

function addNewBargainParameter() {
	try {
		content = "action=addNewBargainParameter";

		if (!addPar("a_name")) {
			return false;
		}
		if (!addPar("a_numberOfPerson")) {
			return false;
		}
		if (!addPar("a_cycleTime")) {
			return false;
		}
		//		if (!addPar("MA")) {
		//			return false;
		//		}
		//		if (!addPar("MB")) {
		//			return false;
		//		}
		if (!addPar("k")) {
			return false;
		}
		if (!addPar("c")) {
			return false;
		}
		if (!addPar("a")) {
			return false;
		}
		if (!addPar("b")) {
			return false;
		}
		if (!addPar("p")) {
			return false;
		}
        if (!addPar("oneRoundTime")) {
            return false;
        }

		document.getElementById("addNewconfirm").disabled = "disabled";

		send_request("POST", basePath + "adminpage/adminParameter_ajax.jsp?",
			content, "text", pushData);
	} catch (e) {
		alert(e.name + ": " + e.message);
	}
}