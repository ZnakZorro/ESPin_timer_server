function sendTime(){
var timesek = Math.round(((new Date()).getTime())/1000);
ax('type=ajax&time='+timesek+'&os='+navigator.platform,'info');
}
setTimeout(function(){sendTime()},999);
//setInterval(function(){sendTime()},66666);

document.addEventListener('DOMContentLoaded', function() {
source = new EventSource(url+'type=sse');
source.onmessage = function(event) {
	try {j = JSON.parse(event.data);} catch(err) {}
	if(j) {displayState(j)}
	var czas = ((new Date(event.timeStamp)).toLocaleString()).slice(12,20);			
	$("czas").innerHTML = czas;
	$("info").innerHTML = event.data;
}

});
function extra(){[].forEach.call(document.querySelectorAll('div.ca'), function(v) {if (v.style.display == 'none') v.style.display='block'; else v.style.display='none';});}
