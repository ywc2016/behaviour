window.onload = function () {
    timer();
    $.ajax({
        url: './ajax/getRandomNeeds_ajax.jsp',
        success: function (data1) {
            var json = JSON.parse(data1);
            var data = json.randomNeeds;
            var myChart = echarts.init(document.getElementById('echarts1'));
            var myRegression = ecStat.regression('linear', data);
            $('#mean').html(json.mean);
            $('#standardDeviation').html(json.standardDeviation);
            myRegression.points.sort(function (a, b) {
                return a[0] - b[0];
            });

            option = {
                toolbox: {

                    show: true,

                    feature: {

                        saveAsImage: {

                            show: true,

                            excludeComponents: ['toolbox'],

                            pixelRatio: 2

                        }

                    }

                },

                title: {
                    text: '需求量',
                    subtext: '',
                    sublink: '',
                    left: 'center'
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'cross'
                    }
                },
                xAxis: {
                    type: 'value',
                    splitLine: {
                        lineStyle: {
                            type: 'dashed'
                        }
                    },
                },
                yAxis: {
                    type: 'value',
                    min: 1.5,
                    splitLine: {
                        lineStyle: {
                            type: 'dashed'
                        }
                    },
                },
                series: [{
                    name: 'scatter',
                    type: 'scatter',
                    label: {
                        emphasis: {
                            show: true,
                            position: 'left',
                            textStyle: {
                                color: 'blue',
                                fontSize: 16
                            }
                        }
                    },
                    data: data
                } /*, {
					name : 'line',
					type : 'line',
					showSymbol : false,
					data : myRegression.points,
					markPoint : {
						itemStyle : {
							normal : {
								color : 'transparent'
							}
						},
						label : {
							normal : {
								show : true,
								position : 'left',
								formatter : myRegression.expression,
								textStyle : {
									color : '#333',
									fontSize : 14
								}
							}
						},
						data : [ {
							coord : myRegression.points[myRegression.points.length - 1]
						} ]
					}
				}*/]
            };
            myChart.setOption(option);
        },
        error: function () {
        }
    });
}

function submitform() {
    var price = document.getElementById("price").value;
    var quantity = document.getElementById("quantity").value;

    var reg = /^[0-9]+.?[0-9]*$/;
    if (!reg.test(price) || !reg.test(quantity)) {
        alert("请检查输入!");
        return;
    }

    // if (order > 100) {
    // alert("您提交的订单有误，请提交0到100的整数！")
    // return;
    // }
    //
    // var filter = /^\d+$/;
    // if (!filter.exec(order)) {
    // alert("您提交的订单有误，请提交0到100的整数！");
    // return;
    // }

    if (confirm("提交价格:" + price + "\n数量：" + quantity + "\n您确定吗？")) {
        send_request(
            "GET",
            basePath
            + "studentpage/main_bargain_price_ajax.jsp?action=bargain&price="
            + price + "&quantity=" + quantity + "&time="
            + Math.random(), null, "text", pushData);
    } else {
        return;
    }
}

function timer() {
    send_request("GET", basePath
        + "studentpage/main_bargain_price_ajax.jsp?action=timer&time="
        + Math.random(), null, "text", pushData);
    setTimeout("timer()", 1000);
}

