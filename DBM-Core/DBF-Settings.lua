--[[
	********************************************************************
	********************************************************************
	Handles Slash commands and settings menu	
	********************************************************************
	********************************************************************
]]--
local DBFSettings;
local DBF_CHAR_SAVE;
function DBF_Settings_SetDefaults()
	if(not _G["DBFSettings"]) then _G["DBFSettings"] = {}; end
	DBFSettings = _G["DBFSettings"];
	if(not _G["DBF_CHAR_SAVE"]) then _G["DBF_CHAR_SAVE"] = {}; end
	DBF_CHAR_SAVE = _G["DBF_CHAR_SAVE"];
	
	-- DBF Frame
	if(DBFSettings['SFLocked'] == nil) then DBFSettings['SFLocked'] = 0; end
	if(DBFSettings['SFHideBorder'] == nil) then DBFSettings['SFHideBorder'] = 1; end
	
	--CHARACTER SPECIFIC SAVE
	if(not DBF_CHAR_SAVE.shaman) then DBF_CHAR_SAVE.shaman = {}; end
	if(not DBF_CHAR_SAVE.shaman.maelstromframe) then
		DBF_CHAR_SAVE.shaman.maelstromframe = {
			['locked'] = false,
			['scale'] = 1,
		};
	end
end

function DBF_Toggle_Bool(var)
	if(var) then
		return false;
	else
		return true;
	end
end

function DBF_Toggle_Setting()
	local s = this.value;
	if(DBFSettings[s]==1) then
		DBFSettings[s] = 0;
	else
		DBFSettings[s] = 1;
	end
end

function DBF_GetCVar(var,value)
	if(GetCVar(var)==value) then
		return true;
	else
		return false;
	end
end

function DBF_ToggleCVar(var)
	if(GetCVar(var)=="1") then
		SetCVar(var,"0");
	else
		SetCVar(var,"1");
	end
	dbf_printc("Setting WoWCVar |cFFFFFFFF"..var.."|cFF8888CC to |cFFFFFFFF"..GetCVar(var));
end

function DBF_SetCVar(var,value,quiet)
	SetCVar(var,value);
	if(not quiet) then
		dbf_printc("Setting WoWCVar |cFFFFFFFF"..var.."|cFF8888CC to |cFFFFFFFF"..value);
	end
end

function DBF_SetS(s,value)
	DBFSettings[s] = value;
	dbf_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFF"..value);
end

function DBF_GetS(s)
	if(DBFSettings[s] == 1) then
		return true;
	elseif(DBFSettings[s] == 0) then
		return false;
	else
		return DBFSettings[s];
	end
end

function DBF_PrintVaribelInfo()
	dbf_printc("InRaid Detected: "..dbf_c_w..((DBF_IN_RAID and "true") or "false"));
	dbf_printc("RaidSize Detected: "..dbf_c_w..DBF_DUNGEON_SIZE);
	dbf_printc("RaidDifficulty Detected: "..dbf_c_w..DBF_DUNGEON_DIFFICULTY);
end
--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, 1]  --  Check the button
info.isTitle = [nil, 1]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, 1]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.hasArrow = [nil, 1]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, 1]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.textR = [1 - 255]  --  Red color value of the button text
info.textG = [1 - 255]  --  Green color value of the button text
info.textB = [1 - 255]  --  Blue color value of the button text
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.justifyH = [nil, "CENTER"] -- Justify button text
info.arg1 = [ANYTHING] -- This is the first argument used by info.func
info.arg2 = [ANYTHING] -- This is the second argument used by info.func
info.textHeight = [NUMBER] -- font height for button text


CONSTANTS;
==========================================
UIDROPDOWNMENU_MENU_LEVEL
UIDROPDOWNMENU_MENU_VALUE
]]--

local function createChannelName()
	myguildName,_,_,_ = GetGuildInfo("player");
	noSpaceGuildName = gsub(myguildName, "%s+", "")
	guildChannel = noSpaceGuildName.."SBM"
