<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//기본 페이지 설정
	int currentPage = 1;	

	//페이지값이 null이 아닐경우 데이터 값 넘어온 currentPage값을 가져와서 currentPage에 int타입으로 선언
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println("empList.currentPage-->" + currentPage);
	
	//DB연동
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("empList DB 드라이버 연동확인");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println("empList DB 로그인확인");
	
	//sql에 들어갈 기본 col, ascDesc의 디폴트 선언
	String col = "emp_no";
	String ascDesc = "ASC";
	// 테이블에서 asc또는 desc선택 후 값을 getParameter로 가져와서 가져온 값을 col과 ascDesc에 선언 이후 sql에서 바뀐 col 과 ascdesc를 이용하여 선언
	if(request.getParameter("col") != null 
			&& request.getParameter("ascDesc") != null) {
		col = request.getParameter("col");
		ascDesc = request.getParameter("ascDesc");
	}

	
	//select로 고를 table변수와 input타입을 써서 검색할 search변수 선언
	//null값이 둘다 아닐경우에 값을 대입해주기
	String table = null;
	String search = null;
	if(request.getParameter("table") != null 
			&& request.getParameter("search") != null) {
		table = request.getParameter("table");
		search = request.getParameter("search");
	}
	
	
	String change = "";
	String temp = "";
	
	//sql1은 기본적으로 공백처리
	String sql1 = "";
	//table문과 search문이 둘다 null일 경우(초기 정보형태)
	if(table==null && search==null){
		//기본 초기 정보형태로 페이지반환
		sql1 = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender gender, hire_date hireDate FROM employees ORDER BY "+col+" "+ascDesc+" LIMIT ?, ?";
	}else{
		//null이 아닐경우 검색조건인 table과 search를 받아서 페이지반환
		sql1 = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender gender, hire_date hireDate FROM employees where "+table+" like ? ORDER BY "+col+" "+ascDesc+" LIMIT ?, ?";
	}
	
	//totalrow를 측정하기 위한 sql문
	String sql2 = "SELECT count(*) FROM employees";
	//sql db에서사용할수 있도록 변경
	PreparedStatement stmt = conn.prepareStatement(sql1);
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	
	//한 페이지에 보일 행의 수
	int rowperPage = 10;
	//행 출력시에 보일 행의 첫행 넘버
	int startrow = (currentPage-1)*rowperPage;
	
	//?값 넣기
	// 검색 조건이 없는 경우
	if(table==null || search==null) {
	    stmt.setInt(1, startrow);
	    stmt.setInt(2, rowperPage);
	} else { // 검색 조건이 있는 경우
	    stmt.setString(1, "%" + search + "%");
	    stmt.setInt(2, startrow);
	    stmt.setInt(3, rowperPage);
		}
	//디버깅
	System.out.println("empList.stmt-->" + stmt);
	System.out.println("empList.stmt2-->" + stmt2);
	
	//stmt,stmt2를 ResultSet 형태로 저장
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	System.out.println("empList.rs-->" + rs);
	System.out.println("empList.rs2-->" + rs2);
	
	//employList에 들어갈 자료들 조회
	//ArrayList 제작
	ArrayList<Employ> employList = new ArrayList<Employ>();
	while(rs.next()){
		Employ e = new Employ();
		e.empNo = rs.getInt("empNo");
		e.birthDate = rs.getString("birthDate");
		e.firstName = rs.getString("firstName");
		e.lastName = rs.getString("lastName");
		e.gender = rs.getString("gender");
		e.hireDate = rs.getString("hireDate");
		employList.add(e);
	}
	
	//전체 행의 수, 마지막 페이지 구하기
	int totalRow = 0;
	if(rs2.next()) {
			totalRow = rs2.getInt("count(*)");
		}
	System.out.println("empList.totalRow-->" + totalRow);
	
	//마지막 페이지 구하기
	int lastPage = totalRow/rowperPage;
	
	//한페이지 당 행의 수로 나눠지지 않을시에 마지막 페이지 +1
	if(totalRow % rowperPage !=0){
		lastPage=lastPage+1;
	}
	System.out.println("empList.lastPage-->" + lastPage);
	
	//나이구하기
	//오늘 날짜 데이터 구하기
	Calendar today = Calendar.getInstance();
	System.out.println("empList.today -->" + today);
	
	//오늘 날짜의 년,월,일 구하기
	int todayYear = today.get(Calendar.YEAR);
	int todayMonth = today.get(Calendar.MONTH);
	int todayDay = today.get(Calendar.DATE);
	//디버깅
	System.out.println("empList.todayYear -->" + todayYear);
	System.out.println("empList.todayMonth -->" + todayMonth);
	System.out.println("empList.todayDay -->" + todayDay);
	
	
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	img {
		width:20px;
		height: 20px;
	}
	h1{
		padding:30px;
	}
