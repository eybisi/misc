
import { log } from "./logger";

log('Starting')
var Color = {
    Reset: "\x1b[39;49;00m",
    Black: "\x1b[30;01m", Blue: "\x1b[34;01m", Cyan: "\x1b[36;01m", Gray: "\x1b[37;11m",
    Green: "\x1b[32;01m", Purple: "\x1b[35;01m", Red: "\x1b[31;01m", Yellow: "\x1b[33;01m",
    Light: {
        Black: "\x1b[30;11m", Blue: "\x1b[34;11m", Cyan: "\x1b[36;11m", Gray: "\x1b[37;01m",
        Green: "\x1b[32;11m", Purple: "\x1b[35;11m", Red: "\x1b[31;11m", Yellow: "\x1b[33;11m"
    }
};

var send_ = Module.findExportByName('WS2_32.dll','send')
var connect_ = Module.findExportByName('WS2_32.dll','connect')
var recv_ = Module.findExportByName('WS2_32.dll','recv')

function getRandomInt(min:number, max:number) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min); //The maximum is exclusive and the minimum is inclusive
  }
  
function generateRandom(length:number) {
    var random_arr = []
    for(var i =0;i<length;i++){
        random_arr[i] = getRandomInt(0,255)
    }
    return random_arr
}

if(connect_){
    
    Interceptor.attach(connect_,{
        onEnter: function (args) {
            //console.log('WS2_32.dll','send')
            var fd = args[0].toInt32();
            // console.log(fd)
            var address = Socket.localAddress(fd);
            // send(address)
            //console.log(fd, ex.name, address.ip + ':' + address.port);
            //console.log("Connect called")
        },

    })
}

function decencBuffer(buffer:ArrayBuffer){
    const view =  new Uint8Array(buffer)
    const xorarr = new Uint8Array([250,158,179])
    const xored_array = new Array()
    for (let index = 0; index < view.length; index++) {
        const element = view[index]^xorarr[index%3];
        xored_array.push(element)
    }
    return xored_array
}


