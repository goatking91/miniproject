<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file ="ssi.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <!-- <meta http-equiv="X-UA-Compatible" content="ie=edge"> -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>userEdit.jsp</title>

    <link rel="stylesheet" type="text/css" href="./css/userInputCSS.css">
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script src="./js/userEditJS.js"></script>
</head>
<body onload="num(); emailcheck();">
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
	String pwd = "";
	String juso1 = "";
	String juso2 = "";
	int postcode = 0;
	String email = "";
	String phone = "";
	String num1 = "";
	String num2 = "";
	String num3 = "";
	String nickname = "";
	String nicknameYN = "";
%>

<%
	request.setCharacterEncoding("UTF-8");

	Gid = Integer.parseInt(request.getParameter("idx"));

	msg = "";
	msg = msg + " select   u_id, u_pwd, nvl(u_name, '') as u_name, nvl(u_nickname, '') as u_nickname " + "\n";
	msg = msg + "        , nvl(u_nicknameYN, 'N') as u_nicknameYN " + "\n";
	msg = msg + "        , u_postcode, nvl(u_juso1, '') as u_juso1, nvl(u_juso2, '') as u_juso2 " + "\n";
	msg = msg + "        , nvl(u_phone, '') as u_phone, nvl(u_email, '') as u_email " + "\n";
	msg = msg + "        , u_regdate " + "\n";
	msg = msg + "   from userinfo " + "\n";
	msg = msg + "  where u_id = " + Gid;
	
	ST=CN.createStatement();
	RS=ST.executeQuery(msg);
	
	while(RS.next()==true)
	{
		Gid = RS.getInt("u_id");
		Gname = RS.getString("u_name");
		Gnickname = RS.getString("u_nickname");
		pwd = RS.getString("u_pwd");
		juso1 = RS.getString("u_juso1");
		juso2 = RS.getString("u_juso2");
		postcode = RS.getInt("u_postcode");
		email = RS.getString("u_email");
		phone = RS.getString("u_phone"); // 핸드폰번호(xxx-xxxx-xxxx)
		nickname = RS.getString("u_nickname");
		nicknameYN = RS.getString("u_nicknameYN");
	}
	
	num1 = phone.substring(0, phone.indexOf("-"));
	num2 = phone.substring((phone.indexOf("-"))+1, phone.lastIndexOf("-"));
	num3 = phone.substring((phone.lastIndexOf("-"))+1, phone.length());
	
	if(Gnickname == null) { Gnickname = ""; }
	else { Gnickname = Gnickname.trim(); }
	
	if(nicknameYN == null || nicknameYN.equals("")) { nicknameYN = "N"; }
%>

	<div class="container">
	    <div class="all" align="center">    
        <div class="cf"><br>*표는 필수 입력</div>
            <form name="iform" class="form-inline" method="post" action="userEditSave.jsp" onsubmit = "check(); return false;">
            <table class="table1" style="width:100%">
                <tr>
                    <th>*ID</th>
                    <td>
                    	<input class="form-control" type="text" size="10" name="id" onkeyup="checklen(this,4)" value="<%=Gid%>" readonly placeholder="숫자4자리">
                    </td>
                </tr>
                <tr>
                    <th>*이름</th>
                    <td><input class="form-control" type="text" name="name" onkeyup="checklen(this,15)" value="<%=Gname%>" readonly></td>
                </tr>
                
                
                <tr>
                    <th>*비밀번호</th>
                    <td><input class="form-control" type="password" value=<%=pwd %> name="pwd" onkeyup="checklen(this,10)"></td>
                </tr>
                <tr>
                    <th>*비밀번호 확인</th>
                    <td>
                        <input class="form-control" type="password" name="pwd2" onkeyup="checkPwd();">
                        <label id="pwdlabel">&nbsp;&nbsp;비밀번호를 한번 더 입력해주세요</label>
                    </td>
                </tr>
                <tr>
                    <th>*주소</th>
                    <td>
                        <input class="form-control" type="text" size="10" id="postcode" name="postcode" value=<%=postcode %> readonly>
                        <input class="btn btn-default" type="button" onclick="DaumPostcode()" value="우편번호"><p>
                        <input class="form-control" type="text" size="60" id="juso1" name="juso1" value=<%=juso1 %> readonly style="margin-top: 10px;"><br>
                        <input class="form-control" type="text" size="60" id="juso2" name="juso2" value=<%=juso2 %> onkeyup="checklen(this,30)" style="margin-top: 10px;">&nbsp;&nbsp;상세주소를 입력하세요.<br>
                    </td>
                </tr>
                <tr>
                    <th>*핸드폰번호</th>
                    <td>
                        <input class="form-control" type="text" size="4" name="num1" value=<%=num1 %> onkeyup="num()" maxlength="4">-
                        <input class="form-control" type="text" size="4" name="num2" value=<%=num2 %> onkeyup="num()" maxlength="4">-
                        <input class="form-control" type="text" size="4" name="num3" value=<%=num3 %> onkeyup="num()" maxlength="4">&nbsp;
                        <label id="numlabel">&nbsp;&nbsp;숫자3~4자리 입력하세요</label>
                    </td>
                </tr>
                <tr>
                    <th>*email</th>
                    <td>
                        <input class="form-control" type="text" size="40" name="email" value=<%=email %> onblur="emailcheck()" onkeyup="checklen(this,30)" placeholder="aaa@aaa.aa형식으로 입력">
                        <span id="email_ch"></span>
                    </td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td>
	                    <input class="form-control" type="text" value="<%=Gnickname%>" name="nickname" onkeyup="checklen(this,15)">
	                    <input class="form-control" type="checkbox" name="nicknameYN" value='<%=nicknameYN%>' <%if(nicknameYN.equals("Y")) {out.println("checked=checked"); } %>>닉네임 사용여부
                    </td>
                </tr>
            </table>
            <p>
            <input class="btn btn-warning" type="submit" value="수정">&nbsp;
            <input class="btn btn-warning" type="button" value="메인" onclick="location.href='index.jsp'">
        </form> 
  
    </div>
    </div>
	<jsp:include page="./Footer.jsp"></jsp:include>          
</body>
</html>