package com.symphony.supervideo.controller;

import com.symphony.supervideo.domain.UserInfo;
import com.symphony.supervideo.domain.VideoInfo;
import com.symphony.supervideo.service.UserService;
import com.symphony.supervideo.service.VideoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author zz.
 * @2018/1/17 14:39.
 * 用户信息控制层
 */

@Controller
public class UserController {
    @Autowired
    public UserService userService;
    @Autowired
    public VideoService videoService;
    /**
     * 登录主页控制器
     * @zz
     */
    @GetMapping(value = "/index")
    public String index(Model model){
        List<VideoInfo> listInit = new ArrayList<VideoInfo>();
        listInit = videoService.queryAllVideos();
        List<VideoInfo> list = new ArrayList<VideoInfo>();
        for (VideoInfo video:listInit) {
            if(video.getVideoURL() != null && !video.getVideoURL().equals("")){
                list.add(video);
            }
        }
        model.addAttribute("list",list);
        return "api/main";
    }
    /**
     * 查询所有用户控制器
     * @zz
     * @return list<UserInfo>
     */
    @RequestMapping (value = "/queryAllUsers",method = RequestMethod.GET)
    public String queryAllUsers(Model model){
        List<UserInfo> list = new ArrayList<UserInfo>();
        list = userService.queryAllUsers();
        model.addAttribute("list",list);
        return "api/queryAllUser";
    }
    /**
     * 启用禁用用户
     * @zz
     */
    @RequestMapping (value = "/updateUserStatus",method = RequestMethod.GET)
    public String updateUserStatus(int userId,String userStatus){
        List<UserInfo> list = userService.queryAllUsers();
        for (UserInfo user:list) {
            if(user.getUserId() == userId){
                user.setUserStatus(userStatus);
                userService.iUserRepository.save(user);
                return "redirect:queryAllUsers";
            }
        }
        return "api/error";
    }
    /**
     * 用户登录
     * @zz
     */
    @RequestMapping (value = "/userLogin",method = RequestMethod.POST)
    public String userLogin(HttpServletRequest request,HttpSession session, String userName, String userPass){
        List<UserInfo> list = new ArrayList<UserInfo>();
        list = userService.queryAllUsers();
        for (UserInfo user:list) {
            if(user.getUserName().equals(userName)
                    && user.getUserPass().equals(userPass)
                    && user.getUserStatus().equals("启用")){
                session.setAttribute("user",user);
                return "redirect:index";
            }
        }
        return "redirect:index";
    }
    /**
     * 注销用户操作
     * @zz
     */
    @RequestMapping (value = "/deleteUserByName",method = RequestMethod.GET)
    public String deleteUserByName(int userId){
        userService.deleteUserById(userId);
        return "redirect:queryAllUsers";
    }

    /**
     * 跳转至用户注册界面
     * @ygh
     */
    @GetMapping(value = "/userRegisterMain")
    public String userRegisterMain(){
        return "api/userRegister";
    }

    /**
     * 将用户存储至数据库
     * @ygh
     */
    @PostMapping(value = "/userRegister")
    public String userRegister(UserInfo userInfo){
        userService.saveUser(userInfo);
        return "redirect:index";
    }

    /**
     * 验证用户名是否可用
     * @ygh
     */
    @GetMapping(value = "/tryUserName")
    @ResponseBody
    public Map<String,String> tryUserName(String userName){
        Map<String,String> map = new HashMap<String, String>();
        if(userService.tryUserName(userName)){
            map.put("result","抱歉，该账号已被注册！");
        }else {
            map.put("result","恭喜，该账号可以使用！");
        }
        return map;

    }

}
