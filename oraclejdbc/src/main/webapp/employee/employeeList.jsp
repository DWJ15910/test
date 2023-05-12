<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//현재 페이지 값
	int currentPage = 1;

	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));		
	}
	
	//한 페이지당 보일 게시물의 수
	int rowPerPage = 10;
	
	if(request.getParameter("rowPerPage") != null){
		currentPage = Integer.parseInt(request.getParameter("rowPerPage"));		
	}
	
	int totalCnt = 0;
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//DB연동
	String driver="oracle.jdbc.driver.OracleDriver";
	String dburl="jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser="hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//전체 행 갯수 출력
	String totalCntSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement totalCntStmt = conn.prepareStatement(totalCntSql);
	ResultSet totalCntRs = totalCntStmt.executeQuery();
	
	if(totalCntRs.next()){
		totalCnt = totalCntRs.getInt("count(*)");//select 반환 컬럼이 하나일때는 index사용 권장
	}
	int lastPage = totalCnt/rowPerPage;
	if(totalCnt%rowPerPage!=0){
		lastPage++;
	}
	
	int startRow = (currentPage-1)*rowPerPage+1;
	int endRow = Math.min((startRow+(rowPerPage-1)), totalCnt);
	
	
	//페이지 리스트
	String employListSql = "select e3.* from (select rownum rnum, e2.* from (select rownum, e1.* from employees e1 order by e1.hire_date desc) e2) e3 where e3.rnum between ? and ?";
	PreparedStatement employListStmt = conn.prepareStatement(employListSql);
	employListStmt.setInt(1,startRow);
	employListStmt.setInt(2,endRow);
	ResultSet employeeListRs = employListStmt.executeQuery();
	System.out.println(employeeListRs+"rs값");
	
	//Employee 리스트 생성
	ArrayList<Employee> employeeList = new ArrayList<Employee>();
	while(employeeListRs.next()){
		Employee e = new Employee();
		e.setEmployeeId(employeeListRs.getInt("employee_id"));
		e.setFirstName(employeeListRs.getString("first_name"));
		e.setLastName(employeeListRs.getString("last_name"));
		e.setEmail(employeeListRs.getString("email"));
		e.setPhoneNumber(employeeListRs.getString("phone_number"));
		e.setHireDate(employeeListRs.getString("hire_date"));
		e.setJobId(employeeListRs.getString("job_id"));
		e.setSalary(employeeListRs.getDouble("salary"));
		e.setCommissionPct(employeeListRs.getDouble("commission_pct"));
		e.setManagerId(employeeListRs.getInt("manager_id"));
		e.setDepartmentId(employeeListRs.getInt("department_id"));
		employeeList.add(e);
	}
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
	<!-- -----------------------------------------------------게시판 내용 출력--------------------------------------------------------------- -->
	<div class="container">
	<table class="table table-hover">
		<thead class="table-primary">
			<tr>
				<th>ID</th>
				<th>FirstName</th>
				<th>LastName</th>
				<th>Email</th>
				<th>PhoneNumber</th>
				<th>HireDate</th>
				<th>JobId</th>
				<th>Salary</th>
				<th>CommissionPct</th>
				<th>ManagerId</th>
				<th>DepartmentId</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		</thead>
		<%
			for(Employee e : employeeList){
		%>
				<tr>
					<td><%=e.getEmployeeId() %></td>
					<td><%=e.getFirstName() %></td>
					<td><%=e.getLastName() %></td>
					<td><%=e.getEmail() %></td>
					<td><%=e.getPhoneNumber() %></td>
					<td><%=e.getHireDate() %></td>
					<td><%=e.getJobId() %></td>
					<td><%=e.getSalary() %></td>
					<td><%=e.getCommissionPct() %></td>
					<td><%=e.getManagerId() %></td>
					<td><%=e.getDepartmentId() %></td>
					<%
						 if(String.valueOf(e.getEmployeeId()).equals(loginMemberId)){
					%>
							<td><a href="<%=request.getContextPath() %>/employee/modifyEmployee.jsp">수정</a></td>
							<td><a href="<%=request.getContextPath() %>/employee/removeEmployeeAction.jsp">삭제</a></td>
					<% 
						}
					%>
				</tr>
		<%
			}
		%>
	</table>
	<%
		if(session.getAttribute("loginMemberId")!=null){
	%>
			<div style="float: right;">
				<form action="<%=request.getContextPath()%>/employee/addEmployee.jsp">
					<button type="submit">직원 데이터 추가</button>
				</form>
			</div>
	<%
		}
	%>
	
	
	<!-- -------------------------------------------------------페이지 이동----------------------------------------------------------- -->
	<div style="text-align: center">
		<%
			//1~10번을 눌러도 1~10페이지만 출력되도록 설정
			int startPage = ((currentPage-1)/10)*10+1;
			//몇 페이지까지 나오게 하는지 선택 startPage+9와 lastPage중에서 작은 수가 출력된다
			int endPage = Math.min(startPage+9,lastPage);
			
			//startPage숫자가 10초과를 해야 ex)11에서 1로 갈수 있도록 -10으로 설정
			if(startPage>10){
		%>
			<a class="btn btn-primary" href="<%=request.getContextPath()%>/employee/employeeList.jsp?currentPage=<%=startPage-10%>">이전</a>
		<%
			}
			//보이는 페이지를 startPage부터 endPage까지 1씩 늘려가며 설정
			for(int i = startPage; i<=endPage; i++){				
		%>
				<a class="<%=currentPage==i ? "btn btn-danger":"btn btn-primary"%>" href="<%=request.getContextPath()%>/employee/employeeList.jsp?currentPage=<%=i%>"><%=i %></a>
		<%
			}
			//currentPage 변수대신 endPage변수를 이용하여 최종페이지 전까지만 출력하도록 변경
			if(endPage<lastPage){
		%>
			<a class="btn btn-primary" href="<%=request.getContextPath()%>/employee/employeeList.jsp?currentPage=<%=endPage+1%>">다음</a>
		<%
			}
		%>
		</div>
	</div>
</body>
</html>