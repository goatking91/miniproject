<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsreplySave.jsp]</title>
</head>
<body>
	<font color="blue"> bbsreplySave.jsp </font><p>
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
	int Rbnum, Rbrnum, Rdata;
	String Rwriter, Rcontent;
	
	String flagVal = "";
	String ct = "";
%>

<%	
	flagVal = request.getParameter("flag"); // 추가[I]/수정[U]/삭제[D]
			
	System.out.println("flagVal : " + flagVal);
	
	//System.out.println("Gid : " + request.getParameter("id"));
	//System.out.println("Rbnum : " + request.getParameter("num"));
	//System.out.println("Rbrnum : " + request.getParameter("brnum"));
	//System.out.println("content : " + request.getParameter("content"));

	if(flagVal.equals("I"))
	{
		try
		{
			Gid = Integer.parseInt(request.getParameter("id")); // 댓글 작성자 id
			Rbnum = Integer.parseInt(request.getParameter("num")); //Rbrnum(br_num:시퀀스글번호) - brnum / Rbnum(br_bnum:게시글번호) - num
			//String wr = request.getParameter("writer"); // 댓글 쓴 사람 이름
			ct = request.getParameter("content"); // 댓글 내용
			
			System.out.println("bbsreply_insert.jsp문서 num=" + Rbnum);
			
			//bbsreply table에서 댓글번호 최대값 추출하기 
			msg = "";
			msg = msg + " select nvl(max(br_num), 0) + 1 as cnt from bbsreply ";
			
			System.out.println(msg);
			
			ST=CN.createStatement();
			RS=ST.executeQuery(msg);
			while(RS.next()==true) { Gtotal = RS.getInt("cnt"); }
	
			System.out.println("Gtotal : " + Gtotal);
			
			msg = "";
			msg = msg + " insert into bbsreply " + "\n";
			msg = msg + " values ( ?, ?, ?, ?, sysdate, sysdate) ";
			
			PST = CN.prepareStatement(msg);
			
			PST.setInt(1, Gtotal); // br_num number(7) not null PRIMARY KEY,  -- 댓글 번호(PK) - 시퀀스 처리
			PST.setInt(2, Rbnum); // br_bnum number(7) not null,              -- 게시글번호(FK)
			PST.setInt(3, Gid); // br_id number(4) not null,                  -- 댓글 작성자 아이디 - 이름은 사용자정보에서 가져오기
			//PST.setString(4, wr); // br_name varchar2(30) not null,           -- 댓글 작성자명
			PST.setString(4, ct); // br_content varchar2(500) not null,       -- 댓글 내용
			
			PST.executeUpdate();
			
			System.out.println("댓글저장 성공");
			response.sendRedirect("bbsDetail.jsp?num=" + Rbnum);
		}
		catch(Exception ex) { System.out.println("댓글저장 실패 : " + ex); }
		finally
		{
			if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
			if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
			if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
			if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
		}
	}
	else if(flagVal.equals("U"))
	{
		try 
		{
			Rbnum = Integer.parseInt(request.getParameter("num"));
			Rbrnum = Integer.parseInt(request.getParameter("brnum"));
			//Rwriter=request.getParameter("writer");
			Rcontent=request.getParameter("content");
			
			System.out.println("bbsreply_insert.jsp문서 num=" + Rbnum);
			
			if(Rcontent==null||Rcontent=="") 
			{
				System.out.println("내용이 공백입니다.");
				response.sendRedirect("bbsDetail.jsp?num=" + Rbnum);
			}
			
			msg="";
			msg=msg + " update bbsreply " + "\n";
			msg=msg + "    set br_content = '" + Rcontent + "', br_moddate = sysdate " + "\n";
			msg=msg + "  where br_num = " + Rbrnum;
			ST=CN.createStatement();
			
			ST.executeUpdate(msg);
			response.sendRedirect("bbsDetail.jsp?num=" + Rbnum);
		} catch(Exception e) { System.out.println("댓글수정에러" + e); }
		finally
		{
			if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
			if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
			if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
			if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
		}
	}
	else if(flagVal.equals("D"))
	{
		try
		{
			Rbnum = Integer.parseInt(request.getParameter("num"));
			Rbrnum = Integer.parseInt(request.getParameter("brnum"));
			
			System.out.println("bbsreply_delete.jsp문서 num=" + Rbnum);
			System.out.println("bbsreply_delete.jsp문서 rnum=" + Rbrnum);

			msg = " delete from bbsreply where br_num = " + Rbrnum;
			System.out.println("쿼리 : " + msg);
			
			ST = CN.createStatement();
			ST.executeUpdate(msg);

			System.out.println("댓글 삭제 성공");
			response.sendRedirect("bbsDetail.jsp?num=" + Rbnum);
		}
		catch(Exception ex) { System.out.println("댓글삭제 실패 : " + ex); }
		finally
		{
			if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
			if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
			if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
			if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
		}
	}
%>
</body>
</html>