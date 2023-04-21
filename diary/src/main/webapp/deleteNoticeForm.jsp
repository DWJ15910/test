<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청 값 유효성 검사
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	//디버깅
	System.out.println(noticeNo+"<--deleteNoticeForm param noticeNo");
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>공지 삭제</h1>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table>
			<tr>
				<td>notice_no</td>
				<td>
					<input type = "text" name="noticeNo" value="<%=noticeNo%>"  readonly="readonly">
					<!-- 이것 또는 hidden type 사용 -->
				</td>
			</tr>
			<tr>
				<td>notice_pw</td>
				<td>
					<input type = "text" name="noticePw">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit">입력</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>