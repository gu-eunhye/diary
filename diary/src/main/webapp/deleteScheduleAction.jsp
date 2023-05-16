<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//요청값 유효성 검사
	if(request.getParameter("scheduleNo")==null
			||request.getParameter("schedulePw")==null
			||request.getParameter("scheduleNo").equals("")
			||request.getParameter("schedulePw").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	//요청값들 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	//디버깅 
	System.out.println(scheduleNo + " <--deleteScheduleAction scheduleNo");
	System.out.println(schedulePw + " <--deleteScheduleAction schedulePw");
	
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
   	String sql = "delete from schedule where schedule_no=? and schedule_pw=?";
  	PreparedStatement stmt = conn.prepareStatement(sql);
  	//?값 지정
   	stmt.setInt(1,scheduleNo);
	stmt.setString(2,schedulePw);
	//디버깅
	System.out.println(stmt + " <--deleteScheduleAction stmt");
	
	//디버깅 - 삭제되는 행의 개수 확인
	int row = stmt.executeUpdate();
	System.out.println(row + " <--deleteScheduleAction row");
	
	if(row == 0){//비밀번호 틀려서 삭제행이 0행
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo);
	}else{
		response.sendRedirect("./scheduleList.jsp");
	}
%>
