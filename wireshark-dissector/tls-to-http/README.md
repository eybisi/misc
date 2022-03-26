### dissector to make http from decrypted tls session

if you have pcapng file with tls session keys and wireshark can decrypt tls.applications data, you can use this dissector and python script to make pcap file with basic http packets. 

### Usage 

- run tshark with this dissector (add files to `Help->About->Folders->Personal Lua Plugins` folder)
- copy http logs
- run python script with http logs

### Why ?

IDS tools can parse http packets :)


### Todo

write log to file and read files from python script.........
