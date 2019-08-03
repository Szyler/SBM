local mod	= DBM:NewMod("Horsemen", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16063, 16064, 16065, 30549)

mod:RegisterCombat("combat", 16063, 16064, 16065, 30549)

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)

local warnMarkSoon			= mod:NewAnnounce("WarningMarkSoon", 1, 28835, false)
local warnMarkNow			= mod:NewAnnounce("WarningMarkNow", 2, 28835)

local specWarnMarkOnPlayer	= mod:NewSpecialWarning("SpecialWarningMarkOnPlayer", nil, false, true)

mod:AddBoolOption("HealthFrame", true)

mod:SetBossHealthInfo(
	16064, L.Korthazz,
	30549, L.Rivendare,
	16065, L.Blaumeux,
	16063, L.Zeliek
)

local markCounter = 0

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	markCounter = 0
end

local markSpam = 0
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and (GetTime() - markSpam) > 5 then
		markSpam = GetTime()
		markCounter = markCounter + 1
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and args:IsPlayer() then
		if args.amount >= 4 then
			specWarnMarkOnPlayer:Show(args.spellName, args.amount)
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

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------