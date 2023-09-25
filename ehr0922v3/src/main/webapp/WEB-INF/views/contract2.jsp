<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Salary</title>
<link rel="stylesheet"
	href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="./css/modal2.css" rel="stylesheet" />
<link href="./css/style.css" rel="stylesheet" />
<link href="./css/contract.css" rel="stylesheet" />

<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Bagel+Fat+One&display=swap"
	rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@700&display=swap"
	rel="stylesheet">
<script type="text/javascript">

$(document).ready(function() {
    // 저장 버튼 클릭 시 이벤트 핸들러
    $(".save").on("click", function() {
        let isEmpty = false; // 빈 필드 여부를 나타내는 변수
        let isValid = true; // 입력 값 유효성 여부를 나타내는 변수

        // 각 input 필드를 검사
        $(".ename, .edept, .egrade, .estate, .eemail, .cstrdate, .cenddate, .cagree").each(function() {
            if ($(this).val() === "") {
                isEmpty = true; // 빈 필드가 있으면 isEmpty를 true로 설정
                return false; // 빈 필드를 찾았으므로 반복문을 종료
            } else if(!(isNaN($(".ename").val())) || !(isNaN($(".edept").val())) || !(isNaN($(".eemail").val()))) {
            	alert("성명/부서/이메일은 문자만 입력 가능합니다.");
        		$("select[name='eid']").val("");
        		$(".ename").val("");
        		$(".edept").val("");
        		$(".eemail").val("");
                isValid = false;
                return false;
            } else if(isNaN($(".estate").val()) || isNaN($(".cagree").val())){
                alert("재직상태, 동의여부는 숫자만 가능합니다.");
    			$(".estate").val("");
    			$(".cagree").val("");
                isValid = false;
                return false;
            }
        });

        if (isEmpty || !isValid) {
            // 빈 필드가 있는 경우 알람 띄우고 저장 버튼 비활성화
            if (isEmpty) {
                alert("모든 필드를 입력해주세요.");
            }
            return false; // 폼 전송을 중지
        }  else {
            // 입력값이 유효하고 빈 필드가 없는 경우 폼을 다시 전송
            $(this).closest("form").submit();
        }
        
    });
});

$(document).ready(function() {
	$(".employeeSelect").on("change", function() {
	    let eid = $(this).val();
	    if (eid !== "") {
	        $.ajax({
	            url: "./searchEmp2", // 서버의 URL을 입력하세요.
	            type: "post",
	            data: { "eid": eid },
	            dataType: "json",
	            success: function (data) {
	                // 서버에서 받아온 데이터를 처리하는 코드
	                //alert(data.elist.ename)
	            	$(".ename").val(data.elist.ename);                
	            	$(".edept").val(data.elist.edept);                
	            	$(".estate").val(data.elist.estate);                
	            	$(".eemail").val(data.elist.eemail);                
	            	let egrade = data.elist.egrade;
	                if (egrade === 0) {
	                    $(".egrade").val("사원");
	                } else if (egrade === 1) {
	                    $(".egrade").val("주임");
	                } else if (egrade === 2) {
	                    $(".egrade").val("대리");
	                } else if (egrade === 3) {
	                    $(".egrade").val("과장");
	                } else if (egrade === 4) {
	                    $(".egrade").val("차장");
	                } else if (egrade === 5) {
	                    $(".egrade").val("부장");
	                } else if (egrade === 6) {
	                    $(".egrade").val("부사장");
	                } else if (egrade === 7) {
	                    $(".egrade").val("사장");
	                } else if (egrade === 6) {
	                    $(".egrade").val("관리자");
	                }                
	            },
	            error: function (error) {
		            $(".retry").text("올바른 사번이 아닙니다. 5자리로 존재하는 사번을 다시 입력해주세요.").css({"color": "red", "font-weight": "bold"});
		            $(".save").prop("disabled", true);
	            }
	        });
	    }
	});
	});


