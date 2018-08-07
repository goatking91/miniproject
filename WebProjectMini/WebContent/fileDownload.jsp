<%@page import="java.io.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[fileDownload.jsp]</title>
	<style type="text/css">
		* { font-size:20pt; font-weight:bold; }
	</style>
</head>
<body>
	<font color="blue"> fileDownload.jsp </font>

	<%
	String path = application.getRealPath("./storage");
	String data = request.getParameter("fileName"); // aaa.gif
	String datareal = request.getParameter("rfileName"); // 0000001_20180703120123_aaa.gif

	File file = new File(path, datareal);
	System.out.println("넘어온그림파일fileNmae=" + data + "<br>");
	System.out.println("넘어온그림파일rfileNmae=" + datareal + "<br>");
		
	//파일 다운로드 처리 => 1)해더변경 2)io처리 읽기후쓰기
	response.setHeader("Content-Disposition", "attachment; filename=" + data + ";"); 

	try
	{
		// 읽기 - 추상메소드 
		// ==> FileInputStream(자식클래스)이 InputStream(부모클래스)을 상속받은 것 ==>  FileInputStream객체는 InputStream객체에 넣을 수 있음. 
		InputStream is = new FileInputStream(file);
		OutputStream os = response.getOutputStream(); // 쓰기는 reponse 이용.
		
		byte[] b = new byte[(int)file.length()]; //권장
		is.read(b, 0, b.length); // b.length - 배열의 길이
		os.write(b);
		
		is.close(); // 닫기
		os.close(); // 닫기
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("self.close();");
		script.println("</script>");
	}
	catch(Exception ex) { System.out.println("다운로드 에러:" + ex); }
	%>
</body>
</html>