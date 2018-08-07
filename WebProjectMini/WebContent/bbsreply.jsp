<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsreply.jsp]</title>
	<script type="text/javascript">
	function rpUp(Rbnum, Rbrnum, flagVal)
	{
		if(confirm("수정하시겠습니까?") == true)
		{
			location.href="bbsDetail.jsp?num=" + Rbnum + "&brnum=" + Rbrnum + "&flag=" + flagVal;
		}
		else { return false; }
	}
	
	function rpDel(Rbnum, Rbrnum, flagVal)
	{
		if(confirm("삭제하시겠습니까?") == true)
		{
			location.href="bbsreplySave.jsp?num=" + Rbnum + "&brnum=" + Rbrnum + "&flag=" + flagVal;
		}
		else { return false; }
	}
	function call(Rbnum) 
	{
		location.href="bbsDetail.jsp?num="+Rbnum;
	}
	
	function checkVal() 
	{
		var content = myreplyform.content.value;
		
		if(content != null) 
		{ 
			if(content.trim() == "") 
			{
				alert("댓글을 입력해주세요.");
				return false; 
			}
		}
		document.myreplyform.submit();
	}
	
	</script>
</head>
<body>
	<!-- <font color="blue"> guestreply.jsp </font><p> -->
	<!--  나중에 단독실행하면 에러발생 -->
<%
	String sId = null;
    		
    if(session.getAttribute("userid") != null)
    {
    	sId = String.valueOf(session.getAttribute("userid"));
    }
    else
    {
    	response.sendRedirect("index.jsp");
    }
%>
	
<%
	//Rbrnum(br_num:시퀀스글번호) - brnum / Rbnum(br_bnum:게시글번호) - num
	int Rbnum = 0, Rbrnum = 0, Rdata = 0;
	String Rwriter, Rcontent;
	String Redit, url; // 댓글 추가/수정 구분처리
%>

