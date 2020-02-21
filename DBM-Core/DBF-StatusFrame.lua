--[[
******************
VARS
******************
]]--
local DBF_BATTLE_ELIXIR = {
	["Major Agility"] = 1,
	["Mighty Agility"] = 1,
	["Deadly Strikes"] = 1,
	["Lightning Speed"] = 1,
	["Armor Piercing"] = 1,
};

local DBF_GUARDIAN_ELIXIR = {
	["Mighty Thoughts"] = 1,
	["Mighty Defense"] = 1,
	["Crystal Force"] = 1,
};

local DBF_BOTH_ELIXIR = {
	["Distilled Wisdom"] = 1,
	["Supreme Power"] = 1,
	["Flask of the Titans"] = 1,
	["Chromatic Resistance"] = 1,
};

local DBF_ELIXIR_EXCEPTIONS = {
	["Flask of the North"] = "North",
};

--[[
******************
Core Frame
******************
]]--

function DBF_StatusFrame_Init()
	SlashCmdList["DeadlyBuffFrames_Statustoggle"] = DBF_SF_Toggle;
	SLASH_DeadlyBuffFrames_Statustoggle1 = "/dbf";
	
	DBFStatusFrameHeaderText:SetText("SzylerBossMods v"..DBM.Version);
	DBF_SF_SetBorder();
	
	DBF_CreateExtraMenuFrames(4,15);
	UIDropDownMenu_Initialize(DBFStatusFrameDropDownMenu, DBF_Settings_Menuofdoom, "MENU");
	
	if DBFSettings['FrameShown'] == 0 then
		DBFStatusFrame:Hide();
	elseif DBFSettings['FrameShown'] == 1 then
		DBFStatusFrame:Show();
	else
		DBFStatusFrame:Show();
	end
end

function DBF_SF_Toggle()
	if(DBFStatusFrame:IsShown()) then
		DBFStatusFrame:Hide();
		DBFSettings['FrameShown'] = 0;
	else
		DBFStatusFrame:Show();
		DBFSettings['FrameShown'] = 1;
	end
end

function DBF_SF_SetBorder()
	if(DBF_GetS("SFHideBorder")) then
		DBFStatusFrame:SetBackdrop( { 
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			tile = true,
			tileSize = 16,
			insets = { left = 4, right = 4, top = 3, bottom = 3 }
		});
	else
		DBFStatusFrame:SetBackdrop( { 
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16, 
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		});
	end
	DBFStatusFrame:SetBackdropColor(0.1,0.1,0.1,0.8);
end

local DBF_SF_TitleTime = false;
local DBF_SF_TITLE_UPDATE = 0;
function DBF_SF_UpdateTitle()
	--only run if active
	if(not DBF_GetS("DisplayTimeElapsed")) then return; end
	--dont update to fast
	if(DBF_SF_TITLE_UPDATE + 1 > GetTime()) then
		return;
	end
	DBF_SF_TITLE_UPDATE = GetTime();	

	if(DBF_ZONE) then
		if(DBF_IsCurrentBossActive()) then
			if(DBF_SF_TitleTime) then
				local tid = math.floor(GetTime()) - DBF_SF_TitleTime;
				local m = math.floor(tid/60);
				local s = math.fmod(tid,60);
				if(s<10) then
					s = "0"..s;
				end
				DBFStatusFrameHeaderText:SetText(m..":"..s.." - "..DBF_GetRealBossName(DBF_BOSS));
				if(DBF_GetS("AutoShowSF")) then
					DBFStatusFrame:Show();
					DBFSettings['FrameShown'] = 1;
				end
			else
				DBF_SF_TitleTime = math.floor(GetTime());
			end
		else
			--reset var
			DBF_SF_TitleTime = false;
		end
	end	
end

--[[
******************
Buff checking
******************
]]--

