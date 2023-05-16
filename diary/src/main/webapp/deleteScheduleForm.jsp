<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//요청값 유효성 검사
	if(request.getParameter("scheduleNo")==null){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + " <--deletescheduleForm scheduleNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleForm.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1 class="text-center">일정 삭제</h1>
	<form action="./deleteScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th class="table-warning text-center">schedule_no</th>
				<td>
					<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
				</td>			
			</tr>
			<tr>
				<th class="table-warning text-center">schedule_pw</th>
				<td>
					<input type="password" name="schedulePw">
				</td>
			</tr>
		</table>
		<div>
			&nbsp;
			<button type="submit" class="btn btn-outline-success"> 일정 삭제</button>
		</div>
	</form>
</body>
</html>