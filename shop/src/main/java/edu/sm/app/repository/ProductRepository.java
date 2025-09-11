package edu.sm.app.repository;


import com.github.pagehelper.Page;
import edu.sm.app.dto.Product;
import edu.sm.app.dto.ProductSearch; // 추가
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import java.util.List; // 추가

@Repository
@Mapper
public interface ProductRepository extends SmRepository<Product, Integer> {
    Page<Product> getpage() throws Exception;
    List<Product> searchProductList(ProductSearch search) throws Exception; // 추가
}