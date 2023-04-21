<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	if(request.getParameter("noticeNo") == null
			||request.getParameter("noticePw") == null
			||request.getParameter("noticeNo").equals("")
			||request.getParameter("noticePw").equals("")){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	System.out.println(noticePw+"<--noticePw");
	//delete from notice where notice_no=? and notice_pw=?
	
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버 부르기
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	
	
	System.out.println(stmt+"<--stmt");
	//stmt에 첫번째 ? 값을 noticeNo로 바꿀것이다 //String값일 경우 작은 따옴표도 출시
			
	int row = stmt.executeUpdate();
	if(row == 0){
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo);
	}else{ // 비밀번호틀려서 삭제행이 0행
		response.sendRedirect("./noticeList.jsp");	
	}
%>