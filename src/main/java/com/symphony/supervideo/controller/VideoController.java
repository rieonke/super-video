package com.symphony.supervideo.controller;

import com.symphony.supervideo.domain.UserInfo;
import com.symphony.supervideo.domain.VideoInfo;
import com.symphony.supervideo.service.VideoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * @author zz.
 * @2018/1/18 17:04.
 * 视频资源控制层
 */
@Controller
public class VideoController {

    @Autowired
    private VideoService videoService;
    /**
     * 登录管理员主界面
     * @ author zz
     */
    @PostMapping(value = "/adminLogin")
    public String adminLogin(String adminName, String adminPass, HttpSession session){
        if(adminName.equals("admin") && adminPass.equals("123")){
            session.setAttribute("ad",adminName);
            return "api/adminMain";
        }else{
            return "redirect:index";
        }

    }
    /**
     * 输入完爬虫目标网站后，返回管理员主界面
     * @ author zz
     */
    @GetMapping(value = "/catchVideo")
    public String catchVideo(String url) throws IOException,Exception{
        videoService.catchVideos(url);
        return "api/adminMain";
    }

    /**
     * 用户为视频资源留言
     * @ author zz
     */
    @PostMapping(value = "/getVideoComment")
    public String userComment(String comment,String videoName,HttpSession session) throws IOException,Exception{
        UserInfo userInfo = (UserInfo)session.getAttribute("user");
        if(userInfo == null){
            return "redirect:index";
        }
        System.out.println(userInfo.getUserName() + comment);
        System.out.println(comment);
        System.out.println(videoName);
        List<VideoInfo> list = videoService.queryAllVideos();
        for (VideoInfo video:list) {
            if(video.getVideoName().equals(videoName)){
                video.setVideoComment(userInfo.getUserName() + "留言：" + comment);
                videoService.iVideoRepository.save(video);
                return "redirect:index";
            }
        }
        return "redirect:index";
    }
}
