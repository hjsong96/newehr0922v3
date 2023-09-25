<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>👌::결재현황</title>
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
<link rel="stylesheet" href="../css/approvalBoard.css">
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
	$(function(){
		$(".page").click(function() {
		    $(this).addClass('active');
		});
	});
	function detail(apno){
		//값 초기화
		$("#apacpt").text("");
		var apacptChk = true;
		if ($("tr").has(".apacpt").html() == null) {
			apacptChk = false;
		}
		if (!apacptChk) {
			var apacptTrHtml = '<tr class="apacpt">';
				apacptTrHtml += '<th colspan="2" class="apacpt">결재현황</th>';
				apacptTrHtml += '<td colspan="4" class="apacpt" id="apacpt"></td></tr>';
				apacptTrHtml += '<tr id="apacptAfter">';
			$(apacptTrHtml).insertBefore("#apacptAfter");
			$("#append").empty();
			$("#appendBtn").empty();
		}
		
		//alert(apno);
		$.ajax({
			url:"./approvaldetail",
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
				
				disableButton = false; // 버튼을 비활성화할지 여부를 나타내는 변수
				for (var i = 0; i < data.appersonsize; i++) {
					var k = "ename"+i
					var k2 = "apacptdetail"+i
					var k3 = "edept"+i
					var k4 = "egrade"+i
					var value = data[k];
					var value2 = data[k2];
					var value3 = data[k3];
					var value4 = "";
					//버튼설정 하나라도 대기중(0)이 아닌 경우 버튼을 비활성화
					if (value2 !== 0) {
						disableButton = true;
					} 
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
						value2 = "<img height='20px' alt='대기' src='./img/green_icon.png'>";
					} else if (value2 == 2) {
						value2 = "<img height='20px' alt='대기' src='./img/red_icon.png'>";
					}
					$("#apacpt").append(value3 + ':' + value + ' ' + value4 + value2 + '<br>');

				}
				// 모든 반복이 끝난 후에 버튼을 설정
				if (disableButton) {
				    $('#revise').prop('disabled', true);
				    $('#delete').prop('disabled', true);
				} else {
				    $('#revise').prop('disabled', false);
				    $('#delete').prop('disabled', false);
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

		<input type="hidden" value="${myEno }" id="myEno">
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
									<tr id="apacptAfter">
										<th colspan="2">본 문</th>
										<td colspan="4" id="apcontent"></td>
									</tr>
									<tr>
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
							<label class="col-md-3" for="disabledTextInput">특이사항</label>
							<div class="col-md-12">
								<textarea id="apmemodetail" class="form-control apmemo"
									placeholder="Disabled input" disabled></textarea>
							</div>
						</div>
						<!-- .apmemo 특이사항 end -->
					</div>
					<!-- 내용 end -->
					<div class="modal-footer">
						<span id="MSG"></span>
						<button type="button" class="btn btn-info" id="revise">수정</button>
						<button type="button" class="btn btn-info" id="delete">취소</button>
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
		<h2 class="card-title" style="text-align: center; padding-right: 20px;">결재 현황</h2>
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
					<c:forEach items="${approvalBoardList}" var="ab">
						<tbody class="customtable">
							<tr class="aptable" onclick="detail(${ab.apno })">
								<th id="tapno">${ab.apno }</th>
								<td>${ab.aptitle }</td>
								<td class=""><c:if test="${ab.aplist eq 0}">경조금</c:if> <c:if
										test="${ab.aplist eq 1}">교육신청</c:if> <c:if
										test="${ab.aplist eq 2}">재직증명서</c:if> <c:if
										test="${ab.aplist eq 3}">경력증명서</c:if> <c:if
										test="${ab.aplist eq 4}">휴직</c:if> <c:if
										test="${ab.aplist eq 5}">육아휴직</c:if> <c:if
										test="${ab.aplist eq 6}">원천징수영수증</c:if></td>
								<td><c:forEach items="${approvalPerson}" var="ap">
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
								<td><c:set var="approvalStat" value="승인"></c:set> <c:set
										var="stayStat" value="대기"></c:set> <c:forEach
										items="${approvalPerson}" var="item">
										<c:if test="${ab.apno eq item.apno }">
											<c:if test="${item.apacptdetail == 0 && stayStat == '대기'}">
												<c:set var="stayStat" value="대기[${item.ename }]"></c:set>
											</c:if>
										</c:if>
									</c:forEach> <c:if test="${stayStat != '대기'}">
										<c:set var="approvalStat" value="${stayStat }"></c:set>
									</c:if> <c:forEach items="${approvalPerson}" var="item">
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
				<%-- <div class="page-div">
					<c:if test="${ph.showPrev}">
						<button class="page"
							onclick="location.href='./approvalBoard?page=${ph.startPage-1}'">이전</button>
					</c:if>
					<c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
						<a onclick="pageCss()"
							href="<c:url value='./approvalBoard?page=${i}&pageSize=${ph.pageSize}'/>">${i}</a>
					</c:forEach>
					<c:if test="${ph.showNext}">
						<button class="page"
							onclick="location.href='./approvalBoard?page=${ph.endPage+1}'">다음</button>
					</c:if>
				</div> --%>


				<div class="page_wrap">
					<div class="page_nation">
						<div class="page_left_wrap">
							<c:if test="${ph.showPrev}">
								<button class="page_left"
									onclick="location.href='./approvalboard?page=${ph.startPage-1}'">이전</button>
							</c:if>
						</div>
						<c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
							<a class="num"
								href="<c:url value='./approvalboard?page=${i}&pageSize=${ph.pageSize}'/>"
								data-page="${i}">${i}</a>
						</c:forEach>
						<c:if test="${ph.showNext}">
							<button class="page"
								onclick="location.href='./approvalboard?page=${ph.endPage+1}'">다음</button>
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
		//삭제버튼 클릭
		$("#delete").click(function(){
			var apno = $("#apno").text();
			if (!confirm("결재요청을 취소 하시겠습니까?")) {
				return false;
			} else {
				let form = $('<form id="deleteBtn"></form>');
				form.attr("action", "./delete");
				form.attr("method", "post");
				form.append($("<input>", {type:'hidden', name:"delApno", value:apno}));
				form.appendTo("body");
				$("#deleteBtn").submit();
			}
		});
		
		$("#revise").click(function(){
			var apno = $("#apno").text();
			//버튼 및 사라질 부분 정리
			$(".apacpt").remove();
			$("#revise").remove();
			var reviseBtnHtml = '<button type="button" class="btn btn-info" id="reviseGo">수정</button>';
			$(reviseBtnHtml).insertBefore("#delete");
			
			$.ajax({
				url:"./revise",
				type:"get",
				data:{apno:apno},
				dataType:"json",
				success:function(data){
					//버튼조정
					$("#delete").prop('disabled', true);
					
					var editHtml = '<div class="form-group">';
												editHtml += '<div id="editor" class="apcontent" style="height: 300px;">';
												editHtml += '<p>'+data.revise.apcontent+'</p>';
												editHtml += '</div>';
						editHtml += '</div>';
					
					$("#apcontent").empty().append(editHtml);
					$("#aprealfile").html("<div class='form-group'><label class='col-md-3'>파일 업로드</label><div class='col-md-12'><div class='custom-file'><input type='file' class='custom-file-input aporifile' id='validatedCustomFile'><label class='custom-file-label' for='validatedCustomFile'>파일 선택</label><div class='invalid-feedback'>Example invalid custom file feedback</div></div></div></div>");
					// 결재자 선택 start
					// 'approval' 배열을 추출
					var approvalArray = data.approval;
					
					var appersonHtml = '<label class="col-md-12">결재자 선택</label>';
						appersonHtml += '<div class="input-group">';
						appersonHtml += '<select name="apperson" class="select2 form-control custom-select apperson" style="width: 100%; height:36px;">';
						appersonHtml += '<option value="0">결재자를 선택하세요</option>';
					// 각 항목에 대한 작업 수행
					for (var i = 0; i < approvalArray.length; i++) {
					    var approvalDTO = approvalArray[i];
					
					    // approvalDTO에서 필요한 데이터 추출
					    var apno = approvalDTO.apno;
					    var eno = approvalDTO.eno;
					    var edept = approvalDTO.edept;
					    var egrade = approvalDTO.egrade;
					    var ename = approvalDTO.ename;
					    if (eno != data.myEno) {
							appersonHtml += '<option value="'+eno+'">'+edept+'.'+ename;
					    }
					    if (egrade == 0) {
					    	appersonHtml += ' 사원</option>';
					    } else if (egrade == 1) {
					    	appersonHtml += ' 주임</option>';
					    } else if (egrade == 2) {
					    	appersonHtml += ' 대리</option>';
					    } else if (egrade == 3) {
					    	appersonHtml += ' 과장</option>';
					    } else if (egrade == 4) {
					    	appersonHtml += ' 차장</option>';
					    } else if (egrade == 5) {
					    	appersonHtml += ' 부장</option>';
					    } else if (egrade == 6) {
					    	appersonHtml += ' 부사장</option>';
					    } else if (egrade == 7) {
					    	appersonHtml += ' 사장</option>';
					    } else {
					    	appersonHtml += ' </option>';
					    } 
					}
							appersonHtml += '</select></div>';
					$("#append").empty().append(appersonHtml);
					// 결재자 선택 end
					// 결재자 추가 start
					var addHtml = '<div class="form-group">';
						addHtml += '<button id="addapperson" type="button" class="btn btn-info"> +결제자 추가 </button></div>';
					$("#appendBtn").append(addHtml);
					$("#addapperson").on("click", function(){
						//alert(appersonHtml);
						$(".last").append(appersonHtml);
					});
					// 결재자 추가 end
					
					//수정버튼 클릭
					$("#reviseGo").on("click", function(){
						var revApno = $("#apno").text();
						var revApcontent = $("#editor").text();
						//file
						/* 결재자 배열생성 start*/
						var revAppersonLn = $("select[name=apperson]").length;
						var revAppersonArr = new Array(revAppersonLn);
						for(var i = 0; i < revAppersonLn; i++) {
							revAppersonArr[i] = $("select[name=apperson]").eq(i).val();
						}
						//alert(revAppersonArr);
						/* 결재자 배열생성 end */
						if (revApcontent.length < 1) {
							$("#MSG").text("내용을 입력하세요.");
							$("#MSG").css("color", "red");
							$("#MSG").css("font-weight", "bold");
							return false;
						}
						for (var i = 0; i < revAppersonLn; i++) {
							if (revAppersonArr[i] == 0) {
								$("#MSG").text("결재자를 선택하세요.");
								$("#MSG").css("color", "red");
								$("#MSG").css("font-weight", "bold");
								return false;
							}
						}
						if (!confirm("수정 제출 하시겠습니까?")) {
							return false;
						} else {
							//수정 제출
							var revContent = $("#editor").children().html();
							//var aprealfile = $("#validatedCustomFile").text();
							var memo = $("#apmemodetail").html();
							var now = new Date();
							var revDate = now.getFullYear() +"-"+ (now.getMonth()+1) +"-"+ now.getDate();
							//alert(revDate);
							
							let form = $('<form></form>');
							form.attr("action", "./revise");
							form.attr("method", "post");
							form.append($("<input>", {type:'hidden', name:"revApno", value:revApno}));
							form.append($("<input>", {type:'hidden', name:"revContent", value:revContent}));
							//form.append($("<input>", {type:'hidden', name:"file", value:aprealfile}));
							form.append($("<input>", {type:'hidden', name:"revAppersonArr", value:revAppersonArr}));
							form.append($("<input>", {type:'hidden', name:"revDate", value:memo + "| 수정일 : "+ revDate}));
							
							form.appendTo("body");
							form.submit();
						}
					});
					
					var quill = new Quill('#editor', {
			            theme: 'snow'
			        });
				},
				error:function(error){
					alert("에러가 발생했습니다");
				}
			});
		});
	});

</script>
	</article>
</body>
</html>
