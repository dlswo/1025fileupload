<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>
<div class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-header card-header-primary">
						<h4 class="card-title ">자유 게시판</h4>
						<p class="card-category">페이지 사이즈를 선택하세요
						
						<select class="custom-select col-sm-1" id="size">
							<option value="10" <c:out value="${pageObj.size =='10'?'selected':'' }"/>>10</option>
							<option value="20" <c:out value="${pageObj.size =='20'?'selected':'' }"/>>20</option>
							<option value="50" <c:out value="${pageObj.size =='50'?'selected':'' }"/>>50</option>
							<option value="100" <c:out value="${pageObj.size =='100'?'selected':'' }"/>>100</option>
						</select>
					</div>
					<div class="card-body">
						<div class="table-responsive">
							<table class="table">
								<thead class=" text-primary">
									<th>글번호</th>
									<th>제목</th>
									<th>글쓴이</th>
									<th>등록일</th>
									<th>수정일</th>
								</thead>
								<tbody>
									<c:forEach items="${list}" var="board">
										<tr>
											<td><c:out value="${board.bno}" /></td>
											<td><a href='${board.bno }' class='board'><c:out value="${board.title}" /></a></td>
											<td><c:out value="${board.writer}" /></td>
											<td><fmt:formatDate value="${board.regdate}" pattern="MM-dd HH:mm" /></td>
											<td><fmt:formatDate value="${board.updatedate}" pattern="MM-dd HH:mm" /></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							
						</div>
						<nav aria-label="Page navigation example">
							<ul class="pagination justify-content-center">
								<c:if test="${pageObj.prev}">
									<li class="page-item"><a class="page-link"	href="${pageObj.start-1}" tabindex="-1">Previous</a></li>
								</c:if>
								<c:forEach begin="${pageObj.start}" end="${pageObj.end}" var="num">
									<li class="page-item" data-page="${num}"><a class="page-link" href="${num}"><c:out value="${num}"></c:out></a></li>
								</c:forEach>
								<c:if test="${pageObj.next}">
									<li class="page-item"><a class="page-link" href="${pageObj.end+1}">Next</a></li>
								</c:if>
							</ul>
						</nav>
						<div class="row">
							<div class="col-md-2">
								<select class="custom-select" id="type">
									<option value="t" <c:out value="${pageObj.type == 't'?'selected':''}"/>>제목</option>
									<option value="c" <c:out value="${pageObj.type == 'c'?'selected':''}"/>>내용</option>
									<option value="w" <c:out value="${pageObj.type == 'w'?'selected':''}"/>>글쓴이</option>
									<option value="tc" <c:out value="${pageObj.type == 'tc'?'selected':''}"/>>제목+내용</option>
									<option value="tcw" <c:out value="${pageObj.type == 'tcw'?'selected':''}"/>>모두</option>
								</select>
							</div>
							<div class="col-md-3">
								<div class="input-group">
									<input type="text" class="form-control" id="keyword" placeholder="검색어를 입력하세요" value="<c:out value='${pageObj.keyword}'/>"/>
								</div>
							</div>
							<button type="submit" class="btn btn-default btn-round btn-just-icon" id="searchBtn">
								<i class="material-icons">search</i>
                			</button>
						</div>
						<button class="btn btn-info btn-lg btn-block" id="register">등록</button>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>

<!-- Modal -->
<div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title text-primary" id="exampleModalLabel">작업 결과</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body text-success">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">닫기</button>
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
<%@include file="../includes/footer.jsp"%>

<script>

	$(document).ready(function (){
		
		var actionForm = $("#actionForm");
		
		//move read
		$(".board").on("click",function(e){
			e.preventDefault();
			var bno = $(this).attr("href");		
			actionForm.append("<input type='hidden' name='bno' value='"+bno+"'>");
			actionForm.attr("action","/board/read")
			.attr("method", "get").submit();
		});
		
		//move register
		$("#register").on("click", function(e){
			location.href="/board/register";
		});
		
		// Modal
		var msg = $("#modal");
		
		var result = "<c:out value='${result }'/>";
		
		checkModal(result);
		
		history.replaceState({},null,null)
		
		function checkModal(result){
			
			if(result ==='' || history.state){
				return;
			}
			
			if(result === 'SUCCESS'){
				$(".modal-body").html("작업 성공");
				msg.modal("show");				
			}
			
		}
		
		//move page
		var pageNum = ${pageObj.page};
		
		$(".pagination li a").on("click",function(e) {
			
			e.preventDefault();
			var target = $(this).attr("href");
			
			$("#page").val(target);
			
			actionForm.attr("action","/board/list").attr("method","get").submit();
			
		});
		
		//active page
		$('.pagination li[data-page='+pageNum+']').addClass("active");
		
		//set size
		$("#size").on("change", function(e) {
			
			e.preventDefault();
			
			var sizeValue = $("#size option:selected").val();
			console.log(sizeValue);
			
			$("#page").val(1);
			actionForm.find("input[name='size']").val(sizeValue);
			actionForm.submit();
			
		});
		
		//search
		
		$("#searchBtn").on("click", function(e) {
			
			e.preventDefault();
			
			var typeValue = $("#type").val();
			var keywordValue = $("#keyword").val();
			
			if(keywordValue.trim().length == 0 ){
				showNotification('top','center')
				return;
			}
			
			actionForm.find("input[name='type']").val(typeValue);
			actionForm.find("input[name='keyword']").val(keywordValue);
			actionForm.submit();
			
			function showNotification(from, align){

				  $.notify({
				      icon: "add_alert",
				      message: "키워드를 입력하세요"

				  },{
				      type: 'danger',
				      timer: 3000,
				      placement: {
				          from: from,
				          align: align
				      }
				  });
			}
			
		});
		
		
		
	});
	
</script>



 	</body>
</html>