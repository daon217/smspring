<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    let center = {
        init:function (){
            $('#send_btn').click(()=>{
                let msg = 'test';
                this.send(msg);
            });
        },
        send:function (msg){
            $.ajax({
                url:'${adminserver}aimsg',
                data: {msg:msg},
                success:()=>{}
            });
        }
    }

    $(()=>{
        center.init();
    })
</script>

<div class="col-sm-10">
    <h2>AI3 Voice Image Chat System</h2>
    <h5>${adminserver}</h5>
    <button id="send_btn">Click</button>
</div>