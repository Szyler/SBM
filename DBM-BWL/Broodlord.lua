local mod	= DBM:NewMod("Broodlord", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 168 $"):sub(12, -3))
mod:SetCreatureID(12017)
mod:RegisterCombat("yell", L.YellPull2)--Will fail if msg find isn't used, msg match won't find yell since a line break is omitted
mod:RegisterCombat("yell", L.YellPull3)--Will fail if msg find isn't used, msg match won't find yell since a line break is omitted

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local prewarnEgg	= mod:NewAnnounce("Egg Hatching Soon", 3)
local warnEgg		= mod:NewAnnounce("Egg Hatching Now", 2)
local timerEgg		= mod:NewTimer(35, "Egg Hatches")

local warnBlastWave	= mod:NewSpellAnnounce(23331)
local warnKnockAway	= mod:NewSpellAnnounce(18670)
local warnMortal	= mod:NewTargetAnnounce(24573)

local timerMortal	= mod:NewTargetTimer(5, 24573)

local soundEgg		= mod:NewSound2(0, "Play Sound on Egg Spawn")

function mod:preEgg()
	prewarnEgg:Show()
end

function mod:alertEgg()
	warnEgg:Show()
	soundEgg:Play()
end

function mod:broodEgg()
	timer1 = 35
	timerEgg:Show(timer1)
	self:ScheduleMethod(timer1-5, "preEgg")
	self:ScheduleMethod(timer1, "alertEgg")
	self:ScheduleMethod(timer1, "broodEgg")
end

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	self:ScheduleMethod(0, "broodEgg")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(23331) then
		warnBlastWave:Show()
	elseif args:IsSpellID(18670) and self:IsInCombat() then
		warnKnockAway:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24573) and self:IsInCombat() then
		warnMortal:Show(args.destName)
		timerMortal:Start(args.destName)
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------