function DBF_PopulateWellFedTooltip()
	local well,dead = DBF_ScanForWellFed();
	local n,d,name,class;
	local text = "Well Fed.";
	local texttochat = "Well Fed: ";
	--add missing wellfed
	local count = 0;
	for n,d in pairs(well) do
		text = text.."\n"..dbf_c_grey..n..": ";
		for name,class in pairs(d) do
			if(count == 0) then
				text = text..DBF_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name;
			else
				text = text..DBF_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..", "..name;
			end
			count = count + 1;
		end
	end
	--add total or all have
	if(GetNumRaidMembers()>0) then
	if(count==0) then
		text = text..dbf_c_g;
		texttochat = "Everybody has "..text;
	else
		text = text.."\n"..dbf_c_grey.."Total: "..dbf_c_w..count;
	end
	--print out dead or out of range
	local first = true;
	for name,class in pairs(dead) do
		if(first) then
			text = text.."\n"..dbf_c_tt.."Dead or out of range:\n";
			first = false;
		end
		text = text..DBF_GetTextClassColor(class)..name.." ";
	end
	else
		text = text.."\n"..dbf_c_r.."Not in raid";
		texttochat = texttochat.."Not in a raid.";
	end
	--add extra info
	text = text.."\n"..dbf_c_grey.."(Shift+Click): Paste to chat.";
	this.texttochat = texttochat;
	GameTooltip:SetOwner(this);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function DBF_PopulateSpellTooltip(nameinput)
	local well,dead = DBF_ScanForbuff(nameinput);
	local n,d,name,class;
	local text = nameinput;
	local texttochat = nameinput..": ";
	--add missing wellfed
	local count = 0;
	for n,d in pairs(well) do
		text = text.."\n"..dbf_c_grey..n..": ";
		for name,class in pairs(d) do
			if(count == 0) then
				text = text..DBF_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name;
			else
				text = text..DBF_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..", "..name;
			end
			count = count + 1;
		end
	end
	--add total or all have
	if(GetNumRaidMembers()>0) then
	if(count==0) then
		text = text.."\n"..dbf_c_g.."All have";
		texttochat = "Everybody has "..nameinput..".";
	else
		text = text.."\n"..dbf_c_grey.."Total: "..dbf_c_w..count;
	end
	--print out dead or out of range
	local first = true;
	for name,class in pairs(dead) do
		if(first) then
			text = text.."\n"..dbf_c_tt.."Dead or out of range:\n";
			first = false;
		end
		text = text..DBF_GetTextClassColor(class)..name.." ";
	end
	else
		text = text.."\n"..dbf_c_r.."Not in raid";
		texttochat = texttochat.."Not in a raid.";
	end
	--add extra info
	text = text.."\n"..dbf_c_grey.."(Shift+Click): Paste to chat.";
	this.texttochat = texttochat;
	GameTooltip:SetOwner(this);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function DBF_PopulatePushbuttonTooltip()
	text = "\n"..dbf_c_grey.."(Shift+Click): to force people to paste their buffs to chat.";
	GameTooltip:SetOwner(this);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function DBF_ScanForWellFed()
	local missing_well = {};
	local oor_dead = {};
	local i;
	
	if(GetNumRaidMembers()>0) then
		--check raid
		for i=1,GetNumRaidMembers() do
			--dont check dead or out of range
			if((not UnitIsDeadOrGhost("raid"..i)) and UnitIsVisible("raid"..i)) then
				local w = DBF_CheckForBuff("Well Fed","raid"..i);
				if(not w) then
				local w = DBF_CheckForBuff("Blessed Sunfruit","raid"..i);
				if(not w) then
				local w = DBF_CheckForBuff("Blessed Sunfruit Juice","raid"..i);
				if(not w) then
				local w = DBF_CheckForBuff("Increased Stamina","raid"..i); -- Dirge's Kickin' Chimaerok Chops
				if(not w) then
					local _,_,group = GetRaidRosterInfo(i);
					local _,class = UnitClass("raid"..i);
					if(not missing_well[group]) then missing_well[group] = {}; end
					missing_well[group][UnitName("raid"..i)] = class;
				end
				end
				end
				end
			else
				local _,class = UnitClass("raid"..i);
				oor_dead[UnitName("raid"..i)] = class;
			end
		end
	end
	return missing_well,oor_dead;
end

function DBF_ScanForbuff(name)
	local missing_well = {};
	local oor_dead = {};
	local i;
	local addto; 
	if(string.find(name,"Mark of the Wild",1,true)) then
	addto = "Gift of the Wild";
	elseif(string.find(name,"Power Word: Fortitude",1,true)) then
	addto = "Prayer of Fortitude";
	elseif(string.find(name,"Arcane Intellect",1,true)) then
	addto = "Arcane Brilliance";
	elseif(string.find(name,"Blessing of Kings",1,true)) then
	addto = "Greater Blessing of Kings";
	elseif(string.find(name,"Blessing of Sanctuary",1,true)) then
	addto = "Greater Blessing of Sanctuary";
	elseif(string.find(name,"Blessing of Might",1,true)) then
	addto = "Greater Blessing of Might";
	elseif(string.find(name,"Blessing of Wisdom", 1, true)) then
	addto = "Greater Blessing of Wisdom";
	elseif(string.find(name,"Battle Shout",1,true)) then
	addto = "Battle Shout";
	end
	
	if(GetNumRaidMembers()>0) then
		--check raid
		for i=1,GetNumRaidMembers() do
			--dont check dead or out of range
			if((not UnitIsDeadOrGhost("raid"..i)) and UnitIsVisible("raid"..i)) then
				local w = DBF_CheckForBuff(name,"raid"..i);
				if(not w) then
				local w = DBF_CheckForBuff(addto,"raid"..i);
				if(not w) then
					local _,_,group = GetRaidRosterInfo(i);
					local _,class = UnitClass("raid"..i);
					if(not missing_well[group]) then missing_well[group] = {}; end
					missing_well[group][UnitName("raid"..i)] = class;
				end
				end
			else
				local _,class = UnitClass("raid"..i);
				oor_dead[UnitName("raid"..i)] = class;
			end
		end
	end
	return missing_well,oor_dead;
