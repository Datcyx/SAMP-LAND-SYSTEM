
ShowDialogToPlayer(playerid, dialogid)
{
	new string[2048];
    //new vehiclestring[4096];
	switch(dialogid)
	{
		case DIALOG_BUYFURNITURE1:
		{
		    for(new i = 0; i < sizeof(furnitureCategories); i ++)
		    {
		        format(string, sizeof(string), "%s\n%s", string, furnitureCategories[i]);
		    }
		    ShowPlayerDialog(playerid, DIALOG_BUYFURNITURE1, DIALOG_STYLE_LIST, "Choose a category to browse.", string, "Select", "Cancel");
			//ShowModelSelectionMenuEx(playerid, furnitureArray, "Select an item to buy", DIALOG_BUYFURNITURE1, 16.0, 0.0, 130.0);
		}
		case DIALOG_BUYFURNITURE2:
		{
		    new index = -1;

            for(new i = 0; i < sizeof(furnitureArray); i ++)
            {
                if(!strcmp(furnitureArray[i][fCategory], furnitureCategories[PlayerInfo[playerid][pCategory]]))
                {
                    if(index == -1)
                    {
                        index = i;
                    }

                    format(string, sizeof(string), "%s\n%s ($%i)", string, furnitureArray[i][fName], furnitureArray[i][fPrice]);
                }
            }

            PlayerInfo[playerid][pFurnitureIndex] = index;
            ShowPlayerDialog(playerid, DIALOG_BUYFURNITURE2, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Back");
		}
		case DIALOG_LANDBUILDTYPE:
		{
	
	   format(string, sizeof(string), "[Land Balance:%d] Choose your browsing method.", Lands[GetPlayerLandPZone(playerid)][landbalances]);
		    ShowPlayerDialog(playerid, DIALOG_LANDBUILDTYPE, DIALOG_STYLE_LIST, string, "Browse by Model\nBrowse by List\nCancel", "Select", "Back");
		}
  		case DIALOG_LANDBUILD1:
		{
		    for(new i = 0; i < sizeof(furnitureCategories); i ++)
		    {
		        format(string, sizeof(string), "%s\n%s", string, furnitureCategories[i]);
		    }

		    ShowPlayerDialog(playerid, DIALOG_LANDBUILD1, DIALOG_STYLE_LIST, "Choose a category to browse.", string, "Select", "Back");
		}
		case DIALOG_LANDBUILD2:
		{
		    new index = -1;

            for(new i = 0; i < sizeof(furnitureArray); i ++)
            {
                if(!strcmp(furnitureArray[i][fCategory], furnitureCategories[PlayerInfo[playerid][pCategory]]))
                {
                    if(index == -1)
                    {
                        index = i;
                    }

                    format(string, sizeof(string), "%s\n%s (%s)", string, furnitureArray[i][fName], FormatNumber(furnitureArray[i][fPrice]));
                }
            }

            PlayerInfo[playerid][pFurnitureIndex] = index;
            ShowPlayerDialog(playerid, DIALOG_LANDBUILD2, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Back");
		}


	}
	return 1;
}
stock LoadObjects()
{
	printf("[oBJECTS] Loading OBJECTs from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `lobject`", "Object_Load", "");
}
stock Object_Delete2(gateid,playerid)
{
	if (gateid != -1 && LObjectData[gateid][mobjExists])
	{
		new
		    query[64];

		mysql_format(MainPipeline,query, sizeof(query), "DELETE FROM `lobject` WHERE `mobjID` = '%d'", LObjectData[gateid][mobjID]);
		mysql_tquery(MainPipeline, query);

		if (IsValidDynamicObject(LObjectData[gateid][mobjObject]))
		    DestroyDynamicObject(LObjectData[gateid][mobjObject]);

			DeletePlayer3DTextLabel(playerid, LObjectData[gateid][mobjname2]);

	    LObjectData[gateid][mobjExists] = false;
	    LObjectData[gateid][mobjID] = 0;
	}
	return 1;
}
stock Object_Delete(gateid,playerid)
{
	if (gateid != -1 && LObjectData[gateid][mobjExists])
	{
		new
		    query[64];

		mysql_format(MainPipeline,query, sizeof(query), "DELETE FROM `lobject` WHERE `mobjID` = '%d'", LObjectData[gateid][mobjID]);
		mysql_tquery(MainPipeline, query);

		if (IsValidDynamicObject(LObjectData[gateid][mobjObject]))
		    DestroyDynamicObject(LObjectData[gateid][mobjObject]);
		    
			DeletePlayer3DTextLabel(playerid, LObjectData[gateid][mobjname2]);
			
	    LObjectData[gateid][mobjExists] = false;
	    LObjectData[gateid][mobjID] = 0;
	}
	return 1;
}
forward Object_Load();
public Object_Load()
{
    static
	    rows,
	    fields;

		cache_get_row_count(rows);
	cache_get_field_count(fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_LANDSOBJ)
	{
	    LObjectData[i][mobjExists] = true;
	    cache_get_value_name_int(i, "mobjID",LObjectData[i][mobjID]);
		cache_get_value_name_int(i, "mobjModel",LObjectData[i][mobjModel]);
		cache_get_value_name_int(i, "mobjInterior",LObjectData[i][mobjInterior]);
		cache_get_value_name_int(i, "mobjWorld",LObjectData[i][mobjWorld]);
		cache_get_value_name_float(i, "mobjX",LObjectData[i][mobjPos][0]);
	    cache_get_value_name_float(i, "mobjY",LObjectData[i][mobjPos][1]);
	    cache_get_value_name_float(i, "mobjZ",LObjectData[i][mobjPos][2]);
	    cache_get_value_name_float(i, "mobjRX",LObjectData[i][mobjPos][3]);
	    cache_get_value_name_float(i, "mobjRY",LObjectData[i][mobjPos][4]);
	    cache_get_value_name_float(i, "mobjRZ",LObjectData[i][mobjPos][5]);
	     cache_get_value_name_int(i, "landid",LObjectData[i][mobjlandmobjID]);
	      cache_get_value_name_int(i, "ownerid",LObjectData[i][mobjownerID]);
	      cache_get_value_name_int(i, "price",LObjectData[i][mobjprice]);


	    LObjectData[i][mobjObject] = CreateDynamicObject(LObjectData[i][mobjModel], LObjectData[i][mobjPos][0], LObjectData[i][mobjPos][1], LObjectData[i][mobjPos][2], LObjectData[i][mobjPos][3], LObjectData[i][mobjPos][4], LObjectData[i][mobjPos][5], LObjectData[i][mobjWorld], LObjectData[i][mobjInterior]);

	 }
	printf("LAND LOADEDS");
	return 1;
}
stock Object_fSave(iHouseID,iSlotID)
{
	new
	    query[1025];
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `furniture` SET `x` = '%f', `y` = '%f', `z` = '%f', `rx` = '%f', `ry` = '%f', `rz` = '%f' WHERE `houseid` = '%d' AND `slotid` = '%d'", arrFurnitures[iSlotID][Fposx], arrFurnitures[iSlotID][Fposy], arrFurnitures[iSlotID][Fposz], arrFurnitures[iSlotID][Fposxs], arrFurnitures[iSlotID][Fposys], arrFurnitures[iSlotID][Fposzs], iHouseID, iSlotID);
	return mysql_tquery(MainPipeline, query);
}
stock Object_Save(gateid)
{
	new
	    query[1025];

	mysql_format(MainPipeline,query, sizeof(query), "UPDATE `lobject` SET `mobjModel` = '%d', `mobjX` = '%f', `mobjY` = '%f', `mobjZ` = '%f', `mobjRX` = '%f', `mobjRY` = '%f', `mobjRZ` = '%f', `mobjInterior` = '%d', `mobjWorld` = '%d', `landid` = '%d', `ownerid` ='%d', `price` ='%d'  WHERE `mobjID` = '%d'",LObjectData[gateid][mobjModel],LObjectData[gateid][mobjPos][0],LObjectData[gateid][mobjPos][1],LObjectData[gateid][mobjPos][2],LObjectData[gateid][mobjPos][3],LObjectData[gateid][mobjPos][4],LObjectData[gateid][mobjPos][5],LObjectData[gateid][mobjInterior],LObjectData[gateid][mobjWorld],LObjectData[gateid][mobjlandmobjID],LObjectData[gateid][mobjownerID],LObjectData[gateid][mobjprice],LObjectData[gateid][mobjID]);
	return mysql_tquery(MainPipeline, query);
}
stock Object_SET(gateid)
{
	new
	    query[1025];

	mysql_format(MainPipeline,query, sizeof(query), "UPDATE `lobject` SET `ownerid` ='%d' WHERE `mobjID` = '%d'",LObjectData[gateid][mobjownerID],LObjectData[gateid][mobjID]);
	return mysql_tquery(MainPipeline, query);
}
forward OnObjectCreated(gateid);
public OnObjectCreated(gateid)
{
	if (gateid == -1 || !LObjectData[gateid][mobjExists])
	    return 0;

	LObjectData[gateid][mobjID] = cache_insert_id();
	Object_Save(gateid);

	return 1;
}

stock Object_Create(playerid, idx,price)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_LANDSOBJ; i ++) if (!LObjectData[i][mobjExists])
		{
		    LObjectData[i][mobjExists] = true;
			LObjectData[i][mobjModel] = idx;

			LObjectData[i][mobjPos][0] = x + (3.0 * floatsin(-angle, degrees));
			LObjectData[i][mobjPos][1] = y + (3.0 * floatcos(-angle, degrees));
			LObjectData[i][mobjPos][2] = z;
			LObjectData[i][mobjPos][3] = 0.0;
			LObjectData[i][mobjPos][4] = 0.0;
			LObjectData[i][mobjPos][5] = angle;
			
            LObjectData[i][mobjInterior] = GetPlayerInterior(playerid);
            LObjectData[i][mobjWorld] = GetPlayerVirtualWorld(playerid);
            
            LObjectData[i][mobjObject] = CreateDynamicObject(LObjectData[i][mobjModel], LObjectData[i][mobjPos][0], LObjectData[i][mobjPos][1], LObjectData[i][mobjPos][2], LObjectData[i][mobjPos][3], LObjectData[i][mobjPos][4], LObjectData[i][mobjPos][5], LObjectData[i][mobjWorld], LObjectData[i][mobjInterior]);

			new string[1024];
			format(string, sizeof(string), "[%i]\nID: %i", LObjectData[i][mobjModel], i);

		
				new string2[1024];
				mysql_format(MainPipeline, string2, sizeof(string2), "INSERT INTO `lobject` (`mobjModel`) VALUES(%d)",i);
			mysql_tquery(MainPipeline, string2, "OnObjectCreated", "d", i);
			
			PlayerInfo[playerid][pEditmObject] = -1;
			EditDynamicObject(playerid, LObjectData[i][mobjObject]);
			PlayerInfo[playerid][pEditmObject] = i;
			LObjectData[i][mobjprice] = price;
			PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW;
			SendClientMessageEx(playerid, COLOR_WHITE, "You are now previewing this object of object ID: %d.", i);
			return i;
		}
	}
	return -1;
}
Object_Changeid(playerid){
for (new i = 0; i < MAX_LANDSOBJ; i ++)
	{
    if(Lands[GetPlayerLandPZone(playerid)][landsells] == 1){
    LObjectData[i][mobjownerID] = GetPlayerSQLId(playerid);
    Object_SET(i);
    }
	}
}
Object_Nearest(playerid)
{
    for (new i = 0; i != MAX_LANDSOBJ; i ++) if (LObjectData[i][mobjExists] && IsPlayerInRangeOfPoint(playerid, 3.0, LObjectData[i][mobjPos][0], LObjectData[i][mobjPos][1], LObjectData[i][mobjPos][2]))
	{
		if (GetPlayerInterior(playerid) == LObjectData[i][mobjInterior] && GetPlayerVirtualWorld(playerid) == LObjectData[i][mobjWorld])
			return i;
	}
	return -1;
}
stock Object_Duplicate(playerid, idx)
{
	for (new i = 0; i < MAX_LANDSOBJ; i ++) if (!LObjectData[i][mobjExists])
	{
		LObjectData[i][mobjExists] = true;
		LObjectData[i][mobjModel] = LObjectData[idx][mobjModel];

		LObjectData[i][mobjPos][0] = LObjectData[idx][mobjPos][0];
		LObjectData[i][mobjPos][1] = LObjectData[idx][mobjPos][1];
		LObjectData[i][mobjPos][2] = LObjectData[idx][mobjPos][2];
		LObjectData[i][mobjPos][3] = LObjectData[idx][mobjPos][3];
		LObjectData[i][mobjPos][4] = LObjectData[idx][mobjPos][4];
		LObjectData[i][mobjPos][5] = LObjectData[idx][mobjPos][5];

		LObjectData[i][mobjInterior] = LObjectData[idx][mobjInterior];
		LObjectData[i][mobjWorld] = LObjectData[idx][mobjInterior];

		LObjectData[i][mobjObject] = CreateDynamicObject(LObjectData[idx][mobjModel], LObjectData[idx][mobjPos][0], LObjectData[idx][mobjPos][1], LObjectData[idx][mobjPos][2], LObjectData[idx][mobjPos][3], LObjectData[idx][mobjPos][4], LObjectData[idx][mobjPos][5], LObjectData[idx][mobjWorld], LObjectData[idx][mobjInterior]);

		new string[48];
		format(string, sizeof(string), "[%i]\nID: %i", LObjectData[i][mobjModel], i);
	
		mysql_tquery(MainPipeline, "INSERT INTO `lobject` (`mobjModel`) VALUES(980)", "OnObjectCreated", "d", i);

		PlayerInfo[playerid][pEditmObject] = -1;
		EditDynamicObject(playerid, LObjectData[i][mobjObject]);
		PlayerInfo[playerid][pEditmObject] = i;
		PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW;
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the position of object ID: %d.", i);
		return i;
	}
	return -1;
}
CMD:nearobj(playerid, params[])
{
	new id;

	if(PlayerInfo[playerid][pAdmin] == 0){
	SendClientMessageEx(playerid, COLOR_RED, "You dont have permission to do this");
	}
	if((id = Object_Nearest(playerid)) >= 0)
	{
		SendClientMessageEx(playerid, COLOR_RED, "You are in range of object ID %i.", id);
	}

	return 1;
}
CMD:showvisitorsobjid(playerid, params[])
{
if(Lands[GetPlayerLandPZone(playerid)][landsells] == 1){
return SendClientMessageEx(playerid, COLOR_WHITE, "You cant edit this land because it is for sale");
}
if(Lands[GetPlayerLandPZone(playerid)][landplayer1] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer2] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer3] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer4] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer5] != GetPlayerSQLId(playerid)){
return SendClientMessageEx(playerid, COLOR_WHITE, "You dont have permission to show objects on this land");
}if(GetPVarInt(playerid, "toglabel") == 1){
	SendClientMessageEx(playerid, COLOR_WHITE, "Labels already turn on");

}else{
  for (new i = 0; i < MAX_LANDSOBJ; i ++)
	{

	if(LObjectData[i][mobjownerID] == Lands[GetPlayerLandPZone(playerid)][landOwnerId])
	{

		new string[48];
		format(string, sizeof(string), "[%i]\nID: %i", LObjectData[i][mobjModel], i);

		    LObjectData[i][mobjname2] = CreatePlayer3DTextLabel(playerid,string, COLOR_RED, LObjectData[i][mobjPos][0], LObjectData[i][mobjPos][1], LObjectData[i][mobjPos][2],5.0);
		    	SetPVarInt(playerid, "toglabel", 1);
	}
	}

}
	return 1;
}
CMD:showmyobjects(playerid, params[])
{
if(GetPVarInt(playerid, "toglabel") == 1){
	SendClientMessageEx(playerid, COLOR_WHITE, "Labels already turn on");

}else{
  for (new i = 0; i < MAX_LANDSOBJ; i ++)
	{
	if(LObjectData[i][mobjownerID] == GetPlayerSQLId(playerid))
	{

		new string[48];
		format(string, sizeof(string), "[%i]\nID: %i", LObjectData[i][mobjModel], i);

		    LObjectData[i][mobjname2] = CreatePlayer3DTextLabel(playerid,string, COLOR_RED, LObjectData[i][mobjPos][0], LObjectData[i][mobjPos][1], LObjectData[i][mobjPos][2],5.0);
		    	SetPVarInt(playerid, "toglabel", 1);
	}
	
	}
}
	return 1;
}
CMD:hidemyobjects(playerid, params[])
{

if(GetPVarInt(playerid, "toglabel") == 0){
	SendClientMessageEx(playerid, COLOR_WHITE, "Labels already turn off");

}else{
for (new i = 0; i < MAX_LANDSOBJ; i ++)
	{
    DeletePlayer3DTextLabel(playerid, LObjectData[i][mobjname2]);
	SetPVarInt(playerid, "toglabel", 0);
	}


}
	return 1;
}
CMD:hidevisitorsobjid(playerid, params[])
{
if(GetPVarInt(playerid, "toglabel") == 0){
	SendClientMessageEx(playerid, COLOR_WHITE, "Labels already turn off");

}else{
for (new i = 0; i < MAX_LANDSOBJ; i ++)
	{
    DeletePlayer3DTextLabel(playerid, LObjectData[i][mobjname2]);
	SetPVarInt(playerid, "toglabel", 0);
	}
	

}
	return 1;
}
CMD:aunsellland(playerid, params[])
{
    szMiscArray[0] = 0;
    new szResult[1024];
    new string[1024];
      new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(Lands[GetPlayerLandPZone(playerid)][landsells] == 0){
      return SendClientMessageEx(playerid, COLOR_GRAD2, "This land is not for sale");
   }else if(id == -1){
    return SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }else if (PlayerInfo[playerid][pAdmin] < 4){
   return SendClientMessageEx(playerid, COLOR_GRAD2, "You dont have permisssion to use this command");
   }else{
				Lands[GetPlayerLandPZone(playerid)][landsells] = 0;
					SaveLandP(GetPlayerLandPZone(playerid));
new zone  = GetPlayerLandPZone(playerid);
					DestroyDynamic3DTextLabel(Lands[zone][landpickupt]);
	DestroyDynamicPickup(Lands[zone][landpickup]);
		if(Lands[zone][landsells] == 1){
   			Lands[zone][landpickup] =  CreateDynamicPickup(19523, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is for sale for %d $", Lands[zone][landprices]);
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
   		}else{
   		Lands[zone][landpickup] =  CreateDynamicPickup(19524, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is owned by %s ", GetPlayerNameEx(GetPlayerNames(Lands[zone][landOwnerId])));
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
				}


	}
    return 1;
}
CMD:unsellland(playerid, params[])
{
    szMiscArray[0] = 0;
    new szResult[1024];
    new string[1024];
      new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(Lands[GetPlayerLandPZone(playerid)][landsells] == 0){
      return SendClientMessageEx(playerid, COLOR_GRAD2, "This land is not for sale");
   }else if(id == -1){
    return SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }else if(Lands[id][landOwnerId] != GetPlayerSQLId(playerid)){
    return SendClientMessageEx(playerid, COLOR_GRAD2, "This is not your land");
   }else{
				Lands[GetPlayerLandPZone(playerid)][landsells] = 0;
					SaveLandP(GetPlayerLandPZone(playerid));
new zone  = GetPlayerLandPZone(playerid);
					DestroyDynamic3DTextLabel(Lands[zone][landpickupt]);
	DestroyDynamicPickup(Lands[zone][landpickup]);
		if(Lands[zone][landsells] == 1){
   			Lands[zone][landpickup] =  CreateDynamicPickup(19523, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is for sale for %d $", Lands[zone][landprices]);
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
   		}else{
   		Lands[zone][landpickup] =  CreateDynamicPickup(19524, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is owned by %s ", GetPlayerNameEx(GetPlayerNames(Lands[zone][landOwnerId])));
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
				}
				

	}
    return 1;
}
CMD:alandsell(playerid, params[])
{
    szMiscArray[0] = 0;
    new string[1024];
      new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(Lands[GetPlayerLandPZone(playerid)][landsells] == 1){
     return SendClientMessageEx(playerid, COLOR_GRAD2, "This land is already for sale");
   }else if(id == -1){
    return SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }else if (PlayerInfo[playerid][pAdmin] < 4){
   return SendClientMessageEx(playerid, COLOR_GRAD2, "You dont have permisssion to use this command");
   }else{
		 SetPVarInt(playerid, "landsell", 1);
			format(str, sizeof(str), "Please enter the price you would like for your land", str);

		 format(string, sizeof(string), "Land Sell");

ShowPlayerDialog(playerid, DIALOG_LANDMENU2, DIALOG_STYLE_INPUT, string, str, "Accept", "Cancel");

	}
    return 1;
}
CMD:landsell(playerid, params[])
{
    szMiscArray[0] = 0;
    new string[1024];
      new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(Lands[GetPlayerLandPZone(playerid)][landsells] == 1){
      return SendClientMessageEx(playerid, COLOR_GRAD2, "This land is already for sale");
   }else if(id == -1){
    return SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }else if(Lands[id][landOwnerId] != GetPlayerSQLId(playerid)){
   return SendClientMessageEx(playerid, COLOR_GRAD2, "This is not your land");
   }else{
		 SetPVarInt(playerid, "landsell", 1);
			format(str, sizeof(str), "Please enter the price you would like for your land", str);

		 format(string, sizeof(string), "Land Sell");

ShowPlayerDialog(playerid, DIALOG_LANDMENU2, DIALOG_STYLE_INPUT, string, str, "Accept", "Cancel");

	}
    return 1;
}
CMD:buyland(playerid, params[])
{

   szMiscArray[0] = 0;
    new string[1024];
      new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(Lands[GetPlayerLandPZone(playerid)][landOwnerId] == GetPlayerSQLId(playerid)){
      return SendClientMessageEx(playerid, COLOR_GRAD2, "You already own this land");
   }else if(id == -1){
    return SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }else if(GetPlayerCash(playerid) < Lands[GetPlayerLandPZone(playerid)][landprices]){
					 return SendClientMessageEx(playerid, COLOR_WHITE, "Insuficient funds, you cant afford this land");

	}else{
				GivePlayerCash(playerid, -Lands[GetPlayerLandPZone(playerid)][landprices]);
					GivePlayerCash(GetPlayerNames(Lands[GetPlayerLandPZone(playerid)][landOwnerId]), Lands[GetPlayerLandPZone(playerid)][landprices]);
				SendClientMessageEx(GetPlayerNames(Lands[GetPlayerLandPZone(playerid)][landOwnerId]), COLOR_WHITE, "%d buy your land ",GetPlayerNameEx(playerid));
				Lands[GetPlayerLandPZone(playerid)][landOwnerId] = GetPlayerSQLId(playerid);
				Lands[GetPlayerLandPZone(playerid)][landsells] = 0;
				SaveLandP(GetPlayerLandPZone(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully buy this land");
					Object_Changeid(playerid);
					new szResult[1024];

new zone  = GetPlayerLandPZone(playerid);
					DestroyDynamic3DTextLabel(Lands[zone][landpickupt]);
	DestroyDynamicPickup(Lands[zone][landpickup]);
		if(Lands[zone][landsells] == 1){
   			Lands[zone][landpickup] =  CreateDynamicPickup(19523, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is for sale for %d $", Lands[zone][landprices]);
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
   		}else{
   		Lands[zone][landpickup] =  CreateDynamicPickup(19524, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is owned by %s ", GetPlayerNameEx(GetPlayerNames(Lands[zone][landOwnerId])));
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
				}
				

	}
    return 1;
}

CMD:setlandpickuppos(playerid, params[])
{
new szResult[1024];
new zone  = GetPlayerLandPZone(playerid);
if(GetPlayerLandPZone(playerid) == -1){
SendClientMessageEx(playerid, COLOR_WHITE, "Youre in any land");
}else if(GetPlayerLandPZone(playerid) != -1 && Lands[GetPlayerLandPZone(playerid)][landOwnerId] != GetPlayerSQLId(playerid)){
SendClientMessageEx(playerid, COLOR_WHITE, "This not in your land");
}
new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	Lands[GetPlayerLandPZone(playerid)][landpickupx] = x;
	Lands[GetPlayerLandPZone(playerid)][landpickupy] = y;
	Lands[GetPlayerLandPZone(playerid) ][landpickupz] = z;
	
	SaveLandP(GetPlayerLandPZone(playerid));
	
		DestroyDynamic3DTextLabel(Lands[zone][landpickupt]);
	DestroyDynamicPickup(Lands[zone][landpickup]);
		if(Lands[zone][landsells] == 1){
   			Lands[zone][landpickup] =  CreateDynamicPickup(19523, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is for sale for %d $", Lands[zone][landprices]);
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
   		}else{
   		Lands[zone][landpickup] =  CreateDynamicPickup(19524, 1, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 0, 0);
		   format(szResult, sizeof szResult, "This land is owned by %s ", GetPlayerNameEx(GetPlayerNames(Lands[zone][landOwnerId])));
				Lands[zone][landpickupt]= CreateDynamic3DTextLabel(szResult, COLOR_YELLOW, Lands[zone][landpickupx], Lands[zone][landpickupy], Lands[zone][landpickupz], 20.0, .worldid = 0, .interiorid = 0);
				}
	return 1;
}

/*CMD:duplicatelandobj(playerid, params[])
{
	static id = -1, idx;
  	if (sscanf(params, "d", idx)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /dupobj [id]");
  		if(GetPlayerLandPZone(playerid) != LObjectData[id][mobjlandmobjID]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in your land");
	if(GetPlayerSQLId(playerid) != LObjectData[id][mobjownerID]) return SendClientMessageEx(playerid, COLOR_WHITE, "This is not your object");


	id = Object_Duplicate(playerid, idx);
	if (id == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "The server has reached the limit for objects.");
	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully duplicate object ID: %d.", id);
	
	return 1;
}*/
CMD:visitorbuild(playerid, params[])
{
if(GetPlayerLandPZone(playerid) == -1){
return SendClientMessageEx(playerid, COLOR_WHITE, "Youre not in any land land");
}else if(Lands[GetPlayerLandPZone(playerid)][landplayer1] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer2] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer3] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer4] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer5] != GetPlayerSQLId(playerid)){
return SendClientMessageEx(playerid, COLOR_WHITE, "You dont have permission to build on this land");
}else{
new string[1024];
  format(string, sizeof(string), "Land Balance:%d Choose your browsing method.", Lands[GetPlayerLandPZone(playerid)][landbalances]);

   ShowPlayerDialog(playerid, DIALOG_LANDBUILDTYPE, DIALOG_STYLE_LIST, string, "Browse by Model\nBrowse by List\nCancel", "Select", "Back");
   SetPVarInt(playerid, "visitorbuy", 1);
}

	return 1;
}
CMD:buildland(playerid, params[])
{
new str[1024];
new str1[1024];
if(GetPVarInt(playerid, "landsystog") == 1){
		PlayerTextDrawHide(playerid, LandSys[playerid][0]);
		PlayerTextDrawHide(playerid, LandSys[playerid][1]);
		PlayerTextDrawHide(playerid, LandSys[playerid][2]);
		PlayerTextDrawHide(playerid, LandSys[playerid][3]);
		PlayerTextDrawHide(playerid, LandSys[playerid][4]);
		PlayerTextDrawHide(playerid, LandSys[playerid][5]);
		PlayerTextDrawHide(playerid, LandSys[playerid][6]);
		PlayerTextDrawHide(playerid, LandSys[playerid][7]);
		PlayerTextDrawHide(playerid, LandSys[playerid][8]);
		PlayerTextDrawHide(playerid, LandSys[playerid][9]);
		PlayerTextDrawHide(playerid, LandSys[playerid][10]);
		PlayerTextDrawHide(playerid, LandSys[playerid][11]);
		PlayerTextDrawHide(playerid, LandSys[playerid][12]);
		PlayerTextDrawHide(playerid, LandSys[playerid][13]);
		PlayerTextDrawHide(playerid, LandSys[playerid][14]);
		PlayerTextDrawHide(playerid, LandSys[playerid][15]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][0]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][1]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][2]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][3]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][4]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][5]);
		PlayerTextDrawHide(playerid, landmenubtn[playerid][6]);
		SetPVarInt(playerid, "landsystog", 1);
		        CancelSelectTextDraw(playerid);
		        	   	PlayerTextDrawShow(playerid, _hungerText[playerid][1]);
		PlayerTextDrawShow(playerid, _hungerText[playerid][0]);
		_hungerTextVisible[playerid] = 1;


}else{
if(GetPlayerLandPZone(playerid) == -1){
SendClientMessageEx(playerid, COLOR_WHITE, "Youre in any land");
}else if(GetPlayerLandPZone(playerid) != -1 && Lands[GetPlayerLandPZone(playerid)][landOwnerId] != GetPlayerSQLId(playerid)){
SendClientMessageEx(playerid, COLOR_WHITE, "This not in your land");
}else{
		PlayerTextDrawShow(playerid, LandSys[playerid][0]);
		PlayerTextDrawShow(playerid, LandSys[playerid][1]);
		PlayerTextDrawShow(playerid, LandSys[playerid][2]);
		PlayerTextDrawShow(playerid, LandSys[playerid][3]);
		PlayerTextDrawShow(playerid, LandSys[playerid][4]);
		PlayerTextDrawShow(playerid, LandSys[playerid][5]);
		PlayerTextDrawShow(playerid, LandSys[playerid][6]);
		PlayerTextDrawShow(playerid, LandSys[playerid][7]);
		PlayerTextDrawShow(playerid, LandSys[playerid][8]);
		PlayerTextDrawShow(playerid, LandSys[playerid][9]);
		PlayerTextDrawShow(playerid, LandSys[playerid][10]);
		PlayerTextDrawShow(playerid, LandSys[playerid][11]);
		PlayerTextDrawShow(playerid, LandSys[playerid][12]);
		PlayerTextDrawShow(playerid, LandSys[playerid][13]);
		PlayerTextDrawShow(playerid, LandSys[playerid][14]);
		PlayerTextDrawShow(playerid, LandSys[playerid][15]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][0]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][1]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][2]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][3]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][4]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][5]);
		PlayerTextDrawShow(playerid, landmenubtn[playerid][6]);
			format(str, sizeof(str), "%d", 	Lands[GetPlayerLandPZone(playerid)][landbalances]);
		PlayerTextDrawSetString(playerid, landmenubtn[playerid][5], str);
		format(str1, sizeof(str1), "%s", 	GetPlayerNameEx(GetPlayerNames(Lands[GetPlayerLandPZone(playerid)][landOwnerId])));
		PlayerTextDrawSetString(playerid, landmenubtn[playerid][6], str1);
		SetPVarInt(playerid, "landsystog", 0);
		SetPVarInt(playerid, "toglabel", 10);
	   SetPVarInt(playerid, "visitorbuy", 0);
	   SelectTextDraw(playerid, 0xF6FBFCFF);
	   	PlayerTextDrawHide(playerid, _hungerText[playerid][0]);
		PlayerTextDrawHide(playerid, _hungerText[playerid][1]);
		_hungerTextVisible[playerid] = 0;


		}
}
return 1;
}
CMD:buildland2(playerid, params[])
{
if(GetPlayerLandPZone(playerid) == -1){
SendClientMessageEx(playerid, COLOR_WHITE, "Youre in any land");
}else if(GetPlayerLandPZone(playerid) != -1 && Lands[GetPlayerLandPZone(playerid)][landOwnerId] != GetPlayerSQLId(playerid)){
SendClientMessageEx(playerid, COLOR_WHITE, "This not in your land");
}else{
	SetPVarInt(playerid, "toglabel", 10);
	 SetPVarInt(playerid, "visitorbuy", 0);
  new string[1024];
	   format(string, sizeof(string), "[Land Balance:%d] Choose your browsing method.", Lands[GetPlayerLandPZone(playerid)][landbalances]);

   ShowPlayerDialog(playerid, DIALOG_LANDBUILDTYPE, DIALOG_STYLE_LIST, string, "Browse by Model\nBrowse by List\nCancel", "Select", "Back");
}
	return 1;
}
/*
CMD:createobj(playerid, params[])
{
	static id = -1, idx;
   	if (sscanf(params, "d", idx)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /createobj [objid]");

	id = Object_Create(playerid, idx);
	if (id == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "The server has reached the limit for objects.");
	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully created object ID: %d.", id);
	return 1;
}*/

