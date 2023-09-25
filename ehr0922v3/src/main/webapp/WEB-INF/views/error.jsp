<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error!!!</title>
<!-- Custom CSS -->
<link href="dist/css/style.min.css" rel="stylesheet">
<script src="./js/jquery-3.7.0.min.js"></script>
</head>
<body>
	<div class="main-wrapper">
        <div class="preloader">
            <div class="lds-ripple">
                <div class="lds-pos"></div>
                <div class="lds-pos"></div>
            </div>
        </div>
        <div class="error-box">
            <div class="error-body text-center">
                <h1 class="error-title text-danger">Error</h1>
                <h3 class="text-uppercase error-subtitle">잘못된 접근입니다</h3>
                <p class="text-muted m-t-30 m-b-30">로그인 후 이용 가능한 페이지입니다</p>
                <a href="./" class="btn btn-danger btn-rounded waves-effect waves-light m-b-40">Back to login</a> </div>
        </div>
    </div>

<!-- All Required js -->
<!-- ============================================================== -->
<script src="assets/libs/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap tether Core JavaScript -->
<script src="assets/libs/popper.js/dist/umd/popper.min.js"></script>
<script src="assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- ============================================================== -->
<!-- This page plugin js -->
<!-- ============================================================== -->
<script>
$('[data-toggle="tooltip"]').tooltip();
$(".preloader").fadeOut();
</script>
</body>
</html>