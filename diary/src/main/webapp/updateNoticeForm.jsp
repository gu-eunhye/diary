<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import ="java.util.*" %>
<%@page import ="vo.*" %>
<%
	//유효성코드
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return; 
	}
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql ="select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,noticeNo);
	System.out.println(stmt + "<-- stmt");
	
	ResultSet rs = stmt.executeQuery(); 
	/*
	if(rs.next()){
		
	}
	
	rs.next();
	*/
	
	//ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);
	}

%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<h1 class="text-center">공지 수정</h1>
	<div><!-- 오류출력 -->
	<%
		if(request.getParameter("msg")!=null){
	%>
		<%=request.getParameter("msg") %>
	<%
		}
	%>
	</div>
	<form action="./updateNoticeAction.jsp" method="post">
	<%
		for(Notice n : noticeList){	
	%>
		<table class="table table-bordered">
			<tr>
				<th class="table-warning text-center">
					notice_no
				</th>
				<td>
					<input type="number" name="noticeNo" value="<%=n.noticeNo %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					notice_pw
				</th>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					notice_title
				</th>
				<td>
					<input type="text" name="noticeTitle" value="<%=n.noticeTitle %>">
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					notice_content
				</th>
				<td>
					<textarea rows="5" cols="80" name="noticeContent">
					 	<%=n.noticeContent %>
					 </textarea>
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					notice_writer
				</th>
				<td>
					<%=n.noticeWriter %>
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					createdate
				</th>
				<td>
					<%=n.createdate.substring(0,10) %>
				</td>
			</tr>
			<tr>
				<th class="table-warning text-center">
					updatedate
				</th>
				<td>
					<%=n.updatedate.substring(0,10) %>
				</td>
			</tr>
		</table>
	<%
		}	
	%>
		<div>
			&nbsp;
			<button type="submit" class="btn btn-outline-success" >수정</button>
		</div>
	</form>
</body>
</html>