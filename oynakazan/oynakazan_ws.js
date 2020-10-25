const Ably = require('ably')
const request = require("request")
const crypto = require('crypto');
const TelegramBot = require('node-telegram-bot-api');
const BOT_TOKEN = "";
const AUTH_TOKEN = "";
const bot = new TelegramBot(BOT_TOKEN, {polling: true});

let chatId;
bot.onText(/\/poll/, (msg, match) => {

    chatId = msg.chat.id;
    getContests()
    bot.sendMessage(chatId, "getting contests...");
});
bot.onText(/\/join (.*)/, (msg, match) => {
    var id = match[1]
    chatId = msg.chat.id;
    joinContest(id)
    //joinContest("instant")
    bot.sendMessage(chatId, "trying to join contest : " + id);
});

let tokenReq;
let channels;
let questions = {}

function decryptQuestion(question,key){

    let messageToDecrypt = Buffer.from(question, "base64")
    let Key = Buffer.from(key, "utf8");
    let iv = Buffer.from(key, "utf8");
    var decipher = crypto.createDecipheriv('aes-128-cbc', Key, iv);
    var decoded = decipher.update(messageToDecrypt,'base64','utf-8');
    decoded += decipher.final('utf-8');
    question_mes = JSON.parse(decoded)
    question_text = question_mes["question"] + "\n" + question_mes["options"][0] + ", " + question_mes["options"][1] + ", " + question_mes["options"][2]
    //question_text =+ question_mes["options"].join(",") 
    return question_text
}
let headers = {"Authorization":AUTH_TOKEN}



d = {"appVersion":"195","platform":"Android"}

let contests = {}

function setToHappen(fn, d, contestid){
    let floored = Math.floor(new Date().getTime()/1000)
    var t = d - floored
    console.log(t ,contestid)
    if (t>10){
        return setTimeout(fn, t*1000, contestid);
    }
}

function getContests(){
    const req = request.get("https://api.oynakazanapp.net/v1/contest/vip",{headers:headers,json:d}, function(err,res,body){

        //console.log(body)
        let contests = []
        let schedules = body
        mes = ""
        schedules.map(function(contest){
            cInfo = contest.contestInfo
            //console.log(cInfo)
            
            if(cInfo.hasOwnProperty("vipInfo")){    
                if(cInfo["vipInfo"]["requiredTicket"] == 0){
                    // console.log(cInfo["contestId"])
                    var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
                    d.setUTCSeconds(cInfo["contestTime"]);
                    timeStr = d.toLocaleString(cInfo["contestTime"]);
                    mes += "ID : " + cInfo["contestId"] + ", " + timeStr
                    mes += "\nTitle : " + cInfo["title"] + ", Prize : "+ cInfo["prize"] + "\n"
                    setToHappen(joinContest, cInfo["contestTime"]-100,cInfo["contestId"])
                }
            }
            else{
                var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
                d.setUTCSeconds(cInfo["contestTime"]);
                timeStr = d.toLocaleString(cInfo["contestTime"]);
                mes += "ID : " + cInfo["contestId"] + ", " + timeStr
                mes += "\nTitle : " + cInfo["title"] + ", Prize : "+ cInfo["prize"] + "\n"
                setToHappen(joinContest, cInfo["contestTime"]-100,cInfo["contestId"])
            }
        })
        
        
        bot.sendMessage(chatId, mes);
    })
}


function joinContest(contestid)
{

    const req = request.get("https://api.oynakazanapp.net/v1/contest/join/"+contestid,{headers:headers}, function(err,res,body){
        if (res.statusCode != 200){
            body = JSON.parse(body)
            if (body["errorCode"] == 1100){
                console.log("kayit yok. kayit olmaya calis "+contestid)
                request.put("https://api.oynakazanapp.net/v1/contest/vip/"+contestid+"/participate",{headers:headers},function(err,res,body){
                    body = JSON.parse(body)
                    if(res.statusCode == 200){
                        return joinContest(contestid)
                        
                    }
                    else if(res.statusCode == 1070){
                        console.log("sad")
                    }
                    else{
                        console.log(body)
                    }
                    
                })
            }
            console.log(body)
            return;
        }
        connectionInfo= JSON.parse(body)
        for (var i = 0, qs; i < connectionInfo["qItems"].length; i++) {
            qs = connectionInfo["qItems"][i]
            questions[ qs["key"] ] = qs.base64Value;
         }
        //console.log(questions)
        channels = connectionInfo["connectionInfo"]["msgHub"]["channelInfo"]
        tokenReq = connectionInfo["connectionInfo"]["msgHub"]["tokenRequest"]
        setTimeout(dothingy2,100)
    })
}


