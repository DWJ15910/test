<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	//년 or 월이 요청값에 넘어오지 않으면 오늘 날짜 년,월 출력
	if(request.getParameter("targetYear") == null
			||request.getParameter("targetMonth") == null) {
				Calendar c = Calendar.getInstance();
				targetYear = c.get(Calendar.YEAR);
				targetMonth = c.get(Calendar.MONTH);
				System.out.println("값없음");
			} else {
				targetYear = Integer.parseInt(request.getParameter("targetYear"));
				targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
				System.out.println("값있음");
			}
	
	System.out.println("scheduleList.targetYear-->" + targetYear);
	System.out.println("scheduleList.targetMonth-->" + targetMonth);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp">일정 리스트</a>
	</div>
	
	<h1>일정 리스트</h1>
</body>
</html>