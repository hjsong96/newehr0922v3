<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>익명게시판</title>
<link rel="stylesheet" type="text/css" href="./assets/libs/quill/dist/quill.snow.css">
<link href="./dist/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" href="../css/boardwrite.css"> 
<script src="./js/jquery-3.7.0.min.js"></script>
</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
 <article id="article">
   <div class="writeAgree" style="font-size: large;">선정적인 내용, 상대방을 비방하거나 불쾌감을 주는 언행을 사용할 시 신고될 수 있으며,<br> 누적될 경우
    	게시판 이용이 불가능해질 수 있습니다.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br></div><button id="admit">확인했습니다.</button>
   <div class="card">
       <div class="card-body">
       <h1>익명게시판</h1>
      <form action="./annonyWrite" method="post">
    <input type="hidden" name="eno" value="${eno}">
    <h4 class="card-title" >제목<br></h4>
    <input type="text" id="abtitle" name="abtitle">
    <div id="editor" style="height: 300px;">
        <div id="editor-container"></div>
    </div>
    <input type="hidden" id="abcontent" name="abcontent">
    <span class="writer">글쓴이는 ${nickName } 으로 저장됩니다.</span><button type="submit" class="saveBtn">저장</button>
    <input type="hidden" value="${nickName }" name="abwrite">
    <br>
  
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
   var quill = new Quill('#editor', {
       theme: 'snow'
   });
   
   // 폼 전송 시 Quill 에디터의 내용을 ncontent 폼 필드에 복사
   document.querySelector('form').addEventListener('submit', function (e) {
       var ncontentInput = document.getElementById('abcontent');
       ncontentInput.value = quill.root.innerHTML;
   });
   
   $(function(){
	   $(".card").hide();
	   $("#admit").click(function(){
		  $(".writeAgree").hide();
		  $("#admit").hide();
		  $(".card").show('slow');
	   });
	   
   });
</script>
 
</body>
</html>