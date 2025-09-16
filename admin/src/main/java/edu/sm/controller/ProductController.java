package edu.sm.controller;

import edu.sm.app.service.CustService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {

    final CustService custService;
    final BCryptPasswordEncoder bCryptPasswordEncoder;
    final StandardPBEStringEncryptor standardPBEStringEncryptor;

    String dir="product/";

    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center",dir+"add");
        return "index";
    }

    @RequestMapping("/get")
    public String get(Model model) {
        model.addAttribute("center",dir+"get");
        return "index";
    }

}