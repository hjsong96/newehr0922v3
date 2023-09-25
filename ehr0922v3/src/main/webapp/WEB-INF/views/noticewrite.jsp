<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link rel="stylesheet" type="text/css" href="./assets/libs/quill/dist/quill.snow.css">
<link rel="stylesheet" href="../css/boardwrite.css"> 
<link href="./dist/css/style.min.css" rel="stylesheet">
<script src="./js/jquery-3.7.0.min.js"></script>
<style type="text/css">
button{
border-radius: 7px;
}
</style>
<script type="text/javascript">
$(function(){
	$(".saveBtn").click(function(){
		let ntitle = $("#ntitle").val();
		let ncontent = $("#ncontent").val();

		if (ntitle == "") {
	         alert("제목을 입력해");
	         $("#ntitle").focus();
	         return false;
	      }

  });
   });
</script>

</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
 <article id="article">
	<div class="card">
	    <div class="card-body">
	    <h1>공지게시판</h1>
				<form action="./noticeWrite" method="post">
    <input type="hidden" name="eno" value="${eno}">
    <h4 class="card-title">제목<br></h4>
    <input type="text" id="ntitle" name="ntitle">
    <input type="hidden" id="ncontent" name="ncontent">
    <div id="editor" style="height: 300px;">
        <div id="editor-container"></div><br>
    <button type="submit" class="saveBtn">저장</button>
    </div>
</form>
			</div>
	</div>

</article>
<!-- editor 라이브러리연결 -->
<script src="assets/libs/jquery/dist/jquery.min.js"></script>
<script src="assets/libs/select2/dist/js/select2.min.js"></script>
<script src="assets/libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="assets/libs/quill/dist/quill.min.js"></script>

<script>
var quill = new Quill('#editor-container', {
    theme: 'snow',
});
	
//폼 전송 시 Quill 에디터의 내용을 ncontent 폼 필드에 추가
document.querySelector('.saveBtn').addEventListener('click', function() {
    // Quill 에디터의 내용을 가져옴
    var quill = new Quill('#editor-container');
    var ncontentValue = quill.root.innerHTML;

    // ncontent 필드에 Quill 에디터의 내용을 설정
    document.querySelector('#ncontent').value = ncontentValue;
});


</script>
 
</body>
</html>