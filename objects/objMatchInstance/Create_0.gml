#macro PORT 22566
#macro MAXCLIENTS 2
global.isServer = true;
scrNetworkMacros();
global.server = network_create_server(network_socket_tcp, PORT, MAXCLIENTS);
if (global.server < 0){
	//Failsafe code here
	
}

clients = {};
global.sockets = [];

ply1Pos = [0,0];
ply2Pos = [0,0];

handleData = function(){
	serverLog("Packet Being Handled!");
	var buff = async_load[?"buffer"];
	var sock = async_load[?"id"];
	var op = buffer_read(buff, buffer_u8);
	serverLog(op);
	switch(op){
		case NET.ADDPLAYER:
			serverLog("Player connected!");
			var ifSource = function(sock){
				serverLog("Sending player to generate!");
				var race = RACE.HUMAN;
				if(array_length(global.players) > 0){
					race = RACE.IMP;	
				}
				
				var opRace = RACE.HUMAN;
				if (race ==	RACE.HUMAN){
					opRace = RACE.IMP;	
				}
				if(array_length(global.players) > 0){
					addExistingOpponent(sock, global.players[0]);
				}
				addPlayer(sock, race);	
			}
			var ifNotSource = function(sock){
				serverLog("Sending player to generate!");
				var race = RACE.HUMAN;
				if(array_length(global.players) > 0){
					race = RACE.IMP;	
				}
				addOpponent(sock, race);
			}
			scrSendAllButSource(sock, ifSource, ifNotSource);
			break;
		case NET.KEY:
			serverLog("Key Received");
			var _up = buffer_read(buff, buffer_u8);
			var _down = buffer_read(buff, buffer_u8);
			var _left = buffer_read(buff, buffer_u8);
			var _right = buffer_read(buff, buffer_u8);
			var plyr = scrGetSockPlayer(sock);
			var mTar = plyr.getMTar(_up, _down, _left, _right);
			serverLog("Position: " + string(mTar));
			var plyrPos = {
				X : mTar[0][0],
				Y : mTar[0][1]
			}
			
			var ifNotSource = method(plyrPos, function(sock){
				return scrSendTarPos(sock, X, Y);
			});
			
			var ifSource = method(plyrPos, function(sock){
				return scrSendPlayerTarPos(sock, X, Y);
			});
			
			scrSendAllButSource(sock, ifSource, ifNotSource);
			
			//for(var i = array_length(global.sockets) - 1; i >= 0; --i){
			//	if (sock != global.sockets[i]){
			//		scrSendTarPos(global.sockets[i], mTar[0][0], mTar[0][1]);
			//	} else {
			//		scrSendPlayerTarPos(global.sockets[i], mTar[0][0], mTar[0][1]);
			//	}
			//}
			if(array_length(global.players) == 2){
				ply1Pos = global.players[0].mapPos;
				ply2Pos = global.players[1].mapPos;
			}
			break;
		case NET.MOVE:
			var _x = buffer_read(buff, buffer_u8);
			var _y = buffer_read(buff, buffer_u8);
			var ply = scrGetSockPlayer(sock);
			ply.X = _x;
			ply.Y = _y;
			//for(var i = array_length(global.sockets) - 1; i >= 0; --i){
			//	if (sock != global.sockets[i]){
			//		scrSendTarPos(global.sockets[i], ply.X, ply.Y);
			//	}
			//}
			
			var plyrPos = {
				X : mTar[0][0],
				Y : mTar[0][1]
			}
			
			var ifNotSource = method(plyrPos, function(sock){
				return scrSendTarPos(sock, X, Y);
			});
			
			var ifSource = function(sock){
				return;
			};
			
			scrSendAllButSource(sock, ifSource, ifNotSource);
			
			break;
		case NET.ADDCOMP:
			var comp = buffer_read(buff, buffer_string);
			var ply = scrGetSockPlayer(sock);
			ply.partyAdd(comp);
			
			var dat = {
				compAdd : comp	
			}
			
			var ifNotSource = method(dat, function(sock){
				return scrNetUpdateComps(sock, compAdd);
			});
			
			var ifSource = function(sock){
				return;
			};
			
			scrSendAllButSource(sock, ifSource, ifNotSource);
			
			//for(var i = array_length(global.sockets) - 1; i >= 0; --i){
			//	if (sock != global.sockets[i]){
			//		scrNetUpdateComps(global.sockets[i], comp);
			//	}
			//}
			serverLog(string(ply.team));
			break;
		case NET.STARTBATTLE:
			for(var i = array_length(global.sockets) - 1; i >= 0; --i){
				scrStartNetBattle(global.sockets[i]);
			}
			array_insert(global.battles, 0, [global.players[0].team, global.players[1].team]);
			instance_create_layer(0,0, "Instances", objNetBattleController);
			break;
		case NET.ACTION:
			var jstring = buffer_read(buff, buffer_string);
			var actionInfo = json_parse(jstring);
			actionInfo.player = scrGetSockPlayer(sock);
			serverLog(actionInfo.player);
			serverLog("Action Event Received!");
			serverLog(string(actionInfo));
			objNetBattleController.doNetAction(actionInfo);
			break;
		case NET.DOATTACK:
			var actInfo = json_parse(buffer_read(buff, buffer_string));
			var str = buffer_read(buff, buffer_u8);
			var final = buffer_read(buff, buffer_bool);
			
			var tTeam = objNetBattleController.battleInfo.team1;
			if (!scrCheckTeam(tTeam, actInfo.tar)){
				tTeam = objNetBattleController.battleInfo.team2;	
			}
			var target = tTeam[scrTeamCharGetInd(tTeam,actInfo.tar)];
			var data = {
				act : actInfo
			}
			scrSendAllSock(method(data, function(socket){
				scrNBDoAnim(socket, act);
			}));
			objNetBattleController.doAttack(actInfo.actor, actInfo.act, target, actInfo.team, str, final);
			break;
		case NET.DOSPELL:
			var actInfo = json_parse(buffer_read(buff, buffer_string));
			var str = buffer_read(buff, buffer_u8);
			var final = buffer_read(buff, buffer_bool);
			
			var tTeam = objNetBattleController.battleInfo.team1;
			if (!scrCheckTeam(tTeam, actInfo.tar)){
				tTeam = objNetBattleController.battleInfo.team2;	
			}
			var target = tTeam[scrTeamCharGetInd(tTeam,actInfo.tar)];
			var data = {
				act : actInfo
			}
			scrSendAllSock(method(data, function(socket){
				scrNBDoAnim(socket, act);
			}));
			objNetBattleController.doSpell(actInfo.actor, actInfo.act, target, actInfo.team, str, final);
			break;
		case NET.QTEMISS:
			var ftr = json_parse(buffer_read(buff, buffer_string));
			var final = buffer_read(buff, buffer_bool);
			objNetBattleController.doMiss(ftr, final);
			break;
	}
}

addPlayer = function(sock, race){
	if (array_length(global.players) < MAXCLIENTS){
		objGame.generatePlayer(sock, race);
		scrInitPlayerServ(sock, race);
	}
}

addOpponent = function(sock, race){
	scrInitNetPlayerServ(sock, race);
}

addExistingOpponent = function(sock, player){
	var opp = player.getSnapshot();
	scrInitExistingNetPlayerServ(sock, opp);
}