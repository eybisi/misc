### dissector to make http from decrypted tls session

if you have pcapng file with tls session keys and wireshark can decrypt tls.applications data, you can use this dissector and python script to make pcap file with basic http packets. 

### Usage 

- run tshark with this dissector `tshark -r com_dismiss_ten.pcap -X lua_script:tls-to-http.lua -X lua_script1:stripped.txt`  (add files to `Help->About->Folders->Personal Lua Plugins` folder)
- copy http logs
- run python script with http logs

```python
    h = HttpStripper(f"stipped_output.pcap")
    if h.parse_http_file('stripped.txt'):
        print('success')
```


### Why ?

IDS tools can parse http packets :)


### Todo

write log to file and read files from python script.........
