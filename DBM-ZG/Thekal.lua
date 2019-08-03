local mod = DBM:NewMod("Thekal", "DBM-ZG", 1)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 148 $"):sub(12, -3))

mod:SetCreatureID(14509, 11348, 11347)
mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellKill)

mod:SetBossHealthInfo(
	14509, L.Thekal,
	11348, L.Zath,
	11347, L.LorKhan
)

mod:RegisterEvents(
	"SPELL_CAST_START",
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


local warnHeal			= mod:NewCastAnnounce(24208, 3)
local timerHeal			= mod:NewCastTimer(4, 24208)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

function mod:vekHeal()
	warnHeal:Show()
	timerHeal:Start()
	self:ScheduleMethod(0, "alarmSound")
end
	
function mod:alarmSound()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.mp3")
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(24208) then
		warnHeal:Show()
		timerHeal:Start()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------