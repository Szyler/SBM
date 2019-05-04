--[[
	********************************************************************
	********************************************************************
	Interact with other addons functions
	********************************************************************
	********************************************************************
]]--


--[[
	/////////////////////////////
	Minimap Button Hider
	/////////////////////////////
]]--

function DBF_HideMinimapButtons(showagain)
	-- Main Buttons
	if(DBF_GetS("WorldMapButton")) then
		MiniMapWorldMapButton:Hide();
	else
		if(showagain=="set") then
			MiniMapWorldMapButton:Show();
		end
	end
	if(DBF_GetS("TrackingButton")) then
		MiniMapTracking:Hide();
	else
		if(showagain=="set") then
			MiniMapTracking:Show();
		end
	end
	if(DBF_GetS("CalendarButton")) then
		GameTimeFrame:Hide();
	else
		if(showagain=="set") then
			GameTimeFrame:Show();
		end
	end
	if(DBF_GetS("ZoomInButton")) then
		MinimapZoomIn:Hide();
	else
		if(showagain=="set") then
			MinimapZoomIn:Show();
		end
	end
	if(DBF_GetS("ZoomOutButton")) then
		MinimapZoomOut:Hide();
	else
		if(showagain=="set") then
			MinimapZoomOut:Show();
		end
	end
	
	-- Decoratives
	if(DBF_GetS("MinimapTopBorder")) then
		MinimapBorderTop:Hide();
	else
		if(showagain=="set2") then
			MinimapBorderTop:Show();
		end
	end
	if(DBF_GetS("MinimapBorder")) then
		MinimapBackdrop:Hide();
	else
		if(showagain=="set2") then
			MinimapBackdrop:Show();
		end
	end
	--[[if(DBF_GetS("MinimapToggleButton")) then
		MinimapToggleButton:Hide();
	else
		if(showagain=="set2") then
			MinimapToggleButton:Show();
		end
	end]]--
	if(DBF_GetS("MinimapZoneText")) then
		MinimapZoneTextButton:Hide();
	else
		if(showagain=="set2") then
			MinimapZoneTextButton:Show();
		end
	end
	
	-- Never Show
	if(DBF_GetS("MeetingStoneButton")) then
		MiniMapLFGFrame:Hide();
		MiniMapLFGFrame:SetScript("OnShow",function() this:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapLFGFrame:SetScript("OnShow",nil);
		end
	end
	if(DBF_GetS("InstanceDiffButton")) then
		MiniMapInstanceDifficulty:Hide();
		MiniMapInstanceDifficulty:SetScript("OnShow",function() this:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapInstanceDifficulty:SetScript("OnShow",nil);
		end
	end
	if(DBF_GetS("MailButton")) then
		MiniMapMailFrame:Hide();
		MiniMapMailFrame:SetScript("OnShow",function() this:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapMailFrame:SetScript("OnShow",nil);
		end
	end
	if(DBF_GetS("BattlefieldButton")) then
		MiniMapBattlefieldFrame:Hide();
		MiniMapBattlefieldFrame:SetScript("OnShow",function() this:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapBattlefieldFrame:SetScript("OnShow",nil);
		end
	end

end

--[[
	/////////////////////////////
	Remove Some Error Messages
	/////////////////////////////
	
	-- Another action is in progress
]]--

function DBF_HookErrorMessageDisabler()
	if(DBF_GetS("ErrorMessageDisabler")) then
		if(not DBF_oldUIErrorsFrame_AddMessage) then
			DBF_oldUIErrorsFrame_AddMessage = UIErrorsFrame.AddMessage;
			UIErrorsFrame.AddMessage = DBF_UIErrorsFrame_AddMessage;
		end
	end
end

function DBF_UIErrorsFrame_AddMessage(self,...)
	local arg1 = ...;
	if(DBF_GetS("ErrorMessAbilityNotReady") and arg1 == ERR_ABILITY_COOLDOWN) then
		return;
	end
	
	if(DBF_GetS("ErrorMessAnotherAction") and arg1 == SPELL_FAILED_SPELL_IN_PROGRESS) then
		return;
	end
	
	if(DBF_GetS("ErrorMessItemNotReady") and arg1 == ERR_ITEM_COOLDOWN) then
		return;
	end
	
	if(DBF_GetS("ErrorMessNotEnergy") and arg1 == ERR_OUT_OF_ENERGY) then
		return;
	end
	
	if(DBF_GetS("ErrorMessNotRage") and arg1 == ERR_OUT_OF_RAGE) then
		return;
	end
	
	if(DBF_GetS("ErrorMessNotMana") and arg1 == ERR_OUT_OF_MANA) then
		return;
	end
	
	if(DBF_GetS("ErrorMessSpellNotReady") and arg1 == ERR_SPELL_COOLDOWN) then
		return;
	end
	
	if(DBF_GetS("ErrorMessNoAttackTarget") and arg1 == ERR_NO_ATTACK_TARGET) then
		return;
	end
	
	if(DBF_GetS("ErrorMessWhileMoving") and arg1 == SPELL_FAILED_MOVING ) then
		return;
	end
	
	if(DBF_GetS("ErrorMessNoTarget") and arg1 == ERR_GENERIC_NO_TARGET  ) then
		return;
	end
	
	if(DBF_GetS("ErrorMustEquipToUse") and arg1 == ERR_MUST_EQUIP_ITEM  ) then
		return;
	end
	
	if(DBF_GetS("ErrorTooFarAway")) then
		if(arg1 == TOO_FAR_TO_LOOT or arg1 == SPELL_FAILED_CUSTOM_ERROR_17 or arg1 == ERR_VENDOR_TOO_FAR or arg1 == ERR_USE_TOO_FAR or arg1 == ERR_TOO_FAR_TO_ATTACK or arg1 == ERR_NO_BANK_HERE or arg1 == ERR_LOOT_TOO_FAR or arg1 == ERR_BADATTACKPOS) then
			return;
		end
	end
	
	if(DBF_GetS("ErrorOutOfRange")) then
		if(arg1 == ERR_OUT_OF_RANGE or arg1 == ERR_SPELL_OUT_OF_RANGE or arg1 == SPELL_FAILED_OUT_OF_RANGE) then
			return;
		end
	end
	
	
	return DBF_oldUIErrorsFrame_AddMessage(self,...);
end

--[[
	/////////////////////////////
	AutoSet MaxDistance Camera
	/////////////////////////////
]]--

function DBF_AutoSetCameraDistance()
	if(DBF_GetS("AutoSetCameraDistance")) then
		SetCVar("cameraDistanceMaxFactor","5");
	end
end

--[[
	/////////////////////////////
	AltInvite
	/////////////////////////////
]]--

function DBF_HookAltInvite()
	if(DBF_GetS("AltInvite")) then
		if(not DeadlyBuffFrames_oldSetItemRef) then
			DeadlyBuffFrames_oldSetItemRef = SetItemRef;
			SetItemRef = DeadlyBuffFrames_SetItemRef;
		end
	end
end


function DeadlyBuffFrames_SetItemRef(link, text, button)
	if ( strsub(link, 1, 6) == "player" ) then
		local namelink = strsub(link, 8);
		local name, lineid = strsplit(":", namelink);
		if ( name and (strlen(name) > 0) ) then
			local begin = string.find(name, "%s[^%s]+$");
			if ( begin ) then
				name = strsub(name, begin+1);
			end
			if ( IsAltKeyDown() ) then
				InviteUnit(name);
				return false;
			end
		end
	end
	
	DeadlyBuffFrames_oldSetItemRef(link, text, button);
end


--[[
	/////////////////////////////
	Remove AutoDecline Then you close ress window
	/////////////////////////////
]]--

function DBF_RemoveAutoDeclineRess()
	if(DBF_GetS("RemoveDeclineRess")) then
		StaticPopupDialogs["RESURRECT"].OnCancel = function()
			if ( UnitIsDead("player") ) then
				StaticPopup_Show("DEATH");
			end
			dbf_printc("Ress has not been declined /ress to ress");
		end
		StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnCancel = function()
			if ( UnitIsDead("player") ) then
				StaticPopup_Show("DEATH");
			end
			dbf_printc("Ress has not been declined /ress to ress");
		end
		StaticPopupDialogs["RESURRECT_NO_TIMER"].OnCancel = function()
			if ( UnitIsDead("player") ) then
				StaticPopup_Show("DEATH");
			end
			dbf_printc("Ress has not been declined /ress to ress");
		end
	end
end

--[[
	/////////////////////////////
	World State Frame Strata fix
	/////////////////////////////
]]--

function DBF_WorldStateFrameFix()
	if(DBF_GetS("BackgroundWorldState")) then
		WorldStateAlwaysUpFrame:SetFrameStrata("BACKGROUND")
	end
end

--[[
	/////////////////////////////
	Disable Blizzard RaidWarning
	/////////////////////////////
]]--

function DBF_DisableBlizzardRaidWarnings()
	if(DBF_GetS("DisableBlizzardWarnText")) then
		RaidBossEmoteFrame:UnregisterAllEvents();
		--[[if(not DBFold_RaidBossEmoteFrame_OnEvent) then
			DBFold_RaidBossEmoteFrame_OnEvent = RaidBossEmoteFrame_OnEvent;
			function RaidBossEmoteFrame_OnEvent(self, event, ...)
				if ( strsub(event,10,18) == "RAID_BOSS" ) then
					return;
				end
				return DBFold_RaidBossEmoteFrame_OnEvent(self, event, ...);
			end
		end]]
	end
end

--[[
	/////////////////////////////
	Kill Blizzard BG Popup
	/////////////////////////////
]]--

function DBF_KillBlizzardBGJoin()
	if(DBF_GetS("KillBlizzardJoinPopup")) then
		StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"] = nil;
	end
end



--[[
	/////////////////////////////
	Autorun all hooks att startup
	/////////////////////////////
]]--
--run during varibles loaded
function DBF_AutoRunHookFunctions()
	DBF_HookAltInvite();
	DBF_RemoveAutoDeclineRess();
	DBF_WorldStateFrameFix();
	DBF_DisableBlizzardRaidWarnings();
	DBF_KillBlizzardBGJoin();
	DBF_HideMinimapButtons();
	DBF_HookErrorMessageDisabler();

end
--run during EnterWorld
function DBF_AutoRunEnterWorldHookFunctions()
	DBF_AutoSetCameraDistance();
end