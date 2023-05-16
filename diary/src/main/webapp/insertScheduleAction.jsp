<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//유효성 검사
	if(request.getParameter("scheduleDate")==null
			||request.getParameter("scheduleTime")==null
			||request.getParameter("scheduleColor")==null
			||request.getParameter("scheduleMemo")==null
			||request.getParameter("schedulePw")==null
			||request.getParameter("scheduleDate").equals("")
			||request.getParameter("scheduleTime").equals("")
			||request.getParameter("scheduleColor").equals("")
			||request.getParameter("scheduleMemo").equals("")
			||request.getParameter("schedulePw").equals("")){
		response.sendRedirect("./scheduleList.jsp");
	return;
	}
	
	//요청값들 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	//디버깅
	System.out.println(scheduleDate + " <-- insertScheduleAction scheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction scheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction schedulePw");
	
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1;
	String d = scheduleDate.substring(8); //8이후 전부 잘림
	//디버깅
	System.out.println(y + " <-- insertScheduleAction y");
	System.out.println(m + " <-- insertScheduleAction m");
	System.out.println(d + " <-- insertScheduleAction d");
	
	
	//mariadb사용가능하도록 장치드라이브를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//디버깅
	System.out.println("드라이버 로딩 성공");
	//mariadb에 로그인 후 접속정보 반환받아야 함
	Connection conn = DriverManager.getConnection(
		"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//디버깅
	System.out.println("접속성공" + conn);
	
	//쿼리생성
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_color, schedule_memo, schedule_pw, createdate, updatedate) values(?,?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//?값 지정
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setString(5, schedulePw);
	
	//디버깅 - 0이면 입력된 행이 없다
	int row = stmt.executeUpdate(); 
	if(row==1){
		System.out.println("정상입력");
	}else{
		System.out.println("비정상입력 row : " + row);
	} 
	   
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	   
	
%>