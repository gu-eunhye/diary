<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import ="java.util.*" %>
<%@page import ="vo.*" %>
<%
	int targetYear=0;
	int targetMonth=0;
	
	//년 or 월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월 값으로
	if(request.getParameter("targetYear")==null 
			|| request.getParameter("targetMonth")==null){
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH); //출력할때 +1을해야지 여기선 안됨
	}else{
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	//디버깅
	System.out.println(targetYear + " <-- sheduleList targetYear");
	System.out.println(targetMonth + " <-- sheduleList targetMonth");
	
	//오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	//targetMonth 1일의 요일=?
	Calendar firstDay = Calendar.getInstance(); //2023년 4월 23일
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1); // 2023년 4월 1일
	
	//년:23,월:12 입력 Calendar API가 24년 1월로 변경
	//년:23,월:-1 입력 Calendar API가 22년 12월로 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	//디버깅
	System.out.println(targetYear + " <-- API변경후 targetYear");
	System.out.println(targetMonth + " <-- API변경후 targetMonth");
	
	// 2023년4월1일 몇번째 요일인지 (일1,...,토7)
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); 
	
	//1일앞의 공백칸의 수 
	int startBlank = firstYoil - 1;
	System.out.println(startBlank + " <-- sheduleList startBlank");
	
	//targetMonth 마지막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	System.out.println(lastDate + " <-- sheduleList lastDate");
	
	//전체 TD의 7로 나눈 나머지값은 0
	//lastDate날짜 뒤 공백칸의 수
	int endBlank = 0;
	if((startBlank+lastDate)%7 != 0){
		endBlank = 7-((startBlank + lastDate)%7);
	}
	System.out.println(endBlank + " <-- sheduleList endBlank");
	
	//전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	System.out.println(totalTD + " <-- sheduleList totalTD");
	
	
	
	//db data를 가져오는 알고리즘 
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	/*
		select schedule_no scheduleNo, day(schedule_date) scheduleDate , 
		substr(schedule_memo,1,5) scheduleMemo, schedule_color scheduleColor
		from schedule
		where year(schedule_date) = ? and month(schedule_date)=?
		order by month(schedule_date) asc;
	*/
	PreparedStatement stmt = conn.prepareStatement(
			"select schedule_no scheduleNo,day(schedule_date) scheduleDate, substr(schedule_memo,1,5) scheduleMemo, schedule_color scheduleColor, createdate, updatedate from schedule where year(schedule_date) = ? and month(schedule_date)=? order by month(schedule_date) asc;");
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth+1);
	System.out.println(stmt + "<-- stmt");
	ResultSet rs = stmt.executeQuery();
	
	//ResultSet -> ArrayList<schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); //전체 날짜가 아닌 실제론 일만 들어가 있음
		s.scheduleMemo = rs.getString("scheduleMemo"); //전체메모가 아닌 5글자만 들어가 있음
		s.scheduleColor = rs.getString("scheduleColor");
		s.updatedate = rs.getString("updatedate");
		s.createdate = rs.getString("createdate");
		scheduleList.add(s);
	}
	
	
		
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList.jsp</title>
<style>
	td{ height: 200px;}
</style>
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
	<h1 class="text-center"><%=targetYear %>년 <%=targetMonth +1 %>월</h1>
	<div class="text-center">
		 <a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
     	 <a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</div>
	<table class="table table-bordered " ><!-- 달력 -->
		<thead class="table-warning text-center">
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>
		<tr>
			<%
				for(int i=0; i<totalTD; i++){
					int num = i-startBlank+1;
					if(i!=0 && i%7==0){
			%>
						</tr><tr>
			<%
					}
					String tdStyle = "";
					if(num>0 && num<=lastDate){
						//오늘날짜이면
						if(today.get(Calendar.YEAR) == targetYear
							&& today.get(Calendar.MONTH) == targetMonth
							&& today.get(Calendar.DATE) == num){
							tdStyle = "background-color:orange;";			
						}
							
			%>
							<td style="<%=tdStyle%>">
								<div><!-- 날짜 숫자 -->
									<a href="./scheduleListByDate.jsp?y=<%=targetYear %>&m=<%=targetMonth %>&d=<%=num %>"><%=num %></a>
								</div>
								<div><!-- 일정 memo(5글자만) -->
									<%
										for(Schedule s : scheduleList){
											if(num == Integer.parseInt(s.scheduleDate)){
									%>
												<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo %></div>
									<%
											}
										}
											
									%>
								</div>
							</td>
			<%
					}else{
			%>
						<td>&nbsp;</td>
			<%
					}
				}
			%>
		</tr>
	</table>
</body>
</html>