<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	//유효성 검사
	if(request.getParameter("scheduleNo")==null
		||request.getParameter("schedulePw")==null
		||request.getParameter("scheduleDate")==null
		||request.getParameter("scheduleTime")==null
		||request.getParameter("scheduleMemo")==null
		||request.getParameter("scheduleColor")==null
		||request.getParameter("scheduleNo").equals("")
		||request.getParameter("schedulePw").equals("")
		||request.getParameter("scheduleDate").equals("")
		||request.getParameter("scheduleTime").equals("")
		||request.getParameter("scheduleMemo").equals("")
		||request.getParameter("scheduleColor").equals("")){
		
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("updateAction 오류");
		return;
	}
	//값 부르기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String scheduleColor = request.getParameter("scheduleColor");
	//디버깅
	System.out.println("update.scheduleNo-->" + scheduleNo);
	
	//되돌아가기 용 값 구하기
	String y = scheduleDate.substring(0,4); //2023
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1; //3
	String d = scheduleDate.substring(8);
	//디버깅
	System.out.println("insert.y-->" + y);
	System.out.println("insert.m-->" + m);
	System.out.println("insert.d-->" + d);
	
	//드라이버 부르기
	Class.forName("org.mariadb.jdbc.Driver");
	//드라이버 디버깅
	System.out.println("드라이버 확인");
	
	//DB연결확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//DB연결 확인 디버깅
	System.out.println(conn + "DB연결 확인");
	
	//sql 구문작성 및 sql구문이 mariadb에서 사용가능하도록 변경
	String sql = "update schedule set schedule_date = ?, schedule_time = ?, schedule_memo = ?, schedule_color = ?, updatedate = now() where schedule_no = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//stmt1 디버깅
	System.out.println(stmt + "<--stmt1 출력확인");
	
	//?에 값집어넣기
	stmt.setString(1,scheduleDate);
	stmt.setString(2,scheduleTime);
	stmt.setString(3,scheduleMemo);
	stmt.setString(4,scheduleColor);
	stmt.setInt(5,scheduleNo);
	stmt.setString(6,schedulePw);
	
	System.out.println(stmt + "<--stmt2 출력확인");
	
	int row = stmt.executeUpdate();
	
	//row출력 성공 확인
	if(row==0){
		System.out.println("수정실패");
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	}else{
		System.out.println("수정성공");
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	}
%>