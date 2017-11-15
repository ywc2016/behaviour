function orderby(orderby_name) {
    document.getElementById("action").value = "order";
    document.getElementById("orderby").value = orderby_name;
    document.form1.submit();
}

function pager(pagerAction) {
    document.getElementById("action").value = "pager";
    document.getElementById("pagerAction").value = pagerAction;
    document.form1.submit();
}

function exportData(experimentId, participantId1) {
    // console.log(experimentId + "  " + participantId1);
    window.open('./adminpage/exportData.jsp?experimentId='
        + experimentId + "&participantId1=" + participantId1);
}

