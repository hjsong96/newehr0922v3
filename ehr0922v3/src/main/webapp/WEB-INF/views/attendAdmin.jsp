<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>근태 관리자 페이지</title>
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" href="./css/attendRegister.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<style type="text/css">
.modal {
   display: none;
   position: fixed;
   padding-top: 50px;
   top: calc(20vh - 100px);
   left: calc(26vw - 250px);
   width: 1600px;
   height: 800px;
   background-color: #FFF3E0;
   justify-content: center;
   align-items: center;
   text-align: center;
   border-radius: 15px;
   border: 1px solid #FFE0B2;
   box-shadow: rgba(0, 0, 0, 0.5) 0 0 0 9999px;
}
</style>
<script type="text/javascript">
function getAtregno() {
   $("input[name=chk]:checked").each(function() {
      let atregno = $(this).closest('tr').find('td:eq(1)').html();
      $("#atregno").val(atregno);
   });
}
$(function() {
   $('#atList4').hide();
   
   $(".apBtn").click(function() {
      $('#Modal').modal('show');
   });

   $(".btn-close").click(function() {
      $('#Modal').modal('hide');
   });
   
   $("#Btn01").addClass('active');   
   
   $("#search-atregsts").hide();
   $("#search-egrade").hide();
   $("#search-atregacpt").hide();
   $("#search-atregcontent").hide();
   $("#search-atregcomment").hide();
      
   $(".page_wrap2").hide();
   
   if($("#search-data option:selected").text() == "조회기간"){
      $(".page_wrap1").hide();
      $(".page_wrap2").show();
   }
   if($("#search-data option:selected").text() == "근태구분"){
      $(".page_wrap1").hide();
      $(".page_wrap2").show();
   }
   if($("#search-data option:selected").text() == "신청상태"){
      $(".page_wrap1").hide();
      $(".page_wrap2").show();
   }
   if($("#search-data option:selected").text() == "신청사유"){
      $(".page_wrap1").hide();
      $(".page_wrap2").show();
   }
   if($("#search-data option:selected").text() == "비고"){
      $(".page_wrap1").hide();
      $(".page_wrap2").show();
   }

   $("#cbx_chkAll").click(function() {
      if ($("#cbx_chkAll").is(":checked"))
         $("input[name=chk]").prop("checked", true);
      else
         $("input[name=chk]").prop("checked", false);
   });

   $("input[name=chk]").click(function() {
      var total = $("input[name=chk]").length;
      var checked = $("input[name=chk]:checked").length;
      if (total != checked)
         $("#cbx_chkAll").prop("checked", false);
      else
         $("#cbx_chkAll").prop("checked", true);
   });

   $(".doApproval").click(function() {
      if (confirm("승인하시겠습니까?")) {
         getAtregno();
         let atregno = $("#atregno").val();
         $.ajax({
            url : "./atApproval",
            type : "post",
            data : {atregno : atregno},
            dataType : "json",
            success : function(data) {
               if (data.result == 1) {
                  alert("승인되었습니다.");
                  location.href = "./attendAdmin";
               }
            },
            error : function(request, status, error) {
               alert("error");
            }
         });
      }
   });

   $(".notApproval1").click(function() {
      $(".doApproval").hide();
      let comment = '<p>반려사유를 입력하세요.<p>';
      comment += '<textarea class="notApprovalCM" style="width:800px; height:70px; text-align:left;"></textarea>';
      $(".view-body").append(comment);
      $(".notApproval1").hide();
      $(".notApproval2").show();
   });

   $(".notApproval2").click(function() {
      getAtregno();
      let atregno = $("#atregno").val();
      let atregcomment = $(".notApprovalCM").val();
      if (atregcomment.length == 0 || atregcomment == "") {
         alert("반려사유를 입력하세요.");
         $(".notApprovalCM").focus();
         return false;
      } else if (atregcomment.length > 500) {
         alert("반려사유는 500자를 넘을 수 없습니다.");
         $(".notApprovalCM").focus();
         return false;
      } else if (confirm("반려하시겠습니까?")) {
         $.ajax({
            url : "./atNotApproval",
            type : "post",
            data : {atregno : atregno,atregcomment : atregcomment},
            dataType : "json",
            success : function(data) {
               if (data.result == 1) {
                  alert("반려되었습니다.");
                  location.href = "./attendAdmin";
               }
            },
            error : function(request, status, error) {
               alert("error");
            }
         });
      }
   });
   
   $("#Btn01").click(function(){
      $('#atList2').show();
      $('#atList4').hide();
   });
   $("#Btn02").click(function(){
      $('#atList2').hide();
      $('#atList4').show();
   });
});
function atview() {
   $(".notApproval2").hide();
   let chks = [];

   $("input[name=chk]:checked").each(function() {
      if ($(this).closest('tr').find('td:eq(10)').text().indexOf("승인") > 0) {
         $(".doApproval").hide();
         $(".notApproval1").hide();
         $(".notApproval2").hide();
         let atregno = $(this).closest('tr').find('td:eq(1)').html();
         let atregacpt = $(this).closest('tr').find('td:eq(10)');
         let cancel = "취소";
         chks.push(atregno);
      } else if ($(this).closest('tr').find('td:eq(10)').text().indexOf("취소") > 0) {
         $(".doApproval").hide();
         $(".notApproval1").hide();
         $(".notApproval2").hide();
         let atregno = $(this).closest('tr').find('td:eq(1)').html();
         let atregacpt = $(this).closest('tr').find('td:eq(10)');
         let cancel = "취소";
         chks.push(atregno);
      } else if ($(this).closest('tr').find('td:eq(10)').text().indexOf("반려") > 0) {
         $(".doApproval").hide();
         $(".notApproval1").hide();
         $(".notApproval2").hide();
         let atregno = $(this).closest('tr').find('td:eq(1)').html();
         let atregacpt = $(this).closest('tr').find('td:eq(10)');
         let cancel = "취소";
         chks.push(atregno);
      } else {
         $(".doApproval").show();
         $(".notApproval1").show();
         let atregno = $(this).closest('tr').find('td:eq(1)').html();
         let atregacpt = $(this).closest('tr').find('td:eq(10)');
         let cancel = "취소";
         chks.push(atregno);
      }
   });
      if (chks.length == 0) {
         alert("조회할 신청항목을 선택하세요.")
      } else if (chks.length > 1) {
         alert("한가지 신청항목만 조회할 수 있습니다.")
      } else {
         let chksData = {
            "chkarr" : chks
         };
         let egrade = "";
         let atregsts = "";
         let atregacpt = "";
         let atregcomment = "";
         $.ajax({
            url : "./atview",
            type : "post",
            data : chksData,
            dataType : "json",
            success : function(data) {
               if (data.egrade == 0) {egrade = "사원";} 
               else if (data.egrade == 1) {egrade = "주임";} 
               else if (data.egrade == 2) {egrade = "대리";} 
               else if (data.egrade == 3) {egrade = "과장";} 
               else if (data.egrade == 4) {egrade = "차장";} 
               else if (data.egrade == 5) {egrade = "부장";} 
               else if (data.egrade == 6) {egrade = "부사장";} 
               else if (data.egrade == 7) {egrade = "사장";} 
               else {egrade = "관리자";}

               if (data.atregsts == 0) {atregsts = "병가";} 
               else if (data.atregsts == 1) {atregsts = "공가";}
               else if (data.atregsts == 2) {atregsts = "휴가";} 
               else if (data.atregsts == 3) {atregsts = "반차";} 
               else {atregsts = "연차";}

               if (data.atregacpt == 0) {atregacpt = "대기";} 
               else if (data.atregacpt == 1) {atregacpt = "승인";} 
               else if (data.atregacpt == 2) {atregacpt = "취소";} 
               else {atregacpt = "반려";}
               
               if(data.atregcomment != null){atregcomment = data.atregcomment;}
                  else{atregcomment = "";}

               let viewContent = '<table class="view-table"><tr><td colspan="6" class="td2"><b>관리 정보</b></td></tr><tr><td class="td3">관리번호</td><td colspan="2" class="td4"><input type="text" disabled value="'+data.atregno+'"></td><td class="td3">신청일자</td><td colspan="2" class="td4"><input type="text" disabled value="'+data.atregdate+'"></td></tr>';
               viewContent += '<tr><td colspan="6" class="td2"><b>신청 정보</b></td></tr><tr><td class="td3">이름</td><td class="td4"><input type="text" disabled value="'+data.ename+'"></td><td class="td3">부서</td><td class="td4"><input type="text" disabled value="'+data.edept+'"></td><td class="td3">직급</td><td class="td4"><input type="text" disabled value="'+egrade+'"></td></tr>';
               viewContent += '<tr><td class="td3">근태일자</td><td class="td4"><input type="text" disabled value="'+data.atregrestdate+'"></td><td class="td3">근태구분</td><td class="td4"><input type="text" disabled value="'+atregsts+'"></td><td class="td3">신청상태</td><td class="td4"><input type="text" disabled value="'+atregacpt+'"></td></tr>';
               viewContent += '<tr><td colspan="6" class="td2"><b>신청사유</b></td</tr>';
               if(atregacpt != "대기"){
               viewContent += '<tr><td colspan="6" class="td3"><textarea disabled style="width:100%; height:100px; text-align:left;">'+ data.atregcontent+ '</textarea></td></tr>';
               viewContent += '<tr id="tr-atregcomment1"><td colspan="6" class="td2"><b>비고</b></td</tr>';
               viewContent += '<tr id="tr-atregcomment2"><td colspan="6" class="td3"><textarea disabled style="width:100%; height:80px; text-align:left;">'+ atregcomment+ '</textarea></td></tr></table>';
               } else {
                  viewContent += '<tr><td colspan="6" class="td3"><textarea disabled style="width:100%; height:100px; text-align:left;">'+ data.atregcontent+ '</textarea></td></tr></table>';
               }
               $(".view-body").html(viewContent);
               $('#viewModal').modal('show');
            },
            error : function(request, status, error) {
               alert("error");
            }
      });
   }
}
function change_btn(e) {
   let btns = document.querySelectorAll(".Btn01");
   btns.forEach(function (btn, i) {
      if (e.currentTarget == btn) {
         btn.classList.add("active");
       } else {
          btn.classList.remove("active");
       }
   });
}
function pageCss(e) {
   let a = document.querySelectorAll(".page-a");
   a.forEach(function (a, i) {
      if (e.currentTarget == a) {
         a.classList.add("active");
       } else {
          a.classList.remove("active");
       }
   });
}
function changeSelect(){
   let value = $("#search-data option:selected").text();
   if(value == "조회기간"){
      $("#search-atregdate").show();
      $("#search-egrade").hide();
      $("#search-atregsts").hide();
      $("#search-atregacpt").hide();
      $("#search-atregcontent").hide();
      $("#search-atregcomment").hide();
   }
   if(value == "신청자"){
      $("#search-atregdate").hide();
      $("#search-egrade").show();
      $("#search-atregsts").hide();
      $("#search-atregacpt").hide();
      $("#search-atregcontent").hide();
      $("#search-atregcomment").hide();
   }
   if(value == "근태구분"){
      $("#search-atregdate").hide();
      $("#search-egrade").hide();
      $("#search-atregsts").show();
      $("#search-atregacpt").hide();
      $("#search-atregcontent").hide();
      $("#search-atregcomment").hide();
   }
   if(value == "신청상태"){
      $("#search-atregdate").hide();
      $("#search-egrade").hide();
      $("#search-atregsts").hide();
      $("#search-atregacpt").show();
      $("#search-atregcontent").hide();
      $("#search-atregcomment").hide();
   }
   if(value == "신청사유"){
      $("#search-atregdate").hide();
      $("#search-egrade").hide();
      $("#search-atregsts").hide();
      $("#search-atregacpt").hide();
      $("#search-atregcontent").show();
      $("#search-atregcomment").hide();
   }
   if(value == "비고"){
      $("#search-atregdate").hide();
      $("#search-egrade").hide();
      $("#search-atregsts").hide();
      $("#search-atregacpt").hide();
      $("#search-atregcontent").hide();
      $("#search-atregcomment").show();
   }
}
</script>
</head>
<body>
   <%@ include file="nav.jsp"%>
   <%@ include file="sidebar.jsp"%>
   <article id="article">
      <div class="atList">
         <h1 class="title">근태 관리</h1>
      <div class="atList3">
         <button type="button" class="Btn01" id="Btn01" onclick="change_btn(event)">요청문서</button>
         <button type="button" class="Btn01" id="Btn02" onclick="change_btn(event)">근태내역</button>
      </div>
         <div class="atList2" id="atList2">
         <div class="atList5">
            <div class="div-search">
            <form action="./attendAdmin" method="get">
            <select name="searchData" id="search-data" style="width:100px;" onchange="changeSelect()">
               <option value="0">조회기간</option><option value="1">신청자</option>
               <option value="2">근태구분</option><option value="3">신청상태</option>
               <option value="4">신청사유</option><option value="5">비고</option></select>
         <input id="search-atregdate" type="month" name="atregdate" style="width:100px;">         
   <select id="search-egrade" name="egrade" style="width:120px;">
         <option value="0">사원</option>
         <option value="1">주임</option>
         <option value="2">대리</option>
         <option value="3">과장</option>
         <option value="4">차장</option>
         <option value="5">부장</option>
         <option value="6">부사장</option>
         <option value="7">사장</option>
         <option value="8">관리자</option></select>
         <select id="search-atregsts" name="atregsts" style="width:120px;">
         <option value="0">병가</option>
         <option value="1">공가</option>
         <option value="2">휴가</option>
         <option value="3">반차</option>
         <option value="4">연차</option></select>
      <select id="search-atregacpt" name="atregacpt" style="width:120px;">
         <option value="0">대기</option>
         <option value="1">승인</option>
         <option value="2">취소</option>
         <option value="3">반려</option></select>
   <input id="search-atregcontent" type="text" name="atregcontent" style="width:200px;">
   <input id="search-atregcomment" type="text" name="atregcomment" style="width:200px;">
         <button type="submit" style="width:100px;">검 색</button>
   </form>
   </div>
   <div class="div-btn">
      <button type="button" class="viewBtn" onclick="return atview()" data-target="#viewModal">조 회</button>
   </div></div>
    <c:choose>
      <c:when test="${attendList.size() eq 0 }"><h1>근태 신청 내역이 없습니다.</h1></c:when>
      <c:otherwise>
            <table class="table1">
               <tbody>
                  <tr class="tr1">
                     <th class="th1"
                        style="width: 30px; min-width: 30px; max-width: 30px;"><input
                        type="checkbox" id="cbx_chkAll" style="width: 20px;"></th>
                     <th class="th1" style="width: 60px; min-width: 60px;">신청번호</th>
                     <th class="th1">신청자</th>
                     <th class="th1">부서</th>
                     <th class="th1" style="width: 60px; min-width: 60px;">직급</th>
                     <th class="th1">신청일자</th>
                     <th class="th1" style="width: 60px; min-width: 60px;">근태일자</th>
                     <th class="th1">근태구분</th>
                     <th class="th1" style="width: 200px; min-width: 200px;">신청사유</th>
                     <th class="th1">승인여부</th>
                     <th class="th1" style="width: 200px; min-width: 200px;">비고</th>
                  </tr>
               </tbody>
               <tbody>
                  <c:forEach items="${attendList }" var="l" varStatus="status">
                     <tr class="tr1">
                        <td class="td1"
                           style="width: 30px; min-width: 30px; max-width: 30px;"><input
                           type="checkbox" name="chk" id="chk" style="width: 20px;"></td>
                        <td hidden="hidden" id="atregno">${l.atregno }</td>
                        <td class="td1" style="width: 60px; min-width: 60px;">${l.rowNum }</td>
                        <td class="td1">${l.ename }</td>
                        <td class="td1">${l.edept }</td>
                        <td class="td1" style="width: 60px; min-width: 60px;"><c:if
                              test="${l.egrade eq 0 }">사원</c:if> <c:if
                              test="${l.egrade eq 1 }">주임</c:if> <c:if
                              test="${l.egrade eq 2 }">대리</c:if> <c:if
                              test="${l.egrade eq 3 }">과장</c:if> <c:if
                              test="${l.egrade eq 4 }">차장</c:if> <c:if
                              test="${l.egrade eq 5 }">부장</c:if> <c:if
                              test="${l.egrade eq 6 }">부사장</c:if> <c:if
                              test="${l.egrade eq 7 }">사장</c:if>
                           <c:if test="${l.egrade eq 8 }">관리자</c:if></td>
                        <td class="td1">${l.atregdate }</td>
                        <td class="td1">${l.atregrestdate }</td>
                        <td class="td1" style="width: 60px; min-width: 60px;"><c:if
                              test="${l.atregsts eq 0 }">병가</c:if> <c:if
                              test="${l.atregsts eq 1 }">공가</c:if> <c:if
                              test="${l.atregsts eq 2 }">휴가</c:if> <c:if
                              test="${l.atregsts eq 3 }">반차</c:if> <c:if
                              test="${l.atregsts eq 4 }">연차</c:if></td>
                        <td class="td1" style="width: 200px; min-width: 200px;">${l.atregcontent }</td>
                        <td class="td1"><c:if test="${l.atregacpt eq 0 }">대기</c:if>
                           <c:if test="${l.atregacpt eq 1 }">승인</c:if> <c:if
                              test="${l.atregacpt eq 2 }">취소</c:if> <c:if
                              test="${l.atregacpt eq 3 }">반려</c:if></td>
                        <td class="td1" style="width: 200px; min-width: 200px;">${l.atregcomment }</td>
                     </tr>
                  </c:forEach>
               </tbody>
            </table></c:otherwise></c:choose>   
            <div class="page_wrap1">
     		<div class="page_nation">
     		<div class="page_left_wrap">
               <c:if test="${ph.showPrev}">
                  <button class="page" onclick="location.href='./attendAdmin?page=${ph.startPage-1}'">이전</button>
               </c:if></div>
               <c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
                  <a class="page-a" onclick="pageCss(event)" href="<c:url value='./attendAdmin?page=${i}&pageSize=${ph.pageSize}'/>">${i}</a>
               </c:forEach>
               <c:if test="${ph.showNext}">
                  <button class="page" onclick="location.href='./attendAdmin?page=${ph.endPage+1}'">다음</button>
               </c:if>
            </div></div>
            <div class="page_wrap2">
     		<div class="page_nation">
     		<div class="page_left_wrap">
                  <c:if test="${ph.showPrev}">
                  <button class="page" onclick="location.href='./attendAdmin?page=${ph.startPage-1}&searchData=${selectedMap.searchData}&atregdate=${selectedMap.atregdate}&atregsts=${selectedMap.atregsts}&atregacpt=${selectedMap.atregacpt}&atregcontent=${selectedMap.atregcontent}&atregcomment=${selectedMap.atregcomment}'">이전</button>
                 </c:if></div>
                  <c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
                  <a onclick="pageCss()" href="<c:url value='./attendAdmin?page=${i}&pageSize=${ph.pageSize}&searchData=${selectedMap.searchData}&atregdate=${selectedMap.atregdate}&atregsts=${selectedMap.atregsts}&atregacpt=${selectedMap.atregacpt}&atregcontent=${selectedMap.atregcontent}&atregcomment=${selectedMap.atregcomment}'/>">${i}</a>
                  </c:forEach>
                  <c:if test="${ph.showNext}">
                    <button class="page" onclick="location.href='./attendAdmin?page=${ph.endPage+1}&searchData=${selectedMap.searchData}&atregdate=${selectedMap.atregdate}&atregsts=${selectedMap.atregsts}&atregacpt=${selectedMap.atregacpt}&atregcontent=${selectedMap.atregcontent}&atregcomment=${selectedMap.atregcomment}'">다음</button>
                 </c:if>
               </div></div>
         </div>
         <div class="atList2" id="atList4">테스트</div>
         <input type="hidden" id="atregno" value="">
         <!-- Modal -->
         <div class="modal" id="viewModal" tabindex="-1"
            aria-labelledby="exampleModalLabel" aria-hidden="true"
            data-bs-backdrop="static" data-keyboard="false">
            <!-- 모달 내용 -->
            <div class="modal-dialog">
               <div class="modal-content">
                  <div class="edit-header">
                     <h1 class="modal-title" id="exampleModalLabel">근태 세부 내역</h1>
                  </div>
                  <div class="modal-body view-body"></div>
                  <div class="modal-footer view-footer">
                     <button type="button" class="doApproval">승인</button>
                     <button type="button" class="notApproval1">반려</button>
                     <button type="button" class="notApproval2">반려</button>
                     <button type="button" class="closeBtn" data-bs-dismiss="modal">닫기</button>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </article>
</body>
</html>