</style>
</head>
<body>
	<div class="container">
	<h1 style="text-align:center; ">empList</h1>
	<form action="./empList.jsp">
	<a style="float:left; font-weight: bold;" class="btn btn-outline-info" href="./empList.jsp">리스트로</a>
	<table class="table table-striped" style="width:50%;">
		<tr>
			<th style="width:150px;">검색 테이블:</th>
			<td style="width:150px;"><%=table %></td>
			<th style="width:150px;">검색 값:</th>
			<td> <%=search %></td>
		</tr>
	</table>
	<!-- 검색창 -->
	<div style="float:right;">
		검색: 
		<select name="table">
			<option value="emp_no">emp_no</option>
			<option value="first_name">first_name</option>
			<option value="last_name">last_name</option>
			<option value="gender">gender</option>
			<option value="hire_date">hire_date</option>
		</select>
		<input type ="text" name="search">
		<button class="btn btn-secondary" type="submit">검색</button>
	</div><br>
	<!-- 검색창 끝 -->
	<!-- 리스트 테이블 -->
		<table class="table table-striped">
			<%
				//검색과 정렬 모두 있을 경우 리스트 출력
				if(search!=null&&table!=null){
			%>
			<tr>
				<th style="width:200px;">
					<a href="./empList.jsp?col=emp_no&ascDesc=ASC&search=<%=search%>&table=<%=table%>">[asc]</a>
					<a href="./empList.jsp?col=emp_no&ascDesc=DESC&search=<%=search%>&table=<%=table%>">[desc]</a>
					emp_no
				</th>
				<th style="width:200px;">
					<a href="./empList.jsp?col=birth_date&ascDesc=ASC&search=<%=search%>&table=<%=table%>">[asc]</a>
					<a href="./empList.jsp?col=birth_date&ascDesc=DESC&search=<%=search%>&table=<%=table%>">[desc]</a>
					age
				</th>
				<th style="width:250px;">
					<a href="./empList.jsp?col=first_name&ascDesc=ASC&search=<%=search%>&table=<%=table%>">[asc]</a>
					<a href="./empList.jsp?col=first_name&ascDesc=DESC&search=<%=search%>&table=<%=table%>">[desc]</a>
					first_name
				</th>
				<th style="width:250px;">
					<a href="./empList.jsp?col=last_name&ascDesc=ASC&search=<%=search%>&table=<%=table%>">[asc]</a>
					<a href="./empList.jsp?col=last_name&ascDesc=DESC&search=<%=search%>&table=<%=table%>">[desc]</a>
					last_name
				</th>
				<th style="width:200px;">
					<a href="./empList.jsp?col=gender&ascDesc=ASC&search=<%=search%>&table=<%=table%>">[asc]</a>
					<a href="./empList.jsp?col=gender&ascDesc=DESC&search=<%=search%>&table=<%=table%>">[desc]</a>
					gender
				</th>
				<th>
					<a href="./empList.jsp?col=hire_date&ascDesc=ASC&search=<%=search%>&table=<%=table%>">[asc]</a>
					<a href="./empList.jsp?col=hire_date&ascDesc=DESC&search=<%=search%>&table=<%=table%>">[desc]</a>
					hire_date
				</th>
			</tr>
			<%
				//정렬만 있을 경우 리스트 출력
				}else{
			%>		
				<tr>
				<th style="width:200px;">
					<a href="./empList.jsp?col=emp_no&ascDesc=ASC">[asc]</a>
					<a href="./empList.jsp?col=emp_no&ascDesc=DESC">[desc]</a>
					emp_no
				</th>
				<th style="width:200px;">
					<a href="./empList.jsp?col=birth_date&ascDesc=ASC">[asc]</a>
					<a href="./empList.jsp?col=birth_date&ascDesc=DESC">[desc]</a>
					age
				</th>
				<th style="width:250px;">
					<a href="./empList.jsp?col=first_name&ascDesc=ASC">[asc]</a>
					<a href="./empList.jsp?col=first_name&ascDesc=DESC">[desc]</a>
					first_name
				</th>
				<th style="width:250px;">
					<a href="./empList.jsp?col=last_name&ascDesc=ASC">[asc]</a>
					<a href="./empList.jsp?col=last_name&ascDesc=DESC">[desc]</a>
					last_name
				</th>
				<th style="width:200px;">
					<a href="./empList.jsp?col=gender&ascDesc=ASC">[asc]</a>
					<a href="./empList.jsp?col=gender&ascDesc=DESC">[desc]</a>
					gender
				</th>
				<th>
					<a href="./empList.jsp?col=hire_date&ascDesc=ASC">[asc]</a>
					<a href="./empList.jsp?col=hire_date&ascDesc=DESC">[desc]</a>
					hire_date
				</th>
			</tr>
			<%
				}
			%>
			<%
				for(Employ e : employList){
			%>
			<tr>
				<td>
					<%=e.empNo%>
				</td>
				<td>
					<%
						//e.birthDate로 가져온 값을 년,월,일로 substring으로 쪼갠뒤 각각 int 타입으로 저장
						int birthYear = Integer.parseInt(e.birthDate.substring(0,4));
						int birthMonth = Integer.parseInt(e.birthDate.substring(5,7));
						int birthDay = Integer.parseInt(e.birthDate.substring(8));
						
						//생일이 지났으면 현재년도-생년
						//생일이 지나지 않았으면 현재년도-생년-1
						if (birthMonth>todayMonth 
								||(birthMonth==todayMonth && birthDay>todayDay)){
					%>
						<%=todayYear-birthYear-1%>세
					<%
						}else{
					%>
						<%=todayYear-birthYear%>세
					<%
						}
					%>
				</td>
				<td>
					<%=e.firstName%>
				</td>
				<td>
					<%=e.lastName%>
				</td>
				<td>
					<!-- M 또는 F 값을 받고 사진이름을 통해 출력 -->
					<div><img src="./img/<%=e.gender%>.JPG"></div>
				</td>
				<td>
					<%=e.hireDate%>
				</td>
			</tr>
			<%
				}
			%>
		</table>
		<!-- 리스트부분 끝 -->
		<!-- 페이지 출력부분 -->
		<div style="text-align: center">
		<%
			//현재페이지가 1보다 클경우만 이전 페이지로 갈수 있도록 설정
			if(currentPage>1){
				//검색과 정렬 모두 활성화 되어 있을 경우 페이지넘기기
				if(search != null && table != null && col!=null && ascDesc!=null){
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage-1%>&search=<%=search%>&table=<%=table%>&col=<%=col%>&ascDesc=<%=ascDesc%>">이전</a>
		<%
				//검색만 활성화 되어 있을 경우 페이지넘기기
				} else if(search != null && table != null) {
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage-1%>&search=<%=search%>&table=<%=table%>">이전</a>
		<%
				//정렬만 활성화 되어 있을 경우 페이지 넘기기
				}else if(col!=null && ascDesc!=null){
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage-1%>&col=<%=col%>&ascDesc=<%=ascDesc%>">이전</a>
		<%
				//전부다 활성화 되어 있지않을 경우 페이지넘기기
				}else{
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
				}
			}
		%>
				<!-- 현재페이지 출력 -->
				<a class="btn btn-primary">현재페이지<%=currentPage%></a>
		<%
			//현재페이지가 lastPage보다 적을 경우에만 다음페이지가 보이도록 설정
			if(currentPage<lastPage){
				//검색과 정렬 모두 활성화 되어 있을 경우 페이지넘기기
				if(search != null && table != null && col!=null && ascDesc!=null){
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage+1%>&search=<%=search%>&table=<%=table%>&col=<%=col%>&ascDesc=<%=ascDesc%>">다음</a>
		<%
				//검색만 활성화 되어 있을 경우 페이지넘기기
				} else if(search != null && table != null){ 
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage+1%>&search=<%=search%>&table=<%=table%>">다음</a>
		<%
				//정렬만 활성화 되어 있을 경우 페이지 넘기기
				}else if(col!=null && ascDesc!=null){
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage+1%>&col=<%=col%>&ascDesc=<%=ascDesc%>">다음</a>
		<%
				//전부다 활성화 되어 있지않을 경우 페이지넘기기
				}else{
		%>
				<a class="btn btn-primary" href="./empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
				}//else문닫기
			}//currentPage닫기
		%>
		</div>
		<!-- 페이지 출력분 끝 -->
	</form>
	</div>
</body>
</html>