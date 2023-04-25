<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%	
	if(request.getParameter("noticeNo")==null) {
		response.sendRedirect("./noticeList.jsp");
		//나중에 응답할 내용을 공유:response
		return; //1) 코드진행종료 2) 반환값을 남길때 
	}
		
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버 부르기
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);//stmt에 첫번째 ? 값을 noticeNo로 바꿀것이다 //String값일 경우 작은 따옴표도 출시

	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeNo = rs.getInt("noticeNo");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		n.noticeWriter = rs.getString("noticeWriter");
		n.noticeContent = rs.getString("noticeContent");
		noticeList.add(n);
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
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp">일정 리스트</a>
	</div>
	<h1>공지 상세</h1>			

	<table class="table table-striped">
		<%
			for(Notice n : noticeList){
		%>
		<tr>
			<th style="width:200px;">notice_no</th>
			<td><%=n.noticeNo%></td>
		</tr>
		<tr>
			<th style="width:200px;">notice_title</th>
			<td><%=n.noticeTitle%></td>
		</tr>
		<tr>
			<th style="width:200px;">notice_content</th>
			<td><%=n.noticeContent%></td>
		</tr>
		<tr>
			<th style="width:200px;">notice_writer</th>
			<td><%=n.noticeWriter%></td>
		</tr>
		<tr>
			<th style="width:200px;">createdate</th>
			<td><%=n.createdate.substring(0,10) %></td>
		</tr>
		<tr>
			<th style="width:200px;">updatedate</th>
			<td><%=n.updatedate.substring(0,10) %></td>
		</tr>
	</table>
	<%
		}
	%>
	<div>
		<a class="btn btn-secondary" href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>">수정</a>
		<a class="btn btn-secondary" href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>">삭제</a>
	</div>
	</div>
</body>
</html>