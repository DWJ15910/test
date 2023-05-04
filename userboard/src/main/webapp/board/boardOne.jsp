<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//boardNo 받기 위해 초기선언
	int boardNo = 0;
	//boardNo가 null이 아니면 boardNo값 을 boardNo에 선언
	if(request.getParameter("boardNo")!=null){
		boardNo = Integer.parseInt(request.getParameter("boardNo"));
		System.out.println("boardOne.boardNo값 받아옴");
	} else {
	//null값이 왔을경우 home으로 이동
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//DB 연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//상세페이지출력용 SQL쿼리에 사용할 stmt,rs 출력
	//댓글 출력용 SQL쿼리에 사용할 stmt,rs 출력
	PreparedStatement oneStmt = null;
	PreparedStatement commentStmt = null;
	ResultSet oneRs = null;
	ResultSet commentRs = null;
	
	//상세페이지용 쿼리문 작성
	String oneListSql = null;
	oneListSql = "SELECT board_no boardNo,local_name localName,board_title boardTitle,board_content boardContent, member_id memberId,createdate,updatedate FROM board WHERE board_no = ?";
	oneStmt = conn.prepareStatement(oneListSql);
	oneStmt.setInt(1,boardNo);
	oneRs = oneStmt.executeQuery();
	//디버깅
	System.out.println("oneStmt-->"+oneStmt);
	System.out.println("oneRs-->"+oneRs);
	
	//댓글용 쿼리문 작성
	String commentSql = null;
	commentSql = "SELECT member_id memberId, comment_text commentText,createdate FROM comment WHERE board_no=? order by createdate DESC";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1,boardNo);
	commentRs = commentStmt.executeQuery();
	//디버깅
	System.out.println("commentStmt-->"+commentStmt);
	System.out.println("commentRs-->"+commentRs);
	
	//댓글내용을 배열에 저장하기 위해 class작성 및 배열에 선언
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment c = new Comment();
		c.memberId = commentRs.getString("memberId");
		c.commentText = commentRs.getString("commentText");
		c.createdate = commentRs.getString("createdate");
		commentList.add(c);
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
	.con {
	  width: 50%; /* 원하는 크기로 조정 */
	  height: auto; /* 내용에 따라 크기 조정 */
	  margin: 0 auto;
	}
	.btn_1 {
		float:right;
	}
</style>
</head>
<body>
	<div class="con">
	
		<!-- 상세페이지 출력 -->
		<h2>상세페이지</h2>
		<table class="table">
			<%
				//단일 이기 때문에 배열에 rs를 저장하지 않고 바로 출력
				while(oneRs.next()){
			%>
				<tr>
					<th>board_no</th>
					<td><%=oneRs.getInt("boardNo") %></td>
				</tr>
				<tr>
					<th>local_name</th>
					<td><%=oneRs.getString("localName") %></td>
				</tr>
				<tr>
					<th>board_title</th>
					<td><%=oneRs.getString("boardTitle") %></td>
				</tr>
				<tr>
					<th>board_content</th>
					<td><%=oneRs.getString("boardContent") %></td>
				</tr>
				<tr>
					<th>member_id</th>
					<td><%=oneRs.getString("memberId") %></td>
				</tr>
				<tr>
					<th>createdate</th>
					<td><%=oneRs.getString("createdate") %></td>
				</tr>
				<tr>
					<th>updatedate</th>
					<td><%=oneRs.getString("updatedate") %></td>
				</tr>
			<%
				}
			%>
		</table>
		
		<!-- 댓글 입력 란 -->
		<h2>댓글</h2>
		<form action="<%=request.getContextPath() %>/board/boardCommentAction.jsp">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<input type="text" name="addWriter" placeholder="member_id" style="width:200px;">
			<button class="btn btn-primary btn_1" type="submit">입력</button>
			<input type="text" class="form-control" name="addText" placeholder="댓글 내용을 입력해주세요">
		</form>
		
		<!-- 댓글 출력 란 -->
		<table class="table">
			<tr>
				<th style="width:100px;">작성자</th>
				<th style="width:600px;">댓글내용</th>
				<th style="width:150px;">작성시간</th>
			</tr>
			<%
				for(Comment c : commentList){
			%>
			<tr>
				<td><%=c.memberId %></td>
				<td><%=c.commentText %></td>
				<td><%=c.createdate %></td>
			</tr>
			<%
				}
			%>
		</table>
	</div>
</body>
</html>