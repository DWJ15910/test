<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
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
					<table>
						<tr>
							<td>아이디</td>
							<td><input type="text" name="memberId"></td>
						</tr>
						<tr>
							<td>패스워드</td>
							<td><input type="password" name="memberPw"></td>
						</tr>
					</table>
					<button type="submit">로그인</button>
				</form>
				<div>
					<!-- 회원 가입 이동 -->
					<a href="<%=request.getContextPath() %>/member/insertMemberForm.jsp">회원가입</a>
				</div>
				
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
</body>
</html>