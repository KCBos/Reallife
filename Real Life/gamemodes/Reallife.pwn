// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT
#pragma dynamic 999999

#include <a_samp>
#include <sscanf2>
#include <a_mysql>
#include <ocmd>

#define Red 0xFF0000FF
#define Green 0x00CC00FF
#define Blue 0x0404FFFF
#define Pink 0xFE05BAFF
#define Aqua 0x00DDB0FF
#define Cyan 0x0FA4FDFF
#define Yellow 0xFBF400FF
#define White 0xFFFFFFFF

#define DIALOG_STYLE_PASSWORD (3)


mainhenk()
{
	print("\n----------------------------------");
	print(" Real Life Game mode Alpha V0.1");
	print("----------------------------------\n");
}


enum PlayerStats
{
	UserID[128],
	Username[128],
	Password[128],
	Score,
	Money,
	Team[128],
	TeamSalary,
	ALevel,
	WantedLevel,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:Angle
}

new Player[MAX_PLAYERS][PlayerStats];
new PayPlayerTimer[MAX_PLAYERS];

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	mysql_debug();
	mysql_connect("192.168.0.20", "root", "samp","12345");

	
	SetGameModeText("Real Life V. A0.1");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	
	AddStaticVehicleEx(402,1357.5000000,-1749.4000000,13.3000000,270.0000000,-1,122,0); //Buffalo
	AddStaticVehicleEx(475,1357.4000000,-1753.7000000,13.3000000,270.0000000,-1,58,0); //Sabre
	AddStaticVehicleEx(541,1346.9000000,-1752.8000000,13.1000000,0.0000000,-1,173,0); //Bullet
	AddStaticVehicleEx(474,1666.2000000,-1134.7000000,23.8000000,0.0000000,-1,26,0); //Hermes
	AddStaticVehicleEx(518,1657.4000000,-1134.9000000,23.7000000,180.0000000,-1,14,0); //Buccaneer
	AddStaticVehicleEx(445,1652.4000000,-1134.4000000,23.9000000,0.0000000,-1,103,0); //Admiral
	AddStaticVehicleEx(451,1343.1000000,-1752.5000000,13.1000000,0.0000000,-1,55,0); //Turismo
	AddStaticVehicleEx(401,1675.4000000,-1129.0000000,23.8000000,90.0000000,-1,103,0); //Bravura
	AddStaticVehicleEx(527,1656.9000000,-1084.9000000,23.7000000,270.0000000,-1,62,0); //Cadrona
	AddStaticVehicleEx(576,1675.6000000,-1115.6000000,23.7000000,270.0000000,-1,88,0); //Tornado
	AddStaticVehicleEx(491,1675.3000000,-1111.3000000,23.8000000,90.0000000,-1,25,0); //Virgo
	AddStaticVehicleEx(549,1648.4000000,-1080.6000000,23.8000000,270.0000000,-1,162,0); //Tampa
	AddStaticVehicleEx(506,1675.5000000,-1098.0000000,23.7000000,270.0000000,-1,142,0); //Super GT
	AddStaticVehicleEx(429,1617.2000000,-1137.1000000,23.7000000,270.0000000,-1,119,0); //Banshee
	AddStaticVehicleEx(602,1617.2000000,-1132.6000000,23.8000000,270.0000000,-1,10,0); //Alpha
	AddStaticVehicleEx(587,1617.1000000,-1123.8000000,23.7000000,90.0000000,-1,88,0); //Euros
	AddStaticVehicleEx(545,1622.0000000,-1107.3000000,23.9000000,270.0000000,-1,117,0); //Hustler
	AddStaticVehicleEx(567,1621.9000000,-1102.9000000,23.9000000,90.0000000,-1,155,0); //Savanna
	AddStaticVehicleEx(439,1621.5000000,-1094.0000000,23.9000000,270.0000000,-1,190,0); //Stallion
	AddStaticVehicleEx(491,1621.4000000,-1089.5000000,23.8000000,90.0000000,-1,31,0); //Virgo
	AddStaticVehicleEx(518,1630.0000000,-1102.9000000,23.7000000,270.0000000,-1,14,0); //Buccaneer
	AddStaticVehicleEx(426,1629.9000000,-1098.5000000,23.7000000,90.0000000,-1,58,0); //Premier
	AddStaticVehicleEx(526,1630.0000000,-1085.3000000,23.8000000,270.0000000,-1,14,0); //Fortune
	AddStaticVehicleEx(562,1630.2000000,-1089.6000000,23.7000000,90.0000000,-1,108,0); //Elegy
	AddStaticVehicleEx(549,1675.2002000,-1106.7998000,23.8000000,270.0000000,-1,162,0); //Tampa
	AddStaticVehicleEx(527,1675.4004000,-1124.7002000,23.7000000,270.0000000,-1,62,0); //Cadrona
	AddStaticVehicleEx(506,1649.3000000,-1102.6000000,23.7000000,90.0000000,-1,142,0); //Super GT
	AddStaticVehicleEx(477,1648.6000000,-1093.7000000,23.8000000,90.0000000,-1,37,0); //ZR-350
	AddStaticVehicleEx(547,1648.8000000,-1106.9000000,23.7000000,270.0000000,-1,58,0); //Primo
	AddStaticVehicleEx(517,1657.2000000,-1089.4000000,23.8000000,90.0000000,-1,58,0); //Majestic
	AddStaticVehicleEx(421,1657.0000000,-1098.0000000,23.9000000,270.0000000,-1,89,0); //Washington
	AddStaticVehicleEx(492,1657.0000000,-1106.9000000,23.8000000,90.0000000,-1,84,0); //Greenwood
	AddStaticVehicleEx(550,1657.5000000,-1111.4000000,23.8000000,270.0000000,-1,28,0); //Sunrise
	AddStaticVehicleEx(422,1592.9000000,-1056.5000000,24.0000000,306.0000000,-1,53,0); //Bobcat
	AddStaticVehicleEx(489,1590.1000000,-1053.4000000,24.3000000,128.0000000,-1,218,0); //Rancher
	AddStaticVehicleEx(589,1577.7000000,-1039.4000000,23.6000000,322.0000000,-1,98,0); //Club
	AddStaticVehicleEx(561,1574.1000000,-1036.7000000,23.8000000,142.0000000,-1,10,0); //Stratum
	AddStaticVehicleEx(500,1584.1000000,-1046.7000000,24.1000000,306.0000000,-1,46,0); //Mesa
	AddStaticVehicleEx(451,1564.1000000,-1030.5000000,23.7000000,164.0000000,-1,55,0); //Turismo
	AddStaticVehicleEx(491,1560.1000000,-1029.3000000,23.8000000,346.0000000,-1,98,0); //Virgo
	AddStaticVehicleEx(545,1558.9000000,-1011.4000000,23.9000000,356.0000000,-1,31,0); //Hustler
	AddStaticVehicleEx(467,1563.4000000,-1012.1000000,23.8000000,180.0000000,-1,119,0); //Oceanic
	AddStaticVehicleEx(535,1572.1000000,-1011.5000000,23.7000000,180.0000000,-1,68,0); //Slamvan
	AddStaticVehicleEx(603,1576.5000000,-1012.0000000,23.9000000,0.0000000,-1,100,0); //Phoenix
	AddStaticVehicleEx(527,1589.7000000,-1010.1000000,23.7000000,6.0000000,-1,32,0); //Cadrona
	AddStaticVehicleEx(410,1594.3000000,-1009.7000000,23.7000000,186.0000000,-1,55,0); //Manana
	AddStaticVehicleEx(534,1612.9000000,-1009.2000000,23.7000000,0.0000000,-1,117,0); //Remington


	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetSpawnInfo(playerid, 0, 0, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], Player[playerid][Angle], 0, 0, 0, 0, 0, 0 );
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new string[128], pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));
	format(string, sizeof(string), "%s joined the server", pName);
	SendClientMessageToAll(-1, string);
	
	new query[256];
	GetPlayerName(playerid, pName, sizeof(pName));
	format(query, sizeof(query), "SELECT * FROM players WHERE username = '%s'", pName);
	mysql_query(query);
	mysql_store_result();
	
	if (mysql_num_rows() == 1)
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_PASSWORD, "Login", "Welcome back to SA-MP Real-Life! \nPlease login", "Login", "Cancel");
	}
	else
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "Login", "Welcome to SA-MP Real-Life! \nPlease register your account, enter a password below", "Register", "Cancel");
	}
	
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SavePlayer(playerid);
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
	SetPlayerFacingAngle(playerid, Player[playerid][Angle]);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	GetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
	GetPlayerFacingAngle(playerid, Player[playerid][Angle]);

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