end

function DBF_PopulateFlaskTooltip()
	local text = "Flask Check";
	local texttochat = "Missing Flask: ";
	if(GetNumRaidMembers()>0) then
		local both,battle,guard,except = DBF_ScanForElixirs();
		local n,d,name,class;
		--text = text.."\n"..dbf_c_y.."(Under dev, need help with buff names)";
		local totalcount = 0;
		--go both
		local count = 0;
		local temptext = "\n"..dbf_c_w.."Missing both:";
		for n,d in pairs(both) do
			temptext = temptext.."\n"..dbf_c_grey..n..": ";
			for name,class in pairs(d) do
				if(count == 0) then
					temptext = temptext..DBF_GetTextClassColor(class)..name.." ";
					texttochat = texttochat..name;
				else
					temptext = temptext..DBF_GetTextClassColor(class)..name.." ";
					texttochat = texttochat..", "..name;
				end
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..dbf_c_grey.."Total: "..dbf_c_w..count;
		end
		--go battle
		local count = 0;
		local temptext = "\n"..dbf_c_w.."Missing Battle:";
		for n,d in pairs(battle) do
			temptext = temptext.."\n"..dbf_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..DBF_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name.." ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..dbf_c_grey.."Total: "..dbf_c_w..count;
		end
		--go guardian
		local count = 0;
		local temptext = "\n"..dbf_c_w.."Missing Guardian:";
		for n,d in pairs(guard) do
			temptext = temptext.."\n"..dbf_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..DBF_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name.." ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..dbf_c_grey.."Total: "..dbf_c_w..count;
		end
		--go exceptions
		local count = 0;
		local temptext = "\n"..dbf_c_w.."Exceptions:";
		for n,d in pairs(except) do
			temptext = temptext.."\n"..dbf_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..DBF_GetTextClassColor(class[1])..name..dbf_c_w.." ("..class[2]..") ";
				texttochat = texttochat..name.."("..class[2]..") ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..dbf_c_grey.."Total: "..dbf_c_w..count;
		end
		--sumarize
		if(totalcount==0) then
			text = text.."\n"..dbf_c_g.."All have";
			texttochat = "Everybody is flasked up.";
		end
	else
		text = text.."\n"..dbf_c_r.."Not in raid";
		texttochat = texttochat.."Not in a raid.";
	end
	--add extra info
	text = text.."\n"..dbf_c_grey.."(Shift+Click): Paste to chat.";
	this.texttochat = texttochat;
	GameTooltip:SetOwner(this);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function DBF_ScanForElixirs(msg,_,announce)
	local missing_both,missing_battle,missing_guardian,exceptions = {},{},{},{};
	local i;
	if(GetNumRaidMembers()>0) then
		for i=1,GetNumRaidMembers() do
			--dont check dead or out of range
			if((not UnitIsDeadOrGhost("raid"..i)) and UnitIsVisible("raid"..i)) then
				local b,g,except = DBF_ScanUnitForElixirs("raid"..i);
				local _,_,group = GetRaidRosterInfo(i);
				local _,class = UnitClass("raid"..i);
				if((not b) and (not g)) then
					if(not missing_both[group]) then missing_both[group] = {}; end
					missing_both[group][UnitName("raid"..i)] = class;
				elseif(not b) then
					if(not missing_battle[group]) then missing_battle[group] = {}; end
					missing_battle[group][UnitName("raid"..i)] = class;
				elseif(not g) then
					if(not missing_guardian[group]) then missing_guardian[group] = {}; end
					missing_guardian[group][UnitName("raid"..i)] = class;
				end
				if(except) then
					if(not exceptions[group]) then exceptions[group] = {}; end
					exceptions[group][UnitName("raid"..i)] = {class,except};
				end
			end
		end
	end
	return missing_both,missing_battle,missing_guardian,exceptions;
