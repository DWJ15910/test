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
	
	//페이징
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;
	int startRow = (currentPage-1)*rowPerPage;
	int totalRow = 0;
	
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
	PreparedStatement totalStmt = null;
	ResultSet oneRs = null;
	ResultSet commentRs = null;
	ResultSet totalRs = null;
	
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
	commentSql = "SELECT member_id memberId, comment_text commentText,createdate FROM comment WHERE board_no=? order by createdate DESC LIMIT ?,?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1,boardNo);
	commentStmt.setInt(2,startRow);
	commentStmt.setInt(3,rowPerPage);
	commentRs = commentStmt.executeQuery();
	//디버깅
	System.out.println("commentStmt-->"+commentStmt);
	System.out.println("commentRs-->"+commentRs);
	
	//페이지의 전체 행 구하는 쿼리문
	String totalRowSql = null;
	totalRowSql = "SELECT count(*) FROM comment WHERE board_no=?";
	totalStmt = conn.prepareStatement(totalRowSql);
	totalStmt.setInt(1,boardNo);
	totalRs = totalStmt.executeQuery();
	//디버깅
	System.out.println("totalStmt-->"+totalStmt);
	System.out.println("totalRs-->"+totalRs);
		
	//전체 페이지수를 구하고
	if(totalRs.next()){
		totalRow=totalRs.getInt("count(*)");
	}
	int lastPage = totalRow/rowPerPage;
	//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
	if(totalRow%rowPerPage!=0){
		lastPage++;
	}
	
	
	//댓글내용을 배열에 저장하기 위해 class작성 및 배열에 선언
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment c = new Comment();
		c.setMemberId(commentRs.getString("memberId"));
		c.setCommentText(commentRs.getString("commentText"));
		c.setCreatedate(commentRs.getString("createdate"));
		commentList.add(c);
	}
	
	Board board = null;
	if(oneRs.next()){
		board = new Board();
		board.setBoardNo(oneRs.getInt("boardNo"));
		board.setLocalName(oneRs.getString("localName"));
		board.setBoardTitle(oneRs.getString("boardTitle"));
		board.setBoardContent(oneRs.getString("boardContent"));
		board.setMemberId(oneRs.getString("memberId"));
		board.setCreatedate(oneRs.getString("createdate"));
		board.setUpdatedate(oneRs.getString("updatedate"));
	}
	
	//페이지 넘기기 서포트
	String addPage = "";
	if(boardNo >0) {
		addPage += "&boardNo=" + boardNo;
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
		<hr>
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<hr>
		<!-- 상세페이지 출력 -->
		<h2>상세페이지</h2>
		<hr>
		<table class="table">
			<tr>
				<th>board_no</th>
				<td><%=board.getBoardNo() %></td>
			</tr>
			<tr>
				<th>local_name</th>
				<td><%=board.getLocalName() %></td>
			</tr>
			<tr>
				<th>board_title</th>
				<td><%=board.getBoardTitle() %></td>
			</tr>
			<tr>
				<th>board_content</th>
				<td><%=board.getBoardContent() %></td>
			</tr>
			<tr>
				<th>member_id</th>
				<td><%=board.getMemberId() %></td>
			</tr>
			<tr>
				<th>createdate</th>
				<td><%=board.getCreatedate() %></td>
			</tr>
			<tr>
				<th>updatedate</th>
				<td><%=board.getUpdatedate() %></td>
			</tr>
		</table>
		<form action="<%=request.getContextPath() %>/board/deleteBaordForm.jsp">
		
		</form>
		<!-- 댓글 입력 란 -->
		<h2>댓글</h2>
		<%
			//로그인 사용자만 댓글 허용
			if(session.getAttribute("loginMemberId") !=null){
					String loginMemberId = (String)session.getAttribute("loginMemberId");
		%>
			<form action="<%=request.getContextPath() %>/board/insertCommentAction.jsp" method="post">
				<table class="table">
					<tr>
						<td>
							<input type="hidden" name="boardNo" value="<%=boardNo%>">
							<input type="text" class="form-control" name="addWriter" style="width:200px;" readonly="readonly" value="<%=loginMemberId%>">
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" class="form-control" name="addText" placeholder="댓글 내용을 입력해주세요">
						</td>
					</tr>
					<tr>
						<td>
							<button class="btn btn-primary btn_1" type="submit">입력</button>
						</td>
					</tr>
				</table>
			</form>
		<%
			}
		%>
		
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
				<td><%=c.getMemberId() %></td>
				<td><%=c.getCommentText() %></td>
				<td><%=c.getCreatedate() %></td>
			</tr>
			<%
				}
			%>
		</table>
		<%
			if(currentPage>1){
		%>
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage-1%>&addPage=<%=addPage%>">이전</a>
		<%	
			}
		%>
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&addPage=<%=addPage%>"><%=currentPage %>페이지</a>
		<%
			if(currentPage<lastPage){
		%>
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage+1%>&addPage=<%=addPage%>">다음</a>
		<%
			}
		%>
	</div>
</body>
</html>