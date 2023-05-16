<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
   <div class="text-center"><!-- 메인메뉴 -->
      <a href="./home.jsp">홈으로</a>
      <a href="./noticeList.jsp">공지 리스트</a>
      <a href="./scheduleList.jsp">일정 리스트</a>
   </div>
   
   <h1 class="text-center">공지 입력</h1>
   <form action="./insertNoticeAction.jsp" method="post">
      <table class="table table-bordered">
         <tr>
            <th class="table-warning text-center">notice_title</th>
            <td>
               <input type="text" name="noticeTitle">
            </td>
         </tr>
         <tr>
            <th class="table-warning text-center">notice_content</th>
            <td>
               <textarea rows="5" cols="80" name="noticeContent"></textarea>
            </td>
         </tr>
         <tr>
            <th class="table-warning text-center">notice_writer</th>
            <td>
               <input type="text" name="noticeWriter">
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
		<button type="submit" class="btn btn-outline-success">입력</button>
      </div>
   </form>
</body>
</html>