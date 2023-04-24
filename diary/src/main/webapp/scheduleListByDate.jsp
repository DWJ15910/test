<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
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
	String sql = "select * from schedule where schedule_date=? order by schedule_time ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,y+"-"+m+"-"+d);
	
	ResultSet rs = stmt.executeQuery();
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
			while(rs.next()){
		%>
		<table class="table table-striped" style="width: 50%;">
		<tr>
			<th style="width: 20%;">schedule_no</th>
			<td><%=rs.getString("schedule_no") %></td>
		</tr>
		<tr>
			<th>schedule_date</th>
			<td><%=rs.getString("schedule_date") %></td>
		</tr>
		<tr>
			<th>schedule_time</th>
			<td><%=rs.getString("schedule_time") %></td>
		</tr>
		<tr>
			<th>schedule_memo</th>
			<td><%=rs.getString("schedule_memo") %></td>
		</tr>
		<tr>
			<th>schedule_color</th>
			<td><%=rs.getString("schedule_color") %></td>
		</tr>
		<tr>
			<th>createdate</th>
			<td><%=rs.getString("createdate") %></td>
		</tr>
		<tr>
			<th>updatedate</th>
			<td><%=rs.getString("updatedate") %></td>
		</tr>
		<tr>
			<td colspan="2">
				<a href="./updateScheduleForm.jsp?scheduleNo=<%=rs.getInt("schedule_no")%>">수정</a>
				<a href="./deleteScheduleForm.jsp?scheduleNo=<%=rs.getInt("schedule_no")%>">삭제</a>
			</td>
		</tr>
			</table>
			<br>
		<%
			}
		%>

</body>
</html>