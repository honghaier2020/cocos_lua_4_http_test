require("json")

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	
	--http test
	-- get
	local xhr_get = cc.XMLHttpRequest:new()
	xhr_get.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr_get:open("GET", "http://httpbin.org/get")
	 
	local function onGetReadyStateChange()
		local statusString = "Http Status Code:"..xhr_get.statusText
        cclog(xhr_get.response)
    end	 
	
	xhr_get:registerScriptHandler(onGetReadyStateChange)
    xhr_get:send()
	cclog("http get waiting...")
	
	-- post
	local xhr_post = cc.XMLHttpRequest:new()
    xhr_post.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr_post:open("POST", "http://httpbin.org/post")
	local function onPostReadyStateChange()
		local statusString = "Http Status Code:"..xhr_post.statusText
        cclog(xhr_post.response)
    end	 
	xhr_post:registerScriptHandler(onPostReadyStateChange)
    xhr_post:send()		
	cclog("http post waiting...")
	
	-- post binary
	 local xhr_post_binary = cc.XMLHttpRequest:new()
     xhr_post_binary.responseType = cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER
     xhr_post_binary:open("POST", "http://httpbin.org/post")
	
	 local function onPostBinaryReadyStateChange()
           local response   = xhr_post_binary.response
           local size     = table.getn(response)
           local strInfo = ""
            
           for i = 1,size do
                if 0 == response[i] then
                    strInfo = strInfo.."\'\\0\'"
                else
                    strInfo = strInfo..string.char(response[i])
                end 
           end
            cclog("Http Status Code:"..xhr_post_binary.statusText)
            cclog(strInfo)
     end
			
	 xhr_post_binary:registerScriptHandler(onPostBinaryReadyStateChange)
     xhr_post_binary:send() 
     cclog("post binary waiting...")
		
	-- post json
	 local xhr_post_json = cc.XMLHttpRequest:new()
     xhr_post_json.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
     xhr_post_json:open("POST", "http://httpbin.org/post")
	local function onPostJsonReadyStateChange()
         cclog("Http Status Code:"..xhr_post_json.statusText)
         local response   = xhr_post_json.response
         local output = json.decode(response,1)
         table.foreach(output,function(i, v) print (i, v) end)
         cclog("headers are")
         table.foreach(output.headers,cclog)
    end
	
	xhr_post_json:registerScriptHandler(onPostJsonReadyStateChange)
    xhr_post_json:send()     
    cclog("post json waiting...")
	
	-- test code begin
    require "./src/hello2"
    cclog("result is " .. myadd(1, 1))
	-- test code end
end


xpcall(main, __G__TRACKBACK__)
