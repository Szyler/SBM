local mod	= DBM:NewMod("Heigan", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15936)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)

mod:EnableModel()

-----Teleport-----
local warnTeleportSoon			= mod:NewAnnounce("WarningTeleportSoon", 2, 46573)
local warnTeleportNow			= mod:NewAnnounce("WarningTeleportNow", 3, 46573)
local timerTeleport				= mod:NewTimer(90, "TimerTeleport", 46573)
local soundTeleport				= mod:SoundInfoLong(46573)
-----HeiganEffects------
local specWarnSpellDisruption	= mod:NewSpecialWarning("Spell Disruption on you!", false, "Special warning when Spell Disruption is applied to you", true)
local specWarnBurningFever		= mod:NewSpecialWarning("Burning Fever on you!", true, "Special warning when Spell Disruption is applied to you", true)
local soundBurningFever			= mod:SoundAirHorn(1003068)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(540)

function mod:OnCombatStart(delay)
	berserkTimer:Start(540-delay)
	self:ScheduleMethod(0, "getBestKill")
	mod:BackInRoom(90 - delay)
end

function mod:DancePhase()
	timerTeleport:Show(47)
	warnTeleportSoon:Schedule(37, 10)
	warnTeleportNow:Schedule(47)
	soundTeleport:Schedule(47)
	self:ScheduleMethod(47, "BackInRoom", 88)
end

function mod:BackInRoom(time)
	timerTeleport:Show(time)
	warnTeleportSoon:Schedule(time - 15, 15)
	warnTeleportNow:Schedule(time)
	soundTeleport:Schedule(time)
	self:ScheduleMethod(time, "DancePhase")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29310) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
		end
	elseif args:IsSpellID(1003068) then 
		if args:IsPlayer() then
			specWarnBurningFever:Show();
			SendChatMessage(L.YellBurningFever, "YELL")
			soundBurningFever:Play();
		end	
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29310) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
		end
	elseif args:IsSpellID(1003068) then 
		if args:IsPlayer() then
			specWarnBurningFever:Show();
			SendChatMessage(L.YellBurningFever, "YELL")
			soundBurningFever:Play();
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
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------