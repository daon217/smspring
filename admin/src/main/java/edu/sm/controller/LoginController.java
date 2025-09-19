package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
public class LoginController {

    @RequestMapping("/loginimpl")
    public String loginimpl(Model model, @RequestParam("id") String adminId,
                            @RequestParam("pwd") String adminPwd) {

        model.addAttribute("center","chart");
        return "index";
    }

}