end

DBM:Schedule(19, createChannelName)

function DBF_Settings_Menuofdoom()
	local info = {};
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		--[[ ***************************************
		     /////// FIRST MENU \\\\\\\\
		     ***************************************]]--
		
		local ShowEXTRAOfficer = true;
		local ShowOfficer = true;
		amnt = 1; -- amount of white spaces
		guildName,_,guildRankIndex = GetGuildInfo("player");
		
		local myName = UnitName("player")
		local REALM_NAME = GetRealmName();
		local myguildName, myguildRankName, myguildRankIndex, myguildRealm = GetGuildInfo(myName)
	
		if(REALM_NAME == "Andorhal - No-Risk") then
			if(myguildName == "toxicity") then
				if(myguildRankIndex == 0 or myguildRankIndex == 1 or myguildRankIndex == 2) then
					ShowOfficer = true;
					ShowEXTRAOfficer = false;
					amnt = 1;
				end
			elseif(myguildName == "Long Live Cenarius") then
				if(myguildRankIndex == 0 or myguildRankIndex == 1) then
					ShowOfficer = true;
					ShowEXTRAOfficer = true;
					amnt = 1;
				end
			elseif(myguildName == "Exiled") then
				if(myguildRankIndex == 0 or myguildRankIndex == 1 or myguildRankIndex == 2 or myguildRankIndex == 3) then
					ShowOfficer = true;
					amnt = 1;
				end			
			elseif(myguildName == "HordeGuards") then
				if(myguildRankIndex == 0 or myguildRankIndex == 1) then
					ShowOfficer = true;
					amnt = 1;
				end
			elseif(ShowOfficer == false) then
				if(myguildName) then
					if(myguildRankIndex == 0 or myguildRankIndex == 1) then
						ShowOfficer = true;
						amnt = 1;
					end
				end
			end	
		elseif(REALM_NAME == "Laughing Skull - High-Risk") then
			if(myguildName == "Method") then
				if(myguildRankIndex == 0 or myguildRankIndex == 1 or myguildRankIndex == 2) then
					ShowOfficer = true;
					amnt = 1;
				end
			elseif(ShowOfficer == false) then
				if(myguildName) then
					if(myguildRankIndex == 0 or myguildRankIndex == 1) then
						ShowOfficer = true;
						amnt = 1;
					end
				end
			end	
		else
		-----DEBUG-----
			if(ShowOfficer == false) then
				if(myguildName) then
					if(myguildRankIndex == 0 or myguildRankIndex == 1) then
						ShowOfficer = true;
						amnt = 1;
					end
				end
			end	
		end
	
			 
		if(ShowEXTRAOfficer) then
			info = {};
			info.text = "Ability Checks";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ChecksMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		end	 
			 
		info = {};
		info.text = "DBF Settings";
		info.hasArrow = 1;
		info.notCheckable = 1;
		info.value = "DBFSettingsMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		if(ShowOfficer) then
			info = {};
			info.text = "Officer";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		end
		
		if(ShowEXTRAOfficer) then
			info = {};
			info.text = "Check versions";
			info.tooltipTitle = info.text;
			info.tooltipText = "People who have a different version than you will get a warning to update their addon.";
			info.notCheckable = 1;
			info.func = function() ChanID = GetChannelName(guildChannel);
			SendChatMessage("tbm_tv: get_version_"..DBM.Version, "CHANNEL", nil, ChanID) end;
			info.value = "CheckVersions";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		end
	end
	
		--[[ ***************************************
		/////// GENERAL MENU \\\\\\\\
		***************************************]]--
				
		if(UIDROPDOWNMENU_MENU_VALUE == "DBFSettingsMenu") then
			info = {};
			info.text = "General";
			info.isTitle = 1;
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
			info = {};
			info.text = "DBF frame";
			info.tooltipTitle = info.text;
			info.tooltipText = "Change the settings for the frame.";
			info.notCheckable = 1;
			info.hasArrow = 1;
			info.checked = DBF_GetS("FrameSettings");
			info.value = "FrameSettings";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
			info = {};
			info.text = "Show commands list";
			info.tooltipTitle = info.text;
			info.tooltipText = "Open a window which shows commands you can use.";
			info.notCheckable = 1;
			info.func = function() DeadlyBuffFrames_PrintOfficerInfo(); end;
			info.value = "ShowOfficerCommands";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		end
			
			if(UIDROPDOWNMENU_MENU_VALUE == "FrameSettings") then
				info = {};
				info.text = "DBF frame";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
				info = {};
				info.text = "Prevent dragging";
				info.tooltipTitle = info.text;
				info.tooltipText = "Prevent the frame from being dragged around.";
				info.keepShownOnClick = 1;
				info.checked = DBF_GetS("SFLocked");
				info.func = DBF_Toggle_Setting;
				info.value = "SFLocked";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "Hide border";
				info.tooltipTitle = info.text;
				info.tooltipText = "Hide the border around the frame.";
				info.keepShownOnClick = 1;
				info.checked = DBF_GetS("SFHideBorder");
				info.func = function(v) DBF_Toggle_Setting(v) DBF_SF_SetBorder() end;
				info.value = "SFHideBorder";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			
		--[[ ***************************************
		/////// OFFICER MENU \\\\\\\\
		***************************************]]--
					
		if(UIDROPDOWNMENU_MENU_VALUE == "OfficerMenu") then			
			info = {};
			info.text = "Officer Commands";
			info.isTitle = 1;
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);

			info = {};
			info.text = "General Group Settings";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerGGSMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);				
			
			info = {};
			info.text = "Dungeon Difficulties";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerDDMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Raid Difficulties";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerRDMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Loot Methods";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerLMMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Break Timers";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerBTMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Pull Timers";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerPTMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Mark Target";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerMTMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
		end
			
			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerGGSMenu") then
				info = {};
				info.text = "Group Settings";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "Assist Everyone";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:PromoteAllRaidTBM() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "Convert to Raid";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:ConvertRaid() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
				
				info = {};
				info.text = "Disband Group";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:DisbandGroup() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Reset all Instances";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:ResetInstance() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);					
			end
			
			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerDDMenu") then
				info = {};
				info.text = "Dungeon Difficulty";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "Normal 5";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:Normal5() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "Heroic 5";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:Heroic5() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);					
			end		

			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerRDMenu") then
				info = {};
				info.text = "Raid Difficulty";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "Normal 10";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:Normal10() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "Heroic 10";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:Heroic10() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Normal 25";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:Normal25() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "Heroic 25";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:Heroic25() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);				
			end	

			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerLMMenu") then
				info = {};
				info.text = "Loot Method";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "Free For All";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:FreeForAll() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "Group Loot";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:GroupLoot() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Master Loot";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MasterLoot() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);				
			end		

			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerBTMenu") then
				info = {};
				info.text = "Break Timers";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "5 Mins";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function()
				if DBM:GetRaidRank() == 0 then
					DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					return
				end
				local timer = 5 * 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				DBM:CreatePizzaTimer(timer, DBM_CORE_TIMER_BREAK, true)
				DBM:Unschedule(SendChatMessage)
				SendChatMessage(DBM_CORE_BREAK_START:format(timer/60), channel)
				if timer/60 > 5 then DBM:Schedule(timer - 5*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(5), channel) end
				if timer/60 > 2 then DBM:Schedule(timer - 2*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(2), channel) end
				if timer/60 > 1 then DBM:Schedule(timer - 1*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(1), channel) end
				if timer > 30 then DBM:Schedule(timer - 30, SendChatMessage, DBM_CORE_BREAK_SEC:format(30), channel) end
				DBM:Schedule(timer, SendChatMessage, DBM_CORE_ANNOUNCE_BREAK_OVER, channel)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "10 Mins";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function()
				if DBM:GetRaidRank() == 0 then
					DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					return
				end
				local timer = 10 * 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				DBM:CreatePizzaTimer(timer, DBM_CORE_TIMER_BREAK, true)
				DBM:Unschedule(SendChatMessage)
				SendChatMessage(DBM_CORE_BREAK_START:format(timer/60), channel)
				if timer/60 > 5 then DBM:Schedule(timer - 5*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(5), channel) end
				if timer/60 > 2 then DBM:Schedule(timer - 2*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(2), channel) end
				if timer/60 > 1 then DBM:Schedule(timer - 1*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(1), channel) end
				if timer > 30 then DBM:Schedule(timer - 30, SendChatMessage, DBM_CORE_BREAK_SEC:format(30), channel) end
				DBM:Schedule(timer, SendChatMessage, DBM_CORE_ANNOUNCE_BREAK_OVER, channel)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "15 Mins";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function()
				if DBM:GetRaidRank() == 0 then
					DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					return
				end
				local timer = 15 * 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				DBM:CreatePizzaTimer(timer, DBM_CORE_TIMER_BREAK, true)
				DBM:Unschedule(SendChatMessage)
				SendChatMessage(DBM_CORE_BREAK_START:format(timer/60), channel)
				if timer/60 > 5 then DBM:Schedule(timer - 5*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(5), channel) end
				if timer/60 > 2 then DBM:Schedule(timer - 2*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(2), channel) end
				if timer/60 > 1 then DBM:Schedule(timer - 1*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(1), channel) end
				if timer > 30 then DBM:Schedule(timer - 30, SendChatMessage, DBM_CORE_BREAK_SEC:format(30), channel) end
				DBM:Schedule(timer, SendChatMessage, DBM_CORE_ANNOUNCE_BREAK_OVER, channel)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "20 Mins";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function()
				if DBM:GetRaidRank() == 0 then
					DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					return
				end
				local timer = 20 * 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				DBM:CreatePizzaTimer(timer, DBM_CORE_TIMER_BREAK, true)
				DBM:Unschedule(SendChatMessage)
				SendChatMessage(DBM_CORE_BREAK_START:format(timer/60), channel)
				if timer/60 > 5 then DBM:Schedule(timer - 5*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(5), channel) end
				if timer/60 > 2 then DBM:Schedule(timer - 2*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(2), channel) end
				if timer/60 > 1 then DBM:Schedule(timer - 1*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(1), channel) end
				if timer > 30 then DBM:Schedule(timer - 30, SendChatMessage, DBM_CORE_BREAK_SEC:format(30), channel) end
				DBM:Schedule(timer, SendChatMessage, DBM_CORE_ANNOUNCE_BREAK_OVER, channel)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "30 Mins";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function()
				if DBM:GetRaidRank() == 0 then
					DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					return
				end
				local timer = 30 * 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				DBM:CreatePizzaTimer(timer, DBM_CORE_TIMER_BREAK, true)
				DBM:Unschedule(SendChatMessage)
				SendChatMessage(DBM_CORE_BREAK_START:format(timer/60), channel)
				if timer/60 > 5 then DBM:Schedule(timer - 5*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(5), channel) end
				if timer/60 > 2 then DBM:Schedule(timer - 2*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(2), channel) end
				if timer/60 > 1 then DBM:Schedule(timer - 1*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(1), channel) end
				if timer > 30 then DBM:Schedule(timer - 30, SendChatMessage, DBM_CORE_BREAK_SEC:format(30), channel) end
				DBM:Schedule(timer, SendChatMessage, DBM_CORE_ANNOUNCE_BREAK_OVER, channel)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "60 Mins";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function()
				if DBM:GetRaidRank() == 0 then
					DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					return
				end
				local timer = 60 * 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				DBM:CreatePizzaTimer(timer, DBM_CORE_TIMER_BREAK, true)
				DBM:Unschedule(SendChatMessage)
				SendChatMessage(DBM_CORE_BREAK_START:format(timer/60), channel)
				if timer/60 > 5 then DBM:Schedule(timer - 5*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(5), channel) end
				if timer/60 > 2 then DBM:Schedule(timer - 2*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(2), channel) end
				if timer/60 > 1 then DBM:Schedule(timer - 1*60, SendChatMessage, DBM_CORE_BREAK_MIN:format(1), channel) end
				if timer > 30 then DBM:Schedule(timer - 30, SendChatMessage, DBM_CORE_BREAK_SEC:format(30), channel) end
				DBM:Schedule(timer, SendChatMessage, DBM_CORE_ANNOUNCE_BREAK_OVER, channel)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);					
			end		

			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerPTMenu") then
			
				local function pullInFive()
					local ChannelID = GetChannelName(guildChannel)
					SendChatMessage("tbm_cmd: pull_5_remaining", "CHANNEL", nil, ChannelID)
				end

				local function pullNow()
					local ChannelID = GetChannelName(guildChannel)
					SendChatMessage("tbm_cmd: pull_now", "CHANNEL", nil, ChannelID)
				end				
				
				info = {};
				info.text = "Pull Timers";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "10 Sec";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() 
				if DBM:GetRaidRank() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				end
				local timer = 10
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				SendChatMessage(DBM_CORE_ANNOUNCE_PULL:format(timer), channel)
				if timer > 10 then 
					DBM:Schedule(timer - 10, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(10), channel) 
				end
				if timer > 7 then 
					DBM:Schedule(timer - 7, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(7), channel) 
				end
				if timer > 5 then 
					DBM:Schedule(timer - 5, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(5), channel)
					DBM:Schedule(timer - 5, pullInFive)
				end
				if timer > 4 then 
					DBM:Schedule(timer - 4, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(4), channel)
				end
				if timer > 3 then 
					DBM:Schedule(timer - 3, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(3), channel) 
				end
				if timer > 2 then 
					DBM:Schedule(timer - 2, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(2), channel) 
				end
				if timer > 1 then 
					DBM:Schedule(timer - 1, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(1), channel) 
				end
					DBM:Schedule(timer - 0, SendChatMessage, DBM_CORE_ANNOUNCE_PULL_NOW, channel)
					DBM:Schedule(timer - 0, pullNow)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "15 Sec";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() 
				if DBM:GetRaidRank() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				end
				local timer = 15
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				SendChatMessage(DBM_CORE_ANNOUNCE_PULL:format(timer), channel)
				if timer > 10 then 
					DBM:Schedule(timer - 10, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(10), channel) 
				end
				if timer > 7 then 
					DBM:Schedule(timer - 7, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(7), channel) 
				end
				if timer > 5 then 
					DBM:Schedule(timer - 5, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(5), channel)
					DBM:Schedule(timer - 5, pullInFive)
				end
				if timer > 4 then 
					DBM:Schedule(timer - 4, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(4), channel)
				end
				if timer > 3 then 
					DBM:Schedule(timer - 3, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(3), channel) 
				end
				if timer > 2 then 
					DBM:Schedule(timer - 2, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(2), channel) 
				end
				if timer > 1 then 
					DBM:Schedule(timer - 1, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(1), channel) 
				end
					DBM:Schedule(timer - 0, SendChatMessage, DBM_CORE_ANNOUNCE_PULL_NOW, channel)
					DBM:Schedule(timer - 0, pullNow)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "20 Sec";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() 
				if DBM:GetRaidRank() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				end
				local timer = 20
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				SendChatMessage(DBM_CORE_ANNOUNCE_PULL:format(timer), channel)
				if timer > 10 then 
					DBM:Schedule(timer - 10, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(10), channel) 
				end
				if timer > 7 then 
					DBM:Schedule(timer - 7, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(7), channel) 
				end
				if timer > 5 then 
					DBM:Schedule(timer - 5, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(5), channel)
					DBM:Schedule(timer - 5, pullInFive)
				end
				if timer > 4 then 
					DBM:Schedule(timer - 4, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(4), channel)
				end
				if timer > 3 then 
					DBM:Schedule(timer - 3, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(3), channel) 
				end
				if timer > 2 then 
					DBM:Schedule(timer - 2, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(2), channel) 
				end
				if timer > 1 then 
					DBM:Schedule(timer - 1, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(1), channel) 
				end
					DBM:Schedule(timer - 0, SendChatMessage, DBM_CORE_ANNOUNCE_PULL_NOW, channel)
					DBM:Schedule(timer - 0, pullNow)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "25 Sec";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() 
				if DBM:GetRaidRank() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				end
				local timer = 25
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				SendChatMessage(DBM_CORE_ANNOUNCE_PULL:format(timer), channel)
				if timer > 10 then 
					DBM:Schedule(timer - 10, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(10), channel) 
				end
				if timer > 7 then 
					DBM:Schedule(timer - 7, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(7), channel) 
				end
				if timer > 5 then 
					DBM:Schedule(timer - 5, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(5), channel)
					DBM:Schedule(timer - 5, pullInFive)
				end
				if timer > 4 then 
					DBM:Schedule(timer - 4, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(4), channel)
				end
				if timer > 3 then 
					DBM:Schedule(timer - 3, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(3), channel) 
				end
				if timer > 2 then 
					DBM:Schedule(timer - 2, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(2), channel) 
				end
				if timer > 1 then 
					DBM:Schedule(timer - 1, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(1), channel) 
				end
					DBM:Schedule(timer - 0, SendChatMessage, DBM_CORE_ANNOUNCE_PULL_NOW, channel)
					DBM:Schedule(timer - 0, pullNow)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "30 Sec";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() 
				if DBM:GetRaidRank() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				end
				local timer = 30
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				SendChatMessage(DBM_CORE_ANNOUNCE_PULL:format(timer), channel)
				if timer > 10 then 
					DBM:Schedule(timer - 10, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(10), channel) 
				end
				if timer > 7 then 
					DBM:Schedule(timer - 7, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(7), channel) 
				end
				if timer > 5 then 
					DBM:Schedule(timer - 5, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(5), channel)
					DBM:Schedule(timer - 5, pullInFive)
				end
				if timer > 4 then 
					DBM:Schedule(timer - 4, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(4), channel)
				end
				if timer > 3 then 
					DBM:Schedule(timer - 3, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(3), channel) 
				end
				if timer > 2 then 
					DBM:Schedule(timer - 2, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(2), channel) 
				end
				if timer > 1 then 
					DBM:Schedule(timer - 1, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(1), channel) 
				end
					DBM:Schedule(timer - 0, SendChatMessage, DBM_CORE_ANNOUNCE_PULL_NOW, channel)
					DBM:Schedule(timer - 0, pullNow)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "60 Sec";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() 
				if DBM:GetRaidRank() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				end
				local timer = 60
				local channel = ((GetNumRaidMembers() == 0) and "PARTY") or "RAID_WARNING"
				SendChatMessage(DBM_CORE_ANNOUNCE_PULL:format(timer), channel)
				if timer > 10 then 
					DBM:Schedule(timer - 10, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(10), channel) 
				end
				if timer > 7 then 
					DBM:Schedule(timer - 7, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(7), channel) 
				end
				if timer > 5 then 
					DBM:Schedule(timer - 5, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(5), channel)
					DBM:Schedule(timer - 5, pullInFive)
				end
				if timer > 4 then 
					DBM:Schedule(timer - 4, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(4), channel)
				end
				if timer > 3 then 
					DBM:Schedule(timer - 3, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(3), channel) 
				end
				if timer > 2 then 
					DBM:Schedule(timer - 2, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(2), channel) 
				end
				if timer > 1 then 
					DBM:Schedule(timer - 1, SendChatMessage, DBM_CORE_ANNOUNCE_PULL:format(1), channel) 
				end
					DBM:Schedule(timer - 0, SendChatMessage, DBM_CORE_ANNOUNCE_PULL_NOW, channel)
					DBM:Schedule(timer - 0, pullNow)
				end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);					
			end		

			if(UIDROPDOWNMENU_MENU_VALUE == "OfficerMTMenu") then
				info = {};
				info.text = "Mark Target";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	
				info = {};
				info.text = "Skull";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget8() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
	
				info = {};
				info.text = "Cross";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget7() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Square";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget6() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Moon";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget5() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Diamond";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget4() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Triangle";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget3() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Circle";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget2() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Star";
				info.tooltipTitle = info.text;
				info.tooltipText = "";
				info.notCheckable = 1;
				info.func = function() DBM:MarkTarget1() end
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);					
			end					
			
		--[[ ***************************************
		/////// CHECKS MENU \\\\\\\\
		***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "ChecksMenu") then
			info = {};
			info.text = "Ability Checks";
			info.isTitle = 1;
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
			info = {};
			info.text = "Disarms";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Disarms", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Disorients";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Disorients", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
			info = {};
			info.text = "Fears";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Fears", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
			info = {};
			info.text = "Immunities";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ChecksImmunitiesMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

			info = {};
			info.text = "Incapacitation";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Incapacitation", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);				
		
			info = {};
			info.text = "Interrupts";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Interrupts", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
			
			info = {};
			info.text = "Mana Drains";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Mana Drains", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);				
			
			info = {};
			info.text = "Roots";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Roots", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);						

			info = {};
			info.text = "Slows";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Slows", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);					
			
			info = {};
			info.text = "Stuns";
			info.tooltipTitle = info.text;
			info.tooltipText = "Ability check for: "..info.text;
			info.notCheckable = 1;
			info.func = function() 
				local ChanID = GetChannelName(guildChannel);
				SendChatMessage("tbm_cmd: check: Stuns", "CHANNEL", nil, ChanID) 
			end;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);								
			
			info = {};
			info.text = "Totems";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ChecksTotemMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
			info = {};
			info.text = "Utility";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ChecksUtilityMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	
		end
		
			if(UIDROPDOWNMENU_MENU_VALUE == "ChecksImmunitiesMenu") then
				info = {};
				info.text = "Spells";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
				info = {};
				info.text = "Deterrence";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Deterrence", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);				
				
				info = {};
				info.text = "Divine Shield";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Divine Shield", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Ice Block";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Ice Block", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
		
			if(UIDROPDOWNMENU_MENU_VALUE == "ChecksTotemMenu") then
				info = {};
				info.text = "Spells";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
				info = {};
				info.text = "Cleansing Totem";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Cleansing Totem", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Grounding Totem";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Grounding Totem", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Tremor Totem";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Tremor Totem", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "ChecksUtilityMenu") then
				info = {};
				info.text = "Spells";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
				info = {};
				info.text = "Focus Magic";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Focus Magic", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);

				info = {};
				info.text = "Cleanse";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Cleanse", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);

				info = {};
				info.text = "Curse of the Elements";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Curse of the Elements", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Curse of Tongues";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Curse of Tongues", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Disarm Trap";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Disarm Trap", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Fade";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Fade", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Feign Death";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function()
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Feign Death", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);	

				info = {};
				info.text = "Purge";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Purge", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Remove Curse";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Remove Curse", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);		

				info = {};
				info.text = "Tranquilizing Shot";
				info.tooltipTitle = info.text;
				info.tooltipText = "Ability check for: "..info.text;
				info.notCheckable = 1;
				info.func = function() 
					local ChanID = GetChannelName(guildChannel);
					SendChatMessage("tbm_cmd: check: Tranquilizing Shot", "CHANNEL", nil, ChanID) 
				end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);						
			end
		--[[ ***************************************
		/////// PRINT INFO MENU \\\\\\\\
		***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "Printinfo") then
			info = {};
			info.text = "Print info";
			info.isTitle = 1;
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
			info = {};
			info.text = "Groupleader/Officer info";
			info.func = DeadlyBuffFrames_PrintOfficerInfo;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
		end
end