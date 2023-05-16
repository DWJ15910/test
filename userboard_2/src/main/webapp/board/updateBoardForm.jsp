<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//local테이블을 조회하여 select option으로 사용하기 위해 조회
	String sql = null;
	sql = "select local_name from local";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();

	//조회한 local테이블을 ArrayList로 만들어서 select option에 for문을 이용하여 구동
	ArrayList<Local> localNameList = new ArrayList<Local>();
	while(rs.next()){
		Local local = new Local();
		local.setLocalName(rs.getString("local_name"));
		localNameList.add(local);
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
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<hr>
		<form action = "<%=request.getContextPath() %>/board/updateBoardAction.jsp">
			<div style="color: red;">
				<%
					if(request.getParameter("msg") != null){
				%>
						<div><%=request.getParameter("msg") %></div>
				<%
					}
				%>
			</div>
			<h2>카테고리명 수정</h2>
			<hr>
			<table class="table">
				<tr>
					<th>이전 카테고리명</th>
				</tr>
				<tr>
					<td>
						<select name="local_name" class="form-select">
							<%
								for(Local local : localNameList) {
							%>
									<option value="<%=local.getLocalName()%>"><%=local.getLocalName() %></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>카테고리명 수정</th>
				</tr>
				<tr>
					<td><input class="form-control" type ="text" name="local_name2"></td>
				</tr>
				<tr>
					<td>
						<button class="btn btn-primary" type="submit">수정</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>