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
	<title>[userInputSave.jsp]</title>
</head>
<body>
	<font color="blue"> userInputSave.jsp </font><p>
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
	request.setCharacterEncoding("UTF-8");

	try
	{
		// 회원정보 저장
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
		
		
		if(nicknameYN == null)
		{
			nicknameYN = "N";
		}
		else { nicknameYN = "Y"; }
		
		// 5. 쿼리 인서트/업데이트 - Prepare Statement 방식
		msg = "";
		msg = msg + " insert into userInfo " + "\n";
		msg = msg + " values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, sysdate ) " + "\n";

		System.out.println("Prepare Statement 쿼리 : " + msg);
		
		PST = CN.prepareStatement(msg); // Prepared Statement => sql쿼리 미리 해석 => 알맹이 없는 상태.
		PST.setInt(1, Gid); //u_id number(4) not null PRIMARY KEY,    -- 아이디(PK)
		PST.setString(2, Gname); //u_name varchar2(100) not null,          -- 이름
		PST.setString(3, pwd); //u_pwd varchar2(100) not null,           -- 비밀번호
		PST.setInt(4, postcd); //u_postcode number(5) not null,          -- 우편번호(5자리)
		PST.setString(5, juso1); //u_juso1 varchar2(100) not null,         -- 주소1(우편번호 종속)
		PST.setString(6, juso2); //u_juso2 varchar2(100) not null,         -- 주소2(사용자입력주소)
		PST.setString(7, phone); //u_phone varchar2(20) not null,          -- 핸드폰번호(xxx-xxxx-xxxx)
		PST.setString(8, email); //u_email varchar2(50) not null,          -- 이메일(xxx@xxx.xxx)
		PST.setString(9, Gnickname); //u_nickname varchar2(30) null,           -- 닉네임
		PST.setString(10, nicknameYN); //u_nicknameYN VARCHAR2(1) default 'N',   -- 닉네임 사용구분(이름(N)/닉네임(Y) 선택 - 기본값:이름)
		
		PST.executeUpdate(); // 쿼리문을 위에서 넣었기 때문에 안 넣어도 됨.
		
		System.out.println("Prepare Statement user데이터 저장 성공"); //"user테이블 데이터 수정저장 성공"
		response.sendRedirect("index.jsp"); //response내장개체 문서이동
	}
	catch(Exception ex) 
	{ 
		System.out.println("Prepare Statement user데이터 저장 실패 : " + ex); //user테이블 데이터 수정저장 실패
		response.sendRedirect("index.jsp");
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