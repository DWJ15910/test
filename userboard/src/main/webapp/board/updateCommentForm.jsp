<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

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
</style>
</head>
<body>
	<div class="con">
		<hr>
		<!-- 메인메뉴 (가로) -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<hr>
		<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
		<h2>댓글 수정</h2>
		<hr>
			<table class="table table-hover">
				<tr>
					<th>댓글 수정</th>
				</tr>
				<tr>
					<th><input type ="text" name="comment_text" class="form-control"></th>
				</tr>
			</table>
			
			<button class="btn btn-primary" type="submit">수정</button>
			<!-- boardNo와 commentNo값 보내기용 -->
			<input type="hidden" name="boardNo" value="<%=boardNo %>">
			<input type="hidden" name="commentNo" value="<%=commentNo %>">
		</form>
	</div>
</body>
</html>