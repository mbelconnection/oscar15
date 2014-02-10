<script>
	
	
	$(function() {
		var currentTab = 0;
		
		add_app_fn = {
			showTab: function(tab){
				$("#tabs").tabs("option", "active", 2);
			}
		}
		
		$("#tabs").tabs();	
		
		
		$("#btnNext").click(function () {
			$("#tabs").tabs("option", "active", 2);
		});
		
		$("#add_appt_form").dialog({
			autoOpen: false,
			minHeight: 200,
			width: 620,
			modal: true
			
		});
		
		$("#add_appt_form").dialog("open");
	});
</script>

<head>
<title>jQuery UI Tabs - Default functionality</title>

<style>
	.ui-tabs .ui-tabs-nav li.ui-tabs-active {
	margin-bottom: -1px;
	padding-bottom: 1px;
	background-color:#FFFFFF;
}
.ui-tabs .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor,
.ui-tabs .ui-tabs-nav li.ui-state-disabled .ui-tabs-anchor,
.ui-tabs .ui-tabs-nav li.ui-tabs-loading .ui-tabs-anchor {
	cursor: text;
}
.ui-tabs-collapsible .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor {
	cursor: pointer;
}

.test{
	border: 0px!important;
}
</style>


</head>
<body>
<div id="add_appt_form" class="fex_form" style="padding:0px;width:100%">
<div id="tabs" class="test">
    <ul>
        <li><a href="#tabs-1" onclick="add_app_fn.showTab(0)">Nunc tincidunt</a></li>
        <li><a href="#tabs-2">Proin dolor</a></li>
        <li><a href="#tabs-3">Aenean lacinia</a></li>
    </ul>
    <div id="tabs-1">
        Tab 1<br>
		Tab 1<br>
		Tab 1<br>
		Tab 1<br>
		Tab 1<br>
		Tab 1<br>Tab 1<br>
		Tab 1<br>
    </div>
    <div id="tabs-2">
        Tab 2
    </div>
    <div id="tabs-3">
        Tab 3
    </div>
</div>
</div>
</body>