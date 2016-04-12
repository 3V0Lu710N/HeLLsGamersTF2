#include <sourcemod>
#include <tf2>
#include <tf2_stocks>
#include <tf2items_giveweapon>
#include <smlib>
#include <advanced_motd>
#include <morecolors>

#define PLUGIN_VERSION "1.0"


public Plugin myinfo = 
{
	name = "HG Event Info Announcer",
	author = "3V0Lu710N",
	description = "HG Event Info Announcer",
	version = PLUGIN_VERSION,
	url = "http://www.hellsgamers.com"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_eventinfo", EventInfo, "HeLLsGamers Event Information");
	HookEvent("post_inventory_application", After_ResupplyLocker);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("teamplay_round_start", Event_RoundStart);
	HookEvent("teamplay_setup_finished",Event_SetupFinished);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	SetHudTextParams(-1.0, -1.0, 10.0, 000, 255, 000, 255, 2, 0.30);

	new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	if(TF2_GetPlayerClass(iClient) != TFClass_Heavy)
	{
		TF2_SetPlayerClass(iClient, TFClass_Heavy);
		TF2_RespawnPlayer(iClient);
		ShowHudText(iClient, -1, "Only Heavy is allowed for this event.");
	}

	TF2_RemoveAllWeapons(iClient);

	TF2Items_GiveWeapon(iClient, 656);

	CreateTimer(5.0, TCB, iClient);
}

public Action TCB(Handle timer, any iClient)
{
	SetHudTextParams(-1.0, -1.0, 5.0, 000, 255, 000, 255, 2, 0.30);

	ShowHudText(iClient, -1, "Press G twice to slay your opponent when they are laughing");
}

public After_ResupplyLocker(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	TF2_RemoveAllWeapons(iClient);

	TF2Items_GiveWeapon(iClient, 656);
}

public Action EventInfo(client, args)
{
	AdvMOTD_ShowMOTDPanel(client, "Degroot Keep Tickle", "http://hellsgamers.com/calendar/event/830-tf2-degroot-keep-tickle-event/", MOTDPANEL_TYPE_URL, true, true, true, OnMOTDFailure);
	
	return Plugin_Handled;
}

public void OnMOTDFailure(int client, MOTDFailureReason reason) {
    if(reason == MOTDFailure_Disabled) {
        PrintToChat(client, "[SM] You have HTML MOTDs disabled.");
    } else if(reason == MOTDFailure_Matchmaking) {
        PrintToChat(client, "[SM] You cannot view HTML MOTDs because you joined via Quickplay.");
    } else if(reason == MOTDFailure_QueryFailed) {
        PrintToChat(client, "[SM] Unable to verify that you can view HTML MOTDs.");
    } else {
        PrintToChat(client, "[SM] Unable to verify that you can view HTML MOTDs for an unknown reason.");
    }
}

public Action Event_RoundStart(Handle event, const String:name[], bool dontBroadcast)
{
    PrintInfo();
}

public Action Event_SetupFinished(Handle event,  const String:name[], bool dontBroadcast) 
{   
    PrintInfo();
}

PrintInfo()
{
  	CPrintToChatAll("{fullred}#### HeLLsGamers ####");
	CPrintToChatAll("{fullred}[HG] {white}Thanks for Participating in this event!");
	CPrintToChatAll("{fullred}[HG] {white}Type /eventinfo for event info (Requires MOTDs to be enabled)");
    CPrintToChatAll("%s", "{fullred}[HG] {white}Welcome to DeGroot Tickle Event (50% Crits)");
	CPrintToChatAll("{fullred}[HG] {white}Event Host: {dodgerblue}HG | Misc2008 [S]");
	CPrintToChatAll("{fullred}[HG] {white}Prizes:");
	CPrintToChatAll("{fullred}[HG] {white}1st Place: {gold}Gold Account");
	CPrintToChatAll("{fullred}[HG] {white}2nd Place: {dodgerblue}30,000 Rep");
	CPrintToChatAll("{fullred}[HG] {white}3rd Place: {purple}VIP Account");
	CPrintToChatAll("{fullred}#### HeLLsGamers ####");
}