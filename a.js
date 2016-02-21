'use strict';
function ax(u,b){fetch(url+u).then(function(ret){return ret.text();}).then(function(d){
try {var j = JSON.parse(d);if(j) {displayState(j)}} catch(err) {}
$(b).innerHTML=d;
});}
function pad(n){return("0"+n).slice(-2)}
function tc(t){var MF=Math.floor;return pad(MF(t%86400/3600))+" "+pad(MF(t%3600/60))+" "+pad(t%60)}
function displayState(j){
var a=j.pins;
var t=j.timers;
  for (var i=0;i<3;i++){
	var n=i+5;
	$("pin"+n).className="pin"+a[i];
	$("led"+n).className="b pin"+a[i];
	$("time"+n).innerHTML=tc(t[i]);
	$("st"+n).value=Math.sqrt(t[i]);
	$("adc").innerHTML=(Math.round(1100*j.adc/1024)/1000)+" V";
  }
}
function suwak(pin,v){ax('type=ajax&pin='+pin+'&pwm='+v,'info')}
function sTime(pin,v){v=v*v;ax('type=ajax&pin='+pin+'&state=2&delay='+v,'info')}