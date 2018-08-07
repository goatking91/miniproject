<%@page import="java.sql.*"%> <!-- java.sql.DriverManager / java.sql.Statement / java.sql.Connection -->
<%@page import="java.util.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<!-- ssi.jsp = server side include -->	
	<%! // <%! - 전역선언임.
		Connection CN = null; //DB연결정보 및 명령어생성
		Statement ST = null; // 명령어 생성 - 전역으로 선언하면 기본값(null)이 기본적으로 셋팅된다.
		PreparedStatement PST; // sql쿼리 미리 해석 => 알맹이 없는 상태.
		ResultSet RS; // select 결과값 기억

		// session 및 작성자 정보 처리용....필수~!!
		int UserID; // 로그인한 사용자의 ID
		String UserName; // 로그인한 사용자의 이름
		String UserNameNick; // 로그인한 사용자의 이름(애칭)
		String UserNameUse; // 로그인한 사용자의 사용하기로 한 이름.
		
		int Gid;
		String Gname, Gnickname;
		String Gfilename, Grealfilename;
		long Gfilesize;
		int Gcnt;
		java.util.Date Gregdt, Gmoddt; // 등록날짜, 수정날짜
		int Gbnum;
		int Gtotal = 0;
		
		String msg = ""; //쿼리(isud) - 전역변수 필드
		String data; // 데이터받는 역할. --> data = request.getParameter(컬럼명);
	%>
	
	<%
		try
		{
			Class.forName("oracle.jdbc.driver.OracleDriver"); // 클래스명 지정 - DB드라이버
			String url = "jdbc:oracle:thin:@127.0.0.1:1521:XE"; // oracle의 리스너의 포트 : 1521(고정) - DB서버정보
			String uId = "system";
			String uPw = "oracle";
			CN = DriverManager.getConnection(url, uId, uPw); // CN이 DB서버정보를 기억하고 있음.
			//System.out.println("ssi.jsp 오라클 DB연결 성공");
		}catch(Exception ex){ System.out.println("ssi.jsp 오라클 DB연결 실패 : " + ex.toString()); }
		finally
		{
			if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
			if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
			if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
		}
	%>
</body>
</html>