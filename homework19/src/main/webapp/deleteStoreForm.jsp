<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//storeList에서 넘어온 storeNo값이 null일 경우에 storeList.jsp로 다시 보내기
	if(request.getParameter("storeNo")==null){
		response.sendRedirect("./storeList.jsp");
		return; // 종료 또는 반환 할때 사용
	}

	int storeNo = Integer.parseInt(request.getParameter("storeNo"));
	//storeNo 디버깅 확인
	System.out.println(storeNo + "<--deleteStoreForm storeNo 출력");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>삭제</h1>
	<form action="./deleteStoreAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>store_no</td>
				<td>
					<input type="text" name="storeNo" readonly="readonly" value="<%=storeNo%>">
				</td>
			</tr>
			<tr>
				<td>store_pw</td>
				<td>
					<input type="text" name="storePw">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button class="btn btn-secondary" type="submit">삭제하기</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>