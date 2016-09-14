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
        
        if(num <= 10000){
            total = 50;
        }else if(num >10000 && num <= 500000){
            total = 50+(num-10000)*0.015;
        }else if(num > 500000 && num <= 5000000){
           total = 50+490000*0.015+(num-500000)*0.01;
        }else if(num > 5000000 && num <= 10000000){
            total = 50+490000*0.015+4500000*0.01+(num-5000000)*0.005;
        }else{
            total = 50+490000*0.015+4500000*0.01+5000000*0.005+(num-10000000)*0.001;
        }
        $(".sum").text(total);
        return false;
    });
    $(".reset").click(function(){
        $(".sum").text(00);
    });
});