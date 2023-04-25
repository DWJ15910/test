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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp">일정 리스트</a>
	</div>
	<h1>공지 삭제</h1>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th style="width:200px;">notice_no</th>
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
					<button class="btn btn-secondary" type="submit">입력</button>
				</td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>