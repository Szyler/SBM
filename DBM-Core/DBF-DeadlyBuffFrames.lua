DBF_LOAD_LAG_TIME = 10; --used for some delay print operations so the text wont be spammed away by other chat messeages during loading screen
DBF_HAS_INIT = false; -- this gets true then dbf is fully loaded
DBF_MSG_FROM = nil; -- will contain name of last received addon message
DBF_GLOBAL_ERROR_MESS = nil; -- used to catch wow error messages, for remote Logout
DBF_ZONE = false;

function DeadlyBuffFrames_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	this:RegisterEvent("RAID_ROSTER_UPDATE");
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("UI_ERROR_MESSAGE");
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED"); 
	this:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
end

function DeadlyBuffFrames_PrintOfficerInfo()
	local text = "\n"..
	dbf_c_t.."Available slash commands:\n"..
	"\n"..
	"|cFF00FF00/tbm unlock: |cFFFFFFFFShows a movable status bar timer (alias: move). \n"..
	"|cFF00FF00/tbm pull <x>: |cFFFFFFFFStarts a <x> second TBM pull timer. \n"..
	"|cFF00FF00/tbm timer <x> <text>: |cFFFFFFFFStarts a <x> second TBM Timer with the name <text>. \n"..
	"|cFF00FF00/tbm broadcast timer <x> <text>: |cFFFFFFFFBroadcasts a <x> second TBM Timer with the name <text> to the raid. \n"..
	"|cFF00FF00/tbm break <min>: |cFFFFFFFFStarts a break timer for <min> minutes. Gives all raid members with TBM a break timer. \n"..
	"|cFF00FF00/tbm aaa: |cFFFFFFFFGrants all raid members the assistant role. \n"..
	"|cFF00FF00/tbm cr: |cFFFFFFFFConvers the party group to a raid group. \n"..
	"|cFF00FF00/tbm gl: |cFFFFFFFFSwap to Group Loot. \n"..
	"|cFF00FF00/tbm ml: |cFFFFFFFFSwap to Master Looter. \n"..
	"|cFF00FF00/tbm ffa: |cFFFFFFFFSwap to Free For All. \n"..
	"|cFF00FF00/tbm ri: |cFFFFFFFFReset instance. \n"..
	"|cFF00FF00/tbm 5n: |cFFFFFFFFSwaps dungeon difficulty to Normal5. \n"..
	"|cFF00FF00/tbm 5h: |cFFFFFFFFSwaps dungeon difficulty to Heroic5. \n"..
	"|cFF00FF00/tbm 10n: |cFFFFFFFFSwaps raid difficulty to Normal10. \n"..
	"|cFF00FF00/tbm 10h: |cFFFFFFFFSwaps raid difficulty to Heroic10. \n"..
	"|cFF00FF00/tbm 25n: |cFFFFFFFFSwaps raid difficulty to Normal25. \n"..
	"|cFF00FF00/tbm 25h: |cFFFFFFFFSwaps raid difficulty to Heroic25. \n"..
	"|cFF00FF00/tbm disband: |cFFFFFFFFDisband party or raid group. \n"..
	"|cFF00FF00/tbm m <1-8>: |cFFFFFFFFAdd a raid marker to your current target. \n"..
	"|cFF00FF00/range: |cFFFFFFFFToggles the range frame. \n"..
	"|cFF00FF00/dbf: |cFFFFFFFFToggles the DeadlyBuffFrames UI. \n"..
	"|cFF00FF00/tbm: |cFFFFFFFFToggles the TBM Options GUI. \n"..
	"|cFF00FF00/tbm help: |cFFFFFFFFShows slash command descriptions \n"..
	"";
	ShowUIPanel(DeadlyBuffFrames_TextBoxTT);
	if ( not DeadlyBuffFrames_TextBoxTT:IsVisible() ) then
		DeadlyBuffFrames_TextBoxTT:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end
	DeadlyBuffFrames_TextBoxTT:SetText("TBM commands");
	DeadlyBuffFrames_TextBoxTT:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	
	DeadlyBuffFrames_TextBoxTT:SetWidth(550);
	DeadlyBuffFrames_TextBoxTT:SetHeight(350);
end

