<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import ="java.util.*" %>
<%@page import ="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="text-center "><!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	
	<!-- 날짜순 최근 공지 5개 -->
	<%
		/*	
			select notice_title, createdate from 
			notice order by createdate desc
			limit 0,5
		*/
	
		//드라이브 로딩 
		Class.forName("org.mariadb.jdbc.Driver");
		
		//db접속정보 저장
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		
		//문자열 정보의 쿼리생성
		String sql1= "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0,5";
		
		PreparedStatement stmt = conn.prepareStatement(sql1);
		System.out.println(stmt + "<-- stmt");
		
		//쿼리실행 _ 아주 특수한 형태의 배열 > 나중에 ArrayList로 변경하는게 좋음
		ResultSet rs1 = stmt.executeQuery(); 
		
		//ResultSet -> ArrayList<Notice>
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs1.next()){
			Notice n = new Notice();
			n.noticeNo = rs1.getInt("noticeNo");
			n.noticeTitle = rs1.getString("noticeTitle");
			n.createdate = rs1.getString("createdate");
			noticeList.add(n);
		}
		
		//오늘일정
		/*
			SELECT schedule_date,schedule_time,substr(schedule_memo,1,10) memo
			FROM SCHEDULE
			WHERE schedule_date = CURDATE()
			ORDER BY schedule_time asc;
		*/
		String sql2="select schedule_no scheduleNo, schedule_date scheduleDate,schedule_time scheduleTime,substr(schedule_memo,1,10) memo from schedule where schedule_date = curdate() order by schedule_time asc";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(stmt + "<-- stmt2");
		
		//ResultSet -> ArrayList<schedule>
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()){
			Schedule s = new Schedule();
			s.scheduleNo = rs2.getInt("scheduleNo");
			s.scheduleDate = rs2.getString("scheduleDate"); 
			s.scheduleMemo = rs2.getString("memo"); //전체 메모가 아닌 10글자만 들어가 있음
			s.scheduleTime = rs2.getString("scheduleTime");
			scheduleList.add(s);
		}
		
		
	%>
	<h1 class="text-center">공지사항</h1>
	<table class="table table-bordered">
		<tr>
			<th class="table-warning text-center">notice_title</th>
			<th class="table-warning text-center">createdate</th>
		</tr>
		<%
			for(Notice n : noticeList){
		%>
			<tr>
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
					<%=n.noticeTitle %>
					</a>
				</td>
				<td><%=n.createdate.substring(0,10) %></td> <!-- 0~9자리까지 자름 -->
			</tr>
		<%
			}
		%>
	</table>
	<h1 class="text-center">오늘 일정</h1>
	<table class="table table-bordered">
		<tr>
			<th class="table-warning text-center">schedule_date</th>
			<th class="table-warning text-center">schedule_time</th>
			<th class="table-warning text-center">schedule_memo</th>
		</tr>
		<%
			for(Schedule s : scheduleList){
		%>
			<tr>
				<td><%=s.scheduleDate %></td>
				<td><%=s.scheduleTime %></td>
				<td>
					<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
					<%=s.scheduleMemo %>
					</a>
				</td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>