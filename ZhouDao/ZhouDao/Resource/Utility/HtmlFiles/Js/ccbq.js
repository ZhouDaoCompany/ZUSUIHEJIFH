$(document).ready(function(){
    var total = 0;
    $(".sub").click(function(){
        var num =parseInt($(".ipt").val());

        //判断输入的数据是否合法
        var number = $(".ipt").val();
        if(number == ""){
            alert("请输入金额");
            return false;
        }
        if(isNaN(number)){
            alert('请输入数字');
            number.text(0);
            return false;
        }
        if(number <= 0){
            alert('输入的金额需大于0');
            number.text(0);
            return false;
        }
        
        if(num <= 1000){
            total = 30;
        }else if(num >1000 && num <= 100000){
            total = 30+($(".ipt").val()-1000)*0.01;
        }else{
           total = 30+99000*0.01+(num-100000)*0.005
        }
        if(total > 5000){
            total = 5000;
        }
        $(".sum").text(total.toFixed(2));
        return false;
    });
    $(".reset").click(function(){
        $(".sum").text(00);
    });
});