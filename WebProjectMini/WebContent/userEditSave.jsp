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
	<title>[userEditSave.jsp]</title>
	<style type="text/css">
		* { font-size: 20pt; font-weight: bold; }
		a { text-decoration:none; font-size: 20pt; color: red; }
		a:hover { text-decoration:underline; font-size: 26pt; color: green; }
	</style>
</head>
<body>
	<font color="blue"> userEditSave.jsp </font><p>
	<!--  나중에 단독실행하면 에러발생 -->
<%
	String pwd = "";
	int postcd = 0;
	String juso1 = "";
	String juso2 = "";
	String num1 = "";
	String num2 = "";
	String num3 = "";
	String phone = "";
	String email = "";
	String nicknameYN = "";
%>
<%
	try
	{
		// 회원정보 수정
		request.setCharacterEncoding("UTF-8");
		
		Gid = Integer.parseInt(request.getParameter("id")); // 고정 - PK
		Gname = request.getParameter("name");
		pwd = request.getParameter("pwd");
		postcd = Integer.parseInt(request.getParameter("postcode")); //우편번호(5자리)
		juso1 = request.getParameter("juso1"); //주소1(우편번호 종속)
		juso2 = request.getParameter("juso2"); //주소2(사용자입력주소)
		num1 = request.getParameter("num1");
		num2 = request.getParameter("num2");
		num3 = request.getParameter("num3");
		phone = num1 + "-" + num2 + "-" + num3; // 핸드폰번호(xxx-xxxx-xxxx)
		email = request.getParameter("email");
		Gnickname = request.getParameter("nickname");
		nicknameYN = request.getParameter("nicknameYN"); // 닉네임 사용구분(이름(N)/닉네임(Y) 선택 - 기본값:이름(N))

		//System.out.println("nicknameYN : " + nicknameYN);
		
		if(nicknameYN == null) { nicknameYN = "N"; } //체크박스 선택안했을 시 null값, => "N"
		else { nicknameYN = "Y"; }
		
		// 5. 쿼리 인서트/업데이트 - Prepare Statement 방식
		msg = "";
		msg = msg + " update userInfo " + "\n";
		msg = msg + "   set   u_name = ?, u_pwd = ? " + "\n";
		msg = msg + "       , u_postcode = ?, u_juso1 = ?, u_juso2 = ? " + "\n";
		msg = msg + "       , u_phone = ?, u_email = ? " + "\n";
		msg = msg + "       , u_nickname = ?, u_nicknameYN = ? " + "\n";
		msg = msg + "       , u_moddate = sysdate " + "\n";
		msg = msg + "  where u_id = " + Gid + "\n";

		System.out.println("Prepare Statement 쿼리 : " + msg);
		
		PST = CN.prepareStatement(msg); // Prepared Statement => sql쿼리 미리 해석 => 알맹이 없는 상태.
		PST.setString(1, Gname);
		PST.setString(2, pwd);
		PST.setInt(3, postcd);
		PST.setString(4, juso1);
		PST.setString(5, juso2);
		PST.setString(6, phone);
		PST.setString(7, email);
		PST.setString(8, Gnickname);
		PST.setString(9, nicknameYN);
		
		PST.executeUpdate(); // 쿼리문을 위에서 넣었기 때문에 안 넣어도 됨.
		
		System.out.println("Prepare Statement user데이터 수정저장 성공"); //"user테이블 데이터 수정저장 성공"
		response.sendRedirect("userDetail.jsp?idx=" + Gid); //response내장개체 문서이동
	}
	catch(Exception ex) 
	{
		System.out.println("Prepare Statement user데이터 수정저장 실패 : " + ex); //user테이블 데이터 수정저장 실패
		response.sendRedirect("userDetail.jsp?idx=" + Gid);
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