if(send_){
    Interceptor.attach(send_,{
        onEnter: function (args) {
            // check if its AQ3D request.
            // One way to check is, taking first 2 bytes and comparing against
            // known cmd and type numbers
            const buffer_length = args[2].toInt32()
            if(buffer_length == 1) {
                return
            }
            const aq3d_check = args[1].readByteArray(2)
            if(aq3d_check instanceof ArrayBuffer){
                const aq3d_type = new Uint8Array(aq3d_check,0,1)[0]^250
                const aq3d_cmd = new Uint8Array(aq3d_check,1,1)[0]^158
                if(aq3d_cmd > 22 || aq3d_type > 37){
                    return
                }

            }
            
            const buffer = args[1].readByteArray(buffer_length)
            if(buffer instanceof ArrayBuffer){
                const xored_view = decencBuffer(buffer)
                const packet_type = xored_view[0]
                const packet_cmd = xored_view[1]
                if(packet_cmd == 1 && packet_type == 37){
                    //Ping
                    return
                }
                if(packet_cmd == 2 && packet_type == 11){
                    //Item sell
                    const forged = new Uint8Array([packet_type,packet_cmd,0x7b,0x22,0x43,0x68,0x61,0x72,0x49,0x74,0x65,0x6d,0x49,0x44,0x22,0x3a,0x33,0x2c,0x22,0x51,0x74,0x79,0x22,0x3a,0x35,0x2c,0x22,0x74,0x79,0x70,0x65,0x22,0x3a,0x31,0x31,0x2c,0x22,0x63,0x6d,0x64,0x22,0x3a,0x32,0x7d]).buffer
                    console.log(hexdump(args[1],{length:xored_view.length,ansi:true}))
                    if(forged instanceof ArrayBuffer){
                        const encrypted_forge = decencBuffer(forged)
                        args[1].writeByteArray(encrypted_forge)
                    }
                    const total_length = 2 + '{"CharItemID":14,"Qty":1,"type":11,"cmd":2}'.length
                    console.log(hexdump(args[1],{length:xored_view.length,ansi:true}))
                }
                if(packet_cmd == 1 && packet_type == 11){
                    //Item buy from shop
                    const forged = new Uint8Array([packet_type,packet_cmd,0x7b,0x22,0x53,0x68,0x6f,0x70,0x49,0x44,0x22,0x3a,0x32,0x35,0x33,0x2c,0x22,0x49,0x74,0x65,0x6d,0x49,0x44,0x22,0x3a,0x31,0x38,0x39,0x33,0x2c,0x22,0x51,0x74,0x79,0x22,0x3a,0x30,0x2c,0x22,0x74,0x79,0x70,0x65,0x22,0x3a,0x31,0x31,0x2c,0x22,0x63,0x6d,0x64,0x22,0x3a,0x31,0x7d]).buffer
                    console.log(hexdump(args[1],{length:xored_view.length,ansi:true}))
                    if(forged instanceof ArrayBuffer){
                        const encrypted_forge = decencBuffer(forged)
                        args[1].writeByteArray(encrypted_forge)
                    }
                    
                    const total_length = 2 + '{"CharItemID":14,"Qty":1,"type":11,"cmd":2}'.length
                    console.log(hexdump(args[1],{length:xored_view.length,ansi:true}))
                }
                //Coordinate
                if(packet_type == 1 && (packet_cmd ==2 || packet_cmd == 1 || packet_cmd == 4)){
                    return
                }
                let formatted_msg = xored_view.slice(2).map(obj=>{
                    return String.fromCharCode(obj)
                }).join('')

                if(packet_type == 11 && (packet_cmd == 1 && packet_cmd == 2)){
                    console.log(Color.Green + "SEND:" + Color.Yellow + " "+formatted_msg + Color.Reset)
                }
                else{
                    console.log(Color.Red + "SEND:" + Color.Yellow + " "+formatted_msg + Color.Reset)
                }
                          
                // const back_buffer = new Uint8Array(xored_view).buffer
                // if(back_buffer instanceof ArrayBuffer){
                //     console.log(hexdump(back_buffer,{length:xored_view.length,ansi:true}))
                // }

               
            }
            
            
        },
        onLeave: function(retval){

        }
    })
}


if(recv_){
    Interceptor.attach(recv_,{
        onEnter: function (args) {
            this.data_buf = args[1]
        },
        onLeave: function(retval){
            
            if(retval.toInt32() == -1){
                return
            }
            if(retval.toInt32() == 1){
                return
            }
            //console.log(hexdump(this.data_buf,{length:retval.toInt32(),ansi:true}))
            const buffer = this.data_buf.readByteArray(retval.toInt32())
            if(buffer instanceof ArrayBuffer){
                const view =  new Uint8Array(buffer)
                const xorarr = new Uint8Array([250,158,179])
                const xored_view = new Array()
                for (let index = 0; index < view.length; index++) {
                    const element = view[index]^xorarr[index%3];
                    xored_view.push(element)
                }
                const packet_type = xored_view[0]
                const packet_cmd = xored_view[1]
                //console.log(packet_cmd,packet_type)
                if(packet_cmd == 1 && packet_type == 37){
                    //Ping
                    return
                }
                //Coordinate
                if(packet_type == 1 && (packet_cmd ==2 || packet_cmd == 1 || packet_cmd == 4)){
                    return
                }
                else{
                    
                    let formatted = xored_view.slice(2).map(obj=>{
                        return String.fromCharCode(obj)
                    }).join('')
                    //console.log("RECV",formatted)
                }
                          
                // const back_buffer = new Uint8Array(xored_view).buffer
                // if(back_buffer instanceof ArrayBuffer){
                //     console.log(hexdump(back_buffer,{length:xored_view.length,ansi:true}))
                // }

               
            }
           
        }
    })
}