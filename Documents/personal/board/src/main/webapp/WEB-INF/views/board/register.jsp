<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<style>
.uploadResult {
	width: 100%;
}
.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-content: center;
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
						<h4 class="card-title">게시판 등록</h4>
						<p class="card-category">글쓰기</p>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="bmd-label-floating">제목</label> <input
										type="text" class="form-control" name="title">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="bmd-label-floating">글쓴이</label> <input
										type="text" class="form-control" name="writer">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<div class="form-group">
										<label class="bmd-label-floating"> 내용을 입력해 주세요</label>
										<textarea class="form-control" rows="5" name="content"></textarea>
									</div>
								</div>
							</div>
						</div>
						<button type="button" class="btn btn-danger pull-right cancel">취소</button>
						<button type="submit" class="btn btn-info pull-right register">등록</button>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-header card-header-primary">
						<h4 class="card-title">파일 첨부</h4>
					</div>
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
</div>

<form id="actionForm">
</form>

<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>
</div>

<%@include file="../includes/footer.jsp"%>
<script>
$(document).ready(function(){
	
	var actionForm = $("#actionForm");
	
	//move registerpost
	$(".register").on("click",function(e){
		e.preventDefault();
		
		
		var titleValue = $("input[name='title']").val();
		var writerValue = $("input[name='writer']").val();
		var contentValue = $("textarea[name='content']").val();
		var str = "";
		
		if(titleValue.trim().length == 0 || writerValue.trim().length == 0 || contentValue.trim().length == 0){
			showNotification('top','center')
			return;
		}
		
		function showNotification(from, align){

			  $.notify({
			      icon: "add_alert",
			      message: "빈칸을 채워주세요"

			  },{
			      type: 'danger',
			      timer: 3000,
			      placement: {
			          from: from,
			          align: align
			      }
			  });
		}
		
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
		
		console.log(str);
		actionForm.attr("action","/board/register").attr("method","post").submit();
		
	});
	
	$(".cancel").on("click", function(e){
		e.preventDefault();
		
		actionForm.attr("action","/board/list").submit();
	});
	
	//checkcheck ext, size
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
	
	$(".uploadResult").on("click", "button", function(e){
		
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var type= $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: '/deleteFile',
			data: {filename : targetFile, type: type},
			dataType: 'text',
			type: 'post',
			success: function(result){
				alert(result);
				targetLi.remove();
			}
		})
	})
	
	$(".uploadResult").on("click", "li",function(e){
		
		console.log("view image")
		
		var liObj = $(this);
		
		var path = encodeURIComponent( liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
		
		if(liObj.data("type")){
			showImage(path.replace(new RegExp(/\\/g),"/"));
		}else{
			//download
			self.location = "/download?filename="+path
		}
		
	});
	
	function showImage(fileCallPath){
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture").html("<img src='/display?filename="+fileCallPath+"'>").animate({width:'100%', height: '100%'}, 500);
		
	}
	
	$(".bigPictureWrapper").on("click", function(e){
		
		$(".bigPicture").animate({width:'0%', height:'0%'}, 500);
		setTimeout(function(){
			$(".bigPictureWrapper").hide();
		}, 1000);
		
	});
	
});
</script>
</body>

</html>