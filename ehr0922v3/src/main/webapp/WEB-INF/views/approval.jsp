<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>👌::결재요청</title>
<link rel="stylesheet" type="text/css" href="./assets/libs/select2/dist/css/select2.min.css">
<link rel="stylesheet" type="text/css" href="./assets/libs/jquery-minicolors/jquery.minicolors.css">
<link rel="stylesheet" type="text/css" href="./assets/libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<link rel="stylesheet" type="text/css" href="./assets/libs/quill/dist/quill.snow.css">
<link href="./dist/css/style.min.css" rel="stylesheet">
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" href="../css/approval.css">
<script type="text/javascript">
	$(function(){
		$("#addapperson").on("click", function(){
			var html = "<br><div class='input-group'><select name='apperson' class='select2 form-control custom-select apperson' style='width: 100%; height:36px;'><option value='0'>결재자를 선택하세요</option><c:forEach items='${approval }' var='r'><option value='${r.eno }'>${r.edept }.${r.ename } <c:if test='${r.egrade eq 0}'>사원</c:if><c:if test='${r.egrade eq 1}'>주임</c:if><c:if test='${r.egrade eq 2}'>대리</c:if><c:if test='${r.egrade eq 3}'>과장</c:if><c:if test='${r.egrade eq 4}'>차장</c:if><c:if test='${r.egrade eq 5}'>부장</c:if><c:if test='${r.egrade eq 6}'>부사장</c:if><c:if test='${r.egrade eq 7}'>사장</c:if></option></c:forEach></select></div></div>";
			$(".last").append(html);
		});		
		$("#approval").click(function(){
			
			var aptitle = $("#aptitle").val();
			let apcontenttext = $("#editor").text();
			/* 결재자 배열생성 start*/
			var appersonln = $("select[name=apperson]").length;
			var appersonarr = new Array(appersonln);
			for(var i = 0; i < appersonln; i++) {
				appersonarr[i] = $("select[name=apperson]").eq(i).val();
			}
			/* 결재자 배열생성 end */
				//alert(appersonarr);
			if (aptitle == "") {
				$("#MSG").text("제목을 입력하세요.");
				$("#MSG").css("color", "red");
				$("#MSG").css("font-weight", "bold");
				return false;
			} else if (apcontenttext.length < 1) {
				$("#MSG").text("내용을 입력하세요.");
				$("#MSG").css("color", "red");
				$("#MSG").css("font-weight", "bold");
				return false;
			}
			for(var i = 0; i < appersonln; i++) {
				if(appersonarr[i] == 0) {
					$("#MSG").text("결재자를 선택하세요.");
					$("#MSG").css("color", "red");
					$("#MSG").css("font-weight", "bold");
					return false;
				}
			}
			if (!confirm("결제를 제출 하시겠습니까?")) {
				return false;
			} else {
				/* 제출 */
				
				var aplist = $("#aplist").val();
				var aptitle = $("#aptitle").val();
				var apcontent = $("#editor").children().html();
				var aprealfile = $("#validatedCustomFile");
				
				if (aprealfile.length > 0) {
					var formData = new FormData();
					
					var inputFile = $("input[name='uploadFile']");
					var files = inputFile[0].files;
					
					for (var i = 0; i < files.length; i++) {
						formData.append("uploadFile", files[i]);
					}
					
					$.ajax({
						url : '/uploadFile',
						processData : false,
						contentType : false,
						dataType:"json",
						data : formData,
						type : "POST",
						success : function (res) {
							var fileNames = res.fileNames;
							var fileNameStr = "";
							
							for (var i = 0; i < fileNames.length; i++) {
								if (i == 0) {
									fileNameStr += fileNames[i];
								} else {
									fileNameStr += "||"+fileNames[i];
								}
								
							}
							let form = $('<form></form>');
							form.attr("action", "./approval");
							form.attr("method", "post");
							form.append($("<input>", {type:'hidden', name:"ipAplist", value:aplist}));
							form.append($("<input>", {type:'hidden', name:"ipAptitle", value:aptitle}));
							form.append($("<input>", {type:'hidden', name:"ipEditor", value:apcontent}));
							form.append($("<input>", {type:'hidden', name:"fileNameStr", value:fileNameStr}));
							form.append($("<input>", {type:'hidden', name:"appersonArr", value:appersonarr}));
							
							form.appendTo("body");
							form.submit();
						},
						error:function(error){
							alert("에러가 발생했습니다");
						}
					})
				} else {
					let form = $('<form></form>');
					form.attr("action", "./approval");
					form.attr("method", "post");
					form.append($("<input>", {type:'hidden', name:"ipAplist", value:aplist}));
					form.append($("<input>", {type:'hidden', name:"ipAptitle", value:aptitle}));
					form.append($("<input>", {type:'hidden', name:"ipEditor", value:apcontent}));
					form.append($("<input>", {type:'hidden', name:"appersonArr", value:appersonarr}));
					form.appendTo("body");
					form.submit();
				}
			}
		});
		
	});		  
</script>
<style type="text/css">
#card{
	width: 500px;
}
</style>
</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
 <article id="article">
 
