<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import ="java.util.*" %>
<%@page import ="vo.*" %>
<%
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return; //1)코드진행종료 2)반환값을 남길때
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql ="select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,noticeNo); //stmt의 첫번째 물음표값을 noticeNo로 변경 //문자열은 '', setString
	System.out.println(stmt + "<-- stmt");
	ResultSet rs = stmt.executeQuery(); 
	
	//모델데이터// M:모델 V:모델값출력페이지 C:요청값을처리하는곳
	Notice n = null;
	if(rs.next()){ //행이하나일때 반복문이 필요없음 
		n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeOne.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="text-center"><!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	
	<h1 class="text-center">공지 상세</h1>
	
			<!-- view단 -->
			<table class="table table-bordered">
				<tr>
					<th class="table-warning text-center">notice_no</th>
					<td><%=n.noticeNo %></td>
				</tr>
				<tr>
					<th class="table-warning text-center">notice_title</th>
					<td><%=n.noticeTitle %></td>
				</tr>
				<tr>
					<th class="table-warning text-center">notice_content</th>
					<td><%=n.noticeContent %></td>
				</tr>
				<tr>
					<th class="table-warning text-center">notice_writer</th>
					<td><%=n.noticeWriter %></td>
				</tr>
				<tr>
					<th class="table-warning text-center">createdate</th>
					<td><%=n.createdate.substring(0,10) %></td>
				</tr>
				<tr>
					<th class="table-warning text-center">updatedate</th>
					<td><%=n.updatedate.substring(0,10) %></td>
				</tr>
		</table>
	<div class="text-center">
		<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>">수정</a>
		&nbsp;
		<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>">삭제</a>
	</div>
</body>
</html>