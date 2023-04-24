<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
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
	String sql = "select * from schedule where schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<--stmt1 확인");
	
	//?값 넣기
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt + "<--stmt2확인");
	
	//stmt를 Result타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--rs");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="./updateScheduleAction.jsp">
		<table>
			<%
				while(rs.next()){
			%>
			<tr>
				<th>schedule_no</th>
				<td><input type ="text" name="scheduleNo" readonly="readonly" value="<%=rs.getInt("schedule_no")%>"></td>
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
				<td><%=rs.getString("createdate") %></td>
			</tr>
			<tr>
				<th>updatedate</th>
				<td><%=rs.getString("updatedate") %></td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit">수정</button>
				</td>
			</tr>
			<%
				}
			%>
		</table>
	</form>
</body>
</html>