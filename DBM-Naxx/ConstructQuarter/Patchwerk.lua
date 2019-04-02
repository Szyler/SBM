local mod	= DBM:NewMod("Patchwerk", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(16028)

mod:RegisterCombat("yell", L.yell1, L.yell2)

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"PLAYER_ALIVE"
)

mod:AddBoolOption("WarningHateful", false, "announce")

local enrageTimer	= mod:NewBerserkTimer(360)
local timerAchieve	= mod:NewAchievementTimer(180, 1857, "TimerSpeedKill")

local function announceStrike(target, damage)
	SendChatMessage(L.HatefulStrike:format(target, damage), "RAID")
end

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	enrageTimer:Start(-delay)
	timerAchieve:Start(-delay)
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, args.amount or 0)
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, getglobal("ACTION_SPELL_MISSED_"..(args.missType)) or "")
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

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------