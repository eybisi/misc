local json = require 'json'
funcs = {}
udp_funcs = {}
udp_funcs[61]="sub_12B2CC0 clock"
udp_funcs[3] ="readInUdp"
udp_funcs[5] ="latencycheck"
udp_funcs[7] ="sendstate"
udp_funcs[4] ="loopUdp"
udp_funcs[5300] = "gameStateReceivedFromUDP" -- 0x14b4
udp_funcs[5001] = "Game::sendState" -- 0x1389
--from server
funcs[5506]="Server->Client prepareGame"
funcs[305]="Server->Client prepareGame"
funcs[306]="Server->Client prepareGame"
funcs[308]="Server->Client prepareGame"

funcs[331]="Server->Client listener"
funcs[5620]="Server->Client listener"
funcs[5512]="Item Used"
funcs[5508]="Server->Client listener"
funcs[308]="Server->Client listener"
funcs[5619]="Server->Client listener"
funcs[5617]="Server->Client listener"
funcs[5615]="Server->Client listener"
funcs[5515]="Server->Client listener"
funcs[5504]="Server->Client listener"
funcs[5004]="Server->Client listener"
funcs[5513]="Server->Client listener"
funcs[5502]="Server->Client listener"
funcs[5508]="Server->Client listener"

funcs[0]="Server->Client listener"
funcs[1]="Server->Client listener"
funcs[10]="Server->Client listener"
funcs[6]="Server->Client listener"
funcs[7]="Server->Client listener"
funcs[5700]="ping"
funcs[5513]="Server->Client listener"
funcs[5502]="Server->Client listener"
funcs[5508]="Server->Client listener"
--
funcs[5002]="Game:useItem"
funcs[5506]="Game::step"
funcs[7738]="Game::endGame"
funcs[7502]="SuperPowerManager::setSelectedSuperPower"
funcs[300]="Game::makeMatchmakingRequest"
funcs[6]="heartbeat"
funcs[5003]= "Game::onPopupSelectItemsClosed"
funcs[5004]= "Game::sendJsonToOtherPlayer"
funcs[5503]= "Game::onPopupSelectItemsClosed"
funcs[5806]="cmdAES, onReceiveMatchRequest"
funcs[6108]="cmdAES, AdManager::checkForOfferwallEarnings"
funcs[1005]="cmdAES, getNumberOfMessagesSinceLastMessage"
funcs[1001]="cmdAES, fetchAllMessages"
funcs[1002]="cmdAES, sendMessage"
funcs[8005]="cmdAES, sendMessageUsingLobby"
funcs[5808]="cmdAES, checkAutoAcceptMatchRequest"
funcs[101]="cmdAES, createNewAccount"
funcs[104]="cmdAES, loginWithGameServices"
funcs[104]="cmdAES, loginWithGameServices"

