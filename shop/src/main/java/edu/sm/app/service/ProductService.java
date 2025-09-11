package edu.sm.app.service;


import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import edu.sm.app.dto.Product;
import edu.sm.app.dto.ProductSearch; // 추가
import edu.sm.app.repository.ProductRepository;
import edu.sm.common.frame.SmService;
import edu.sm.util.FileUploadUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService implements SmService<Product, Integer> {

    final ProductRepository productRepository;

    @Value("${app.dir.uploadimgsdir}")
    String imgDir;

    @Override
    public void register(Product product) throws Exception {
        if(product.getProductImgFile() != null){
            product.setProductImg(product.getProductImgFile().getOriginalFilename());
            FileUploadUtil.saveFile(product.getProductImgFile(), imgDir);
        }
        productRepository.insert(product);
    }

    @Override
    public void modify(Product product) throws Exception {
        // 기존 이미지 사용
        if(product.getProductImgFile().isEmpty()){
            productRepository.update(product);
        }
        // 신규 이미지 사용
        else{
            FileUploadUtil.deleteFile(product.getProductImg(), imgDir);
            FileUploadUtil.saveFile(product.getProductImgFile(), imgDir);
            product.setProductImg(product.getProductImgFile().getOriginalFilename());
            productRepository.update(product);
        }

    }

    @Override
    public void remove(Integer s) throws Exception {
        productRepository.delete(s);
    }

    @Override
    public List<Product> get() throws Exception {
        return productRepository.selectAll();
    }

    @Override
    public Product get(Integer s) throws Exception {
        return productRepository.select(s);
    }

    // searchProductList 메서드 추가
    public List<Product> searchProductList(ProductSearch search) throws Exception {
        return productRepository.searchProductList(search);
    }

    public Page<Product> getPage(int pageNo) throws Exception {
        PageHelper.startPage(pageNo, 3);
        return productRepository.getpage();
    }
}