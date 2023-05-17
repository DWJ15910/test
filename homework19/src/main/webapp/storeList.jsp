<%@page import="java.util.function.IntPredicate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	//페이지 값 기본 1설정
	int current = 1;
	
	//페이지 값이 null이 아닐경우 반환받은 current값을 현재 current값으로 반환?
	if(request.getParameter("current")!=null) {
	current = Integer.parseInt(request.getParameter("current"));
	}
	
	//DB구동 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("출력");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/homework0419","root","java1234");
	
	//SQL문 선언 및 SQL퀄리로 변환 (select뒤 열들을 store테이블에서 조회해서 store_begin을 기준으로 오름차순 정렬을 하여 일정 갯수마다 출력)
	PreparedStatement stmt = conn.prepareStatement("select store_no,store_name,store_category,createdate,updatedate from store order by store_begin ASC limit ?,?");
	//store테이블의 행의 갯수 출력
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from store");
	
	//한 페이지당 출력할 행의 수
	int pageRow = 10;
	//SQL limit을 통해 가져올 값의 첫 번째 배열? 값
	int startRow = (current-1)*10;
	
	//SQL문의 ? 값 가져오기
	stmt.setInt(1,startRow);
	stmt.setInt(2,pageRow);
	
	//쿼리문을 resultSet형태로 변환
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	
	//전체 행의 개수 모른다는 가정하에 0 선언
	int totalRow = 0;
	//rs2.next()에 요소가 있을경우 store테이블의 행의 수를 모두 카운트하여 totalRow에 반환
	if(rs2.next()){
		totalRow = rs2.getInt("count(*)");
	}
	//마지막 페이지 숫자 구하기
	int lastPage = totalRow/pageRow;
	//마지막페이지가 함페이지당 게시물수 (10)으로 나눠지지 않을때 lastPage를 +1 (하지 않을 시 10개씩 나누고나서 남은 값은 짤림)
	if(lastPage%pageRow!=0){
		lastPage+=1;
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
	a{
		text-decoration: none;
		color: #000000;
	}
</style>
</head>
<body>
	<h1>음식점 리스트</h1>
		<table class="table table-striped">
			<tr>
				<th>리스트번호</th>
				<th>이름</th>
				<th>카테고리</th>
				<th>게시날짜</th>
				<th>수정날짜</th>
			</tr>
			<%
				//rs.next가 계속 다음 행을 조회 할때마다 데이터 생성
				while(rs.next()){
			%>
			<tr>
				<td><a href="./storeDetail.jsp?storeNo=<%=rs.getInt("store_no")%>"><%=rs.getInt("store_no") %></a></td>
				<td><a href="./storeDetail.jsp?storeNo=<%=rs.getInt("store_no")%>"><%=rs.getString("store_name") %></a></td>
				<td><%=rs.getString("store_category") %></td>
				<td><%=rs.getString("createdate") %></td>
				<td><%=rs.getString("updatedate") %></td>
			</tr>
			<%
				}
			%>
		</table>
		<div style="text-align: center">
		<%
			if(current>1){
		%>
				<a class="btn btn-primary" href="./storeList.jsp?current=<%=current-1%>">이전</a>
		<%				
			}
		%>
				<a class="btn btn-primary" href="./storeList.jsp?current=<%=current%>"><%=current%>페이지</a>
		<%
			if(current<lastPage){
		%>
				
				<a class="btn btn-primary" href="./storeList.jsp?current=<%=current+1%>">다음</a>
		<%
			}
		%>
		</div>
		<br>
		<a class="btn btn-primary" href="./insertStoreForm.jsp">추가</a>
</body>
</html>