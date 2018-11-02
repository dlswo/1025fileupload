<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="../includes/header.jsp"%>
<style>
.uploadResult {
	width: 100%;
}
.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}
.uploadResult ul li {
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}
.uploadResult ul li img{
	width: 100px;
}
.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255,255,255,0.5);
}
.bigPicture{
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}
.bigPicture img{
	width: 600px;
}
</style>

<div class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-header card-header-primary">
						<h4 class="card-title">게시판 읽기</h4>
						<p class="card-category"><c:out value="${board.bno}" />번째 글입니다.</p>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="bmd-label-floating">제목</label> <input
										type="text" class="form-control" name="title" value='<c:out value="${board.title}" />'>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="bmd-label-floating">글쓴이</label> <input
										type="text" class="form-control" name="writer" value='<c:out value="${board.writer}" />'>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<div class="form-group">
										<label class="bmd-label-floating"> 내용을 입력해 주세요</label>
										<textarea class="form-control" rows="5" name="content"><c:out value="${board.content}" /></textarea>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="card">
									<div class="card-header card-header">
										<label>첨부파일</label>
										<div class="card-body">
											<div class="input-group mb-3">
												<div class="custom-file uploadDiv">
													<input type="file" id="files" multiple="multiple">
												</div>
												<div class="input-group-prepend">
													<button class="input-group-text" id="uploadBtn">Upload</button>
												</div>
											</div>
											<div class='uploadResult'>
												<ul>
	
												</ul>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<button type="submit" class="btn btn-success pull-right List">리스트로 가기</button>
						<button type="submit" class="btn btn-danger pull-right Remove">삭제하기</button>
						<button type="submit" class="btn btn-info pull-right Modify">수정하기</button>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<form id='actionForm'>
	<input type='hidden' name='page' id='page' value='${pageObj.page}'>
	<input type='hidden' name='size' value='${pageObj.size}'>
	<input type='hidden' name='type' value='${pageObj.type}'>
	<input type='hidden' name='keyword' value='${pageObj.keyword}'>
</form>

<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>
</div>

<%@include file="../includes/footer.jsp"%>
</body>

