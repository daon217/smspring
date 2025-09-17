
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    $(function(){

    });
</script>

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Tables</h1>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Product Select</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>IMAGE</th>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>PRICE</th>
                        <th>RATE</th>
                        <th>Register Date</th>
                        <th>Update Date</th>
                    </tr>
                    </thead>
                    <tfoot>
                    <tr>
                        <th>IMAGE</th>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>PRICE</th>
                        <th>RATE</th>
                        <th>Register Date</th>
                        <th>Update Date</th>
                    </tr>
                    </tfoot>
                    <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <th><img src="/imgs/${product.productImg}" width="100px" height="100px"></th>
                            <th>${product.productId}</th>
                            <th>${product.productName}</th>
                            <th>${product.productPrice}</th>
                            <th>${product.discountRate}</th>
                            <th>${product.productRegdate}</th>
                            <th>${product.productUpdate}</th>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>
<!-- /.container-fluid -->

<!-- Page level plugins -->
<script src="/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<!-- Page level custom scripts -->
<script src="/js/demo/datatables-demo.js"></script>