// Admin Commands

ocmd:setjob(playerid, params[]){
	new pID, jobID[128];

	if(sscanf(params, "is", pID, jobID)) return SendClientMessage(playerid, Cyan, "/setjob [Player ID] [Job ID]");
	if(Player[playerid][ALevel] >=2)
	{
		Player[pID][Team] = jobID;
		return 1;
	}
	else
	{
		return 1;
	}

}

ocmd:tp(playerid, params[])
{
	new pID, pID2, Float:x, Float:y, Float:z, Float:a;
	if(sscanf(params,"ii",pID, pID2)) return SendClientMessage(playerid, Cyan, "/tp [From ID] [To ID]");
	if(Player[playerid][ALevel] >=2)
	{
		GetPlayerPos(pID2, Float:x, Float:y, Float:z);
		GetPlayerFacingAngle(pID2, Float:a);
		
		new string[128], string2[128], pName[MAX_PLAYER_NAME], pName2[MAX_PLAYER_NAME], pName3[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName3, sizeof(pName3));
		GetPlayerName(pID2, pName2, sizeof(pName2));
		GetPlayerName(pID, pName, sizeof(pName));
		format(string, sizeof(string), "You have been teleported by admin %s", pName3);
		format(string2, sizeof(string2), "You have teleported %s to %s", pName, pName2);
		SendClientMessage(pID, Cyan, string);
		SendClientMessage(pID2, Cyan, string2);


		SetPlayerPos(pID, Float:x, Float:y, Float:z);
		SetPlayerFacingAngle(pID, Float:a);
		return 1;
	}
	else {
		SendClientMessage(playerid, Red, "Y");

		return 1;
	}
}

