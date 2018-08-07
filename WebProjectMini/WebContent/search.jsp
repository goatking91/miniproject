<%@ page language="java" contentType="text/html; charset=UTF-8"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="./css/theme.min.css">
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<script src="./js/auth.js"></script>
	<script src="./js/search.js"></script>
	<script src="https://apis.google.com/js/client.js?onload=googleApiClientReady"></script>
	<title>Search</title>
	
</head>
<body>

<jsp:include page="Header.jsp">
	<jsp:param value="" name=""/>
	</jsp:include>
<div class="container">
	<div class="row">
		<div class="col-xs-1">
		</div>
		<div class="col-xs-9">
		<input class="form-control input-lg" id="query" value='' type="text">
		</div>
		<div class="col-xs-2">
		<button class="btn btn-primary btn-lg" id="search-button" onkeydown="deletea();" onclick="search();">Search</button>
		</div>
	</div>
	<br>
	<div class="row">
		<div class="col-xs-9"></div>
		<div class="col-xs-3">
			<button class="btn btn-default btn-xs" id="default-thumbnail-btn" onkeydown="deletea();" onclick="sizeThumnail('s');">small</button> &nbsp;
			<button class="btn btn-default btn-xs" id="medium-thumbnail-btn" onkeydown="deletea();" onclick="sizeThumnail('m');">medium</button> &nbsp;
			<button class="btn btn-default btn-xs" id="default-thumbnail-btn" onkeydown="deletea();" onclick="sizeThumnail('h');">large</button> &nbsp;
		</div>
	</div>
	<br>
</div>
<div class="container">
	<div id="place"></div>
</div>
<jsp:include page="Footer.jsp">
	<jsp:param value="" name=""/>
	</jsp:include>
</body>
</html>