<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="ssi.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>[bbsInput.jsp]</title>

    <link rel="stylesheet" type="text/css" href="./css/bbsInputCSS.css">
    
    <script type="text/javascript" src="./smartEditor/dist/js/service/HuskyEZCreator.js" charset=UTF-8></script>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" charset=UTF-8></script>

	<script type="text/javascript">
		function bbsinput() 
		{
			var title = myform.title.value;
			var content = myform.content.value;
			
			if(title == null) { title = ""; } else { title = title.trim(); }
			if(content == null) { content = ""; } else { content = content.trim(); }

			if(title == "")
			{
				alert("제목을 입력해주세요.");
				myform.title.focus();
				return false;
			}
			
			if(content == "")
			{
				alert("내용을 입력해주세요.");
				myform.content.focus();
				return false;
			}

			document.myform.submit();
		}// bbsinput end
		
		// 스마트 에디터
		var oEditors = [];
		
		$(function(){ 
			nhn.husky.EZCreator.createInIFrame ({
			oAppRef: oEditors, 
			elPlaceHolder: "content",  // editor => content
			//SmartEditor2Skin.html 파일이 존재하는 경로 
			sSkinURI: "./smartEditor/dist/SmartEditor2Skin.html",	
			htParams : { 
				// 툴바 사용 여부 (true:사용/ false:사용하지 않음) 
				bUseToolbar : true,	
				// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음) 
				bUseVerticalResizer : true,	
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음) 
				bUseModeChanger : true,	
				fOnBeforeUnload : function(){ } 
				}, 
				
				//수정할때 사용
				/* fOnAppLoad : function(){ 
					//기존 저장된 내용의 text 내용을 에디터상에 뿌려주고자 할때 사용 --> json방식 사용시.
					oEditors.getById["editor"].exec("PASTE_HTML", ["기존 DB에 저장된 내용을 에디터에 적용할 문구"]); 
				}, */
				fCreator: "createSEditor2" 
			});
		
		// 전송버튼 처리
		$("#savebutton").click(function() {
				//id가 smarteditor인 textarea에 에디터에서 대입
				oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
				
				var content = $('#content').val();
					
					if (title == '' || content == '' || content == '<p>&nbsp;</p>') 
					{
						alert("내용을 입력하세요.");	
						return false;
					} else {
						//폼 submit
						$("#writeForm").submit();
					}
			})
			
		$("#resetbutton").click(function() 
		{
			oEditors.getById["content"].exec("SET_IR", [""]);
		})
	});
		
	$(document).ready(function(){ 
		var fileTarget = $('.filebox .upload-hidden'); 
		fileTarget.on('change', function(){ // 값이 변경되면 
			if(window.FileReader){ // modern browser 
				var filename = $(this)[0].files[0].name; 
			} else { // old IE 
				var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출 
			} 
		
		// 추출한 파일명 삽입 
		$(this).siblings('.upload-name').val(filename); 
		}); 
	});

	</script>
</head>
<body>
	<jsp:include page="./Header.jsp"></jsp:include>

<%
	String sId = null;
    		
    if(session.getAttribute("userid") != null)
    {
    	sId = String.valueOf(session.getAttribute("userid"));
    	System.out.println(sId);
    }
    else
    {
    	response.sendRedirect("index.jsp");
    }
%>
	<div class="container">
	    <div class="all" align="center">    
	            <form name="iform" id="writeForm" class="form-inline" method="post" enctype="multipart/form-data" action="bbsInputSave.jsp" onsubmit="bbsinput(); return false;">
	            <table class="table1" style="width: 100%;">
	                <tr>
	                    <th>아이디</th><!--id,이름(닉네임 변경가능)고정-->
	                    <td>
	                        <input class="form-control" type="text" size="25" name="id" class="id" readonly value="<%=sId%>" style="background-color: transparent; border: 0px; box-shadow: inset 0 0px 0 rgba(0,0,0,.075);"> 
	                    </td>
	                </tr>
	
	                <tr>
	                    <th>제목</th>
	                    <td>
	                        <input class="form-control" type="text" name="title" placeholder="제목을 입력해주세요!" style="width: 65%;">                       
	                    </td>
	                </tr>
	
	                <tr>
	                    <th>내용</th>
	                    <td>
	                        <textarea style="width:90%;" class="form-control" name="content" id="content" onkeyup="checklen(this,30)" rows="10" cols="70"  placeholder="내용을 입력해주세요!"></textarea>
	                    </td>
	                    </tr>
	                <tr>
	                    <th>파일등록</th>
	                    <td>
	                   	<div class="filebox"> 
	                   		<input class="upload-name" value="파일선택" disabled="disabled"> 
	                   		<label for="ex_filename">업로드</label> 
	                   		<input type="file" id="ex_filename" name="fileName" class="upload-hidden"> 
	                   	</div>
						</td>
	                </tr>
	            </table>
	
	            <p>
	            <input class="btn btn-info" type="submit" id="savebutton" value="등록">&nbsp;
	            <input class="btn btn-info" type="reset" value="초기화" id="resetbutton" >&nbsp;
	            <input class="btn btn-info" type="button" value="목록" onclick="location.href='bbsList.jsp'">
	        </form>
	    </div>
	</div>
<jsp:include page="./Footer.jsp"></jsp:include>
</body>
</html>