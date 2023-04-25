<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//유효성 검사
	if(request.getParameter("scheduleNo")==null
		||request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("updateform오류");
		return;
	}

	//값 불러오기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	//드라이버 연결확인
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("Form 드라이버 연결확인");
	
	//DB연결확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + "<--DB연결확인");
	
	//sql구문 작성 및 db에서 사용가능하게 변환
	String sql = "select schedule_no scheduleNo, createdate,updatedate from schedule where schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<--stmt1 확인");
	
	//?값 넣기
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt + "<--stmt2확인");
	
	//stmt를 Result타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--rs");
	
	//ArrayList<Schedule>클래스의 새로운 변수 scheudleList를 선언하고
	//ArrayList<Schedule>클래스의 새로운 객체를 생성하여 이를 scheduleList에 할당한다
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		//Class Schedule 의 변수 s에 Schedule클래스의 새로운 객체의 값을 할당한다.
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		
		//scheduleList라는 ArrayList에 add라는 메서드를 통해 s라는 객체를 추가하는것
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
	<h1>수정하기</h1>
	<form action="./updateScheduleAction.jsp">
		<table class="table table-striped">
			<%
				for(Schedule s : scheduleList){
			%>
			<tr>
				<th>schedule_no</th>
				<td><input type ="text" name="scheduleNo" readonly="readonly" value="<%=s.scheduleNo%>"></td>
			</tr>
			<tr>
				<th>schedule_pw</th>
				<td><input type ="text" name="schedulePw"></td>
			</tr>
			<tr>
				<th>schedule_date</th>
				<td><input type="date" name="scheduleDate"></td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td><input type="color" name="scheduleColor"></td>
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
					<button type="submit" class="btn btn-secondary">수정</button>
				</td>
			</tr>
			<%
				}
			%>
		</table>
	</form>
	</div>
</body>
</html>