CMD:editlandobj(playerid, params[])
{
	static id;
   	if (sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editobj [id]");
	if ((id < 0 || id >= MAX_LANDSOBJ) || !LObjectData[id][mobjExists]) return SendClientMessageEx(playerid, COLOR_WHITE, "You have specified an invalid object ID.");
	
	if(GetPlayerLandPZone(playerid) != LObjectData[id][mobjlandmobjID]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in your land");
	if(GetPlayerSQLId(playerid) != LObjectData[id][mobjownerID]) return SendClientMessageEx(playerid, COLOR_WHITE, "This is not your object");
	
	PlayerInfo[playerid][pEditmObject] = -1;
	EditDynamicObject(playerid, LObjectData[id][mobjObject]);
	PlayerInfo[playerid][pEditmObject] = id;
	PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW2;
	SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the position of object ID: %d.", id);
	return 1;
}
CMD:visitoreditlandobj(playerid, params[])
{
	static id;
   	if (sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editobj [id]");
	if ((id < 0 || id >= MAX_LANDSOBJ) || !LObjectData[id][mobjExists]) return SendClientMessageEx(playerid, COLOR_WHITE, "You have specified an invalid object ID.");

	if(GetPlayerLandPZone(playerid) != LObjectData[id][mobjlandmobjID]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in your land");
  if(Lands[GetPlayerLandPZone(playerid)][landplayer1] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer2] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer3] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer4] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer5] != GetPlayerSQLId(playerid)){
return SendClientMessageEx(playerid, COLOR_WHITE, "You dont have permission to build on this land");
}
	PlayerInfo[playerid][pEditmObject] = -1;
	EditDynamicObject(playerid, LObjectData[id][mobjObject]);
	PlayerInfo[playerid][pEditmObject] = id;
	PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW2;
	SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the position of object ID: %d.", id);
	return 1;
}

