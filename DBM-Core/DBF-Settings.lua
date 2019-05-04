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

function DBF_Settings_Menuofdoom()
	local info = {};
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		--[[ ***************************************
		     /////// FIRST MENU \\\\\\\\
		     ***************************************]]--
		info = {};
		info.text = "General";
		info.hasArrow = 1;
		info.notCheckable = 1;
		info.value = "DBFSettingsMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		local ShowOfficer = false;
		amnt = 1; -- amount of white spaces
		guildName,_,guildRankIndex = GetGuildInfo("player");
		if(UnitName("player") == "Sky") then
			ShowOfficer = true;
			amnt = 1;
		end
		
		if(ShowOfficer) then
			info = {};
			info.text = "Checks";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ChecksMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
			info = {};
			info.text = "Officer";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "OfficerMenu";
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
			info.text = "Show OBM commands";
			info.tooltipTitle = info.text;
			info.tooltipText = "Open a window which shows commands you can use.";
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
			info.text = "Check versions";
			info.tooltipTitle = info.text;
			info.tooltipText = "People who have a different version than you will get a warning to update their addon.";
			info.func = function() ChanID = GetChannelName("OBMCOMMAND");
			SendChatMessage("obm_tv: get_version_"..DBM.Version, "CHANNEL", nil, ChanID) end;
			info.value = "CheckVersions";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		end
			
		--[[ ***************************************
		/////// CHECKS MENU \\\\\\\\
		***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "ChecksMenu") then
			info = {};
			info.text = "Checks";
			info.isTitle = 1;
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);

			info = {};
			info.text = "Spells";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ChecksGeneralMenu";
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		end
		
			if(UIDROPDOWNMENU_MENU_VALUE == "ChecksGeneralMenu") then
				info = {};
				info.text = "Spells";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
				info = {};
				info.text = "Cleansing Totem";
				info.tooltipTitle = info.text;
				info.tooltipText = "Make everybody with Cleansing Totem print their current group in raid chat.";
				info.notCheckable = 1;
				info.func = function() local ChanID = GetChannelName("OBMCOMMAND");
					SendChatMessage("frame_cmd: get_cleansing", "CHANNEL", nil, ChanID) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
				info = {};
				info.text = "Interrupts";
				info.tooltipTitle = info.text;
				info.tooltipText = "Make everybody with an interrupt print their interrupts in raid chat.";
				info.notCheckable = 1;
				info.func = function() local ChanID = GetChannelName("OBMCOMMAND");
					SendChatMessage("frame_cmd: get_interrupts", "CHANNEL", nil, ChanID) end;
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