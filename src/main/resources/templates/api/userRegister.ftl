<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Title</title>
    <link th:href="@{css/bootstrap.css}" rel="stylesheet" />
    <link th:href="@{css/bootstrap-theme.css}" rel="stylesheet" />
    <script src="js/jquery.js"></script>
    <script src="/js/jquery-1.11.2.min.js"></script>
    <script src="/js/vue.min.js"></script>
    <script>
        $(function () {
            $('#user1').blur(function () {
                $.ajax({
                    type:"get",url:"tryUserName",data:{userName:$('#user1').val()},
                    dataType:"json",
                    success:function(data){
                        alert(data.result);
                    },
                    error: function() {
                        alert("error");
                    }
                })
            })
        })
    </script>
</head>
<body>
<h1 style="text-align: center;color:#8e4cc7;">用户注册页面</h1>
<button onclick="location.href='index'">返回主页面</button>
<div class="container">
    <form action="userRegister" method="post">
        <span>用户账号：</span>
        <input id="user1" type="text" name="userName" placeholder="用户名为6~12位字母数字组成" pattern="[A-Za-z0-9]{6,12}"/><br/>
        <span>用户密码：</span>
        <input type="password" name="userPass" placeholder="用户名为6~12位字母数字组成" pattern="[A-Za-z0-9]{6,12}"/><br/>
        <span>身份证号：</span>
        <input type="text" name="userNum" pattern="\d{17}(\d|X|x)"/><br/>
        <span>手机号码：</span>
        <input type="text" name="userTel" pattern="\d{11}" /><br/>
        <input type="hidden" name="userStatus" value="启用"/><br/>
        <input type="submit" value="注册" /><br/>
    </form>
</div>



</body>
</html>