<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
   
   //validation (요청 파라미터값 유효성 검사)
   request.setCharacterEncoding("utf-8");
   
   //불러온 값이 null이거나 공백이면 페이지 반환
   if(request.getParameter("noticeTitle")==null 
         || request.getParameter("noticeContent")==null
         || request.getParameter("noticeWriter")==null
         || request.getParameter("noticePw")==null
         || request.getParameter("noticeTitle").equals("")
         || request.getParameter("noticeContent").equals("")
         || request.getParameter("noticeWriter").equals("")
         || request.getParameter("noticePw").equals("")){
      
      response.sendRedirect("./insertNoticeForm.jsp");
      return;
   }

   String noticeTitle = request.getParameter("noticeTitle");
   String noticeContent = request.getParameter("noticeContent");
   String noticeWriter = request.getParameter("noticeWriter");
   String noticePw = request.getParameter("noticePw");
   
   //DB연동
   Class.forName("org.mariadb.jdbc.Driver"); //드라이버 부르기
   Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
   String sql = "insert into notice(notice_title,notice_content,notice_writer,notice_pw,createdate,updatedate) values(?,?,?,?,now(),now())";
   PreparedStatement stmt = conn.prepareStatement(sql);
   
   stmt.setString(1,noticeTitle);
   stmt.setString(2,noticeContent);
   stmt.setString(3,noticeWriter);
   stmt.setString(4,noticePw);
   int row = stmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다
   //row값을 이용한 디버깅
   
   //conn.setAutoCommit(true);//자동 커밋 디폴트값이 트루
   //conn.commit(); // 자동커밋 false일 경우 사용
   
   
   // redirection
   response.sendRedirect("./noticeList.jsp");
   
%>