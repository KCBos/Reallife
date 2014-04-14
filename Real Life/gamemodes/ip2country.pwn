/**
 * IP to Country - based on MySQL (database taken from http://phpweby.com/software/ip2country)
 * simple demonstration of how to use some of the new functions in R7
 * detects country and country code and prints it into the server log
 *
 * TODO:
 * - import "ip2c.sql" via PHPMySQLAdmin
 * - edit host, username, database and password
 * - compile and add the fs to your server config
 */
 
#include <a_samp>
#include <a_mysql>

#define ENABLE_DEBUGGING true

forward onCountryDetect(playerid, ip[]);

new g_ConnectionHandle;


public OnFilterScriptInit()
{

	g_ConnectionHandle = mysql_connect("host", "user", "database", "password");
	return 1;
}

public OnPlayerConnect(playerid)
{
	new szPlayerIP[16], iNumIP, szQuery[128];
	GetPlayerIp(playerid, szPlayerIP, sizeof(szPlayerIP));
	iNumIP = IpToInteger(szPlayerIP);
	mysql_format(g_ConnectionHandle, szQuery, "SELECT `country_code`, `country_name` FROM `ip2c` WHERE \"%d\" BETWEEN `begin_ip_num` AND `end_ip_num` LIMIT 1", iNumIP);
	mysql_function_query(g_ConnectionHandle, szQuery, true, "onCountryDetect", "ds", playerid, szPlayerIP);
	return 1;
}

public onCountryDetect(playerid, ip[])
{
	if(IsPlayerConnected(playerid)) {
		new rows, fields, szPlayerName[MAX_PLAYER_NAME];
		cache_get_data(rows, fields);
		new country_name[30], country_code[30];
		#define FIELD_COUNTRYNAME 0
		#define FIELD_COUNTRYCODE 1
		cache_get_row(0, FIELD_COUNTRYNAME, country_name); // row 0 = first row, idx 0 = first field in the selected row
		cache_get_row(0, FIELD_COUNTRYCODE, country_code); // row 0 = first row, idx 1 = second field in the selected row
		/* you could also use: (this is not needed incase we know the field index)
		 * cache_get_field_content(0, "country_name", country_name);
		 * cache_get_field_content(0, "country_code", country_code);
		 */
		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		printf("Player %s (ID: %d, IP: %s, Country: %s, CountryCode: %s)", szPlayerName, playerid, country_name, country_code);
	}
	// the cache gets cleared once the callback has completely executed,
	// therefore you don't have to worry about storing or free'ing results
	return 1;
}

// the ip ranges are saved as decimals so lets convert the ip (string) into a decimal
stock IpToInteger(ip[])
{
	new ipPart[4][4], iPart, cPos, idx;
	for(new a = strlen(ip);idx < a;idx++) {
		if(ip[idx] == '.') {
			strmid(ipPart[iPart], ip, cPos, idx, 4);
			cPos = idx + 1;
			iPart++;
		}
	}
	strmid(ipPart[3], ip, cPos, idx, 4);
	return (strval(ipPart[0]) << 24) | (strval(ipPart[1]) << 16) | (strval(ipPart[2]) << 8) | strval(ipPart[3]);
}
