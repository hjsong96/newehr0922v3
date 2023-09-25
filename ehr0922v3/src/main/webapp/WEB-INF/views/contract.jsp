<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Salary</title>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="./css/style.css" rel="stylesheet" />
<link href="./css/modal.css" rel="stylesheet" />
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
	function printPage() {
		window.print();
	}

	$(function(){
		let clickedOnce = false;
		 $(".xi-file-text-o").click(function(){
			 
 	        $(document).on("click", ".btn-close", function() {
                $("#submit button, .agree2, #acno2, #acstrdate2, #acenddate2").remove();
        	}); //.btn-close 끝
			 
	        let cno = $(this).parents("tr").find(".cno").text();
	        let eno = $(".eno").val();
	        let cstrdate = $(this).parents("tr").find(".cstrdate").text();
	        let cenddate = $(this).parents("tr").find(".cenddate").text();
			
			   $.ajax({
					url: "./modal",
					type: "post",
					data: {"cno" : cno, "eno" : eno, "cstrdate" : cstrdate, "cenddate" : cenddate }, 
					dataType: "json",
					success:function(data){
						let acno = data.clist2.cno;
						let acstrdate = data.clist2.cstrdate;
						let acenddate = data.clist2.cenddate;
						
						function formatNumber(number) {
                    	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                		}
						$(".name").text(data.elist.ename);
						$(".sannualsal").text(formatNumber(data.slist.sannualsal) + '원');
						$(".sbasesal").text(formatNumber(data.slist.sbasesal) + '원');
						$(".seat").text(formatNumber(data.slist.seat) + '원');
						$(".ssalary").text(formatNumber(data.slist.ssalary) + '원');
						$(".cstrdate2").text(cstrdate);
						$(".cenddate2").text(cenddate);
						$(".eaddr").text(data.elist.eaddr);
						$(".errn").text(data.elist.errn);
						
						let button = $("<button></button>");
						button.text("제출하기");
						button.attr("type", "submit");
						button.attr("class", "submit");
	                    $("#submit").append(button);
						
		                $("#exampleModal").modal("show");
		                

	                    if(!clickedOnce) {  // clickedOnce가 false인 경우에만 버튼 생성
			            	$(document).on("click", ".submit", function(){
			            		//가상 form 만들어서 전송하기
			            		let agreeValue = $("input[name='agree']:checked").val();
			            		
			            	    // 선택된 동의 값 확인
			            	    if (agreeValue !== undefined) {
			            	        let form = $('<form></form>');
			            	        form.attr("action", "./contrack");
			            	        form.attr("method", "post");

			            	        // 동의 값을 추가
			            	        let agreeInput = $("<input>");
			            	        agreeInput.attr("name", "agree2");
			            	        agreeInput.attr("class", "agree2");
			            	        agreeInput.attr("type", "hidden");
			            	        agreeInput.val(agreeValue);
			            	        form.append(agreeInput);

			            	        // acno, acstrdate, acenddate 값 추가
			            	        let input1 = $("<input>");
			            	        input1.attr("name", "acno2");
			            	        input1.attr("id", "acno2");
			            	        input1.attr("type", "hidden");
			            	        input1.val(acno);
			            	        form.append(input1);

			            	        let input2 = $("<input>");
			            	        input2.attr("name", "acstrdate2");
			            	        input2.attr("id", "acstrdate2");
			            	        input2.attr("type", "hidden");
			            	        input2.val(acstrdate);
			            	        form.append(input2);

			            	        let input3 = $("<input>");
			            	        input3.attr("name", "acenddate2");
			            	        input3.attr("id", "acenddate2");
			            	        input3.attr("type", "hidden");
			            	        input3.val(acenddate);
			            	        form.append(input3);

			            	        form.appendTo(".detail-head2");
			            	        
				            	    $(document).on("click", ".submit", function() {
					                    $("#submit button, .agree2, #acno2, #acstrdate2, #acenddate2").remove();
						            	}); 
			            	        
			            	        $(document).on("click", ".btn-close", function() {
					                    $("#submit button, .agree2, #acno2, #acstrdate2, #acenddate2").remove();
					            	}); //.btn-close 끝
			            	        
			            	        form.submit();
				                    clickedOnce = true;
			            		} //if 끝 
			            	    else {
			            	        alert("동의 또는 비동의를 선택하세요.");
			            	    } //else 끝
			            	}); //submit 클릭 시 끝
		                } //클릭 false 체크 끝
		            	   
					}, //success 끝
					
					error:function(error){
						alert("에러가 발생했습니다.");} //error 끝
				}); //ajax 끝
		}); //.xi-file-text-o 클릭 끝
	}); //function 끝
