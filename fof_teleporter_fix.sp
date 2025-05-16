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
	if (!IsClientInGame(client) || IsFakeClient(client) || !IsPlayerAlive(client))
		return;
	char class[32];
	GetEdictClassname(other, class, sizeof(class));
	if(StrEqual(class, "trigger_teleport"))
	{
		char target[32];
		GetEntPropString(other, Prop_Data, "m_target", target, sizeof(target));
		int ent = INVALID_ENT_REFERENCE;
		while ((ent = FindEntityByClassname(ent, "info_teleport_destination")) != INVALID_ENT_REFERENCE)
		{
			GetEdictClassname(ent, class, sizeof(class));
			if (StrEqual(class, "info_teleport_destination"))
			{
				char destination[32];
				GetEntPropString(ent, Prop_Data, "m_iName", destination, sizeof(destination));
				if (StrEqual(destination, target))
				{
					float pos[3];
					float ang[3];
					GetEntPropVector(ent, Prop_Send, "m_vecOrigin", pos);
					GetEntPropVector(ent, Prop_Data, "m_angRotation", ang);
					SetEntPropVector(client, Prop_Send, "m_vecOrigin", pos);
					SetEntPropVector(client, Prop_Data, "m_angRotation", pos);
					break;
				}
			}
		}
	}
}