//joinContest()
let authToken;
function dothingy2(){
    let token = JSON.parse(tokenReq)
    //console.log(token)
    let keyName = JSON.parse(tokenReq)["keyName"]
    const req = request.get("http://onedio-a-fallback.ably-realtime.com/keys/"+keyName+"/requestToken",{json:token},function(err,res,body){
        authToken = body["token"]    
        setTimeout(dothingy3,100)
    })

}


function dothingy3(){

    var client = Ably.Realtime({token:authToken,environment:"onedio"})
    var contestPub = client.channels.get(channels["contestPub"]);  
    client.connection.on('connected', function() {
        console.log("Connected to client..")
        //console.log(questions["3abfae"])
      });
      //console.log(channels)
      var contestSub = client.channels.get(channels["contestSub"]);  
      contestSub.subscribe(function(message) {
        md = JSON.parse(message.data)
        console.log(message.name,message.data)
        if(message.name == "showQuestion"){
            //data={"ms":1587137544568,"pst":true,"k":"daa0f0","s":"b240d0db1f963feb","o":9,"sg":0,"ea":0.0,"winAward":null} id=Frb3Eptww8:0:0 name=showQuestion]
            console.log(decryptQuestion(questions[md["k"]],md["s"]))
            //data={"c":[0,1,2],"k":"7f586c","ms":1587420118626} name=sendChoice
            // contestPub.publish("sendChoice",data={"c":[0,1,2],"k":md["k"],"ms":md["ms"]+20000},function(err) {
            //     if(err) {
            //       console.log('publish failed with error ' + err);
            //     } else {
            //       console.log('sendChoice[+] : success');
            //     }
            // });
        }
        else if(message.name == "showAnswer"){
            answer = "Question key : " + md["s"] + " : " + md["k"] 
            answer += decryptQuestion(questions[md["k"]],md["s"])
            answer += "\nDogru cevap : " + md["a"]
            answer += "\nStats : " + md["st"]
            contestPub.publish("sendChoice",data={"c":[md["a"]],"k":md["k"],"ms":md["ms"]-20000},function(err) {
                if(err) {
                  console.log('publish failed with error ' + err);
                } else {
                  console.log('sendChoice[+] : success');
                }
            });
            bot.sendMessage(chatId,answer)
        }
        else{
            if(message.name == 'contestFinished'){
                bot.sendMessage(chatId, "contestfinished");
            }
            console.log(message.name,message.data)
        }
        
        

      });

      contestSub.history(function(err, messagesPage) {

        // if (messagesPage.items.length == 0){
        //     console.log("empty contestSub history..")
        // }
        // for(var i=0;i<messagesPage.items.length;i++){
        //     console.log(messagesPage.items[i])

        // }
        // console.log("Printing contestSub history..")
        // for(var i=0;i<messagesPage.items.length;i++){

        //     let curr = messagesPage.items[i]
        //     if (curr.name == "showAnswer"){
        //         let md = JSON.parse(curr.data)
        //         //console.log(curr)
        //         console.log(decryptQuestion(questions[md["k"]],md["s"]))
        //         console.log("Dogru cevap : " + md["a"])
        //         console.log("stats : " + md["st"])
        //         console.log("\n")
        //     }

        // }
      });
      var chatSub = client.channels.get(channels["chatSub"]);  
      chatSub.subscribe(function(message) {
        //console.log(message.name,message.data) 
      });

      var statsSub = client.channels.get(channels["statsSub"]);  
      statsSub.subscribe(function(message) {
        //console.log(message.name,message.data)
      });
      var privateChn = client.channels.get(channels["privateChn"]);  
      privateChn.subscribe(function(message) {
        console.log("wtf private")
        console.log(message.name,message.data)
      });


}
