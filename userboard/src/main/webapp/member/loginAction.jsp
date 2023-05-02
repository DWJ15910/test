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
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	//디버깅
	System.out.println("memberId-->"+memberId);
	System.out.println("memberPw-->"+memberPw);
	Member paramMember = new Member();
	paramMember.memberId = memberId;
	paramMember.memberPw = memberPw;
	
	
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? and member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,paramMember.memberId);
	stmt.setString(2,paramMember.memberPw);
	rs = stmt.executeQuery();
	System.out.println("rs성공"+rs);
	
	if(rs.next()){//로그인성공
		//세션에 로그인 정보 (memberId)저장
		session.setAttribute("loginMemberId",rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
	} else {//로그인실패
		System.out.println("로그인실패");
	}

	String msg = URLEncoder.encode(memberId+"님 안녕하세요","utf-8");
	response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
%>