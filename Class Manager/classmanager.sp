#include <sourcemod>
#include <tf2>
#include <tf2_stocks>
#include <smlib>

#define PLUGIN_VERSION "1.0"

public Plugin myinfo = 
{
	name = "HG TF2 Jailbreak Class Manager",
	author = "3V0Lu710N",
	description = "TF2 Jailbreak Class Manager",
	version = PLUGIN_VERSION,
	url = "http://www.hellsgamers.com"
};

public void OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	SetHudTextParams(-1.0, -1.0, 10.0, 000, 255, 000, 255, 2, 0.30);

	if(TF2_GetClientTeam(iClient) == TFTeam_Blue && CheckCommandAccess(iClient, "", ADMFLAG_ROOT) == false)
	{
		if(TF2_GetPlayerClass(iClient) == TFClass_Engineer || TF2_GetPlayerClass(iClient) == TFClass_Pyro || TF2_GetPlayerClass(iClient) == TFClass_Spy)
		{
			TF2_SetPlayerClass(iClient, TFClass_Scout);
			TF2_RespawnPlayer(iClient);
			ShowHudText(iClient, -1, "Spy, Pyro and Engineer Class are not Allowed.");
		}
	}
	if(TF2_GetClientTeam(iClient) == TFTeam_Blue && CheckCommandAccess(iClient, "", ADMFLAG_BAN) == false)
	{
		if(TF2_GetPlayerClass(iClient) == TFClass_Soldier || TF2_GetPlayerClass(iClient) == TFClass_DemoMan)
		{
			TF2_SetPlayerClass(iClient, TFClass_Scout);
			TF2_RespawnPlayer(iClient);
			ShowHudText(iClient, -1, "Only Admins can play as Soldier or Demoman");
		}
	}
	if(TF2_GetClientTeam(iClient) == TFTeam_Blue && CheckCommandAccess(iClient, "", ADMFLAG_ROOT) == false)
	{
		new iLimit = 1;

		for(int i = 1, iCount = 0; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && _:TF2_GetPlayerClass(i) == TFClass_Medic && ++iCount > iLimit)
			{
				if(CheckCommandAccess(i, "", ADMFLAG_ROOT) == false)
				{
					TF2_SetPlayerClass(i, TFClass_Scout);
					TF2_RespawnPlayer(i);
					ShowHudText(i, -1, "There can only be one Medic on Blue Team.");
				}
			}
		}
	}
	
	if(TF2_GetClientTeam(iClient) == TFTeam_Red && CheckCommandAccess(iClient, "", ADMFLAG_ROOT) == false)
	{
		if(TF2_GetPlayerClass(iClient) == TFClass_Engineer || TF2_GetPlayerClass(iClient) == TFClass_Spy)
		{
			TF2_SetPlayerClass(iClient, TFClass_Scout);
			TF2_RespawnPlayer(iClient);
			ShowHudText(iClient, -1, "Spy and Engineer Class are not Allowed.");
		}
	}
	if(TF2_GetClientTeam(iClient) == TFTeam_Red)
	{
		if(TF2_GetPlayerClass(iClient) == TFClass_Medic)
		{
			TF2_SetPlayerClass(iClient, TFClass_Scout);
			TF2_RespawnPlayer(iClient);
			ShowHudText(iClient, -1, "Medic is not allowed on Red Team.");
		}
	}
}
