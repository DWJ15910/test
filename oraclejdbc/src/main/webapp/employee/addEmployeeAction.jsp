<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%

	if(request.getParameter("employeeId")==null
		||request.getParameter("firstName")==null
		||request.getParameter("lastName")==null
		||request.getParameter("email")==null
		||request.getParameter("phoneNumber")==null
		||request.getParameter("hireDate")==null
		||request.getParameter("jobId")==null
		||request.getParameter("salary")==null
		||request.getParameter("commissionPct")==null
		||request.getParameter("managerId")==null
		||request.getParameter("departmentId")==null
		||request.getParameter("employeeId").equals("")
		||request.getParameter("firstName").equals("")
		||request.getParameter("lastName").equals("")
		||request.getParameter("email").equals("")
		||request.getParameter("phoneNumber").equals("")
		||request.getParameter("hireDate").equals("")
		||request.getParameter("jobId").equals("")
		||request.getParameter("salary").equals("")
		||request.getParameter("commissionPct").equals("")
		||request.getParameter("managerId").equals("")
		||request.getParameter("departmentId").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("addnull이나 공백있음");
		return;
		
	}

	int employeeId = Integer.parseInt(request.getParameter("employeeId"));
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String Email = request.getParameter("email");
	String phoneNumber = request.getParameter("phoneNumber");
	String hireDate = request.getParameter("hireDate");
	String jobId = request.getParameter("jobId");
	double salary = Double.parseDouble(request.getParameter("salary"));
	double commissionPct = Double.parseDouble(request.getParameter("commissionPct"));
	int managerId = Integer.parseInt(request.getParameter("managerId"));
	int departmentId = Integer.parseInt(request.getParameter("departmentId"));

	//DB연동
	String driver="oracle.jdbc.driver.OracleDriver";
	String dburl="jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser="hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String addSql = "INSERT INTO employees values(?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement addStmt = conn.prepareStatement(addSql);
	addStmt.setInt(1,employeeId);
	addStmt.setString(2,firstName);
	addStmt.setString(3,lastName);
	addStmt.setString(4,Email);
	addStmt.setString(5,phoneNumber);
	addStmt.setString(6,hireDate);
	addStmt.setString(7,jobId);
	addStmt.setDouble(8,salary);
	addStmt.setDouble(9,commissionPct);
	addStmt.setInt(10,managerId);
	addStmt.setInt(11,departmentId);
	
	int row = addStmt.executeUpdate();
	
	if(row==1){
		String msg = URLEncoder.encode("데이터가 성공적으로 추가 되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		System.out.println("변경성공 row값-->"+row);
		return;
	}else{
		//row값이 1이 아닐경우 메시지와 함게 이전페이지로 반환
		String msg = URLEncoder.encode("데이터 추가에 실패하였습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/employee/addEmploy.jsp?msg="+msg);
		System.out.println("변경실패 row값-->"+row);
		return;
	}
%>