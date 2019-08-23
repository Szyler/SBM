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
local warnTeleportSoon			= mod:NewAnnounce("Teleport to Platform Soon", 2, 46573)
local warnTeleportNow			= mod:NewAnnounce("Teleport to Platform Now", 3, 46573)
local timerTeleport				= mod:NewTimer(90, "Teleport to Platform", 46573)
local soundTeleport				= mod:SoundInfoLong(46573)
-----Dance Ends----
local timerDanceEnds			= mod:NewTimer(47, "Dance Ends", 46573)
local warnDanceEndsSoon			= mod:NewAnnounce("Dance Ends Soon", 2, 46573)
local warnDanceEnds				= mod:NewAnnounce("Dance Ends Now", 3, 46573)
local soundDanceEnds			= mod:SoundInfoLong(46573)
-----HeiganEffects------
local specWarnSpellDisruption	= mod:NewSpecialWarning("Spell Disruption on you!", false, "Special warning when Spell Disruption is applied to you", true)
local specWarnBurningFever		= mod:NewSpecialWarning("Burning Fever on you!", true, "Special warning when Spell Disruption is applied to you", true)
local soundBurningFever			= mod:SoundAirHorn(1003068)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(540)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(540-delay)
	mod:getBestKill()
	mod:BackInRoom()
end

function mod:DancePhase()
	timer = 47
	timerDanceEnds:Show(timer)
	warnDanceEndsSoon:Schedule(timer-10, 10)
	warnDanceEnds:Schedule(timer)
	soundDanceEnds:Schedule(timer)
	self:ScheduleMethod(timer, "BackInRoom", 88)
end

function mod:BackInRoom()
	timer = 90
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer-15, 15)
	warnTeleportNow:Schedule(timer)
	soundTeleport:Schedule(timer)
	self:ScheduleMethod(timer, "DancePhase")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29310) then 
		if args:IsPlayer() then
			specWarnSpellDisruption:Show();
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
			specWarnSpellDisruption:Show();
		end
	elseif args:IsSpellID(1003068) then 
		if args:IsPlayer() then
			specWarnBurningFever:Show();
			SendChatMessage(L.YellBurningFever, "YELL")
			soundBurningFever:Play();
		end
	end
end

-----TBM CLEAN UP FUNCTIONS-----
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