funcs[7720]="cmdAES, IAPManager::purchaseConcluded"
funcs[7799]="cmdAES, IAPManager::purchaseConcluded"
funcs[7802]="cmdAES, IAPManager::purchaseConcluded"
funcs[7815]="cmdAES, IAPManager::purchaseConcluded"
funcs[7832]="cmdAES, IAPManager::purchaseConcluded"
funcs[7610]="cmdAES, IAPManager::purchaseConcluded"
funcs[7625]="cmdAES, IAPManager::purchaseConcluded"
--funcs[5506]="cmdAES, sub_EE7558"
funcs[5801]="cancelMatchRequest"
funcs[5601]="sub_EC0B08"
funcs[1006]="ChatHandler::setLastMessageRead"
funcs[6017]="PopupFreeGold::setUp"
funcs[5505]="Game::onAllPlayersConnected"
funcs[400]="fetchServerTime"
funcs[7500]="superPowerManager::onlyFetchPowers"
funcs[7710]="updateAdvertisementLevel"
funcs[9000]="fetchAchievementData"
funcs[5613]="onEnterTransitionDidFinish"
funcs[5619]="sub_EC70B8"
funcs[5616]="sub_EBB954"
funcs[5614]="sub_EC6534"
funcs[5618]="sub_EB82B0 : energyvouchyper init"
funcs[7746]="fetchBrandingData"
funcs[7755]="collectCampaignReward"
funcs[7814]="CharacterUpgradeBundle::Manager::fetchData"
funcs[7626]="fetchBundles"
funcs[7627]="purchaseBundleWithCurrency"
funcs[7806]="sendPossibleBundleIdRequest"
funcs[7758]="fetchCareerStepsData"
funcs[7759]="fetchUserCareerInfo"
funcs[7761]="fetchCareerTop1000"
funcs[7504]="fillVouchers"
funcs[7774]="sendSkillCardAction"
funcs[7775]="fetchUpgradeKeyData"
funcs[7773]="fetchAllSkillCardData"
funcs[7773]="fetchPagedSkillCardData"
funcs[7773]="fetchSkillCardInfo"
funcs[7750]="openChest"
funcs[7748]="fetchChests"
funcs[7749]="fetchOwnedChestCounts"
funcs[6021]="CrownBallManager::fetchData"
funcs[6022]="openCrownBag"
funcs[7797]="fetchProducts"
funcs[7798]="collectPrize"
funcs[7807]="fetchMissionsConfig"
funcs[7808]="collectReward"
funcs[7620]="DailyRewardManager::fetchData"
funcs[7620]="DailyRewardManager::collectReward"
funcs[7504]="fillEnergy"
funcs[7999]="7716,7735|fetchEvents"
funcs[7716]="getUpdatedGlobalRaceData"
funcs[7751]="getEventRankList"
funcs[7717]="joinGlobalRace"
funcs[7764]="watchedVideoToJoinGlobalRace"
funcs[7644]="AES | videoReward::sendtoserver"
funcs[7765]="collectDailyReward"
funcs[5615]="onFriendsInvited"
funcs[7812]="fetchProgressVideoRewardCardData"
funcs[7723]="FriendManager::fetchGameFriendsPage"
funcs[7722]="FriendManager::getFriendRequests"
funcs[7116]="FriendManager::updateOnlineFriends"
funcs[7721]="FriendManager::searchFriend"
funcs[7720]="FriendManager::removeOrRejectFriend"
funcs[7720]="FriendManager::requestFriendship"
funcs[7720]="FriendManager::acceptFriend"
funcs[7720]="FriendManager::rejectAllRequests"
funcs[7720]="FriendManager::acceptAllRequests"
funcs[7767]="GachaManager::fetchAllProducts"
funcs[7775]="GachaManager::fetchSingleGachaCardData"
funcs[7768]="GachaManager::fetchUserOwnProducts"
funcs[7768]="GachaManager::fetchUserOwnProduct"
funcs[7766]="GachaManager::fetchOwnedGachaPacks"
funcs[7771]="GachaManager::sendUserProductAction"
funcs[7606]="GachaManager::fetchMetrics"
funcs[5603]="Game::matchDataCall"
funcs[203]="Game::appConnectToMatch"
funcs[5603]="Game::endGame"
funcs[5603]="Game::fetchProfileData"
funcs[5000]="Game::checkNewVersion"
funcs[7780]="IAPManager::fetchCurrencyConversionRates"
funcs[7642]="InboxManager::fetchData"
funcs[7622]="InboxManager::fetchRewards"
funcs[7623]="InboxManager::collectReward"
funcs[7897]="InboxManager::collectNewsReward"
funcs[7642]="InboxManager::fetchNewsDetail"
funcs[7744]="InvitationManager::getProgressData"
funcs[7745]="InvitationManager::getPlayers"
funcs[7724]="NotificationManager::sendFriendlyNotification"
funcs[7604]="upgradePlayerLevel"
funcs[7515]="cheatPlayerLevel"
funcs[7603]="getLevelupRewards"
funcs[7795]="EntranceController"
funcs[7796]="userDecisionCall"
funcs[9001]="collectReward"
funcs[7118]="fetchMatchHistory"
funcs[7757]="CC"
funcs[6026]="C8"
funcs[7628]="304"
funcs[7812]="Controller::fetchData"
funcs[7816]="Controller::fetchPromotions"
funcs[7817]="Controller::sendCodeCALL"
funcs[7643]="RewardedVideoManager::fetchData"
funcs[7637]="fetchLastSeasonData"
funcs[7634]="SeasonManager::fetchData"
funcs[7635]="fetchLastSeasonChampionData"
funcs[6003]="fetchOnlines"
funcs[7635]="seasontop10::fetch"
funcs[201]="reconnectSuccess"
funcs[201]="connectToLobby"
funcs[151]="SpecialProductManager::fetchSpecialProductData"
funcs[7621]="SpecialProductManager::buySpecialProduct"
funcs[7605]="fetchStadiumDetails"
funcs[210]="StatisticsPackage::send"
funcs[210]="StatisticsPackage::sendRapidly"
funcs[7503]="SuperPowerManager::upgradeSuperPower"
funcs[7503]="SuperPowerManager::downgradeSuperPower"
funcs[7633]="SuperPowerManager::purchaseSuperPowerPacket"
funcs[7501]="134"
funcs[7801]="Supervisor::Manager::cmd"
funcs[7802]="Supervisor::Manager::cmdStore"
funcs[7702]="fetchTeamData"
funcs[7702]="getTeamDetail"
funcs[7701]="TeamManager::createTeam"
funcs[7701]="TeamManager::updateTeam"
funcs[7702]="TeamManager::getAwaitingRequests"
funcs[7703]="TeamManager::getTeamRankList"
funcs[7703]="TeamManager::getTeamRankPage"
funcs[7743]="TeamManager::getTeamSuggestions"
funcs[7703]="TeamManager::searchTeamNextPage"
funcs[7703]="TeamManager::searchTeam"
funcs[7705]="TeamManager::quitTeam"
funcs[7705]="TeamManager::applyToTeam"
funcs[7705]="TeamManager::acceptInvite"
funcs[7705]="TeamManager::rejectInvite"
funcs[7705]="TeamManager::approveJoinRequest"
funcs[7705]="TeamManager::disapproveJoinRequest"
funcs[7705]="TeamManager::removeMember"
funcs[7705]="TeamManager::upgradeMember"
funcs[7705]="TeamManager::downgradeMember"
funcs[7705]="TeamManager::inviteToTeam"
funcs[7116]="updateOnline"
funcs[7116]="getOnlineCount"
funcs[7702]="getTeamDetail"
funcs[7737]="levelCompleted"
funcs[7736]="tournamenmanager::join"
funcs[7756]="watchedVideoToJoinTournament"
funcs[7757]="usersettings::setPermissionState"
funcs[5602]="saveCurrentCharacterStyle"
funcs[7713]="vanitymanager::fetchData"
funcs[7714]="buyVanityItem"
funcs[7824]="fetchDataTeam"
funcs[7825]="equipTeamVanity"
funcs[7742]="7C"
funcs[7504]="fillVouchers"
funcs[106]= "Delegate::fetchConfigFromServer"
funcs[7635]= "PopupChangeRank::load"

