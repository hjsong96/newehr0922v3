<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 관리</title>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="../css/admin.css">

<script type="text/javascript">
   $(function() {
      //alert("!");
      $(".reportDetail").click(function() {
    	  let $row = $(this).closest("tr");
          
          // <tr> 내에서 abno 클래스의 값을 가져옵니다.
          let abno = $row.find(".abno").text();
    	  window.open('./reportDetail?abno='+abno, '신고된 게시판',"width=1000px, height = 600px scrollbars=yes");
        
      });//상세보기 끝
      
      $(".agree").click(function(){
    	  if(confirm("동일한 게시글에 대한 신고는 일괄 처리됩니다.\n신고를 승인하시겠습니까?")){
    		  let $row = $(this).closest("tr");
              
              // <tr> 내에서 abno 클래스의 값을 가져옵니다.
              let abno = $row.find(".abno").text();
			  let rreported = $(this).siblings(".rreported").val();
    		  $.ajax({
    			  url : "./reportAgree",
    			  type : "post",
    			  data : {abno:abno, rreported:rreported},
    			  dataType : "json",
    			  success : function(data){
    				  alert("승인이 완료되었습니다.");
    				  window.location.href = '/checkBoard';
    			  },
    			  error : function(error){
    				  alert("오류가 발생했습니다 다시 시도해주세요" + error);
    			}
    			  
    			  
    		  });//ajax 끝 
    	  }
      });//승인 눌렀을 때 끝
      
      $(".reject").click(function(){
    	  if(confirm("동일한 게시글에 대한 신고는 일괄 처리됩니다.\n신고를 거절하시겠습니까?")){
    		  let $row = $(this).closest("tr");
              
              // <tr> 내에서 abno 클래스의 값을 가져옵니다.
              let abno = $row.find(".abno").text();
    		  $.ajax({
    			  url : "./reportReject",
    			  type : "post",
    			  data : {abno:abno},
    			  dataType : "json",
    			  success : function(data){
    				  alert("거절이 완료되었습니다.");
    				  window.location.href = '/checkBoard';
    			  },
    			  error : function(error){
    				  alert("오류가 발생했습니다 다시 시도해주세요" + error);
    			}
    			  
    			  
    		  });//ajax 끝 
    	  }
		  
      });

      
      
      
      
      
     
   });
</script>
</head>
<body>
   <%@ include file="nav.jsp"%>
   <%@ include file="sidebar.jsp"%>
   <article id="article">
	<div class="container">
		<div class="main">
			<div class="article">			
				<h1>신고 관리 게시판</h1>
				<c:choose><c:when test="${list.size() eq 0 }"><h2 style="text-align: center; color: #424242;">신고 내역이 없습니다.</h2></c:when>
				<c:otherwise><table>
					<tr>
					
						<th>게시판 번호</th>
						<th>날짜</th>
						<th>신고 내용</th>
						<th>신고 상세설명</th>
					
						<th>처리 유무</th>
					</tr>
					<c:forEach items="${list}" var="row">
						<tr class="tr1">
						<td class="abno reportDetail">${row.abno }</td>
						<td class="reportDetail">${row.rdate }</td>
						<td class="reportDetail">${row.rcontent }</td>
						<td class="reportDetail">${row.rdetail }</td>
						<td>
						<button class="agree">승인</button><button class="reject">거절</button>
						
						<input class="rno" type="hidden" value="${row.rno}"/>
						<input class="rreported" type="hidden" value="${row.rreported }"/>
						</td>
						</tr>						
					</c:forEach>
				</table></c:otherwise></c:choose>
			</div>
		</div>
	</div>
	</article>
</body>
</html>