ocmd:giveweapon(playerid, params[])
{
	new pID, wID, Ammo;
	if(sscanf(params, "iii", pID, wID, Ammo))return SendClientMessage(playerid, Cyan, "/giveweapon [Playerid] [Weapon ID] [Ammo]");
	if(Player[playerid][ALevel] >=2)
	{
		GivePlayerWeapon(pID, wID, Ammo);
		return 1;
	}
	else
	{
      	SendClientMessage(playerid, Cyan,"You are not able to use this command!");
		return 1;
	}
}

ocmd:givemoney(playerid, params[])
{
	new pID, amount;
	if(sscanf(params,"ii",pID, amount))
	if(Player[playerid][ALevel] >= 2)
	{
	  return  SendClientMessage(playerid, Cyan,"INFO: /pay [Playerid] [Amount]");
 	}
	else
	{
     	SendClientMessage(playerid, Cyan,"You are not able to use this command!");
     	return 1;
	}
	
	if(Player[playerid][ALevel] >= 2)
	{
	    GivePlayerMoney(pID, amount);
	    return 1;
	}
	else
	{
      SendClientMessage(playerid, Cyan,"You are not able to use this command!");
      return 1;
	}
}

ocmd:vehicle(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:a, carmodel, carid;
	if(sscanf(params, "i", carmodel)) return SendClientMessage(playerid, Cyan, "/vehicle [Vehicle ID]");
	if(Player[playerid][ALevel] >=1)
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		carid = CreateVehicle(carmodel, x,y,z,a, -1, -1, 0);
		PutPlayerInVehicle(playerid, carid, 0);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, Cyan,"You are not able to use this command!");
		return 1;
	}

}

