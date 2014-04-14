#include <a_samp>
#include <a_mysql>

forward OnUserRegister(query[], index, extraid, connectionHandle);
forward OnConnectResponse(query[], index, extraid, connectionHandle);
forward OnUserLogin(query[], index, extraid, connectionHandle);
forward OnUserUpdate(query[], index, extraid, connectionHandle);

//MySQL Configuration
#define SQL_HOST "host"
#define SQL_DB "database"
#define SQL_USER "username"
#define SQL_PASS "password"

#define TABLENAME "users"

#define GREY 0xAFAFAFAA
#define RED 0xFF0000AA
#define YELLOW 0xFFFF00AA
#define LIGHTBLUE 0x33CCFFAA

#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

//global variables
new
	bool:LoggedIn[MAX_PLAYERS] = { false, ... },
	bool:AccRegistered[MAX_PLAYERS] = { false, ... },
	Wrongattempt[MAX_PLAYERS],
	TimerSet[MAX_PLAYERS],
	pLogtimer[MAX_PLAYERS],
	PlayerMoney[MAX_PLAYERS];

public OnFilterScriptInit()
{
	mysql_debug(1);
	mysql_connect(SQL_HOST, SQL_USER,SQL_DB, SQL_PASS);
 	SetupTable(); //run this only once
}

SetupTable()
{
	return mysql_query("CREATE TABLE IF NOT EXISTS `"TABLENAME"`(`id` int(11) NOT NULL auto_increment PRIMARY KEY,`Username` varchar(30) NOT NULL,`Password` varchar(50) NOT NULL,`Money` int(10) NOT NULL default '0')");
}

public OnFilterScriptExit()
{
	printf("OnFilterScriptExit()");
	mysql_close();
}

RegisterAccount(playerid,pass[])
{
    new
		pName[MAX_PLAYER_NAME],
		query[256];

	GetPlayerName(playerid,pName,sizeof(pName));
	mysql_real_escape_string(pName,pName);
	mysql_real_escape_string(pass,pass);
	format(query,sizeof(query),"INSERT INTO `"TABLENAME"` (Username,Password) VALUES ('%s',md5('%s'))",pName,pass);
	mysql_query_callback(playerid,query,"OnUserRegister");
	return 1;
}

public OnUserRegister(query[], index, extraid, connectionHandle)
{
    new string[128],pName[MAX_PLAYER_NAME];
	if(IsPlayerConnected(index)) {
		GetPlayerName(index,pName,sizeof pName);
		format(string,sizeof(string),">> Account %s successfully registered - Remember your password for later use.",pName);
		SendClientMessage(index,GREY,string);
		SendClientMessage(index,GREY,"You have been automatically logged in");
		LoggedIn[index] = true;
		AccRegistered[index] = true;
	}
	return 1;
}

LoginPlayer(playerid,pass[])
{
    new
		pName[MAX_PLAYER_NAME],
		query[256];

	GetPlayerName(playerid,pName,sizeof(pName));

	mysql_real_escape_string(pName,pName);
	mysql_real_escape_string(pass,pass);
	format(query,sizeof(query),"SELECT Money FROM `"TABLENAME"` WHERE Username = '%s' AND Password = md5('%s') LIMIT 1",pName,pass);
	mysql_query_callback(playerid,query,"OnUserLogin");
	return 1;
}

public OnUserLogin(query[], index, extraid, connectionHandle)
{
	new string[128],pName[MAX_PLAYER_NAME];
	if(IsPlayerConnected(index)) {
		mysql_store_result();
		if(mysql_num_rows() == 1) {
			PlayerMoney[index] = mysql_fetch_int();
			GivePlayerMoney(index,PlayerMoney[index]);
			LoggedIn[index] = true;
			format(string,sizeof(string),">> You have been successfully logged in. (Money: %d)",PlayerMoney[index]);
			SendClientMessage(index,GREY,string);
			mysql_free_result();
		} else {
  			Wrongattempt[index] += 1;
			printf("Bad log in attempt by %s (Total attempts: %d)",pName,Wrongattempt[index]);
			if(Wrongattempt[index] >= 3) 	{
				SendClientMessage(index,RED,">> You have been kicked.( 3 times wrong pass )");
				mysql_free_result();
				return Kick(index);
			}
			mysql_free_result();
			SendClientMessage(index,RED,">> Wrong Password");
		}
	} else {
		//to avoid "commands out of sync" errors
		mysql_store_result();
		mysql_free_result();
	}
	return 1;
}


