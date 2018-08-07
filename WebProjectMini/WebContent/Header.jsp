<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link href="./css/theme.min.css" rel="stylesheet" id="bootstrap-css">
	<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="./js/bootstrap.js"></script>
	
	<script type="text/javascript">
		function idNumCheck() 
		{
			var checkVal = myform.userid.value;
			
			var num_reg = /^[0-9]{4}$/;
			if(num_reg.test(checkVal) == false) 
			{
				alert("아이디는 숫자 4자리만 가능합니다.");
				location.href = "index.jsp";
			}
		}
		
		function logoutCheck() 
		{
			if(confirm("로그아웃하시겠습니까?") == true)
			{
				location.href='logout.jsp';
			}
			else { return false; }
		}
	</script>
</head>
<body>
<%
	String sId = null;
    		
    if(session.getAttribute("userid") != null)
    {
    	sId = String.valueOf(session.getAttribute("userid"));
    }
    else
    {
    	response.sendRedirect("index.jsp");
    }
%>
	<div class="container-fluid">
		<nav class="navbar navbar-default">
	      <div class="container">
	        <!-- Brand and toggle get grouped for better mobile display -->
	        <div class="navbar-header">
	          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-2">
	            <span class="sr-only">Toggle navigation</span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </button>
	          <a class="navbar-brand" href="index.jsp">Home</a>
	        </div>
	    
	        <!-- Collect the nav links, forms, and other content for toggling -->
	        <div class="collapse navbar-collapse" id="navbar-collapse-2">
	          <ul class="nav navbar-nav navbar-right">
	          	<li>
	          	<% 
	         		if(sId!=null && sId!=""){ out.print("<a href='userDetail.jsp?idx="+sId+"'>"+sId+"님 환영합니다.</a>"); }
	        	%>
	         	</li>
	            <li><a href="bbsList.jsp">bbsList</a></li>
	            <li><a href="userList.jsp">userList</a></li>
	            <li><a href="search.jsp">VideoSearch</a></li>
	         <% 
	         if(sId==null || sId==""){ 
	         %>
	            <li>
	              <button class="btn btn-success"  data-toggle="collapse" href="#nav-collapse2" aria-expanded="false" aria-controls="nav-collapse2">Sign in</a>
	            </li>
	          </ul>
	          <div class="collapse nav navbar-nav nav-collapse" id="nav-collapse2">
	            <form class="navbar-form navbar-right form-inline" name="myform" method="post" role="form" action="loginCheck.jsp" onsubmit="idNumCheck(); return false;">
	              <div class="form-group">
	                <label class="sr-only">ID</label>
	                <input type="text" class="form-control" name="userid" id="ID" placeholder="ID" autofocus required />
	              </div>
	              <div class="form-group">
	                <label class="sr-only" for="Password">Password</label>
	                <input type="password" class="form-control"  name="pwd" id="Password" placeholder="Password" required />
	              </div>
	              <button type="submit" class="btn btn-success">Sign in</button>
	              <button type="button" onclick="location.href='userInput.jsp'" name="signup" class="btn btn-default">회원가입</button>
	            </form>
	            </div>
	           <% } else { %>
	            <li>
	              <button class="btn btn-danger" onclick="logoutCheck(); return false;">Log Out</a>
	            </li>
	          </ul>
	           <% } %>
	        </div><!-- /.navbar-collapse -->
	      </div><!-- /.container -->
	    </nav>
	</div>
</body>
</html>