function DeadlyBuffFrames_OnEvent(event)
	if (event == "VARIABLES_LOADED") then 
		DeadlyBuffFrames_Init();
		DBF_StatusFrame_Init();
		--support for mod mods feature
		DBF_AutoRunHookFunctions(); --found in hooks.lua
		return;
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		if(not DBF_HAS_INIT) then
			DBF_AutoRunEnterWorldHookFunctions(); --found in hooks.lua
			DBF_HAS_INIT = true;
		end

		return;
	end
	
	--if not fully inited then just return
	if(not DBF_HAS_INIT) then return; end
	
	if (event == "RAID_ROSTER_UPDATE") then 
		DBF_DetectRaid();
		return;
	end
	
	-- turn on or off the addon depending on zone

	if(not DBF_ZONE) then return; end
end

function DeadlyBuffFrames_OnUpdate()
	-- don't update too fast
	if(this.lastupdate and this.lastupdate + 0.05 > GetTime()) then
		return;
	end
	this.lastupdate = GetTime();
	
	DBF_Delay_OnUpdate();
	DBF_PositionSync_OnUpdate();
end

function DeadlyBuffFrames_Init()	
	DBF_Settings_SetDefaults();
	DBF_Delay(DBF_LOAD_LAG_TIME,DBF_CPUWarning); --cpu profileing warning found in helpfunctions.lua
	DBF_Delay(DBF_LOAD_LAG_TIME,DBF_NoneEnglish); -- found in helpfunctions.lua
end

function DBF_GetBuffs()
	for j = 1, GetNumRaidMembers() do
		myName, _, groupId = GetRaidRosterInfo(j);
	end
	
	local i = 1;
	while true do
	local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
	if not spellName then
		break;
	end
	
	-- use spellName and spellRank here
	if((spellName == "Thorns" and spellRank == "Rank 6") or
	(spellName == "Gift of the Wild" and spellRank == "Rank 2") or
	(spellName == "Arcane Brilliance" and spellRank == "Rank 1") or
	(spellName == "Dampen Magic" and spellRank == "Rank 5") or
	(spellName == "Amplify Magic" and spellRank == "Rank 4") or
	(spellName == "Greater Blessing of Wisdom" and spellRank == "Rank 2") or
	(spellName == "Concentration Aura") or
	(spellName == "Devotion Aura" and spellRank == "Rank 7") or
	(spellName == "Greater Blessing of Kings") or
	(spellName == "Shadow Resistance Aura" and spellRank == "Rank 3") or
	(spellName == "Frost Resistance Aura" and spellRank == "Rank 3") or
	(spellName == "Fire Resistance Aura" and spellRank == "Rank 3") or
	(spellName == "Greater Blessing of Sanctuary") or
	(spellName == "Blessing of Might" and spellRank == "Rank 7") or
	(spellName == "Retribution Aura" and spellRank == "Rank 5") or
	(spellName == "Prayer of Fortitude" and spellRank == "Rank 2") or
	(spellName == "Prayer of Spirit") or
	(spellName == "Prayer of Shadow Protection") or
	(spellName == "Totem of Wrath" and spellRank == "Rank 2") or
	(spellName == "Stoneskin Totem" and spellRank == "Rank 6") or
	(spellName == "Strength of Earth Totem" and spellRank == "Rank 5") or
	(spellName == "Frost Resistance Totem" and spellRank == "Rank 3") or
	(spellName == "Fire Resistance Totem" and spellRank == "Rank 3") or
	(spellName == "Flametongue Totem" and spellRank == "Rank 4") or
	(spellName == "Nature Resistance Totem" and spellRank == "Rank 3") or
	(spellName == "Windfury Totem") or
	(spellName == "Mana Tide Totem") or
	(spellName == "Frost Resistance Totem" and spellRank == "Rank 3") or
	(spellName == "Healing Stream Totem" and spellRank == "Rank 5") or
	(spellName == "Mana Spring Totem" and spellRank == "Rank 4") or
	(spellName == "Battle Shout" and spellRank == "Rank 7")) then
		if(myName == GetUnitName("player")) then
			SendChatMessage("Group "..groupId..": "..spellName.." "..spellRank, "RAID", nil, nil);
		end
	end
	
	i = i + 1;
	end
