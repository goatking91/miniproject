// ====전역변수:각각 체크여부
var flag = false;//null체크여부
var flagP = false;//비번중복체크여부
var flagE = false;//이메일중복체크여부
var flagN = false;//번호체크여부

//====다 체크하고 submit
function check() 
{
	var id = iform.id.value;
	var name = iform.name.value;
	var pwd = iform.pwd.value;
	var pwd2 = iform.pwd2.value;
	var postcode = iform.postcode.value;
	var juso1 = iform.juso1.value;
	var juso2 = iform.juso2.value;
	var num1 = iform.num1.value;
	var num2 = iform.num2.value;
	var num3 = iform.num3.value;
	var email = iform.email.value;
	
	if (id == null || id == "") 
	{
		alert("아이디를 입력해주세요");
		iform.id.focus();
		return;
	}
	
	if (name == null || name == "") 
	{
		alert("이름을 입력해주세요");
		iform.name.focus();
		return;
	}
	
	if (pwd == null || pwd == "") 
	{
		alert("비밀번호를 입력해주세요");
		iform.pwd.focus();
		return;
	}
	
	if (pwd2 == null || pwd2 == "") 
	{
		alert("비밀번호를 재입력해주세요");
		iform.pwd2.focus();
		return;
	}
	
	if (postcode == null || postcode == "" || juso1 == null || juso1 == "" || juso2 == null || juso2 == "") 
	{
		alert("주소를 입력해주세요");
		iform.postcode.focus();
		return;
	}
	
	if (num1 == null || num1 == "" || num2 == null || num2 == "" || num3 == null || num3 == "") 
	{
		alert("전화번호를 입력해주세요");
		iform.num1.focus();
		return;
	}
	
	if (email == null || email == "") 
	{
		alert("이메일을 입력해주세요")
		iform.email.focus();
		return;
	}
	
	//== 위에 해당되는거 없으면 널체크 true
	flag = true;
	
	if (flagP == false) //비번 확인 틀렸을 때 
	{
		alert("비밀번호가 일치하지 않습니다")
		iform.pwd2.focus();
		return;
	}
	
	if (flagN == false) 
	{
		alert("전화번호를 올바르게 입력하세요");
		iform.num1.focus();
		return;
	}

	//위에 다 통과&체크 완료 후 submit
	if (flag == true && flagP == true && flagE == true && flagN == true) 
	{
		document.iform.submit();
	} 
	else { return; }
}//check end


//아이디 체크
function checkId() //사번 입력체크하고 중복확인 팝업창 열어주기 
{
	
	var popupX = (window.screen.width / 2) - (500 / 2);
	// 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음
	var popupY= (window.screen.height /2) - (130 / 2);
	// 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음
	
	window.open("openID.jsp", 'openID', 'menubar=no, statusbar=no, height=140, width=510, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
	
}//checkId end


//====비밀번호 확인
function checkPwd() //비밀번호 확인 체크 
{
	var str = document.getElementById("pwdlabel");
	if (iform.pwd.value == iform.pwd2.value) 
	{
		str.innerHTML = "비밀번호가 일치합니다";
		flagP = true;
	} 
	else 
	{
		str.innerHTML = "<font color='red'>비밀번호가 일치하지 않습니다</font>";
	}
}//checkPwd end

//===각각 데이터 입력 자리수 제한(db오류 안나게 바이트로 처리)
function checklen(obj, maxByte) //db데이터 사이즈에 맞는 길이 체크//html에 checklen(this,4)라고 써있음 
{
	var strValue = obj.value;
	var strLen = strValue.length;
	var totalByte = 0;
	var len = 0;
	var oneChar = "";
	var str2 = "";
	
	for (var i = 0; i < strLen; i++) //한글자씩 가져와서 
	{
		oneChar = strValue.charAt(i);
		if (escape(oneChar).length > 4) //길이가 4초과=유니코드/한글이면 
		{
			totalByte += 2; //2바이트로 넣어주고
		} 
		else 
		{
			totalByte++;//아니면 1바이트로 처리
		}
	}
	if (totalByte > maxByte) 
	{
		alert(maxByte + "Byte를 초과 입력 불가");
		str2 = strValue.substr(0, len);
		obj.value = str2;
	}
}// checklen end

//====email 형식체크
function emailcheck() 
{
	var mail = iform.email.value;
	var mail_reg = /^([\S]{2,16})@([a-zA-Z]{2,10})\.([a-zA-Z]{2,10})$/; ///\S => 공백문자가아닌 나머지문자를 사용하게 함. \s=>공백만 사용하게 함.
	
	if (mail_reg.test(mail) == false) 
	{
		msg = "<font color=red>이메일 형식 체크하세요</font>";
		document.getElementById("email_ch").innerHTML = msg;
		iform.email.focus;
		return;
	} 
	else 
	{
		flagE = true;
		document.getElementById("email_ch").innerHTML = "";
	}
}//emailcheck end


//====우편번호
function DaumPostcode() 
{
	new daum.Postcode
	({
		oncomplete:function(data) 
		{
			//팝업에서 검색결과 항목을 클릭했을 떄 실행할 코드를 작성하는 부분
			//각 주소의 노출 규칙에 따라 주소를 조합한다
			//내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기한다
			var fullAddr = '';//최종 주소 변수
			var extraAddr = '';//조합형 주소 변수
			
			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다
			if (data.userSelectedType === 'R') //사용자가 도로명 주소를 선택했을 경우 
			{
				fullAddr = data.roadAddress;
			} 
			else //사용자가 지번 주소를 선택했을 경우(J) 
			{
				fullAddr = data.jibunAddress;
			}
			
			//사용자가 선택한 주소가 도로명 타입일때 조합한다
			if (data.userSelectedType === 'R') //법적동명이 있을 경우 추가한다 
			{
				if (data.bname !== '') 
				{
					extraAddr += data.bname;
				}
			
				//건물명이 있을 경우 추가 한다
				if (data.buildingName !== '') 
				{
					extraAddr += (extraAddr !== '' ? ',' + data.buildingName : data.buildingName);
				}
				//조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종주소를 만든다
				fullAddr += (extraAddr !== '' ? '(' + extraAddr + ')' : '');
			}
			
			//우편번호와 주소 정보를 해당 필드에 넣는다
			document.getElementById('postcode').value = data.zonecode;//5자리 새우편번호 사용
			document.getElementById('juso1').value = fullAddr;
		
			//커서를 상세주소 필드로 이동한다
			document.getElementById('juso2').focus();
		}
	}).open();
}//DaumPostcode end


//====전화번호 입력확인
function num() 
{
	var str1 = iform.num1.value;
	var str2 = iform.num2.value;
	var str3 = iform.num3.value;
	var num_reg = /[0-9]{3,4}/;
	var label = document.getElementById("numlabel");
	var test1 = num_reg.test(str1);
	var test2 = num_reg.test(str2);
	var test3 = num_reg.test(str3);
	
	if (test1 == false || test2 == false || test3 == false) 
	{
		label.innerHTML = "&nbsp;숫자3~4자리 입력하세요";
	} 
	else 
	{
		label.innerHTML = '';
		flagN = true;
	}
}//num end
