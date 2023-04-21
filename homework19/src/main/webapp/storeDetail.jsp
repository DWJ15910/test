<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	//storeNo값이 null값이면 storeList.jsp 페이지로 리턴
	if(request.getParameter("storeNo")==null) {
			response.sendRedirect("./storeList.jsp");
			return;
		}
	
	//sotreNo값 받아와서 Int 변수 선언
	int storeNo = Integer.parseInt(request.getParameter("storeNo"));
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/homework0419","root","java1234");
	
	//SQL 문자열 제작 및 DB가 실행가능한 쿼리문 형태로 변경
	String sql = "select store_no,store_name,store_category,store_address,store_emp_cnt,store_begin,createdate,updatedate from store where store_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//sql문의 첫 번째 ? 표에 값넣기
	stmt.setInt(1,storeNo);
	
	//stmt 쿼리데이터를 ResultSet타입으로 반환
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
	<h1>가게 상세정보</h1>
	<%
		//
		if(rs.next()){
	%>
	<table class="table table-striped">
		<tr>
			<th>가게번호</th>
			<td><%=rs.getInt("store_no") %></td>
		</tr>
		<tr>
			<th>가게이름</th>
			<td><%=rs.getString("store_name") %></td>
		</tr>
		<tr>
			<th>분류</th>
			<td><%=rs.getString("store_category") %></td>
		</tr>
		<tr>
			<th>주소</th>
			<td><%=rs.getString("store_address") %></td>
		</tr>
		<tr>
			<th>종업원 수</th>
			<td><%=rs.getInt("store_emp_cnt") %>명</td>
		</tr>
		<tr>
			<th>오픈 날짜</th>
			<td><%=rs.getString("store_begin") %></td>
		</tr>
		<tr>
			<th>등록 날짜</th>
			<td><%=rs.getString("createdate") %></td>
		</tr>
		<tr>
			<th>수정 날짜</th>
			<td><%=rs.getString("updatedate") %></td>
		</tr>
		</table>
		<%
		}
		%>
		<a class="btn btn-primary" href="./updateStoreForm.jsp?storeNo=<%=storeNo%>">수정</a>
		<a class="btn btn-primary" href="./deleteStoreForm.jsp?storeNo=<%=storeNo%>">삭제</a>
</body>
</html>