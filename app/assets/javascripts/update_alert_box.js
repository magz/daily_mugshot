var periodic_upate = function() {
	$.get("/openapis/get_update", function(data) {
		$("#alert_box").replaceWith("<div id='alert_box'>"+ data + "</div>");
	})};
