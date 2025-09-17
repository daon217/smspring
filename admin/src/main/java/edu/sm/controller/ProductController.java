package edu.sm.controller;

import edu.sm.app.dto.Product;
import edu.sm.app.service.CustService;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.List;

@Controller
@Slf4j
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {

    final CustService custService;
    final ProductService productService; // ProductService를 주입합니다.
    final BCryptPasswordEncoder bCryptPasswordEncoder;
    final StandardPBEStringEncryptor standardPBEStringEncryptor;

    String dir="product/";

    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center",dir+"add");
        return "index";
    }

    @RequestMapping("/registerimpl")
    public String register(Product product) {
        log.info("register product: {}", product);
        try {
            productService.register(product);
        } catch (Exception e) {
            log.error("Failed to register product", e);
        }
        return "redirect:/product/get";
    }


    @RequestMapping("/get")
    public String get(Model model) {
        try {
            List<Product> products = productService.get();
            model.addAttribute("products", products);
        } catch (Exception e) {
            log.error("Failed to get product list", e);
        }
        model.addAttribute("center",dir+"get");
        return "index";
    }
}