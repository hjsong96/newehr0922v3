<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>👌::결재하기</title>
<link rel="stylesheet" type="text/css"
	href="./assets/libs/select2/dist/css/select2.min.css">
<link rel="stylesheet" type="text/css"
	href="./assets/libs/jquery-minicolors/jquery.minicolors.css">
<link rel="stylesheet" type="text/css"
	href="./assets/libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<link rel="stylesheet" type="text/css"
	href="./assets/libs/quill/dist/quill.snow.css">
<link href="./css/style.css" rel="stylesheet" />
<link href="./dist/css/style.min.css" rel="stylesheet">
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" href="../css/doApproval.css">
<script type="text/javascript">
var APPROVAL_ITEMS = {
      0 : "경조금",
      1 : "교육신청",
      2 : "재직증명서",
      3 : "경력증명서",
      4 : "휴직",
      5 : "육아휴직",
      6 : "원천징수영수증"
   } 
   function detail(apno){
      //append 값 초기화
      $("#apacpt").text("");
      var stat = $("#"+apno+"").text();
      //alert(stat);
      //console.log(stat);
      $.ajax({
         url:"./doApDetail",
         type:"post",
         data:{apno:apno},
         dataType:"json",
         success:function(data){
            $("#aptitle").text(data.aptitle);
            $("#apno").text(data.apno);
            /* Object로 가져와서 값이 UTC (협정 세계시)로 오므로 변경하는 과정 */
            var timestamp = data.apdate; // 타임스탬프 값
            var date = new Date(timestamp); // 타임스탬프를 Date 객체로 변환
            var year = date.getFullYear(); // 연도 가져오기
            var month = (date.getMonth() + 1).toString().padStart(2, '0'); // 월 가져오기 (0부터 시작하므로 +1 필요)
            var day = date.getDate().toString().padStart(2, '0'); // 일 가져오기
            var formattedDate = year + '-' + month + '-' + day; // 형식화된 날짜 문자열 생성
            $("#apdate").text(formattedDate);
            /* 결제항목 */
               var v = APPROVAL_ITEMS[data.aplist];
            $("#aplist").text(v);
            
            //버튼설정 결재차례 eno = myEno 이면서 대기중(0)이 아닌 경우 버튼을 비활성화
            var myEname = $("#myEname").val();
            //var containChk = $('#'+apno+':contains('+myEname+')').text();
            var containChk = stat.indexOf(myEname); //내 이름이 있으면 숫자, 없으면 -1 배출
            //console.log(containChk);
            var disableButton = false; // 버튼을 비활성화할지 여부를 나타내는 변수
            if (containChk == -1) {
               disableButton = true;
            } 
            for (var i = 0; i < data.appersonsize; i++) {
               var k = "ename"+i
               var k2 = "apacptdetail"+i
               var k3 = "edept"+i
               var k4 = "egrade"+i
               var value = data[k];
               var value2 = data[k2];
               var value3 = data[k3];
               var value4 = "";
               
                
               //직급설정
               if (data[k4] == 1) {
                  value4 = "주임";
               } else if (data[k4] == 2) {
                  value4 = "대리";
               } else if (data[k4] == 3) {
                  value4 = "과장";
               } else if (data[k4] == 4) {
                  value4 = "차장";
               } else if (data[k4] == 5) {
                  value4 = "부장";
               } else if (data[k4] == 6) {
                  value4 = "부사장";
               } else if (data[k4] == 7) {
                  value4 = "사장";
               } else if (data[k4] == 8) {
                  value4 = "관리자";
               }
               //alert(k+" : "+value);
               //var k = data.apperson+i;
               if (value2 == 0) {
                  value2 = "<img height='20px' alt='대기' src='./img/yellow_icon.png'>";
               } else if (value2 == 1) {
                  value2 = "👌<img height='20px' alt='대기' src='./img/green_icon.png'>";
               } else if (value2 == 2) {
                  value2 = "😵<img height='20px' alt='대기' src='./img/red_icon.png'>";
               }
               $("#apacpt").append(value3 + ':' + value + ' ' + value4 + value2 + '<br>');

            }
            // 모든 반복이 끝난 후에 버튼을 설정
            if (disableButton) {
                $('#doApproval').prop('disabled', true);
                $('#notApproval').prop('disabled', true);
            } else {
                $('#doApproval').prop('disabled', false);
                $('#notApproval').prop('disabled', false);
            }
            
            $("#apcontent").html(data.apcontent);
            
            var fileHtml = "";
             if (data.aprealfile != null && data.aprealfile != "") {
                var fileList = data.aprealfile.split("||");
                for (var i = 0; i < fileList.length; i++) {
                   fileHtml += "<a href = '/upload/" + fileList[i] + "' download>첨부파일[" + [i+1] + "]</a>";
                   
                   fileHtml += "<br>";
                }
             }
             $("#aprealfile").html(fileHtml);
            $("#apmemodetail").html(data.apmemo);
            $("#modal").modal("show");
         },
         error:function(error){
            alert("에러가 발생했습니다");
         }
      });
   }
   
