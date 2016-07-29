$(document).ready(function(){
    var currYear = (new Date()).getFullYear();
    var opt={};
    opt.date = {preset : 'date'};
    opt.datetime = {preset : 'datetime'};
    opt.time = {preset : 'time'};
    opt.default = {
        theme: 'android-ics light', //皮肤样式
        display: 'modal', //显示方式
        mode: 'scroller', //日期选择模式
        dateFormat: 'yyyy-mm-dd',
        lang: 'zh',
        showNow: true,
        nowText: "今天",
        startYear: currYear - 100, //开始年份
        endYear: currYear + 20 //结束年份
    };

    $("#beginTime").mobiscroll($.extend(opt['date'], opt['default']));
    $("#endTime").mobiscroll($.extend(opt['date'], opt['default']));
    
    $(".all").click(function(){
        $(this).addClass('active');
        $(".half").removeClass('active');
        $(".danxuan").css("display","block");
        $(".duoxuan").css("display","none");
        $(".danji").css("display","block");
        $(".duoji").css("display","none");
    });
    $(".half").click(function(){
        $(this).addClass('active');
        $(".all").removeClass('active');
        $(".danxuan").css("display","none");
        $(".duoxuan").css("display","block");
        $(".danji").css("display","none");
        $(".duoji").css("display","block");
    });
    
    $(".sub").click(function(){
        var hobby = 0;
        var num1 = parseFloat($(".iptmoney").val());
        var ah = $(".active").val();
        var time1 = $('#beginTime').val();
        var time2 = $('#endTime').val();
        var arr1 = time1.split("-");
        var arr2 = time2.split("-");
        var date1=new Date(parseInt(arr1[0]),parseInt(arr1[1])-1,parseInt(arr1[2]),0,0,0);
        var date2=new Date(parseInt(arr2[0]),parseInt(arr2[1])-1,parseInt(arr2[2]),0,0,0);
        var time3 = Number(date2)-Number(date1);
        var date3 = time3/24/60/60/1000/365;
        var fullYear = date3.toFixed(0);  //周岁
        var rate = $("input[name^=rate]:checked").val();
        $("input[name='dj']:checked").each(function(){
            hobby += parseFloat($(this).val());  //获取多级别的值
         });
        
        
        //判断输入金额是否合法
        var number = $(".iptmoney").val();
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
        //判断日期
        if(time1 == ""){
            alert("请输入出生日期");
            return false;
        }
        if(time2 == ""){
            alert("请输入定残日期");
            return false;
        }

        //计算赔偿年限
        
        var payYear = 0;
        
        if(fullYear < 60){
            payYear = 20;
        }else if(fullYear >= 60 && fullYear < 75){
            payYear = 20-(fullYear-60);
        }else if(fullYear >= 75){
            payYear = 5;
        }
        
        //计算伤残等级
        
        var lv = 0;
        if(rate == 1){
            lv = 1;
        }else if(rate == 2){
            lv = 0.9;
        }else if(rate == 3){
            lv = 0.8;
        }else if(rate == 4){
            lv = 0.7;
        }else if(rate == 5){
            lv = 0.6;
        }else if(rate == 6){
            lv = 0.5;
        }else if(rate == 7){
            lv = 0.4;
        }else if(rate == 8){
            lv = 0.3;
        }else if(rate == 9){
            lv = 0.2;
        }else if(rate == 10){
            lv = 0.1;
        }
        
        //一级残疾赔偿金计算
        
        var onePayMoney = 0;
        
        onePayMoney = num1*payYear*lv;
        
        $(".danxuan_money").text(onePayMoney);
        
        //多级疾赔偿金计算
        
        var lv_sum = 0;
        var morePayMoney = 0;
        
        if(hobby >= 1){
            hobby = 1;
        }

        morePayMoney = num1*payYear*hobby;
        $(".duoji_money").text(morePayMoney);
       return false;  
    });

    //重置

    $(".reset").click(function(){
        $(".danxuan_money, .duoji_money").text(00);
    });
});
