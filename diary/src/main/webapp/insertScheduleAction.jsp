<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf8");
	
	//유효성검사
	if(request.getParameter("scheduleDate")==null
			||request.getParameter("schedulePw")==null
			||request.getParameter("scheduleTime")==null
			||request.getParameter("scheduleColor")==null
			||request.getParameter("scheduleMemo")==null
			||request.getParameter("scheduleDate").equals("")
			||request.getParameter("schedulePw").equals("")
			||request.getParameter("scheduleTime").equals("")
			||request.getParameter("scheduleColor").equals("")
			||request.getParameter("scheduleMemo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("getparameter 오류");
		return;
	}
	
	//값 불러오기
	String scheduleDate = request.getParameter("scheduleDate");
	String schedulePw = request.getParameter("schedulePw");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	
	System.out.println("insert.scheduleDate-->" + scheduleDate);
	System.out.println("insert.scheduleTime-->" + scheduleTime);
	System.out.println("insert.scheduleColor-->" + scheduleColor);
	System.out.println("insert.scheduleMemo-->" + scheduleMemo);
	
	//입력 후에 sendredicetion으로 다시 반환하기 위해 문자열 자르기 이후 하단 리다이렉션으로 입력페이지 전환
	String y = scheduleDate.substring(0,4); //2023
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1; //3
	String d = scheduleDate.substring(8); //24
	
	System.out.println("insert.y-->" + y);
	System.out.println("insert.m-->" + m);
	System.out.println("insert.d-->" + d);
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//sql구문
	String sql = "insert into schedule (schedule_date, schedule_time, schedule_memo, schedule_color,schedule_pw,createdate,updatedate) values(?,?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//?값입력
	stmt.setString(1,scheduleDate);
	stmt.setString(2,scheduleTime);
	stmt.setString(3,scheduleMemo);
	stmt.setString(4,scheduleColor);
	stmt.setString(5,schedulePw);
	
	int row = stmt.executeUpdate();
	
	if(row==1){
		System.out.println("row출력정상");
	}else{
		System.out.println("row출력비정상");
	}
	//다시 스케줄 치는 폼으로 이동
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	
%>