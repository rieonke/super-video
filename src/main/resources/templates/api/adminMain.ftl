<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8"/>
    <title>Title</title>
</head>
<body>

<h1 style="text-align: center;color:dodgerblue;">管理员主页面</h1>
<form method="get" action="catchVideo">
    <span>请输入爬虫目标网站</span><input type="text" name="url"/>
    <input type="submit"  value="确认"/>
</form>
<br/><a href="/queryAllUsers">查询所有用户</a>
<br/><a href="/queryAllVideos">查询所有视频</a>
<br/><a href="/index">返回主页面</a>
</body>
</html>