function getsno() {
    let row = [];
    $("input[name=check]:checked").each(function() {
        let cno = $(this).closest('tr').find('.cno').text();
        //alert(cno);
        row.push(cno);
    });

    if (row.length > 0) {
        $.ajax({
            url: "./deleteRows2", // 서버의 URL을 입력하세요.
            type: "post",
            data: { "row" : row },
            dataType: "json",
            success: function (data) {
                alert("선택한 행이 삭제되었습니다.");
                $("input[name=check]:checked").prop("checked", false);
                location.href="./contract2?eno="+${sessionScope.eno};
            },
            error: function (error) {
                alert("삭제 중 오류가 발생했습니다.");
            }
        });
    } else {
        alert("삭제할 행을 선택해주세요.");
    }
}

		$(function(){
			$("#allCheck").click(function() {
			    if($("#allCheck").is(":checked")) $("input[name=check]").prop("checked", true);
			    else $("input[name=check]").prop("checked", false);
			 });
		});


		function sendmail() {
			
		    let count = $("input[name=check]:checked");
		    
		    if (count.length > 1) {
		        alert("메일은 하나의 대상에게만 보낼 수 있습니다.");
		        return;
		    }
		    
		    count.each(function() {
		        let eid2 = $(this).closest('tr').find('.eid2').text();
		        let ename2 = $(this).closest('tr').find('.ename2').text();
		        let edept2 = $(this).closest('tr').find('.edept2').text();
		        let eemail2 = $(this).closest('tr').find('.eemail2').text();

		        let text = edept2 + " " + ename2 + "님 연봉계약서 동의 여부가 선택되지 않았습니다. 확인 후 연봉계약서 동의 부탁드립니다.^^";

		        $(".email").val(eemail2);
		        $(".content").val(text);
		    });

		    $("#exampleModal").modal("show");
		};
		
	
	function getcontent() {
		let count = $("input[name=check]:checked");
		
	    if(count.length > 1){
	    	alert("연봉 복사는 하나만 가능합니다.");
			$("select[name='eid']").val("");
			$(".ename").val("");
			$(".edept").val("");
			$(".egrade").val("");
			$(".estate").val("");
			$(".eemail").val("");
			$(".cstrdate").val("");
			$(".cenddate").val("");
			$(".cagree").val("");
	    	return false;
	    } 
	    
	    $("input[name=check]:checked").each(function() {
	    	
			let eid2 = $(this).closest('tr').find('.eid2').text();
			let ename2 = $(this).closest('tr').find('.ename2').text();
			let edept2 = $(this).closest('tr').find('.edept2').text();
			let egrade2 = $(this).closest('tr').find('.egrade2').text().trim();
			let estate2 = $(this).closest('tr').find('.estate2').text();
			let eemail2 = $(this).closest('tr').find('.eemail2').text();
			let cstrdate2 = $(this).closest('tr').find('.cstrdate2').text();
			let cenddate2 = $(this).closest('tr').find('.cenddate2').text();
			let cagree2 = $(this).closest('tr').find('.cagree2').text();
			
			alert("복사되었습니다.");
			
			$("select[name='eid']").val(eid2);
			$(".ename").val(ename2);
			$(".edept").val(edept2);
			$(".egrade").val(egrade2);
			$(".estate").val(estate2);
			$(".eemail").val(eemail2);
			$(".cstrdate").val(cstrdate2);
			$(".cenddate").val(cenddate2);
			$(".cagree").val(cagree2);
	    });

	}
	
