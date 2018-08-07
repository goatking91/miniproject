<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[userDeleteSave.jsp]</title>
</head>
<body>
	<font color="blue"> userDeleteSave.jsp </font><p>
	<!--  나중에 단독실행하면 에러발생 -->
<%	try
	{
		Gid = Integer.parseInt(request.getParameter("idx"));

		msg = "delete from userinfo where u_id = " + Gid;
		System.out.print(msg);

		ST = CN.createStatement();
		ST.executeUpdate(msg);

		System.out.println("회원데이터 탈퇴(삭제) 성공");
		response.sendRedirect("userGoodbye.jsp");
	}
	catch(Exception ex) { System.out.println("회원데이터 삭제 실패 : " + ex); }
	finally
	{
		if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
		if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
		if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
		if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
	}
%>
</body>
</html>