<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	//맨 위에는 세션 요소검사 부터 해야한다
	
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 요청값 유효성 검사
	String employeeId = request.getParameter("employeeId");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	//디버깅
	
	//DB연동
	String driver="oracle.jdbc.driver.OracleDriver";
	String dburl="jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser="hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String sql = "SELECT employee_id FROM employees WHERE employee_id = ? and (first_name = ? and last_name = ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,employeeId);
	stmt.setString(2,firstName);
	stmt.setString(3,lastName);
	ResultSet rs = stmt.executeQuery();
	System.out.println("rs성공"+rs);
	
	if(rs.next()){//로그인성공
		//세션에 로그인 정보 (memberId)저장
		session.setAttribute("loginMemberId",rs.getString("employee_id"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
		String msg = URLEncoder.encode(employeeId+"님 안녕하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	} else {//로그인실패
		System.out.println("로그인실패");
		String msg = URLEncoder.encode("ID와 비밀번호가 틀렸습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	}

	
	
%>