CMD:visitorsellobjects(playerid, params[])
{
	static id = 0;
    	if (sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /delobj [id]");
	if ((id < 0 || id >= MAX_LANDSOBJ) || !LObjectData[id][mobjExists]) return SendClientMessageEx(playerid, COLOR_WHITE, "You have specified an invalid object ID.");
	if(GetPlayerLandPZone(playerid) != LObjectData[id][mobjlandmobjID]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in your land");
if(Lands[GetPlayerLandPZone(playerid)][landplayer1] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer2] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer3] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer4] != GetPlayerSQLId(playerid) && Lands[GetPlayerLandPZone(playerid)][landplayer5] != GetPlayerSQLId(playerid)){
return SendClientMessageEx(playerid, COLOR_WHITE, "You dont have permission to sell this object");
}	new str[57+1];
SetPVarInt(playerid, "sellobj", id);
format(str, sizeof(str), "%sYou will get a refund {880808}%d $ {Ffffff} For this item", str,LObjectData[id][mobjprice]);

ShowPlayerDialog(playerid, DIALOG_SELL, DIALOG_STYLE_MSGBOX, "{fff000}Are you sure do you want to sell this item?", str, "Accept", "Cancel");
SetPVarInt(playerid, "visitorbuy", 1);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have sell your object for%d.", LObjectData[id][mobjprice]);
 new ccs[1024];
		format(ccs, sizeof(ccs), "+ %d", LObjectData[id][mobjprice]);
	GameTextForPlayer(playerid, ccs, 5000, 1);
	return 1;
}

