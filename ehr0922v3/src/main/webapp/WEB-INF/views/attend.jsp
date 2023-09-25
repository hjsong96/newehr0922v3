<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출결 등록 관리</title>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.9.0/main.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.9.0/main.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.9.0/locales/ko.js'></script>
<script src="./js/jquery-3.7.0.min.js"></script>
<script src='js/index.global.min.js'></script>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/attend.css">
<%@ include file="sidebar.jsp" %>
<%@ include file="nav.jsp" %>
<link rel="stylesheet" type="text/css" href="./assets/libs/select2/dist/css/select2.min.css">
<link rel="stylesheet" type="text/css" href="./assets/libs/jquery-minicolors/jquery.minicolors.css">
<link rel="stylesheet" type="text/css" href="./assets/libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<link rel="stylesheet" type="text/css" href="./assets/libs/quill/dist/quill.snow.css">
</head>
<body>
<div class="area">
	<h2 id="HH">출결 관리</h2>
	<input id="search-atregdate" type="month" name="atregdate">
	<form action="./attendCalList" method="get">
		<button id="search" type="submit" style="width:100px;">조 회</button>
	</form>
	<div class="atList2">
    	<div id="calendar"></div>
    </div>
</div>
<script>
// 날짜별 출근 및 퇴근 정보를 저장할 객체
var attendanceData = {};
var attendance = {}; // 초기화
var attendance2 = {}; // 초기화


