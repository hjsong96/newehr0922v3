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
<script type="text/javascript">
	function adetailDel() {
		if (confirm("삭제하시겠습니까?")) {
			location.href = "./adetailDel?abno=${detail.abno}";
		}
	}

	function adetailUp() {
		if (confirm("수정하시겠습니까?")) {
			location.href = "./adetailUp?num=${detail.rowNum}";
		}
	}
</script>
<style type="text/css">
.cdel{
 float: right;
}
.cedit {
 float: right;
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
	<%@ include file="nav.jsp"%>
	<%@ include file="sidebar.jsp"%>
	<article id="article">
  
  	
        <div class="container">
      <div id="detail">


         <div id="detailH">${detail.abtitle}
         <br>
          </div>
         <div id="detailN_no" style="margin-left: 100%-30px;"> </div>
         <div id="detailIdDate">
            <div id="detailID">${detail.abwrite}</div>
            <div id="detailDate">${detail.abdate}  &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;조회수 : ${detail.abread}</div>
         </div>
         <div id="detailContent" style="word-wrap: break-word; ">${detail.abcontent}</div>

        
         
         <br>
  <c:if test="${sessionScope.eno == detail.eno || session.egrade == 8}">
			<button class="adetailUp" onclick="adetailUp()">수정</button>
			<button class="adetailDel" onclick="adetailDel()">삭제</button>
		</c:if>
		<c:if test="${sessionScope.eno ne detail.eno }">
		<button class="abreport">신고</button>
		<div class="reportBox"></div>
		</c:if>	
		<hr>
         <c:choose>
			<c:when test="${count gt 0 }">
				<div class="divTable minimalistBlack">
					<h3>댓글(${count })</h3>
					<c:forEach items="${commentList }" var="row">
						<div class="divTableBody">
							<div class="divTableRow">
								<c:choose>
									<c:when
										test="${row.csecret == 0 && (sessionScope.eno == detail.eno|| sessionScope.eno == row.eno || session.egrade == 8)}">
										<div class="divTableCell" style="font-weight: bold;">${row.cwrite}<c:if
												test="${row.cself == 0 }">
												<h6 style="color: red; display: inline;">(작성자)</h6>
											</c:if>
										</div>
										<div class="divTableCell">${row.ccomment}<div style="font-weight: bold; display: inline; color: red;">
											<h5 style="display: inline;">비밀댓글입니다.</h5><img src="./img/secretComment.png" alt="(비밀댓글입니다.)" width="25px;" height="25px;" style="position: relative; top: 5px;"></div>
											<c:if test="${sessionScope.eno == row.eno || session.egrade == 8}">
												<button class="cdel">삭제</button>
												<button class="cedit">수정</button>
												<input type="hidden" class="cno" value="${row.cno }">
												<input type="hidden" class="comment" value="${row.ccomment}">
											</c:if>
										</div>
									</c:when>
									<c:when
										test="${row.csecret == 0 && (sessionScope.eno != detail.eno && sessionScope.eno != row.eno)}">
										<div class="divTableCell" style="font-weight: bold; color: gray;" >비밀댓글입니다.<img src="./img/secretComment.png" alt="(비밀댓글입니다.)" width="25px;" height="25px;" style="position: relative; top: 5px;"></div>
									</c:when>
									<c:when test="${row.csecret == 1 }">
										<div class="divTableCell" style="font-weight: bold;">${row.cwrite}<c:if
												test="${row.cself == 0 }">
												<h6 style="color: red; display: inline;">(작성자)</h6>
											</c:if>
										</div>
										<div class="divTableCell">
											${row.ccomment}
											<c:if test="${sessionScope.eno == row.eno }">
												<button class="cdel" >삭제</button> 
												<button class="cedit">수정</button>
												<input type="hidden" class="cno" value="${row.cno }">
												<input type="hidden" class="comment" value="${row.ccomment}">
											</c:if>
										</div>
									</c:when>
								</c:choose>
								
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>
			<c:otherwise>
댓글이 없습니다.
</c:otherwise>
		</c:choose>
		
		<form action="./comment" method="post">
		<br>
			<input type="text" name="comment" class="commentcontent"
				placeholder="글쓴이 : ${commentWriter }" style="width: 100%; height: 80px;">
			<c:if test="${sessionScope.eno != detail.eno }">
				<br><input id="secret" type="checkbox" name="secret" value="0"/>비밀댓글</c:if>
			<br>
			<br>
			<button type="submit" class="writeBtn" style="height: ">댓글쓰기</button>
			<input type="hidden" name="writer" value="${commentWriter }"
				class="commentWriter'"> <input type="hidden" name="eno"
				value="${sessionScope.eno }" class="commentEno'"> <input
				type="hidden" name="abno" value="${detail.abno }"
				class="commentAbno'"> <input type="hidden" name="detailEno"
				value="${detail.eno }"> <input type="hidden" name="rowNum"
				value="${detail.rowNum }">
		</form>
		
		
      </div>
      
      
      
      </div>
  
  
  
  
  
  
  
  

		
		






	</article>

	
	<script type="text/javascript">
	
	
	
	
		$(function() {
			$(".writeBtn").click(function(){
				let length = $(".commentcontent").val().length;
				
				if(length < 5 ){
					alert("댓글을 5글자 이상 입력해주세요.");
					return false;
				}
			});
			
			
			
			
			$(".cedit").click(function() {
				//alert("!");
				const cno = $(this).siblings(".cno").val();
				let content = $(this).siblings(".comment").val();
				let abno = ${detail.abno};
				let rowNum = ${detail.rowNum};
				// 가져온 값을 알람으로 표시합니다.
				//글씨 상자 만들기
		    	  let recommentBox = '<div class="recommentBox">';
		    	  recommentBox += '<form action = "./cedit" method = "post">';
		    	  recommentBox += '<input type="text" id = "rcta" name = "comment"  style="width: 80%;" placeholder="댓글을 입력하세요" value = '+content+'></input>';
		    	  recommentBox += '<input type = "hidden" id="abno" name = "abno" value = "'+abno+'">';
		    	  recommentBox += '<input type = "hidden" id="cno" name = "cno" value = "'+cno+'">';
		    	  recommentBox += '<input type = "hidden" id="rowNum" name = "rowNum" value = "'+rowNum+'">';
		    	  recommentBox += '<button type="submit" id="recomment" style="float : right;">댓글수정하기</button>';
		    	 recommentBox += '</form>';
		    	  recommentBox += '</div>';
				
		    	  //내 위치 찾기
				let location = $(this).parent(".divTableCell");
		    	  location.after(recommentBox);
		    	  location.remove();
			});//cedit 끝
			$(".cdel").click(function(){
				const cno = $(this).siblings(".cno").val();
				let content = $(this).siblings(".comment").val();
				let abno = ${detail.abno};
				let rowNum = ${detail.rowNum};
				
				if(confirm("댓글을 삭제하시겠습니까?")){
					$.ajax({
						url : "/cdel",
						type : "post",
						data : {cno : cno, abno : abno},
						dataType : "json",
						success: function(data){
							
						
							alert("댓글이 삭제되었습니다.");
							window.location.href = '/annonyDetail?num='+rowNum;
						},
						error : function(error){
							alert("ㅠㅠ");
						}
						
						
					});
				}
				
				
			});//cdel 끝
			

				 $(".abreport").click(function() {
					 
					 let reportBox = $(".reportBox");

					 reportBox.empty();
					 var popupX = (window.screen.width / 2) - (650 / 2);
					var popupY= (window.screen.height / 2) - (550 / 2);
					  
					 window.open('./report?num='+${detail.rowNum}, '신고하기',"width=650px, height = 550px, left= "+popupX+" top="+popupY+" scrollbars=yes");

							

					  });//신고 버튼 클릭 끝
			
			
		});
	</script>

</body>
</html>