ocmd:repair(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, Cyan, "You are not in a vehicle!");
	RepairVehicle(GetPlayerVehicleID(playerid));

	return 1;
}
// Player Commands

ocmd:koekje(playerid)
{
	new string[128];
	format(string, sizeof(string), "Jou Team is %s", Player[playerid][Team]);
	SendClientMessage(playerid, Cyan, string);

	return 1;
}

ocmd:pay(playerid,params[])
{

	new pID, amount;
	if(sscanf(params,"ii",pID, amount))return SendClientMessage(playerid, Cyan,"/pay [playerid] [amount]");
	if(GetPlayerMoney(playerid) >= amount)
	{
		if (amount < 0) {
			SendClientMessage(playerid, Cyan, "You can't pay a negative value!");
		} 
		else
		{
	    GivePlayerMoney(playerid, -amount);
	 	new string[128], string2[128], pName[MAX_PLAYER_NAME], pName2[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		GetPlayerName(pID, pName2, sizeof(pName2));
		format(string, sizeof(string), "%s payed you $%i", pName, amount);
		format(string2, sizeof(string2), "You have payed %s $%i", pName2, amount);
		SendClientMessage(pID, Cyan, string);
		SendClientMessage(playerid, Cyan, string2);
		GivePlayerMoney(pID, amount);
		}
	}
	else
	{
		SendClientMessage(playerid, Cyan, "You don't have enough money!");
	}
	return 1;
}

ocmd:startworkday(playerid)
{
	if(!strcmp(Player[playerid][Team], "0", true)) {
		SendClientMessage(playerid, Cyan, "You do not have a job!");
  	}

	else if(!strcmp(Player[playerid][Team], "1", true))
  	{
    	SetPlayerSkin(playerid, 280);
    	SetPlayerColor(playerid, Blue);
    	GivePlayerWeapon(playerid, 3, 1);
    	GivePlayerWeapon(playerid, 41, 999999);
    	GivePlayerWeapon(playerid, 24, 999990);
	 	PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}

	else if(!strcmp(Player[playerid][Team], "2", true))
	{
	    SetPlayerSkin(playerid, 286);
	    SetPlayerColor(playerid, Blue);
	    PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	    
	}

	else if(!strcmp(Player[playerid][Team], "3", true))
	{
	    SetPlayerSkin(playerid, 287);
	    SetPlayerColor(playerid, Green);
	    PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}
	
	else if(!strcmp(Player[playerid][Team], "4", true))
	{
	    SetPlayerSkin(playerid, 276);
	    SetPlayerColor(playerid, Yellow);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}
	
	else if(!strcmp(Player[playerid][Team], "5", true))
	{
	    SetPlayerSkin(playerid, 279);
	    SetPlayerColor(playerid, Red);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}
	
	else if(!strcmp(Player[playerid][Team], "6", true))
	{
	    SetPlayerSkin(playerid, 295);
	    SetPlayerColor(playerid, Yellow);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}
	
    else if(!strcmp(Player[playerid][Team], "7", true))
	{
	    SetPlayerSkin(playerid, 50);
	    SetPlayerColor(playerid, Yellow);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}
	
	return 1;
}

ocmd:stopworkday(playerid)
{
	if(!strcmp(Player[playerid][Team], "civ", true))
	{
		SendClientMessage(playerid, Cyan, "You do not have a job!");
	}
	else
	{
	    KillTimer(PayPlayerTimer[playerid]);
	    SendClientMessage(playerid, Cyan, "You have stopped your workday, have a nice day!");
	    SetPlayerSkin(playerid, 0);
	    SetPlayerColor(playerid, White);
	}
	return 1;
}

ocmd:jobhelp(playerid)
{
	if(!strcmp(Player[playerid][Team], "civ", true)) {
		SendClientMessage(playerid, Cyan, "You do not have a job!");
  	}

	else if(!strcmp(Player[playerid][Team], "lspd", true))
  	{
		SendClientMessage(playerid, Cyan, "Job Commands:");
		SendClientMessage(playerid, Cyan, "/checksuspects, /stun, /(un)cuff, /putinvehicle, /removefromvehicle, /(un)jail, /ticket");
		SendClientMessage(playerid, Cyan, "/placeradar, /removeradar, /checkspeed, /stopchecking");
		SendClientMessage(playerid, Cyan, "Police Chat: /p");
	}

	else if(!strcmp(Player[playerid][Team], "fbi", true))
	{
		SendClientMessage(playerid, Cyan, "Job Commands:");
		SendClientMessage(playerid, Cyan, "/checksuspects, /stun, /(un)cuff, /putinvehicle, /removefromvehicle, /(un)jail, /ticket");
		SendClientMessage(playerid, Cyan, "/placeradar, /removeradar, /checkspeed, /stopchecking");
		SendClientMessage(playerid, Cyan, "/checkplayerposition, /disarm, /refreshweapons");
	}

	else if(!strcmp(Player[playerid][Team], "army", true))
	{
	    SetPlayerSkin(playerid, 287);
	    SetPlayerColor(playerid, Green);
	    PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}

	else if(!strcmp(Player[playerid][Team], "medic", true))
	{
	    SetPlayerSkin(playerid, 276);
	    SetPlayerColor(playerid, Yellow);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}

	else if(!strcmp(Player[playerid][Team], "fire", true))
	{
	    SetPlayerSkin(playerid, 279);
	    SetPlayerColor(playerid, Red);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}

	else if(!strcmp(Player[playerid][Team], "taxi", true))
	{
	    SetPlayerSkin(playerid, 295);
	    SetPlayerColor(playerid, Yellow);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}

    else if(!strcmp(Player[playerid][Team], "mechanic", true))
	{
	    SetPlayerSkin(playerid, 50);
	    SetPlayerColor(playerid, Yellow);
		PayPlayerTimer[playerid] = SetTimerEx("PayPlayer", 3600000, true, "i", playerid);
	}

	return 1;
}


//Team Commands

//LSPD

ocmd:checksuspects(playerid)
{
		if(!strcmp(Player[playerid][Team], "lspd", true))
		{
  			new count = 0;
		    new string[128];
			SendClientMessage(playerid, 0x00FF00FF, " ");
			SendClientMessage(playerid, 0x00FF00FF, "___________{F00000} |- Online Criminals -| {00FF00}___________");
			SendClientMessage(playerid, 0x00FF00FF, " ");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if (IsPlayerConnected(i))
		 		{
					if (GetPlayerWantedLevel(i) >= 1)
					{
					    new name[MAX_PLAYER_NAME];
					    GetPlayerName(i,name,sizeof(name));
						format(string, 128, "%s [%d] | Wanted Level: %i",name,playerid,GetPlayerWantedLevel(i));
						SendClientMessage(playerid, Cyan, string);
						count++;
					}
				}
			}
		}
		else if(!strcmp(Player[playerid][Team], "fbi", true))
		{

		}
		else if(!strcmp(Player[playerid][Team], "army", true))
		{

		}
		return 1;
}



