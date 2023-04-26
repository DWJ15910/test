<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
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
		
		String sql1 = "select notice_no noticeNo,notice_title noticeTitle, createdate from notice order by createdate desc limit 0,5";
		String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		//내가보낸 문자열 모양의 쿼리를 mariadb가 실행 가능한 쿼리 형태로 변환
		
		System.out.println(stmt1 + "<--stmt1"); //stmt 정상 실행 확인
		System.out.println(stmt2 + "<--stmt2"); //stmt 정상 실행 확인
		
		ResultSet rs1 = stmt1.executeQuery();
		ResultSet rs2 = stmt2.executeQuery();
		
		//ArrayList Notice부분 데이터 추가
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs1.next()) {
			Notice n = new Notice();
			n.noticeTitle = rs1.getString("noticeTitle");
			n.noticeNo = rs1.getInt("noticeNo");
			n.createdate = rs1.getString("createdate");
			noticeList.add(n);
		}
		
		//ArrayList클래스에 scheduleList 변수를 선언하고 ArrayList의 객체를 생성한뒤 이를 변수에 할당한다
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()){
			Schedule s = new Schedule();
			s.scheduleNo = rs2.getInt("scheduleNo");
			s.scheduleDate = rs2.getString("scheduleDate");
			s.scheduleTime = rs2.getString("scheduleTime");
			s.scheduleMemo = rs2.getString("scheduleMemo");//10글자만출력
			scheduleList.add(s);
		}
	%>
	<h1>공지사항</h1>
	<table class="table table-striped">
		<tr>
			<th style="width:200px;">notice_no</th>
			<th style="width:800px;">notice_title</th>
			<th>createdate</th>
		</tr>
		<%
			for(Notice n : noticeList){
		%>
			<tr>
				<td><%=n.noticeNo %></td>
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
					<%=n.noticeTitle%>
					</a>
				</td>
				<td><%=n.createdate.substring(0,10) %></td>
			</tr>
		<%
			}
		%>
	</table>
	<h1>오늘일정</h1>
	<table class="table table-striped">
		<tr>
			<th style="width:200px;">schedule_date</th>
			<th style="width:200px;">schedule_time</th>
			<th>schedule_memo</th>
		</tr>
		<%
			//scheduleList객체에서 Schedule이라는 클래스의 객체를하나씩 가져와서 s라는 변수에 할당하는 반복문이다
			for(Schedule s : scheduleList){
		%>
			<tr>
				<td>
					<%=s.scheduleDate %>
				</td>
				<td>
					<%=s.scheduleTime%>
				</td>
				<td>	
					<a href="./scheduleListByDate.jsp?">
						<%=s.scheduleMemo%>
					</a>
				</td>
			</tr>
		<%
			}
		%>
	</table>
	<br>
	<h2>사용언어</h2>
	<div>JAVA</div>
	<h2>사용 프로그램</h2>
	<div>Eclipse,HeidSQL</div>
	<h2>사용기술</h2>
	<div>1. html</div>
	<div>2. css bootstrap</div>
	<div>3. java ArrayList를 통해서 rs.next를 교체</div>
	<div>4. MariaDB 와 연동하여 공지사항 리스트 추가</div>
	<div>5. 공지사항의 삽입, 삭제, 수정</div>
	<div>6. 스케쥴 일정 달력 추가</div>
	<div>7. 달력 날짜를 누른 뒤 삽입, 삭제, 수정</div>
	</div>
</body>
</html>