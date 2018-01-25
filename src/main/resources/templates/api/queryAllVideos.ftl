<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Title</title>
    <link th:href="@{css/main.css}" rel="stylesheet" />
    <link th:href="@{css/bootstrap.css}" rel="stylesheet" />
    <link th:href="@{css/bootstrap-theme.css}" rel="stylesheet" />
    <style>
        table td{
            text-align: center;
        }
    </style>
</head>
<body>
<h1 style="text-align: center;color:darkorange;">视频管理界面</h1>
<button onclick="location.href='adminMain'">返回管理员主页面</button>


<div class="container">
    <table class="table-bordered">
        <tr style="height: 50px;line-height: 50px;color:red;">
            <td>视频名称</td><td>更新时间</td><td>点击量</td><td>评论</td><td>删除</td>
        </tr>
        <tr th:each="li:${list}">
            <td><a th:href="'updateVideoSum?vName=' + ${li.videoName}" >
                <span id="vName" th:text="${li.videoName}">${li.videoName}</span></a></td>
            <td><span th:text="${li.videoTime}"></span></td>
            <td><span th:text="${li.videoSum}"></span></td>
            <td><span th:text="${li.videoComment}"></span></td>
            <td>
                <form action="deleteVideoByName" method="get">
                    <input type="hidden" name="videoName" th:value="${li.videoName}"/>
                    <input type="submit" onclick="if(!confirm('是否确认删除该视频？')){return false;}" value="删除"/>
                </form>
            </td>
        </tr>
    </table>
</div>
</body>
</html>