headb_protocol_tcp = Proto("hb2tcp",  "HeadBall2 TCP Protocol")
message_type = ProtoField.string("hb2tcp.type", "Type", base.ASCII)
message_sec = ProtoField.string("hb2tcp.second_packet", "Second part of long packet", base.ASCII)
mtype_int = ProtoField.int32("hb2tcp.type_int", "Type Number", base.DEC)
message_len= ProtoField.int32("hb2tcp.len"     , "Length"    , base.DEC)
unknown = ProtoField.int32("hb2tcp.unknown", "unknown",base.DEC)
headdata = ProtoField.string("hb2tcp.data", "Data",base.ASCII)
head_json = ProtoField.string("hb2tcp.json", "Jsondata",base.ASCII)



function add_json(tree,data)
  --local datatable,error = json.decode(data)
  --xpcall(  json.decode(data), myerrorhandler )
  local datatable = json.decode(data)
  for key, value in pairs(datatable) do
    if type(value) == "table" then
      local subtree = tree:add(key)
      local sub_table = json.encode(value)
      add_json(subtree,sub_table)
    else
      tree:add(tostring(key).." :",tostring(value))
    end
  end

end

headb_protocol_tcp.fields = { message_type, head_json, message_len,unknown,headdata,mtype_int,message_sec }

function headb_protocol_tcp.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end
  local subtree = tree:add(headb_protocol_tcp, buffer(), "HeadBall2 TCP Protocol Data")
  pinfo.cols.protocol = headb_protocol_tcp.name
  local msglen = buffer(5,4):le_int()
  local msgtype = buffer(0,4):le_int()
  if msgtype > 0xffff then
    subtree:add_le(message_sec,"SECOND PART")
    subtree:add_le(headdata,buffer())
    pinfo.cols.info = "#th part"
    return
  end
  local type_str = funcs[msgtype]
  
  if type_str == nil then type_str = "Unknown" end
  subtree:add_le(message_type, buffer(0,4),type_str):add_le(mtype_int,buffer(0,4),msgtype)
  subtree:add_le(unknown, buffer(4,1)):set_hidden()
  subtree:add_le(message_len,buffer(5,4))
  if msglen > 0 then
    if length == 1440 then
        subtree:add_le(headdata,buffer(9,1440-9))
    else
        --subtree:add_le(headdata,buffer(9,msglen))
        local jsontree = subtree:add("JSON")
        local status, retval = pcall(add_json,jsontree,buffer(9,msglen):string())
        if not status then
          subtree:add_le(headdata,buffer(9,msglen))
          jsontree:add("Are you sure its a json ? ",retval)
        end
    end
  end

  pinfo.cols.info = type_str
end

local tcp_port = DissectorTable.get("tcp.port")
tcp_port:add(110, headb_protocol_tcp)
tcp_port:add(37645, headb_protocol_tcp)



