test=0
lastTime=tmr.time()
retrySSE = 15000

function sendFile(conn, filename)
	local sum=0
	if file.open(filename, "r") then
		repeat
			local line=file.read()
			if line then conn:send(line) sum=sum+#line end
		until not line 
		file.close()
	end
	print("-> -> -> Sent file: "..filename.." "..sum.." bytes")
	line=nil sum=nil
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
	conn:on("receive",function(conn,payload)
		if(test==1) then print(payload) end
		local _GET = {}
		local ajax_head="HTTP/1.1 200 OK \r\nAccess-Control-Allow-Origin: *\r\n\r\n"
		local sse_head ="HTTP/1.1 200 OK \r\nContent-Type: text/event-stream\r\nCache-Control: no-cache\r\n\r\n"
		local _, _, method, url, vars = string.find(payload, "([A-Z]+) /([^?]*)%??(.*) HTTP")
		print("\r\n"..method, url, vars, tmr.time())
		if url=="" and vars=="" then url = "index.html" end

		if url~=nil then
			for k, v, x,y in string.gmatch(url, "(%w+)=(%w+)&*") do	_GET[k] = v	 end
			--table.foreach(_GET,print)
			if(_GET.time) then 
				setRealTime(_GET.time) 
				conn:send(ajax_head..getPins())
			end
			if(_GET.type=="ajax") then 
				if     (_GET.delay) then setTimePin(_GET)
				elseif (_GET.pwm) then setPWM(_GET.pin,_GET.pwm)
				elseif (_GET.pin=="x") then setPins(_GET.state) 
				else setPin(_GET.pin,_GET.state) 
				end
				conn:send(ajax_head..getPins()) 
			end
			if(_GET.type=="sse") then
				if(_GET.retry) then retrySSE=_GET.retry*1000 end
				conn:send(sse_head.."data:"..getPins().."\r\nretry: "..retrySSE.."\r\n\r\n")
			end
			
		end
		local ex=nil
		if (url) then ex=url:match "[^.]+$" 
			if (url=="favicon.ico") then conn:send("HTTP/1.1 404 file not found\r\n\r\n") end
			if (ex=="html" or ex=="css" or ex=="js") then sendFile(conn,url) end
		end
		print(". . .",tmr.time()-lastTime,retrySSE)
		lastTime=tmr.time()
	end) -- on recive
	
	conn:on("sent",function(conn)
        conn:close()
    end) -- on sent
	
	conn:on("disconnection",function(conn) 
		--tmr.softwd(tmrWatchDog)
        collectgarbage();
    end) -- on disconection
	
end) -- srv