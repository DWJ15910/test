<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//console 색 변수
	final String RESET = "\u001B[0m";
	final String BG_RED = "\u001B[41m";
	final String BG_GRAY = "\u001B[47m"; 
	
	// Controller layer(요청 값을 처리)
	//요청 파라미터값 확인
	//현재페이지번호
	System.out.println(BG_GRAY + "empList3 requestCurrenPage : " + request.getParameter("currentPage"));
	//검색단어(이름검색)	
	System.out.println("empList3 requestSearchWord : " + request.getParameter("searchWord"));
	//페이지당 보여줄 데이터 개수
	System.out.println("empList3 requestRowPerPage : " + request.getParameter("rowPerPage"));
	//성별
	System.out.println("empList3 requestGender : " + request.getParameter("gender"));
	//검색입사년도(구간시작년도)
	System.out.println("empList3 requestBeginYear : " + request.getParameter("beginYear"));
	//검색입사년도(구간끝년도)
	System.out.println("empList3 requestEndYear : " + request.getParameter("endYear"));

	// 요청 값이 null이 아니면 값 저장 => null이면 기본값
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	String searchWord = "";
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null
	&& !request.getParameter("rowPerPage").equals("")){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String gender = "";
	if(request.getParameter("gender") != null){
		gender = request.getParameter("gender");
	}
	//DB상 최소년도를 기본값으로
	int beginYear = 1985;
	if(request.getParameter("beginYear") != null){
		beginYear = Integer.parseInt(request.getParameter("beginYear"));
	}
	//DB상 최대년도를 기본값으로
	int endYear = 2000;
	if(request.getParameter("endYear") != null){
		endYear = Integer.parseInt(request.getParameter("endYear"));
	}
	
	// 변수값 확인
	System.out.println("empList3 currenPage : " + currentPage);
	System.out.println("empList3 searchWord : " + searchWord);
	System.out.println("empList3 rowPerPage : " + rowPerPage);
	System.out.println("empList3 gender : " + gender);
	System.out.println("empList3 beginYear : " + beginYear);
	System.out.println("empList3 endYear : " + endYear);
	
	// Model layer(모델값을 생성) => DB에서 받아와서 ArrayList를 만드는 과정까지
	int startRow = (currentPage - 1) * rowPerPage;
	// currentPage 1 => startRow 0
	System.out.println(BG_GRAY + "empList3 startRow : " + startRow + RESET);
	
	//DB호출
	String driver = "org.mariadb.jdbc.Driver";
	Class.forName(driver);
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//genderQuery부분만 따로 빼줌
	String genderQuery = "";
	//gender는 기본값이 공백인데 쿼리에 공백으로 들어가면 안되므로 따로 빼서 마지막에 붙여줌
	if(!gender.equals("")){
		genderQuery = " and gender = '" + gender + "'"; 
	}
	
	//이름검색조건, 입사년도구간, 성별에 맞는 데이터 rowPerPage개수만큼 가져오기
	String sql = "select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where concat(first_name, ' ', last_name) like ? and year(hire_date) between ? and ?" + genderQuery + " limit ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%"+searchWord+"%");
	stmt.setInt(2, beginYear);
	stmt.setInt(3, endYear);
	stmt.setInt(4, startRow);
	stmt.setInt(5, rowPerPage);
	System.out.println(BG_RED + "empList3 query : " + stmt);
	
	ResultSet rs = stmt.executeQuery();
	
	//일반적인 자료구조로 변경
	ArrayList<Employ> empList = new ArrayList<Employ>();
	while(rs.next()){
		Employ emp = new Employ();
		emp.empNo = rs.getInt("emp_no");
		emp.birthDate = rs.getString("birth_date");
		emp.firstName = rs.getString("first_name");
		emp.lastName = rs.getString("last_name");
		emp.gender = rs.getString("gender");
		emp.hireDate = rs.getString("hire_date");
		empList.add(emp);
	}
	
	//모델값 디버깅
	System.out.println(BG_GRAY + "empList3 empListSize : " + empList.size());
	
	//두번째 모델값 - lastPage:pagination을 위해
	int totalCnt = 0;
	int lastPage = 0;
	
	//이름검색조건, 입사년도구간, 성별에 맞는 데이터 개수
	String sql2 ="select count(*) empCnt from employees where concat(first_name, ' ', last_name) like ? and year(hire_date) between ? and ?" + genderQuery;
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%" + searchWord + "%");
	stmt2.setInt(2, beginYear);
	stmt2.setInt(3, endYear);
	System.out.println(BG_RED + "empList3 query2 : " + stmt2);
	
	//결과값 저장
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()){
		totalCnt = rs2.getInt("empCnt");
	}
	System.out.println(BG_GRAY + "empList3 totalCnt : " + totalCnt + RESET);
	
	//lastPage 구하기
	lastPage = totalCnt / rowPerPage;
	
	//딱 나누어 떨어지지 않으면 페이지가 한개 더 있어야함.
	if(totalCnt % rowPerPage != 0){
		lastPage++;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Employee List</title>
	<style>
		.big-icon{
				width: 40px;
				height: 40px;
				margin-right: 10px;
			}
			.container{
				width: 1280px;
				margin: 0 auto;
			}
			header{
				display: flex;
				align-items: center;
				justify-content: center;
			}
			.icon{
				width: 30px;
				height: 30px;
			}
			table, th, td{
				border: 1px solid #333333;
				border-collapse: collapse;
				padding: 3px;
			}
			table{
				width: 80%;
				margin: 0 10%;
			}
			th{
				background-color: lightblue;
			}
			td{
				text-align: center;
			}
			.pagination{
				display: flex;
				justify-content: space-between;
				align-items: center;
				width: 80%;
				margin: 20px auto 0;
			}
			.pagination > div{
				width: 33%;
				text-align: center;
			}
			a{
				display:block;
				width: 100%;
				text-decoration: none;
				color: black;
			}
			a:hover{
				color: cornflowerblue;
			}
			.full-form{
				width: 100%;
				margin: 10px;
				text-align: center;
			}
			.full-form > input, button, select{
				padding : 5px;
				width: 10%;
				border-radius: 4px;
				background-color: #ffffff;
			}
			.full-form button:hover{
				background-color: whitesmoke;
				cursor: pointer;
			}
	</style>
</head>
<body>
	<!-- View layer(모델값을 출력)  -->
	<div class="container">
		<header>
			<img src="./images/employee.png" class="big-icon">
			<h1>Employee List</h1>
		</header>
		<div>
			<form action="./empList3.jsp" method="get" class="full-form">
				<input type="text" name="searchWord" placeholder="이름검색"  value="<%=searchWord%>"></input>
				<select name="gender">
					<option value="">성별선택</option>
					<!-- gender값이 M이면 value가 남성으로 나오게 selected, F면 여성으로... -->
					<option value="M" <%if(gender.equals("M")){ %>selected<%} %>>남성</option>
					<option value="F" <%if(gender.equals("F")){ %>selected<%} %>>여성</option>
				</select>
				<label>입사년도 : </label>
				<input type="number" name="beginYear" placeholder="시작년도"  value="<%=beginYear%>"></input> ~ 
				<input type="number" name="endYear" placeholder="마지막년도"  value="<%=endYear%>"></input>
				<label>페이지당 개수 : </label>
				<select name="rowPerPage">
					<!-- rowPerPage값에 따라 selected여부 지정 -->
					<option value="10" <%if(rowPerPage == 10){ %>selected<%} %>>10개</option>
					<option value="15" <%if(rowPerPage == 15){ %>selected<%} %>>15개</option>
					<option value="20" <%if(rowPerPage == 20){ %>selected<%} %>>20개</option>
				</select>
				<button type="submit">검색</button>
			</form>
			
			<table>
				<tr>
					<th>사원번호</th>
					<th>나이</th>
					<th>성</th>
					<th>이름</th>
					<th>성별</th>
					<th>입사일</th>
				</tr>
				<%
					for(Employ emp : empList){
						//오늘 날짜 가져오기 => 나이를 구하기 위해
						Calendar today = Calendar.getInstance();
						//사원의 태어난 년,월,일
						int empY = Integer.parseInt(emp.birthDate.substring(0, 4));
						int empM = Integer.parseInt(emp.birthDate.substring(5, 7));
						int empD = Integer.parseInt(emp.birthDate.substring(8, 10));
						//년도로만 구한 나이
						int age = today.get(Calendar.YEAR) - empY;
						//생일 안지났으면 -1
						//생일월이 아직 안되었거나 생일월인데 생일이 안지났으면
						if((today.get(Calendar.MONTH) + 1 < empM)
							|| ((empM == today.get(Calendar.MONTH) + 1) && (today.get(Calendar.DATE) < empD))){
							age--;
						}
						//성별 이미지 url넣어두기
						String genderImg = "./images/male.png";
						if(emp.gender.equals("F")){
							genderImg = "./images/female.png";
						}
				%>
						<tr>
							<td><%=emp.empNo %></td>
							<td><%=age %></td>
							<td><%=emp.firstName%></td>
							<td><%=emp.lastName %></td>
							<td>
								<img src="<%=genderImg %>" class="icon"> 
							</td>
							<td><%=emp.hireDate %></td>
						</tr>
				<%	
					}
				%>
			</table>
			
			<div class="pagination">
				<div>
					<%
						if(currentPage > 1){
					%>
							<a href="./empList3.jsp?currentPage=<%=currentPage-1 %>&rowPerPage=<%=rowPerPage%>&searchWord=<%=searchWord%>&gender=<%=gender%>&beginYear=<%=beginYear%>&endYear=<%=endYear%>">
								<img src="./images/left-arrow.png" class="icon">
							</a>
					<%
						}
					%>
				</div>
				<div>
					<strong><%=currentPage %></strong>
				</div>
				<div>
					<%
						if(currentPage < lastPage){
					%>
							<a href="./empList3.jsp?currentPage=<%=currentPage+1 %>&rowPerPage=<%=rowPerPage%>&searchWord=<%=searchWord%>&gender=<%=gender%>&beginYear=<%=beginYear%>&endYear=<%=endYear%>">
								<img src="./images/right-arrow.png" class="icon">
							</a>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
</body>
</html>