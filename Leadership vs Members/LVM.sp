#include <sourcemod>
#include <morecolors>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

#define PLUGIN_VERSION		"1.1"

public Plugin:myinfo = 
{
	name = "Leadership vs Members Team Manager",
	author = "3V0Lu710N",
	description = "LVM Team Manager",
	version = PLUGIN_VERSION,
	url = "http://www.sourcemod.net/"
};

public OnPluginStart()		
{	
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public int PanelHandler1(Menu menu, MenuAction action, int param1, int param2)
{

}

public int PanelHandler2(Menu menu, MenuAction action, int param1, int param2)
{

}

public Event_PlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{	
	char identity[MAX_NAME_LENGTH];	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	GetClientName(iClient, identity, sizeof(identity));
	
	TFTeam Members = TFTeam_Red;
	TFTeam Leadership = TFTeam_Blue;
	
	/*
		If the [S] or [L] tag is found in the name, and the client is not a bot, will get moved to blue team
		If the [S] or [L] tag is not found in the name, and the client is not a bot, will get moved to read team
		Staff members will be forced to use their tags in the name
	*/
	
	if(StrContains(identity, "[S]", false) >= 0 || StrContains(identity, "[L]", false) >= 0 && IsFakeClient(iClient) == false)
	{
		if(TF2_GetClientTeam(iClient) == Members)
		{
			TF2_ChangeClientTeam(iClient, Leadership);	
			TF2_RespawnPlayer(iClient);
		
			CPrintToChat(iClient, "{fullred}[HG] {dodgerblue}Leadership {white}tag detected, moving you to {dodgerblue}Blue {white}team");

			Panel panel1 = new Panel();
			panel1.SetTitle("Leadership vs Members");
			DrawPanelText(panel1, "-----------------------------");
			DrawPanelText(panel1, "Leadership Tag detected in your name");
			DrawPanelText(panel1, "You were switched to Blue team");

			panel1.Send(iClient, PanelHandler1, 15);
		}
	}
	else
	{	
		if(StrContains(identity, "[S]", false) == -1 && StrContains(identity, "[L]", false) == -1 && IsFakeClient(iClient) == false)
		{
			if(TF2_GetClientTeam(iClient) == Leadership)
			{
				TF2_ChangeClientTeam(iClient, Members);
				TF2_RespawnPlayer(iClient);

				CPrintToChat(iClient, "{fullred}[HG] {white}Leadership tag {fullred}NOT {white}detected, moving you to {fullred}Red {white}team,");

				Panel panel2 = new Panel();
				panel2.SetTitle("Leadership vs Members");
				DrawPanelText(panel2, "-----------------------------");
				DrawPanelText(panel2, "You were switched to Red team,");
				DrawPanelText(panel2, "If you are a Staff Member,");						
				DrawPanelText(panel2, "Put on your Staff tag.");

				panel2.Send(iClient, PanelHandler2, 15);
			}
		}
	}
}
