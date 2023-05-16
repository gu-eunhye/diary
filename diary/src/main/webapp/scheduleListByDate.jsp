<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import ="java.util.*" %>
<%@page import ="vo.*" %>
<%
	
	//y, m, d 값이 null or ""(공백)이면 redirection scheduleList.jsp
	if(request.getParameter("y")==null
			||request.getParameter("m")==null
			||request.getParameter("d")==null
			||request.getParameter("y").equals("")
			||request.getParameter("m").equals("")
			||request.getParameter("d").equals("")){
		response.sendRedirect("./scheduleList.jsp");
	return;
	}

	//입력받은 값 변수에 저장
	int y = Integer.parseInt(request.getParameter("y"));
	//자바API에서는 12월을 11월로 표현, 마리아DB에서는 12월을 12월로 표현
	int m = Integer.parseInt(request.getParameter("m"))+1; //Calendar쓰는게 아니라서 +1해도 괜찮음
	int d = Integer.parseInt(request.getParameter("d"));
	//디버깅
	System.out.println(y + " <-- scheduleListByDate y");
	System.out.println(m + " <-- scheduleListByDate m");
	System.out.println(d + " <-- scheduleListByDate d");
	
	//ex)4월을 04월로 나타내기 위해 
	String strM = m+""; //숫자 m을 공백붙여서 문자로 바꿈
	if(m<10){
		strM = "0"+strM;
	}
	//ex)1일을 01일로 나타내기 위해 
	String strD = d+"";
	if(d<10){
		strD = "0"+strD;
	}
	
	//일별 스케줄 리스트
	//mariadb사용가능하도록 장치드라이브를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//디버깅
	System.out.println("드라이버 로딩 성공");
	//mariadb에 로그인 후 접속정보 반환받아야 함
	Connection conn = DriverManager.getConnection(
		"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//디버깅
	System.out.println("접속성공" + conn);
		
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, schedule_pw schedulePw, createdate, updatedate from schedule where schedule_date = ? order by schedule_time asc ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,y+"-"+strM+"-"+strD);
	System.out.println(stmt + " <-- scheduleListByDate stme");
	
	ResultSet rs = stmt.executeQuery();	// 원래는 arraylist로 바꿔야 됨
	
	//ResultSet -> ArrayList<schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
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
<title>scheduleListByDate.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1 class="text-center">스케줄 입력</h1>
	<form action ="./insertScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th class="table-warning text-center">schedule_date</th>
				<!-- 2023-04-01형식으로 표시 -->
				<td><input type="date" name = "scheduleDate" 
							value="<%=y%>-<%=strM%>-<%=strD%>"
							readonly="readonly"></td>
			</tr>
			<tr>
				<th class="table-warning text-center">schedule_time</th>
				<td><input type="time" name = "scheduleTime"></td>
			</tr>
			<tr>
				<th class="table-warning text-center">schedule_color</th>
				<td><input type="color" name = "scheduleColor" value="#000000" ></td>
			</tr>
			<tr>
				<th class="table-warning text-center">schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th class="table-warning text-center">schedule_pw</th>
				<td><input type="password" name = "schedulePw" ></td>
			</tr>
		</table>
		<div>
			&nbsp;
			<button type ="submit" class="btn btn-outline-success" >스케줄 입력</button>
		</div>
	</form>
	
	
	<h1 class="text-center"><%=y %>년 <%=m %>월 <%=d %>일 스케줄 목록</h1>
	<table class="table table-bordered">
		<tr>
			<th class="table-warning text-center">schedule_time</th>
			<th class="table-warning text-center">schedule_memo</th>
			<th class="table-warning text-center">createdate</th>
			<th class="table-warning text-center">updatedate</th>
			<th class="table-warning text-center">수정</th>
			<th class="table-warning text-center">삭제</th>
		</tr>
		<%
			for(Schedule s : scheduleList){
				
				%>
				<tr>
					<td><%=s.scheduleTime %></td>
					<td><%=s.scheduleMemo %></td>
					<td><%=s.createdate.substring(0,10) %></td>
					<td><%=s.updatedate.substring(0,10) %></td>
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a></td>
				</tr>
				<%
			}
		%>
	</table>
	
</body>
</html>