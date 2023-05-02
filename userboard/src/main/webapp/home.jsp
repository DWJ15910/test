<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<%
			if(request.getParameter("msg") != null){
		%>
				<div><%=request.getParameter("msg") %></div>
		<%
			}
		%>
		<div>
			<!-- home내용: 로그인폼/ 카테고리별 게시글 5개씩 -->
			<!-- 로그인폼 -->
			<%
				if(session.getAttribute("loginMemberId")==null){//로그인전이면 로그인폼 출력
			%>
					<form action="<%=request.getContextPath() %>/member/loginAction.jsp" method="post">
						<h2>로그인</h2>
						<table class="table">
							<tr>
								<td>아이디</td>
								<td><input class="form-control" type="text" name="memberId"></td>
							</tr>
							<tr>
								<td>패스워드</td>
								<td><input class="form-control" type="password" name="memberPw"></td>
							</tr>
						</table>
						<button class="btn btn-primary" type="submit">로그인</button>
					</form>
					
			<%
				}
			%>
			
			<!-- 카테고리폼 -->
		</div>
		
		<div>
			<%
				//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response);
				//이 코드 액션태그로 변경하면 아래와 같다
			%>
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>