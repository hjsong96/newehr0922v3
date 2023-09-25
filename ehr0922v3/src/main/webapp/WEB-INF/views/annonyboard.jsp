<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>익명게시판</title>
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" href="../css/board.css">

</head>
<body>
   <%@ include file="nav.jsp"%>
   <%@ include file="sidebar.jsp"%>
   <article id="article">
      <br>
      <div class="atList">
         <h1 class="title">익명게시판</h1>
         <c:choose>
            <c:when test="${fn:length(list) gt 0 }">
               <div class="atList2">
                  <div class="div-btn">
                     <c:if test="${sessionScope.eid ne null }">
                        <button type="button" class="viewBtn">글쓰기</button>
                     </c:if>
                  </div>
                  <table class="table">
                     <thead>
                        <tr>
                           <th style="width:60px; min-width: 60px; max-width: 60px;">번호</th>
                           <th style="width:450px; min-width: 450px; max-width: 450px;">제목</th>
                           <th style="width:150px; min-width: 150px; max-width: 150px;">글쓴이</th>
                           <th style="width:150px; min-width: 150px; max-width: 150px;">날짜</th>
                           <th style="width:60px; min-width: 60px; max-width: 60px;">조회수</th>
                        </tr>
                     </thead>
                     <tbody>
                        <c:forEach items="${list }" var="row">
                           <tr onclick="location.href='./annonyDetail?num=${row.rowNum}'">
                              <td style="width:60px; min-width: 60px; max-width: 60px;">${row.rowNum}</td>
                              <td class="tdtitle" style="width:450px; min-width: 450px; max-width: 450px;">${row.abtitle}<c:if test="${row.commentcount gt 0 }">    <h5 style="display: inline;">[${row.commentcount}]</h5></c:if> </td>
                              <td class="tdwrite" style="width:150px; min-width: 150px; max-width: 150px;">${row.abwrite}</td>
                              <td class="tddate" style="width:150px; min-width: 150px; max-width: 150px;">${row.abdate}</td>
                              <td style="width:60px; min-width: 60px; max-width: 60px;">${row.abread }</td>
                           </tr>
                        </c:forEach>
                     </tbody>
                  </table>
                    <div class="page_wrap">
                  <div class="page_nation">
                <div class="page_left_wrap">
                  <c:if test="${ph.showPrev}">
                        <button class="page_left"  onclick="location.href='./annonyboard?page=${ph.startPage-1}'">이전</button>
                    </c:if>
                 </div>
                  <c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
                  <a class="num" href="<c:url value='./annonyboard?page=${i}&pageSize=${ph.pageSize}'/>" data-page="${i}">${i}</a>
                  </c:forEach>
                  <c:if test="${ph.showNext}">
                        <button class="page"
                           onclick="location.href='./annonyboard?page=${ph.endPage+1}'">다음</button>
                    </c:if>
                  </div>
               </div>
               </div>
            </c:when>
            <c:otherwise>
               <h1>게시판에 글이 없습니다.</h1>
               <c:if test="${sessionScope.eid ne null }">
                  <button type="button" class="viewBtn"
                     onclick="location.href='./annonyWrite'">글쓰기</button>
               </c:if>
            </c:otherwise>
         </c:choose>
         <br>
      </div>
   </article>
<script type="text/javascript">
$(function(){
	
    $(".viewBtn").click(function() {
let eboardCount = ${eboardCount};
           //alert(eboardCount);
           if(eboardCount > 5){
              alert("게시판 누적 신고 횟수가 5회를 넘어 익명 게시판에 글을 쓸 수 없습니다.");
              return false;
           }else{
              window.location.href='/annonyWrite';
           }
       });
   });
</script>
</body>
</html>