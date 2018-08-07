<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.*"%>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsFileDelete.jsp]</title>
</head>
<body>
	<!--<font color="blue"> bbsFileDelete.jsp </font><p>-->
	<!--  나중에 단독실행하면 에러발생 -->
<%
	String folder = ""; 
	String path = ""; 
	String realfilename = "";
	
	boolean b_result = false;
%>
<%
	try
	{
		// ** 파일삭제
		// 1.1. 파일 경로 추출
		folder = "/storage";
		path = application.getRealPath(folder);

		// 1.2. 파라미터 받아오기.
		Gbnum = Integer.parseInt(request.getParameter("num"));
		Gfilename = request.getParameter("fileName");
		realfilename = request.getParameter("rfileName");
		
		System.out.println(path);
		System.out.println(Gfilename);
		System.out.println(realfilename);
		
		if(Gfilename != null && Gfilename != "" && realfilename != null && realfilename != "")
		{
			// 1.3. 파일 삭제하기.
			File f_old = new File(path + "/" + realfilename);
			b_result = f_old.delete(); // 파일 삭제
		}
		
		if(b_result == true)  //성공하면...
		{
			// 1.4. 쿼리 인서트/업데이트 - Prepare Statement 방식
			msg = "";
			msg = msg + " update  bbs " + "\n";
			msg = msg + "    set  b_filename = '', b_realfilename = '', b_filesize = 0 " + "\n";
			msg = msg + "       , b_moddate = sysdate " + "\n";
			msg = msg + "  where b_num = " + Gbnum + "\n";

			System.out.println("쿼리 : " + msg);
			
			ST = CN.createStatement();
			ST.executeUpdate(msg);
			
			System.out.println("파일 삭제 성공");
			response.sendRedirect("bbsEdit.jsp?num=" + Gbnum); //response내장개체 문서이동
		}
		else
		{
			System.out.println("파일 삭제 실패");
			response.sendRedirect("bbsEdit.jsp?num=" + Gbnum); //response내장개체 문서이동
		}
	}
	catch(Exception ex) 
	{ 
		System.out.println("파일 삭제 실패 : " + ex);
		response.sendRedirect("bbsEdit.jsp?num=" + Gbnum);
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