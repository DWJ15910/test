<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	request.setCharacterEncoding("utf-8");
	//페이지 null이나 ""값오면 storeList페이지로 반환
	if(request.getParameter("storeNo")==null
		||request.getParameter("storePw")==null
		||request.getParameter("storeName")==null
		||request.getParameter("storeCategory")==null
		||request.getParameter("storeAddress")==null
		||request.getParameter("storeEmpCnt")==null
		||request.getParameter("storeBegin")==null
		||request.getParameter("storeNo").equals("")
		||request.getParameter("storePw").equals("")
		||request.getParameter("storeName").equals("")
		||request.getParameter("storeCategory").equals("")
		||request.getParameter("storeAddress").equals("")
		||request.getParameter("storeEmpCnt").equals("")
		||request.getParameter("storeBegin").equals("")){
	
			response.sendRedirect("./storeList.jsp");
			return;
		}
	
	//값 불러오기
	int storeNo = Integer.parseInt(request.getParameter("storeNo"));
	String storePw = request.getParameter("storePw");
	String storeName = request.getParameter("storeName");
	String storeCategory = request.getParameter("storeCategory");
	String storeAddress = request.getParameter("storeAddress");
	int storeEmpCnt = Integer.parseInt(request.getParameter("storeEmpCnt"));
	String storeBegin = request.getParameter("storeBegin");
	
	//값 디버깅
	System.out.println("updateAction storeNo:" + storeNo);
	System.out.println("updateAction storePw:" + storePw);
	System.out.println("updateAction storeName:" + storeName);
	System.out.println("updateAction storeCategory:" + storeCategory);
	System.out.println("updateAction storeAddress:" + storeAddress);
	System.out.println("updateAction storeEmpCnt:" + storeEmpCnt);
	System.out.println("updateAction storeBegin:" + storeBegin);
	
	//괄호안에 있는 jdbc Driver를 로드
	Class.forName("org.mariadb.jdbc.Driver");
	//드라이버 디버깅
	System.out.println("updateAction 드라이버 확인");
	
	//DB연결확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/homework0419","root","java1234");
	//DB연결 확인 디버깅
	System.out.println("updateAction DB연결 확인-->" + conn);
	
	//sql 구문작성 및 sql구문이 mariadb에서 사용가능하도록 변경
	String sql = "update store set store_name=?,store_category=?,store_address=?,store_emp_cnt=?,store_begin=?, updatedate=now() where store_no = ? and store_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//stmt1 디버깅
	System.out.println("updateAction stmt1 출력확인-->" + stmt);
	
	//?값들 교체
	stmt.setString(1,storeName);
	stmt.setString(2,storeCategory);
	stmt.setString(3,storeAddress);
	stmt.setInt(4,storeEmpCnt);
	stmt.setString(5,storeBegin);
	stmt.setInt(6,storeNo);
	stmt.setString(7,storePw);
	//stmt2 디버깅
	System.out.println("updateAction stmt2 출력확인-->" + stmt);
	
	//모두 제대로 적었는지 확인
	int row = stmt.executeUpdate();
	//row 디버깅
	//0이면 오류값있는걸로 sql구문쪽 재확인 1이면 정상
	System.out.println("updateActoin row 확인-->" + row);
	
	//row가 0(잘못적었으면) 수정페이지로 이동
	if(row==0){
		response.sendRedirect("./updateStoreForm.jsp?storeNo="+storeNo);
	}else{//정상일 경우 해당 상세페이지 출력
		response.sendRedirect("./storeDetail.jsp?storeNo="+storeNo);
	}
%>