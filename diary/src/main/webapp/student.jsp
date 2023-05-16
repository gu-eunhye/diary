<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); 
	
	Connection conn = null; 
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속성공 "+ conn);	
	
	String sql = "select student_no, student_name, student_age from student order by student_no ";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	ResultSet rs = stmt.executeQuery(); 
	System.out.println("쿼리실행성공 "+ rs);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>student.jsp</title>
</head>
<body>
	<table border="1">
		<tr>
			<th>student_no</th>
			<th>student_name</th>
			<th>student_age</th>
		</tr>
		
	<%
		while(rs.next()){
	%>
			<tr>
				<td><%=rs.getInt("student_no") %></td>
				<td><%=rs.getString("student_name") %></td>
				<td><%=rs.getInt("student_age") %></td>
			</tr>
	<%
		}
	%>
	</table>
</body>
</html>