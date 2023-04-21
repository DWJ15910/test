<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("성공");

	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "select * from student;";
	
	PreparedStatement stmt = conn.prepareStatement(sql);//sql을 쿼리문으로 변경
	ResultSet student = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	table,td,th {
		border: 1px solid #000000;
	}
</style>
</head>
<body>
	<table>
		<tr>
			<th>student_no</th>
			<th>student_name</th>
			<th>student_age</th>
		</tr>
		<%
			while(student.next()){
		%>
			<tr>
				<td><%=student.getInt("s_no")%></td>
				<td><%=student.getString("s_name")%></td>
				<td><%=student.getInt("s_age")%></td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>