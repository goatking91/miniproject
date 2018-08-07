<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[userDetail.jsp]</title>
	<link rel="stylesheet" href="./css/userInputCSS.css">
	<script type="text/javascript">
		function deletecheck(Gid){
			if(confirm("정말 탈퇴하시겠습니까 ?") == true)
			{
				location.href="userDeleteSave.jsp?idx=" + Gid;
			}
			else{ return false; }
		};
	</script>
</head>
<body>
	<jsp:include page="./Header.jsp"></jsp:include>
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
	String juso1 = "";
	String juso2 = "";
	String phone = "";
	String email = "";
	String nicknameYN = "";
	int postcode = 0;
%>
<%
	try
	{
		Gid = Integer.parseInt(request.getParameter("idx"));
		
		msg = "";
		msg = msg + " select   u_id, nvl(u_name, '') as u_name, nvl(u_nickname, '') as u_nickname " + "\n";
		msg = msg + "        , nvl(u_nicknameYN, 'N') as u_nicknameYN " + "\n";
		msg = msg + "        , u_postcode, nvl(u_juso1, '') as u_juso1, nvl(u_juso2, '') as u_juso2 " + "\n";
		msg = msg + "        , nvl(u_phone, '') as u_phone, nvl(u_email, '') as u_email " + "\n";
		msg = msg + "        , u_regdate " + "\n";
		msg = msg + "   from userinfo " + "\n";
		msg = msg + "  where u_id = " + Gid;
		
		ST = CN.createStatement();
		RS = ST.executeQuery(msg);
		
		System.out.println(msg);

		while(RS.next() == true)
		{
			Gid = RS.getInt("u_id");
			Gname = RS.getString("u_name");
			Gnickname = RS.getString("u_nickname");
			nicknameYN = RS.getString("u_nicknameYN");
			postcode = RS.getInt("u_postcode");
			juso1 = RS.getString("u_juso1");
			juso2 = RS.getString("u_juso2");
			phone = RS.getString("u_phone");
			email = RS.getString("u_email");
			Gregdt = RS.getDate("u_regdate");
%>
	<div class="container">
		<div class="row">
		<form class="form-inline">
		<table class="table1" style="width:100%;">
                <tr>
                    <th>회원ID</th>
                    <td colspan="2"><input class="form-control" type="text" value="<%=Gid%>" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);"> </td>
                     
                </tr>
                <tr>
                    <th>가입일</th>
                    <td colspan="2"><input class="form-control" type="text" value="<%=Gregdt%>" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);"></td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td colspan="2"><input class="form-control" type="text" value="<%=Gname%>" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);"></td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td>
                        <%	
							if(Gnickname == null || Gnickname.equals("")) { out.println(""); }
							else { out.println("<input class='form-control' type='text' value='" + Gnickname + "' readonly style='background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);'>"); }
       
						%>
                    </td>
                    <td>
                    	
                    	<%
							if(nicknameYN.equals("Y")) { out.println("<input class='form-control' type='text' value='사용' readonly style='background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);''>"); }
							else { out.println("<input class='form-control' type='text' value='미사용' readonly style='background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);''>"); }
						%>
                    </td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td colspan="2">
                    	<input class="form-control" type="text" size="3"  value="( <%=postcode%> )" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);">
                        <input class="form-control" type="text" size="50" readonly value="<%=juso1%>" style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);">
                        <input class="form-control" type="text" size="50"  value="<%=juso2%>" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);">
                    </td>
                </tr>
                <tr>
                    <th>핸드폰번호</th>
                    <td colspan="2"><input class="form-control" type="text" value="<%=phone%>" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);"></td>
                </tr>
                <tr>
                    <th>email</th>
                    <td colspan="2"><input class="form-control" type="text" value="<%=email%>" readonly style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);"></td>
                </tr>
            </table>
		</form>
<%		} // while end %>
	</div>
	<div class="col-xs-12 text-center">
	<%	if(sId != null && sId.equals("") == false && sId.equals(String.valueOf(Gid))) 
		{%> 
	  		<br>
	  		<button type="button" class="btn btn-warning btn-lg" onclick="location='userEdit.jsp?idx=<%=Gid%>'">수정</button>
	  		<button type="button" class="btn btn-warning btn-lg" onclick="deletecheck(<%=Gid%>); return false;">탈퇴</button>
	<% } %>
	<button type="button" class="btn btn-warning btn-lg" onclick="location='userList.jsp?'">목록</button>
	</div>
	</div>
<%	}catch(Exception ex) { System.out.println(ex.toString()); } 
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