<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//오류날시 화면 출력
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	//noticeNo 값불러오기
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + "Form noticeNo값 확인");
	
	//드라이버 연결확인
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("Form 드라이버 연결확인");
	
	//DB연결확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + "<--DB연결확인");
	
	//sql구문 작성 및 db에서 사용가능하게 변환
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate, notice_pw noticePw from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<--stmt1 확인");
	
	//?값 넣기
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + "<--stmt2확인");
	
	//stmt를 Result타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--rs");
	
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
<title>updateNoticeForm</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	td{
		width:100px;
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
	<h1>수정페이지</h1>
	<div>
		<%
			if(request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
	</div>
	<form action="./updateNoticeAction.jsp" method="post">
		<table class="table table-striped">
		<%
			for(Notice n : noticeList){
		%>
			<tr>
				<th style="width:200px;">
					notice_no
				</th>
				<td>
					<input type="number" name="noticeNo" value="<%=n.noticeNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>
					notice_pw
				</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
			<tr>
				<td>
					notice_title
				</td>
				<td>
					<input type="text" name="noticeTitle" value="<%=n.noticeTitle%>">
				</td>
			</tr>
			<tr>
				<td>
					notice_content
				</td>
				<th style="width:200px;">
					<textarea rows="5" cols="80" name="noticeContent">
						<%=n.noticeContent%>
					</textarea>
				</th>
			</tr>
			<tr>
				<td>
					notice_writer
				</td>
				<td>
					<%=n.noticeWriter%>
				</td>
			</tr>
			<tr>
				<td>
					createdate
				</td>
				<td>
					<%=n.createdate%>
				</td>
			</tr>
			<tr>
				<td>
					updatedate
				</td>
				<td>
					<%=n.updatedate%>
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
	</div>
</body>
</html>