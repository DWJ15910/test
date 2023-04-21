<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	//가져온 값이 null이거나 ""이면 updateNoticeForm페이지로 이동
	String msg = null;
	
	if(request.getParameter("noticeTitle")==null 
	      || request.getParameter("noticeTitle").equals("")) {
	      msg = "noticeTitle is required";
	} else if(request.getParameter("noticeContent")==null 
	      || request.getParameter("noticeContent").equals("")) {
	      msg = "noticeContent is required";
	} else if(request.getParameter("noticePw")==null 
	      || request.getParameter("noticePw").equals("")) {
	      msg = "noticePw is required";
	}
	
	if(request.getParameter("noticeNo")==null
		||request.getParameter("noticeTitle").equals("")){
		 response.sendRedirect("./noticeList.jsp");
		 return;
	}
	
	if(msg != null) { // 위 ifelse문에 하나라도 해당된다
	   response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
	                     +request.getParameter("noticeNo")
	                     +"&msg"+msg);
		return;
	}
	
	
	//updateNoticeForm에서 값불러오기
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	
	//디버깅
	System.out.println(noticeNo + "<--noticeNo");
	System.out.println(noticePw + "<--noticePw");
	System.out.println(noticeTitle + "<--noticeTitle");
	System.out.println(noticeContent + "<--noticeContent");
	
	//드라이버 부르기
	Class.forName("org.mariadb.jdbc.Driver");
	//드라이버 디버깅
	System.out.println("드라이버 확인");
	
	//DB연결확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//DB연결 확인 디버깅
	System.out.println(conn + "DB연결 확인");
	
	//sql 구문작성 및 sql구문이 mariadb에서 사용가능하도록 변경
	String sql = "update notice set notice_title = ?, notice_content = ?, updatedate=now() where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//stmt1 디버깅
	System.out.println(stmt + "<--stmt1 출력확인");
	
	//?값들 교체
	stmt.setString(1,noticeTitle);
	stmt.setString(2,noticeContent);
	stmt.setInt(3,noticeNo);
	stmt.setString(4,noticePw);
	//stmt2 디버깅
	System.out.println(stmt + "<--stmt2 출력확인");
	
	//모두 제대로 적었는지 확인
	int row = stmt.executeUpdate();
	
	//row 디버깅
	System.out.println(row + "<--row 출력확인");
	
	//row가 0(잘못적었으면) 그전 페이지로 이동 잘적었으면 리스트페이지로 이동
	if(row==0){
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
	            +noticeNo
	            +"&msg=incorrect noticePw");
	}else{
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	}

%>