function getExp() {
	var select_teacherId = document.getElementById("teacherId");
	var select_expId = document.getElementById("expId");
	var select_retailerId = document.getElementById("retailerId");

	select_retailerId.innerHTML = "";
	select_retailerId.options.add(new Option("请先选择实验", "0"));

	if (select_teacherId.value == 0) {
		select_expId.innerHTML = "";
		select_expId.options.add(new Option("请先选择教师", "0"));
	} else {
		select_expId.innerHTML = "";
		select_expId.options.add(new Option("请稍后...", "0"));
		// 获取教师所创建的实验
		send_request("GET", basePath
				+ "studentpage/login_ajax.jsp?action=getExp&teacherId="
				+ select_teacherId.value + "&time=" + Math.random(), null,
				"text", pushData);
	}
}

function getExperimentType() {
	var select_experiment_type = document.getElementById("experimentType");
	if (select_experiment_type.value == "-1") {
		// select_experiment_type.innerHTML = "";
		// select_experiment_type.options.add(new Option("请先选择实验种类", "-1"));
	} else {
		send_request("GET", basePath
				+ "studentpage/login_ajax.jsp?action=getExperimentType"
				+ "&experimentType=" + select_experiment_type.value + "&time="
				+ Math.random(), null, "text", pushData);
	}

}
function getRetailer() {
	var experimentType = document.getElementById("experimentType").value;

	if (experimentType == "game") {
		var select_expId = document.getElementById("expId");
		var select_retailerId = document.getElementById("retailerId");

		if (select_expId.value == 0) {
			select_retailerId.innerHTML = "";
			select_retailerId.options.add(new Option("请先选择实验名称", "0"));
		} else {
			select_retailerId.innerHTML = "";
			select_retailerId.options.add(new Option("请稍后...", "0"));
			// 获取该实验的retailer
			send_request("GET", basePath
					+ "studentpage/login_ajax.jsp?action=getRetailer&expId="
					+ select_expId.value + "&experimentType=" + experimentType
					+ "&time=" + Math.random(), null, "text", pushData);
		}
	} else if (experimentType == "bargain") {
		var select_expId = document.getElementById("expId");
		var select_retailerId = document.getElementById("retailerId");

		if (select_expId.value == 0) {
			select_retailerId.innerHTML = "";
			select_retailerId.options.add(new Option("请先选择实验名称", "0"));
		} else {
			select_retailerId.innerHTML = "";
			select_retailerId.options.add(new Option("请稍后...", "0"));
			// 获取该实验的参与者
			send_request(
					"GET",
					basePath
							+ "studentpage/login_ajax.jsp?action=getBargainParticipants&expId="
							+ select_expId.value + "&experimentType="
							+ experimentType + "&time=" + Math.random(), null,
					"text", pushData);
		}
	}
}

function submitform() {
	var select_expId = document.getElementById("expId");
	var select_retailerId = document.getElementById("retailerId");
	var select_experiment_type = document.getElementById("experimentType");

	var password = document.getElementById("password");

	if (select_experiment_type.value == -1) {
		alert("请先选择实验类型！");
		return;
	}
	if (select_expId.value == 0) {
		alert("请先选择实验！");
		return;
	}
	if (select_retailerId.value == 0) {
		alert("请先选择零售商！");
		return;
	}
	send_request("GET", basePath
			+ "studentpage/login_ajax.jsp?action=login&expId="
			+ select_expId.value + "&retailerId=" + select_retailerId.value
			+ "&experimentType=" + select_experiment_type.value + "&password="
			+ password.value + "&time=" + Math.random(), null, "text", pushData);
}

// 处理键盘事件
function enterHandler(event) {
	// 定义键盘中发出事件的键
	var keyCode = event.keyCode ? event.keyCode : event.which ? event.which
			: evernt.charCode;
	// 回车键的代码为13，如果按下了回车键
	if (keyCode == 13) {
		var select_expId = document.getElementById("expId");
		var select_retailerId = document.getElementById("retailerId");
		if ((select_expId.value == 0) || (select_retailerId.value == 0)) {
			return;
		} else {
			submitform();
		}
	}
}

function pushData() {
	if (http_request.readyState == 4) { // 判断对象状态
		if (http_request.status == 200) { // 信息已经成功返回，开始处理信息
			try {
				var returnObj = eval("(" + http_request.responseText + ")");
				var action = returnObj.action;
				if (action == "getExp") {
					var select_expId = document.getElementById("expId");
					select_expId.innerHTML = "";

					var exps = returnObj.exps;
					if (exps.length == 0) {
						select_expId.options.add(new Option("该教师没有创建实验", "0"));
					} else {
						select_expId.options.add(new Option("请选择实验", "0"));
					}

					for (var i = 0; i < exps.length; i++) {
						select_expId.options.add(new Option(exps[i].name,
								exps[i].id));
					}
				} else if (action == "getRetailer") {
					var select_retailerId = document
							.getElementById("retailerId");
					select_retailerId.innerHTML = "";

					var retailers = returnObj.retailers;
					if (retailers.length == 0) {
						select_retailerId.options.add(new Option("该实验没有零售商",
								"0"));
					} else {
						select_retailerId.options
								.add(new Option("请选择零售商", "0"));
					}

					for (var i = 0; i < retailers.length; i++) {
						select_retailerId.options.add(new Option(
								retailers[i].name, retailers[i].id));
					}
				} else if (action == "getBargainParticipants") {
					var select_retailerId = document
							.getElementById("retailerId");
					select_retailerId.innerHTML = "";

					var participants = returnObj.participants;
					if (participants.length == 0) {
						select_retailerId.options.add(new Option("该实验没有参与者",
								"0"));
					} else {
						select_retailerId.options
								.add(new Option("请选择参与者", "0"));
					}

					for (var i = 0; i < participants.length; i++) {
						select_retailerId.options.add(new Option(
								participants[i].name, participants[i].id));
					}
				} else if (action == "getExperimentType") {// 实验类型发生改变
					var select_expId = document.getElementById("expId");
					select_expId.innerHTML = "";

					var experiments = returnObj.experiments;
					if (experiments.length == 0) {
						select_expId.options.add(new Option("没有创建实验", "0"));
					} else {
						select_expId.options.add(new Option("请选择实验名称", "0"));
					}

					for (var i = 0; i < experiments.length; i++) {
						select_expId.options.add(new Option(
								experiments[i].name, experiments[i].id));
					}

				} else if (action == "login") {
					var loginstatus = returnObj.loginstatus;
					var experimentType = returnObj.experimentType;
					if (loginstatus == "success") {
						
						if(experimentType == "game"){//博弈
							window.location.href = basePath + "servlet/transform";
							return;
						}
						if(experimentType == "bargain"){//谈判
							window.location.href = basePath + "servlet/bargainTransform";
							return;
						}
					} else {
						alert(loginstatus);
					}
				} else {
					alert("出现未定义action！");
				}
			} catch (e) {
				alert(http_request.responseText);
			}
		} else { // 页面不正常
			alert("您所请求的页面有异常。或者服务器连接失败，请检查网络是否连接！");
		}
	}
}