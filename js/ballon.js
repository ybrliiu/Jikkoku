//ブラウザ判定用function browser(){    if(navigator.userAgent.indexOf("Opera") != -1){        type = "Opera";    }else if(navigator.userAgent.indexOf("MSIE")!=-1     && navigator.userAgent.indexOf("Trident/4.0")!=-1){        type = "MSIE8";    }else if(navigator.userAgent.indexOf("MSIE") != -1){        type = "MSIE";    }else if(navigator.userAgent.indexOf("Firefox") != -1){        type = "Firefox";    }else if(navigator.userAgent.indexOf("Netscape") != -1){        type = "Netscape";    }else if(navigator.userAgent.indexOf("Safari") != -1){        type = "Safari";    }else{        type = "none";     }    return type;}//バルーンブロック表示用function balloon_showblock(Target, TopPos, LeftPos){    if(browser() == "MSIE"){        document.onmousemove = iMouseIE;    }else if(browser() == "MSIE8"){        document.onmousemove = iMouseIE8;    }else{        document.onmousemove = iMouseFirefox;   }    function iMouseFirefox(evt){        Xpos = evt.pageX-LeftPos;        Ypos = evt.pageY-TopPos;        document.getElementById(Target).style.top = Ypos+"px";        document.getElementById(Target).style.left = Xpos+"px";    }    function iMouseIE(){        Xpos = event.x+(document.body.scrollLeft || document.documentElement.scrollLeft)-LeftPos;        Ypos = event.y+(document.body.scrollTop || document.documentElement.scrollTop)-TopPos;        document.getElementById(Target).style.top = Ypos+"px";        document.getElementById(Target).style.left = Xpos+"px";    }    function iMouseIE8(){        Xpos = event.x-LeftPos;        Ypos = event.y-TopPos;        document.getElementById(Target).style.top = Ypos+"px";        document.getElementById(Target).style.left = Xpos+"px";    }    document.getElementById(Target).style.display = "";}//バルーンブロック非表示用function hide_block(Target){    document.getElementById(Target).style.display = "none";}