<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석(컨트롤러 계층)
	// 1) session 내장개체
	// 2) request/reponse JSP내창 객체
	
	int currentPage = 1;
	//localName을 전체를 기본 설정
	String localName ="전체";
	
	
	//유효성 검사
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
	}
	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	int startRow = (currentPage-1)*rowPerPage;

	
	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	PreparedStatement subMenuStmt2 = null;
	ResultSet subMenuRs2 = null;
	PreparedStatement totalStmt = null;
	ResultSet totalRs = null;
	
	//submenu 출력을 위한 쿼리 작성
	String subMenuSql = "select '전체' localName,count(local_name) cnt from board union all select local_name localName,count(local_name) cnt from board group by local_name";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	System.out.println("home.subMenuStmt-->"+subMenuStmt);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	System.out.println("home.subMenuRs-->"+subMenuRs);
	
	//submenu로 나올 게시판 sql 분기 작성
	String subMenuSql2 = null;
	if(localName.equals("전체")){ //전체를 고를시에 where를 구문에서 삭제하여 전체에서 게시판 출력
		subMenuSql2 = "SELECT board_no boardNo, local_name localName,board_title boardTitle,substring(board_content,1,10) boardContent,member_id memberId FROM board limit ?,?";
		subMenuStmt2 = conn.prepareStatement(subMenuSql2);
		subMenuStmt2.setInt(1,startRow);
		subMenuStmt2.setInt(2,rowPerPage);
		System.out.println("home1.subMenuStmt2-->"+subMenuStmt2);
	} else { // ?를 통해 클릭한 값의 localName만 출력
		subMenuSql2 = "SELECT board_no boardNo,local_name localName,board_title boardTitle,substring(board_content,1,10) boardContent,member_id memberId FROM board WHERE local_name = ? limit ?,?";
		subMenuStmt2 = conn.prepareStatement(subMenuSql2);
		subMenuStmt2.setString(1,localName);
		subMenuStmt2.setInt(2,startRow);
		subMenuStmt2.setInt(3,rowPerPage);
		System.out.println("home2.subMenuStmt2-->"+subMenuStmt2);
	}
	subMenuRs2 = subMenuStmt2.executeQuery();
	System.out.println("home.subMenuRs2-->"+subMenuRs2);
	
	//페이지의 전체 행 구하는 쿼리문
	String totalRowSql = null;
	totalRowSql = "SELECT count(*) FROM board WHERE local_name=?";
	totalStmt = conn.prepareStatement(totalRowSql);
	totalStmt.setString(1,localName);
	totalRs = totalStmt.executeQuery();
	//디버깅
	System.out.println("totalStmt-->"+totalStmt);
	System.out.println("totalRs-->"+totalRs);
		
	//전체 페이지수를 구하고
	int totalRow = 0;
	if(totalRs.next()){
		totalRow=totalRs.getInt("count(*)");
	}
	int lastPage = totalRow/rowPerPage;
	//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
	if(totalRow%rowPerPage!=0){
		lastPage++;
	}
	
	// subMenuList <-- 모델데이터
	//서브메뉴 작성을 위한 해시맵 작성
	ArrayList<HashMap<String,Object>> subMenuList = new ArrayList<HashMap<String,Object>>();
	while(subMenuRs.next()){
		HashMap<String,Object> m = new HashMap<String,Object>();
		m.put("localName",subMenuRs.getString("localName"));
		m.put("cnt",subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	//게시판 작성을 위해 vo 패키지의 class 함수를 통해 값 가져오기 (boardNo는 나중에 게시판 연결을 위해 채택)
	ArrayList<Board> localNameList = new ArrayList<Board>();
	while(subMenuRs2.next()){
		Board b = new Board();
		b.boardNo = subMenuRs2.getInt("boardNo");
		b.localName = subMenuRs2.getString("localName");
		b.boardTitle = subMenuRs2.getString("boardTitle");
		b.boardContent = subMenuRs2.getString("boardContent");
		localNameList.add(b);
	}
	
	//페이지 이동 조건문 작성
	String addPage = "";
	if(localName != null && !localName.equals("")) {
		addPage += "&localName=" + localName;
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
	.con {
	  width: 50%; /* 원하는 크기로 조정 */
	  height: auto; /* 내용에 따라 크기 조정 */
	  margin: 0 auto;
	}
	
</style>
</head>
<body>
	<div class="con">
		<!-- 메인메뉴 (가로) -->
		<hr>
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div>
			<%
				if(request.getParameter("msg") != null){
			%>
					<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>
		</div>
		<hr>
		<!-- 서브메뉴 (세로) subMenuList모델을 출력 -->
		<div style="float:left;">
			<ul>
				<%
					for(HashMap<String,Object> m : subMenuList){
				%>		
						<li>
							<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
							<%=(String)m.get("localName") %>(<%=(Integer)m.get("cnt") %>)</a>
						</li>
				<%
					}
				%>
			</ul>
		</div>
			<!-- home내용: 로그인폼/ 카테고리별 게시글 5개씩 -->
			<!-- 로그인폼 -->
		<div style="float:right;">
			<%
				if(session.getAttribute("loginMemberId")==null){//로그인전이면 로그인폼 출력
			%>
					<form action="<%=request.getContextPath() %>/member/loginAction.jsp" method="post">
						<h2>로그인</h2>
						<table class="table">
							<tr>
								<td>아이디</td>
								<td><input class="form-control" type="text" name="memberId"></td>
							</tr>
							<tr>
								<td>패스워드</td>
								<td><input class="form-control" type="password" name="memberPw"></td>
							</tr>
						</table>
						<button style="float: right;" class="btn btn-primary" type="submit">로그인</button>
					</form>
					
			<%
				}
			%>
			
			<!-- 카테고리폼 -->
		</div>
		<!-- 게시판 10개 출력 -->
		<div>
			<table class="table">
				<tr>
					<th style="width:200px;">localName</th>
					<th style="width:300px;">localTitle</th>
					<th>boardContent</th>
				</tr>
			<%
				for(Board b : localNameList){
			%>
				<tr>
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.localName %></a></td>
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle %></a></td>
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardContent %></a></td>
				</tr>
			<%
				}
			%>
			</table>
		<%
			if(currentPage>1){
		%>
			<a class="btn btn-primary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage-1%>&addPage=<%=addPage%>">이전</a>
		<%
			}
		%>
			<a class="btn btn-primary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&addPage=<%=addPage%>"><%=currentPage %>페이지</a>
		<%
			if(currentPage<lastPage){
		%>
			<a class="btn btn-primary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage+1%>&addPage=<%=addPage%>">다음</a>
		<%
			}
		%>
		</div>
		<!-- copyright -->
		<div>
			<%
				//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response);
				//이 코드 액션태그로 변경하면 아래와 같다
			%>
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>