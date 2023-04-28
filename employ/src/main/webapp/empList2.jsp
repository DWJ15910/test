<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//----------------------------------------------디버깅 메세지 색칠---------------------------------------------
	final String RED = "\u001B[41m"; //페이지 수 출력 관련
	final String GREEN = "\u001B[42m"; // 쿼리문 관련
	final String YELLOW = "\u001B[43m"; // DB연결 관련
	final String BLUE = "\u001B[44m"; // 리스트,날짜 관련
	//-----------------------------------------------utf8인코딩-------------------------------------------------
	request.setCharacterEncoding("utf8");	

	//------------------------------------------------페이지설정-------------------------------------------------
	//기본 페이지 설정
	int currentPage = 1;	

	//페이지값이 null이 아닐경우 데이터 값 넘어온 currentPage값을 가져와서 currentPage에 int타입으로 선언
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println(RED+"currentPage는 null값이 아닙니다");
	}
	//디버깅 현재페이지만큼 currentPage 값이 나온다
	System.out.println(RED+"empList2.currentPage-->" + currentPage);
	
	//한 페이지에 보일 행의 수
	int rowperPage = 10;
	//행 출력시에 보일 행의 첫행 넘버
	int startrow = (currentPage-1)*rowperPage;
	
	//------------------------------------------------DB연동-----------------------------------------------------
	//DB연동
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println(YELLOW+"empList DB 드라이버 연동확인");
	//DB URL, ID, PW 작성
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbId = "root";
	String dbPw = "java1234";
	Connection conn = DriverManager.getConnection(dbUrl,dbId,dbPw);
	System.out.println(YELLOW+"empList DB 로그인확인");

	//-----------------------------------------------쿼리에 쓸 변수 작성-----------------------------------------------
	//null값이 둘다 아닐경우에 값을 대입해주기
	//gender와 name 둘다 공백 선언
	String gender = "";//성별 검색했을때 받는 곳
	//gender 나 name 값이 null값이 아닐 경우에는 form에서 action을 통해 가져온 값을 각각의 변수에 다시 대입 시켜준다
	if(request.getParameter("gender") != null) {
		gender = request.getParameter("gender");
		System.out.println(GREEN+"gender가 null이 아닙니다");
	}
	String name = "";//이름 검색했을때 받는 곳
	if(request.getParameter("name") != null) {
		name = request.getParameter("name");
		System.out.println(GREEN+"name이 null이 아닙니다");
	}
	String hireFirst = "1900";//입사일 검색 앞부분 받는 곳
	if(request.getParameter("hireFirst") != null) {
		hireFirst =request.getParameter("hireFirst");
		System.out.println(GREEN+"hireFirst는 null이 아닙니다");
	}
	String hireSecond = "2200";//입사일 검색 뒷부분 받는 곳
	if(request.getParameter("hireSecond") != null) {
		hireSecond = request.getParameter("hireSecond");
		System.out.println(GREEN+"hireSecond이 null이 아닙니다");
	}
	//input radio로 받아온 value값을 바탕으로 sql문 분기 작성
	
	//input checkbox에서 받아온 값을 스트링으로 저장
	String[] ageBox = request.getParameterValues("ageBox");
	//ageBox의 값을 int로 저장해줄 int타입의 배열선언
	int[] intAgeBox = null;
	
	//ageBox의 값을 받아 왔을때
	if(ageBox != null){
		//ageBox의 길이만큼 intAgeBox의 배열이 만들어진다
		intAgeBox = new int[ageBox.length];
			//그리고 ageBox배열[]번째의 값을 intAgeBox[]번째에 넣어준다
			for(int i =0; i<ageBox.length; i++){
			intAgeBox[i] = Integer.parseInt(ageBox[i]);
			}//for문닫기
	}//if문닫기
	
	//나이대 구하기용 sql문 작성
	String ageQuery2 = "";
	//intAgeBox가 null이 아니고 0보다 클때
	if(intAgeBox != null && intAgeBox.length > 0){
		//sql문에 in( 생성
	    ageQuery2 = "in (";
	    //intAgeBox의[0]번째 배열 값부터 차례대로 넣어준다
	    for(int i = 0; i < intAgeBox.length; i++){
	        ageQuery2 += intAgeBox[i];
	        //배열 값을 넣어주면서 마지막 번호전까지는 뒤에 쉼표도 붙여준다
	        if(i != intAgeBox.length - 1){
	            ageQuery2 += ",";
	        }
	    }
	    //모든 값 삽입이 끝나면 )를 닫아서 완성한다
	    ageQuery2 += ")";
	}
	
	//----------------------------------------------쿼리문 작성------------------------------------------------------
	//sql1을 기본 값으로 null 선언
	String sql1 = null;
	//stmt를 null값 선언(stmt가 내부 선언되어 다시 쓰기 위해 바깥에서 선언)
	PreparedStatement stmt = null;
	//SQL에서 YEAR만 출력하는 상태로 현재날짜-생일을 뺀 뒤 생일이 지나지 않았다면 -1을 하고, 나온 나이 값 중 앞부분만 출력
	String ageQuery = "LEFT(CASE WHEN MONTH(birth_date) > MONTH(CURDATE()) OR (MONTH(birth_date) = MONTH(CURDATE()) AND DAY(birth_date) > DAY(CURDATE())) THEN YEAR(CURDATE()) - YEAR(birth_date) - 1 ELSE YEAR(CURDATE()) - YEAR(birth_date) END,1)";
	//SQL에서 YEAR만 출력하는 상태로 현재날짜-생일을 뺀 뒤 생일이 지나지 않았다면 -1을 하고, 나온 나이 값 중 앞부분만 출력하는대 그앞에 유동적으로 사용할 수 있도록 AND 추가
	String ageQueryAnd = "AND LEFT(CASE WHEN MONTH(birth_date) > MONTH(CURDATE()) OR (MONTH(birth_date) = MONTH(CURDATE()) AND DAY(birth_date) > DAY(CURDATE())) THEN YEAR(CURDATE()) - YEAR(birth_date) - 1 ELSE YEAR(CURDATE()) - YEAR(birth_date) END,1)";
	
	//성별, 이름, 고용일, 나이대 모두 공백일 경우 기본 리스트를 실행한다
	if(gender.equals("") && name.equals("") && (hireFirst.equals("") && hireSecond.equals("") && ageQuery.equals(""))){
		sql1 = "SELECT emp_no,birth_date,first_name,last_name,gender,hire_date FROM employees LIMIT ?, ?";
		//해당 쿼리문을 DB에서 실행가능하도록 교체
		stmt = conn.prepareStatement(sql1);
		//?값 넣기
		stmt.setInt(1, startrow);
	    stmt.setInt(2, rowperPage);
	    //SQL쿼리문 실행 타입 확인 디버깅
		System.out.println(GREEN+"SQL쿼리문 실행 타입 1");
	//입사년도 검색이 공백 일경우 실행 되는 sql문
	}else{
		//성별, 이름, 고용일, 나이대 중 하나라도 검색할 경우 리스트에서 검색하여 실행한다
		sql1 = "SELECT emp_no,birth_date,first_name,last_name,gender,hire_date," +
				ageQuery+
				" FROM employees "+
				" where gender like ? "+
				" and concat(first_name,' ',last_name) like ? "+
				ageQueryAnd+
				ageQuery2+
				" AND YEAR(hire_date) BETWEEN ? AND ? "+
				" LIMIT ?, ?";
		//해당 쿼리문을 DB에서 실행가능하도록 교체
		stmt = conn.prepareStatement(sql1);
		//?값 넣기
		stmt.setString(1,"%"+gender+"%");
	    stmt.setString(2,"%"+name+"%");
	    stmt.setString(3, hireFirst);
	    stmt.setString(4, hireSecond);
	    stmt.setInt(5, startrow);
	    stmt.setInt(6, rowperPage);
	  //SQL쿼리문 실행 타입 확인 디버깅
	    System.out.println(GREEN+"SQL쿼리문 실행 타입 2");
	}
	
	//sql1을 기본 값으로 null 선언
		String sql2 = null;
		//stmt를 null값 선언(stmt가 내부 선언되어 다시 쓰기 위해 바깥에서 선언)
		PreparedStatement stmt2 = null;
		
		//성별, 이름, 고용일, 나이대 모두 공백일 경우 기본 리스트를 실행한다
		if(gender.equals("") && name.equals("") && (hireFirst.equals("") && hireSecond.equals("") && ageQuery.equals(""))){
			sql2 = "SELECT count(*) FROM employees";
			//해당 쿼리문을 DB에서 실행가능하도록 교체
			stmt2 = conn.prepareStatement(sql1);
			//?값 넣기
			stmt2.setInt(1, startrow);
		    stmt2.setInt(2, rowperPage);
		    //SQL쿼리문 실행 타입 확인 디버깅
			System.out.println(GREEN+"SQL쿼리문 실행 타입 3");
		//입사년도 검색이 공백 일경우 실행 되는 sql문
		}else{
			//성별, 이름, 고용일, 나이대 중 하나라도 검색할 경우 리스트에서 검색하여 실행한다
			sql2 = "SELECT count(*)" +
					" FROM employees "+
					" where gender like ? "+
					" and concat(first_name,' ',last_name) like ? "+
					ageQueryAnd+
					ageQuery2+
					" AND YEAR(hire_date) BETWEEN ? AND ? "+
					" LIMIT ?, ?";
			//해당 쿼리문을 DB에서 실행가능하도록 교체
			stmt2 = conn.prepareStatement(sql2);
			//?값 넣기
			stmt2.setString(1,"%"+gender+"%");
		    stmt2.setString(2,"%"+name+"%");
		    stmt2.setString(3, hireFirst);
		    stmt2.setString(4, hireSecond);
		    stmt2.setInt(5, startrow);
		    stmt2.setInt(6, rowperPage);
		  //SQL쿼리문 실행 타입 확인 디버깅
		    System.out.println(GREEN+"SQL쿼리문 실행 타입 4");
		}
	
	//STMT 디버깅
	System.out.println(GREEN+"empList2.stmt-->" + stmt);
	System.out.println(GREEN+"empList2.stmt2-->" + stmt2);
	
	//stmt,stmt2를 ResultSet 형태로 저장
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	//RS 디버깅
	System.out.println(GREEN+"empList2.rs-->" + rs);
	System.out.println(GREEN+"empList2.rs2-->" + rs2);
	
	//------------------------------------------------------ArrayList작성-------------------------------------------
	//employList에 들어갈 자료들 조회
	//ArrayList 제작
	ArrayList<Employ> employList = new ArrayList<Employ>();
	while(rs.next()){
		Employ e = new Employ();
		e.empNo = rs.getInt("emp_no");
		e.birthDate = rs.getString("birth_date");
		e.firstName = rs.getString("first_name");
		e.lastName = rs.getString("last_name");
		e.gender = rs.getString("gender");
		e.hireDate = rs.getString("hire_date");
		employList.add(e);
	}
	
	//-----------------------------------------------------페이지 수 구하기--------------------------------------------
	//전체 행의 수, 마지막 페이지 구하기
	int totalRow = 0;
	//SQL문에서 받아서온 count(*)로 전체 행의 개수 출력을 한다
	if(rs2.next()) {
			totalRow = rs2.getInt("count(*)");
		}
	System.out.println(RED+"empList2.totalRow-->" + totalRow);
	
	//마지막 페이지 구하기
	int lastPage = totalRow/rowperPage;
	
	//한페이지 당 행의 수로 나눠지지 않을시에 마지막 페이지 +1
	if(totalRow % rowperPage !=0){
		lastPage=lastPage+1;
	}
	System.out.println(RED+"empList2.lastPage-->" + lastPage);
	
	//-------------------------------------------------------나이 구하기-----------------------------------------------
	//오늘 날짜 데이터 구하기
	Calendar today = Calendar.getInstance();
	System.out.println(BLUE+"empList2.today -->" + today);
	
	//오늘 날짜의 년,월,일 구하기
	int todayYear = today.get(Calendar.YEAR);
	int todayMonth = today.get(Calendar.MONTH)+1;
	int todayDay = today.get(Calendar.DATE);
	//오늘 날짜 디버깅
	System.out.println(BLUE+"empList2.todayYear -->" + todayYear);
	System.out.println(BLUE+"empList2.todayMonth -->" + todayMonth);
	System.out.println(BLUE+"empList2.todayDay -->" + todayDay);
	
	//age를 배열형태로 저장하기 위해 forreach 문 선언
	for(Employ e : employList){

	//e.birthDate로 가져온 값을 년,월,일로 substring으로 쪼갠뒤 각각 int 타입으로 저장
	int birthYear = Integer.parseInt(e.birthDate.substring(0,4));
	int birthMonth = Integer.parseInt(e.birthDate.substring(5,7));
	int birthDay = Integer.parseInt(e.birthDate.substring(8));
	e.age = todayYear-birthYear;
	
	//생일이 지났으면 현재년도-생년
	//생일이 지나지 않았으면 현재년도-생년-1
	if (birthMonth>todayMonth 
			||(birthMonth==todayMonth && birthDay>todayDay)){
				e.age = todayYear-birthYear-1;
			}else{
				e.age = todayYear-birthYear;
			}
	}
	//-----------------------------------------------------뷰---------------------------------------------------------------
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	img {
		width:20px;
		height: 20px;
	}
	h1{
		padding:30px;
	}
