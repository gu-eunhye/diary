<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//요청값 유효성 검사
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + "<--deleteNoticeForm param noticeNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteNoticeForm.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1 class="text-center">공지 삭제</h1>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th class="table-warning text-center">notice_no</th>
				<td>
					<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
					<!-- <input type="hidden" name="noticeNo" value="<%=noticeNo%>"> -->
				</td>			
			</tr>
			<tr>
				<th class="table-warning text-center">notice_pw</th>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
		</table>
		<div>
			&nbsp;
			<button type="submit" class="btn btn-outline-success">삭제</button>
		</div>
	</form>
</body>
</html>