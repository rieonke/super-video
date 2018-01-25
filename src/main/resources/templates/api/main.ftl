<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8"/>
    <title>Title</title>
    <link th:href="@{css/main.css}" rel="stylesheet" />
    <link th:href="@{css/bootstrap.css}" rel="stylesheet" />
    <link th:href="@{css/bootstrap-theme.css}" rel="stylesheet" />
    <script src="js/jquery.js"></script>
    <script src="/js/jquery-1.11.2.min.js"></script>
    <script src="/js/vue.min.js"></script>
    <script>
        $(function () {
            $('#sum').click(function () {
                location.href='updateVideoSum?vName=' + $('vName').innerText;
            })
        })

    </script>
</head>
<body>
    <h1 id="sum"  style="text-align:center;color: red;">网络视频爬虫系统主页面</h1>
    <span>您好，尊敬的</span>
    <span id="user1" th:text="${session.user}?${session.user.userName}:null">${session.user.userName}</span>
    <div id="ws" style="position: fixed;margin-left: 1000px;margin-top: 0px;border: 1px solid blue;">
        <span> 用户实时讨论窗口</span><br/>
        <input id="text" type="text"/><br/>
        <button id="send" onclick="sendMsg();">发送</button>
        <button onclick="closeWS()" :disabled="!opened">下线</button>
        <button onclick="openWS()"  :disabled="opened">上线</button>
        <div v-html="msg"></div>
    </div>


    <br/>管理员登录<br/>
    <form action="/adminLogin" method="post">
        <span>管理员账号</span><input type="text" name="adminName" /><br/>
        <span>管理员密码</span><input type="password" name="adminPass" /><br/>
        <input type="submit" value="登录" />
    </form>

    <br/>用户登录<br/>
    <form action="/userLogin" method="post">
        <span>用户账号</span><input type="text" name="userName" /><br/>
        <span>用户密码</span><input type="password" name="userPass" /><br/>
        <input type="submit" value="登录" />
    </form>
    <button onclick="location.href='userRegisterMain';">注册</button>

    <div class="container">
        <table class="table-bordered">
            <tr style="height: 50px;line-height: 50px;color:red;">
                <td>视频名称</td><td>更新时间</td><td>点击量</td><td>图片</td><td>评论</td><td>留言</td>
            </tr>
            <tr th:each="li:${list}">
                <td><a th:href="'updateVideoSum?vName=' + ${li.videoName}" >
                    <span id="vName" th:text="${li.videoName}">${li.videoName}</span></a></td>
                <td><span th:text="${li.videoTime}"></span></td>
                <td><span th:text="${li.videoSum}"></span></td>
                <td><img th:src="${li.videoMsg}" /></td>
                <td><span th:text="${li.videoComment}"></span></td>
                <td><form action="getVideoComment" method="post">
                    <input type="hidden" name="videoName" th:value="${li.videoName}"/>
                    <input type="text" name="comment"/>
                    <input type="submit" value="留言"/>
                </form></td>
            </tr>
        </table>
    </div>




    <script type="text/javascript">

        var websocket = null;

        var wsVue = new Vue({
            el: '#ws',
            data: {
                msg: "可以开始讨论了<br/>",
                opened: false
            },
            mounted: function(){
                initWs();
            }
        });

        function initWs() {
            //check if your browser supports WebSocket
            if ('WebSocket' in window) {
                websocket = new WebSocket("ws://localhost:8080/my-websocket");
            }
            else {
                alert('websocket与浏览器不一致')
            }

            //Error callback
            websocket.onerror = function () {
                setMessageContent("error!");
                wsVue.opened = false;
            };

            //socket opened callback
            websocket.onopen = function (event) {
                setMessageContent("开启讨论模式");
                wsVue.opened = true;
            }

            //message received callback
            websocket.onmessage = function (event) {
                setMessageContent(event.data);
            }

            //socket closed callback
            websocket.onclose = function () {
                setMessageContent("关闭讨论模式");
                wsVue.opened = false;
            }

            //when browser window closed, close the socket, to prevent server exception
            window.onbeforeunload = function () {
                websocket.close();
            }
        }

        //update message to vue and then in div
        function setMessageContent(content) {
            wsVue.msg += content  + '<br/>';
        }

        //click to close the websocket
        function closeWS() {
            websocket.close();
            wsVue.opened = false;
        }

        //click to open the websocket
        function openWS() {
            initWs();
        }

        //click to send message
        function sendMsg() {
            var message =document.getElementById('user1').innerHTML + '发言：' + document.getElementById('text').value;
            websocket.send(message);
            document.getElementById('text').value="";
        }
    </script>
</body>
</html>