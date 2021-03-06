local mod	= DBM:NewMod("TwinEmpsAQ", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15276, 15275)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

mod:SetBossHealthInfo(
	15276, L.Veklor,
	15275, L.Veknil
)

local warnTeleportSoon	= mod:NewSoonAnnounce(800, 2)
local warnTeleport		= mod:NewSpellAnnounce(800, 3)
local timerTeleport			= mod:NewNextTimer(30, 800)
local berserkTimer	=	mod:NewBerserkTimer(600)

local soundTele		= mod:SoundInfo(800)

local specWarnBlizzard		= mod:NewSpecialWarningMove(26607, true, "Special warning when standing in Blizzard", true)
local specWarnMutateBug		= mod:NewSpecialWarningMove(802, true, "Special warning for add with Mutate Bug", true)
local specWarnExplodeBug		= mod:NewSpecialWarningMove(804, true, "Special warning for add with Explode Bug", true)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	self:ScheduleMethod(-delay, "twinTeleport")
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

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(26607) then 
		if args:IsPlayer() then
			specWarnBlizzard:Show();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(26607) then -- Miasma (Eye Tentacles)
		if args:IsPlayer() then
			specWarnBlizzard:Show();
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(802, 804) then -- Mutate Bug 802 -- Explode Bug 804
		specWarnMutateBug:Show();
		if (mark == nil) or (mark < 0) then
			mark=9;
		end
		if(GetRaidTargetIndex(args.destName) == nil) then 
			SetRaidTarget(args.destName, mark);
			mark=mark-1;
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(802, 804) then -- Mutate Bug 802 -- Explode Bug 804
		if(GetRaidTargetIndex(args.destName) > 0) then
			SetRaidTarget(args.destName, 0);
		end
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------