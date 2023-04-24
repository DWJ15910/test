<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//요청 값 유효성 검사
	if(request.getParameter("scheduleNo")==null){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	//값 불러오기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	//디버깅
	System.out.println(scheduleNo+"<--delete scheduleNo");
	
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>삭제하기</h1>
	<form action="./deleteScheduleAction.jsp" method="post">
		<table>
			<tr>
				<td>schedule_no</td>
				<td>
					<input type = "text" name="scheduleNo" value="<%=scheduleNo%>"  readonly="readonly">
					<!-- 이것 또는 hidden type 사용 -->
				</td>
			</tr>
			<tr>
				<td>schedule_pw</td>
				<td>
					<input type = "text" name="schedulePw">
				</td>
			</tr>
			<tr>
			
				<td colspan="2">
					<button type="submit">삭제하기</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>