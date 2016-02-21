dofile("gapio567.lua")
dofile("wifis.lua")

last=nil
function polocz(n)
n=n+1
if last == n then return end
print(n,wifis[n][1])
wifi.sta.config(wifis[n][1],wifis[n][2])
last=n
end


wifi.setmode(wifi.STATION)
--wifi.setmode(wifi.STATIONAP)
licz=0;

tmr.alarm(0, 3000, 1, function()
	polocz(licz/10)
	if wifi.sta.getip() == nil then
		print("Conn to AP...#"..licz)
		licz=licz+1
		setPin(5,"2")
	else
		local ip, nm, gw=wifi.sta.getip()
		print("IP: ",ip)
		ip=nil
		nm=nil
		gw=nil
		licz=nil
		wifis=nil
		tmr.stop(0)
		flash(5)
		collectgarbage()
		dofile("server_AJAX_TCP.lua")
	end
end)