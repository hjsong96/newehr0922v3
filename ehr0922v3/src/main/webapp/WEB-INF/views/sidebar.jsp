<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <link rel="stylesheet" href="./css/style.css">
     <link rel="stylesheet"href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    <script defer src="./js/app.js"></script>
	<aside id="sidebar">
            <ul class="sidebar__menu">
                <li id="menu1">
                    <a href="./main"><i class=" xi-home-o xi-2x"></i><br>홈으로</a>  
                </li>

                <li id="menu2">
				    <c:if test="${sessionScope.egrade eq 8}">
				       <a href="#"><i class="xi-profile-o xi-2x"></i><br>인사관리</a>
				        <ul>
				            <li><a href="./join">사원등록</a></li>
				            <li><a href="./memberlist">전체 사원 목록</a></li>
				        </ul>
				    </c:if>
				</li>
                <li id="menu3">
                    <a href="#"><i class="xi-money xi-2x"></i><br>급여관리</a>
                    <ul>
                        <li><a href="./salary?eno=${sessionScope.eno}">개인월급여내역</a></li>
                        <li><a href="./contract?eno=${sessionScope.eno}">연봉계약서</a></li>
                        <li><a href="./salary2?eno=${sessionScope.eno}">급여목록<br>(관리자)</a></li>
                        <li><a href="./contract2?eno=${sessionScope.eno}">연봉동의목록<br>(관리자)</a></li>
                    </ul>
                </li>
                <li id="menu4">
                   <a href="#"><i class="xi-calendar-check xi-2x"></i><br>근태관리</a>
                    <ul>
                        <li><a href="./attend">출결관리</a></li>
                        <li><a href="./attendRegister">근태관리</a></li>
                        <c:if test="${sessionScope.egrade eq 8}"><li><a href="./attendAdmin">근태관리<br>(관리자)</a></li></c:if>
                    </ul>
                </li>
                <li id="menu5">
                    <a href="#"><i class="xi-file-check xi-2x"></i><br>결재관리</a>
                    <ul>
                        <li><a href="./approval">결재요청</a></li>
                        <li><a href="./approvalBoard">결재현황</a></li>
                        <li><a href="./doApproval">결재하기</a></li>
                    </ul>
                </li>
                <li id="menu6">
                    <a href="#"><i class="xi-form xi-2x"></i><br>게시판</a>
                    <ul id="menu6">
                        <li><a href="./notice">공지사항</a></li>
                        <li><a href="./annonyboard">익명게시판</a></li>
                    <c:if test="${sessionScope.egrade eq 8}">
                    	<li><a href="./checkBoard">신고게시판<br>(관리자)</a></li>
                     </c:if>
                    </ul>
                
                <li id="menu7">
                    <a href="#" id="menu6" class="logout">
                    <i class="xi-unlock xi-2x"></i><br>로그아웃</a>
                </li>
            </ul>

        </aside>

