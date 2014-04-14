/*
	OCMD 2.0.3
	by Kleiner Opa
	best command-solution for sa:mp
	supports samp 0.2X, 0.3a, 0.3b, 0.3c, 0.3d, 0.3e, 0.3x
	email: fisch70000@gmail.com
	http://forum.sa-mp.de/index.php?page=User&userID=24998
*/
#include <a_samp>

forward ocmdOnPlayerCommandText(playerid,cmdtext[]);
#if defined OCMD_BEFORE_CALLBACK
	forward BeforePlayerCommandText(playerid,cmdtext[]);
	new bool:ocmdBeforeCallback,bool:ocmdInit;
#endif

#define ocmd:%1(%2) forward ocmd_%1(%2);\
public ocmd_%1(%2)

public OnPlayerCommandText(playerid,cmdtext[])
{
    #if defined OCMD_BEFORE_CALLBACK
        if(!ocmdInit)
        {
        	if(funcidx("BeforePlayerCommandText")!=-1)ocmdBeforeCallback=true;
            ocmdInit=true;
        }
    #endif
    new ocmdStr[32]="ocmd_",
		i=1,
		#if defined OCMD_COMMAND_LOG
		ocmdName[MAX_PLAYER_NAME],
		#endif
		bool:ocmdNoParams;
	#if defined OCMD_COMMAND_LOG
		GetPlayerName(playerid,ocmdName,sizeof ocmdName);
	    printf("[cmd] [%s]: %s",ocmdName,cmdtext);
	#endif
	#if defined OCMD_BEFORE_CALLBACK
	    if(ocmdBeforeCallback&&!CallLocalFunction("BeforePlayerCommandText","ds",playerid,cmdtext))return 1;
	#endif
	for(;i<128;i++)
	{
	    if(!cmdtext[i]||cmdtext[i]==' ')
	    {
	        if(!cmdtext[i]||!cmdtext[i+1])ocmdNoParams=true;
	        break;
	    }
	    ocmdStr[i+4]=tolower(cmdtext[i]);
	}
	if(!ocmdNoParams&&CallLocalFunction(ocmdStr,"ds",playerid,cmdtext[i+1]))return 1;
	if(ocmdNoParams&&CallLocalFunction(ocmdStr,"ds",playerid," "))return 1;
	return CallLocalFunction("ocmdOnPlayerCommandText","ds",playerid,cmdtext);
}

#if defined _ALS_OnPlayerCommandText
	#undef OnPlayerCommandText
#else
	#define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText ocmdOnPlayerCommandText
