<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		text-decoration: none;
		color: #000000;
		font-weight: bold;
	}
</style>
<div>
	<ul class="list-group list-group-horizontal" >
		<li class="list-group-item"><a href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		
		<!-- 
			로그인전 : 회원가입 
			로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId
		-->
		<%
			if(session.getAttribute("loginMemberId")==null){ //로그인 전
		%>
				<li class="list-group-item"><a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
		<%
			} else { //로그인 후
		%>
				<li class="list-group-item"><a href="<%=request.getContextPath()%>/member/userInformation.jsp">회원정보</a></li>
				<li class="list-group-item"><a href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
				<li class="list-group-item"><a href="<%=request.getContextPath()%>/board/category.jsp">카테고리 관리</a></li>
				<li class="list-group-item"><a href="<%=request.getContextPath()%>/board/insertPostForm.jsp">게시글 추가</a></li>
		<%
			}
		%>
		<li class="list-group-item"><a href="<%=request.getContextPath()%>/.jsp"></a></li>
	</ul>
</div>