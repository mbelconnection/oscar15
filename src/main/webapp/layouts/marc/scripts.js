
# patient documents page
$(document).ready(function() {
	$("#selectAllLink").live("click", function() {
		$("#patientDocumentsTable input:checkbox:not(:disabled)").attr("checked", "checked");
	});
});