end

function DBF_ScanUnitForElixirs(unit)
	local i = 1;
	local text,name;
	local battle, guardian, exception = false,false,false;
	while(UnitBuff(unit,i) ~= nil) do
		name = UnitBuff(unit,i);
		if(name) then
			if(DBF_ELIXIR_EXCEPTIONS[name]) then
				exception = DBF_ELIXIR_EXCEPTIONS[name];
				battle = true; guardian = true;
				break;
			end
			if(DBF_BATTLE_ELIXIR[name]) then
				battle = true;
			end
			if(DBF_GUARDIAN_ELIXIR[name]) then
				guardian = true;
			end
			if(DBF_BOTH_ELIXIR[name]) then
				battle = true; guardian = true;
				break;
			end
			if(string.find(name,"Flask of",1,true)) then
				battle = true; guardian = true;
				break;
			end
		end
		text = DBF_GetBuffText(i,unit);
		if(text) then
			text = string.lower(text);
			if(string.find(text,"battle and guardian elixir",1,true)) then
				battle, guardian = true,true;
			elseif(string.find(text,"guardian and battle elixir",1,true)) then
				battle, guardian = true,true;
			elseif(string.find(text,"battle elixir",1,true)) then
				battle = true;
			elseif(string.find(text,"guardian elixir",1,true)) then
				guardian = true;
			end
		end
		text = "";	
		i = i + 1;
	end
	return battle, guardian, exception;
end

