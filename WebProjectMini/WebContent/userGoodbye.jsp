<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>userGoodbye</title>
	<link rel="stylesheet" href="./css/theme.min.css">
	<script type="text/javascript">
	  	setTimeout("location.href='index.jsp'",5000);
	</script>
</head>
<body>
	<jsp:include page="./Header.jsp"></jsp:include>
<%
if(session.getAttribute("userid") != null)
{
	session.removeAttribute("userid");
}
%>
	<div class="container">
		<div class="row " style="height:300px;margin:250px 0;">
		<div class="col-xs-3"></div>
			<div class="col-xs-6" >
				<h2 style="color:#fce84e;">ȸ��Ż�� �Ϸ�Ǿ����ϴ�</h2>
		
				<h4 style="color:#5f5f5f;">�� ���� �ٳ����� �̿����ּż� ����帳�ϴ�.</h4>
			</div>
			<div class="col-xs-3"></div>
		</div>
	</div>
	<jsp:include page="./Footer.jsp"></jsp:include>
</body>
</html>