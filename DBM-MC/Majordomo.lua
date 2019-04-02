local mod	= DBM:NewMod("Majordomo", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(12018, 11663, 11664)
mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Kill)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
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



local warnMagicReflect	= mod:NewSpellAnnounce(20619)
local warnDamageShield	= mod:NewSpellAnnounce(21075)
local warnTeleport		= mod:NewTargetAnnounce(20534)

local specWarnMagicReflect		= mod:NewSpecialWarningSpell(20619, not mod:IsMelee())

local timerMagicReflect	= mod:NewBuffActiveTimer(10, 20619)
local timerDamageShield	= mod:NewBuffActiveTimer(10, 21075)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(20619) then
		warnMagicReflect:Show()
		specWarnMagicReflect:Show()
		timerMagicReflect:Start()
	elseif args:IsSpellID(21075) then
		warnDamageShield:Show()
		timerDamageShield:Start()
	elseif args:IsSpellID(20534) then
		warnTeleport:Show(args.destName)
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------