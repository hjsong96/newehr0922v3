<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보</title>
<script src="./js/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" href="../css/mypage.css">
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
				<form action="./join" method="post" enctype="multipart/form-data">
				<div class="form topline">
					<table>
						<tr>
							<td><img src="./upload/${list.eimg}" width="100px" height="100px"></td>
						</tr>
						<tr>
							<th class="id">이름</th>
							<td>${list.ename}</td>
							<th class="id">사번</th>
							<td>${list.eid}</td>
							<th class="id">생년월일</th>
							<td>${ebirth}</td>
						</tr>
						<tr>
							<th class="id">나이</th>
							<td>${age}</td>
							<th class="id">전화번호</th>
							<td>${list.ephoneno}</td>
							<th class="id">입사일</th>
							<td>${ehiredate}</td>
						</tr>
						<tr>
							<th class="id">근무부서</th>
							<td>${list.edept}</td>
							<th class="id">직급</th>
							<td>${egrade}</td>
						</tr>
						<tr>
							<th class="id">주소</th>
							<td>${list.eaddr}</td>
							<th class="id">상세주소</th>
							<td>${list.eaddr2}</td>
						</tr>
					</table>
				</div>
				<div class="form_button">
					<button type="button" onclick="location.href='./main'">메인으로</button>
					<button type="button" onclick="location.href='./mypageupdate'">정보수정</button>
					<button class="changePW">비밀번호 변경</button>
				</div>
			</form>
		</div>
	</div>
</article>
<script type="text/javascript">
$(function(){
	$(".changePW").click(function(){
		var popupX = (window.screen.width / 2) - (400 / 2);
		var popupY= (window.screen.height / 2) - (250 / 2);
		 window.open('./changePW', '비밀번호변경',"width=400px, height = 250px left= "+popupX+" top="+popupY+" scrollbars=yes");
		return false;
	})
});
</script>
</body>

</html>