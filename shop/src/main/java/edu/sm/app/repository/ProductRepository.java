package edu.sm.app.repository;


import com.github.pagehelper.Page;
import edu.sm.app.dto.Product;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ProductRepository extends SmRepository<Product, Integer> {
    Page<Product> getpage() throws Exception;
}