</script>
</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
	<article id="article2">
	<div class="total_area2">
			<h1 class="example">관리자-연봉 동의목록</h1>
		<div class="top_area">
			<form action="./contract2" method="get">
						<div class="search_area">
				<ul>
					<li class="li1">조회기간<input class="input1" type="month" name="cstrdate"> ~ <input class="input1" type="month" name="cenddate"></li>
					<li class="li1">소속<input class="input1" name="edept"></li>
					<li class="li1">직급 <select class="select" name="egrade">
							<option value="" selected disabled hidden></option>
							<option value="0">사원</option>
							<option value="1">주임</option>
							<option value="2">대리</option>
							<option value="3">과장</option>
							<option value="4">차장</option>
							<option value="5">부장</option>
							<option value="6">부사장</option>
							<option value="7">사장</option>
							<option value="8">관리자</option>
					</select>
					</li>
					<li class="li1">사번<input class="input1" name="eid"></li>
					<li class="li1">성명<input name="ename" class="ename3 input1"></li>
					<li class="li1">재직상태 <select class="select" name="estate">
							<option value="0">재직</option>
							<option value="1">퇴사</option>
					</select>
					</li>
					<li class="li1">동의 <select class="select" name="cagree">
							<option value="0">비동의</option>
							<option value="1">동의</option>
					</select>
					</li>
				</ul>
				<div class="border_area2">
				<div class="btn_area2">				
				<button class="search">조회</button>
				<button type="button" class="delBtn" onclick="getsno()">삭제</button>
				<button type="button" class="copyBtn" onclick="getcontent()">복사</button>
				<button type="button" class="mailBtn" onclick="sendmail()">메일</button>
				<input type="hidden" name="eno" value="${sessionScope.eno}">
				</div>
				</div>
				</div>
			</form>
			
		</div>
			<div class="middle_area2">
					<div class="middle_content4">
			<table class="contracttb">
				<tr>
					<td class="th2 tt"><input type="checkbox" id="allCheck"></td>
					<td class="th2 tt">No</td>
					<td class="th3 tt">사번</td>
					<td class="th3 tt">성명</td>
					<td class="th4 tt">부서</td>
					<td class="th3 tt">직급</td>
					<td class="th2 tt">재직상태</td>
					<td class="th4 tt">이메일주소</td>
					<td class="th6 tt">시작일</td>
					<td class="th6 tt">종료일</td>
					<td class="th2 tt">동의</td>
					<td class="th6 tt">동의일자</td>
				</tr>
				<c:forEach items="${adclist }" var="row">
					<tr class="modalOpen">
						<td class="cdel th2" ><input type="checkBox" name="check" id="check" value=${row.cno }></td>
						<td class="cno th2">${row.cno }</td>
						<td class="eid2 th3">${row.eid }</td>
						<td class="ename2 th3">${row.ename }</td>
						<td class="edept2 th4">${row.edept }</td>
						<td class="egrade2 th3">
						<c:if test="${row.egrade eq 0}">사원</c:if>
						<c:if test="${row.egrade eq 1}">주임</c:if> 
						<c:if test="${row.egrade eq 2}">대리</c:if> 
						<c:if test="${row.egrade eq 3}">과장</c:if> 
						<c:if test="${row.egrade eq 4}">차장</c:if> 
						<c:if test="${row.egrade eq 5}">부장</c:if> 
						<c:if test="${row.egrade eq 6}">부사장</c:if> 
						<c:if test="${row.egrade eq 7}">사장</c:if> 
						<c:if test="${row.egrade eq 8}">관리자</c:if> 						
						</td>
						<td class="estate2 th2">${row.estate }</td>
						<td class="eemail2 th4">${row.eemail }</td>
						<td class="cstrdate2 th6">${row.cstrdate }</td>
						<td class="cenddate2 th6">${row.cenddate }</td>
						<td class="cagree2 th2">${row.cagree }</td>
						<td class="cagreedate2 th6">${row.cagreedate }</td>
					</tr>
				</c:forEach>
			</table>
			</div>
		</div>
		
					<div class="page_wrap">
						<div class="page_nation">
					 <div class="page_left_wrap">
				      <c:if test="${ph.showPrev}">
				            <a class="page_left" onclick="location.href='./contract2?eno=${sessionScope.eno}&page=${ph.startPage-1}'">이전</a>
				        </c:if>
				     </div>
				      <c:forEach var="i" begin="${ph.startPage}" end="${ph.endPage}">
						<a class="num" href="<c:url value='./contract2?eno=${sessionScope.eno}&page=${i}&pageSize=${ph.pageSize}'/>" data-page="${i}">${i}</a>
				      </c:forEach>
				      <c:if test="${ph.showNext}">
				            <a class="page_right" onclick="location.href='./contract2?eno=${sessionScope.eno}&page=${ph.endPage+1}'">다음</a>
				        </c:if>
						</div>
				   </div>
				<div class="bottom_area">   
				<h1>연봉등록</h1>
				<div class="border_area">
					<form action="./contract2" method="post">
						<div class="btn_area3">
						<button class="save">저장</button>
						<input type="hidden" name="eno" value="${sessionScope.eno}">
						<span class="retry"></span>
						</div>
					<table class="contracttb2">
							<tr>
					<td class="th2 tt">No</td>
					<td class="th3 tt">사번</td>
					<td class="th3 tt">성명</td>
					<td class="th4 tt">부서</td>
					<td class="th3 tt">직급</td>
					<td class="th2 tt">재직상태</td>
					<td class="th4 tt">이메일주소</td>
					<td class="th6 tt">시작일</td>
					<td class="th6 tt">종료일</td>
					<td class="th2 tt">동의</td>
					<td class="th6 tt">동의일자</td>
							</tr>
								<tr>
								<td></td>
								<td>
									<select name="eid" class="employeeSelect select2">
										 <option value="">-- 선택 --</option>
	   								<c:forEach items="${eidList}" var="row">
	        							<option value="${row.eid}">${row.eid}</option>
	   								</c:forEach>
									</select>
								</td>
								<td><input class="ename input2" name="ename" ></td>
								<td><input class="edept input2" name="edept" ></td>
								<td><input class="egrade input2" name="egrade" ></td>
								<td><input class="estate input2" name="estate" ></td>
								<td><input class="eemail input2" name="eemail" ></td>
								<td><input class="cstrdate input2" name="cstrdate" type="date"></td>
								<td><input class="cenddate input2" name="cenddate" type="date"></td>
								<td><input class="cagree input2" name="cagree2"></td>
								<td><input class="cagreedate2 input2" name="cagreedate2"></td>
								</tr>
						</table>
					</form>
					</div>
				</div>
					</article>
				
		<!-- Modal -->
		<div class="modal fade" id="exampleModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true"
			data-bs-backdrop="static">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<!-- 헤더 바디 푸터 묶어주는 div -->
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">연봉동의 메일 보내기</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
					<!-- 내용 start -->
						<div class="datail-detail">
							<div class="mail-content">
								<form action="./mail" method="post">
									<input class="title" type="text" name="title"
										value="연봉계약서 확인 바랍니다."> <input class="email"
										type="text" name="to" placeholder="받는 사람 email 주소를 적어주세요">
									<textarea class="content" name="content"></textarea>
									<button class="mail-button" type="submit">보내기</button>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	<!-- modal -->
	
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/scripts.js"></script>
	<script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
</body>
</html>
