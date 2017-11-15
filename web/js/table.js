// JavaScript Document
function selectChangeColor(obj)
{
	if(obj.checked)
	{
		obj.parentNode.parentNode.className="selectBgColor";
	}
	else
	{
		obj.parentNode.parentNode.className="noBgColor";
	}
}

function changeAllColor(eachName, allId)
{
	var obj = document.getElementById(allId);
	var objs = document.getElementsByName(eachName);
	
	if(obj.checked)
	{
		for(i=0; i<objs.length; i++)
			objs[i].parentNode.parentNode.className="selectBgColor";
	}
	else
	{
		for(i=0; i<objs.length; i++)
			objs[i].parentNode.parentNode.className="noBgColor";
	}
}

function mouseOverColor(obj)
{
	obj.className="mouseOverBgColor";
}

function mouseOutColor(obj)
{
	obj.className="noBgColor";
}

/*tab切换效果*/
function twoTabSwap(tab1Id, tab2Id, div1Id, div2Id)
{
	var obj1 = document.getElementById(tab1Id);
	var obj2 = document.getElementById(tab2Id);
	if(obj1.className=="selectedTab" && obj2.className=="unselectedTab")
	{
		selectTab(obj2);
		unselectTab(obj1);
		displayDiv(div2Id);
		hideDiv(div1Id);
	}
	else if(obj2.className=="selectedTab" && obj1.className=="unselectedTab")
	{
		selectTab(obj1);
		unselectTab(obj2);
		displayDiv(div1Id);
		hideDiv(div2Id);
	}
	
}

function selectTab(obj)
{
	obj.className="selectedTab";
}

function unselectTab(obj)
{
	obj.className="unselectedTab";
}

function displayDiv(id)
{
	var obj = document.getElementById(id);
	obj.style.display="block";
}

function hideDiv(id)
{
	var obj = document.getElementById(id);
	obj.style.display="none";
}