</script>
</head>
<body>
	<%@ include file="nav.jsp"%>
	<%@ include file="sidebar.jsp"%>
	<article id="article">
		<input type="hidden" value="${myInfo.myEno }" id="myEno"> <input
			type="hidden" value="${myInfo.myEname }" id="myEname"> <input
			type="hidden" value="${myInfo.myEgrade }" id="myEgrade">
		<!-- 모달 start -->
		<div class="modal" id="modal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true"
			data-bs-backdrop="static">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<!-- 내용 start -->
					<div class="modal-header">
						<h5 class="modal-title" id="aptitle">제 목</h5>
						<button type="button" class="close" data-bs-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="overflow-y: scroll;">
						<div class="table-responsive">
							<table class="table" border="1">
								<tr>
									<td>No.</td>
									<td id="apno"></td>
									<td>신청일</td>
									<td id="apdate"></td>
									<td>결재항목</td>
									<td id="aplist"></td>
								</tr>
								<tbody>
									<tr class="apacpt">
										<th colspan="2" class="apacpt">결재현황</th>
										<td colspan="4" class="apacpt" id="apacpt"></td>
									</tr>
									<tr class="">
										<th colspan="2">본 문</th>
										<td colspan="4" id="apcontent"></td>
									</tr>
									<tr class="">
										<th colspan="2">첨부파일</th>
										<td colspan="4" id="aprealfile"></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div id="append" class="form-group last"></div>
						<div id="appendBtn"></div>
						<!-- .apmemo 특이사항 start -->
						<div id="apmemo" class="form-group">
							<label class="col-md-3">특이사항</label>
							<div class="col-md-12" id="forAddApmemo">
								<textarea id="apmemodetail" class="form-control apmemo"
									placeholder="Disabled input" disabled></textarea>
							</div>
						</div>
						<!-- .apmemo 특이사항 end -->
					</div>
					<!-- 내용 end -->
					<div class="modal-footer">
						<span id="MSG"></span>
						<button type="button" class="btn btn-info" id="doApproval">승인</button>
						<button type="button" class="btn btn-info" id="notApproval">반려</button>
						<button type="button" class="btn btn-info" data-bs-dismiss="modal"
							aria-label="Close">X 닫기</button>
						<br>
						<div class="form-group"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 모달 end -->
		<!-- 보드 start -->
		<h2 class="card-title"
			style="text-align: center; padding-right: 20px;">결재 하기</h2>
		<div class="card">
			<div class="table-responsive">
				<table class="table">
					<thead class="thead-light">
						<tr>
							<th scope="col" class="col-1">No.</th>
							<th scope="col" class="col-3">결재문서제목</th>
							<th scope="col" class="col-2">결재항목</th>
							<th scope="col" class="col-2">승인여부</th>
							<th scope="col" class="col-2">현 황</th>
							<th scope="col" class="col-2">신청일</th>
						</tr>
					</thead>
					<c:forEach items="${doApprovalList}" var="ab">
						<tbody class="customtable">
							<tr id="aptable" onclick="detail(${ab.apno })">
								<th id="tapno">${ab.apno }</th>
								<td>${ab.aptitle }</td>
								<td class=""><c:if test="${ab.aplist eq 0}">경조금</c:if> <c:if
										test="${ab.aplist eq 1}">교육신청</c:if> <c:if
										test="${ab.aplist eq 2}">재직증명서</c:if> <c:if
										test="${ab.aplist eq 3}">경력증명서</c:if> <c:if
										test="${ab.aplist eq 4}">휴직</c:if> <c:if
										test="${ab.aplist eq 5}">육아휴직</c:if> <c:if
										test="${ab.aplist eq 6}">원천징수영수증</c:if></td>
								<td><c:forEach items="${ApListForDoAp}" var="ap">
										<c:if test="${ab.apno eq ap.apno }">
											<c:if test="${ap.apacptdetail eq 0 }">
												<img height="20px" alt="대기" src="./img/yellow_icon.png">
											</c:if>
											<c:if test="${ap.apacptdetail eq 1 }">
												<img height="20px" alt="승인" src="./img/green_icon.png">
											</c:if>
											<c:if test="${ap.apacptdetail eq 2 }">
												<img height="20px" alt="반려" src="./img/red_icon.png">
											</c:if>
										</c:if>
									</c:forEach></td>
								<td id="${ab.apno }"><c:set var="approvalStat" value="승인"></c:set>
									<c:set var="stayStat" value="대기"></c:set> <c:forEach
										items="${ApListForDoAp}" var="item">
										<c:if test="${ab.apno eq item.apno }">
											<c:if test="${item.apacptdetail == 0 && stayStat == '대기'}">
												<c:set var="stayStat" value="대기[${item.ename }]"></c:set>
											</c:if>
										</c:if>
									</c:forEach> <c:if test="${stayStat != '대기'}">
										<c:set var="approvalStat" value="${stayStat }"></c:set>
									</c:if> <c:forEach items="${ApListForDoAp}" var="item">
										<c:if test="${ab.apno eq item.apno }">
											<c:if test="${item.apacptdetail == 2 }">
												<c:set var="approvalStat" value="반려"></c:set>
											</c:if>
										</c:if>
									</c:forEach> ${approvalStat }</td>
								<td>${ab.apdate }</td>
							</tr>
						</tbody>
					</c:forEach>
				</table>
				<!-- 페이징 start -->
				<div class="page_wrap">
					<div class="page_nation">
						<div class="page_left_wrap">
							<c:if test="${ph.showPrev}">
								<button class="page_left"
									onclick="location.href='./doApproval?page=${ph.startPage-1}'">이전</button>
							</c:if>
						</div>
						<c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
							<a class="num"
								href="<c:url value='./doApproval?page=${i}&pageSize=${ph.pageSize}'/>"
								data-page="${i}">${i}</a>
						</c:forEach>
						<c:if test="${ph.showNext}">
							<button class="page"
								onclick="location.href='./doApproval?page=${ph.endPage+1}'">다음</button>
						</c:if>
					</div>
				</div>
			</div>
			<!-- 페이징 end -->


		</div>

		<!-- modal -->
		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		<script src="js/scripts.js"></script>
		<script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
		<!-- 라이브러리연결 -->
		<script src="assets/libs/jquery/dist/jquery.min.js"></script>
		<!-- Bootstrap tether Core JavaScript -->
		<script src="assets/libs/popper.js/dist/umd/popper.min.js"></script>
		<script src="assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
		<!-- slimscrollbar scrollbar JavaScript -->
		<script
			src="assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
		<script src="assets/extra-libs/sparkline/sparkline.js"></script>
		<!--Wave Effects -->
		<script src="dist/js/waves.js"></script>
		<!--Menu sidebar -->
		<script src="dist/js/sidebarmenu.js"></script>
		<!--Custom JavaScript -->
		<script src="dist/js/custom.min.js"></script>
		<!-- this page js -->
		<script src="assets/extra-libs/multicheck/datatable-checkbox-init.js"></script>
		<script src="assets/extra-libs/multicheck/jquery.multicheck.js"></script>
		<script src="assets/extra-libs/DataTables/datatables.min.js"></script>

		<!-- This Page JS -->
		<script
			src="assets/libs/inputmask/dist/min/jquery.inputmask.bundle.min.js"></script>
		<script src="dist/js/pages/mask/mask.init.js"></script>
		<script src="assets/libs/select2/dist/js/select2.full.min.js"></script>
		<script src="assets/libs/select2/dist/js/select2.min.js"></script>
		<script src="assets/libs/jquery-asColor/dist/jquery-asColor.min.js"></script>
		<script src="assets/libs/jquery-asGradient/dist/jquery-asGradient.js"></script>
		<script
			src="assets/libs/jquery-asColorPicker/dist/jquery-asColorPicker.min.js"></script>
		<script src="assets/libs/jquery-minicolors/jquery.minicolors.min.js"></script>
		<script
			src="assets/libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
		<script src="assets/libs/quill/dist/quill.min.js"></script>
		<script>
   /****************************************
    *       Basic Table                   *
    ****************************************/
   $('#zero_config').DataTable();
