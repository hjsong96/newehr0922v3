<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>익명게시판</title>
<link rel="stylesheet" type="text/css" href="./assets/libs/quill/dist/quill.snow.css">
<link rel="stylesheet" href="../css/boardupdate.css"> 
<link href="./dist/css/style.min.css" rel="stylesheet">
<script src="./js/jquery-3.7.0.min.js"></script>
<style type="text/css">
button{
   border: 0;
   background-color: #303F9F;
   border-radius: 7px;
   padding: 7px;
   color: white;
   font-weight: bold;
   font-family: 'Noto Sans KR', sans-serif;
   width: 60px;
   height: 40px;
   margin: 10px;
   margin-right: 0px;
}
button:hover{
   cursor: pointer;
   background-color: #1A237E;
}
</style>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
 <article id="article">
   <div class="card">
       <div class="card-body">
       <h1>익명게시판</h1>
      <form action="./adetailUp" method="post">
    <input type="hidden" name="abno" value="${detail.abno}">
    <h4 class="card-title" >제목<br></h4>
    <input type="text" id="abtitle" name="abtitle" value="${detail.abtitle }">
    <div id="editor" style="height: 300px;">
        <div id="editor-container">
        ${detail.abcontent }
        </div>
    </div>
    <input type="hidden" id="abcontent" name="abcontent">
    <button type="submit" class="saveBtn">저장</button>
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
</script>
 
</body>
</html>