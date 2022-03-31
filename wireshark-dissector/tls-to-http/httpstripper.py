import time
import socket
import struct
import json

class HttpStripper:
    def __init__(self,output_pcap_name:str):
        self.pcap_filename = output_pcap_name
        self.pcap_handle = open(self.pcap_filename, "wb", 0)
        self.write_pcap_header()
    
    def parse_http_file(self,http_file:str):
        try:
            f = open(http_file,"r")
        except:
            print('stripped http file cannot be found',http_file)
            return False
        http_lines = open(http_file,"r").readlines()
        for line in http_lines:
            tp = json.loads(line) 
            bl = [ bytes.fromhex(x) for x in tp["http_raw"].split(":")]
            tp["http_raw"] = bl
            tp["frame_time"] = int(tp["frame_time"].split(".")[0])
            self.write_to_pcap(tp["frame_time"],tp["http_raw"],tp["src_addr"],tp["dst_addr"],tp["src_port"],tp["dst_port"],tp["seq_num"],tp["ack_num"])
        self.pcap_handle.close()
        return True

    def write_to_pcap(self,t:int,data:list,src_addr:str,dst_addr:str,src_port:int,dst_port:int,seq:int,ack:int):
        if len(data)>65535:
            print('Data is so large')
            print('Download module ? ,partial http ?')
            return
        for writes in (
            # PCAP record (packet) header
            ("=I", int(t)),                        # Timestamp seconds
            ("=I", int((t * 1000000) % 1000000)),  # Timestamp microseconds
            ("=I", 40 + len(data)),           # Number of octets saved
            ("=i", 40 + len(data)),           # Actual length of packet
            # IPv4 header
            (">B", 0x45),                     # Version and Header Length
            (">B", 0),                        # Type of Service
            (">H", 40 + len(data)),           # Total Length
            (">H", 0),                        # Identification
            (">H", 0x4000),                   # Flags and Fragment Offset
            (">B", 0xFF),                     # Time to Live
            (">B", 6),                        # Protocol
            (">H", 0),                        # Header Checksum
            (">I", int.from_bytes(socket.inet_aton(src_addr),byteorder='big')),                 # Source Address
            (">I", int.from_bytes(socket.inet_aton(dst_addr),byteorder="big")),                 # Destination Address
            # TCP header
            (">H", src_port),                 # Source Port
            (">H", dst_port),                 # Destination Port
            (">I", seq),                      # Sequence Number
            (">I", ack),                      # Acknowledgment Number
            (">H", 0x5018),                   # Header Length and Flags
            (">H", 0xFFFF),                   # Window Size
            (">H", 0),                        # Checksum
            (">H", 0)):                       # Urgent Pointer
            self.pcap_handle.write(struct.pack(writes[0], writes[1]))
        self.pcap_handle.write(b''.join(data))

    def write_pcap_header(self):
        for writes in (
                ("=I", 0xa1b2c3d4),     # Magic number
                ("=H", 2),              # Major version number
                ("=H", 4),              # Minor version number
                ("=i", time.timezone),  # GMT to local correction
                ("=I", 0),              # Accuracy of timestamps
                ("=I", 65535),          # Max length of captured packets
                ("=I", 228)):           # Data link type (LINKTYPE_IPV4)
            self.pcap_handle.write(struct.pack(writes[0], writes[1]))


