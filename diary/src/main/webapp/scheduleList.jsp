<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
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
	
	// targetMonth 1일의 요일
	Calendar firstDay = Calendar.getInstance();
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1);
	
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
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div><!-- 메인메뉴 -->
		<a class="btn btn-secondary" href="./home.jsp">홈으로</a>
		<a class="btn btn-secondary" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp">일정 리스트</a>
	</div>
		<h1><%=targetYear %>년 <%=targetMonth+1%>월</h1>
	<div>
		<a class="btn btn-secondary" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<a class="btn btn-secondary" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</div>
	
	<table class="table table-striped">
		<tr>
			<th>일</th>
			<th>월</th>
			<th>화</th>
			<th>수</th>
			<th>목</th>
			<th>금</th>
			<th>토</th>
		</tr>
		
		<tr>
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
						<td style="<%=tdStyle%>">
							<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=dateNum%>"><%=dateNum%></a>
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
</body>
</html>