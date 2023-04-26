<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	//년 or 월이 요청값에 넘어오지 않으면 오늘 날짜 년,월 출력
	if(request.getParameter("targetYear") == null
			||request.getParameter("targetMonth") == null) {
				Calendar c = Calendar.getInstance();
				targetYear = c.get(Calendar.YEAR);
				targetMonth = c.get(Calendar.MONTH);
				System.out.println("값없음");
			} else {
				targetYear = Integer.parseInt(request.getParameter("targetYear"));
				targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
				System.out.println("값있음");
/*				
				//이전달 다음달 넘어갈때 1월이전 또는 12월 이후로 가면 년도,월 변경
				if(targetMonth==-1){
					targetYear = targetYear - 1;
					targetMonth = 11;
				} else if(targetMonth == 12) {
					targetYear = targetYear + 1;
					targetMonth = 0;
				}*/
			}

	System.out.println("scheduleList.targetYear-->" + targetYear);
	System.out.println("scheduleList.targetMonth-->" + targetMonth);
	
	//오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	// firstDay라는 Calendar의 변수에 Calendar객체에서 받아온 값을 넣는다
	Calendar firstDay = Calendar.getInstance();
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1);
	
	//secondDay라는 Calendar의 변수에 Calendar객체에서 받아온 값을 넣는다
	Calendar secondDay = Calendar.getInstance();
	secondDay.set(Calendar.YEAR, targetYear);
	secondDay.set(Calendar.MONTH, targetMonth-1);
	secondDay.set(Calendar.DATE, 1);
	
	//날짜를 넘길때 MONTH가 12가넘기면 MONTH는 1 YEAR은 +1이 되고
	//MONTH가 1에서 이전으로 가면 MONTH는 12 YEAR는 -1이 된다
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	
	//고른 년월의 1일이 일주일중 몇번째 인지 ex)일=1 ~토=7
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK);
	
	//1일 앞의 공백칸의 수
	int startBlank = firstYoil - 1;
	System.out.println("scheduleList.startBlank-->" + startBlank);
	
	// targetMonth 마지막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	System.out.println("scheduleList.lastDate-->" + lastDate);
	
	int lastDate2 = secondDay.getActualMaximum(Calendar.DATE);
	System.out.println("scheduleList.lastDate2-->" + lastDate2);
	
	// lastDate 날짜 뒤 공백칸의 수
	int endBlank = 0;
	if((startBlank + lastDate + endBlank)%7!=0){
		endBlank = 7-(startBlank+lastDate)%7;
	}
	System.out.println("scheduleList.endBlank-->" + endBlank);
	
	//전체 Td의 갯수
	int totalTd = startBlank + lastDate + endBlank;
	System.out.println("scheduleList.totalTd-->" + totalTd);
	
	// DB data를 가져오는 알고리즘
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//sql구문
	String sql = "select schedule_no scheduleNo, substr(schedule_memo,1,5) scheduleMemo,schedule_color scheduleColor,day(schedule_date) scheduleDate from schedule where year(schedule_date)=? and month(schedule_date)=? order by month(schedule_date) asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,targetYear);
	stmt.setInt(2,targetMonth+1);
	
	ResultSet rs = stmt.executeQuery();
	
	// ResultSet - > ArrayList<Schedule> 
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");// 전체날짜가 아닌 일(day)만
		s.scheduleMemo = rs.getString("scheduleMemo");//전체가 아닌 5글자만 
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	td {
		width: 10%;
		height: 110px;
		overflow: hidden;
		position: relative;
	}
	.con {
		position: absolute;
		padding-bottom: 30px;
	}
	a{
		text-decoration: none;
		color: #000000;
		font-size: 12pt;
		font-weight: bold;
	}
	.asdf {/* 표시할 텍스트 줄 수 */
		
	}
</style>
</head>
<body>	
	<div class="container">
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp">일정 리스트</a>
	</div>
		<div class="row">
			<h1 class="text-center"><%=targetYear %>년 <%=targetMonth+1%>월</h1>
		</div>
	<div class="row">
		<div class="col-sm-6 text-white text-left">
			<a class="btn btn-secondary" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		</div>
		<div style ="text-align: right" class="col-sm-6 text-white text-right">
			<a class="btn btn-secondary" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
		</div>
	</div>
	
	<table class="table table-striped">
		<tr style="height:50px;">
			<th>일</th>
			<th>월</th>
			<th>화</th>
			<th>수</th>
			<th>목</th>
			<th>금</th>
			<th>토</th>
		</tr>
		
		<tr style="height:100px;">
			<%
				for(int i = 0; i<totalTd; i++){
					int dateNum = i-startBlank+1;
					if(i != 0 && i%7==0){
			%>
						</tr><tr>
			<%
					} // if문 tr 행변환 닫기
			%>
			<%		
					String tdStyle = "";
					if(dateNum > 0 && dateNum<=lastDate){
						
						if(today.get(Calendar.YEAR) == targetYear
								&& today.get(Calendar.MONTH) == targetMonth
								&& today.get(Calendar.DATE) == dateNum){
								tdStyle = "background-color:orange;";
								
						}
			%>
						
						<td class="asdf" style="<%=tdStyle%>">
						<div class="con">
							<div><!-- 날짜 숫자 -->
								<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=dateNum%>"><%=dateNum%></a>
							</div>
							<div><!-- 일정 memo(5글자만) -->
								<%
									for(Schedule s : scheduleList){
										if(dateNum == Integer.parseInt(s.scheduleDate)){		
											
								%>
										<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo %></div>
								<%
										}
									}
								%>
							</div>
						</div>
							
						</td>
			<%
					
						
					} else if(dateNum<=0){
			%>
						<td style="color:gray;"><%=dateNum+lastDate2%></td>
			<%
					} else {
			%>
						<td style="color:gray;"><%=dateNum-lastDate%></td>
			<%
					}
			
				}
			%>
		</tr>
	</table>
	</div>
</body>
</html>