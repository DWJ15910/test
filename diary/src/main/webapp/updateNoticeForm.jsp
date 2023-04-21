<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
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
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate, notice_pw from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<--stmt1 확인");
	
	//?값 넣기
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + "<--stmt2확인");
	
	//stmt를 Result타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--rs");
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
			if(rs.next()){
		%>
			<tr>
				<td>
					notice_no
				</td>
				<td>
					<input type="number" name="noticeNo" value="<%=rs.getInt("notice_no")%>" readonly="readonly">
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
					<input type="text" name="noticeTitle" value="<%=rs.getString("notice_title")%>">
				</td>
			</tr>
			<tr>
				<td>
					notice_content
				</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent">
						<%=rs.getString("notice_content") %>
					</textarea>
				</td>
			</tr>
			<tr>
				<td>
					notice_writer
				</td>
				<td>
					<%=rs.getString("notice_writer") %>
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