</style>
</head>
<body>
	<div class="container">
	<!-- 제목 -->
	<h1 style="text-align:center; ">empList</h1>
	
	<!-- form 열기 -->
	<form action="./empList2.jsp">
	
	<!-- 홈 버튼 -->
	<a style="float:left; font-weight: bold;" class="btn btn-outline-info" href="./empList2.jsp">리스트로</a>
	
	<!-- 검색창 -->
	<div style="float:right;">
		<!-- 성별 검색 -->
		<label>성별 : </label>
		<select name="gender">
			<%
				if (gender.equals("")){
			%>
				<option value="" selected="selected">선택</option>
				<option value="M">남</option>
				<option value="F">여</option>
			<%
				} else if (gender.equals("M")){
			%>
				<option value="">선택</option>
				<option value="M" selected="selected">남</option>
				<option value="F">여</option>
			<%
				} else if (gender.equals("F")){
			%>
				<option value="">선택</option>
				<option value="M">남</option>
				<option value="F" selected="selected">여</option>
			<%
				}
			%>
		</select>
		<!-- 이름 검색 -->
		<input type ="text" name="name" placeholder="이름 검색" value="<%=name%>">
		<input type ="number" name="hireFirst" placeholder="입사년도" value="<%=hireFirst%>"> -
		<input type ="number" name="hireSecond" placeholder="입사년도" value="<%=hireSecond%>">
		<%
			//age의 나이대 앞자리 나열
			int[] age = {1,2,3,4,5,6,7,8,9};
			//int a가 age배열을 참조
			for(int a : age){
				//기본 checked속성 fasle로 실행
				boolean checked = false;
				//체크해서 보낸 ageBox데이터를 다시 받아오기
			    ageBox = request.getParameterValues("ageBox");
				//받아온 ageBox가 null이 아닐경우에만 실행
			    if (ageBox != null) {
			    	//ageBox의 0번배열부터 쭉 검색
			        for (int i = 0; i < ageBox.length; i++) {
			        	//ageBox배열이 a와 같다면 check를 true로 변경
			            if (ageBox[i].equals(Integer.toString(a))) {
			                checked = true;
			            }//if문닫기
			        }//for문닫기
			    }//if문닫기
		%>	
				<input type="checkbox" name="ageBox" <%=checked ? "checked" : "" %> value="<%=a %>"><%=a %>0대
		<%
			}
		%>
		
		<!-- 정보 보내기 -->
		<button class="btn btn-secondary" type="submit">검색</button>
	</div><br>
	<!-- 검색창 끝 -->
	
	<!-- 리스트 테이블 -->
		<table class="table table-striped">
			<thead>
			<!-- DB기준 열이름 나열 -->
				<tr>
					<th style="width:200px;">
						emp_no
					</th>
					<th style="width:200px;">
						age
					</th>
					<th style="width:250px;">
						first_name
					</th>
					<th style="width:250px;">
						last_name
					</th>
					<th style="width:200px;">
						gender
					</th>
					<th>
						hire_date
					</th>
				</tr>
			<!-- 열이름 나열 종료 -->
			</thead>
			
			<!-- 리스트 출력 -->
			<tbody>
				<%
					for(Employ e : employList){
				%>

				<tr>
					<td>
						<!-- 번호 출력 -->
						<%=e.empNo%>
					</td>
					<td>
						<!-- 나이 출력 -->
						<%=e.age %>
					</td>
					<td>
						<!-- 앞 이름 출력 -->
						<%=e.firstName%>
					</td>
					<td>
						<!-- 뒤 이름 출력 -->
						<%=e.lastName%>
					</td>
					<td>
						<!-- M 또는 F 값을 받고 사진이름을 통해 출력 -->
						<div><img src="./img/<%=e.gender%>.JPG"></div>
					</td>
					<td>
						<!-- 고용일 출력 -->
						<%=e.hireDate%>
					</td>
				</tr>
				<% 
					}
				%>
				
			<!-- 리스트 출력종료 -->
			</tbody>
		<!-- 리스트부분 끝 -->
		</table>
		
		<!-- 페이지 출력부분 -->
		<div style="text-align: center">
		<%
			//현재페이지가 1보다 클경우만 이전 페이지로 갈수 있도록 설정
			if(currentPage>1){
			//페이지 뒤에 url추가 주소값을 넣기위한(검색했을때 검색정보값) 스트링 변수선언
			String queryString = "";
				//gender가 null이나 공백이 아닐때 gender값을 주소에 추가
				if(gender != null && !gender.equals("")) {
					//ex)gender에서 '남'을 검색하면 &gender=M 출력
					queryString += "&gender=" + gender;
				}//gender If문 닫기
				//name이 null이나 공백이 아닐때 name값을 주소에 추가
				if(name != null && !name.equals("")) {
					queryString += "&name=" + name;
				}//name IF문 닫기
				if(hireFirst !=null && !hireFirst.equals("")) {
					queryString += "&hireFirst=" + hireFirst;
				}//hireFist IF문 닫기
				if(hireSecond !=null && !hireSecond.equals("")) {
					queryString += "&hireSecond=" + hireSecond;
				}//hireFist IF문 닫기
				if(ageBox !=null && ageBox.length>0) {
					//ageBox의 길이만큼 실행
					for(int i = 0; i < ageBox.length; i++){
						//ageBox의 값이 공백이 아니라면 ageBox에 값 추가해주고 queryString에 추가 만약 공백이면 탈출
						if(!ageBox[i].equals("")){
						queryString += "&ageBox=" + ageBox[i];
						}//if문닫기
					}//for문닫기
				}//ageBox IF문 닫기
				System.out.println(RED+"queryString이전"+queryString);
		%>
				<a class="btn btn-primary" href="./empList2.jsp?currentPage=<%=currentPage-1%><%=queryString%>">이전</a>
		<%
				}//currentPage>1 IF문 닫기
		%>
				<!-- 현재페이지 출력 -->
				<a class="btn btn-primary">현재페이지<%=currentPage%></a>
		<%
			//현재페이지가 lastPage보다 적을 경우에만 다음페이지가 보이도록 설정
			if(currentPage<lastPage){
				//변수를 하나 선언해준 뒤 검색해준 항목이 있을때만 해당 항목을 변수에 추가 선언하여 출력
				String queryString = "";
				//gender가 null이나 공백이 아닐때 gender값을 주소에 추가
				if(gender != null && !gender.equals("")) {
					//ex)gender에서 '남'을 검색하면 &gender=M 출력
					queryString += "&gender=" + gender;
				}//gender If문 닫기
				//name이 null이나 공백이 아닐때 name값을 주소에 추가
				if(name != null && !name.equals("")) {
					queryString += "&name=" + name;
				}//name If문 닫기
				if(hireFirst!=null && !hireFirst.equals("")) {
					queryString += "&hireFirst=" + hireFirst;
				}//hireFist IF문 닫기
				if(hireSecond !=null && !hireSecond.equals("")) {
					queryString += "&hireSecond=" + hireSecond;
				}//hireFist IF문 닫기
				if(ageBox !=null && ageBox.length>0) {
					//ageBox의 길이만큼 실행
					for(int i = 0; i < ageBox.length; i++){
						//ageBox의 값이 공백이 아니라면 ageBox에 값 추가해주고 queryString에 추가 만약 공백이면 탈출
						if(!ageBox[i].equals("")){
						queryString += "&ageBox=" + ageBox[i];
						}//if문닫기
					}//for문 닫기
				}//ageBox IF문 닫기
				System.out.println(RED+"queryString다음"+queryString);
		%>
				<a class="btn btn-primary" href="./empList2.jsp?currentPage=<%=currentPage+1%><%=queryString%>">다음</a>
		<%
				//전부다 활성화 되어 있지않을 경우 페이지넘기기
			}//currentPage닫기
		%>
		</div>
		<!-- 페이지 출력분 끝 -->
	</form>
	<!-- form 닫기 -->
	<!-- 검색 조건 -->
	<table class="table table-striped" style="width:70%;">
		<tr>
			<th style="width:150px;">성별:</th>
			<td style="width:150px;"><%=gender %></td>
			<th style="width:150px;">이름:</th>
			<td style="width:150px;"> <%=name %></td>
			<th style="width:150px;">입사년도:</th>
			<td><%=hireFirst %> - <%=hireSecond %></td>
		</tr>
	<!--  검색 조건 닫기 -->
	</table>
	
	<!-- contaioner 닫기 -->
	</div>
</body>
</html>