</script>
</head>
<body>
<%@ include file="nav.jsp" %>
<%@ include file="sidebar.jsp" %>
	<article id="article2">
	<div class="total-content">
	<h1 class="example">연봉계약서</h1>
	<form action="./salary" method="get">
		<input type="hidden" name="eno" class="eno" value="${sessionScope.eno}">
	</form>
	<br>

	<div class="middle_area">
		<div class="middle_content1">
		<table class="contract1">
			<tr>
				<th>No</th>
				<th>세부내역</th>
				<th>시작일자</th>
				<th>종료일자</th>
				<th>동의</th>
				<th>동의일자</th>
			</tr>
			<c:forEach items="${clist }" var="row">
				<tr> 
					<td class="cno td1">${row.cno }</td>
					<td class="td1"><i class="xi-file-text-o modalOpen" style="cursor: pointer;"></i></td>
					<td class="cstrdate td1">${row.cstrdate }</td>
					<td class="cenddate td1">${row.cenddate }</td>
					<td class="td1">${row.cagree }</td>
					<td class="td1">${row.cagreedate }</td>
				</tr>
			</c:forEach>
		</table>
		</div>
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-backdrop="static">
		<div class="modal-dialog modal-lg">
			<div class="modal-content"> <!-- 헤더 바디 푸터 묶어주는 div -->
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">연봉계약서 세부내역</h5>
						<button class="print" onclick="printPage()">출력</button>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="datail-detail">
						<div>
						</div>
						<div class="detail-name">연봉계약서</div>
							<div class="detail-content">
							(주)지식소프트(이하 '갑'이라 함)와 <span class="name"></span> 은/는 체결된 근로계약서의 부속계약서로서 다음과 같이 연봉 계약을 체결하고 이를 성실히 이행할 것을 약정한다. 
							</div>
							<div class="detail-content">
							<div class="detail-head">제 1조. 적용기간:</div>
								① <span class="cstrdate2"></span> 부터 <span class="cenddate2"></span> 까지로 한다.<br>
								② 제 1항의 적용 기간 이후 총연봉 금액 및 구성항목의 조정은 매년 "갑" 의 취업규칙 또는 "갑"이 정한 조정 기준 및 절차에 따르기로 한다.<br> 
				   				   ※ 단, 총연봉의 저하가 발생하는 경우에는 "갑"과 "을"이 별도로 합의하여 정한다.
				   			</div>
							<div class="detail-head">제 2조. 총연봉 구성항목:</div>
								<div class="detail-content">
								<table class="salary" border="1">
								<tr>
								<td colspan="4">월 구성내역</td>
								<td colspan="2">총연봉<br>(월합계x12기준)</td>
								</tr>
								<tr>
								<td>기본급</td>
								<td>식대</td>
								<td>기타수당</td>
								<td>월합계</td>
								<td class="sannualsal" colspan="2" rowspan="2"></td>
								</tr>
								<tr>
								<td class="sbasesal"></td>
								<td class="seat"></td>
								<td class="sbonus"></td>
								<td class="ssalary"></td>
								</tr>
								</table>
								</div>
						<div class="detail-head">제 3조. ﻿퇴직금</div>
						<div class="detail-content">
								① ﻿“A”는 계속근로기간 1년 이상인 자에 대하여 근로기준법 및 근로자퇴직급여 보장법이 정한바에 따라 퇴직금을 지급한다.
						</div>
						<div class="detail-head">제 4조. ﻿﻿임금 외 기타금품</div>
						<div class="detail-content">
								① ﻿﻿“A”는 경영성과 및 목표대비 달성도 등과 “B”의 직책수준 및 업무성과 등을 종합적으로 평가하여, “B”에게<br>
								별도의 성과급을 지급할 수 있으며, 구체적인 성과급의 산정 및 지급방법 등에 대하여는 “A”가 별도로 정한 기준에 따른다.<br>
								② 상기 금품은 일시적, 은혜적인 금품으로서, 공히 통상 및 평균임금 산정에서 제외되며 연봉 조정 시 기준금액에서 제외된다.
						</div>
						<div class="detail-head">제 5조. 비밀유지</div>
						<div class="detail-content">
								﻿“B”는 연봉과 관련한 사항에 대하여 타인에게 공개하거나 타인의 연봉관련 사항을 취득하려 하지 말아야 하며 타인의 연봉관련 사항의 공개를 요구하여서는 아니된다. 이를 위반 시 “B”는 어떠한 불이익도 감수한다.
						</div>
						<div class="detail-head">제 6조. 기타</div>
						<div class="detail-content">
							﻿① “A”와 “B”는 본 계약에서 정하지 않은 사항은 근로기준법 등 관련 법령, ‘A’의 취업규칙 및 제반 규정에 따른다.<br>
							② “B”는 상기 사항에 충분하게 숙지하고 계약사항에 대하여 동의하여 연봉계약을 체결하였으며 “A”와 “B”는<br>
							계약사항을 원칙하에 준수할 것을 서약한다.<br>
							③ 입사 이후 회사의 허가없이 다른 직무를 겸하거나 영리사업에 종사하지 않는다.<br>
							④ “A”는 근로계약을 체결함과 동시에 본 계약서를 사본하여 “근로자”의 교부요구와 관계없이 “B”에게 교부한다.						
						</div>
						
						
						<div class="detail-head">제 7조. 동의여부</div>
						<div class="detail-head2">
							<label>
		            		<input type="radio" value="1" name="agree" checked class="agree">
		            		<span>동의</span>
		            		</label>
		            		<label>
           				 	<input type="radio" value="0" name="agree" class="disagree">
		            		<span>비동의</span>
		            		</label>
		            	<div class="detail-content">
		            	<div class="company">
							(A)		주 소 : 서울시 강남구 테헤란로 7길 7<br>			
									회 사 명 : (주)지식소프트<br>
									대 표 자 : 윤 승 현	 
		            	</div>
		            	<div class="employee">
		            		(B)		주 소 : <span class="eaddr"></span><br>
									주민등록번호 : <span class="errn"></span><br>
									성 명 : <span class="name"></span>
		            	</div>
						</div>
						<div id="cno"></div>
						<div id="cstrdate"></div>
						<div id="cenddate"></div>
						<div id="submit"></div>
						</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</article>
	<!-- modal -->
   <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
   <script src="js/scripts.js"></script>
   <script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
</body>
</html>
