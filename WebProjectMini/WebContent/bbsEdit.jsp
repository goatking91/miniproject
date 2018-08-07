<%@ page import="java.sql.*"  %>
<%@ include file="ssi.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[bbsEdit.jsp]</title>
	<link rel="stylesheet" href="./css/theme.min.css">
	<link rel="stylesheet" type="text/css" href="./css/bbsInputCSS.css">
	
	<script type="text/javascript" src="./smartEditor/dist/js/service/HuskyEZCreator.js" charset=UTF-8></script>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" charset=UTF-8></script>
	
	<script type="text/javascript">
		function Check(num){
			var title = myform.title.value;
			var content = myform.content.value;
			
			if(title == null || title == "")
			{
				alert("제목을 입력해주세요")
				myform.title.focus();
				return false;
			}
			
			if(content == null || content == "")
			{
				alert("내용을 입력해주세요")
				myform.content.focus();
				return false;
			}
			else
			{
				if(confirm("수정 완료하시겠습니까?")==true)
				{
					document.myform.submit();
				}
				else { return false; }
			 }
		}//Check end
		
		function fileDel() 
		{
			if(confirm("첨부파일을 삭제하시겠습니까?") == true)
			{
				var num = myform.num.value;
				var filename = myform.fileNameOld.value;
				var rfileName = myform.rfileNameOld.value;
				
				location.href ="bbsFileDelete.jsp?num=" + num + "&fileName=" + filename + "&rfileName=" + rfileName;
			}
			else { return false; }
		}
	</script>
	
	<script type="text/javascript">
		// 스마트 에디터
		var oEditors = [];
		
		$(function()
		{ 
			nhn.husky.EZCreator.createInIFrame (
			{
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
						} 
						//else { $("#writeForm").submit(); } //폼 submit
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
	String title = ""; // 제목
	String content = ""; // 내용
%>
<%
	try
	{
		data = request.getParameter("num");

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
		msg = msg + "  where  b_num = " + data;

		ST = CN.createStatement();
		RS = ST.executeQuery(msg);

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
	<form name="myform" id="writeForm"  enctype="multipart/form-data" method="post" action="bbsEditSave.jsp" onsubmit="Check(<%=Gbnum%>); return false;">
		<input type=hidden id="num" name="num" style="display: none;" value="<%=Gbnum%>">
		<div class="container">
			<div class="row">
			<div class="col-xs-12">
					<h2><input style="width:70%;" class="form-control" type="text" id="title" name="title"  value="<%=title%>"></h2>
				</div>
			</div>	
			<div class="row" >
				<div class="col-xs-6">
					첨부파일 : 
					<%
					if(Gfilename != null && Gfilename != "")
					{
					%>
						<input type="text" readonly id="fileNameOld" name="fileNameOld" value="<%=Gfilename%>" style="border: 0px; border:1px solid #ccc; ">
						<input type="hidden" style="display: none;"  id="rfileNameOld" name="rfileNameOld" value="<%=Grealfilename%>">
						<input type="button" class="btn btn-default btn-xs" style="margin: 0 0 5px 0;" id="BtnFileDel" name="BtnFileDel" onclick="fileDel(); return false;" value="삭제">
					<%
					}
					else
					{
					%>
						<input type="text" readonly id="fileNameOld" name="fileNameOld" style="border: 0px;">
						<input type="hidden" style="display: none;"  id="rfileNameOld" name="rfileNameOld">
					<%
					}
					%>
				</div>
				<div class="col-xs-6">
					<h6 style="float:right;">ID : <%=Gid%> | 작성자 : <%=Gname%> | 등록일 : <%=Gregdt%> | 조회수 : <%=Gcnt%></h6>
				</div>
			</div>
			<div class="row align-middle" >
				<div class="col-xs-12">
					<div class="tit"><textarea style="width:90%;" class="form-control" rows="10" id=content name=content><%=content%></textarea></div><!-- 내용위치 -->
				</div>
			</div>
			
			<div class="row" >
				<div class="col-xs-3 filebox">
               		<input class="upload-name" value="파일선택" disabled="disabled"> 
               		<label for="ex_filename">업로드</label> 
               		<input type="file" id="ex_filename" name="fileName" class="upload-hidden"> 
					<!-- <td><img src ="<%=request.getContextPath()%>/storage/<%=Gfilename %>"></td>  -->
				</div>
				<div class="col-xs-7"></div>
				<div class="col-xs-2">
					<input class="btn btn-success" type="submit" id="savebutton" value="수정">
					<input class="btn btn-danger" type="button" value="수정취소" onclick ="location.href ='bbsDetail.jsp?num=<%=data%>';">
				</div>
			</div>
		</div>
	</form>
<%
		} // while end
	}catch(Exception ex) { System.out.println(ex.toString()); }
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