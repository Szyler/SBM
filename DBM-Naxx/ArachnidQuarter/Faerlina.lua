local mod	= DBM:NewMod("Faerlina", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15953)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"PLAYER_ALIVE"
)

local warnEmbraceActive		= mod:NewSpellAnnounce(28732, 1)
local warnEmbraceExpire		= mod:NewAnnounce("WarningEmbraceExpire", 2, 28732)
local warnEmbraceExpired	= mod:NewAnnounce("WarningEmbraceExpired", 3, 28732)
local warnEnrageSoon		= mod:NewSoonAnnounce(28131, 3)
local warnEnrageNow			= mod:NewSpellAnnounce(28131, 4)

local timerEmbrace			= mod:NewBuffActiveTimer(30, 28732)
local timerEnrage			= mod:NewCDTimer(60, 28131)

local embraceSpam = 0
local enraged = false

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	timerEnrage:Start(-delay)
	warnEnrageSoon:Schedule(55 - delay)
	enraged = false
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28732, 54097)				-- Widow's Embrace
	and (GetTime() - embraceSpam) > 5 then  -- This spell is casted twice in Naxx 25 (bug?)
		embraceSpam = GetTime()
		warnEmbraceExpire:Cancel()
		warnEmbraceExpired:Cancel()
		warnEnrageSoon:Cancel()
		timerEnrage:Stop()
		if enraged then
			timerEnrage:Start()
			warnEnrageSoon:Schedule(45)
		end
		timerEmbrace:Start()
		warnEmbraceActive:Show()
		warnEmbraceExpire:Schedule(25)
		warnEmbraceExpired:Schedule(30)
		enraged = false
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28798, 54100) then			-- Frenzy
		warnEnrageNow:Show()
		enraged = GetTime()
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
