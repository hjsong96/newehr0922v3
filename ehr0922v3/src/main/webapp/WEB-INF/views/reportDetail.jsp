<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>익명게시판</title>
<link href="css/styles.css" rel="stylesheet" />
<link rel="stylesheet" href="../css/annonydetail.css">
<script src="./js/jquery-3.7.0.min.js"></script>
<style type="text/css">
.cdel{
 float: right;
}
.cedit {
 float: right;
}

@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap');
* {
   font-family: 'Noto Sans KR', sans-serif;
}

#main{
   margin: 0 auto;
   width:95%;
   margin-top: 60px;
   color: black;
}
#detail{
   background-color: white;
   margin: 0 auto;
   width: 90%;
   height: auto;
   margin-top: 15px;
   color: black;
   padding: 10px;
   box-sizing: border-box;
}
#detailH{
   height: 40px;
   line-height: 40px;
   font-size: x-large;
   border-bottom: 1px solid black;
   box-sizing: border-box;
   overflow: hidden;
}
#detailIdDate{
   height: 50px;
   line-height: 30px;
   border-bottom: 1px gray solid;
   padding:10px;
   box-sizing: border-box;
   
}
#detailID, #detailDate{
   width: 45%;
   float: left;
   text-align: left;
}
#detailDate{
   float: right;
   text-align: right;
}
#detailContent{
   padding:10px;
   min-height:300px;
   height: auto;
   border-bottom: 1px solid white;
   box-sizing: border-box;
   text-align: left;
}


</style>
</head>
<script type="text/javascript">
function insertLineBreaks(text) {
    if (text.length > 130) {
        let result = '';
        for (let i = 0; i < text.length; i += 130) {
            result += text.substr(i, 130) + '<br>';
        }
        return result;
    }
    return text;
}
document.addEventListener('DOMContentLoaded', function() {
    // 이 부분에서 페이지가 로드된 후에 insertLineBreaks 함수를 사용할 수 있습니다.
    const detailContent = document.getElementById('detailContent');
    detailContent.innerHTML = '<p>' + insertLineBreaks(detail.abcontent) + '</p>';
</script>
<body>

	<article id="article">
  
  	
        <div class="container">
      <div id="detail">


         <div id="detailH">${detail.abtitle}
         <br>
          </div>
         <div id="detailN_no" style="margin-left: 100%-30px;"> </div>
         <div id="detailIdDate">
            <div id="detailID">${detail.abwrite}</div>
            <div id="detailDate">${detail.abdate}  &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;</div>
         </div>
         <div id="detailContent" style="word-wrap: break-word; ">${detail.abcontent}</div>
         <br>
		<hr>
		<h4>이 게시글은 ${reportCount } 회 신고되었습니다.</h4>
      </div>
      </div>
      <br>
      <div style="text-align: center;">
      <button class="close" >닫기</button>
      </div>
	</article>
<script type="text/javascript">
$(function(){
	$(".close").click(function(){
		window.close();
	
	});
});

</script>
</body>
</html>