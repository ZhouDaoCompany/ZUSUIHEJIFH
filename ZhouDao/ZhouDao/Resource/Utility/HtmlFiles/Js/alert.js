window.alert = function(str)
    {
        var shield = document.createElement("DIV");
        shield.id = "shield";
        shield.style.position = "absolute";
        shield.style.left = "0px";
        shield.style.top = "0px";
        shield.style.width = "100%";
        shield.style.height = document.body.scrollHeight+"px";

        shield.style.textAlign = "center";
        shield.style.zIndex = "25";

        var alertFram = document.createElement("DIV");
        alertFram.id="alertFram";
        alertFram.style.position = "absolute";
        alertFram.style.left = "50%";
        alertFram.style.top = "50%";
        alertFram.style.marginLeft = "-135px";
        alertFram.style.marginTop = "-70px";
        alertFram.style.width = "270px";
        alertFram.style.height = "115px";
        alertFram.style.background = "#fff";
        alertFram.style.textAlign = "center";
        alertFram.style.lineHeight = "150px";
        alertFram.style.zIndex = "300";
        strHtml = "<ul style=\"list-style:none;margin:0px;width:100%;border:1px solid #999\">\n";
        strHtml += " <li style=\"background:#f4f4f4;text-align:left;padding-left:20px;font-size:14px;line-height:25px;\">提示：</li>\n";
        strHtml += " <li style=\"background:#fff;text-align:center;font-size:14px;height:50px;line-height:50px;\">"+str+"</li>\n";
        strHtml += " <li style=\"background:#f1f1f1;text-align:right;line-height:25px;padding:5px 10px;\">" +
            "<input style=\"text-align:center;padding:2px 10px;\" type=\"button\" value=\"确 定\" onclick=\"doOk()\" /></li>\n";
        strHtml += "</ul>\n";
        alertFram.innerHTML = strHtml;
        document.body.appendChild(alertFram);
        document.body.appendChild(shield);
        var ad = setInterval("doAlpha()",5);
        this.doOk = function(){
            alertFram.style.display = "none";
            shield.style.display = "none";
        }
        alertFram.focus();
        document.body.onselectstart = function(){return false;};
    }