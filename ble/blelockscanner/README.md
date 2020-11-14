### BLEH 👀
Most of the bike and scooter ble locks works similar since they all share almost total of 3 ble sdk (omni.ble.library, com.sofi.blelocker, com.sunshine.blelibrary .. ) App gets static or dynamic password from server and opens up devices. This is template for scanning and opening ble 🔒s. 

- check your app and see if its same type of blelibrary as in this repo ( uses aes to encrypt communication & request/response command bytes ) 
- set LOCK_PASS and LOCK_AES
- in my case all devices had same devicename so I used devicename as a filter. If your target devices dont have common names, you can filter with service uuids by replacing TARGET_SERVICEUUID and uncommenting lines from [bucklehunter.py](bucklehunter.py)
- run `python bucklehunter.py`


#### TODO

add scanner delegate to check device info when device is found.

#### Requirements

- pwntools for log 
- bluepy for ble 


