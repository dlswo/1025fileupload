<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>업로드 테스트 페이쥐~</h1>


<!-- multipart/form-data이거 꼭 넣어야해요 -->
<form action="/upload" method="post" enctype="multipart/form-data">
	<input type="file" name="files" multiple="multiple">
	<button>Upload</button>
</form>

</body>
</html>