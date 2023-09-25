<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link href="css/styles.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="./assets/libs/quill/dist/quill.snow.css">
<link href="./dist/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" href="../css/boarddetail.css"> 
<script src="./js/jquery-3.7.0.min.js"></script>
<script type="text/javascript">

function ndetailDel(){
   if(confirm("삭제하시겠습니까?")){
      location.href="./ndetailDel?nno=${nd.nno}";
   }
}

function ndetailUp(){
   if(confirm("수정하시겠습니까?")){
      location.href="./ndetailUp?nno=${nd.nno}";
   }
}
</script>

</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
 <article id="article">
<div class="container">
<div id="detail">
<div id="detailH">${nd.ntitle }<br></div>
<div id="detailN_no" style="margin-left: 100%-30px;"> </div>
<div id="detailIdDate">
<div id="detailID">${nd.ename}</div>
<div id="detailDate">${nd.ndate}  &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;조회수 : ${nd.nread}</div>
</div>
<div id="detailContent" style="word-wrap: break-word; ">${nd.ncontent}</div>
<br>
<c:if test="${sessionScope.eno == nd.eno }">
<button class="ndetailDel" onclick="ndetailDel()">삭제</button>
<button class="ndetailUp" onclick="ndetailUp()">수정</button>
</c:if>
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
   
</script>

</body>
</html>