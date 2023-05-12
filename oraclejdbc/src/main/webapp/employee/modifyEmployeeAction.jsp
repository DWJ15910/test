<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	String loginMemberIdStr = (String)session.getAttribute("loginMemberId");
	int loginMemberId = Integer.parseInt(loginMemberIdStr);
	
	if(request.getParameter("firstName")==null
		||request.getParameter("lastName")==null
		||request.getParameter("email")==null
		||request.getParameter("phoneNumber")==null
		||request.getParameter("hireDate")==null
		||request.getParameter("salary")==null
		||request.getParameter("commissionPct")==null
		||request.getParameter("managerId")==null
		||request.getParameter("firstName").equals("")
		||request.getParameter("lastName").equals("")
		||request.getParameter("email").equals("")
		||request.getParameter("phoneNumber").equals("")
		||request.getParameter("hireDate").equals("")
		||request.getParameter("salary").equals("")
		||request.getParameter("commissionPct").equals("")
		||request.getParameter("managerId").equals("")){
		
		System.out.println(request.getParameter("firstName"));
		System.out.println(request.getParameter("lastName"));
		System.out.println(request.getParameter("email"));
		System.out.println(request.getParameter("phoneNumber"));
		System.out.println(request.getParameter("hireDate"));
		System.out.println(request.getParameter("salary"));
		System.out.println(request.getParameter("commissionPct"));
		System.out.println(request.getParameter("managerId"));
		
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("addnull이나 공백있음");
		return;
		
	}

	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String email = request.getParameter("email");
	String phoneNumber = request.getParameter("phoneNumber");
	String hireDate = request.getParameter("hireDate");
	double salary = Double.parseDouble(request.getParameter("salary"));
	double commissionPct = Double.parseDouble(request.getParameter("commissionPct"));
	int managerId = Integer.parseInt(request.getParameter("managerId"));

	//DB연동
	String driver="oracle.jdbc.driver.OracleDriver";
	String dburl="jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser="hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String modifySql = "UPDATE employees SET first_name=?,last_name=?,email=?,phone_number=?,hire_date=?,salary=?,commission_pct=?,manager_id=? WHERE employee_id=?";
	PreparedStatement modifyStmt = conn.prepareStatement(modifySql);
	modifyStmt.setString(1,firstName);
	modifyStmt.setString(2,lastName);
	modifyStmt.setString(3,email);
	modifyStmt.setString(4,phoneNumber);
	modifyStmt.setString(5,hireDate);
	modifyStmt.setDouble(6,salary);
	modifyStmt.setDouble(7,commissionPct);
	modifyStmt.setInt(8,managerId);
	modifyStmt.setInt(9,loginMemberId);
	
	int row = modifyStmt.executeUpdate();
	
	if(row==1){
		String msg = URLEncoder.encode("데이터가 성공적으로 변경 되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		System.out.println("변경성공 row값-->"+row);
		return;
	}else{
		//row값이 1이 아닐경우 메시지와 함게 이전페이지로 반환
		String msg = URLEncoder.encode("데이터 변경 실패하였습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/employee/modifyEmployee.jsp?msg="+msg);
		System.out.println("변경실패 row값-->"+row);
		return;
	}
%>