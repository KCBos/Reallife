//Includes
#include <a_samp>
#include <ocmd>
#include <sscanf2>
#include <a_mysql>

//enums
enum playerInfo{
	eingeloggt,
	level
}

//Globale Variablen
new dbhandle;
new sInfo[MAX_PLAYERS][playerInfo];

//Farben
#define COLOR_RED 0xFF0000FF

//Dialoge
#define DIALOG_TELEPORT 1
#define DIALOG_REGISTER 2
#define DIALOG_LOGIN 3

//MySQL
#define db_host "127.0.0.1"
#define db_user "root"
#define db_pass "12345"
#define db_db "samp"

//Forwards
forward OnUserCheck(playerid);
forward OnPasswordResponse(playerid);

main()
{

}

public OnGameModeInit()
{
	SetGameModeText("MrMonat Tutorialmode");
	AddPlayerClass(1,199.0846,-150.0331,1.5781,359.1443,WEAPON_MP5,500,0,0,0,0);
	AddPlayerClass(2,199.0846,-150.0331,1.5781,359.1443,WEAPON_MP5,500,0,0,0,0);
	AddPlayerClass(3,199.0846,-150.0331,1.5781,359.1443,WEAPON_MP5,500,0,0,0,0);
	
	//MySQL
	dbhandle = mysql_connect(db_host,db_user,db_db,db_pass);
	return 1;
}

public OnGameModeExit()
{
	mysql_close(dbhandle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid,199.0846,-150.0331,1.5781);
	SetPlayerCameraPos(playerid, 199.2307,-143.8328,1.5781);
	SetPlayerCameraLookAt(playerid, 199.0846,-150.0331,1.5781);
	SetPlayerFacingAngle(playerid,359.1443);
	return 1;
}

public OnUserCheck(playerid)
{
	new num_rows,num_fields;
	cache_get_data(num_rows,num_fields,dbhandle);
	if(num_rows==0)
	{
	    //Registrierung
	    ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Registrierung","Gib bitte dein gewünschtes Passwort an:","Okay","Abbrechen");
	}
	else
	{
	    //Login
	    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Gibt bitte dein Passwort ein:","Okay","Abbrechen");
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	new nachricht[128];
	format(nachricht,sizeof(nachricht),"Du bist mit der ID %i verbunden.",playerid);
	SendClientMessage(playerid,COLOR_RED,nachricht);
	
	//Login/Register
	new name[MAX_PLAYER_NAME],query[128];
	GetPlayerName(playerid,name,sizeof(name));
	format(query,sizeof(query),"SELECT id FROM players WHERE username='%s'",name);
	mysql_function_query(dbhandle,query,true,"OnUserCheck","i",playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
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

//Befehle

ocmd:teleport(playerid,params[])
{
	ShowPlayerDialog(playerid,DIALOG_TELEPORT,DIALOG_STYLE_LIST,"Teleport","Spawn\nFarm","Teleport","Abbrechen");
	return 1;
}

ocmd:pn(playerid,params[])
{
	new pID,text[128];
	if(sscanf(params,"us[128]",pID,text))return SendClientMessage(playerid,COLOR_RED,"INFO: /pn [playerid] [text]");
	SendClientMessage(pID,COLOR_RED,text);
	return 1;
}

ocmd:restart(playerid,params[])
{
    SendRconCommand("gmx");
    return 1;
}

ocmd:test(playerid,params[])
{
    SendClientMessage(playerid,COLOR_RED,"Du hast /test eingegeben.");
    return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
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

public OnPasswordResponse(playerid)
{
	new num_fields,num_rows;
	cache_get_data(num_rows,num_fields,dbhandle);
	if(num_rows==1)
	{
	    //Passwort richtig
	    sInfo[playerid][eingeloggt] = 1;
	    sInfo[playerid][level] = cache_get_field_content_int(0,"level",dbhandle);
	}
	else
	{
	    //Passwort falsch
	    SendClientMessage(playerid,COLOR_RED,"Das eingegebene Passwort ist falsch.");
	    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Gibt bitte dein Passwort ein:","Okay","Abbrechen");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid==DIALOG_LOGIN)
	{
	    if(response)
	    {
	        new name[MAX_PLAYER_NAME],query[128],passwort[35];
	        GetPlayerName(playerid,name,sizeof(name));
	        if(strlen(inputtext)>0)
	        {
	            mysql_escape_string(inputtext,passwort,dbhandle);
	            format(query,sizeof(query),"SELECT * FROM players WHERE username='%s' AND password='%s'",name,passwort);
	            mysql_function_query(dbhandle,query,true,"OnPasswordResponse","i",playerid);
	        }
	        else
			{
				//Keine Eingabe
				SendClientMessage(playerid,COLOR_RED,"Gibt bitte dein Passwort ein.");
                ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Gibt bitte dein Passwort ein:","Okay","Abbrechen");
   			}
	    }
	    else
	    {
	        Kick(playerid);
	    }
	    return 1;
	}
	if(dialogid==DIALOG_REGISTER)
	{
	    if(response)
	    {
	        new name[MAX_PLAYER_NAME],query[128],passwort[35];
	        GetPlayerName(playerid,name,sizeof(name));
	        if(strlen(inputtext)>3)
	        {
	            //Registrierungsfunktion
	            mysql_escape_string(inputtext,passwort,dbhandle);
	            format(query,sizeof(query),"INSERT INTO players (username,password) VALUES ('%s','%s') ",name,passwort);
	            mysql_function_query(dbhandle,query,false,"","");
	        }
	        else
	        {
	            //Kleiner als 4 Zeichen
	            SendClientMessage(playerid,COLOR_RED,"Dein Passwort muss mindestens 4 Zeichen lang sein.");
	            ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Registrierung","Gib bitte dein gewünschtes Passwort an:","Okay","Abbrechen");
	        }
	    }
	    else
	    {
	        Kick(playerid);
	    }
	    return 1;
	}
	if(dialogid==DIALOG_TELEPORT)
	{
	    if(response)
	    {
			if(listitem==0)
			{
			    //Spawn
			    SetPlayerPos(playerid,199.0846,-150.0331,1.5781);
			}
			if(listitem==1)
			{
			    //Farm
			    SetPlayerPos(playerid,0.0,0.0,6.0);
			}
	    }
	    else
	    {
	        SendClientMessage(playerid,COLOR_RED,"Vorgang abgebrochen.");
	    }
	    return 1;
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
