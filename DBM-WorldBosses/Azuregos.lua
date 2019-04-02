local mod	= DBM:NewMod("Azuregos", "DBM-WorldBosses")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4181 $"):sub(12, -3))
mod:SetCreatureID(6109)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)

local specWarnManastorm		= mod:NewSpecialWarningMove(21097, true, "Special warning when standing in Blizzard", true)
local warnMagicReflection		= mod:NewSpellAnnounce(20223, 3)
local soundMagicReflection		= mod:NewSound2(20223)


function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end


function mod:OnCombatStart()
	self:ScheduleMethod(0, "getBestKill")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(21097) then 
		if args:IsPlayer() then
			specWarnManastorm:Show();
		end
	elseif args:IsSpellID(20223) then
		warnMagicReflection:Show()
		soundMagicReflection:Play()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(21097) then 
		if args:IsPlayer() then
			specWarnManastorm:Show();
		end
	elseif args:IsSpellID(20223) then
		warnMagicReflection:Show()
		soundMagicReflection:Play()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------