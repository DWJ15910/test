<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	//오류날시 화면 출력
	if(request.getParameter("storeNo")==null){
		response.sendRedirect("./storeList.jsp");
		return;
	}
	
	//noticeNo값을 불러오는데 int타입으로 변환하여 부름(Integer.parseInt)
	int storeNo = Integer.parseInt(request.getParameter("storeNo"));
	System.out.println("updateForm storeNo값--> "+ storeNo);
	
	//괄호안에 있는 jdbc Driver를 로드
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("updateForm 드라이버 연결확인");
	
	//DB연결확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/homework0419","root","java1234");
	System.out.println("updateForm conn 출력확인-->" + conn);
	
	//sql구문 작성 및 db에서 사용가능하게 변환
	String sql = "select store_no, store_name, store_category, store_address, store_emp_cnt, store_begin, store_pw, createdate, updatedate from store where store_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("updateForm stmt1 출력확인-->" + stmt);
	
	//?값 넣기
	stmt.setInt(1, storeNo);
	System.out.println("updateForm stmt2 출력확인-->" + stmt);
	
	//stmt를 Result타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println("updateForm rs-->" + rs);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>수정페이지</h1>
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./storeList.jsp">스토어 리스트</a>
	</div>
	<form action="./updateStoreAction.jsp" method="post">
		<table class="table table-striped">
		<%
			if(rs.next()){
		%>
			<tr>
				<td>
					store_no
				</td>
				<td>
					<input type="number" name="storeNo" value="<%=rs.getInt("store_no")%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>
					store_pw
				</td>
				<td>
					<input type="password" name="storePw">
				</td>
			</tr>
			<tr>
				<td>
					store_name
				</td>
				<td>
					<input type="text" name="storeName" value="<%=rs.getString("store_name")%>">
				</td>
			</tr>
			<tr>
				<td>
					store_category
				</td>
				<td>
					<select name="storeCategory">
						<option value="<%=rs.getString("store_category")%>">현재: <%=rs.getString("store_category") %></option>
						<option value="한식">변경: 한식</option>
						<option value="일식">변경: 일식</option>
						<option value="중식">변경: 중식</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					store_address
				</td>
				<td>
					<input type="text" name="storeAddress" value="<%=rs.getString("store_address")%>">
				</td>
			</tr>
			<tr>
				<td>
					store_emp_cnt
				</td>
				<td>
					<input type="number" name="storeEmpCnt" value="<%=rs.getInt("store_emp_cnt")%>">
				</td>
			</tr>
			<tr>
				<td>
					store_begin
				</td>
				<td>
					<input type="date" name="storeBegin" value="<%=rs.getString("store_begin")%>">
				</td>
			</tr>
			<tr>
				<td>
					createdate
				</td>
				<td>
					<%=rs.getString("createdate") %>
				</td>
			</tr>
			<tr>
				<td>
					updatedate
				</td>
				<td>
					<%=rs.getString("updatedate") %>
				</td>
			</tr>
		</table>
		<%
			}
		%>
		<div>
			<button class="btn btn-secondary" type="submit">수정</button>
		</div>
	</form>
</body>
</html>