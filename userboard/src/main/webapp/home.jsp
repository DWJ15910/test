<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String subMenuSql = "select '전체' localName,count(local_name) cnt from board union all select local_name localName,count(local_name) cnt from board group by local_name";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	
	// subMenuList <-- 모델데이터
	ArrayList<HashMap<String,Object>> subMenuList = new ArrayList<HashMap<String,Object>>();
	while(subMenuRs.next()){
		HashMap<String,Object> m = new HashMap<String,Object>();
		m.put("localName",subMenuRs.getString("localName"));
		m.put("cnt",subMenuRs.getInt("cnt"));
		subMenuList.add(m);
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
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 (세로) subMenuList모델을 출력 -->
		<div>
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
			<%
				if(request.getParameter("msg") != null){
			%>
					<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>
		<div>
			<!-- home내용: 로그인폼/ 카테고리별 게시글 5개씩 -->
			<!-- 로그인폼 -->
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
						<button class="btn btn-primary" type="submit">로그인</button>
					</form>
					
			<%
				}
			%>
			
			<!-- 카테고리폼 -->
		</div>
		
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