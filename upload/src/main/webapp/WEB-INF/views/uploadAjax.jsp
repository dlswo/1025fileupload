<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<h1>Ajax Upload Page</h1>

<input type="file" id="files" multiple="multiple">

<button id="btn">Upload button</button>

<div class="thumbs">
</div>

<style>
.imgBox{
	width: 100%;
	height: 100vh;
	position: absolute;
	top: 0px;
	left: 0px;
	background: silver;
	display: none;
}
</style>

<div class="imgBox">
</div>

<script
  src="https://code.jquery.com/jquery-3.3.1.min.js"
  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
  crossorigin="anonymous"></script>
  
  
<script>
//p.533보면 IE/edge 문제관련해서 나옴

$(".thumbs").on("click","p",function(e){
	
	var obj = $(this);
	console.log(obj);
	
	var link = "/download/" + obj.attr("data-src");
	self.location = link;
	
});

$(".thumbs").on("click","img",function(e){
	
	var obj = $(this);
	console.log(obj);
	
	$(".imgBox").html("<img src='/viewFile/" + obj.attr("data-src") + "'>").show("slow");
	
	$(".imgBox").on("click",function(e){
		$(this).hide("slow");
	});
	
});

$("#btn").on("click",function(e){
	
	var thumbs = $(".thumbs");
	
	//formdata는 IE10버전부터 사용가능하다.
	var formData = new FormData();
	
	var filesObj = $("#files");
	
	console.log(filesObj);
	
	//jquery이기 때문에 순수한 데이터를 가져온다.
	var files = filesObj[0].files;
	
	for(var i = 0; i < files.length; i++){
		
		formData.append("files", files[i]);
	}
	
	//processData와 contentType은 꼭 써줘야한다.
	$.ajax({
		url:"/upload",
		processData: false,
		contentType: false,
		data: formData,
		type:"post",
		success:function(result){//성공하면 실행, 콜백함수 느낌
			
			console.log(result);
			
			var str = "";
			
			for(var i = 0 ; i < result.length; i++){
				
				var path = "/viewFile/" + result[i].thumbName + "_" + result[i].ext;
				var fileSrc = (result[i].thumbName + "_" + result[i].ext).substring(2);
				str += "<div>";
				str += "<img data-src='"+ fileSrc +"' src='"+path+"'>";
				str += "<p data-src='"+ fileSrc +"'>" + result[i].originName + "</p>";
				str += "</div>";
			
			}//end for
			
			thumbs.append(str);
		}
	});// end ajax
	
	
});


</script>
	
</body>
</html>