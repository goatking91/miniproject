<%@page import="com.sun.swing.internal.plaf.metal.resources.metal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  %>
<%@ include file="ssi.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title> [loginCheck.jsp] </title>
</head>
<body>
	<!-- <font size=7> <b> [loginCheck.jsp] </b></font> <p> -->
	<!-- loginCheck.jsp단독실행하면 에러발생 -->
<%
	String userid = "";
	String userpw = "";
	int cnt_id = 0;
%>
<%
	try
	{
		if(request.getParameter("userid") != null && request.getParameter("userid") != "")
		{
			Gid = Integer.parseInt(request.getParameter("userid"));
			
			userid = request.getParameter("userid");
			userpw = request.getParameter("pwd");
	
			// 존재여부만 확인 가능.
			msg = "";
			msg = msg + " select count(*) as cnt " + "\n";
			msg = msg + "   from userinfo " + "\n";
			msg = msg + "  where u_id = ? and u_pwd = ? " + "\n";
			
			System.out.println(msg);
			//System.out.println(userid + " | " + userpw);
	
			PST = CN.prepareStatement(msg);
			PST.setString(1, userid);
			PST.setString(2, userpw);
	
			RS = PST.executeQuery(); //executeUpdate( )==>insert,delete,update
	
			while(RS.next()) { cnt_id = RS.getInt("cnt"); }
	
			if(cnt_id > 0)
			{
				session.setAttribute("userid", userid);
				System.out.println("session.setAttribute(userid, usera)아이디=" + userid);
				response.sendRedirect("bbsList.jsp");
			}
			else
			{
				out.println("<script type='text/javascript'>");
				out.println("	alert('아이디 또는 패스워드를 확인하세요.');");
				out.println("	location.href = 'index.jsp';");
				out.println("</script>");
			}
		}
		else { response.sendRedirect("index.jsp"); }
	}
	catch(Exception ex) { System.out.println("login 체크 오류 : " + ex.toString()); }
	finally
	{
		if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
		if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
		if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
	}
%>
</body>
</html>
