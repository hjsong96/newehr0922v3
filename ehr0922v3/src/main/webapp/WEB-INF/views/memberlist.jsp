<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 사원 목록</title>
<link rel="stylesheet" href="./css/memberlist.css">
<script type="text/javascript">
function egradeCh(eno, ename, value){

	if(confirm(ename + "님의 등급을 변경하시겠습니까?")){
		location.href="./egradeChange?eno="+eno+"&egrade="+value;
	}	
}
function edeptCh(eno, ename, value){
	   if(confirm(ename + "님의 직급을 변경하시겠습니까?")){
	      location.href="./edeptChange?eno="+eno+"&edept="+value;
	   }
	}

</script>
</head>
<body>
	<%@ include file="nav.jsp"%>
	<%@ include file="sidebar.jsp"%>
	<article id="article">
	<div class="atList">
   <h1 class="title">전체 사원 목록</h1>
    <div class="atList2">
    <div class="atList5"></div>
    <table class="table1">
    	<tbody>
    		<tr class="tr1">
    			<th class="th1">사원번호</th>
    			<th class="th1">이름</th>
    			<th class="th1">나이</th>
    			<th class="th1" style="width:50px; min-width: 50px; max-width: 50px;">입사일</th>
    			<th class="th1" style="width:150px; min-width: 150px; max-width: 150px;">부서</th>
    			<th class="th1" style="width:350px; min-width: 350px; max-width: 350px;">주소</th>
    			<th class="th1" style="width:50px; min-width: 50px; max-width: 50px;">생년월일</th>
    			<th class="th1">등급</th>
    		</tr>
    	</tbody>
    	<tbody>
    		<c:forEach items="${list }" var="i">
    			<tr class="tr1">
    				<td class="td1">${i.eid }</td>
    				<td class="td1">${i.ename }</td>
    				<td class="td1">${i.eage }</td>
    				<td class="td1">${i.ehiredate }</td>
    				<td class="td1" style="width:150px; min-width: 150px; max-width: 150px;"><select id="edept" name="edept" onchange="edeptCh(${i.eno},'${i.ename}', this.value)">
      <optgroup label="선택하세요.">
      <option value="경영관리실" <c:if test="${i.edept eq '경영관리실'}">selected="selected"</c:if>>경영관리실</option>
      <option value="솔루션개발팀" <c:if test="${i.edept eq '솔루션개발팀'}">selected="selected"</c:if>>솔루션개발팀</option>
      <option value="ICT사업팀" <c:if test="${i.edept eq 'ICT사업팀'}">selected="selected"</c:if>>ICT사업팀</option>
      <option value="헬스케어개발팀" <c:if test="${i.edept eq '헬스케어개발팀'}">selected="selected"</c:if>>헬스케어개발팀</option>
      <option value="디자인UI-UX팀" <c:if test="${i.edept eq '디자인UI-UX팀'}">selected="selected"</c:if>>디자인UI-UX팀</option>
      <option value="마케팅팀" <c:if test="${i.edept eq '마케팅팀'}">selected="selected"</c:if>>마케팅팀</option>
      </optgroup>
   </select></td>
    				<td class="td1" style="width:350px; min-width: 350px; max-width: 350px;">${i.eaddr }</td>
    				<td class="td1">${i.ebirth }</td>
    				<td class="td1">
    				<select class="egrade" id="egrade" name="egrade" onchange="egradeCh(${i.eno},'${i.ename}', this.value)">
					<optgroup label="선택하세요.">
						<option value="0" <c:if test="${i.egrade eq 0}">selected="selected"</c:if>>사원</option>
						<option value="1" <c:if test="${i.egrade eq 1}">selected="selected"</c:if>>주임</option>
						<option value="2" <c:if test="${i.egrade eq 2}">selected="selected"</c:if>>대리</option>
						<option value="3" <c:if test="${i.egrade eq 3}">selected="selected"</c:if>>과장</option>
						<option value="4" <c:if test="${i.egrade eq 4}">selected="selected"</c:if>>차장</option>
						<option value="5" <c:if test="${i.egrade eq 5}">selected="selected"</c:if>>부장</option>
						<option value="6" <c:if test="${i.egrade eq 6}">selected="selected"</c:if>>부사장</option>
						<option value="7" <c:if test="${i.egrade eq 7}">selected="selected"</c:if>>사장</option>
						<option value="8" <c:if test="${i.egrade eq 8}">selected="selected"</c:if>>관리자</option>
					</optgroup>
					</select>
    				</td>
    			</tr>
    		</c:forEach>
    	</tbody>
    </table>
	</div>
</div>
</article>
</body>
</html>