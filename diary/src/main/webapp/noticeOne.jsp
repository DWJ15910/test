<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%	
	if(request.getParameter("noticeNo")==null) {
		response.sendRedirect("./noticeList.jsp");
		//나중에 응답할 내용을 공유:response
		return; //1) 코드진행종료 2) 반환값을 남길때 
	}
		
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버 부르기
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);//stmt에 첫번째 ? 값을 noticeNo로 바꿀것이다 //String값일 경우 작은 따옴표도 출시

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
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./diaryList.jsp">일정 리스트</a>
	</div>
	<h1>공지 상세</h1>
	<%
		if(rs.next()){
	%>
			

	<table class="table table-striped">
		<tr>
			<td>notice_no</td>
			<td><%=rs.getInt("notice_no") %></td>
		</tr>
		<tr>
			<td>notice_title</td>
			<td><%=rs.getString("notice_title") %></td>
		</tr>
		<tr>
			<td>notice_content</td>
			<td><%=rs.getString("notice_content") %></td>
		</tr>
		<tr>
			<td>notice_writer</td>
			<td><%=rs.getString("notice_writer") %></td>
		</tr>
		<tr>
			<td>createdate</td>
			<td><%=rs.getString("createdate").substring(0,10) %></td>
		</tr>
		<tr>
			<td>updatedate</td>
			<td><%=rs.getString("updatedate").substring(0,10) %></td>
		</tr>
	</table>
	<%
		}
	%>
	<div>
		<a class="btn btn-secondary" href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>">수정</a>
		<a class="btn btn-secondary" href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>">삭제</a>
	</div>
</body>
</html>