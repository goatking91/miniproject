<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsList.jsp]</title>
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
	String sId = "";
    		
    if(session.getAttribute("userid") != null)
    {
    	sId = String.valueOf(session.getAttribute("userid"));
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
	
	int bnum = 0; // 게시글 번호(PK)
	int iReplyCnt = 0; // 댓글 갯수
	String title = ""; // 게시글 제목
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
				sqlWhere = "";
				sqlWhere = sqlWhere + " where b_id    like '%" + sval + "%' or b_writer  like '%" + sval + "%' ";
				sqlWhere = sqlWhere + "    or b_title like '%" + sval + "%' or b_content like '%" + sval + "%' ";
				
			}
		}
		else if(skey.equals("titlecontent"))
		{
			if(skey.equals(""))
			{
				sqlWhere = "";
			}
			else
			{
				sqlWhere = " where b_title like '%" + sval +"%' or b_content like '%" + sval + "%' ";
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
		msg = " select count(*) as CNT from bbs " + sqlWhere; // 조건절 추가

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
		<table class="table table-striped" >
			<tr align="center">
				<td colspan="7">
					<form name="myform" method="get" action="bbsList.jsp">
						<div class="row">
							<div class="col-xs-1">
							</div>
							<div class="col-xs-4">
								<select class="form-control" name="keyfield" onchange="javascript:changeClear();">
									<option value="all" <% if(skey.equals("all")) { out.println("selected"); } %> > 전체 검색 </option>
									<option value="b_id" <% if(skey.equals("b_id")) { out.println("selected"); } %> > 아이디 검색 </option>
									<option value="b_writer" <% if(skey.equals("b_writer")) { out.println("selected"); } %> > 작성자 검색 </option>
									<option value="b_title" <% if(skey.equals("b_title")) { out.println("selected"); } %> > 제목검색 </option>
									<option value="b_content" <% if(skey.equals("b_content")) { out.println("selected"); } %> > 내용 검색 </option>
									<option value="titlecontent" <% if(skey.equals("titlecontent")) { out.println("selected"); } %> > 제목+내용 검색 </option>
								</select>
							</div>
							<div class="col-xs-5">
								<input class="form-control" type="text" name="keyword" value="<%=sval%>" size="10">
							</div>
							<div class="col-xs-2">
								<input class="btn btn-default" type="submit" style="background-color: #ccc; border-color: #c2c2c2;" value="&nbsp;&nbsp;검&nbsp;&nbsp;색&nbsp;&nbsp;">
							</div>
						</div>
					</form>
				</td>
			</tr>
			
			<tr align="center" class="header" style="background-color: #fce84e">
				<td>번호</td> <td>제목</td> <td>ID</td> <td>작성자</td> <td>날짜</td> <td>조회수</td> <td>파일</td>
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
			
			// 쿼리작성 : 행번호 출력 및 사번(sabun)으로 정렬하여 출력하기. - // 댓글 갯수 있는 bbs리스트
			msg = "";
			msg = msg + " select bss.* " + "\n";
			msg = msg + "   from ( select rownum as rowcnt, bs.* " + "\n";
			msg = msg + "  		     from ( select bbss.* " + "\n";
			msg = msg + "          		      from ( select   b_num, b_id, b_title, b_regdate, b_cnt, b_content " + "\n";
			msg = msg + "                        		    , nvl(b_filename, '') as b_filename, nvl(b_realfilename, '') as b_realfilename " + "\n";
			msg = msg + "                   				, nvl(b_filesize, 0) as b_filesize " + "\n";
			msg = msg + "                   				, case when u_nicknameyn = 'Y' then u_nickname else u_name end as b_writer " + "\n";
			msg = msg + "                   				, ( select count(*) CNT from bbsreply where b_num = br_bnum  GROUP BY br_bnum ) as replyCnt " + "\n";
			msg = msg + "                              from  bbs left join userinfo on b_id = u_id order by b_regdate desc " + "\n";
			msg = msg + "                          ) bbss " + "\n";
			msg = msg + "                     " + sqlWhere  + "\n";
			msg = msg + "                 ) bs " + "\n";
			msg = msg + "        ) bss " + "\n";
			msg = msg + " where bss.rowcnt between " + iStartNum  + " and " + iEndNum + "\n";
			msg = msg + " order by bss.b_regdate desc " + "\n";
	
			// ** join사용방식
			//msg = msg + " select bs.*, nvl(br.cnt, 0) as replyCnt " + "\n";
			//msg = msg + "   from ( select bss.* " + "\n";
			//msg = msg + "            from ( select rownum as rowcnt, b.* " + "\n";
			//msg = msg + "            		  from ( select bbss.* " + "\n";
			//msg = msg + "                     		   from ( select   b_num, b_id, b_title, b_regdate, b_cnt, b_content " + "\n";
			//msg = msg + "                   			     		  , nvl(b_filename, '') as b_filename, nvl(b_realfilename, '') as b_realfilename " + "\n";
			//msg = msg + "                   				 		  , nvl(b_filesize, 0) as b_filesize " + "\n";
			//msg = msg + "                   				 		  , case when u_nicknameyn = 'Y' then u_nickname else u_name end as b_writer " + "\n"; //, decode(u_nicknameyn, 'Y', u_nickname, u_name) as b_writer
			//msg = msg + "                              			from  bbs left join userinfo on b_id = u_id order by b_id " + "\n";
			//msg = msg + "                              		 ) bbss " + sqlWhere + "\n";
			//msg = msg + "                  		   ) b " + "\n";
			//msg = msg + "         		  ) bss " + "\n";
			//msg = msg + "  	     ) bs left join ( select br_id, count(*) CNT from bbsreply  GROUP BY br_id) br on bs.b_id = br.br_id " + "\n";
			//msg = msg + " where bs.rowcnt between " + iStartNum  + " and " + iEndNum;
			//msg = msg + " order by bs.b_id " + "\n";
			
			System.out.println(msg);
			
			ST = CN.createStatement();
			RS = ST.executeQuery(msg);
			
			while(RS.next() == true)
			{
				iRowNum = RS.getInt("rowcnt");
				bnum = RS.getInt("b_num");
				Gid = RS.getInt("b_id");
				Gname = RS.getString("b_writer");
				title = RS.getString("b_title");
				Gregdt = RS.getDate("b_regdate");
				Gcnt = RS.getInt("b_cnt");
				Gfilename = RS.getString("b_filename");
				Grealfilename = RS.getString("b_realfilename");
				Gfilesize = RS.getInt("b_filesize");
				iReplyCnt = RS.getInt("replyCnt");
	%>
			<tr class="guestValues">
				<td width=60pt align="center"><%=iRowNum%>&nbsp;</td>
				<td width=190pt><a href="bbsCntSave.jsp?num=<%=bnum%>"><%= title %></a>
					<font color='red' style="font-size:12;"> <% if(iReplyCnt != 0) { out.println("[" + iReplyCnt +"]"); } %></font>
				</td>
				<td width=60pt align="center"><a href="bbsCntSave.jsp?num=<%=bnum%>"><%=Gid%></a></td> <!-- bbsDetail.jsp?num=%=bnum% -->
				<td width=120pt><%=Gname%></td>
				<td width=100pt align="center"><%=Gregdt%></td>
				<td width=65pt align="center"><%= Gcnt %>&nbsp;</td>
				<td width=55pt align="center"> 
					<% if(Gfilename != null && Gfilesize != 0)
						{ %> <a href ="fileDownload.jsp?fileName=<%=Gfilename%>&rfileName=<%=Grealfilename %>" style="text-decoration: none;"><img width="20" height="20" src="./images/documentIcon1.png"></a> <% } %> 
				</td>
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
				<td colspan="5">
				<%  
					// [이전] 출력 여부 - [11]부터 [이전]을 붙여줘야 하며 이동시 10씩 빼줘야 함.
					if(iStartPage > iPageSize) { out.println("<a class='btn btn-default' style='text-decoration: none;' href='bbsList.jsp?pageNum=" + (iStartPage - iPageSize) + returnPage + "'>" + "[이전]" + "</a>"); }
					
					// 페이지 번호 - iStartPage : 1 / iEndPage : 10 ==> [1][2] ~ [9][10]
					for(int i = iStartPage; i <= iEndPage; i++)
					{
						if(iPageNum == i) { out.println("<a class='btn btn-warning' style='text-decoration: none;' href='#'>" + i + "</a>"); }
						else { out.println("<a class='btn btn-default' style='text-decoration: none;' href='bbsList.jsp?pageNum=" + i + returnPage + "'>" +  i  + "</a>"); }
					}
				
					// [다음] 출력 여부 - 최종페이지가 아닌 경우 [다음]을 붙여줘야 하며 이동시 10씩 더해줘야 함.
					if(iEndPage < iPageCount) { out.println("<a class='btn btn-default' style='text-decoration: none;' href='bbsList.jsp?pageNum=" + (iStartPage + iPageSize) + returnPage + "'>" + "[다음]" + "</a>"); }
				%>
				</td>
				<td colspan="2">
					<% if(sId != null && sId != "") {%> <button class="btn btn-default" style='text-decoration: none; background-color: #ccc; border-color: #c2c2c2;' type="button" onclick="location.href='bbsInput.jsp'" name="bbs_input">글쓰기</button> <% } %>
				</td>
			</tr>
		</table>
	</div>
<jsp:include page="./Footer.jsp"></jsp:include>
</body>
</html>