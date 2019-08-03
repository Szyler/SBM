local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2943 $"):sub(12, -3))
mod:SetCreatureID(15956)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"PLAYER_ALIVE"
)
-----Locust Swarm-----
local prewarnLocustInitial	= mod:NewAnnounce("Locust Swarm Initial CD Now", 2, 28785)
local prewarnLocust			= mod:NewAnnounce("Locust Swarm Soon", 2, 28785)
local warnLocust			= mod:NewAnnounce("Locust Swarm", 3, 28785)
local timerLocust			= mod:NewTimer(90, "Next Locust Swarm", 28785)
local timerLocustInitial	= mod:NewTimer(90, "Locust Swarm Initial CD", 28785)
local timerLocustRemaining	= mod:NewTimer(15, "Locust Swarm: Time Remaining", 28785)
local specWarnLocust		= mod:NewSpecialWarning("Locust Swarm", nil, "Special warning for Locust Swarm cast")
local soundLocust			= mod:NewSound(28785)
-----Dark Gaze-----
local specWarnDarkGaze		= mod:NewSpecialWarning("Dark Gaze", nil, "Special warning for Dark Gaze on you")
-----Misc-----
local berserkTimer			= mod:NewBerserkTimer(600)
-----Pre-Alert Functions-----
function mod:preLocust()
	prewarnLocust:Show()
end
-----Alert FUNCTIONS-----
function mod:alertLocustInitial()
	prewarnLocustInitial:Show()
end
function mod:alertLocust()
	warnLocust:Show()
	soundLocust:Play()
end
-----Boss Functions-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "getBestKill")
	self:ScheduleMethod(0, "locustInitial")
end

function mod:locustInitial()
	timer1 = 90
	timerLocustInitial:Show(timer1)
	self:ScheduleMethod(timer1, "alertLocustInitial")
end

function mod:locustRepeat()
	timer3 = 90
	timerLocust:Show(timer3)
	self:ScheduleMethod(timer3-5, "preLocust")
	self:ScheduleMethod(timer3, "alertLocust")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1003011) then 
		if args:IsPlayer() then
			specWarnDarkGaze:Show();
			SendChatMessage(L.YellDarkGaze, "YELL")
		end
	elseif args:IsSpellID(28786) then 
		timerLocustRemaining:Show(15)
	end	
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28785) then
		mod:locustRepeat()
		specWarnLocust:Show(17)
	end
end
-----OBM CLEAN UP FUNCTIONS-----
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