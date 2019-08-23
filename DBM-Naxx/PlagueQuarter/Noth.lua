local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15954)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)

-----Teleport-----
local warnTeleportNow		= mod:NewAnnounce("WarningTeleportNow", 3, 46573)
local warnTeleportSoon		= mod:NewAnnounce("WarningTeleportSoon", 1, 46573)
local timerTeleport			= mod:NewTimer(600, "Teleport to Balcony", 46573)
local timerTeleportBack		= mod:NewTimer(600, "Teleport to Raid", 46573)
local soundTeleport			= mod:SoundInfoLong(46573)
-----Curse-----
local warnCurse				= mod:NewSpellAnnounce(29213, 2)
local specWarnCurse			= mod:NewSpecialWarning("Curse of the Plaguebringer on you!", true, "Special warning when Curse of the Plaguebringer is applied to you", true)
local soundCurse			= mod:SoundAirHorn(29213)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(375)
local phase = 0

function mod:OnCombatStart(delay)
	berserkTimer:Start(375-delay)
	self:ScheduleMethod(0, "getBestKill")
	phase = 0
	self:BackInRoom()
end

function mod:Balcony()
	local timer
	if phase == 1 then timer = 75
	elseif phase == 2 then timer = 70
	elseif phase == 3 then timer = 30 
	else return	end
	soundTeleport:Schedule(timer)
	timerTeleportBack:Show(timer)
	warnTeleportSoon:Schedule(timer - 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "BackInRoom")
end

function mod:BackInRoom()
	phase = phase + 1
	local timer
	if phase == 1 then timer = 60
	elseif phase == 2 then timer = 45 
	elseif phase == 3 then timer = 30 
	else return end
	soundTeleport:Schedule(timer)
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer - 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "Balcony")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29213, 54835) then	-- Curse of the Plaguebringer
		warnCurse:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29213) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
			soundCurse:Play();
		end
	end
	if args:IsSpellID(54835) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
			soundCurse:Play();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29213) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
			soundCurse:Play();
		end
	end
	if args:IsSpellID(54835) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
			soundCurse:Play();
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