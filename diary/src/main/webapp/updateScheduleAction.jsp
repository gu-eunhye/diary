<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//request 인코딩 설정
	request.setCharacterEncoding("utf-8");

	//요청값 유효성 검사
	if(request.getParameter("scheduleNo")==null
			||request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	String msg = null; //오류알려주는 메시지
	if(request.getParameter("scheduleDate")==null //null조건부터 먼저
			||request.getParameter("scheduleDate").equals("")){
		msg = "scheduleDate is required";
	}else if(request.getParameter("scheduleTime")==null
			||request.getParameter("scheduleTime").equals("")){
		msg = "scheduleTime is required";
	}else if(request.getParameter("scheduleColor")==null
			||request.getParameter("scheduleColor").equals("")){
		msg = "scheduleColor is required";
	}else if(request.getParameter("scheduleMemo")==null
			||request.getParameter("scheduleMemo").equals("")){
		msg = "scheduleMemo is required";
	}else if(request.getParameter("schedulePw")==null
			||request.getParameter("schedulePw").equals("")){
		msg = "schedulePw is required";
	}
	
	if(msg != null){ //위 ifelse에 하나라도 해당된다면
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
				+request.getParameter("scheduleNo")
				+"&msg="+msg);
		return;
	}
	
	//받아온 값 저장하기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
		
	//디버깅
	System.out.println(scheduleNo + " <--updateScheduleAction scheduleNo");
	System.out.println(scheduleDate + " <--updateScheduleAction scheduleDate");
	System.out.println(scheduleTime + " <--updateScheduleAction scheduleTime");
	System.out.println(scheduleColor + " <--updateScheduleAction scheduleColor");
	System.out.println(scheduleMemo + " <--updateScheduleAction scheduleMemo");
	System.out.println(schedulePw + " <--updateScheduleAction schedulePw");
	
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
	String sql = "update schedule set schedule_date=?, schedule_time=?, schedule_color=?, schedule_memo=?, updatedate=now() where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//?값지정
	stmt.setString(1,scheduleDate);
	stmt.setString(2,scheduleTime);
	stmt.setString(3,scheduleColor);
	stmt.setString(4,scheduleMemo);
	stmt.setInt(5,scheduleNo);
	stmt.setString(6,schedulePw);
	//디버깅
	System.out.println(stmt + " <--updateScheduleAction stmt");
	
	//실행되는 행의 개수
	int row = stmt.executeUpdate();
	//디버깅
	System.out.println(row + "<--updateScheduleAction row");
	
		
	if(row == 0){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo +"&msg=incorrect schedulePw");
	}else if(row == 1){
		response.sendRedirect("./scheduleListByDate.jsp");
	}else{//row>1 : 무조건 존재해서는 안됨
		System.out.println("error row값 : "+row);
	}
%>