<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Salary</title>
<link href="./css/salary.css" rel="stylesheet" />
<link href="./css/style.css" rel="stylesheet" />
<script src="./js/jquery-3.7.0.min.js"></script>
<script type="text/javascript">
/* 	window.onload = function() {
		today = new Date();
		today = today.toISOString().slice(0, 7);
		bir = document.getElementById("sdate");
		bir.value = today;
	} */

	$(function() {
		$(".search").click(function() {
					let eno = $(".eno").val();
					let sdate = $("input[name='sdate']").val();

					$.ajax({
						url : "./searchSal",
						type : "post",
						data : {
							"eno" : eno,
							"sdate" : sdate
						},
						dataType : "json",
						success : function(data) {
							if (data.slist.sdate == null) {
								alert("급여가 지급되지 않았습니다. 다시 조회해주세요.");
								$("input[name='sdate']").val('');
								$(".changeSal").text('');
								$(".sbasesal").text('');
								$(".seat").text('');
								$(".ssalary").text('');
								$(".snation").text('');
								$(".shealth").text('');
								$(".scare").text('');
								$(".shire").text('');
								$(".stake").text('');
								$(".ssalary").text('');
								$(".stake").text('');
								$(".sreal").text('');
								return false;
							}
							function formatNumber(number) {
								return number.toString().replace(
										/\B(?=(\d{3})+(?!\d))/g, ",");
							}
							
							$(".changeSal").text(sdate);

							$(".sbasesal").text(
									formatNumber(data.slist.sbasesal) + '원');
							$(".seat")
									.text(formatNumber(data.slist.seat) + '원');
							$(".ssalary").text(
									formatNumber(data.slist.ssalary) + '원');
							$(".snation").text(
									formatNumber(data.slist.snation) + '원');
							$(".shealth").text(
									formatNumber(data.slist.shealth) + '원');
							$(".scare").text(
									formatNumber(data.slist.scare) + '원');
							$(".shire").text(
									formatNumber(data.slist.shire) + '원');
							$(".stake").text(
									formatNumber(data.slist.stake) + '원');
							$(".ssalary").text(
									formatNumber(data.slist.ssalary) + '원');
							$(".stake").text(
									formatNumber(data.slist.stake) + '원');
							$(".sreal").text(
									formatNumber(data.slist.sreal) + '원');
						},

						error : function(error) {
							alert("에러가 발생했습니다.");
						}
					});
				});
	});

	function printPage() {
		window.print();
	}
</script>
</head>

<body>
	<%@ include file="nav.jsp"%>
	<%@ include file="sidebar.jsp"%>
	<article id="article2">
		<div class="total_area">
			<h1>개인 <span class="changeSal"></span>월 급여내역</h1>
			<div class="top_area">
				<div class="date_area">
				<form action="./salary" method="get">
					<input type="hidden" name="eno" class="eno" value="${sessionScope.eno}"> 
						<input name="sdate" id="sdate" type="month">
				</form>
				</div>
				<button class="search">조 회</button>
				<div class="btn_area">
				<button class="print" onclick="printPage()">출 력</button>
				</div>
			</div>
			<div class="middle_area">
				<div class="middle_content1">
				<table class="give">
					<tr>
						<th colspan="4">지 급</th>
					</tr>
					<tr>
						<td class="td1" colspan="2">항목</td>
						<td class="td1" colspan="2">금액</td>
					</tr>
					<tr>
						<td class="td2" colspan="2">기본급</td>
						<td class="td2 sbasesal" colspan="2"><fmt:formatNumber
								value="${slist.sbasesal}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2"  colspan="2">식대</td>
						<td class="td2 seat" colspan="2"><fmt:formatNumber
								value="${slist.seat}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td1" colspan="2">합 계</td>
						<td class="td1 ssalary" colspan="2"><fmt:formatNumber
								value="${slist.ssalary}" pattern="#,###" /></td>
					</tr>
				</table>
				</div>
				<div class="middle_content2">
				<table class="take">
					<tr>
						<th colspan="4">공 제</th>
					</tr>
					<tr>
						<td class="td1" colspan="2">항 목</td>
						<td class="td1" colspan="2">금 액</td>
					</tr>
					<tr>
						<td class="td2" colspan="2">국민연금</td>
						<td class="td2 snation" colspan="2"><fmt:formatNumber
								value="${slist.snation}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2">건강보험</td>
						<td class="td2 shealth" colspan="2"><fmt:formatNumber
								value="${slist.shealth}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2">장기요양보험</td>
						<td class="td2 scare" colspan="2"><fmt:formatNumber
								value="${slist.scare}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2">고용보험</td>
						<td class="td2 shire" colspan="2"><fmt:formatNumber
								value="${slist.shire}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td1" colspan="2">합 계</td>
						<td class="td1 stake" colspan="2"><fmt:formatNumber value="${slist.stake}"
								pattern="#,###" /></td>
					</tr>
				</table>
				</div>
				<div class="middle_content3">
				<table class="real">
					<tr>
						<th colspan="4">세금내역</th>
					</tr>
					<tr>
						<td class="td2" colspan="2">지급총액</td>
						<td class="td2 ssalary" colspan="2"><fmt:formatNumber
								value="${slist.ssalary}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2">공제총액</td>
						<td class="td2 stake" colspan="2"><fmt:formatNumber
								value="${slist.stake}" pattern="#,###" /></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td2" colspan="2"></td>
						<td class="td2" colspan="2"></td>
					</tr>
					<tr>
						<td class="td1" colspan="2">실지급액</td>
						<td class="td1 sreal" colspan="2"><fmt:formatNumber
								value="${slist.sreal}" pattern="#,###" /></td>
					</tr>
				</table>
				</div>
			</div>
		</div>
	</article>
</body>
</html>