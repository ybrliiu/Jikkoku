/* status.cgi コマンド入力のためのjs 要jquelly.js*/

var hit = 0;
var shit = 0;
var bid = null;
var check_id = null;
var i = 0;

$(document).ready(function(){

	$("#off").mouseup(function(){
		$("table#command input").prop('checked', false);
		$("table#command tr").css("background", "#FFFFFF").css("color", "#000000");
	});

	$("#sof").mouseup(function(){
		$("input#sof").toggle();
		$("input#son").toggle();
		$("table#command").css("user-select", "text").css("-moz-user-select", "text").css("-webkit-user-select", "text").css("-ms-user-select", "text");
	});
	$("#son").mouseup(function(){
		$("input#sof").toggle();
		$("input#son").toggle();
		$("table#command").css("user-select", "none").css("-moz-user-select", "none").css("-webkit-user-select", "none").css("-ms-user-select", "none");
	});


	$(window).keydown(function(e){
		if(e.keyCode === 16){
		shit = 1;
		}
	});
	$(window).keyup(function(f){
		if(f.keyCode === 16){
		shit = 0;
		}
	});

	$("table#command").on({
		'mousedown': function() {
		hit=1;
		},
		'mouseup': function() {
		hit=0;
		}
	});
	$("table#command tr").mousedown(function(){
		check_id = $(this).attr("id");
		if(!$("table#command input[value=" + check_id + "]").prop('checked')){
			var box = document.getElementById(check_id);
			box.style.backgroundColor = "#4682B4";
			box.style.color = "#ffffff";
			$("table#command input[value=" + check_id + "]").prop('checked', true);
			if(shit){
				if(bid > check_id){
					if(bid < check_id){
					}else{
					var tmp = bid;
					bid = check_id;
					check_id = tmp;
					}
				}
				var n = 0;
				for(i=bid;i<=check_id;i++){
				var box = document.getElementById(i);
				box.style.backgroundColor = "#4682B4";
				box.style.color = "#ffffff";
				$("table#command input[value=" + i + "]").prop('checked', true);
				n++;
				}
			}
		}else{
			var box = document.getElementById(check_id);
			box.style.backgroundColor = "#FFFFFF";
			box.style.color = "#000000";
			$("table#command input[value=" + check_id + "]").prop('checked', false);
			if(shit){
				if(bid > check_id){
					if(bid < check_id){
					}else{
					var tmp = bid;
					bid = check_id;
					check_id = tmp;
					}
				}
				var n = 0;
				for(i=bid;i<=check_id;i++){
				var box = document.getElementById(i);
				box.style.backgroundColor = "#4682B4";
				box.style.color = "#ffffff";
				$("table#command input[value=" + i + "]").prop('checked', true);
				n++;
				}
			}
		}
		bid = check_id;
	});
	$("table#command tr").mouseover(function(){
		if(hit){
			var check_id = $(this).attr("id");
			if(!$("table#command input[value=" + check_id + "]").prop('checked')){
				var box = document.getElementById(check_id);
				box.style.backgroundColor = "#4682B4";
				box.style.color = "#ffffff";
				$("table#command input[value=" + check_id + "]").prop('checked', true);
			}else{
				var box = document.getElementById(check_id);
				box.style.backgroundColor = "#FFFFFF";
				box.style.color = "#000000";
				$("table#command input[value=" + check_id + "]").prop('checked', false);
			}
		}
	});

});


function sentaku(SEL1,SEL2){
	var SEL;
	LEN = document.com.no.length;
	LEN--;
	if(SEL1 == null || SEL2 == null){
	SEL1 = document.com.SEL1.value * 1;
	SEL2 = document.com.SEL2.value * 1;
	}
	SEL1--;
	for(SEL = 0; SEL < LEN; SEL++){
	document.com.no[SEL+1].checked = false;
	var box = document.getElementById(SEL);
	box.style.backgroundColor = "#FFFFFF"; 
	box.style.color = "#000000"; 
	}
	for(SEL = SEL1; SEL < LEN; SEL = SEL + SEL2){
	document.com.no[SEL+1].checked = true;
	var box = document.getElementById(SEL);
	box.style.backgroundColor = "#4682B4"; 
	box.style.color = "#ffffff"; 
	}
}
