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
	<title>[bbsInputSave.jsp]</title>
</head>
<body>
	<font color="blue"> bbsInputSave.jsp </font><p>
	<!--  나중에 단독실행하면 에러발생 -->

<%
	String title = "";
	String content = "";
	String numVal1 = "";
	String numVal2 = "";
	
	int size = 1024*1024*7;
	long fileSize = 0;
	
	String folder = ""; 
	String path = ""; 
	
	String originalPath = "";
	
	int maxNum = 0;
%>
<%
	try
	{
		// 1. 파일업로드
		folder = "/storage";
		path = application.getRealPath(folder);

		MultipartRequest multi = new MultipartRequest(request, path, size, "UTF-8", new DefaultFileRenamePolicy()); // MultipartRequest(요청[request], 경로, 사이즈, 인코딩)

		// 2. 파라미터 받아오기.
		Gid = Integer.parseInt(multi.getParameter("id"));
		title = multi.getParameter("title");
		content = multi.getParameter("content");
		Gfilename = multi.getOriginalFileName("fileName"); //확장자 포함 - // 파일은 "getParameter"가 아닌 "getOriginalFileName"으로 처리.
		//originalPath = request.getContextPath() + folder;
		
		// 3. 게시글번호 최대값 추출 - ex) 26 --> 7자리로 변환 거침. xxxxxxx
		msg = "";
		msg = msg + " select nvl(max(b_num), 0) +1 as CNT from bbs ";
		
		System.out.println("쿼리1 : " + msg);
		
		ST = CN.createStatement();
		RS = ST.executeQuery(msg);
		while(RS.next() == true) { maxNum = RS.getInt("CNT"); }
		
		System.out.println("글번호 : " + maxNum);
		
		// 파일정보 처리
		if(Gfilename != null && Gfilename != "")
		{
			// 3. 파일사이즈 추출하기. - filesize
			File ff = multi.getFile("fileName"); // 실제파일 정보보기
			Gfilesize = ff.length();

			// 4. 파일명 생성하기
			// 4.1. 게시글번호 7자리로 변환 거침. xxxxxxx
			numVal1 = String.format("%07d", maxNum);

			// 4.2. 현재날짜 --> yyyyMMddHHmmss
			Calendar cal = Calendar.getInstance();
			String str1 = String.valueOf(cal.get(Calendar.YEAR)) + String.format("%02d", cal.get(Calendar.MONTH)+1) + String.format("%02d", cal.get(Calendar.DAY_OF_MONTH));
			String str2 = String.format("%02d", cal.get(Calendar.HOUR_OF_DAY)) + String.format("%02d", cal.get(Calendar.MINUTE)) + String.format("%02d", cal.get(Calendar.SECOND));
			
			numVal2 = str1 + str2;
			
			// 4.3. 파일명 생성 --> xxxxxxx_yyyyMMddHHmmss_fileName
			Grealfilename = numVal1 + "_" + numVal2 + "_" + Gfilename;
			
			// 5. 새로 올린 파일 명칭 변경하기.
			File f_new = new File(path + "/" + Grealfilename);
			ff.renameTo(f_new); // 파일명 변경.
		}
		else // 파일정보가 없다면 파일정보 초기값으로 저장.
		{
			Gfilename = "";
			Grealfilename = "";
			Gfilesize = 0;
		}
		
		// 5. 쿼리 인서트/업데이트 - Prepare Statement 방식
		msg = "";
		msg = msg + " insert into bbs " + "\n";
		msg = msg + " values( ?, ?, ?, ?, ?, ?, ?, 0, sysdate, sysdate )" + "\n";

		System.out.println("쿼리2 : " + msg);
		
		PST = CN.prepareStatement(msg); // Prepared Statement => sql쿼리 미리 해석 => 알맹이 없는 상태.
		PST.setInt(1, maxNum); //b_num number(7) not null PRIMARY KEY,   -- 게시글번호(PK) - 시퀀스 처리
		PST.setInt(2, Gid); //b_id number(4) not null,                -- 등록자 아이디(FK) - 이름은 사용자정보에서 가져오기
		PST.setString(3, title); //b_title varchar2(150) not null,         -- 제목
		PST.setString(4, content); //b_content varchar2(500) not null,       -- 내용
		PST.setString(5, Gfilename); //b_filename varchar2(150) null,          -- 파일명.확장자(올린 명칭)
		PST.setString(6, Grealfilename); //b_realfilename varchar2(150) null,       -- 실제파일명(서버에 저장된 파일명 -> id_YYYYMMDDHHmmss_파일명.확장자)
		PST.setLong(7, Gfilesize); //b_filesize number(7) default 0,         -- 파일사이즈(없는 경우 0)

		PST.executeUpdate(); // 쿼리문을 위에서 넣었기 때문에 안 넣어도 됨.
		
		System.out.println("Prepare Statement 데이터 저장 성공"); //"bbs테이블 데이터 수정저장 성공"
		response.sendRedirect("bbsList.jsp"); //response내장개체 문서이동
	}
	catch(Exception ex) 
	{ 
		System.out.println("Prepare Statement 데이터 저장 실패 : " + ex); //bbs테이블 데이터 수정저장 실패
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