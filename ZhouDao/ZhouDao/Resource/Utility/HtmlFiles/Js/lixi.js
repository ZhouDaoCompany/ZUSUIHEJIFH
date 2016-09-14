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
        $(".appoint").css("display","block");
        $(".bank").css("display","none");
        $(".one").css("display","block");
    });
    $(".half").click(function(){
        $(this).addClass('active');
        $(".all").removeClass('active');
        $(".bank").css("display","block");
        $(".appoint").css("display","none");
        $(".one").css("display","none");
    });
    
    $(".sub").click(function(){
        var num1 = parseFloat($(".iptmoney").val());
        var num2 = parseFloat($(".iptrate").val());
        var ah = $(".active").val();
        var rate = $(".select").find("option:selected").val();
        var time1 = $('#beginTime').val();
        var time2 = $('#endTime').val();
        var arr1 = time1.split("-");
        var arr2 = time2.split("-");
        var date1=new Date(parseInt(arr1[0]),parseInt(arr1[1])-1,parseInt(arr1[2]),0,0,0);
        var date2=new Date(parseInt(arr2[0]),parseInt(arr2[1])-1,parseInt(arr2[2]),0,0,0);
        var time3 = Number(date2)-Number(date1);
        var date3 = time3/24/60/60/1000;

        //判断输入是否合法
        var number = $(".iptmoney").val();
        if(number == ""){
            alert('请输入金额');
            number.focus;
            return false;
        }
        if(number <= 0){
            alert('输入的金额需大于0');
            number.text(0);
            return false;
        }
        if(time1 == ""){
            alert("请输入起算日期");
            return false;
        }
        if(time2 == ""){
            alert("请输入截至日期");
            return false;
        }

        //利率选项
        var rate_ch = 0;
        if(rate == 1){
            rate_ch = ((num2)/100);
        }else if(rate == 2){
            rate_ch = ((num2*12/360)/100);
        }else if(rate == 3){
            rate_ch =((num2/360)/100);
        }
        
        //起算日期不能大于截止日期
        
        if(date3 < 0 ){
            alert("起算日期不能大于截止日期");
            return false;
        }
        
        //一般债务利息
        var singelDebt = 0;
        
        singelDebt = num1*date3*rate_ch;
        
        $(".singelDebt").text(singelDebt.toFixed(2));
        
        //加倍部分债务利息
        
        var doubleDebt = 0;
        
        doubleDebt = num1*date3*0.000175;
        
        $(".doubleDebt").text(doubleDebt.toFixed(2));


        //迟延期间的债务利息

        $(".delayDebt").text((singelDebt+doubleDebt).toFixed(2));
        
        //根据中国银行利率 计算
        
        var abc = {
                   "19890201":["0.1134","0.1134","0.1278","0.1440","0.1926"],
                   "19900821":["0.0864","0.0936","0.1008","0.1080","0.1116"],
                   "19910321":["0.0900","0.1008","0.1080","0.1152","0.1188"],
                   "19910421":["0.0810","0.0864","0.0900","0.0954","0.0972"],
                   "19930515":["0.0882","0.0936","0.1080","0.1206","0.1224"],
                   "19930711":["0.0900","0.1098","0.1224","0.1386","0.1404"],
                   "19950101":["0.0900","0.1098","0.1296","0.1458","0.1476"],
                   "19950701":["0.1008","0.1206","0.1305","0.1512","0.1530"],
                   "19960501":["0.0972","0.1098","0.1314","0.1494","0.1512"],
                   "19960823":["0.0918","0.1008","0.1098","0.1170","0.1242"],
                   "19971023":["0.0765","0.0864","0.0936","0.0990","0.1053"],
                   "19980325":["0.0702","0.0792","0.0900","0.0972","0.1035"],
                   "19980701":["0.0657","0.0693","0.0711","0.0765","0.0801"],
                   "19981207":["0.0612","0.0639","0.0666","0.0720","0.0756"],
                   "19990610":["0.0558","0.0585","0.0594","0.0603","0.0621"],
                   "20020221":["0.0504","0.0531","0.0549","0.0558","0.0576"],
                   "20041029":["0.0522","0.0558","0.0576","0.0585","0.0612"],
                   "20050317":["0.0522","0.0558","0.0576","0.0585","0.0612"],
                   "20060428":["0.0540","0.0585","0.0603","0.0612","0.0639"],
                   "20060819":["0.0558","0.0612","0.0630","0.0648","0.0684"],
                   "20070318":["0.0567","0.0639","0.0657","0.0675","0.0711"],
                   "20070519":["0.0585","0.0657","0.0675","0.0693","0.0720"],
                   "20070721":["0.0603","0.0684","0.0702","0.0720","0.0738"],
                   "20070822":["0.0621","0.0702","0.0720","0.0738","0.0756"],
                   "20070915":["0.0648","0.0729","0.0747","0.0765","0.0783"],
                   "20071221":["0.0657","0.0747","0.0756","0.0774","0.0783"],
                   "20080916":["0.0621","0.0720","0.0729","0.0756","0.0774"],
                   "20081009":["0.0612","0.0693","0.0702","0.0729","0.0747"],
                   "20081027":["0.0612","0.0693","0.0702","0.0729","0.0747"],
                   "20081030":["0.0603","0.0666","0.0675","0.0702","0.0720"],
                   "20081127":["0.0504","0.0558","0.0567","0.0594","0.0612"],
                   "20081223":["0.0486","0.0531","0.0540","0.0576","0.0594"],
                   "20101020":["0.0510","0.0556","0.0560","0.0596","0.0614"],
                   "20101226":["0.0535","0.0581","0.0585","0.0622","0.0640"],
                   "20110209":["0.0560","0.0606","0.0610","0.0645","0.0660"],
                   "20110406":["0.0585","0.0631","0.0640","0.0665","0.0680"],
                   "20110707":["0.0610","0.0656","0.0665","0.0690","0.0705"],
                   "20120608":["0.0585","0.0631","0.0640","0.0665","0.0680"],
                   "20120706":["0.0560","0.0600","0.0615","0.0640","0.0655"],
                   "20141122":["0.0560","0.0560","0.0600","0.0600","0.0615"],
                   "20150301":["0.0535","0.0535","0.0575","0.0575","0.0590"],
                   "20150511":["0.0510","0.0510","0.0550","0.0550","0.0565"],
                   "20150628":["0.0485","0.0485","0.0525","0.0525","0.0540"],
                   "20150826":["0.0460","0.0460","0.0500","0.0500","0.0515"]
                  }
        
        if(arr2[2] < 10) arr2[2] = "0"+arr2[2];
        var endTime = arr2[0]+arr2[1]+arr2[2];
        
        if(arr1[2] < 10) arr1[2] = "0"+arr1[2];
        var beginTime = arr1[0]+arr1[1]+arr1[2];
        
        var lastTime,thisDayAll,differ;
        var breachMoney     = 0;
        
        
        for(var item in abc){

            
            if(endTime > item && item > beginTime ){ 

                if(beginTime > lastTime && beginTime < item){
                     lastTime = beginTime;
                 }
                
                differYear      = item.substring(0,4);
                differMonth     = item.substring(4,6);
                differDay       = item.substring(6,8);
                var stamp = new Date(differYear,differMonth-1,differDay,0,0,0);

                differYearOld      = lastTime.substring(0,4);
                differMonthOld     = lastTime.substring(4,6);
                differDayOld       = lastTime.substring(6,8);
                var stampOld = new Date(differYearOld,differMonthOld-1,differDayOld,0,0,0);

                var differTime = Number(stamp)/1000 - Number(stampOld)/1000;

                var differTimeDay = differTime/24/60/60;

                if(differTimeDay < 180){
                    breachMoney += num1*differTimeDay*(lastTimeVal[0]/360);
                }
                else if(differTimeDay > 180 && differTimeDay < 365){
                    breachMoney += num1*differTimeDay*(lastTimeVal[1]/360);
                }
                else if(differTimeDay > 365 && differTimeDay < 1095){
                    breachMoney += num1*differTimeDay*(lastTimeVal[2]/360);
                }
                else if(differTimeDay > 1095 && differTimeDay < 1825){
                    breachMoney += num1*differTimeDay*(lastTimeVal[3]/360);
                }
                else if(differTimeDay > 1825){
                    breachMoney += num1*differTimeDay*(lastTimeVal[4]/360);
                }
            }
            if(endTime < item){
                item = endTime;
                differYear      = item.substring(0,4);
                differMonth     = item.substring(4,6);
                differDay       = item.substring(6,8);
                var stamp = new Date(differYear,differMonth-1,differDay,0,0,0);

                differYearOld      = lastTime.substring(0,4);
                differMonthOld     = lastTime.substring(4,6);
                differDayOld       = lastTime.substring(6,8);
                var stampOld = new Date(differYearOld,differMonthOld-1,differDayOld,0,0,0);

                var differTime = Number(stamp)/1000 - Number(stampOld)/1000;

                var differTimeDay = differTime/24/60/60;

                if(differTimeDay < 180){
                    breachMoney += num1*differTimeDay*(lastTimeVal[0]/360);
                }
                else if(differTimeDay > 180 && differTimeDay < 365){
                    breachMoney += num1*differTimeDay*(lastTimeVal[1]/360);
                } 
                else if(differTimeDay > 365 && differTimeDay < 1095){
                    breachMoney += num1*differTimeDay*(lastTimeVal[2]/360);
                }
                else if(differTimeDay > 1095 && differTimeDay < 1825){
                    breachMoney += num1*differTimeDay*(lastTimeVal[3]/360);
                }
                else if(differTimeDay > 1825){
                    breachMoney += num1*differTimeDay*(lastTimeVal[4]/360);
                }
                $('.bankDelayDebt').text(breachMoney.toFixed(2)*2);
               return false;
            }

            lastTime = item;
            lastTimeVal = abc[item];

        }
            if(endTime > lastTime && beginTime < item){
                   item = endTime;
                differYear      = item.substring(0,4);
                differMonth     = item.substring(4,6);
                differDay       = item.substring(6,8);
                var stamp = new Date(differYear,differMonth-1,differDay,0,0,0);

                differYearOld      = lastTime.substring(0,4);
                differMonthOld     = lastTime.substring(4,6);
                differDayOld       = lastTime.substring(6,8);
                var stampOld = new Date(differYearOld,differMonthOld-1,differDayOld,0,0,0);

                var differTime = Number(stamp)/1000 - Number(stampOld)/1000;

                var differTimeDay = differTime/24/60/60;

                if(differTimeDay < 180){
                    breachMoney += num1*differTimeDay*(lastTimeVal[0]/360);
                }
                else if(differTimeDay > 180 && differTimeDay < 365){
                    breachMoney += num1*differTimeDay*(lastTimeVal[1]/360);
                } 
                else if(differTimeDay > 365 && differTimeDay < 1095){
                    breachMoney += num1*differTimeDay*(lastTimeVal[2]/360);
                }
                else if(differTimeDay > 1095 && differTimeDay < 1825){
                    breachMoney += num1*differTimeDay*(lastTimeVal[3]/360);
                }
                else if(differTimeDay > 1825){
                    breachMoney += num1*differTimeDay*(lastTimeVal[4]/360);
                }
            }

        if(beginTime > lastTime){
            item = beginTime;
            differYear      = item.substring(0,4);
            differMonth     = item.substring(4,6);
            differDay       = item.substring(6,8);
            var stamp = new Date(differYear,differMonth-1,differDay,0,0,0);

            differYearOld      = endTime.substring(0,4);
            differMonthOld     = endTime.substring(4,6);
            differDayOld       = endTime.substring(6,8);
            var stampOld = new Date(differYearOld,differMonthOld-1,differDayOld,0,0,0);

            var differTime = Number(stamp)/1000 - Number(stampOld)/1000;

            var differTimeDay = -(differTime/24/60/60);
            if(differTimeDay < 180){
                breachMoney += num1*differTimeDay*(lastTimeVal[0]/360);
            }
            else if(differTimeDay > 180 && differTimeDay < 365){
                breachMoney += num1*differTimeDay*(lastTimeVal[1]/360);
            }
            else if(differTimeDay > 365 && differTimeDay < 1095){
                breachMoney += num1*differTimeDay*(lastTimeVal[2]/360);
            }
            else if(differTimeDay > 1095 && differTimeDay < 1825){
                breachMoney += num1*differTimeDay*(lastTimeVal[3]/360);
            }
            else if(differTimeDay > 1825){
                breachMoney += num1*differTimeDay*(lastTimeVal[4]/360);
            }

          }
            var bankSingeldebt =0;

            $(".bankDelayDebt").text(breachMoney.toFixed(2)*2);

            return false;

        
    });

    $(".reset").click(function(){

        $(".singelDebt").text(0);
        $(".doubleDebt").text(0);
        $(".bankSingeldebt").text(0);
        $(".bankDoubleDebt").text(0);
        $(".delayDebt").text(0);
        $(".bankDelayDebt").text(0);
    });
});