headb_protocol_udp = Proto("hb2udp",  "HeadBall2 UDP Protocol")
message_type_udp = ProtoField.string("hb2udp.type", "Type", base.ASCII)
message_type_udp_int = ProtoField.int32("hb2udp.type_int", "Type", base.DEC)
headb_score = ProtoField.string("hb2udp.score", "Score",base.ASCII)
headb_counttime = ProtoField.int32("hb2udp.score", "Counttime",base.DEC)
headb_gamestarted = ProtoField.bool("hb2udp.gamestarted", "Game started",base.BOOL)
headb_round = ProtoField.int32("hb2udp.round", "Round",base.DEC)
headb_time = ProtoField.string("hb2udp.time", "Time",base.ASCII)
headb_input = ProtoField.string("hb2udp.input", "Input",base.ASCII)
headb_x_y = ProtoField.int32("hb2udp.x_y", "X_Y",base.DEC)
headb_player = ProtoField.string("hb2udp.player", "Player",base.ASCII)
headb_data = ProtoField.bytes("hb2udp.data", "Data",base.BYTES)

headb_player_coordinates = ProtoField.float("hb2udp.coordinates", "Coordinate",base.FLOAT)
headb_protocol_udp.fields = { message_type_udp,headb_round,headb_x_y,headb_input,message_type_udp_int,headdata_udp,headb_counttime,headb_score,headb_data,headb_player,headb_player_coordinates,headb_time,headb_gamestarted }

inputs = {}
inputs[0] = "Still"
inputs[1] = "Left"
inputs[2] = "Right"
inputs[4] = "Jump"
inputs[6] = "Jump right"
inputs[5] = "Jump left"

inputs[8] = "Kick Up"
inputs[9] = "Kick left"
inputs[10] = "Kick right"
inputs[16] = "Kick Normal"



function headb_protocol_udp.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end
  local subtree = tree:add(headb_protocol_udp, buffer(), "HeadBall2 UDP Protocol Data")
  local msgtype = buffer(8,2):le_int()
  subtree:add_le(message_type_udp,buffer(8,4),udp_funcs[msgtype]):add_le(message_type_udp_int,buffer(0,4),msgtype)
  pinfo.cols.protocol = headb_protocol_udp.name  
  --subtree:add_le(headb_data,buffer(17))

  if msgtype == 5001 then -- sendstate
    local idx = buffer(17,1):int()
    local input = inputs[idx]
    if input == nil then input ="Unknown input : "..tostring(idx) end
    subtree:add_le(headb_input,input)
    subtree:add_le(headb_x_y,buffer(18,1))
    subtree:add_le(headb_x_y,buffer(19,1))

    pinfo.cols.info ="Sent: "..input.." X:"..tostring(buffer(18,1):int()).." Y:"..tostring(buffer(19,1):int())
  
  elseif msgtype == 5300 then -- receivestate


    subtree:add_le(headb_gamestarted,buffer(17,1))
    subtree:add_le(headb_round,buffer(18,1))    
    local score_1 = buffer(17+4,1):int()
    local score_2 = buffer(17+7,1):int()
    local score_text = tostring(score_1).." "..tostring(score_2)
    subtree:add_le(headb_score,score_text)
    subtree:add_le(headb_time,tostring(buffer(18+26,1):int()))
    subtree:add_le(headb_counttime,tostring(buffer(18+27,1):int()))
    local player1 = subtree:add_le(headb_player,"1")
    local p1x = buffer(19,1):int()
    local p1y = buffer(20,1):int()
    player1:add_le(headb_player_coordinates,p1x)
    player1:add_le(headb_player_coordinates,p1y)
    local player2= subtree:add_le(headb_player,"2")
    local p2x = buffer(22,1):int()
    local p2y = buffer(23,1):int()
    player2:add_le(headb_player_coordinates,p2x)
    player2:add_le(headb_player_coordinates,p2y)
    infor = "Received:"
    if buffer(18+27,1):int() ~= 0 then infor = infor.." Countdown : "..tostring(buffer(18+27,1):int()) end
    infor_n=infor.." Time: "..tostring(buffer(18+26,1):int()).." Score "..score_text.." Player 1  X:"..tostring(p1x).." Y:"..tostring(p1y).." Player 2  X:"..tostring(p2x).." Y:"..tostring(p2y)
    pinfo.cols.info = infor_n 
    --subtree:add_le(headb_score,buffer(17))
  else
    pinfo.cols.info = udp_funcs[msgtype]
  end

end

local udp = DissectorTable.get("udp.port")
udp:add(1433, headb_protocol_udp)
