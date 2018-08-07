<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="ssi.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		* { font-size: 20pt; font-weight: bold; }
		a { text-decoration:none; font-size: 20pt; color: red; }
		a:hover { text-decoration:underline; font-size: 26pt; color: green; }
	</style>
</head>
<body>
	<!-- IdCheck_my.jsp 단독 실행하면 에러발생. -->
<%
	try
	{
		data = request.getParameter("userid"); //int iSearchSabun = Integer.parseInt(request.getParameter("sabun")); // --> openIDSave.jsp에서 전송한 sabun 추출.
		
		msg = "";
		msg = msg + " select  count(*) as CNT "; // CNT > 0 이면 존재하고 아니면 사용가능. 
		msg = msg + "   from  guest ";  
		msg = msg + "  where  sabun = " + data; //iSearchSabun

		ST = CN.createStatement();
		RS = ST.executeQuery(msg);
		
		while(RS.next() == true)
		{
			Gtotal = RS.getInt("CNT");
			
			if(Gtotal == 0) // 사용가능.
			{
				System.out.println(data + " 데이터는  사용가능합니다.");
%>
				<script type="text/javascript">
					alert(<%=data%> + "데이터는 사용가능합니다.");
					opener.myform.sabun.value = <%=data%>;
					opener.myform.name.focus();
					self.close();
				</script>
<%
			}
			else // 존재.
			{
				System.out.println(data + " 데이터는 이미 사용중입니다.");
%>
				<script type="text/javascript">
					alert(<%=data%> + " 데이터는 이미 사용중이라 사용할 수 없습니다.");
					opener.myform.sabun.value = "";
					opener.myform.sabun.focus();
					self.close();
				</script>
<%
			}
		} // while end
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