<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Title</title>
    <link th:href="@{css/bootstrap.css}" rel="stylesheet" />
    <link th:href="@{css/bootstrap-theme.css}" rel="stylesheet" />
    <style>
        table td{
            text-align: center;
        }
    </style>
</head>
<body>
<h1 style="text-align: center;color:darkorange;">用户管理界面</h1>
<button onclick="location.href='adminMain'">返回管理员主页面</button>


<div class="container">
    <table class="table-bordered">
        <tr style="height: 50px;line-height: 50px;color:#8fff66;">
            <td>用户ID</td><td>用户名称</td><td>用户密码</td><td>用户身份证号码</td>
            <td>用户手机号</td><td>用户状态</td><td>是否禁用</td><td>注销用户</td>
        </tr>
        <tr th:each="li:${list}">
            <td><span th:text="${li.userId}"></span></td>
            <td><span th:text="${li.userName}"></span></td>
            <td><span th:text="${li.userPass}"></span></td>
            <td><span th:text="${li.userNum}"></span></td>
            <td><span th:text="${li.userTel}"></span></td>
            <td><span th:text="${li.userStatus}"></span></td>
            <td>
                <form action="updateUserStatus" method="get">
                    <input type="hidden" name="userId" th:value="${li.userId}"/>
                    <input type="radio" name="userStatus" checked="checked" th:value="启用"/>启用
                    <input type="radio" name="userStatus" th:value="禁用"/>禁用
                    <input type="submit" value="确认"/>
                </form>
            </td>
            <td>
                <form action="deleteUserByName" method="get">
                    <input type="hidden" name="userId" th:value="${li.userId}"/>
                    <input type="submit" onclick="if(!confirm('是否确认删除该用户？')){return false;}" value="删除"/>
                </form>
            </td>
        </tr>
    </table>
</div>
</body>
</html>