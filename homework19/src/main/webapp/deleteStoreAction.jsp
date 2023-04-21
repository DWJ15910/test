<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	//한글 안깨지게 해주기
	request.setCharacterEncoding("utf-8");

	//store_no랑 store_pw가 null값이나 ""값이면 deleteStoreForm페이지가 다시나오도록 
	if(request.getParameter("storeNo")==null
		||request.getParameter("storePw")==null
		||request.getParameter("storeNo").equals("")
		||request.getParameter("storePw").equals("")){
			response.sendRedirect("./deleteStoreForm.jsp");
			return;
		}
	
	//store_no 와 store_pw 변수 가져와서 선언
	int storeNo = Integer.parseInt(request.getParameter("storeNo"));
	String storePw = request.getParameter("storePw");
	
	//디버깅 확인완료
	System.out.println(storeNo + "<--deleteStoreAction storeNo 출력");
	System.out.println(storePw + "<--deleteStoreAction storePw 출력");
	
	//드라이버 연결확인
	Class.forName("org.mariadb.jdbc.Driver");
	//드라이버 연결확인 디버깅 확인
	System.out.println("deleteStoreAction 드라이버연결확인");
	
	//DB서버에 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/homework0419","root","java1234");
	//DB서버 로그인 디버깅 확인
	System.out.println(conn + "<--deleteStoreAction DB서버 연결 확인");
	
	//sql문 작성
	String sql = "delete from store where store_no = ? and store_pw = ?";
	//sql문이 db에서 구동되도록 설정
	PreparedStatement stmt = conn.prepareStatement(sql);
	//stmt 디버깅
	System.out.println(stmt + "<--stmt 디버깅 1 확인");
	
	//?에 값넣기
	stmt.setInt(1,storeNo);
	stmt.setString(2,storePw);
	//?에 값 제대로 들어갔는지 디버깅
	System.out.println(stmt + "<--stmt 디버깅 2 확인");
	
	int row = stmt.executeUpdate();
	//sql 구문이 맞을때는 row 1반환 틀리면 0반환 디버깅 확인
	System.out.println(row+"<--row값 확인");
	
	//row가 0일 경우에는 다시 삭제 페이지로 이동(storeNo값을 가져와서 다시 칠수 있도록)
	if(row==0){
		response.sendRedirect("./deleteStoreForm.jsp?storeNo="+storeNo);
	}else{
		//row가 0이 아닐 경우에는 정상 가동 되어서 storeList 페이지 출력
		response.sendRedirect("./storeList.jsp");
	}
%>