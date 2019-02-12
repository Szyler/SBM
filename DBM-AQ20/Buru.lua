local mod	= DBM:NewMod("Buru", "DBM-AQ20", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 156 $"):sub(12, -3))
mod:SetCreatureID(15370)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_EMOTE",
	"UNIT_DIED",
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

local warnPursue		= mod:NewAnnounce("WarnPursue", 3)
local specWarnPursue	= mod:NewSpecialWarning("SpecWarnPursue")

local berserkTimer	=	mod:NewBerserkTimer(600)

local eggsDead

function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "getBestKill")
	eggsDead = 0 
	DBM:AddMsg("This boss is not yet completed in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

function mod:CHAT_MSG_MONSTE_EMOTE(msg)
	if not msg then return end
	local _, target = msg.find(L.PursueEmote)
	if target then
		warnPursue:Show(target)
		if target == UnitName("player") then
			specWarnPursue:Show()
		end
	end
end

--EDIT THIS: add the recapID
function mod:UNIT_DIED(args)
	local recapID = self:GetCIDFromGUID(args.destGUID)
	if recapID == 15514 then
		eggsDead = eggsDead + 1  
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------