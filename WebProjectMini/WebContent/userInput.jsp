<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <!-- <meta http-equiv="X-UA-Compatible" content="ie=edge"> -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>userInput.jsp</title>

    <link rel="stylesheet" type="text/css" href="./css/userInputCSS.css">

    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script src="./js/userInputJS.js"></script>
</head>
<body>
	<jsp:include page="./Header.jsp"></jsp:include>
	<div class="container">
	    <div class="all" align="center">    
        <div class="cf"><br>*표는 필수 입력</div>
        <form name="iform" class="form-inline" method="post" onsubmit = "check(); return false;" action="userInputSave.jsp">
            <table class="table1" style="width:100%;">
                <tr>
                    <th>*ID</th>
                    <td>
                        <input class="form-control" type="text" size="10" name="id" onkeyup="checklen(this,4)" readonly placeholder="숫자4자리">
                    	<input class="btn btn-default" type="button" onclick="checkId()" value="중복확인">
					</td>
                </tr>
                <tr>
                    <th>*이름</th>
                    <td><input class="form-control" type="text" name="name" onkeyup="checklen(this,15)"></td>
                </tr>
                <tr>
                    <th>*비밀번호</th>
                    <td><input class="form-control" type="password" name="pwd" onkeyup="checklen(this,10)"></td>
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
                        <input class="form-control" type="text" size="10" id="postcode" name="postcode" readonly>
                        <input class="btn btn-default" type="button" onclick="DaumPostcode()" value="우편번호"><br>
                        <input class="form-control" type="text" size="60" id="juso1" name="juso1" readonly  style="margin-top: 10px;"><br>
                        <input class="form-control" type="text" size="60" id="juso2" name="juso2" onkeyup="checklen(this,30)"  style="margin-top: 10px;"> 상세주소 입력하세요
                    </td>
                </tr>
                <tr>
                    <th>*전화번호</th>
                    <td>
                        <input class="form-control" type="text" size="4" name="num1" onchange="num()" maxlength="4">-
                        <input class="form-control" type="text" size="4" name="num2" onchange="num()" maxlength="4">-
                        <input class="form-control" type="text" size="4" name="num3" onchange="num()" maxlength="4">&nbsp;
                        <label id="numlabel">&nbsp;&nbsp;숫자3~4자리 입력하세요</label>
                    </td>
                </tr>
                <tr>
                    <th>*email</th>
                    <td>
                        <input class="form-control" type="text" size="40" name="email" onblur="emailcheck()" onkeyup="checklen(this,30)" placeholder="aaa@aaa.aa형식으로 입력">
                        <span id="email_ch"></span>
                    </td>
                </tr>
                
                <tr>
                    <th>닉네임</th>
                    <td>
                    	<input class="form-control" type="text" name="nickname" onkeyup="checklen(this,15)">
                    	<input type="checkbox" name="nicknameYN" value="Y">닉네임 사용여부
                    </td>
                </tr>
            </table>
            <p>
            <input class="btn btn-warning" type="submit" value="등록">&nbsp;
            <input class="btn btn-warning" type="reset" value="초기화" onclick="checkrs();">&nbsp;
            <input class="btn btn-warning" type="button" value="메인" onclick="location.href='index.jsp'">
        </form> 
	    </div>
    </div>
    <jsp:include page="./Footer.jsp"></jsp:include>    
</body>
</html>