--[[
 ****************************************************************************
 Rebirth Tracking
 ****************************************************************************
 ]]--
 
 local rebirth = {
 	druid = {},
 	shaman = {},
 	warlock = {},
 };
 
 function DBF_Rebirth_TrackingTest()
 	--rebirth.druid["Vislike"] = {O = time()+60*20};
 	--rebirth.warlock["Vislike"] = {O = time()+60*30};
 	--rebirth.shaman["Vislike"] = {O = time()+10*60};
 	dbf_print_table(rebirth);
 end
 
 function DBF_Rebirth_Tracking() --getting from extrafeatures.lua
 	local combatEvent, sourceName, destName = arg2,arg4,arg7;
 	
 	--anyone gains a buff
 	if( (combatEvent == "SPELL_CAST_SUCCESS" or combatEvent == "SPELL_RESURRECT") and sourceName) then
 		local spellName = arg10;
 		--check for spell casts
 		if(spellName == "Rebirth") then
 			rebirth.druid[sourceName] = {O = time()+60*10};
 		elseif(spellName == "Soulstone") then
 			rebirth.warlock[sourceName] = {O = time()+60*15};
 		elseif(spellName == "Reincarnation") then
 			rebirth.shaman[sourceName] = {O = time()+60*60};
 		end
 	end
 end
 
 function DBF_PopulateRebirthTooltip(self)
 	local text = "RaidRess Tracking:";
 	local texttochat = "RaidRess: ";
 	local i;
 	--scan party or raid for druids shamans and locks
 	local druids,warlocks,shamans = {},{},{};
 	local c;
 	if(GetNumRaidMembers()>0) then
 		for i=1,GetNumRaidMembers() do
 			_,c = UnitClass("raid"..i);
 			if(c=="WARRIOR") then
 				druids[#druids+1] = UnitName("raid"..i);
 			elseif(c=="WARLOCK") then
 				warlocks[#warlocks+1] = UnitName("raid"..i);
 			elseif(c=="SHAMAN") then
 				shamans[#shamans+1] = UnitName("raid"..i);
 			end
 		end
 	elseif(GetNumPartyMembers()>0) then
 		for i=1,GetNumPartyMembers() do
 			_,c = UnitClass("party"..i);
 			if(c=="WARRIOR") then
 				druids[#druids+1] = UnitName("party"..i);
 			elseif(c=="WARLOCK") then
 				warlocks[#warlocks+1] = UnitName("party"..i);
 			elseif(c=="SHAMAN") then
 				shamans[#shamans+1] = UnitName("party"..i);
 			end
 		end
 	end
 	--Rebirth
 	text = text.."\n"..dbf_c_w.."Rebirth:";
 	if(#druids > 0) then
 		table.sort(druids);
 		texttochat = texttochat.."Rebirth: ";
 		local tid,tidtext;
 		for i=1,#druids do
 			--get data
 			if(rebirth.druid[druids[i]]) then
 				--found rebirth data
 				tid = rebirth.druid[druids[i]].O - time();
 				if(tid > 0) then
 					tidtext = string.format("%d:%.2d",tid/60,math.fmod(tid,60));
 					texttochat = texttochat..druids[i].." ("..tidtext..") ";
 					tidtext = dbf_c_w..tidtext;
 				else
 					texttochat = texttochat..druids[i].." (Ready) ";
 					tidtext = dbf_c_g.."Ready";
 				end
 			else
 				--nodata found
 				texttochat = texttochat..druids[i].." (Ready*) ";
 				tidtext = dbf_c_g.."Ready"..dbf_c_w.."*";
 			end
 			text = text.."\n"..DBF_GetTextClassColor("DRUID")..druids[i].." "..dbf_c_grey.."("..tidtext..dbf_c_grey..")";
 		end
 	else
 		text = text.."\n"..dbf_c_grey.."No Druids in Group";
 	end
 	--Soulstone
 	text = text.."\n"..dbf_c_w.."Soulstone:";
 	if(#warlocks > 0) then
 		table.sort(warlocks);
 		texttochat = texttochat.."Soulstone: ";
 		local tid,tidtext;
 		for i=1,#warlocks do
 			--get data
 			if(rebirth.warlock[warlocks[i]]) then
 				--found rebirth data
 				tid = rebirth.warlock[warlocks[i]].O - time();
 				if(tid > 0) then
 					tidtext = string.format("%d:%.2d",tid/60,math.fmod(tid,60));
 					texttochat = texttochat..warlocks[i].." ("..tidtext..") ";
 					tidtext = dbf_c_w..tidtext;
 				else
 					texttochat = texttochat..warlocks[i].." (Ready) ";
 					tidtext = dbf_c_g.."Ready";
 				end
 			else
 				texttochat = texttochat..warlocks[i].." (Ready*) ";
 				tidtext = dbf_c_g.."Ready"..dbf_c_w.."*";
 			end
 
 			text = text.."\n"..DBF_GetTextClassColor("WARLOCK")..warlocks[i].." "..dbf_c_grey.."("..tidtext..dbf_c_grey..")";
 		end
 	else
 		text = text.."\n"..dbf_c_grey.."No Warlocks in Group";
 	end
 	--Reincarnation
 --	text = text.."\n"..dbf_c_w.."Reincarnation:";
 --	if(#shamans > 0) then
 --		table.sort(shamans);
 --		local tid,tidtext;
 --		for i=1,#shamans do
 --			--get data
 --			if(rebirth.shaman[shamans[i]]) then
 --				--found rebirth data
 --				tid = rebirth.shaman[shamans[i]].O - time();
 --			else
 --				tid = 0;
 --			end
 --			if(tid > 0) then
 --				tidtext = dbf_c_w..string.format("%d:%.2d",tid/60,math.fmod(tid,60));
 --				tidtext = tidtext..dbf_c_grey.." W1T ";
 --				if(tid - 10*60 > 0) then
 --					tidtext = tidtext..dbf_c_w..string.format("%d:%.2d",(tid-10*60)/60,math.fmod((tid-10*60),60));
 --					tidtext = tidtext..dbf_c_grey.." W2T ";
 --					if(tid - 20*60 > 0) then
 --						tidtext = tidtext..dbf_c_w..string.format("%d:%.2d",(tid-20*60)/60,math.fmod((tid-20*60),60));
 --					else
 --						tidtext = tidtext..dbf_c_g.."Ready";
 --					end
 --				else
 --					tidtext = tidtext..dbf_c_g.."Ready";
 --				end
 --			else
 --				tidtext = dbf_c_g.."Ready";
 --			end
 --			text = text.."\n"..DBF_GetTextClassColor("SHAMAN")..shamans[i].." "..dbf_c_grey.."("..tidtext..dbf_c_grey..")";
 --		end
 --	else
 --		text = text.."\n"..dbf_c_grey.."No Shamans in Group";
 --	end
 	
 	text = text.."\n"..dbf_c_grey.."(Shift+Click): Paste to chat.";
 	text = text.."\n"..dbf_c_w.."*"..dbf_c_grey.." = Not seen the spell casted, so assuming ready.";
 	self.texttochat = texttochat;
 	GameTooltip:SetOwner(self);
 	GameTooltip:SetText(text);
 	GameTooltip:Show();
 end
 
 function DBF_PopulateRebirthTooltipOnUpdate(self)
 	if(GameTooltip:GetOwner()==self) then
 		DBF_PopulateRebirthTooltip(self);
 	end
 end

function DBFStatusFrame_OnLoad()
	
end