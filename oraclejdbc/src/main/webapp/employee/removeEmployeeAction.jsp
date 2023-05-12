<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
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
	
	String remSql = "DELETE FROM employees WHERE employee_id = ?";
	PreparedStatement remStmt = conn.prepareStatement(remSql);
	remStmt.setInt(1,loginMemberId);
	
	int row = remStmt.executeUpdate();
	
	if(row==1){
		String msg = URLEncoder.encode("성공적으로 삭제되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		session.invalidate();
		System.out.println("변경성공 row값-->"+row);
		return;
	}else{
		//row값이 1이 아닐경우 메시지와 함게 이전페이지로 반환
		String msg = URLEncoder.encode("삭제안되었다","utf-8");
		response.sendRedirect(request.getContextPath()+"/employee/employeeList.jsp?msg="+msg);
		System.out.println("변경실패 row값-->"+row);
		return;
	}
	
%>