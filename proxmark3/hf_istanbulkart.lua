local cmds = require('commands')
local getopt = require('getopt')
local lib14a = require('read14a')
local ansicolors  = require('ansicolors')
-- External libs -- 
local json = require('json') -- parse json
local requests = require("requests") -- http requests
local inspect = require("inspect") -- print json



copyright = ''
author = "Ahmet Bilal Can"
version = 'v1.0.0'
desc = [[
Automate the istanbulkart connection
]]

example = [[
    script run proxy -c <customer_no> -s <session_key>

]]
usage = [[
script run proxy
]]

arguments = [[
    -c              Customer number
    -s              Session key
    -d              Debug mode

]]

-- helper colors --
local function yellow(str)
    return ansicolors.yellow..str..ansicolors.reset
end

local function err0r()
    return "["..ansicolors.red.."!"..ansicolors.reset.."] "
end
local function info()
    return "["..ansicolors.blue.."~"..ansicolors.reset.."] "
end
local function success()
    return "["..ansicolors.green.."+"..ansicolors.reset.."] "
end

local function warning()
    return "["..ansicolors.yellow.."-"..ansicolors.reset.."] "
end

-- Creating base-json to send --
local function base_json(session_key,connection,customer_no,uid,transaction)
    base = {}
    base["sessionToken"] = session_key
    base["clientData"] = {clientConnectionIndex=connection}
    if transaction ~= nil then
        base["transactionId"] = transaction
    end    
    base["customerNumber"] = customer_no
    base["uid"] = uid

    return base
end

local function help()
    print(copyright)
    print(author)
    print(version)
    print(desc)
    print(ansicolors.cyan..'Usage'..ansicolors.reset)
    print(usage)
    print(ansicolors.cyan..'Example usage'..ansicolors.reset)
    print(example)
    print(ansicolors.cyan..'Arguments'..ansicolors.reset)
    print(arguments)
end

-- print out response cool style --

local function debug_response(response)
    print(info().."Status Code:")
    print(response.status_code)
    print(info().."Response body:")
    print(response.text)
end

local function oops(err)
    print('ERROR:', err)
    core.clearCommandBuffer()
    return nil, err
