<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[userList.jsp]</title>
	
	<script type="text/javascript">
		function changeClear()
		{
			myform.keyword.value = "";
			myform.keyword.focus();
		}
	</script>
</head>
<body>
	<jsp:include page="./Header.jsp"></jsp:include>
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
	// 페이지내 출력되는 행번호 처리
	int iPageNum = 0; // 게시판의 페이지번호
	String sPageNum = ""; // 행번호(문자열) - null이나 공백인 경우 에러방지용...
	int iStartNum = 0; // 게시판에 출력될 페이지번호의 첫 행번호
	int iEndNum = 0; // 게시판에 출력될 페이지번호의 마지막 행번호
	int iRowSize = 10; // 게시판 한페이지당 행크기
	int iRowNum = 0; // 페이지에 출력될 행번호컬럼의 번호값 => rownum
	
	// 페이지번호 처리
	int iPageCount = 0; // 페이지 총 갯수(최종페이지번호) => 318 / 10 => 31 + 1 => 32
	int iStartPage = 0; // 화면에 출력될 시작 페이지번호
	int iEndPage = 0; // 화면에 출력될 종료 페이지번호
	int iPageSize = 10; // 한 페이지당 출력될 페이지수
	
	// 검색 처리
	String skey = ""; // 검색할 컬럼
	String sval = ""; //  검색값
	String sqlWhere = "";
	String returnPage = ""; // 검색시 출력될 값(url)
	
	int iReplyCnt = 0; // 댓글 갯수
	String juso1 = ""; // 주소1
%>

<%
	skey = request.getParameter("keyfield");
	sval = request.getParameter("keyword");
	
	if(skey == null) { skey = ""; } else { skey = skey.trim(); }
	if(sval == null) { sval = ""; } else { sval = sval.trim(); }
	
	if(skey.equals("") && sval.equals(""))
	{
		sqlWhere = ""; //" where title like '%%' ";
		returnPage = "";
	}
	else
	{
		if(skey.equals("all"))
		{
			if(skey.equals(""))
			{
				sqlWhere = "";
			}
			else
			{
				sqlWhere = " where u_id like '%" + sval +"%' or u_name like '%" + sval + "%' or u_nickname like '%" + sval +"%'";
			}
		}
		else
		{
			sqlWhere = " where " + skey + " like '%" + sval + "%'";
		}
		returnPage = "&keyfield=" + skey + "&keyword=" + sval;
	}
%>

<%	try
	{
		msg = " select count(*) as CNT from userinfo " + sqlWhere; // 조건절 추가

		ST = CN.createStatement();
		RS = ST.executeQuery(msg);
		if(RS.next() == true) { Gtotal = RS.getInt("CNT"); }
	}catch(Exception ex) { System.out.println(ex.toString()); }
	finally
	{
		if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
		if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
		if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
	}