public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/help", cmdtext, true, 10) == 0)
	{
		SendClientMessage(playerid, Cyan, "All Player Commands:");
		SendClientMessage(playerid, Cyan, "BANK: /deposit, /withdraw, /balance, /bankrob");
		SendClientMessage(playerid, Cyan, "WORK: /startworkday, /stopworkday, /jobhelp, /quitjob");
		SendClientMessage(playerid, Cyan, "SERVICE: /askfor (police, paramadics, fireteam, taxi, mechanic) (Message)");
		SendClientMessage(playerid, Cyan, "CALL SYSTEM: /call (phonenumber) /showphonenumber");
		SendClientMessage(playerid, Cyan, "VEHICLE COMMANDS: /trunk, /hood, /refuel, /(un)lock /tune");
		SendClientMessage(playerid, Cyan, "FUN: /animationlist, /smoke, /radiostream");
		return 1;
	}

	
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case 0:
		{
			if(response)
			{
      			new query[126], pName[MAX_PLAYER_NAME];
			    GetPlayerName(playerid, pName, sizeof(pName));

				format(query, sizeof(query), "SELECT * FROM players WHERE username = '%s' AND password = '%s'", pName, inputtext);
                mysql_query(query);
				mysql_store_result();
				
				if(mysql_num_rows() == 1)
				{
              		new line[500];
					new data[15][200], data2[42], Float:data3[4];
					mysql_fetch_row(line);
					sscanf(line, "p<|>is[10]s[10]iis[10]iiiffff",
					data2[0],
					data[0],
					data[1],
					data2[1],
					data2[2],
					data[2],
					data2[3],
					data2[4],
					data2[5],
					data3[0],
					data3[1],
					data3[2],
					data3[3]);

					Player[playerid][UserID] = data2[0];
					format(Player[playerid][Username], 200, "%s", data[0]);
					format(Player[playerid][Password], 200, "%s", data[1]);
					Player[playerid][Score] = data2[1];
					Player[playerid][Money] = data2[2];
					format(Player[playerid][Team], 200, "%s", data[2]);
					Player[playerid][TeamSalary] = data2[3];
					Player[playerid][ALevel] = data2[4];
					Player[playerid][WantedLevel] = data2[5];
					Player[playerid][PosX] = data3[0];
					Player[playerid][PosY] = data3[1];
     				Player[playerid][PosZ] = data3[2];
					Player[playerid][Angle] = data3[3];
					
      				SetPlayerScore(playerid, Player[playerid][Score]);
      				GivePlayerMoney(playerid, Player[playerid][Money]);
      				SetPlayerWantedLevel(playerid, Player[playerid][WantedLevel]);
				}
				else
				{
					SendClientMessage(playerid, -1, "Incorrect Password!");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_PASSWORD, "Login", "Welcome back! Please login", "Login", "Cancel");
				}

			}
		}
		case 1:
		{
			if(response)
			{
				RegisterPlayer(playerid, inputtext);
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

stock RegisterPlayer(playerid, inputtext[])
{
	new query[512], pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));
	format(query, sizeof(query), "INSERT INTO players (Username, Password, Score, Money, Team, ALevel, PosX, PosY, PosZ, Angle) VALUES ('%s', '%s', '0', '50000', 'civ', '0', '1475.449218', '-1674.632812', '14.046875', '180.982391')", pName, inputtext);
    mysql_query(query);
	SendClientMessage(playerid, -1, "You are succesfully registered! Please re-enter the server to make sure all your settings are working fine!");
	SetTimerEx("BringPlayerToSpawn", 1, false, "i", playerid);
	
}

