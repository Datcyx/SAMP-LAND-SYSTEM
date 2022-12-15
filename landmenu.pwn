/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Turfs System

				New Generation Gaming, LLC
	(created by New Generation Gaming Development Team)
					
	* Copyright (c) 2014, New Generation Gaming, LLC
	*
	* All rights reserved.
	*
	* Redistribution and use in source and binary forms, with or without modification,
	* are not permitted in any case.
	*
	*
	* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <YSI\y_hooks>

SaveLandP(turfid)
{
	new string[500];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `land` SET data='%e|%d|%d|%d|%d|%f|%f|%f|%f', `landp1` = '%d',`landp2` = '%d', `landp3` = '%d', `landp4` = '%d', `landp5` = '%d', `landsell` = '%d', `landprice` = '%d', `landbalance` = '%d', `landpx` = '%f', `landpy` = '%f', `landpz` = '%f'  WHERE id = %d",
	Lands[turfid][landName],
	Lands[turfid][landOwnerId],
	Lands[turfid][landLocked],
	Lands[turfid][landSpecial],
	Lands[turfid][landVulnerable],
	Lands[turfid][landMinX],
	Lands[turfid][landMinY],
	Lands[turfid][landMaxX],
	Lands[turfid][landMaxY],
	Lands[turfid][landplayer1],
	Lands[turfid][landplayer2],
	Lands[turfid][landplayer3],
	Lands[turfid][landplayer4],
	Lands[turfid][landplayer5],
	Lands[turfid][landsells],
	Lands[turfid][landprices],
	Lands[turfid][landbalances],
	Lands[turfid][landpickupx],
	Lands[turfid][landpickupy],
	Lands[turfid][landpickupz],
	turfid + 1);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

SaveLands()
{
	for(new i; i < MAX_LANDS; i++)
	{
		SaveLandP(i);
	}
}

forward OnLoadLandP();
public OnLoadLandP()
{
	new i, rows, tmp[128],tmp2[128];
	cache_get_row_count(rows);
	while(i < rows)
	{
        cache_get_value_name_int(i, "landp1", Lands[i][landplayer1]);
        cache_get_value_name_int(i, "landp2", Lands[i][landplayer2]);
        cache_get_value_name_int(i, "landp3", Lands[i][landplayer3]);
        cache_get_value_name_int(i, "landp4", Lands[i][landplayer4]);
        cache_get_value_name_int(i, "landp5", Lands[i][landplayer5]);
        cache_get_value_name_int(i, "landsell",Lands[i][landsells]);
        cache_get_value_name_int(i, "landprice", Lands[i][landprices]);
        cache_get_value_name_int(i, "landbalance", Lands[i][landbalances]);
        cache_get_value_name_float(i, "landpx", Lands[i][landpickupx]);
        cache_get_value_name_float(i, "landpy", Lands[i][landpickupy]);
        cache_get_value_name_float(i, "landpz", Lands[i][landpickupz]);
		cache_get_value_name(i, "data", tmp);
		if(!sscanf(tmp, "p<|>s[64]iiiiffff",
			Lands[i][landName],
			Lands[i][landOwnerId],
			Lands[i][landLocked],
			Lands[i][landSpecial],
			Lands[i][landVulnerable],
			Lands[i][landMinX],
			Lands[i][landMinY],
			Lands[i][landMaxX],
			Lands[i][landMaxY]
		)) CreateLandP(0, i++);
	}
	if(i) printf("[PlayerLands] %d lands loaded.", i);
	else printf("[PlayerLands] Failed to load any lands.");
	return 1;
}

stock LoadLandP()
{
	printf("[Turf Wars] Loading turfs from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `land`", "OnLoadLandP", "");
}

InitLandP()
{
	for(new i = 0; i < MAX_LANDS; i++)
	{
	    Lands[i][landOwnerId] = -1;
	    Lands[i][landActive] = 0;
	    Lands[i][landLocked] = 0;
	    Lands[i][landSpecial] = 0;
	    Lands[i][landTimeLeft] = 0;
	    Lands[i][landVulnerable] = 12;
	    Lands[i][landAttemptId] = -1;
	    Lands[i][landGangZoneId] = -1;
	    Lands[i][landAreaId] = -1;
	    Lands[i][landFlash] = -1;
	    Lands[i][landFlashColor] = 0;
	}
	return 1;
}

