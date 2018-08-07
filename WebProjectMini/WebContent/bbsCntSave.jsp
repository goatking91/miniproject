<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsCntSave.jsp]</title>
</head>
<body>
<%
int iCnt = 0; // 조회수
%>

<%	try
	{
		Gbnum = Integer.parseInt(request.getParameter("num"));
	
		msg = "";
		msg = msg + " select (nvl(max(b_cnt), 0) + 1) as CNT  " + "\n";
		msg = msg + "   from bbs  " + "\n";
		msg = msg + "  where b_num = " + Gbnum + "\n";
		
		System.out.println("쿼리1 : " + msg);
		
		ST = CN.createStatement();
		RS = ST.executeQuery(msg);
		while(RS.next() == true) { iCnt = RS.getInt("CNT"); }
		
		msg = "";
		msg = msg + " update bbs " + "\n";
		msg = msg + "   set   b_cnt = ? " + "\n";
		msg = msg + "  where b_num = " + Gbnum + "\n";

		System.out.println("쿼리2 : " + msg);
		
		PST = CN.prepareStatement(msg);
		PST.setInt(1, iCnt);
		PST.executeUpdate();
		
		System.out.println("조회수 증가처리 성공");
		response.sendRedirect("bbsDetail.jsp?num=" + Gbnum); //response내장개체 문서이동
		
	}catch(Exception ex) { System.out.println(ex.toString()); }
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