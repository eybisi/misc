import { log } from "./logger";
log('Starting')

var send_ = Module.findExportByName('WS2_32.dll','send')


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
   
  // Get an array of 18 random bytes where each byte is an integer from range [0,255] inclusive, where [0,255] 
  // is the range of 8-bit unsigned integers from `new Uint8Array(n)`
   
if(send_){
    var send_f = new NativeFunction(send_,'int',['pointer','pointer','int','int'])
    Interceptor.attach(send_,{
        onEnter: function (args) {
            
            //console.log(hexdump(args[1],{length:args[2].toInt32(),ansi:true}))
            // var blacklist_types = [0x1c,0x21,0x1b,0x22,0x47,2,0x23]
            var blacklist_types = [0x1000]
            var packet_data = args[1].readByteArray(args[2].toInt32())
            var packet_size = args[2].toInt32()
            if(packet_data instanceof ArrayBuffer){
                if(packet_size == 1){
                    return
                }
                if(packet_size>4){
                    var data_view = new DataView(packet_data)
                    var inside_size = data_view.getInt32(0,true)
                    if(inside_size+4 == packet_size && packet_size < 500){
                        //console.log('Kayra buffer!',packet_size)
                        var packet_type = data_view.getInt32(4,true)
                        if(packet_type == 0x5dc){
                            console.log('Bypass hardware ban')
                            
                            args[1].add(0x14).writeByteArray(generateRandom(80))
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                        }

                        if(blacklist_types.includes(packet_type)){
                            return
                        }
                        if(packet_type == 0x39){
                            // sell to npc
                            var item_count = data_view.getInt32(packet_size-4,true)
                            console.log('Sell slot id ',item_count)
                            // args[1].add(12).writeAnsiString('10001_0002')
                            //args[1].add(packet_size-4).writeByteArray([0x9,0x00,0x00,0x00])
                            //args[1].add(packet_size-4-4).writeByteArray([0x30,0x31,0x33,0x31])
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))

                            //args[1].add(packet_size-4).writeByteArray([0x5,0x00,0x00,0x00])

                            
                        }
                        if(packet_type == 66 ){
                            console.log('Trade Put items')
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                            // console.log('Printing forged packet') 
                            // //args[1].add(0x21).writeByteArray([0x30])
                            // args[1].add(0x22).writeByteArray([0x14])
                            // console.log(hexdump(args[1],{length:packet_size,ansi:true}))                                
                        }
                        if(packet_type == 62){
                            console.log('Upgrade')
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                            console.log('Printing forged packet') 
                            //args[1].add(0x21).writeByteArray([0x30])
                            args[1].add(0x22).writeByteArray([0x14])
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))                         
                        }
                        if(packet_type == 31){
                            //Bypass monster hit
                            args[1].writeByteArray([ 0x8,0x00,0x00,0x00,0x21,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
                        }
                        if(packet_type == 19){
                            var item_count = data_view.getInt32(packet_size-4,true)
                            console.log('Item slice packet')
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                            //forge
                            console.log('Printing forged packet') 
                            args[1].add(packet_size-4).writeByteArray([0x7f,0xff,0xff,0xff])
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                        }
                        if(packet_type == 11){
                            //forge
                            console.log('Printing forged packet') 
                            // args[1].add(0xc).writeByteArray([])
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))            
                        }

                        if(packet_type == 47){
                            console.log('Quest Accept')
                           
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                        }
                        if(packet_type == 49){
                            // this.type = 49
                            // this.gorevbitti_buf = args[1]
                            // this.gorevbitti_len = args[2].toInt32()
                            // this.gorevbitti_flag = args[3].toInt32()
                            // this.gorevbitti_sock = args[0]
                            console.log('Quest complete')
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                        }
                        if(packet_type == 68){
                            //Trade add money
                            var item_count = data_view.getInt32(packet_size-4,true)
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                            args[1].add(packet_size-4).writeByteArray([0xff,0xff,0xff,0x8f])
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))


                        }
                        if(packet_type == 0x38){
                            // get item from npc
                            var item_count = data_view.getInt32(packet_size-4,true)
                            console.log('Get item count ',item_count)
                            // args[1].add(packet_size-4).writeByteArray([0x00,0x00,0x00,0x80])
                            console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                            
                        }
                        if(packet_type == 0x50){
                            // banking 
                            var banking_type = data_view.getInt32(8,true)
                            var coin_count = data_view.getInt32(12,true)
                            
                            if(banking_type==1){
                                //give to bank
                                console.log('Give to bank : ',coin_count)
                                //args[1].add(packet_size-4).writeByteArray([0x00,0x00,0x00,0x80])
                                console.log(hexdump(args[1],{length:packet_size,ansi:true}))
                            }    
                            else{
                                console.log('Get from bank : ',coin_count)
                                //get from bank

                            }
                            
                        }
                        console.log(packet_type)
                        console.log(hexdump(packet_data,{length:packet_size,ansi:true}))
                        
                    }
                    
                }
            }
           

        },
        onLeave: function(retval){
            //sending new gorev
            // if(this.type == 49){
            //     console.log('sending gorev again')
            //     send_f(gorev_socket,gorev_buf,gorev_len,gorev_flag)
            //     send_f(this.gorevbitti_sock,this.gorevbitti_buf,this.gorevbitti_len,this.gorevbitti_flag)
            // }
            
            // this.gorev_buf = args[1]
            // this.gorev_len = args[2]
            // this.socket = args[0]
            // this.flags = args[3]
        }
    })
}

// var recv_ = Module.findExportByName('WS2_32.dll','recvfrom')

// if(recv_){
//     Interceptor.attach(recv_,{
//         onEnter: function (args) {
//             console.log(
//                 hexdump(args[1],{length:args[2].toInt32()})
//             )
//         },
//     })
// }