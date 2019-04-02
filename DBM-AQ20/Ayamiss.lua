local mod	= DBM:NewMod("Ayamiss", "DBM-AQ20", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 171 $"):sub(12, -3))
mod:SetCreatureID(15369)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

local warnPhase2	= mod:NewPhaseAnnounce(2)
local warnParalyze	= mod:NewTargetAnnounce(25725, 3)
local timerParalyze	= mod:NewTargetTimer(30, 25725)

local warned_P2 = false

function mod:OnCombatStart(delay)
	warned_P2 = false
	self:ScheduleMethod(0, "getBestKill")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(25725) then
		warnParalyze:Show(args.destName)
		timerParalyze:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(25725) then
		timerParalyze:Cancel()
	end
end

function mod:UNIT_HEALTH(uId)
	if not warned_P2 and self:GetUnitCreatureId(uId) == 15369 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.70 then
		warned_P2 = true
		warnPhase2:Show()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------