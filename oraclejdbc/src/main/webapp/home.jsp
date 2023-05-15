<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	String loginMemberId = (String)session.getAttribute("loginMemberId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<a href="<%=request.getContextPath() %>/employee/employeeList.jsp">게시판으로</a>
	<a href="<%=request.getContextPath() %>/employee/addEmployee.jsp">데이터 추가</a>
	
	<%
				if(session.getAttribute("loginMemberId")==null){//로그인전이면 로그인폼 출력
			%>
					<form action="<%=request.getContextPath() %>/loginAction.jsp" method="post">
						<h2>로그인</h2>
						<table class="table">
							<tr>
								<td>employee_id</td>
								<td><input class="form-control" type="text" name="employeeId"></td>
							</tr>
							<tr>
								<td>first_name</td>
								<td><input class="form-control" type="text" name="firstName"></td>
							</tr>
							<tr>
								<td>last_name</td>
								<td><input class="form-control" type="text" name="lastName"></td>
							</tr>
						</table>
						<button class="btn btn-primary" type="submit">로그인</button>
					</form>
					
			<%
				}else{
			%>
					<table class="table table-hover">
						<tr>
							<td><%=loginMemberId %>님 접속중 입니다</td>
						</tr>
					</table>
					<a href="<%=request.getContextPath() %>/employee/logoutAction.jsp">로그아웃</a>
			
			<%	
				}
			%>
			
	<!-- 메시지 출력 -->
		<div style="color: red;">
			<%
				if(request.getParameter("msg") != null){
			%>
					<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>
		</div>
</body>
</html>