CMD:sellmyobjects(playerid, params[])
{
	static id = 0;
    	if (sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /delobj [id]");
	if ((id < 0 || id >= MAX_LANDSOBJ) || !LObjectData[id][mobjExists]) return SendClientMessageEx(playerid, COLOR_WHITE, "You have specified an invalid object ID.");
	if(GetPlayerLandPZone(playerid) != LObjectData[id][mobjlandmobjID]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in your land");
	if(GetPlayerSQLId(playerid) != LObjectData[id][mobjownerID]) return SendClientMessageEx(playerid, COLOR_WHITE, "This is not your object");
	new str[57+1];
SetPVarInt(playerid, "sellobj", id);
SetPVarInt(playerid, "visitorbuy", 0);
format(str, sizeof(str), "%sYou will get a refund {880808}%d $ {Ffffff} For this item", str,LObjectData[id][mobjprice]);

ShowPlayerDialog(playerid, DIALOG_SELL, DIALOG_STYLE_MSGBOX, "{fff000}Are you sure do you want to sell this item?", str, "Accept", "Cancel");

	SendClientMessageEx(playerid, COLOR_WHITE, "You have sell your object for%d.", LObjectData[id][mobjprice]);
 new ccs[1024];
		format(ccs, sizeof(ccs), "+ %d", LObjectData[id][mobjprice]);
	GameTextForPlayer(playerid, ccs, 5000, 1);
	return 1;
}
CMD:landperms(playerid, params[])
{
    szMiscArray[0] = 0;
    new string[1024];
   new id = GetPlayerLandPZone(playerid);
   if(id == -1){
   SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }if(Lands[id][landOwnerId] != GetPlayerSQLId(playerid)){
   SendClientMessageEx(playerid, COLOR_GRAD2, "This is not your land");
   }else{
			new name1[1024],name2[1024],name3[1024],name4[1024],name5[1024];
				if(Lands[id][landplayer1] == -1){
				name1 = "None";
				}else{
				 name1 = GetPlayerNameEx(GetPlayerNames(Lands[id][landplayer1]));
				}
				if(Lands[id][landplayer2] == -1){
				name2 = "None";
				}else{
				 name2 = GetPlayerNameEx(GetPlayerNames(Lands[id][landplayer2]));
				}
				if(Lands[id][landplayer3] == -1){
				name3 = "None";
				}else{
				 name3 = GetPlayerNameEx(GetPlayerNames(Lands[id][landplayer3]));
				}
				if(Lands[id][landplayer4] == -1){
				name4 = "None";
				}else{
				 name4 = GetPlayerNameEx(GetPlayerNames(Lands[id][landplayer4]));
				}
				if(Lands[id][landplayer5] == -1){
				name5 = "None";
				}else{
				 name5 = GetPlayerNameEx(GetPlayerNames(Lands[id][landplayer5]));
				}
					format(string,sizeof(string),"(%s)\n(%s)\n(%s)\n(%s)\n(%s)",name1,name2,name3,name4,name5);
	ShowPlayerDialog(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_LIST, "LAND PERMS", string, "OK", "Cancel");

	}
    return 1;
}
CMD:landdeposit(playerid, params[])
{
    szMiscArray[0] = 0;
    new string[1024];
      new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(id == -1){
   SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }if(Lands[id][landOwnerId] != GetPlayerSQLId(playerid)){
   SendClientMessageEx(playerid, COLOR_GRAD2, "This is not your land");
   }else{
		 SetPVarInt(playerid, "withdrawtrue", 0);
			format(str, sizeof(str), "Please enter the amount you would like to deposit", str);

		 format(string, sizeof(string), "[Land Balance:%d] Land Deposit", Lands[GetPlayerLandPZone(playerid)][landbalances]);

ShowPlayerDialog(playerid, DIALOG_LANDMENU1, DIALOG_STYLE_INPUT, string, str, "Accept", "Cancel");

	}
    return 1;
}
CMD:landwithdraw(playerid, params[])
{
    szMiscArray[0] = 0;
    new string[1024];
    new str[1024];
   new id = GetPlayerLandPZone(playerid);
   if(id == -1){
   SendClientMessageEx(playerid, COLOR_GRAD2, "Youre not in rage of any land");
   }if(Lands[id][landOwnerId] != GetPlayerSQLId(playerid)){
   SendClientMessageEx(playerid, COLOR_GRAD2, "This is not your land");
   }else{
   SetPVarInt(playerid, "withdrawtrue", 1);
			format(str, sizeof(str), "Please enter the amount you would like to withdraw", str);
			
		 format(string, sizeof(string), "[Land Balance:%d] Land Withdraw", Lands[GetPlayerLandPZone(playerid)][landbalances]);

ShowPlayerDialog(playerid, DIALOG_LANDMENU1, DIALOG_STYLE_INPUT, string, str, "Accept", "Cancel");

	}
    return 1;
}
public OnPlayerSelectionMenuResponse(playerid, extraid, response, listitem, modelid)
{
	switch(extraid)
	{
	    /*case MODEL_SELECTION_FURNITURE:
	    {
	        if(response)
	        {
	            new houseid = GetInsideHouse(playerid);

	            if(houseid >= 0 && HasFurniturePerms(playerid, houseid))
	            {
		            PurchaseFurniture(playerid, listitem + WickedInfo[playerid][pFurnitureIndex]);
				}
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_BUYFURNITURE1);
			}
	    }*/

	    case MODEL_SELECTION_LANDOBJECTS:
	    {
	        if(response)
	        {
	            new landid = GetPlayerLandPZone(playerid);

		    
					PurchaseLandObject(playerid, listitem + PlayerInfo[playerid][pFurnitureIndex]);
			}
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_LANDBUILD1);
			}
	    }
	}

	return 1;
}


PurchaseLandObject(playerid, index)
{
SetPVarInt(playerid, "sellobjprice", furnitureArray[index][fPrice]);
      Object_Create(playerid, furnitureArray[index][fModel],furnitureArray[index][fPrice]);

}
