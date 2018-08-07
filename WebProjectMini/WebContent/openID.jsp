<%@include file="ssi.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>[openID.jsp]</title>
	<link rel="stylesheet" href="./css/theme.min.css">	
	<script type="text/javascript">
		function idCheck() 
		{
			var strId = subform.userid.value.trim();
			if(strId.length != 4) 
			{
				alert("아이디는 4자리입니다.");
				return false;
			}
			location.href = "openID.jsp?idx=" + strId;
		} //idCheck end
		
		function idSend() 
		{
			var idVal = subform.userid.value;
			var bFlagVal = subform.bFlag.value;

			if(bFlagVal == "true")
			{
				opener.iform.id.value = idVal;
				opener.iform.name.focus();
			}
			else
			{
				opener.iform.id.value = "";
				opener.iform.id.focus();
			}
			self.close();	
		} // idSend end
	</script>
</head>
<body>
	<!-- openID.jsp -->
	<form class="form-inline" name = "subform" method="post" onsubmit="idCheck(); return false;">
		<div class="container form-group">
			<h3>중복 체크</h3>
			<div class="row">
				<div class="col-xs-8"><input class="form-control input-xs" type="text" name="userid"  maxlength="4" placeholder="ID 입력"></div>
				<div class="col-xs-4">
					<input class="btn btn-warning" type="submit" value="중복체크">
					<input class="btn btn-warning" type="button" onClick="idSend();" value="적용">
				</div>
			</div>
			
			
			<input type="text" name="bFlag" value="false" style="width: 10pt; display: none;">
		</div>
	</form>
<%
	try
	{
		if(request.getParameter("idx") != null && request.getParameter("idx") != "" )
		{
			Gid = Integer.parseInt(request.getParameter("idx"));
			
			msg = "";
			msg = msg + " select  count(*) as CNT ";
			msg = msg + "   from  userInfo ";  
			msg = msg + "  where  u_id = " + Gid;
			
			ST = CN.createStatement();
			RS = ST.executeQuery(msg);
			
			while(RS.next() == true)
			{
				if(RS.getInt("CNT") == 0) // 사용할 수 있음.
				{
					%>
					<script type="text/javascript">
						subform.bFlag.value = "true";
						alert(<%=Gid%> + "데이터는 사용가능합니다.");
						subform.userid.value = <%=Gid%>;
						//iSend();
					</script>
					<%
				}
				else // 사용할 수 없음.
				{
					%>
					<script type="text/javascript">
						subform.bFlag.value = "false";
						alert(<%=Gid%> + " 데이터는 이미 사용중이라 사용할 수 없습니다.");
					</script>
					<%
				}
			}	
		}
	}catch(Exception ex) { System.out.println(ex.toString()); }
	finally
	{
		if(RS != null) { try{ RS.close(); } catch(Exception ex){} }
		if(ST != null) { try{ ST.close(); } catch(Exception ex){} }
		if(PST != null) { try{ PST.close(); } catch(Exception ex){} }
	}
%>
</body>
</html>