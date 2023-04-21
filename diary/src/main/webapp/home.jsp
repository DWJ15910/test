<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
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
	
	<!-- 날짜순 최근 공지 5개 -->
	<%
		//select notice_title, createdate from notice
		//order by createdate desc 
		//limit 0,5;
		
		Class.forName("org.mariadb.jdbc.Driver"); //드라이버 부르기
		System.out.println("드라이버 정상 실행"); // 드라이버 정상 실행 확인
		
		//conn 객체 변수 클래스 타입 가능하면 객체와 비슷한 타입의 변수선언이 좋다
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		// 주소,사용자id,사용자pw
		// 주소는 프로토콜,ip주소or도메인,포트넘버
		PreparedStatement stmt = conn.prepareStatement("select notice_no,notice_title, createdate from notice order by createdate desc limit 0,5");
		//내가보낸 문자열 모양의 쿼리를 mariadb가 실행 가능한 쿼리 형태로 변환
		System.out.println(stmt + "<--stmt"); //stmt 정상 실행 확인
		
		ResultSet rs = stmt.executeQuery();
	%>
	<h1>공지사항</h1>
	<table class="table table-striped">
		<tr>
			<th>notice_no</th>
			<th>notice_title</th>
			<th>createdate</th>
		</tr>
		<%
			while(rs.next()){
		%>
			<tr>
				<td><%=rs.getInt("notice_no") %></td>
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=rs.getInt("notice_no")%>">
					<%=rs.getString("notice_title") %>
					</a>
				</td>
				<td><%=rs.getString("createdate").substring(0,10) %></td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>