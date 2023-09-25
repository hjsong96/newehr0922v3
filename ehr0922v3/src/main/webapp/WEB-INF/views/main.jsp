<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지식소프트</title>
<link href="css/main.css" rel="stylesheet" />
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet"
   href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet" href="../css/main.css">
<link rel="stylesheet" href="../css/admin.css">
<link rel="stylesheet" href="./css/style.css">
<script type="text/javascript">
$(function(){
   $(".changePW").click(function(){
      var popupX = (window.screen.width / 2) - (480 / 2);
      var popupY= (window.screen.height / 2) - (250 / 2);
       window.open('./changePW', '비밀번호변경',"width=480px, height = 250px, left= "+popupX+" top="+popupY+" scrollbars=yes");
      return false;
   })
});
</script>
</head>
<body>
    <%@ include file="nav.jsp"%> 
   <%@ include file="sidebar.jsp"%>
   <article id="article">
            <div class="flexbox">
               <div class="item"><img src="./upload/${list.eimg}" class="eimg" ><br>
                  <div class="nameset7">${sessionScope.ename } 님<br></div>
                     <div class="nameset8"><a href="./mypage" class="mypage">내 정보</a></div>
                     <div class="nameset9"><img alt="" src="./img/changePW.png"><a class="changePW">비밀번호 변경</a></div>
               </div>
               
                  
               <div class="item">   
               <div class="nameset6">
                       <div class="nameset_title">출결관리현황</div>
                <br>
                <br>
				<c:if test="${atmgdate == 'exist' }">
                <c:out value="출근 : ${fn:substring(list2[list2.size() - 1].atmgstr,0,5)}" /><br>
                <c:if test="${list2[list2.size() - 1].atmgend != null}">
                
                <c:out value="퇴근 : ${fn:substring(list2[list2.size() - 1].atmgend,0,5)}" /><br>
                <c:choose>
               			<c:when test="${list2[list2.size() - 1].atmgsts eq 0}">
                   	 	<div class="sts-img">정상 출근</div>
               		 	</c:when>

                		<c:when test="${list2[list2.size() - 1].atmgsts eq 1}">
                   		 <div class="sts-img">지각</div>
                		</c:when>
                
               		 	<c:when test="${list2[list2.size() - 1].atmgsts eq 2}">
                    		<div class="sts-img">조퇴</div>
                		</c:when>
                
               			 <c:when test="${list2[list2.size() - 1].atmgsts eq 3}">
                    		<div class="sts-img">결근</div>
               	 		
                	</c:when>
               		 <c:otherwise>
                    	<div>휴가</div>
               	 	</c:otherwise>
            	</c:choose>
                </c:if>
            </c:if>
            <c:if test="${atmgdate == 'none' }">
            				<div class="sts-img">출근 기록 없음</div>
            </c:if>
         </div>
         </div>

               <div class="item">
                  <div class="nameset1">
                <div class="nameset_title">신규입사자</div><br>
            <div class="slideshow-container">

               <div class="mySlides fade">
                  <img class="pic" src="./upload/${newM[0].eimg }"
                     style="width: 100px" height="100px"> <br>
                  <br>
                  <div class="nameset2">
                     ${newM[0].edept }<br>
                  </div>
                  <div class="nameset3">
                     ${newM[0].ename }<br>
                  </div>
                  <div class="nameset4">${newM[0].ehiredate } 입사</div>
               </div>


               <div class="mySlides fade">
                  <img class="pic" src="./upload/${newM[1].eimg }" style="width: 100px"
                     height="100px"> <br><br>
                  <div class="nameset2">
                     ${newM[1].edept }<br>
                  </div>
                  <div class="nameset3">
                     ${newM[1].ename }<br>
                  </div>
                  <div class="nameset4">${newM[1].ehiredate } 입사</div>

               </div>
               
               
               <div class="mySlides fade">
                  <img class="pic" src="./upload/${newM[2].eimg }" style="width: 100px"
                     height="100px"> <br><br>
                  <div class="nameset2">
                     ${newM[2].edept }<br>
                  </div>
                  <div class="nameset3">
                     ${newM[2].ename }<br>
                  </div>
                  <div class="nameset4">${newM[2].ehiredate } 입사</div>

               </div>
               <div class="mySlides fade">
                  <img class="pic" src="./upload/${newM[3].eimg }" style="width: 100px"
                     height="100px"> <br><br>
                  <div class="nameset2">
                     ${newM[3].edept }<br>
                  </div>
                  <div class="nameset3">
                     ${newM[3].ename }<br>
                  </div>
                  <div class="nameset4">${newM[3].ehiredate } 입사</div>

               </div>
               <div class="mySlides fade">
                  <img class="pic" src="./upload/${newM[4].eimg }" style="width: 100px"
                     height="100px"> <br><br>
                  <div class="nameset2">
                     ${newM[4].edept }<br>
                  </div>
                  <div class="nameset3">
                     ${newM[4].ename }<br>
                  </div>
                  <div class="nameset4">${newM[4].ehiredate } 입사</div>

               </div>
               <br>

               <div style="text-align: center">
                  <span class="dot" hidden="hidden"></span> <span class="dot" hidden="hidden"></span>
                  <span class="dot" hidden="hidden"></span>
                  <span class="dot" hidden="hidden"></span>
                  <span class="dot" hidden="hidden"></span>
               </div>
            </div>
         </div>
         </div>

               <div class="item4">
                  <div class="nameset5">
                     <a href="./notice" class="notice">공지사항</a><br>
                     <img alt="" src="./img/notice2.png" class="nimg" onclick="location.href='./notice'">
                     <table>
                      <tbody style="text-align: left;">
                      <c:choose><c:when test="${nlist.size() gt 8 }"><c:forEach items="${nlist}" var="i" varStatus="loop">
                     <c:if test="${loop.index < 8}">
                  <tr class="tr1">
                     <td style="width: 70%; min-width: 70%; max-width: 70%">· <a class="tdtitle" href="noticeDetail?nno=${i.nno}">${i.ntitle}</a></td>
                     <td class="tdndate2">${i.ndate}</td>
                  </tr>
               </c:if>
                  </c:forEach></c:when>
                      <c:otherwise><c:forEach items="${nlist}" var="i" varStatus="loop">
                  <tr class="tr1">
                     <td style="width: 70%; min-width: 70%; max-width: 70%">· <a class="tdtitle" href="noticeDetail?nno=${i.nno}">${i.ntitle}</a></td>
                     <td class="tdndate2">${i.ndate}</td>
                  </tr>
                  </c:forEach></c:otherwise>
                      </c:choose>
                     
                  </tbody>
                  </table>

      </div>
   </div></div>

   </article>
   <script type="text/javascript">
      var slideIndex = 0;
      showSlides();

      function showSlides() {
         var i;
         var slides = document.getElementsByClassName("mySlides");
         var dots = document.getElementsByClassName("dot");
         for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
         }
         slideIndex++;
         if (slideIndex > slides.length) {
            slideIndex = 1
         }
         for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(" active", "");
         }
         slides[slideIndex - 1].style.display = "block";
         dots[slideIndex - 1].className += " active";
         setTimeout(showSlides, 4000); // Change image every 2 seconds
      }
      $(function(){
         $(".dot").hide();
         
      });
   </script>
</body>
</html>