<h2 class="card-title">결재요청</h2>
<div class="atList2">
<div class="card" id="card">
	<div class="card-body">
		<!-- <form action="./approval" method="post"> -->
			<!-- aplist 결재항목 선택 start-->
			<div class="form-group">
				<label class="col-md-12">결재항목 선택</label>
				<div class="input-group">
					<select name="aplist" id="aplist" class="select2 form-control custom-select" style="width: 100%; height:36px;">
						<option value="0">0.경조금</option>
						<option value="1">1.교육신청</option>
						<option value="2">2.재직증명서</option>
						<option value="3">3.경력증명서</option>
						<option value="4">4.휴직</option>
						<option value="5">5.육아휴직</option>
						<option value="6">6.원천징수영수증</option>
					</select>
				</div>
			</div>
			<!-- aplist 결재항목 선택 end -->
		
			<!-- aptitle 제 목 start -->
			<div class="form-group">
				<label class="col-md-10">제 목</label>
				<div class="input-group">
					<input id="aptitle" name="aptitle" class="form-control">
				</div>
			</div>
			<!-- aptitle 제 목 end -->
			<!-- .apcontent 본 문 start -->
			<div class="form-group">
				<label class="col-md-10">본 문</label>
				<div class="input-group">
					<div class="row">
				        <div class="col-12">
				            <div class="card">
				                <div class="card-body">
				                    <!-- Create the editor container -->
				                    <div id="editor" class="apcontent">
									    <p></p>
				                    </div>
				                    <!-- the editor end -->
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
			</div>
			<!-- .apcontent 본 문 end -->
			<!-- .aporifile 파일 업로드 start -->
			<div class="form-group">
				<label class="col-md-3" id="colMd">파일 업로드</label>
			    <div class="col-md-12" id="colFile">
			        <div class="custom-file">
			            <input type="file" class="custom-file-input aporifile" id="validatedCustomFile" name = "uploadFile" multiple>
			            <label class="custom-file-label" for="validatedCustomFile">파일 선택</label>
			            <div class="invalid-feedback">Example invalid custom file feedback</div>
			        </div>
			    </div>
			</div>
			<!-- .aporifile 파일 업로드 end -->
			<!-- .apmemo 특이사항 start -->			
			<div class="form-group">
			    <label class="col-md-3" id="colMd2" for="disabledTextInput">특이사항</label>
			    <div class="col-md-12" id="colText">
			        <textarea id="disabledTextInput" class="form-control apmemo" placeholder="Disabled input" disabled></textarea>
			    </div>
			</div>
			<!-- .apmemo 특이사항 end -->
			<!-- apperson 결재자 선택 start-->
			<div class="form-group last">
				<label class="col-md-12" id="colMd3">결재자 선택</label>
				<div class="input-group" id="colApp">
					<select name="apperson" class="select2 form-control custom-select apperson" style="width: 100%; height:36px;">
						<option value="0">결재자를 선택하세요</option>
						<c:forEach items="${approval }" var="r"> 
							<c:if test="${r.eno ne myEno }">
							<option value="${r.eno }">${r.edept }.${r.ename } <c:if test="${r.egrade eq 0}">사원</c:if><c:if test="${r.egrade eq 1}">주임</c:if><c:if test="${r.egrade eq 2}">대리</c:if><c:if test="${r.egrade eq 3}">과장</c:if><c:if test="${r.egrade eq 4}">차장</c:if><c:if test="${r.egrade eq 5}">부장</c:if><c:if test="${r.egrade eq 6}">부사장</c:if><c:if test="${r.egrade eq 7}">사장</c:if></option>
							</c:if>
						</c:forEach>
					</select>
				</div>
			</div>
			<!-- apperson 결재자 선택 end -->
			<!-- apperson 결재자 추가 start -->
			<div class="form-group">
				<button id="addapperson" type="button" class="btn btn-info"> +결제자 추가 </button>
			</div>
			<!-- apperson 결재자 추가 end -->
			<!-- 메세지 span start -->
			<div class="form-group">
				<span id="MSG"></span>
			</div>
			<!-- 메세지 span end -->
			<!-- approval 버튼 start -->
			<button id="approval" type="button" class="btn btn-info">제출</button>
			<!-- approval 버튼 end -->
		<!-- </form> -->
	</div>
</div>
</div>

<!-- 라이브러리연결 -->
<script src="assets/libs/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap tether Core JavaScript -->
<script src="assets/libs/popper.js/dist/umd/popper.min.js"></script>
<script src="assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- slimscrollbar scrollbar JavaScript -->
<script src="assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
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
<script src="assets/libs/inputmask/dist/min/jquery.inputmask.bundle.min.js"></script>
<script src="dist/js/pages/mask/mask.init.js"></script>
<script src="assets/libs/select2/dist/js/select2.full.min.js"></script>
<script src="assets/libs/select2/dist/js/select2.min.js"></script>
<script src="assets/libs/jquery-asColor/dist/jquery-asColor.min.js"></script>
<script src="assets/libs/jquery-asGradient/dist/jquery-asGradient.js"></script>
<script src="assets/libs/jquery-asColorPicker/dist/jquery-asColorPicker.min.js"></script>
<script src="assets/libs/jquery-minicolors/jquery.minicolors.min.js"></script>
<script src="assets/libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
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
        var quill = new Quill('#editor', {
            theme: 'snow'
        });

    </script>
</article>
</body>
</html>
