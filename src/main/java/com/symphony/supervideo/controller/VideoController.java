package com.symphony.supervideo.controller;

import com.symphony.supervideo.domain.UserInfo;
import com.symphony.supervideo.domain.VideoInfo;
import com.symphony.supervideo.service.VideoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
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
     * 返回管理员主界面
     * @ author zz
     */
    @GetMapping(value = "/adminMain")
    public String adminMain(){
        return "api/adminMain";

    }
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
        List<VideoInfo> list = videoService.queryAllVideos();
        for (VideoInfo video:list) {
            if(video.getVideoName().equals(videoName)){
                String info = null;
                if(video.getVideoComment() == null || video.getVideoComment().equals("")){
                    info="";
                }else{
                    info=video.getVideoComment();
                }
                StringBuilder sb = new StringBuilder(info);
                sb.append(userInfo.getUserName() + "留言：" + comment + ";");
                  video.setVideoComment(sb.toString());
                videoService.iVideoRepository.save(video);
                return "redirect:index";
            }
        }
        return "redirect:index";
    }

    /**
     * 增加视频点击量，找到网址做响应重定向
     * @ author zz
     */
    @GetMapping(value = "/updateVideoSum")
    public String updateVideoSum(String vName){
        List<VideoInfo> list = videoService.queryAllVideos();
        for (VideoInfo video:list) {
            if(video.getVideoName().equals(vName)){
                int sum = video.getVideoSum() + 1;
                video.setVideoSum(sum);
                videoService.iVideoRepository.save(video);
                return "redirect:" + video.getVideoURL();
            }
        }
        return "api/error";
    }

    /**
     * 查看所有上架的视频
     * @ author zz
     */
    @GetMapping(value = "/queryAllVideos")
    public String queryAllVideos(Model model){
        List<VideoInfo> listInit = new ArrayList<VideoInfo>();
        listInit = videoService.queryAllVideos();
        List<VideoInfo> list = new ArrayList<VideoInfo>();
        for (VideoInfo video:listInit) {
            if(video.getVideoURL() != null && !video.getVideoURL().equals("")){
                list.add(video);
            }
        }
        model.addAttribute("list",list);
        return "api/queryAllVideos";
    }

    /**
     * 根据名称删除视频
     * @ author zz
     */
    @GetMapping(value = "/deleteVideoByName")
    public String deleteVideoByName(String videoName){
        videoService.deleteVideo(videoName);
        return "redirect:queryAllVideos";
    }

}
