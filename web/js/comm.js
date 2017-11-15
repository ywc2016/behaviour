function NewWindow(mypage, myname, w, h, scroll){
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',resizable';
		win = window.open(mypage, myname, winprops);
		if (parseInt(navigator.appVersion) >= 4) { 
			win.window.focus();
		 }
}
		
/*
 * 弹出新窗口，并指定弹出窗口的格式
 */		
function popUpWindow(url,w,h){
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var Newwin = window.open(url,'title','width='+w+',height='+h+',left='+winl+', top='+wint+',menubar=no,toolbar=no,directories=no,location=no,scrollbars=yes,status=yes,resizable=no');
		Newwin.focus();
}

function popUpWindow1(url,w,h,t){
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var Newwin = window.open(url,t,'width='+w+',height='+h+',left='+winl+', top='+wint+',menubar=no,toolbar=no,directories=no,location=no,scrollbars=yes,status=yes,resizable=no');
		Newwin.focus();
}

/*
 * 重新设置窗口的大小。在窗口load时设置，并使得窗口自动居中显示
 */
function resizeWindow(w,h){
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		window.moveTo(winl,wint);
		window.resizeTo(w,h);
}


/*
 * 对一组复选框进行全选
 */
 function selectAll(a) {
  var objs =document.getElementsByName(a);
  for(var i=0; i<objs.length; i++) {
    if(objs[i].type.toLowerCase() == "checkbox")
      objs[i].checked = true;
  }
}


/*
 * 对一组复选框取消全选
 */
 function unselectAll(a) {
  var objs =document.getElementsByName(a);
  for(var i=0; i<objs.length; i++) {
    if(objs[i].type.toLowerCase() == "checkbox" )
      objs[i].checked =false; 
  }
}


/*
 * 根据某个复选框，全选或全不选某组复选框
 */
function checkall(a,b){
	var obj=document.getElementById(b);
	if(obj.checked==true){
		selectAll(a);
	}else{
		unselectAll(a);
	}
}


/*
 * 取得一组复选框中选中的值的数目
 */
function GetChoosedNum(name){
	var sValue=0;
	var tmpels=document.getElementsByName(name);
	for(var i=0;i<tmpels.length;i++){
       if(tmpels[i].checked){
       	sValue+=1;
       	}
    }
    return sValue;
}

		
/*
 * 去掉字符串前后的空格
 * 
 */
function trim(str){	
	return str.replace(/(^\s*)|(\s*$)/g,"");

}

/*
 * 格式化数字为两位字符表示
 */
function formatTimeStr(n)
{
	var m=new String();
	var tmp=new String(n);
	if (n<10 && tmp.length<2)
	{
		m="0"+n;
	}
	else
	{
		m=n;
	}
	return m;
}


/*
 * 显示隐藏某控件
 */
function displayhiden(elementid){
	var a=document.getElementById(elementid);
	if(a.style.display=='none'){
		a.style.display='block';
	}else{
		a.style.display='none';
	}
	
	try{
		document.getElementById(elementid+"display").value=a.style.display;
	}catch(e){
		//alert(e.name + ": " + e.message);
	}
}

