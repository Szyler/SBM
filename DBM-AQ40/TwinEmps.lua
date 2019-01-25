local mod	= DBM:NewMod("TwinEmpsAQ", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15276, 15275)
mod:RegisterCombat("combat")
mod:SetBossHealthInfo(
	15276, L.Veklor,
	15275, L.Veknil
)
local warnTeleportSoon	= mod:NewSoonAnnounce(800, 2)
local warnTeleport		= mod:NewSpellAnnounce(800, 3)
local timerTeleport			= mod:NewNextTimer(30, 800)
local berserkTimer	=	mod:NewBerserkTimer(600)

local soundTele		= mod:NewSound2("Teleport Sound Effect")

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	self:ScheduleMethod(0-delay, "twinTeleport")
	self:ScheduleMethod(0, "getBestKill")
end

function mod:alarmSound()
	soundTele:Play()
end

function mod:teleSoon()
	warnTeleportSoon:Show()
end

function mod:teleNow()
	warnTeleport:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:twinTeleport()
	timer = 30
	timerTeleport:Start(timer)
	self:ScheduleMethod(timer-5, "teleSoon")
	self:ScheduleMethod(timer, "teleNow")
	self:ScheduleMethod(timer, "twinTeleport")
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------