public OnPlayerDisconnect(playerid,reason)
{
	if(pLogtimer[playerid] != 0) KillTimer(pLogtimer[playerid]);
	new
		query[300],
		pName[MAX_PLAYER_NAME];

	GetPlayerName(playerid,pName,sizeof(pName));

	if(LoggedIn[playerid]) {
	    new Float:arm;
	    GetPlayerArmour(playerid,arm);
		format(query,sizeof(query),"UPDATE `"TABLENAME"` SET `Money`='%d' WHERE (`Username` = '%s')",GetPlayerMoney(playerid),pName);
		mysql_query_callback(playerid,query,"OnUserUpdate");
	}
	return 1;
}

public OnUserUpdate(query[], index, extraid, connectionHandle)
{
	printf("Data of playerid %d has been updated",index);
	return 1;
}

public OnPlayerConnect(playerid)
{
    new
		query[256],
		pname[MAX_PLAYER_NAME];
	Wrongattempt[playerid] = 0;
	LoggedIn[playerid] = false;
	TimerSet[playerid] = 0;

	GetPlayerName(playerid,pname,sizeof(pname));
	format(query,sizeof(query),"SELECT * FROM `"TABLENAME"` WHERE Username = '%s'",pname);
	mysql_query_callback(playerid,query,"OnConnectResponse");
	return 1;
}

public OnConnectResponse(query[], index, extraid, connectionHandle)
{
    new string[128],pName[MAX_PLAYER_NAME];
	if(IsPlayerConnected(index))  {
		GetPlayerName(index,pName,sizeof pName);
		mysql_store_result();
		if(mysql_num_rows() > 0) {
			format(string,sizeof(string),">> This account (%s) is registered.Please login by using /login [pass]",pName);
			SendClientMessage(index,GREY,string);
			AccRegistered[index] = true;
			pLogtimer[index] = SetTimerEx("LoginKick",30000,0,"d",index);
		} else {
			format(string,sizeof(string),">> Welcome %s, you can register by using /register [pass]",pName);
			SendClientMessage(index,GREY,string);
			AccRegistered[index] = false;
		}
		mysql_free_result();
	} else {
		//to avoid "commands out of sync" errors
		mysql_store_result();
		mysql_free_result();
	}
	return 1;
}

forward LoginKick(playerid);
public LoginKick(playerid)
{
	if(!LoggedIn[playerid]) KickEx(playerid,"Not logged in");
	else
	{
	    KillTimer(pLogtimer[playerid]);
	    pLogtimer[playerid] = 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(register,8,cmdtext);
	dcmd(login,5,cmdtext);
	return 0;
}

dcmd_login(playerid, params[])
{
	if(LoggedIn[playerid])
	{
     	return SendClientMessage(playerid,RED,">> You are already logged in");
	}
	if(!AccRegistered[playerid])
	{
     	return SendClientMessage(playerid,RED,">> This Account is not registered. ( Use /register [pass] )");
	}
	if(!strlen(params))
	{
	    return SendClientMessage(playerid,RED,"SYNTAX: /login [password]");
	}
	LoginPlayer(playerid,params);
	return true;
}

dcmd_register(playerid, params[])
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	if(AccRegistered[playerid])
	{
	    return SendClientMessage(playerid,RED,">> This account is already registered. ( /login [pass] )");
	}
	if(LoggedIn[playerid])
	{
	    return SendClientMessage(playerid,RED,">> You are already logged in");
	}
	if(!strlen(params))
	{
	    return SendClientMessage(playerid,RED,"SYNTAX: /register [password]");
	}
	if(strlen(params) < 6)
	{
	    return SendClientMessage(playerid,RED,">> The password should contain 6 characters at least.");
	}
	RegisterAccount(playerid,params);
	return 1;
}

stock KickEx(playerid,reason[])
{
	new
		string[128],
		MsgAll[128],
		pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	format(string,sizeof(string),"You have been kicked: ");
	strcat(string,reason,sizeof(string));
	SendClientMessage(playerid,RED,string);
	Kick(playerid);
	format(MsgAll,sizeof(MsgAll),">> %s has been kicked.(Reason: %s)",pName,reason);
	SendClientMessageToAll(GREY,MsgAll);
	return 1;
}