end
---
-- The main entry point
function main(args)
    if args == nil or #args == 0 then return help() end
    local stayconnected = true
    local doconnect = true
    local no_rats = false
    local transaction = nil
    local session_key = nil
    local uid = nil
    local customer_no = nil
    local debug_mod = false
    local help_flag = false

    -- Read the parameters
    for o, a in getopt.getopt(args,'c:s:dh') do
        if o == "c" then customer_no = tonumber(a) end
        if o == "s" then session_key = a end
        if o == "d" then debug_mod = true end
        if o == "h" then help_flag = true end

    end
    if help_flag then
       help() 
       return
    end

    if customer_no == nil then
        print(err0r().."You need to give customer no with -c parameter")
        return
    end
    if session_key == nil then
        print(err0r().."You need to give session_key with -s parameter") 
        return
    end
    
    if debug_mod ~= false then
        print(info().."Debug mod enabled ! You will see response informations..")
    end    

    -- First of all, connect
    if doconnect then

        inf, err = lib14a.read(true, no_rats)
        if err then
            lib14a.disconnect()
            return oops(err)
        end
        print((info()..'Connected to card, uid = %s'):format(inf.uid))
        uid = inf.uid
    end

   
    -- generate random connection number to create transaction --
    local connection = math.random(100)
    local base_url = "https://mobiletugra.belbim.istanbul/MobileAdapter/MobileWcfAdapter/"
    local headers = {["User-Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0",
                ["Content-Type"]="application/json"}
  

    -- get transaction id from MBSearchCardWithAuthP1 API--
    print(yellow("#######").." STEP-1 : Create transaction "..yellow("#######"))
    url = base_url.."MBSearchCardWithAuthP1"
    SearchAuthP1_body = base_json(session_key,connection,customer_no,uid,nil)
    SearchAuthP1_body["amount"] = 0  -- :)
    SearchAuthP1_body["txnType"] = 5
    SearchAuthP1_body["terminalInfo"] = {}

    -- create post parameters --
    j = json.encode(SearchAuthP1_body)
    response = requests.post{url, data=SearchAuthP1_body,headers=headers}
    if debug_mod then debug_response(response) end
    local response_json = json.decode(response.text)
    if string.match(response.text,"Hsm servis") then -- they dont change response.status_code so..
        print("Server Error.. Enable debug mod with -d to see server response..")
        lib14a.disconnect()
        return
    end
    response_json = response_json["MBSearchCardWithAuthP1Result"]
    transaction = response_json["transactionId"]
    print(info().."Got transaction id from server : "..transaction)
    if transaction == 0 then
        print(err0r().."Cannot create transaction. Check customerno and session key")
        return
    end
    
    -- send auth from card to server --
	print(yellow("#######").." STEP-2 : Send card info and auth response server "..yellow("#######"))
	--commands = {"905A00000342220100","9060000000","90AF000000","90AF000000","90BD0000070100000020000000","90F50000010200","90F50000010600","900A0000010200"}
    commands_inst = {}
    commands = response_json["commands"]
    for i=1,#commands do commands_inst[i] = commands[i]["cmd"] end

    connection = connection+1
    auth_1 = base_json(session_key,connection,customer_no,uid,transaction)
	ret = send_commands(commands_inst)
	auth_1["authP1CardReturn"]={}
	for i=1,#ret do
		cmdArr = {cmd=ret[i],name="iso cmd"}
		auth_1["authP1CardReturn"][i] = cmdArr

	end

	print(info().."Card auth response "..ret[#ret].." , sending it to server")
    
	print(yellow("#######").." STEP-3 : Auth token response from server"..yellow("#######"))
    url = base_url.."AuthP1"
    response = requests.post{url, data=auth_1,headers=headers}
        
    response_json = json.decode(response.text)
    if debug_mod then debug_response(response) end
    local response_json = json.decode(response.text)
    if string.match(response.text,"Hsm servis") then
        print("Server Error.. Enable debug mod with -d to see server response..")
        lib14a.disconnect()
        return
    end

    response_json = response_json["AuthP1Result"]
    local auth2 = response_json["commands"][1]["cmd"]
    print(info().."Got token from server, sending it to card "..auth2)

	print(yellow("#######").." STEP-4 : Get final auth token "..yellow("#######"))
    connection = connection+1
    auth_2 = base_json(session_key,connection,customer_no,uid,transaction)
	ret = send_commands({auth2})
	auth_2["authP2CardReturn"]={}
	for i=1,#ret do
		cmdArr = {cmd=ret[i],name="iso cmd"}
		auth_2["authP2CardReturn"][i] = cmdArr

	end
    url = base_url.."AuthP2"
    print(info().."Sending final token to server "..ret[1])
    response = requests.post{url, data=auth_2,headers=headers}
    if debug_mod then debug_response(response) end

    response_json = json.decode(response.text)
    
	print(yellow("########").." STEP-6 : Read a lot of data from card "..yellow("########"))

	--commands = {"90BD0000070100000020000000","90BD0000070200000032000000","90BD000007023200000E000000","906C0000010300","90BD0000070400000032000000","90BD000007043200002E000000","90BD0000070600000032000000","90BD0000070632000032000000","90BD000007066400001C000000","90BD0000070700000032000000","90BD000007073200002E000000"}
    commands = response_json["AuthP2Result"]["commands"]
    commands_inst = {}
    for i=1,#commands do commands_inst[i] = commands[i]["cmd"] end
    -- print("mb received commands")

    read_result = base_json(session_key,connection,customer_no,uid,transaction)
	read_result["kartOkuData"]={}
	ret = send_commands(commands_inst)
	for i=1,#ret do
		cmdArr = {cmd=ret[i],name="iso cmd"}
		read_result["kartOkuData"][i] = cmdArr
	end

	print(yellow("########").." STEP-7 : Which means.. "..yellow("########"))
    url = base_url.."ReadCardResult"
    response = requests.post{url, data=read_result,headers=headers}
    if debug_mod then debug_response(response) end

    local response_json = json.decode(response.text)
    response_json = response_json["ReadCardResultResult"]
    if string.match(response.text,"Hsm servis") then
        print("Well... Your Istanbulkart is probably bricked..")
        return
    end

    if next(response_json["instructionCommands"]) ~= nil then
        print("Found write instructions. This means there is a transaction waiting to be completed to add balance to the card. You can play with these commands. You dont need to send results of commands to the server.")
        print(inspect(response_json["instructionCommands"]))
    end
    -- commands = response_json["instructionCommands"]
    -- commands_inst = {}
    -- for i=1,#commands do
    --     commands_inst[i] = commands[i]["cmd"]
    -- end
    -- write_result = base_json(session_key,connection,customer_no,uid,transaction)
	-- write_result["kartYazVerifyCevap"]={}
	-- ret = send_commands(commands_inst)
	-- for i=1,#ret do
		-- cmdArr = {cmd=ret[i],name="iso cmd"}
		-- write_result["kartYazVerifyCevap"][i] = cmdArr

	-- end
    -- url = base_url.."WriteCardResult"
    -- response = requests.post{url, data=write_result,headers=headers}
    -- if debug_mod then
    --     debug_response(response)
    -- end
    -- print(inspect(response_json))
    print(success().."Transactions completed! Here is your card informations >")
    print(success().."Card balance : "..response_json["balance"])
    print(success().."Card status  : "..response_json["cardStatus"])


    -- And, perhaps disconnect?
    if not stayconnected then
        lib14a.disconnect()
    end

    --darkside
    -- brute force mac of inc command
    --

end
function send_commands(commands)
	returnCommands = {}
	for a = 1, #commands do
		r, err = send_apdu(commands[a],{i=false})
		if err then
			lib14a.disconnect()
			return oops(err)
		end
		r2 = show_data(r)
		returnCommands[a] = r2
	end
	return returnCommands

end
--- Picks out and displays the data read from a tag
-- Specifically, takes a usb packet, converts to a Command
-- (as in commands.lua), takes the data-array and
-- reads the number of bytes specified in arg1 (arg0 in c-struct)
-- and displays the data
-- @param usbpacket the data received from the device
function show_data(usbpacket)
    local cmd_response = Command.parse(usbpacket)
    local len = tonumber(cmd_response.arg1) *2
    --print("data length:",len)
    local data = string.sub(tostring(cmd_response.data), 0, len-4);
    print(ansicolors.red.."<< "..ansicolors.reset..data)
    return data
end

function send_apdu(rawdata, options)
    print(ansicolors.green..'>> '..ansicolors.reset..rawdata)

    local flags = lib14a.ISO14A_COMMAND.ISO14A_NO_DISCONNECT + lib14a.ISO14A_COMMAND.ISO14A_APDU

    local command = Command:newMIX{cmd = cmds.CMD_HF_ISO14443A_READER,
                                arg1 = flags, -- Send raw
                                -- arg2 contains the length, which is half the length
                                -- of the ASCII-string rawdata
                                arg2 = string.len(rawdata)/2,
                                data = rawdata}
    return  command:sendMIX(options.i)
end

main(args)