end

function DBF_GetDebuffs()
	for j = 1, GetNumRaidMembers() do
		myName, _, groupId = GetRaidRosterInfo(j);
	end
	
	local i = 1;
	while true do
	local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
	if not spellName then
		break;
	end
	
	-- use spellName and spellRank here
	if((spellName == "Demoralizing Roar" and spellRank == "Rank 5") or
	(spellName == "Demoralizing Shout" and spellRank == "Rank 5") or
	(spellName == "Curse of Weakness" and spellRank == "Rank 6") or
	(spellName == "Curse of the Elements" and spellRank == "Rank 3") or
	(spellName == "Sunder Armor") or
	(spellName == "Expose Armor") or
	(spellName == "Faerie Fire")) then
		if(myName == GetUnitName("player")) then
			SendChatMessage("Group "..groupId..": "..spellName.." "..spellRank, "RAID", nil, nil);
		end
	end
	
	i = i + 1;
	end
end
--[[
	********************************************************************
	********************************************************************
	Delay Exec Functions
	********************************************************************
	********************************************************************
]]--

local DBF_Delay_data = {};
local DBF_Delay_dataname = {};

function DBF_Delay(when, func, ...)
	if (not func) then
		return;
	end

	local data = {};
	data.time = when + GetTime();
	data.func = func;
	data.args = {...};

	-- task list is a heap, add new
	local i = #DBF_Delay_data+1
	while(i > 1) do
		if(data.time < DBF_Delay_data[i-1].time) then
			i = i - 1;
		else
			break
		end
	end
	tinsert(DBF_Delay_data, i, data)
end

function DBF_DelayRemove(name)
	if(name and DBF_Delay_dataname[name]) then
		DBF_Delay_dataname[name] = nil;
	end
end

function DBF_DelayByName(name, when, func, ...)
	if (not name) then 
		return;
	end
	if (not func) then
		return;
	end
	DBF_Delay_dataname[name] = {};
	DBF_Delay_dataname[name].time = when+GetTime();
	DBF_Delay_dataname[name].func = func;
	DBF_Delay_dataname[name].args = {...};
end

function DBF_Delay_run(func,args)
	if(func) then
		if(args) then
			func(unpack(args));
		else
			func();
		end
	end
end
-- /script DBF_DelayByName("test",20,function() dbf_print("hej"); end);
-- /script dbf_print_table(DBF_Delay_dataname)
function DBF_Delay_OnUpdate()
	-- Execute scheduled tasks that are ready, pulling them off the front of the list queue.
	local now = GetTime();
	local i;
	local task;
	while(#DBF_Delay_data > 0) do
		if (not DBF_Delay_data[1].time) then
			tremove(DBF_Delay_data, 1);
		elseif(DBF_Delay_data[1].time <= now) then
			task = tremove(DBF_Delay_data, 1);
			DBF_Delay_run(task.func, task.args);
		else
			break;
		end
	end
	-- Execute named scheduled tasks that are ready.
	local n,d;
	local exectable = {};
	for n,d in pairs(DBF_Delay_dataname) do
		if(not d.time) then
			DBF_Delay_dataname[n] = nil;
		elseif(d.time <= now) then
			exectable[#exectable+1] = {func = d.func,args = d.args};
			DBF_Delay_dataname[n] = nil;
		end
	end
	local i;
	for i=1,#exectable do
		DBF_Delay_run(exectable[i].func, exectable[i].args);
	end
end

function DBF_DetectRaid()
	--Check if we have joined a raid group and if so request version
	if(GetNumRaidMembers()>0 and DBF_IN_RAID == false) then
		DBF_IN_RAID = true;
	end
	if(GetNumRaidMembers()==0 and DBF_IN_RAID == true) then
		DBF_IN_RAID = false;
		--turn on autogreed if set to on
	end
end

function dbf_sendchat(msg)
	if(GetNumRaidMembers()>0) then
		SendChatMessage("<TBM> "..msg,"RAID");
	elseif(GetNumPartyMembers()>0) then
		SendChatMessage("<TBM> "..msg,"PARTY");
	else
		SendChatMessage("<TBM> "..msg,"SAY");
	end
end