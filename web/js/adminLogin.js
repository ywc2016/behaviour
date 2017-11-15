function submitform(){
	var username= document.getElementById("username");
	var password= document.getElementById("password");
	if(username.value.length==0){
		alert(" ");
		return;
	}
	var content="action=login";
	content+="&username="+username.value;
	content+="&password="+password.value;
	send_request("POST",basePath+"adminpage/adminLogin_ajax.jsp",content,"text",pushData);
}

//处理键盘事件
function enterHandler(event){
	//定义键盘中发出事件的键
	var keyCode=event.keyCode?event.keyCode:event.which?event.which:evernt.charCode;
	//回车键的代码为13，如果按下了回车键
	if(keyCode==13){
		var username= document.getElementById("username");
		if(Trim(username.value).length==0){
			return;
		}else{
			submitform();
		}
	}
}

function pushData() {
	if (http_request.readyState == 4) { // 判断对象状态
		if (http_request.status == 200) { // 信息已经成功返回，开始处理信息		
			try {
				var returnObj = eval("("+http_request.responseText+")");
				var action = returnObj.action;			
				if(action=="login"){					
					var loginstatus=returnObj.loginstatus;
	 				if(loginstatus=="success"){
						window.location.href=basePath+"adminpage/adminIndex.jsp"
	 				}else{
	 					alert(loginstatus);
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