forward BringPlayerToSpawn(playerid);

public BringPlayerToSpawn(playerid)
{
	SetPlayerPos(playerid, 1475.449218, -1674.632812, 14.046875);
	SetPlayerFacingAngle(playerid, 180.982391);
	TogglePlayerControllable(playerid,0);
	SetTimerEx("KickPlayer", 1, false, "i", playerid);
}

forward KickPlayer(playerid);

public KickPlayer(playerid)
{

	Kick(playerid);
}

forward PayPlayer(playerid);

public PayPlayer(playerid)
{
	GivePlayerMoney(playerid, Player[playerid][TeamSalary]);
	SendClientMessage(playerid, Cyan, "U have received your loan for this hour!");
}

stock SavePlayer(playerid)
{
	new query[512], pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));
	GetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
	GetPlayerFacingAngle(playerid, Player[playerid][Angle]);
	Player[playerid][Money] = GetPlayerMoney(playerid);
 	format(query, sizeof(query), "UPDATE `players` SET Team = '%s', Money = '%i', PosX = '%f', PosY = '%f', PosZ = '%f', angle = '%f' WHERE username = '%s'", Player[playerid][Team], Player[playerid][Money] , Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], Player[playerid][Angle], Player[playerid][Username]);
	mysql_query(query);
}

