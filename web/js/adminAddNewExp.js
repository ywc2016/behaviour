/**
 * 改变实验类型
 */
function changeType() {
	var obj = document.getElementById("experimentType");
	var index = obj.selectedIndex;
	var text = obj.options[index].value;
	location.href = basePath+"adminpage/adminAddNewExp.jsp?experimentType=" + text;
}