document.addEventListener('DOMContentLoaded', function() {	
	var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
    	headerToolbar: {
  	      left: 'prev,next today',
  	      center: 'title',
  	      right: 'dayGridMonth,timeGridWeek,timeGridDay'
  	    },
  	    events: [
  	    	<c:forEach items="${list}" var="l">
  	    	{ 	
  	    		title: "출근 : ${fn:substring(l.atmgstr,0,5)}",
  	    		start: "${l.atmgdate}T${l.atmgstr}"
  	    	},
  	    	{ 
  	    		title: "퇴근 : ${fn:substring(l.atmgend,0,5)}",
  	    		start: "${l.atmgdate}T${l.atmgend}"
  	    	},
  	    	</c:forEach>
  	    ],
        dateClick : function(info) {
            // 선택한 날짜의 출근 정보 가져오기
            var today = new Date();
            var selectedDate = info.dateStr;
			attendance = attendanceData[selectedDate];
			attendance2 = attendanceData[selectedDate];

        	if (attendance === undefined || attendance2 === undefined) {
        		<c:if test="${nowResult.atmgdate ne null}">
        			attendance = '${nowResult.atmgdate}T${nowResult.atmgstr}.000Z';
        			attendance2 = '${nowResult.atmgdate}T${nowResult.atmgend}.000Z';
        		</c:if>
        	}
            
            // 클릭한 날짜가 오늘이면 모달 창 열기
            if (selectedDate === today.toISOString().split("T")[0]) {
				
	            var modal = $('#myModal');
	            modal.modal('show'); // 모달 창 열기

	         	// 모달 내용 설정
                var modalContent = $('.modal-content');
                var detailName = modalContent.find('.detail-name');
                var detailDate = modalContent.find('.detail-date');
                var detailDate2 = modalContent.find('.detail-date2');
                var btnIn = modalContent.find('.btnIn');
                var btnOut = modalContent.find('.btnOut');
	            
             	// 모달에 날짜 업데이트
                function updateModalDate(date) {
                    detailName.text('근무 날짜: ' + date);
                    
                    if (attendance != undefined) {
                        detailDate.text('출근 시간 : ' + attendance.substring(11, 16));
                        btnIn.hide(); // 출근 버튼 숨김
                    }

                    if (attendance2 != undefined) {
                    	if (attendance2.split("T")[1] == ".000Z") {
                    		
                    		$(document).on('click', '.btnOut', function() {});
                    		
                    	} else {
	                    	detailDate2.text('퇴근 시간 : ' + attendance2.substring(11, 16));
    	                	btnOut.hide();
                    	}
                    }
             	}
				
	            updateModalDate(selectedDate);
	
	            // ISO-08601로 변환된 현재 시간 함수
	            function getCurrentTimeInISO8601() {
	           	  const now = new Date();
	           	  return now.toISOString();
	            }
	            
	            function getCurrentTime2InISO8601() {
	           	  const now2 = new Date();
	           	  return now2.toISOString();
		        }
	            
	            
	            var currentTime = getCurrentTimeInISO8601();
	            var currentTime2 = getCurrentTime2InISO8601();
	            
	            
	            // 출근 버튼 클릭 이벤트
	            var btnIn = modalContent.find('.btnIn');
	            btnIn.off('click'); // 이전 이벤트 핸들러 제거
	            if (attendance != undefined) {
	                btnIn.hide(); // 이미 출근 처리된 경우 출근 버튼 숨김
	            } else {
		            /* btnIn.show(); // 출근 버튼 보이기 */
		            btnIn.on('click', function() {
		            	
		            	var btn = 0;
		                var atmgsts = 0;
		                // 현재 시간 표시
		                
		                if (attendance === undefined) {
			                console.log("출근 정보 없음");
			            } else {
			                // attendance가 정의된 경우 시간 정보 파싱
			                var currentHour = parseInt(attendance.substring(11, 13));
			                var currentMinute = parseInt(attendance.substring(14, 16));
			                var currentHour2 = parseInt(attendance2.substring(11, 13));
							var currentMinute2 = parseInt(attendance2.substring(14, 16));
			            }
		                
		                if (currentHour <= 9 && (currentHour2 > 18 || (currentHour2 === 18 && currentMinute2 === 0))) {
		                    atmgsts = 0; // 정상 출근
		                } else if (currentHour > 9 || (currentHour === 9 && currentMinute > 0)) {
		                    atmgsts = 1; // 지각
		                } else if (currentHour <= 9 || (currentHour < 18 && currentMinute > 0)) {
		                    atmgsts = 2; // 조퇴
		                } else {
		                    atmgsts = 3; // 결근
		                }
		                
		                var serverDate = new Date(getCurrentTimeInISO8601());
		                
		                detailDate.text('출근 시간: ' + serverDate.toString().substring(16, 21));
		                btnIn.hide();
		                
		                calendar.addEvent({
		                	groupId: 'testGroupId',
		                	title: "${ename}",
		                	start: currentTime
		          	    });
		                
		            	$.ajax({
		    				url : "./attendIn",
		    				type : "post",
		    				data : {
		    					"btnIn" : btn,
		    					"atmgsts" : atmgsts				
		    				},
		    				dataType : "json",
		    				success : function(data) {
		    					if (data.result == 1) {
		    						alert("출근이 완료되었습니다.");
		    					} else {
		    						alert("출근 실패");
		    					}
		    				},
		    				error : function(request, status, error) {
								alert("에러 발생");
		    				}
		            	}); 
		            });
	            	
	            }
            
            
	         	// 퇴근 버튼 클릭 이벤트
	            var btnOut = modalContent.find('.btnOut');
	         	btnOut.off('click'); // 이전 이벤트 핸들러 제거
	            if (attendance2 != undefined && attendance2.split("T")[1] != ".000Z") {
	                btnIn.hide(); // 이미 출근 처리된 경우 출근 버튼 숨김
	            } else {
	                btnOut.on('click', function() {
	                		                    
	                	var serverDate2 = new Date(getCurrentTime2InISO8601());

	                    detailDate2.text('퇴근 시간: ' + serverDate2.toString().substring(16, 21));
	                    btnOut.hide();
	                	
	                    calendar.addEvent({
	                    	groupId: 'testGroupId',
	                   		title: "${ename}",
	                       	start: currentTime2	
	              	    });
	                    
	                    var btn2 = 0;
	                    var atmgsts = 0;
	                    
	                    $.ajax({
	                        url : "./attendOut",
	                        type : "post",
	                        data : {
	                            "btnOut" : btn2,
	                            "atmgsts" : atmgsts
	                        },
	                        dataType : "json",
	                        success : function(data) {
	                            if (data.result2 == 1) {
	                                alert("퇴근이 완료되었습니다.");
	                            } else {
	                                alert("퇴근 실패");
	                            }
	                        },
	                        error : function(request, status, error) {
	                            alert("에러 발생");
	                        }
	                    }); 
	                
	                });
	            }
	         	
            } else {
            	alert('오늘이 아닌 날짜입니다.');            	
            }
 
            // 모달 닫기 버튼
            var closeBtn = $('.btn-close');
            closeBtn.on('click', function () {
                modal.modal('hide'); // 모달 창 닫기
            });
			
        }
    });
    
    calendar.render();
    
});
</script>

<!-- Modal -->
<div class="modal" id="myModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <!-- 모달 내용 -->
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="header">
                <h5 class="title" id="exampleModalLabel"></h5>
            </div>
            <div class="modal-body">
                <div class="detail-detail">
                    <div class="detail-name"></div>
                    <div class="detail-date-read">
                        <div class="detail-date"></div>
                        <div class="detail-date2"></div>
                        <div class="detail-in-time"></div>
                        <div class="detail-out-time"></div>
                    </div>
                    <br>
                    <div style="text-align: center;">
                        <button type="button" class="btnIn">출근</button>
                        <button type="button" class="btnOut">퇴근</button>
                    </div>
                </div>
            </div>
            <div style="text-align: center;">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">닫기</button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/scripts.js"></script>
<script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
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
</body>
</html>
