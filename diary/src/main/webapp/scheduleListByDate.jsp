<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//y,m,d 값이 null or "'-> redrection
	if(request.getParameter("y")==null
		||request.getParameter("m")==null
		||request.getParameter("d")==null
		||request.getParameter("y").equals("")
		||request.getParameter("m").equals("")
		||request.getParameter("d").equals("")){
		
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
		
	
	int y = Integer.parseInt(request.getParameter("y"));
	//자바 API 12월은 11이다, 마리아DB에서는 12월은 12이다
	int m = Integer.parseInt(request.getParameter("m"))+1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println("bydate.y-->" + y);
	System.out.println("bydate.m-->" + m);
	System.out.println("bydate.d-->" + d);
	
	String strM = m+"";
	if(m<10){
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10){
		strD = "0"+strD;
	}
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//sql구문
	String sql = "select schedule_no scheduleNo,schedule_date scheduleDate,schedule_time scheduleTime,schedule_memo scheduleMemo,schedule_color scheduleColor,createdate,updatedate from schedule where schedule_date=? order by schedule_time ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,y+"-"+m+"-"+d);
	
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
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
	<a href="./scheduleList.jsp" class="btn btn-secondary">홈으로</a>
	<h1>스케줄 입력</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th>schedule_date</th>
				<td>
					<input type="date" name="scheduleDate"
					value="<%=y%>-<%=strM%>-<%=strD%>" 
					readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>schedule_pw</th>
				<td>
					<input type="password" 
					name="schedulePw">
				</td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td>
					<input type="time" 
					name="scheduleTime">
				</td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" 
					value="#000000" 
					name="scheduleColor">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td>
					<textarea rows="3" cols="80" name="scheduleMemo"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button class="btn btn-secondary" type="submit">추가</button>
				</td>
			</tr>
		</table>
	</form>
	<h1><%=y %>년<%=m %>월<%=d %>일 스케쥴 목록</h1>
		<%
			for(Schedule s : scheduleList){
		%>
		<table class="table table-striped">
		<tr>
			<th style="width: 20%;">schedule_no</th>
			<td><%=s.scheduleNo%></td>
		</tr>
		<tr>
			<th>schedule_date</th>
			<td><%=s.scheduleDate%></td>
		</tr>
		<tr>
			<th>schedule_time</th>
			<td><%=s.scheduleTime%></td>
		</tr>
		<tr>
			<th>schedule_memo</th>
			<td><%=s.scheduleMemo%></td>
		</tr>
		<tr>
			<th>schedule_color</th>
			<td><%=s.scheduleColor%></td>
		</tr>
		<tr>
			<th>createdate</th>
			<td><%=s.createdate%></td>
		</tr>
		<tr>
			<th>updatedate</th>
			<td><%=s.updatedate%></td>
		</tr>
		<tr>
			<td colspan="2">
				<a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-secondary">수정</a>
				<a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-secondary">삭제</a>
			</td>
		</tr>
			</table>
			<br>
		<%
			}
		%>
	</div>
</body>
</html>