local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2943 $"):sub(12, -3))
mod:SetCreatureID(15956)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED",
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED"
)

local warningLocustSoon		= mod:NewSoonAnnounce(28785, 2)
local warningLocustNow		= mod:NewSpellAnnounce(28785, 3)
local warningLocustFaded	= mod:NewAnnounce("WarningLocustFaded", 1, 28785)
local specialWarningLocust	= mod:NewSpecialWarning("SpecialLocust")
local timerLocustIn			= mod:NewCDTimer(80, 28785)
local timerLocustFade 		= mod:NewBuffActiveTimer(26, 28785)

local berserkTimer				= mod:NewBerserkTimer(600)
local specWarnDarkGaze	= mod:NewSpecialWarning("Dark Gaze", nil, "Special warning for Dark Gaze on you")

mod:AddBoolOption("ArachnophobiaTimer", true, "timer")


function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "getBestKill")
	if mod:IsDifficulty("heroic25") then
		timerLocustIn:Start(90 - delay)
		warningLocustSoon:Schedule(80 - delay)
	else
		timerLocustIn:Start(91 - delay)
		warningLocustSoon:Schedule(76 - delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28785, 54021) then  -- Locust Swarm
		warningLocustNow:Show()
		specialWarningLocust:Show()
		timerLocustIn:Stop()
		if mod:IsDifficulty("heroic25") then
			timerLocustFade:Start(26)
		else
			timerLocustFade:Start(19)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(28785, 54021)
	and args.auraType == "BUFF" then
		warningLocustFaded:Show()
		timerLocustIn:Start()
		warningLocustSoon:Schedule(62)
	end
end

function mod:UNIT_DIED(args)
	if self.Options.ArachnophobiaTimer and not DBM.Bars:GetBar(L.ArachnophobiaTimer) then
		local guid = tonumber(args.destGUID:sub(9, 12), 16)
		if guid == 15956 then		-- Anub'Rekhan
			DBM.Bars:CreateBar(1200, L.ArachnophobiaTimer)
		end
	end
end

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1003011) then 
		if args:IsPlayer() then
			specWarnDarkGaze:Show();
			SendChatMessage(L.YellDarkGaze, "YELL")
		end
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------