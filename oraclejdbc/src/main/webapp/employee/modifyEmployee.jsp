<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	String loginMemberIdStr = (String)session.getAttribute("loginMemberId");
	int loginMemberId = Integer.parseInt(loginMemberIdStr);

	//DB연동
	String driver="oracle.jdbc.driver.OracleDriver";
	String dburl="jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser="hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String jobSql = "SELECT job_id FROM jobs";
	PreparedStatement jobStmt = conn.prepareStatement(jobSql);
	ResultSet jobRs = jobStmt.executeQuery();
	
	ArrayList<Job> jobList = new ArrayList<Job>();
	while(jobRs.next()){
		Job j = new Job();
		j.setJobId(jobRs.getString("job_id"));
		jobList.add(j);
	}
	
	String departmentSql = "SELECT department_id,department_name FROM departments";
	PreparedStatement departmentStmt = conn.prepareStatement(departmentSql);
	ResultSet departmentRs = departmentStmt.executeQuery();
	
	ArrayList<Department> departmentList = new ArrayList<Department>();
	while(departmentRs.next()){
		Department d = new Department();
		d.setDepartment(departmentRs.getInt("department_id"));
		d.setDepartmentName(departmentRs.getString("department_name"));
		departmentList.add(d);
	}
	
	String managerSql = "SELECT employee_id, job_id FROM employees";
	PreparedStatement managerStmt = conn.prepareStatement(managerSql);
	ResultSet managerRs = managerStmt.executeQuery();
	
	ArrayList<Employee> managerList = new ArrayList<Employee>();
	while(managerRs.next()){
		Employee m = new Employee();
		m.setEmployeeId(managerRs.getInt("employee_id"));
		m.setJobId(managerRs.getString("job_id"));
		managerList.add(m);
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
	<div class="container">
		<form action="<%=request.getContextPath() %>/employee/modifyEmployeeAction.jsp">
			<table class="table table-hover">
				<tr>
					<th>Emlploy_id</th>
					<td><input type="text" class="form-control" pattern="\d*" maxlength="6" readonly="readonly" value="<%=loginMemberId%>"></td>
				</tr>
				<tr>
					<th>First_name</th>
					<td><input type="text" name="firstName" class="form-control" maxlength="20" pattern="[A-Za-z]+" placeholder="20자리 이하의 영어로 입력해주시기 바랍니다"></td>
				</tr>
				<tr>
					<th>Last_name</th>
					<td><input type="text" name="lastName" class="form-control" pattern="[A-Za-z]+" maxlength="20" placeholder="20자리 이하의 영어로 입력해주시기 바랍니다"></td>
				</tr>
				<tr>
					<th>Email</th>
					<td><input type="text" name="email" class="form-control" maxlength="25" placeholder="25자리 이하의 숫자로 입력해주시기 바랍니다"></td>
				</tr>
				<tr>
					<th>Phone_number</th>
					<td><input type="text" name="phoneNumber" class="form-control" pattern="\d*" maxlength="25" placeholder="25자리 이하의 숫자로 입력해주시기 바랍니다"></td>
				</tr>
				<tr>
					<th>Hire_date</th>
					<td><input type="date" name="hireDate" class="form-control" pattern="\d*" maxlength="20" placeholder="20자리 이하의 숫자로 입력해주시기 바랍니다"></td>
				</tr>
				<tr>
					<th>Job_id</th>
					<td>
						<select>
						<%
							for(Job j : jobList){
						%>
							<option value="<%=j.getJobId() %>"><%=j.getJobId() %></option>
						<%
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<th>Salary</th>
					<td><input type="text" name="salary" class="form-control" step="0.01" pattern="\d*" maxlength="8" placeholder="8자리 이하의 숫자로 입력해주시기 바랍니다"></td>
				</tr>
				<tr>
					<th>Commission_pct</th>
					<td><input type="text" name="commissionPct" step="0.01" class="form-control" maxlength="4" placeholder="0초과 1미만의 값을 넣어주기시 바랍니다"></td>
				</tr>
				<tr>
					<th>Manager_id</th>
					<td>
						<select name="managerId">
						<%
							for(Employee m : managerList){
						%>
							<option value="<%=m.getEmployeeId() %>"><%=m.getEmployeeId() %>-<%=m.getJobId() %></option>
						<%
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<th>Department_id</th>
					<td>
						<select>
						<%
							for(Department d : departmentList){
						%>
							<option value="<%=d.getDepartment() %>"><%=d.getDepartment() %>-<%=d.getDepartmentName() %></option>
						<%
							}
						%>
						</select>
					</td>
				</tr>
			</table>
			<button type="submit">데이터 변경</button>
		</form>
	</div>
</body>
</html>