<% // 단독 실행하면 에러발생
	// jsp:param name="Gsabun"
	try
	{
		msg = "";

		url = "bbsreplySave.jsp";
		
		if(request.getParameter("num") == null)
		{
			//url = "bbsreply_insert.jsp";
		}
		else 
		{
			Rbnum = Integer.parseInt(request.getParameter("num"));
			
			if(request.getParameter("brnum") != null)
			{
				Rbrnum = Integer.parseInt(request.getParameter("brnum"));
			}

			//url = "bbsreply_editSave.jsp";
			msg = "";
			msg = msg + " select    br_id " + "\n";
			msg = msg + "        , ( select case when u_nicknameyn = 'Y' then u_nickname else u_name end from userinfo where u_id = br_id ) as br_writer " + "\n";
			msg = msg + "        , br_bnum, br_content " + "\n";
			msg = msg + " from bbsreply " + "\n";
			msg = msg + " where br_bnum = " + Rbnum + "and br_num = " + Rbrnum + "\n";
			
			System.out.println("U :" + msg);
			
			ST = CN.createStatement();
			RS = ST.executeQuery(msg);
		}
	%>

	<form name="myreplyform"  method="get" action="<%=url%>" onsubmit="checkVal(); return false;">
		<input type="hidden" style="display: none;" name="insert" value="flag">
		<input type="hidden" style="display: none;" name="num" value="<%=Rbnum%>">
		<input style="display: none;" name="brnum" value=<%=Rbrnum %>>
		<table width="600" border="0" cellspacing="0" style="margin: 0px;">
			<tr style="margin:0px;">
			<%	
				if(sId != null && sId.equals("") == false)
				{
					if(Rbrnum == 0) 
					{
						out.println("<div class='container-fluid'>");
						out.println("	<div class='row'>");
						out.println("		<div class='col-xs-3'></div>");
						out.println("		<div class='col-xs-5 '>");
						out.println("			<input class='form-control' type='hidden' style='display:none;' name='id' value='" + sId  + "'>");
						out.println("			<input class='form-control' type='hidden' style='display:none;' name='flag' value='I'>");
						//out.println("			<input class='form-control' type='text' name='writer' value='" + UserNameUse  + "' readonly>");
						out.println("			<textarea class='form-control' name='content' rows='2' placeholder='내용을 적어주세요...' ></textarea>");
						out.println("		</div>");
						out.println("		<div class='col-xs-1'>");
						out.println("			<input class='btn btn-success btn-lg' type='submit' value='댓글저장'>");
						out.println("		</div>");
						out.println("		<div class='col-xs-3'></div>");			
						out.println("	</div>");
						out.println("</div>");
					}
					else
					{
						while(RS.next() == true) 
						{
							out.println("<div class='container-fluid'>");
							out.println("	<div class='row'>");
							out.println("		<div class='col-xs-3'></div>");
							out.println("		<div class='col-xs-5 '>");
							out.println("			<input class='form-control' type='hidden' style='display:none;' name='id' value='" + sId  + "'>");
							out.println("			<input class='form-control' type='hidden' style='display:none;' name='flag' value='U'>");
							//out.println("			<input class='form-control' type='text' name='writer' value='" + UserNameUse  + "' readonly>");
							out.println("			<textarea class='form-control' name='content' rows='2' placeholder='내용을 적어주세요...' >" + RS.getString("br_content") + "</textarea>");
							out.println("		</div>");
							out.println("		<div class='col-xs-1'>");
							out.println("			<input class='btn btn-info btn-lg' style='float:right;' type='submit' value='댓글수정'>");
							out.println("		</div>");
							out.println("		<div class='col-xs-1'>");
							out.println("			<input class='btn btn-danger btn-lg' style='float:right;' type='button' onclick='call("+Rbnum+");' value='댓글취소'>");						
							out.println("		</div>");
							out.println("		<div class='col-xs-2'></div>");	
							out.println("	</div>");
							out.println("</div>");
						}
					}
				}
			%>
			</tr>
		</table>
	</form>
	<p>
	<div class='container'>
		<div class='row'>
			<div class='col-xs-1'></div>
				<div class='col-xs-10'>
					<table class="table table-striped">
		<%		msg = "";
				msg = msg + " select    br_id, br_num " + "\n";
				msg = msg + "        , ( select case when u_nicknameyn = 'Y' then u_nickname else u_name end from userinfo where u_id = br_id ) as br_writer " + "\n";
				msg = msg + "        , br_bnum, br_content, br_regdate " + "\n";
				msg = msg + "  from bbsreply " + "\n";
				msg = msg + " where br_bnum = " + Rbnum + "\n"; // Rbrnum(br_num:시퀀스글번호) / Rbnum(br_bnum:게시글번호)
				msg = msg + " order by br_regdate desc ";
		
				System.out.println("쿼리 : " + msg);
		
				ST = CN.createStatement();
				RS = ST.executeQuery(msg);
				
				while(RS.next() == true)
				{
					Gid = RS.getInt("br_id"); // 작성자 ID
					Rwriter = RS.getString("br_writer"); // 작성자 명
					Rcontent = RS.getString("br_content");
					Gregdt = RS.getDate("br_regdate");
					Rbrnum = RS.getInt("br_num");
		%>	
					<tr>
						<td><h6 class="text-muted"><%=Gid%>(<%=Rwriter%>)</h6></td>
						<td style="width:50%;"><%=Rcontent%></td>
						<td><h6 class="text-muted">작성날짜 <%=Gregdt%></h6></td>
				
				<% 
					if(sId != null && sId.equals("") == false && sId.equals(String.valueOf(Gid))) 
					{%> 
						<td><input class="btn btn-info btn-sm" type="button" onclick="rpUp(<%=Rbnum%>,<%=Rbrnum%>, 'U');return false;" value="수정">
						<input class="btn btn-info btn-sm" type="button" onclick="rpDel(<%=Rbnum%>,<%=Rbrnum%>, 'D');return false;" value="삭제"></td>
					<% } else {%><td></td><%}%>
			<%	} // while end
	} catch(Exception ex) { System.out.println("댓글 실패 : " + ex); }
	finally
	{
		if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
		if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
		if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
		if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
	}
	%>
					</tr>
				</table>
				<div class="col-xs-1"></div>
			</div>
		</div>
	</div>
</body>
</html>