CreateLandP(forcesync, zone)
{
new szResult[1024];
    if(Lands[zone][landMinX] != 0.0 && Lands[zone][landMinY] != 0.0 && Lands[zone][landMaxX] != 0.0 && Lands[zone][landMaxY] != 0.0) {
 		Lands[zone][landGangZoneId] = GangZoneCreate(Lands[zone][landMinX],Lands[zone][landMinY],Lands[zone][landMaxX],Lands[zone][landMaxY]);
   		Lands[zone][landAreaId] = CreateDynamicRectangle(Lands[zone][landMinX],Lands[zone][landMinY],Lands[zone][landMaxX],Lands[zone][landMaxY],-1,-1,-1);
   		if(Lands[zone][landsells] == 1){
   			Lands[zone][landpickup] =  CreateDynamicPickup(19523, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is for sale for %d $", Lands[zone][landprices]);
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_RED, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
   		}else{
   		Lands[zone][landpickup] =  CreateDynamicPickup(19524, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is owned by %s ", GetPlayerNameEx(GetPlayerNames(Lands[zone][landOwnerId])));
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_RED, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
				}
	}
	if(forcesync) {
	    SyncLandPToAll();
	}

	SaveLandP(zone);
}

ResetLandPZone(forcesync, zone)
{
	Lands[zone][landActive] = 0;
	Lands[zone][landFlash] = -1;
	Lands[zone][landFlashColor] = 0;
	Lands[zone][landTimeLeft] = 0;
	Lands[zone][landAttemptId] = -1;

	if(forcesync) {
	    SyncLandPToAll();
	}

	SaveLandP(zone);
}

SetOwnerLandPZone(forcesync, zone, ownerid)
{
new szResult[1024];
	Lands[zone][landOwnerId] = GetPlayerSQLId(ownerid);
		DestroyDynamic3DTextLabel(Lands[zone][landpickupt]);
	DestroyDynamicPickup(Lands[zone][landpickup]);
		if(Lands[zone][landsells] == 1){
   			Lands[zone][landpickup] =  CreateDynamicPickup(19523, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is for sale for %d $", Lands[zone][landprices]);
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_RED, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
   		}else{
   		Lands[zone][landpickup] =  CreateDynamicPickup(19524, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is owned by %s ", GetPlayerNameEx(GetPlayerNames(Lands[zone][landOwnerId])));
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_RED, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
				}
				
	if(forcesync) {
	    SyncLandPToAll();
	}

	SaveLandP(zone);
}

DestroyLandPZone(zone,playerid)
{
	Lands[zone][landActive] = 0;

	if(Lands[zone][landGangZoneId] != -1) {
	    GangZoneDestroy(Lands[zone][landGangZoneId]);
	}

	if(Lands[zone][landAreaId] != -1) {
	    if(IsValidDynamicArea(Lands[zone][landAreaId])) DestroyDynamicArea(Lands[zone][landAreaId]);
	}

	Lands[zone][landMinX] = 0;
	Lands[zone][landMinY] = 0;
	Lands[zone][landMaxX] = 0;
	Lands[zone][landMaxY] = 0;
 	Lands[zone][landOwnerId] = -1;
	Lands[zone][landGangZoneId] = -1;
	Lands[zone][landAreaId] = -1;
	Lands[zone][landFlash] = -1;
	Lands[zone][landFlashColor] = 0;
	Lands[zone][landActive] = 0;
 	Lands[zone][landLocked] = 0;
 	Lands[zone][landSpecial] = 0;
 	Lands[zone][landTimeLeft] = 0;
 	Lands[zone][landAttemptId] = -1;
	Lands[zone][landVulnerable] = 12;
	Lands[zone][landplayer1] = -1;
	Lands[zone][landplayer2] = -1;
	Lands[zone][landplayer3] = -1;
	Lands[zone][landplayer4] = -1;
	Lands[zone][landplayer5] = -1;
	Lands[zone][landsells] = -1;
	Lands[zone][landprices] = -1;
	DestroyDynamic3DTextLabel(Lands[zone][landpickupt]);
	DestroyDynamicPickup(Lands[zone][landpickup]);
	SyncLandPToAll();
	SaveLandP(zone);

  	for(new i = 0; i != MAX_LANDSOBJ; i++)
 	{
	if(LObjectData[i][mobjlandmobjID] == zone){
	Object_Delete2(i,playerid);
	}
	
	}

}

GetPlayerLandPZone(playerid)
{
	for(new i = 0; i < MAX_LANDS; i++) {
    	if(IsPlayerInDynamicArea(playerid, Lands[i][landAreaId])) {
    	    return i;
    	}
	}
	return -1;
}


ShowLandPRadar(playerid)
{
	if(landpRadar[playerid] == 1) { return 1; }
	landpRadar[playerid] = 1;
	SyncLandPRadar(playerid);
    return 1;
}

HideLandPRadar(playerid)
{
	if(landpRadar[playerid] == 0) { return 1; }
	for(new i = 0; i < MAX_LANDS; i++) {
	    if(Lands[i][landGangZoneId] != -1) {
	    	GangZoneHideForPlayer(playerid,Lands[i][landGangZoneId]);
		}
	}
	landpRadar[playerid] = 0;
	return 1;
}

SyncLandPToAll()
{
	foreach(new i: Player)
	{
		SyncLandPRadar(i);
	}	
}

SyncLandPRadar(playerid)
{
	if(landpRadar[playerid] == 0) { return 1; }
	HideLandPRadar(playerid);
	landpRadar[playerid] = 1;
	for(new i = 0; i < MAX_LANDS; i++)
	{
	    if(Lands[i][landGangZoneId] != -1)
	    {
	        if(Lands[i][landOwnerId] >= 0)
	        {
	            GangZoneShowForPlayer(playerid, Lands[i][landGangZoneId], COLOR_YELLOW);
	        }
	        else
	        {
	            GangZoneShowForPlayer(playerid,Lands[i][landGangZoneId],COLOR_BLACK);
	        }

	        if(Lands[i][landFlash] == 1)
	        {
	        	GangZoneFlashForPlayer(playerid, Lands[i][landGangZoneId], Lands[i][landFlashColor] * 256 + 170);
	        }
	        else
	        {
	            GangZoneStopFlashForPlayer(playerid, Lands[i][landGangZoneId]);
	        }
	    }
	}
	return 1;
}
GetPlayerNames(sqlid){
for(new i = 0; i <= MAX_PLAYERS; i++)
  	{
     if(GetPlayerSQLId(i) == sqlid){
     return i;
     }
  	}
return -1;
}
LandsPEditLandSelection(playerid)
{
	szMiscArray[0] = 0;
	for(new i = 0; i < MAX_LANDS; i++)
	{
		if(Lands[i][landOwnerId] != -1)
		{
			if(Lands[i][landOwnerId] < -2)
			{
				format(szMiscArray,sizeof(szMiscArray),"%s%d) (Invalid Player)\n",szMiscArray,i/*,TurfWars[i][twName]*/);
			}
			else
			{
				format(szMiscArray,sizeof(szMiscArray),"%s%d) (%s)\n",szMiscArray,i,/*TurfWars[i][twName],*/GetPlayerNameEx(GetPlayerNames(Lands[i][landOwnerId])));
			}
		}
		else
		{
			format(szMiscArray,sizeof(szMiscArray),"%s%d) (%s)\n",szMiscArray,i,/*TurfWars[i][twName],*/"Vacant");
		}
	}
	ShowPlayerDialogEx(playerid,LDPEDITLANDSSELECTION,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Selection Menu:",szMiscArray,"Select","Back");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case LDPADMINMENU: // Turf Wars System
		{
			if(response == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						LandsPEditLandSelection(playerid);
					}
					/*case 1:
					{
						TurfWarsEditFColorsSelection(playerid);
					}*/
				}
			}
		}
		case LDPEDITLANDSSELECTION:
		{
			if(response == 1)
			{
				for(new i = 0; i < MAX_LANDS; i++)
				{
					if(listitem == i)
					{
						SetPVarInt(playerid, "EditingLandsP", i);
						ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
					}
				}
			}
		}
		case LDPEDITLANDSMENU:
		{
			if(response == 1)
			{
				new tw = GetPVarInt(playerid, "EditingLandsP");
				switch(listitem)
				{
					case 0: // Edit Dim
					{
						SetPVarInt(playerid, "EditingLandPStage", 1);
						SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savelandppos) to edit the West Wall.");
					}
					case 1: // Edit Owner
					{
						ShowPlayerDialogEx(playerid,LDPEDITLANDSOWNER,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Owner Menu:","Please enter a group ID that you wish to assign to this turf:\n\nHint: Enter -1 if you wish to vacant the turf.","Change","Back");
					}
					case 2: // Edit Vulnerablity
					{
						ShowPlayerDialogEx(playerid,LDPEDITLANDSVUL,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Vulnerable Menu:","Please enter a Vulnerable countdown time for the turf:","Change","Back");
					}
					case 3: // Edit Locks
					{
						ShowPlayerDialogEx(playerid,LDPEDITLANDSLOCKED,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Locked Menu:","Lock\nUnlock","Change","Back");
					}
					case 4: // Edit Perks
					{
						ShowPlayerDialogEx(playerid,LDPEDITLANDSPERKS,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Perks Menu:","None\nExtortion\nDrugs","Change","Back");
					}
					case 5: // Reset War
					{
						ResetLandPZone(1, tw);
						LandsPEditLandSelection(playerid);
					}
					case 6: // Destroy Turf
					{
						DestroyLandPZone(tw,playerid);
						LandsPEditLandSelection(playerid);
					}
				}
			}
			else
			{
				LandsPEditLandSelection(playerid);
			}
		}
		case LDPEDITLANDSOWNER:
		{
			if(response == 1)
			{
				new tw = GetPVarInt(playerid, "EditingLandsP");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,LDPEDITLANDSOWNER,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Owner Menu:","Please enter a group ID that you wish to assign to this turf:\n\nHint: Enter -1 if you wish to vacant the turf.","Change","Back");
					return 1;
				}
				if(strval(inputtext) < -1 || strval(inputtext) > MAX_LANDS)
				{
					ShowPlayerDialogEx(playerid,LDPEDITLANDSOWNER,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Owner Menu:","Please enter a group ID that you wish to assign to this turf:\n\nHint: Enter -1 if you wish to vacant the turf.","Change","Back");
					return 1;
				}
				SetOwnerLandPZone(1, tw, strval(inputtext));
				SaveLandP(tw);
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
			else
			{
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
		}
		case LDPEDITLANDSVUL:
		{
			if(response == 1)
			{
				new tw = GetPVarInt(playerid, "EditingLandsP");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,LDPEDITLANDSVUL,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Vulnerable Menu:","Please enter a Vulnerable countdown time for the turf:","Change","Back");
					return 1;
				}
				if(strval(inputtext) < 0)
				{
					ShowPlayerDialogEx(playerid,LDPEDITLANDSVUL,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Vulnerable Menu:","Please enter a Vulnerable countdown time for the turf:","Change","Back");
					return 1;
				}
				Lands[tw][landVulnerable] = strval(inputtext);
				SaveLandP(tw);
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
			else
			{
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
		}
		case LDPEDITLANDSLOCKED:
		{
			if(response == 1)
			{
				new tw = GetPVarInt(playerid, "EditingLandsP");
				switch(listitem)
				{
					case 0: // Lock
					{
						Lands[tw][landLocked] = 1;
						SaveLandP(tw);
						ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
					}
					case 1: // Unlock
					{
						Lands[tw][landLocked] = 0;
						SaveLandP(tw);
						ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
					}
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
		}
		case LDPEDITLANDSPERKS:
		{
			if(response == 1)
			{
				new tw = GetPVarInt(playerid, "EditingLandsP");
				Lands[tw][landSpecial] = listitem;
				SaveLandP(tw);
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
			else
			{
				ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			}
		}
	}
	return 0;
}

CMD:landinfo(playerid, params[])
{
    if(GetPlayerLandPZone(playerid) != -1) {
        new string[128];
        new tw = GetPlayerLandPZone(playerid);
        format(string,sizeof(string),"|___________ (ID: %d) %s ___________|",tw,Lands[tw][landsells]);
        SendClientMessageEx(playerid, COLOR_GREEN, string);
        if(Lands[tw][landOwnerId] == -1) {
            format(string,sizeof(string),"Owner: Vacant.");
        }
        else {
            format(string,sizeof(string),"Owner: %s.",GetPlayerNameEx(GetPlayerNames(Lands[tw][landOwnerId])));
        }
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Locked: %d.",Lands[tw][landLocked]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Active: %d.",Lands[tw][landActive]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        
        switch(Lands[tw][landSpecial]) {
            case 1:
            {
                format(string,sizeof(string),"Special Perks: Extortion.");
            }
            case 2:
            {
            	format(string,sizeof(string),"Special Perks: Drugs.");
            }
            default:
            {
                format(string,sizeof(string),"Special Perks: None.");
            }
        }
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You are not in a Land!");
    }
    return 1;
}

CMD:savelandppos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1) {
        new string[128];
        new tw = GetPVarInt(playerid, "EditingLandsP");
        new stage = GetPVarInt(playerid, "EditingLandPStage");
        new Float:x, Float: y, Float: z;
        new Float:tminx, Float: tminy, Float: tmaxx, Float: tmaxy;
        GetPlayerPos(playerid, x, y, z);
        if(stage == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are not editing any Land Dimensions right now!");
            return 1;
        }
        else {
            switch(stage) {
                case 1:
                {
                    SetPVarFloat(playerid, "EditingLandPMinX", x);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Land West Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savelandppos) to edit the South Wall.");
                    SetPVarInt(playerid, "EditingLandPStage", 2);
                }
                case 2:
                {
                    SetPVarFloat(playerid, "EditingLandPMinY", y);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Land South Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savelandppos) to edit the East Wall.");
                    SetPVarInt(playerid, "EditingLandPStage", 3);
                }
                case 3:
                {
                    SetPVarFloat(playerid, "EditingLandPMaxX", x);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Land East Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savelandppos) to edit the North Wall.");
                    SetPVarInt(playerid, "EditingLandPStage", 4);
                }
                case 4:
                {
                    SetPVarFloat(playerid, "EditingLandPMaxY", y);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Land Land Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    format(string,sizeof(string),"You have successfully re-created (Landid: %d) %s.",tw,Lands[tw][landName]);
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    SetPVarInt(playerid, "EditingLandPStage", -1);

                    DestroyLandPZone(tw,playerid);

                    tminx = GetPVarFloat(playerid, "EditingLandPMinX");
                    tminy = GetPVarFloat(playerid, "EditingLandPMinY");
                    tmaxx = GetPVarFloat(playerid, "EditingLandPMaxX");
                    tmaxy = GetPVarFloat(playerid, "EditingLandPMaxY");


                    
                    if(tminx > tmaxx)
							{
	                               Lands[tw][landMinX] = tmaxx;
                    Lands[tw][landMaxX] = tminx;
					        }else{
					          Lands[tw][landMinX] = tminx;
                    Lands[tw][landMaxX] = tmaxx;
					        }
					if(tminy > tmaxy)
							{
					            Lands[tw][landMinY] = tmaxy;
					            Lands[tw][landMaxY] = tminy;
					        }else{
                    Lands[tw][landMinY] = tminy;
                    Lands[tw][landMaxY] = tmaxy;
					        }

                    SetPVarFloat(playerid, "EditingLandPMinX", 0.0);
                    SetPVarFloat(playerid, "EditingLandPMinY", 0.0);
                    SetPVarFloat(playerid, "EditingLandPMaxX", 0.0);
                    SetPVarFloat(playerid, "EditingLandPMaxY", 0.0);

                    CreateLandP(1,tw);
                    ShowPlayerDialogEx(playerid,LDPEDITLANDSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
                }
            }
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
    }
    return 1;
}

CMD:landpmenu(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
        ShowPlayerDialogEx(playerid,LDPADMINMENU,DIALOG_STYLE_LIST,"Land  - Admin Menu:","Edit Turfs...","Select","Exit");
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
    }
    return 1;
}

CMD:toglands(playerid, params[])
{
    if(landpRadar[playerid] == 0) {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Land Minimap Radar.");
        ShowLandPRadar(playerid);
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Land Minimap Radar.");
        HideLandPRadar(playerid);
    }
    return 1;
}


