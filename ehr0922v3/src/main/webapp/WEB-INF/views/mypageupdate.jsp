<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 수정</title>
<link rel="stylesheet" href="../css/mypageupdate.css">
<script src="https://code.jquery.com/jquery-3.7.0.min.js" ></script>
<script type="text/javascript">

$(function(){
    $(".mypage_up").click(function() {
       let epw = $("#epw").val();
       let ephoneno = $("#ephoneno").val();
       let eaddr = $("#eaddr").val();
        let eaddr2 = $("#eaddr2").val();
       
       let num_reg = /[^0-9]/g; //eid, epw, ephoneno, errn, eaccount
      
       if (epw == "" || epw.length != 5) {
            $("#epw").focus();
            $("#epwMsg").text("비밀번호는 5자리 입니다.");
            $("#epwMsg").css("color", "red");
            return false;
         }else{
            $("#epwMsg").empty();
         }
            
         if (num_reg.test(epw)) {
            $("#epw").focus();
            $("#epwMsg").text("숫자만 입력해주세요.");
            $("#epwMsg").css("color", "red");
            return false;
         }
         
         if (ephoneno == "" || ephoneno.length != 11) {
               $("#ephoneno").focus();
               $("#ephonenoMsg").text("핸드폰번호는 11자리 입니다.");
               $("#ephonenoMsg").css("color", "red");
               return false;
            }else{
               $("#ephonenoMsg").empty();
            }

            if (num_reg.test(ephoneno)) {
               $("#ephoneno").focus();
               $("#ephonenoMsg").text("핸드폰번호에 숫자만 사용할 수 있습니다.");
               $("#ephonenoMsg").css("color","red");
               return false;
            }
         
         if (eaddr == "") {
               $("#eaddr").focus();
               $("#eaddrMsg").text("주소를 입력해주세요.");
               $("#eaddrMsg").css("color", "red");
               return false;
            }else{
               $("#eaddrMsg").empty();
            }
            
            if (eaddr2 == "") {
               $("#eaddr2").focus();
               $("#eaddrMsg2").text("상세주소를 입력해주세요.");
               $("#eaddrMsg2").css("color", "red");
               return false;
            }else{
               $("#eaddrMsg").empty();
            }
    })

});
</script>

</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
 <article id="article">

<div class="nav_container">
      <div class="content_join" id="div_content">
         <h3 class="form_title">
            ${list.ename }님 정보 수정 페이지
         </h3>
         <form action="./mypageupdate" method="post" enctype="multipart/form-data">
            <div class="form topline">
            <table>
               <tr>
               <td><img src="./upload/${list.eimg}" width="100px" height="100px"></td>
               <td>
               <label for="eimg" class="custom-label">사진 변경</label>
               <input type="file" id="eimg" name="eimg" class="custom-file-input">
               <div class="file-name" id="file-name-display"></div>
               </td>
                    
               </tr>
                  <tr>
                     <th class="id">이름</th>
                     <td><input type="text" value="${list.ename}" disabled="disabled"></td>
                     <th class="id">사번</th>
                     <td><input type="text" value="${list.eid}" disabled="disabled"></td>
                     <th class="id">생년월일</th>
                     <td><input type="text" value="${list.ebirth}" disabled="disabled"></td>
                  </tr>
                  <tr>
                     <th class="id">나이</th>
                     <td><input type="text" value="${age}" disabled="disabled"></td>
                     <th class="id">전화번호</th>
                     <td>
                     <input type="text" value="${list.ephoneno}" name="ephoneno" id="ephoneno"  maxlength="11"><br>
                     <span id="ephonenoMsg" class="tip"></span>
                     </td>
                     <th class="id">입사일</th>
                     <td><input type="text" value="${list.ehiredate}" disabled="disabled"></td>
                  </tr>
                  <tr>
                     <th class="id">근무부서</th>
                     <td><input type="text" value="${list.edept}" disabled="disabled"></td>
                     <th class="id">직급</th>
                     <td>
                     <input type="text" value="${egrade}" name="egrade" id="egrade" disabled="disabled"></td>
                  </tr>
                  <tr>
                  <th class="id">주소</th>
                  <td>
                  <input type="text" value="${list.eaddr}" id="eaddr" name="eaddr" id="eaddr"><br>
                  <span id="eaddrMsg" class="tip"></span>
                  </td>
                  <th class="id">상세주소</th>
                  <td>
                  <input type="text" value="${list.eaddr2}" id="eaddr2" name="eaddr2" id="eaddr2"><br>
                  <span id="eaddrMsg2" class="tip"></span>
                  </td>
               </table>
            </div>
            <div class="form_button">
               <button type="button" onclick="location.href='./main'">메인으로</button>
               <button class="mypage_up" type="submit">정보수정</button>
            </div>
         </form>
      </div>
   </div>

</article>
</body>
   <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
window.onload = function(){
    document.getElementById("eaddr").addEventListener("click", function(){ //주소입력칸을 클릭하면
        //카카오 지도 발생
        new daum.Postcode({
            oncomplete: function(data) { //선택시 입력값 세팅
                document.getElementById("eaddr").value = data.address; // 주소 넣기
                document.querySelector("input[name=eaddr2]").focus(); //상세입력 포커싱
            }
        }).open();
    });
}

// 파일 선택 input 요소
const fileInput = document.getElementById("eimg");

// 파일 이름을 표시할 div 요소
const fileNameDisplay = document.getElementById("file-name-display");

// 파일 선택 시 이벤트 리스너
fileInput.addEventListener("change", function() {
  // 선택한 파일의 이름을 표시
  const fileName = fileInput.files[0].name;
  fileNameDisplay.textContent = fileName;
});
</script>


</html>