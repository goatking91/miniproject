<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsDetail.jsp]</title>
		<link rel="stylesheet" href="./css/theme.min.css">
	<script type="text/javascript">
	function DeleteCheck(num){
		if(confirm("삭제하시겠습니까?")==true) { location.href="bbsDeleteSave.jsp?num=" + num; }
		else{ return false; }
	}
	</script>
</head>
<body>
<jsp:include page="./Header.jsp"></jsp:include>
	<!-- <font color="blue"> bbsDetail.jsp </font><p> -->
	<!--  나중에 단독실행하면 에러발생 -->
<%
	String sId = null;
    		
    if(session.getAttribute("userid") != null)
    {
    	sId = String.valueOf(session.getAttribute("userid"));
    }
%>

<%
	String title = ""; // 제목
	String content = ""; // 내용
	
	try
	{
		Gbnum = Integer.parseInt(request.getParameter("num"));
		
		msg = "";
		msg = msg + " select   b_num, nvl(b_id, 0) as b_id " + "\n";
		msg = msg + " 		 , ( select case when u_nicknameyn = 'Y' then u_nickname else u_name end from userinfo where u_id = b_id ) as b_writer " + "\n";
		msg = msg + " 		 , nvl(b_cnt, 0) as b_cnt " + "\n";
		msg = msg + " 		 , b_regdate " + "\n";
		msg = msg + " 		 , nvl(b_title, '') as b_title " + "\n";
		msg = msg + " 		 , nvl(b_content, '') as b_content " + "\n";
		msg = msg + " 		 , nvl(b_filename, '') as b_filename " + "\n";
		msg = msg + " 		 , nvl(b_realfilename, '') as b_realfilename " + "\n";
		msg = msg + " 		 , nvl(b_filesize, 0) as b_filesize " + "\n";
		msg = msg + "   from  bbs ";  
		msg = msg + "  where  b_num = " + Gbnum;

		ST = CN.createStatement();
		RS = ST.executeQuery(msg);
		
		System.out.println(msg);

		while(RS.next() == true)
		{
			Gbnum = RS.getInt("b_num");
			Gid = RS.getInt("b_id");
			Gname = RS.getString("b_writer");
			Gcnt = RS.getInt("b_cnt");
			Gregdt = RS.getDate("b_regdate");
			title = RS.getString("b_title");
			content = RS.getString("b_content");
			Gfilename = RS.getString("b_filename");
			Grealfilename = RS.getString("b_realfilename");
			Gfilesize = RS.getInt("b_filesize");
%>
<form name="myform" method="post">
	<div class="container">
		<div class="row">
			<div class="col-xs-12">
				<h2><%=title%></h2>
			</div>
		</div>
		<div class="row" >
			<div class="col-xs-6">
				<%
				if(Grealfilename != null && Grealfilename != "") 
				{
					%>
					첨부파일 <a href ="fileDownload.jsp?fileName=<%=Gfilename%>&rfileName=<%=Grealfilename %>"><%=Gfilename %></a>
					<%
				}
				else
				{
					%>첨부파일	<%
				}
				%>
			</div>
			<div class="col-xs-6">
				<h6 style="float:right;">id : <%=Gid%> | 작성자 : <%=Gname%> | 
				등록일 : <%=Gregdt%> | 조회수 : <%=Gcnt%></h6>
			</div>
		</div>
		<div class="row" style="width: 100%; align:center; margin-left: 5%;">
			<div style="border: 1px solid #e0e0e0; width: 90%; padding: 10px;">
				<!-- <div class="tit"><h5><textarea class="form-control" rows="10" style="font-size: 16px;" readonly><%=content%></textarea></h5></div> --> <!-- 내용위치 -->
				<%=content%>
			</div>
		</div>
		
		<div class="row" >
			<div class="col-xs-12">
				<%
				if(Grealfilename != null && Grealfilename != "") 
				{
					%>
					<img src="<%=request.getContextPath()%>/storage/<%= Grealfilename%>" border ='0' width=120 height=70 width="3%" height="3%" alt="이미지명">
					<%
				}
				%>
			</div>
		</div>
<%		} // while end %>
	</div>
</form>
	<div class="row" >
	<div class="col-xs-12 text-center">
	<% if(sId != null && sId.equals("") == false && sId.equals(String.valueOf(Gid))) 
		{%> 
  		<button class="btn btn-warning btn-lg" type="button" onclick='DeleteCheck(<%=Gbnum%>); return false;'>삭제</button>
  		<button class="btn btn-warning btn-lg" type="button" onclick="location.href='bbsEdit.jsp?num=<%=Gbnum%>'">수정</button>
		<!-- class="btn btn-warning btn-lg" 버튼 css붙일때 -->
	 <% } %>
		<!-- <button type="button" class="btn btn-warning btn-lg" onclick="location='bbsList.jsp'">목록</button>  -->
		<button type="button" class="btn btn-warning btn-lg" onclick="javascript:history.back();">뒤로</button>
	</div>
	</div>

	<!-- 댓글 붙이기 -->
	<br>
		<jsp:include page="./bbsreply.jsp">
			<jsp:param value="<%=Gbnum%>" name="num"/>
		</jsp:include>
	<br>
<%	}catch(Exception ex) { System.out.println(ex.toString()); }
	finally
	{
		if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
		if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
		if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
		if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
	}
%>
<jsp:include page="./Footer.jsp"></jsp:include>
</body>
</html>