function pushData() {
    if (http_request.readyState == 4) { // �0�2�0�8��0�3�0�2�0�2�0�2�0�4�0�1���0�3�0�4�0�0�0�9�0�3�0�0�0�1
        // console.log("aaa");
        if (http_request.status == 200) { // �0�1�0�7�0�3�0�3�0�1�0�4�0�2���0�5�0�4�0�3�0�5�0�3�0�8�0�6�0�2�0�0�0�1���0�7�0�0�0�2�0�7�0�0�0�7�0�4�0�2�0�2�0�4�0�0�0�2��0�1�0�2��0�4�0�4�0�6�0�6�0�1�0�7�0�3�0�3�0�1�0�4
            try {
                var returnObj = eval("(" + http_request.responseText + ")");
                var action = returnObj.action;
                if (action == "timer") {
                    var status = returnObj.status;
                    if (status == "finished") {
                        window.location.href = basePath + "servlet/transform"
                    } else if (status == '实验已结束') {
                        alert("实验已结束")
                    } else if (status == "离线") {
                        window.location.href = basePath
                            + "servlet/bargainTransform?status=" + status;
                    } else if (status == "空闲中") {
                        window.location.href = basePath
                            + "servlet/bargainTransform?status=" + status;
                    } else if (status == "出价中") {

                    } else if (status == "出价完毕") {
                        window.location.href = basePath
                            + "servlet/bargainTransform?status=" + status;
                    } else if (status == "回应出价") {
                        window.location.href = basePath
                            + "servlet/bargainTransform?status=" + status;
                    } else if (status == "查看结果") {
                        window.location.href = basePath
                            + "servlet/bargainTransform?status=" + status;
                    }
                    var leftSeconds = returnObj.leftSeconds;
                    document.getElementById("timer").innerHTML = "本次谈判剩余时间:" + leftSeconds + "";
                    var leftDecisionSeconds = returnObj.leftDecisionSeconds;
                    document.getElementById("decisionTime").innerHTML = "本次决策剩余时间:" + leftDecisionSeconds + "";

                } else if (action == "bargain") {
                    var status = returnObj.status;
                    if (status == "success") {
                        window.location.href = basePath
                            + "servlet/bargainTransform";
                    } else {
                        alert(status);
                    }
                } else if (action == "reply1") {
                    window.location.href = basePath
                        + "servlet/bargainTransform";
                } else if (action == "reply2") {
                    window.location.href = basePath
                        + "servlet/bargainTransform";
                } else if (action == "reply3") {
                    window.location.href = basePath
                        + "servlet/bargainTransform?status=" + action;
                } else if (action == "finishCheck") {
                    window.location.href = basePath
                        + "servlet/bargainTransform";
                } else if (action == 'tiptools') {
                    document.getElementById('myProfit1').innerText = returnObj.myProfit1;
                    document.getElementById('myProfit2').innerText = returnObj.myProfit2;
                    document.getElementById('oppositeProfit1').innerText = returnObj.oppositeProfit1;
                    document.getElementById('oppositeProfit2').innerText = returnObj.oppositeProfit2;
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
// console.log("a");
}

function reply(i) {
    if (i == 1) { // 接受出价
        send_request("GET", basePath
            + "studentpage/main_bargain_price_ajax.jsp?action=reply1&time="
            + Math.random(), null, "text", pushData);
        return;
    }
    if (i == 2) { // 继续谈判
        send_request("GET", basePath
            + "studentpage/main_bargain_price_ajax.jsp?action=reply2&time="
            + Math.random(), null, "text", pushData);
        return;
    }
    if (i == 3) { // 终止谈判
        send_request("GET", basePath
            + "studentpage/main_bargain_price_ajax.jsp?action=reply3&time="
            + Math.random(), null, "text", pushData);
        return;
    }
}

/**
 * 查看结果完毕
 */
function finishCheck() {
    send_request(
        "GET",
        basePath
        + "studentpage/main_bargain_price_ajax.jsp?action=finishCheck&time="
        + Math.random(), null, "text", pushData);
    return;
}

function inputPriceOrQuantity() {
    var price = document.getElementById("price").value;
    var quantity = document.getElementById("quantity").value;
    if (price != null && price != '' && quantity != null && quantity != '') { //都不为空 计算值
        send_request("GET", basePath + "studentpage/main_bargain_price_ajax.jsp?action=tiptools&price=" + price
            + "&quantity=" + quantity + "&time=" + Math.random(), null, "text", pushData);
    } else {
        document.getElementById('myProfit1').innerText = '';
        document.getElementById('myProfit2').innerText = '';
        document.getElementById('oppositeProfit1').innerText = '';
        document.getElementById('oppositeProfit2').innerText = '';
    }
}