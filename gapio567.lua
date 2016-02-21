boardTime = tmr.time()
PCTime  = 0
atimers={0,0,0}
apwms={0,0,0}

function setRealTime(itime)
	boardTime = tmr.time()
	PCTime = itime;
	--print('setRealTime=',itime,PCTime)
end

function getTime()
	local stamp = PCTime + tmr.time() - boardTime + 3600
	return(string.format("%02u:%02u:%02u", stamp % 86400 / 3600, stamp % 3600 / 60, stamp % 60))
end

function getPins()
	local ok, json = pcall(cjson.encode, {pins={gpio.read(5),gpio.read(6),gpio.read(7)},timers={atimers[1],atimers[2],atimers[3]},pwms={apwms[1],apwms[2],apwms[3]},time={getTime()},adc={readADC()}})
	if ok then  return(json) else  return nil end
end

function setPWM(pin,duty)
	local nr = tonumber(pin)-4	apwms[nr]=duty atimers[nr]=0
	duty = duty*duty/1023
	pwm.setup(pin,100,duty)
	pwm.start(pin)
	pwm.setduty(pin, duty)
end

function setPin(pin,stan)
	if (stan==nil) then return end
	if (stan=="x") then return end
	local nr = tonumber(pin)-4
	atimers[nr]=0 
	apwms[nr]=0
	if (stan=="2") then	if (gpio.read(pin)==0) then stan=1 else stan=0 end	end
	gpio.mode(pin,gpio.OUTPUT) gpio.write(pin,stan) 
end

function setPins(s) setPin(5,s) setPin(6,s) setPin(7,s) end 

function setTimePin(_GET)
	local delay = tonumber(_GET.delay) * 1000
	local nr = tonumber(_GET.pin)-4	
	apwms[nr]=0
	atimers[nr]=delay/1000
	tmr.alarm(nr-1, delay, 0, function()
		setPin(_GET.pin,_GET.state)	
	end)
end

function flash(pin)	setPin(pin,0) tmr.delay(250000) setPin(pin,1) tmr.delay(250000) setPin(pin,0) end

tmr.alarm(6, 1000, 1, function()
	for t=1,3 do
		if atimers[t]>0 then atimers[t]=atimers[t]-1 end
	end
end)

setPins(0)

function readADC()
	local ADC=0; for i=1,4 do ADC=ADC+adc.read(0) end 
	return bit.rshift(ADC,2)
end