%>
	<div class="container">
		<table class="table table-striped" style="width:100%;">
			<tr align="center">
				<td colspan="6">
					<form name="myform" method="get" action="userList.jsp">
						<div class="row">
							<div class="col-xs-1">
							</div>
							<div class="col-xs-4">
								<select class="form-control" name="keyfield" onchange="javascript:changeClear();">
									<option value="all" <% if(skey.equals("all")) { out.println("selected"); } %> > 전체 검색 </option>
									<option value="u_id" <% if(skey.equals("u_id")) { out.println("selected"); } %> > 아이디 검색 </option>
									<option value="u_name"  <% if(skey.equals("u_name")) { out.println("selected"); } %> > 이름검색 </option>
									<option value="u_nickname" <% if(skey.equals("u_nickname")) { out.println("selected"); } %> > 닉네임검색 </option>
								</select>
							</div>
							<div class="col-xs-5">
								<input class="form-control"  type="text" name="keyword" value="<%=sval%>" size="10">
							</div>
							<div class="col-xs-2">
								<input class="btn btn-default"  type="submit" style="background-color: #ccc; border-color: #c2c2c2;"  value="&nbsp;&nbsp;&nbsp;검&nbsp;&nbsp;&nbsp;색 &nbsp;&nbsp;&nbsp;">
							</div>
						</div>
					</form>
				</td>
			</tr>
			
			<tr align="center" class="header" style="background-color: #fce84e">
				<td>번호</td> <td>ID</td> <td>이름</td> <td>닉네임</td> <td>주소</td> <td>가입일</td>
			</tr>
	<%	try
		{
			// 총페이지번호 계산
			if(Gtotal % iRowSize == 0) { iPageCount = Gtotal / iRowSize; }
			else { iPageCount = (Gtotal / iRowSize) + 1; } //나머지가 있는 경우 페이지수 +1 해줘야 함.
	
			sPageNum = request.getParameter("pageNum");
			
			if(sPageNum == null || sPageNum == "") 
			{ 
				// 페이지번호(pageNum)가 없는 경우에도 초기값으로 처리하기.
				sPageNum = "1"; // 페이지번호 초기값 = 1
				//iStartPage = 1; // 페이지 시작번호 초기값 = 1 
				//iEndPage = 10; // 페이지 종료번호 초기값 = 10
	
				//iStartNum = 1; // 페이지에 출력될 시작 행번호 초기값 = 1
				//iEndNum = 10; // 페이지에 출력될 종료 행번호 초기값 = 10
			}
			
			iPageNum = Integer.parseInt(sPageNum); // 사용자가 선택한 페이지 번호 => 형변환
	
			// 페이지에 출력될 행번호 계산
			iStartNum = (iPageNum * iRowSize) - (iRowSize-1);
			iEndNum = iPageNum * iRowSize;
	
			// 화면에 출력될 시작페이지번호 계산 => 선택한 페이지번호에서 size로 나눈 나머지를 선택한 페이지번호에서 빼면 됨.
			iStartPage = iPageNum - ((iPageNum-1) % iPageSize); // 시작페이지번호 = 선택페이지번호 - ((선택페이지번호-1) % 페이지번호 크기); 
			iEndPage = iStartPage + (iPageSize-1);
			
			if(iEndPage > iPageCount) // 종료페이지번호가 총페이지번호(최종페이지번호)보다 클 경우 최종페이지번호로 변경.
			{
				iEndPage = iPageCount;
			}
			
			// 쿼리작성 : 행번호 출력 및 사번(sabun)으로 정렬하여 출력하기. - // UserInfo리스트
			msg = "";
			msg = msg + " select ur.* " + "\n";
			msg = msg + "   from ( select rownum as rowcnt, us.* " + "\n";
			msg = msg + "            from ( select u_id, u_name, nvl(u_nickname, '') as u_nickname, u_regdate, u_juso1 " + "\n";
			msg = msg + "                     from userinfo " + sqlWhere + "\n";
			msg = msg + "                    order by u_id " + "\n";
			msg = msg + "                 ) us " + "\n";
			msg = msg + "        ) ur " + "\n";
			msg = msg + " where ur.rowcnt between " + iStartNum  + " and " + iEndNum + "\n";
			msg = msg + " order by ur.u_id " + "\n";
					
			System.out.println(msg);
			
			ST = CN.createStatement();
			RS = ST.executeQuery(msg);
			
			while(RS.next() == true)
			{
				iRowNum = RS.getInt("rowcnt");
				Gid = RS.getInt("u_id");
				Gname = RS.getString("u_name");
				Gnickname = RS.getString("u_nickname");
				Gregdt = RS.getDate("u_regdate");
				juso1 = RS.getString("u_juso1");
				
				if(Gnickname == null) { Gnickname = ""; }
	%>
			<tr class="guestValues">
				<td width=60pt align="center"><%=iRowNum%>&nbsp;</td>
				<td width=60pt align="center"><a href="userDetail.jsp?idx=<%=Gid%>"><%=Gid%></a></td>
				<td width=120pt><a href="userDetail.jsp?idx=<%=Gid%>"><%=Gname%></a></td>
				<td width=120pt><%= Gnickname %></td>
				<td width=230pt><%= juso1 %>&nbsp;</td>
				<td width=110pt align="center"><%=Gregdt%></td>
			</tr>
	<%		} // while end
		}catch(Exception ex) { System.out.println(ex.toString()); }
		finally
		{
			if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
			if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
			if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
			if(CN != null) { try{ CN.close(); } catch(Exception ex){} }
		}
	%>
			<tr align="center">
				<td colspan="6">
				<%  
					// [이전] 출력 여부 - [11]부터 [이전]을 붙여줘야 하며 이동시 10씩 빼줘야 함.
					if(iStartPage > iPageSize) { out.println("<a class='btn btn-default' style='text-decoration: none;' href='userList.jsp?pageNum=" + (iStartPage - iPageSize) + returnPage + "'>" + "이전" + "</a>"); }
					
					// 페이지 번호 - iStartPage : 1 / iEndPage : 10 ==> [1][2] ~ [9][10]
					for(int i = iStartPage; i <= iEndPage; i++)
					{
						if(iPageNum == i) { out.println("<a class='btn btn-default' style='text-decoration: none;' href='#'>" + i + "</a>"); }
						else { out.println("<a class='btn btn-default' style='text-decoration: none;' href='userList.jsp?pageNum=" + i + returnPage + "'>" + i + "</a>"); }
					}
				
					// [다음] 출력 여부 - 최종페이지가 아닌 경우 [다음]을 붙여줘야 하며 이동시 10씩 더해줘야 함.
					if(iEndPage < iPageCount) { out.println("<a class='btn btn-default' style='text-decoration: none;' href='userList.jsp?pageNum=" + (iStartPage + iPageSize) + returnPage + "'>" + "다음" + "</a>"); }
				%>
				</td>
			</tr>
		</table>
	</div>
	<jsp:include page="./Footer.jsp"></jsp:include>
</body>
</html>