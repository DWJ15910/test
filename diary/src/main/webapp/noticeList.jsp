<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 요청 분석(currentPage, ...)
	
	//현재페이지
	int currentPage = 1;

	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "currentPage");
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행 번호
	int startRow = (currentPage-1)*rowPerPage;
	//currentaPage startRow(rowPerPage가 10일때)
	//1				0 <-- (currentPage-1)*rowPerPage
	//2				10
	//3				20
	
	// DB연결 설정	
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버 부르기
	System.out.println("드라이버 정상 실행"); // 드라이버 정상 실행 확인
	
	//conn 객체 변수 클래스 타입 가능하면 객체와 비슷한 타입의 변수선언이 좋다
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");

	//내가보낸 문자열 모양의 쿼리를 mariadb가 실행 가능한 쿼리 형태로 변환
	PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo,notice_title noticeTitle, createdate from notice order by createdate desc limit ?,?");
	
	//sql문의 ?값 출력
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowPerPage);
	
	//출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	
	//마지막 페이지
	// select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0;
	if(rs2.next()) {
			totalRow = rs2.getInt("count(*)");
		}
	int lastPage = totalRow/rowPerPage;
	if(totalRow % rowPerPage !=0){
		lastPage=lastPage+1;
	}
	
	//자료구조 ResultSet 타입을 일반적인 자료구조타입(자바 배열or 기본API 자료구조 타입 List, Set, Map)
	// ResultSet -. ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeNo = rs.getInt("noticeNo");
		n.createdate = rs.getString("createdate");
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
<style>
	a{
		text-decoration: none;
		color: #FF00FF;
		font-size: 12pt;
	}
	
</style>
</head>
<body>
	<div class="container">
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp">일정 리스트</a>
	</div>
	<h1>공지사항 리스트</h1>
	
	<a class="btn btn-secondary" href="./insertNoticeForm.jsp">공지입력</a>
	
	<table class="table table-striped">
		<tr>
			<th style="width:200px;">notice_no</th>
			<th style="width:800px;">notice_title</th>
			<th>createdate</th>
		</tr>
		<%
			for(Notice n : noticeList) {
		%>
			<tr>
				<td><%=n.noticeNo %></td>
				<td>
					<a style="color: #FF00FF;" href="./noticeOne.jsp?noticeNo=<%=n.noticeNo %>">
					<%=n.noticeTitle %>
					</a>
				</td>
				<td><%=n.createdate.substring(0,10) %></td>
			</tr>
		<%
			}
		%>
	</table>
	<div style="text-align: center">
	<%
		if(currentPage>1){
	%>
		<a class="btn btn-primary" href="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	
	if(currentPage<lastPage){
	%>
		<a class="btn btn-primary" href="./noticeList.jsp?currentPage=<%=currentPage%>"><%=currentPage %>페이지</a>
		<a class="btn btn-primary" href="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
	</div>

	<%
	}
	%>
	</div>
</body>
</html>