<script>
$(document).ready(function(){
	
	//첨부파일 표시
	(function(){
		
		var bno = '<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
			console.log(arr);
			
			var str = "";
			
			$(arr).each(function(i, attach){
				
				//img type
				if(attach.filetype){
					var fileCallPath = encodeURIComponent( attach.path + "/s_" + attach.uuid + "_" + attach.filename);
					str += "<li data-path='"+attach.path+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.filename+"' data-type='"+attach.filetype+"'><div>";
					str += "<img src='/display?filename="+fileCallPath+"'><br/>";
					str += "<span>"+attach.filename+"</span>";
					str += "<button type='button' data-file='"+fileCallPath+"' data-type='image' rel='tooltip' class='btn btn-white btn-link btn-sm' data-original-title='Remove'><i class='material-icons'>close</i></button><br>";
					str += "</div>";
					str += "</li>";
				}else{
					var fileCallPath = encodeURIComponent( attach.path + "/" + attach.uuid + "_" + attach.filename);
					str += "<li data-path='"+attach.path+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.filename+"' data-type='"+attach.filetype+"'><div>";
					str += "<img src='/resources/assets/img/attach.png'><br/>";
					str += "<span>"+attach.filename+"</span>";
					str += "<button type='button' data-file='"+fileCallPath+"' data-type='file' rel='tooltip' class='btn btn-white btn-link btn-sm' data-original-title='Remove'><i class='material-icons'>close</i></button><br>";
					str += "</div>";
					str += "</li>";
				}
				
			});//end each
			
			$(".uploadResult ul").html(str);
			
		});// end getjson
		
	})(); // end function
});
</script>
<script>
$(document).ready(function(){
	
	var actionForm = $("#actionForm");
	var bno = '<c:out value="${board.bno}"/>';
	
	$(".Modify").on("click", function(e){
		
		e.preventDefault();
		
		var titleValue = $("input[name='title']").val();
		var writerValue = $("input[name='writer']").val();
		var contentValue = $("textarea[name='content']").val();
		var str = "";
		
		str += "<input type='hidden' name='bno' value='"+bno+"'>";
		str += "<input type='hidden' name='title' value='"+titleValue+"'>";
		str += "<input type='hidden' name='writer' value='"+writerValue+"'>";
		str += "<textarea name='content'>"+contentValue+"</textarea>";
		
		$(".uploadResult ul li").each(function(i, obj){
			
			var jobj = $(obj);
			
			str += "<input type='hidden' name='attachList["+i+"].filename' value='"+jobj.data("filename")+"'>"
			str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>"
			str += "<input type='hidden' name='attachList["+i+"].path' value='"+jobj.data("path")+"'>"
			str += "<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>"
			
		});
		
		actionForm.append(str);
		
		actionForm.attr("action","/board/modify").attr("method","post").submit();
		
		
	});
	
	$(".List").on("click", function(e){
		e.preventDefault();
		
		actionForm.attr("action","/board/list").attr("method","get").submit();
		
	});
	
	$(".Remove").on("click", function(e){
		e.preventDefault();
		
		actionForm.append("<input type='hidden' name='bno' value='"+bno+"'>");
		actionForm.attr("action","/board/remove").attr("method","post");
		$("#page").val(1);
		actionForm.submit();
		
	});	
	
	$(".uploadResult").on("click", "button", function(e){
		
		console.log("delete file");
		
		if(confirm("Remove this file? ")){
		
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}
	});
	
	//check ext, size
	var regex = new RegExp("(.*?)\.(bmp|jpeg|jpg|png|tif)$")
	var maxSize = 5242880;
	
	function checkExtension(fileName, fileSize) {
		
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			$(".uploadDiv").html(cloneObj.html());
			return false;
		}
		
		if(!regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			$(".uploadDiv").html(cloneObj.html());
			return false;
		}
		return true;
	}
	
	//upload
	var cloneObj = $(".uploadDiv").clone();
	
	$("#uploadBtn").on("click",function(e){
		
		e.preventDefault();
		
		var formData = new FormData();
		
		var filesObj = $("#files");
		
		var files = filesObj[0].files;
		
		for (var i = 0; i < files.length; i++) {
			
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("files",files[i]);
		}
		
		$.ajax({
			url: '/upload',
			processData: false,
			contentType: false,
			data: formData,
			type: 'post',
			dataType: 'json',
			success: function(result){
				console.log(result);
				showUploadResult(result);
				$(".uploadDiv").html(cloneObj.html());
			}
		});
		
	});
	
	function showUploadResult(uploadResultArr){
		
		if(!uploadResultArr || uploadResultArr.length == 0) { return; }
		
		var uploadUL = $(".uploadResult ul")
		var str = "";
		
		$(uploadResultArr).each(function(i, obj){
			console.log(obj);
			//img type
			if(obj.filetype){
				var fileCallPath = encodeURIComponent( obj.path + "/s_" + obj.uuid + "_" + obj.filename);
				str += "<li data-path='"+obj.path+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.filename+"' data-type='"+obj.filetype+"'><div>";
				str += "<img src='/display?filename="+fileCallPath+"'><br/>";
				str += "<span>"+obj.filename+"</span>";
				str += "<button type='button' data-file='"+fileCallPath+"' data-type='image' rel='tooltip' class='btn btn-white btn-link btn-sm' data-original-title='Remove'><i class='material-icons'>close</i></button><br>";
				str += "</div>";
				str += "</li>";
			}else{
				var fileCallPath = encodeURIComponent( obj.path + "/" + obj.uuid + "_" + obj.filename);
				str += "<li data-path='"+obj.path+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.filename+"' data-type='"+obj.filetype+"'><div>";
				str += "<img src='/resources/assets/img/attach.png'><br/>";
				str += "<span>"+obj.filename+"</span>";
				str += "<button type='button' data-file='"+fileCallPath+"' data-type='file' rel='tooltip' class='btn btn-white btn-link btn-sm' data-original-title='Remove'><i class='material-icons'>close</i></button><br>";
				str += "</div>";
				str += "</li>";
			}
		});
		uploadUL.append(str);		
	}
	
});
</script>

</html>