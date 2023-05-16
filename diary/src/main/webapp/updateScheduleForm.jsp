<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import ="java.util.*" %>
<%@page import ="vo.*" %>
<%
	//유효성코드
	if(request.getParameter("scheduleNo") == null
			||request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
	return;
	}

	//받아온 값 저장하기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	//디버깅
	System.out.println(scheduleNo + " <-- updateScheduleForm scheduleNo");
	
	//mariadb사용가능하도록 장치드라이브를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//디버깅
	System.out.println("드라이버 로딩 성공");
		
	//mariadb에 로그인 후 접속정보 반환받아야 함
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//디버깅
	System.out.println("접속성공 "+ conn);
	
	//쿼리생성
	String sql ="select schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, schedule_pw schedulePw, createdate, updatedate from schedule where schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,scheduleNo);
	//디버깅
	System.out.println(stmt + "<-- stmt");
	//결과셋을 반환
	ResultSet rs = stmt.executeQuery(); 
	
	//ResultSet -> ArrayList<schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleDate = rs.getString("scheduleDate"); 
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo"); 
		s.scheduleColor = rs.getString("scheduleColor");
		s.schedulePw = rs.getString("schedulePw");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateScheduleForm.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1 class="text-center">일정 수정</h1>
	<div class="text-center"><!-- 오류출력 -->
	<%
		if(request.getParameter("msg")!=null){
	%>
		<%=request.getParameter("msg") %>
	<%
		}
	%>
	</div>
	<form action="./updateScheduleAction.jsp" method="post">
	<%
		for(Schedule s : scheduleList){	
	%>
		<table class="table table-bordered">
			<tr>
				<th class="table-warning text-center">
					schedule_no
				</th>
				<td>
					<input type="number" name="scheduleNo" value="<%=scheduleNo %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					schedule_pw
				</th>
				<td>
					<input type="password" name="schedulePw">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					schedule_date
				</th>
				<td>
					<input type="date" name="scheduleDate" value="<%=s.scheduleDate%>">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					schedule_time
				</th>
				<td>
					<input type="time" name = "scheduleTime" value="<%=s.scheduleTime%>">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					schedule_color
				</th>
				<td>
					<input type="color" name = "scheduleColor" value="<%=s.scheduleColor %>" >
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					schedule_memo
				</th>
				<td>
					<textarea cols="80" rows="3" name="scheduleMemo"><%=s.scheduleMemo %></textarea>
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					createdate
				</th>
				<td>
					<%=s.createdate.substring(0,10) %>
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					updatedate
				</th>
				<td>
					<%=s.updatedate.substring(0,10) %>
				</td>
			</tr>
		</table>
	<%
		}
	%>
		<div>
			&nbsp;
			<button type="submit" class="btn btn-outline-success" >일정 수정</button>
		</div>
	</form>
</body>
</html>