local json = require 'json'
strip_ssl_protocol = Proto("dumtektek",  "wtf")
local frame_time = Field.new("frame.time_epoch")
local src_addr = Field.new("ip.src")
local dst_addr = Field.new("ip.dst")
local src_port = Field.new("tcp.srcport")
local dst_port = Field.new("tcp.dstport")
local seq_num = Field.new("tcp.seq_raw")
local ack_num = Field.new("tcp.ack_raw")
local args = { ... } 
if #args ~= 1 then
    print('give output file name with -X lua_script1:filename')
    return
end
local output_file_name = args[1]
strip_ssl_protocol.prefs.text = Pref.statictext("writen in hell")
local function getstring(finfo)
    local ok, val = pcall(tostring,finfo)
    if not ok then val = "(unknown)" end
    return val
end


function strip_ssl_protocol.dissector(buffer, pinfo, tree)
    if pinfo.dst_port ~= 443 and pinfo.src_port ~= 443 then
        return
    end
    local fields = { all_field_infos() }
    -- print(fields)
    output = ""
    http_res = nil
    found_tls = false
    found_http = false
    for ix, finfo in ipairs(fields) do
        if finfo.name == "tls" then
            found_tls = true
        end
        if finfo.name == "http" then
            found_http = true
            http_res = finfo
        end
    end
    --print(output)
    if found_http and found_tls then
        a = {}        
        a["frame_time"] = tostring(frame_time())
        a["src_addr"] = tostring(src_addr())
        a["dst_addr"] = tostring(dst_addr())
        a["src_port"] = tonumber(tostring(src_port()))
        a["dst_port"] = tonumber(tostring(dst_port()))
        a["seq_num"] = tonumber(tostring(seq_num()))
        a["ack_num"] = tonumber(tostring(ack_num()))
        a["http_raw"] = tostring(http_res)
        enc  = json.encode(a)
        local output_file = io.open(output_file_name,"a")
        io.output(output_file)
        io.write(enc .. "\n")
        io.close(output_file)
        --print(http_h())
    end
    return 1
end

register_postdissector(strip_ssl_protocol)
print('loading dumtektek')

