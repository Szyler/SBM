local mod	= DBM:NewMod("Faerlina", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15953, 16506)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)
-----ENRAGE-----
local warnEnrageSoon			= mod:NewSoonAnnounce(28131, 3)
local warnEnrageNow				= mod:NewSpellAnnounce(28131, 4)
local warnEmbraceActive			= mod:NewSpellAnnounce(28732, 1)
local timerEnrage				= mod:NewTimer(60, "Enrage CD", 28131)
-----EMBRACE-----
local warnEmbraceExpire			= mod:NewAnnounce("WarningEmbraceExpire", 2, 28732)
local warnEmbraceExpired		= mod:NewAnnounce("WarningEmbraceExpired", 3, 28732)
local timerEmbrace				= mod:NewBuffActiveTimer(20, 28732)
local timerEnrage				= mod:NewTimer(60, "Enrage CD", 28131)
------AoE-----
local specWarnRainOfFire		= mod:NewSpecialWarningMove(1003054, true, "Special warning when standing in Rain of Fire", true)
local soundRainOfFire			= mod:SoundAlert(1003054)
local specWarnPoisonPool		= mod:NewSpecialWarningMove(869762, true, "Special warning when standing in Poison Pool", true)
local specWarnClingingPoison	= mod:NewSpecialWarningMove(1003060, true, "Special warning when standing in Clinging Poison", true)
local soundPoison				= mod:SoundAirHorn(869762)
-----MISC-----
local berserkTimer				= mod:NewBerserkTimer(300)
local embraceSpam = 0
local enraged = false

function mod:OnCombatStart(delay)
	berserkTimer:Start(300-delay)
	mod:getBestKill()
	timerEnrage:Start(60 - delay)
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
			warnEnrageSoon:Schedule(55)
		end
		timerEmbrace:Start()
		warnEmbraceActive:Show()
		warnEmbraceExpire:Schedule(15)
		warnEmbraceExpired:Schedule(20)
		enraged = false
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28798, 54100) then			-- Frenzy
		warnEnrageNow:Show()
		enraged = GetTime()
	end
	if args:IsSpellID(1003054) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show();
			soundRainOfFire:Play();
		end
	end
	if args:IsSpellID(869762) then 
		if args:IsPlayer() then
			specWarnPoisonPool:Show();
			soundPoison:Play();
		end
	end
	if args:IsSpellID(1003060) then 
		if args:IsPlayer() then
			specWarnClingingPoison:Show();
			soundPoison:Play();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(1003054) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show();
			soundRainOfFire:Play();
		end
	end
	if args:IsSpellID(869762) then 
		if args:IsPlayer() then
			specWarnPoisonPool:Show();
			soundPoison:Play();
		end
	end
	if args:IsSpellID(1003060) then 
		if args:IsPlayer() then
			specWarnClingingPoison:Show();
			soundPoison:Play();
		end
	end
end

-----TBM GLOBAL FUNCTIONS-----
function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end