</script>
		<script>
        //***********************************//
        // For select 2
        //***********************************//
        $(".select2").select2();

        /*colorpicker*/
        $('.demo').each(function() {
        //
        // Dear reader, it's actually very easy to initialize MiniColors. For example:
        //
        //  $(selector).minicolors();
        //
        // The way I've done it below is just for the demo, so don't get confused
        // by it. Also, data- attributes aren't supported at this time...they're
        // only used for this demo.
        //
        $(this).minicolors({
                control: $(this).attr('data-control') || 'hue',
                position: $(this).attr('data-position') || 'bottom left',

                change: function(value, opacity) {
                    if (!value) return;
                    if (opacity) value += ', ' + opacity;
                    if (typeof console === 'object') {
                        console.log(value);
                    }
                },
                theme: 'bootstrap'
            });

        });
        /*datwpicker*/
        jQuery('.mydatepicker').datepicker();
        jQuery('#datepicker-autoclose').datepicker({
            autoclose: true,
            todayHighlight: true
        });
      
        $(function(){
          //승인버튼 클릭
          $("#doApproval").click(function(){
             var apno = $("#apno").text();
             if (!confirm("승인 하시겠습니까?")) {
                return false;
             } else {
                let form = $('<form id="doApprovalGo"></form>');
                form.attr("action", "./doApproval");
                form.attr("method", "post");
                form.append($("<input>", {type:'hidden', name:"doApno", value:apno}));
                form.appendTo("body");
                $("#doApprovalGo").submit();
             }
          });
          
          //반려버튼 클릭
          $("#notApproval").click(function(){
             //버튼 및 사라질 부분 정리
             $("#notApproval").remove();
             var approvalBtnHtml = '<button type="button" class="btn btn-info" id="doNotApproval">반려</button>';
             $(approvalBtnHtml).insertAfter("#doApproval");
             
             var notApReasonHtml = '<label class="col-md-3">반려사유</label>';
                notApReasonHtml += '<div class="col-md-12">';
                notApReasonHtml += '<textarea class="form-control" id="addReason"></textarea>';
                notApReasonHtml += '</div>';
                $(notApReasonHtml).insertAfter("#forAddApmemo");
                
             $("#doNotApproval").click(function(){
                var apno = $("#apno").text();
                var addMemoCk = $("#addReason").val();
                var addMemo = $("#apmemodetail").text() + " | "+$("#myEname").val()+$("#myEgrade").val()+" 반려 사유:" + $("#addReason").val();
                //alert(addMemo);
                
                if (!confirm("반려 하시겠습니까?")) {
                   return false;
                } else {
                   if (addMemoCk.length < 1) {
                      $("#MSG").text("반려사유를 입력하세요.");
                     $("#MSG").css("color", "red");
                     $("#MSG").css("font-weight", "bold");
                     return false;
                   } else {
                      let form = $('<form id="notAp"></form>');
                      form.attr("action", "./notAp");
                      form.attr("method", "post");
                      form.append($("<input>", {type:'hidden', name:"doNotApno", value:apno}));
                      form.append($("<input>", {type:'hidden', name:"addMemo", value:addMemo}));
                      form.appendTo("body");
                      $("#notAp").submit();
                   }
                }
             });
          });
        });
</script>
	</article>
</body>
</html>
