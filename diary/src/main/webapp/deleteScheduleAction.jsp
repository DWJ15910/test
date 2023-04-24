<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	//값 유효성검사
	if(request.getParameter("scheduleNo")==null
		||request.getParameter("schedulePw")==null
		||request.getParameter("scheduleNo").equals("")
		||request.getParameter("schedulePw").equals("")){
		
		response.sendRedirect("./deleteScheduleForm.jsp");
		System.out.println("deleteAction오류");
		return;
	}
	
	//값 입력
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	String scheduleDate = request.getParameter("scheduleDate");
	//디버깅
	System.out.println("schedulePw -->" + schedulePw);
	System.out.println("scheduleNo -->" + scheduleNo);
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//sql구문 및 db에서 작동 되도록 교체
	String sql = "delete from schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,scheduleNo);
	stmt.setString(2,schedulePw);
	//디버깅
	System.out.println("stmt-->" + stmt);
	
	int row = stmt.executeUpdate();
	//row 디버깅
	if(row==1){
		System.out.println("삭제성공");
	}else{
		System.out.println("삭제실패");
	}
	
	//반환 페이지
	response.sendRedirect("./scheduleList.jsp");
%>