<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	//한글 인코딩
	request.setCharacterEncoding("utf8");
	
	//불러온 값이 ""이거나 null일경우 다시 입력페이지 반환
	if(request.getParameter("storeName")==null
			||request.getParameter("storeCategory")==null
			||request.getParameter("storeAddress")==null
			||request.getParameter("storeEmpCnt")==null
			||request.getParameter("storeBegin")==null
			||request.getParameter("storeName").equals("")
			||request.getParameter("storeCategory").equals("")
			||request.getParameter("storeAddress").equals("")
			||request.getParameter("storeEmpCnt").equals("")
			||request.getParameter("storeBegin").equals("")){
		
		response.sendRedirect("./insertStoreForm.jsp");
		return;
	}
	
	//insertStoreForm에서 데이터 받아오기
	String storeName = request.getParameter("storeName");
	String storeCategory = request.getParameter("storeCategory");
	String storeAddress = request.getParameter("storeAddress");
	int storeEmpCnt = Integer.parseInt(request.getParameter("storeEmpCnt"));
	String storeBegin = request.getParameter("storeBegin");
	//디버깅
	System.out.println(storeName+"<--storeName");
	System.out.println(storeCategory+"<--storeCategory");
	System.out.println(storeAddress+"<--storeAddress");
	System.out.println(storeEmpCnt+"<--storeEmpCnt");
	System.out.println(storeBegin+"<--storeBegin");
	
	//DB연동
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/homework0419","root","java1234");
	//sql 구문 : store_no를 제외한 모든 셀에 값을 집어넣기 (날짜는 추가버튼 누를시에 당시 시간 입력)
	String sql = "insert into store(store_name,store_category,store_address,store_emp_cnt,store_begin,createdate,updatedate) values(?,?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//stmt 디버깅
	System.out.println(stmt+"<--stmt");
	
	//sql에 ?문 대체 넣어주기
	stmt.setString(1,storeName);
	System.out.println(stmt+"<--stmt1");
	stmt.setString(2,storeCategory);
	System.out.println(stmt+"<--stmt2");
	stmt.setString(3,storeAddress);
	System.out.println(stmt+"<--stmt3");
	stmt.setInt(4,storeEmpCnt);
	System.out.println(stmt+"<--stmt4");
	stmt.setString(5,storeBegin);
	System.out.println(stmt+"<--stmt5");
	
	
	//row값이 1일 경우 1행반환
	int row = stmt.executeUpdate();
	//row값 디버깅
	System.out.println(row+"<--row");
	
	response.sendRedirect("./storeList.jsp");
%>