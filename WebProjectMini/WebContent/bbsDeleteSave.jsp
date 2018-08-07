<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsDeleteSave.jsp]</title>
</head>
<body>
	<!-- <font color="blue"> bbsDeleteSave.jsp </font><p> -->
	<!--  나중에 단독실행하면 에러발생 -->
<%
	try
	{
		data = request.getParameter("num");

		msg = "";
		msg = msg + " delete from bbs "; 
		msg = msg + "  where b_num = " + data;

		System.out.println("쿼리 : " + msg);
		
		ST = CN.createStatement(); //명령어 생성.
		ST.executeUpdate(msg); // 진짜 저장처리 - update | delete ==> executeUpdate 사용.
		System.out.println("bbs테이블 데이터 삭제 성공");
		response.sendRedirect("bbsList.jsp"); //response내장개체 문서이동
	}
	catch(Exception ex) 
	{ 
		System.out.println("bbs테이블 데이터 삭제 실패 : " + ex);
		response.sendRedirect("bbsList.jsp");
	}
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