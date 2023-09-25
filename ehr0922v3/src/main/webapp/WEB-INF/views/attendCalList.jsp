<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출결 상세 현황</title>
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/attend.css">
<%@ include file="sidebar.jsp"%>
<%@ include file="nav.jsp"%>
<style type="text/css">
table {
	width: 900px;
	height: auto;
	margin: 0 auto;
	border-collapse: collapse;
	border-radius: 10px;
}

th {
	background-color: #303F9F;
	border-bottom: 1px solid #303F9F;
	color: white;
}

td {
	border-bottom: 1px solid #303F9F;
	text-align: center;
}

tr:hover {
	background-color: #6495ED;
}

.btn {
	text-align: center;
	padding: 20px;
}

.btn-secondary {
	width: 75px;
	border: 0;
	background-color: #303F9F;
	border-radius: 7px;
	color: white;
	font-weight: bold;
	font-family: 'Noto Sans KR', sans-serif;
	height: 40px;
}

.txt {
	text-align: center;
	font-weight: bold;
	padding: 20px;
}
</style>
</head>
<body>
	<div class="area">
		<h2 id="HH">출결 관리</h2>
		<div class="atList2">
			<div class="txt">
				<c:if test="${not empty calList}">
			    ${fn:substring(calList[0].atmgdate, 0, 7)}
			</c:if>
			</div>
			<table border="1" class="">
				<thead>
					<tr class="row">
						<th class="col-1">이름</th>
						<th class="col-6">출근일</th>
						<th class="col-2">출근</th>
						<th class="col-2">퇴근</th>
						<th class="col-1">출결상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${calList }" var="row">
						<tr class="">
							<td class="col-1">${row.ename}</td>
							<td class="col-6">${row.atmgdate}</td>
							<td class="col-2">${fn:substring(row.atmgstr,0,5)}</td>
							<td class="col-2">${fn:substring(row.atmgend,0,5)}</td>
							<c:choose>
								<c:when test="${row.atmgsts eq 0}">
									<td class="col-1">정상 출근</td>
								</c:when>

								<c:when test="${row.atmgsts eq 1}">
									<td class="col-1">지각</td>
								</c:when>

								<c:when test="${row.atmgsts eq 2}">
									<td class="col-1">조퇴</td>
								</c:when>

								<c:when test="${row.atmgsts eq 3}">
									<td class="col-1">결근</td>
								</c:when>
								<c:otherwise>
									<div>휴가</div>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="btn">
				<button type="button" class="btn-secondary"
					onclick="location.href='./attend'">돌아가기</button>
			</div>
		</div>
	</div>
</body>
</html>