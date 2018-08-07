<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="ssi.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

	<link rel="stylesheet" type="text/css" href="./css/theme.min.css">
	<script src="http://maps.googleapis.com/maps/api/js"></script>
 
	<script type="text/javascript">
		function initialize()
		{
			var point = new google.maps.LatLng(37.494590, 127.027588);
			
		  var mapProp = {
		    center : point,
		    zoom :17,
		    mapTypeId : google.maps.MapTypeId.ROADMAP
		  };
		  
		  var map = new google.maps.Map(document.getElementById("googleMap"), mapProp);
		  
		  var marker = new google.maps.Marker({
			  map : mapProp,
			  position : new google.maps.LatLng(37.494590, 127.027588),
			  title : "bit"
		  });  
		}
		 
		google.maps.event.addDomListener(window, 'load', initialize);
	</script>
	<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyD7QKjqiK9xkJIQnCVS8GA9KQVEjhtsayY"></script>
	<title>Banana</title>
</head>
<body>
	<jsp:include page="./Header.jsp"></jsp:include>
<form name="myform" method="post">
	<div class="container">
		<div class="row">
			<div class="col-3"></div>
				<div class="col-6" align="center">
					<h1 class="display-3" style="text-align:center;margin-top:50px;margin-bottom:50px;"><b>BANANA</b></h1>
					<img src="./images/banana2.jpg" class="img-thumbnail img-circle" height="376" width="564">
	    		<p class="lead" style="text-align:center; margin-top:50px;margin-bottom:50px">Welcome to visit our project:)</p>
	   			<div class="col-3"></div>
				</div>
		</div>
	</div>
	
    <div class="display-3 text-center">
      <h3><strong>Contact Us</strong></h3>
    </div>
	    
	<div class="container">
	    <div class="row">
		    <div class="col-3"></div>
		    <div class="col-6" align="center" id="googleMap" style="width:100%;height:600px;"></div>
			<div class="col-3"></div>
	    </div>
	</div> <!-- /container -->
</form>
	<jsp:include page="./Footer.jsp"></jsp:include>
</body>
</html>