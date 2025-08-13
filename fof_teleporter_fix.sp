#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

public Plugin myinfo =
{
	name = "[FoF] Teleporter Fix",
	author = "",
	description = "Fix teleporter not working on Fistful of Frags",
	version = "0.1.0",
	url = ""
};

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_Touch, OnTouch)
}

public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_Touch, OnTouch)
}

public void OnTouch(int client, int other)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
		return;
	char name[32];
	GetEdictClassname(other, name, sizeof(name));
	if (StrEqual(name, "trigger_teleport"))
	{
		char target[32];
		GetEntPropString(other, Prop_Data, "m_target", target, sizeof(target));
		int ent;
		while ((ent = FindEntityByClassname(ent, "info_teleport_destination")) != INVALID_ENT_REFERENCE)
		{
			char dest[32];
			GetEntPropString(ent, Prop_Data, "m_iName", dest, sizeof(dest));
			if (StrEqual(dest, target))
			{
				float pos[3];
				GetEntPropVector(ent, Prop_Send, "m_vecOrigin", pos);
				SetEntPropVector(client, Prop_Send, "m_vecOrigin", pos);
				break;
			}
		}
	}
}