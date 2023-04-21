<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

	<h1>데이터 입력</h1>
	
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./storeList.jsp">스토어 리스트</a>
	</div>
	
	<br>
	<!-- 추가할 가게 데이터 입력 폼 -->
	<form action="./insertStoreAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>store_name</td>
				<td>
					<input type="text" name="storeName">
				</td>
			</tr>
			<tr>
				<td>store_category</td>
				<td>
					<select name="storeCategory">
						<option value="한식">한식</option>
						<option value="일식">일식</option>
						<option value="중식">중식</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>store_address</td>
				<td>
					<input type="text" name="storeAddress">
				</td>
			</tr>
			<tr>
				<td>store_emp_cnt</td>
				<td>
					<input type="number" name="storeEmpCnt">
				</td>
			</tr>
			<tr>
				<td>store_begin</td>
				<td>
					<input type="date" name="storeBegin">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div style="text-align: right">
						<button class="btn btn-primary" type="submit">입력</button>
					</div>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>