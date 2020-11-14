from bluepy.btle import Peripheral,DefaultDelegate
from Crypto.Cipher import AES
from pwn import log,ui,context
        
# context.log_level = 'info'

class BLECommand:
    def __init__(self,isTokenReq:bool,isPassReq:bool,data:bytes):
        self.IsTokenReq = isTokenReq
        self.IsPassReq = isPassReq
        self.Data = data
    def isTokenRequired(self):
        return self.IsTokenReq
    def isPassRequired(self):
        return self.IsPassReq
    def getData(self):
        return self.Data


class Portunus :
    class PeripDelegate(DefaultDelegate):
        def __init__(self,Portunus,aeskey):
            self.portunus =Portunus 
            self.RESP_GET_BATTERY_SUCCESS = bytes([2,2,1])
            self.RESP_GET_BATTERY_FAIL = bytes([2,2,1,0xff-1])
            self.AES_KEY = aeskey
            self.RESP_TOKEN = bytes([6,2,8])
            self.RESP_UNLOCK_SUCCESS = bytes([5,2,1,0])
            self.RESP_UNLOCK_FAIL = bytes([5,2,1,1])
            self.LOCK_STATE_LOCKED = bytes([5,15,1,1])
            self.LOCK_STATE_UNLOCKED = bytes([5,15,1,0])
            self.AES = AES.new(self.AES_KEY,AES.MODE_ECB)
            DefaultDelegate.__init__(self)
        def handleNotification(self,cHandle,enc_data):
            try:
                data = self.AES.decrypt(enc_data)  
            except Exception as e:
                log.failure(f"Cant decrypt {enc_data} with {self.AES_KEY} err: {e}")
                return
            log.debug(f'Notification received from: {cHandle} \nenc_data: {enc_data}\ndata: {data}')
            if data.startswith(bytes([0xcb])):
                log.success("received : withResponse of last command")
            elif data.startswith(self.RESP_GET_BATTERY_FAIL):
                log.failure(f"received: GET BATTERY FAIL")
            elif data.startswith(self.RESP_GET_BATTERY_SUCCESS):
                log.success(f"received: GET BATTERY SUCCESS {data}")
            elif data.startswith(self.RESP_TOKEN):
                log.success(f"received: TOKEN RECEIVED ! {data[3:7]}")
                self.portunus.assign_token(data[3:7])
            elif data.startswith(self.RESP_UNLOCK_SUCCESS):
                log.success("received: UNLOCKED")
            elif data.startswith(self.RESP_UNLOCK_FAIL):
                log.failure("received: UNLOCK FAILED")
            elif data.startswith(self.LOCK_STATE_LOCKED):
                log.success("received: LOCK STATE : LOCKED")
            elif data.startswith(self.LOCK_STATE_UNLOCKED):
                log.success("received: LOCK STATE : UNLOCKED")
            else:
                print(f"Unknown data {data}")
            

    def __init__(self,device:Peripheral,lockpass:bytes,aeskey:bytes):

        self.delegate = Portunus.PeripDelegate(self,aeskey)
        self.device = device
        self.token = bytes([0,0,0,0])
        self.device.setDelegate(self.delegate)
        self.SERVICE_UUID = "0000fee7-0000-1000-8000-00805f9b34fb"
        self.READ_FROM = "000036f6-0000-1000-8000-00805f9b34fb"
        self.WRITE_TO = "000036f5-0000-1000-8000-00805f9b34fb"
        self.ENABLE_NOTIF = "00002902-0000-1000-8000-00805f9b34fb"
        self.AES_KEY = aeskey
        self.AES = AES.new(self.AES_KEY,AES.MODE_ECB)
        self.LOCK_PASS = lockpass
        self.REQ_TOKEN = BLECommand(False,False,bytes([6,1,1,1]))
        self.GET_BATTERY = BLECommand(True,False,bytes([2,1,1,1]))
        self.UNLOCK = BLECommand(True,True,bytes([5,1,6]))
        self.GET_LOCK_STATE = BLECommand(True,False,bytes([5,14,1,1]))
        self.set_notification_enabled()
        self.request_token()

    def set_notification_enabled(self):
        svc = self.device.getServiceByUUID(self.SERVICE_UUID)
        ch = svc.getCharacteristics()
        for c in ch:
            if c.uuid == self.READ_FROM:
                ch_handle = c.getHandle()
                log.warn(f'Set notification enable for UUID : {c.uuid}, handle : {ch_handle+1}')
                self.device.writeCharacteristic(ch_handle+1,b"\x01\x00",withResponse=True)
                break
        


    def wait_for_notification(self):
       with log.progress('Waiting for notification') as p:
           while True:
                if self.device.waitForNotifications(1.0):
                    break
                p.status("..")

    def assign_token(self,token):
        self.token = token
        log.warn(f'Got token {token}! First lets check LOCK_STATE')
        self.get_lock_state()
        log.warn(f'Gonna unlock anyway')
        self.unlock()
        log.warn(f'Just for fun get Battery level')
        self.get_battery()

    def send_command(self,command:BLECommand):
        data_to_send = command.getData()
        if command.isPassRequired():
            data_to_send += self.LOCK_PASS
        if command.isTokenRequired():
            data_to_send += self.token 
        if len(data_to_send) < 16:
            data_to_send += bytes(range(len(data_to_send),16))

        assert len(data_to_send)==16
        log.debug(f"sending bytes {data_to_send}")
        enc_data = self.AES.encrypt(data_to_send)
        log.debug(f"sending encrypted bytes {enc_data}")
        ch = self.device.getCharacteristics(uuid=self.WRITE_TO)[0]
        ch.write(enc_data,True)
        self.wait_for_notification()
        self.wait_for_notification()


    def get_battery(self):
        log.info("sending command : GET_BATTERY")
        self.send_command(self.GET_BATTERY)

    def unlock(self):
        log.info("sending command : UNLOCK")
        self.send_command(self.UNLOCK)

    def get_lock_state(self):
        log.info("sending command : GET_LOCK_STATE")
        self.send_command(self.GET_LOCK_STATE)

    def request_token(self):
        log.info("sending command : REQUEST_TOKEN")
        self.send_command(self.REQ_TOKEN)
