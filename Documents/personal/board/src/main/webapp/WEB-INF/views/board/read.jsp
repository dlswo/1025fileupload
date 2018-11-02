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
.chat{
	list-style: none;
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
											type="text" class="form-control" name="title" value='<c:out value="${board.title}" />' disabled="disabled">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
										<label class="bmd-label-floating">글쓴이</label> <input
											type="text" class="form-control" name="writer" value='<c:out value="${board.writer}" />' disabled="disabled">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
										<div class="form-group">
											<label class="bmd-label-floating"> 내용</label>
											<textarea class="form-control" rows="5" name="content" disabled="disabled"><c:out value="${board.content}" /></textarea>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
										<div class="form-group">
											<label>첨부파일</label>
											<div class="uploadResult">
												<ul></ul>
											</div>
										</div>
									</div>
								</div>
							</div>
							<button class="btn btn-success pull-right List">리스트로 가기</button>
							<button class="btn btn-info pull-right Modify">수정하기</button>
							<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-header card-header-primary">
						<h4 class="card-title"><i class="material-icons">comment</i>  댓글</h4>
					</div>
					<div class="card-body">
						<ul class="chat">
							<li class="left clearfix" data-rno="12">
								<div>
									<div class="header">
										<strong class="primary-font">user00</strong>
										<small class="pull-right text-muted">2018-01-01 13:13</small>
									</div>
									<p>Good job!</p>
								</div>
							</li>
							<!-- end reply -->
						</ul>
						<!-- end ul  -->
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
<script type="text/javascript" src="/resources/assets/js/reply.js"></script>
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
					str += "</div>";
					str += "</li>";
				}else{
					var fileCallPath = encodeURIComponent( attach.path + "/" + attach.uuid + "_" + attach.filename);
					str += "<li data-path='"+attach.path+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.filename+"' data-type='"+attach.filetype+"'><div>";
					str += "<img src='/resources/assets/img/attach.png'><br/>";
					str += "<span>"+attach.filename+"</span>";
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
	var replyUL = $(".chat");
	
	showList(1);
	
	function showList(page){
		
		replyService.getList({bno:bno,page:page||1}, function(list) {
			
			var str = "";
			if(list == null || list.length == 0){
				replyUL.html("");
				
				return;
			}
			for (var i = 0, len = list.length || 0; i < len; i++){
				str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				str += "<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
				str += "<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
				str += "<p>"+list[i].reply+"</p></div></li>";	
			}
			replyUL.html(str);
			
		});
		
	}
	
	//reply
	replyService.getList(
		{bno: bno, page:1},function(list){
			for(var i = 0, len = list.length||0; i < len; i++){
				console.log(list[i]);
			}
		
		});
	
	replyService.get(2, function(data){
		console.log(data);
	});
	
	//move List
	$(".List").on("click", function(e){
		
		actionForm.attr("action","/board/list").attr("method","get").submit();
		
	});
	
	//move modify
	$(".Modify").on("click", function(e){
		
		actionForm.append("<input type='hidden' name='bno' value='"+bno+"'>");
		actionForm.attr("action","/board/modify").attr("method","get").submit();
		
	});	
	
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
		
		$(".bigPicture").html("<img src='/display?filename="+fileCallPath+"'>").animate({width:'100%', height: '100%'}, 1000);
		
	}
	
	$(".bigPictureWrapper").on("click", function(e){
		
		$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
		setTimeout(function(){
			$(".bigPictureWrapper").hide();
		}, 1000);
		
	});
	
	
	
});
</script>

</html>