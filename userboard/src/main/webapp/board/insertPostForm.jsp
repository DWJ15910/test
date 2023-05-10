<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String memberId = (String)session.getAttribute("loginMemberId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/board/insertPostAction.jsp">
		<table>
			<tr>
				<th>local_name</th>
				<td>
					<input type="text" name="local_name">
				</td>
			</tr>
			<tr>
				<th>board_title</th>
				<td>
					<input type="text" name="board_title">
				</td>
			</tr>
			<tr>
				<th>board_content</th>
				<td>
					<input type="text" name="board_content">
				</td>
			</tr>
			<tr>
				<th>member_id</th>
				<td>
					<input type="text" name="member_id" disabled="disabled" value="<%=memberId %>">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit">게시글 작성</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>