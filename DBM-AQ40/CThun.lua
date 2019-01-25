local mod	= DBM:NewMod("CThun", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15727, 15589)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_SUMMON",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

----------Pre-warnings----------
local prewarnEyeTentacleShadow		= mod:NewAnnounce("Eye Tentacles: Shadow Soon", 3)
local prewarnEyeTentacleFire		= mod:NewAnnounce("Eye Tentacles: Fire Soon", 3)
local prewarnEyeTentacleNature		= mod:NewAnnounce("Eye Tentacles: Nature Soon", 3)
local prewarnLookAway				= mod:NewAnnounce("Look Away Soon", 3)
local prewarnDarkGlare				= mod:NewAnnounce("Dark Glare Soon", 3)
local prewarnManipulator			= mod:NewAnnounce("Manipulator Tentacle Soon", 3)
local prewarnDevastator				= mod:NewAnnounce("Devastator Tentacle Soon", 3)
local prewarnMalignant				= mod:NewAnnounce("Malignant Tentacle Soon", 3)
local prewarnGiantEye				= mod:NewAnnounce("Giant Eye Tentacle Soon", 3)
local prewarnGiantClaw				= mod:NewAnnounce("Giant Claw Tentacle Soon", 3)
local prewarnStomach				= mod:NewAnnounce("Stomach Phase Soon", 3)
----------Warnings----------
local warnEyeTentacleShadow			= mod:NewAnnounce("Eye Tentacles Spawned: Shadow", 2)
local warnEyeTentacleFire			= mod:NewAnnounce("Eye Tentacles Spawned: Fire", 2)
local warnEyeTentacleNature			= mod:NewAnnounce("Eye Tentacles Spawned: Nature", 2)
local warnDarkGlare					= mod:NewTargetAnnounce(26029, 4)
local warnEldritch					= mod:NewSpellAnnounce(4500009, 4)
local warnManipulator				= mod:NewAnnounce("Manipulator Tentacle Spawned", 2)
local warnDevastator				= mod:NewAnnounce("Devastator Tentacle Spawned", 2)
local warnMalignant					= mod:NewAnnounce("Malignant Tentacle Spawned", 2)
local warnGiantEyeTentacle			= mod:NewAnnounce("Giant Eye Tentacle Spawned", 2)
local warnGiantClawTentacle			= mod:NewAnnounce("Giant Claw Tentacle Spawned", 2)
local warnWeakened					= mod:NewAnnounce("C'thun is Weakened!", 4)
local warnStomach					= mod:NewAnnounce("Stomach Phase Now", 2)
local warnPhase2					= mod:NewPhaseAnnounce(2)

----------Timers----------
local timerDarkGlareCD				= mod:NewCDTimer(87.5, 26029)
local timerDarkGlare				= mod:NewTimer(37.5, "Dark Glare: Time Remaining")
local timerEldritch					= mod:NewTimer(5, "LOOK AWAY")
local timerEldritchCD				= mod:NewCDTimer(30, 4500009)
local timerEyeTentacleShadow		= mod:NewTimer(45, "Eye Tentacles: Shadow")
local timerEyeTentacleFire			= mod:NewTimer(45, "Eye Tentacles: Fire")
local timerEyeTentacleNature		= mod:NewTimer(45, "Eye Tentacles: Nature")
local timerStomach					= mod:NewTimer(21, "Enter Stomach")
local timerGiantEyeTentacle			= mod:NewTimer(44, "Giant Eye Tentacle")
local timerGiantClawTentacle 		= mod:NewTimer(14, "Giant Claw Tentacle")
local timerWeakened					= mod:NewTimer(30, "Weakened: Time Remaining")
local timerManipulator				= mod:NewTimer(15, "Manipulator Tentacle")
local timerDevastator				= mod:NewTimer(15, "Devastator Tentacle")
local timerMalignant				= mod:NewTimer(15, "Malignant Tentacle")

----------Misc----------
mod:AddBoolOption("RangeFrame", true)
local etent
local lasttent
local phase
local miniadd
local eldfixglare

local soundGlare					= mod:NewSound(26029)

----------PreWarning Functions----------
function mod:preShadow()
	prewarnEyeTentacleShadow:Show()
end
function mod:preFire()
	prewarnEyeTentacleFire:Show()
end
function mod:preNature()
	prewarnEyeTentacleNature:Show()
end
function mod:preStomach()
	prewarnStomach:Show()
end
function mod:preGiantClaw()
	prewarnGiantClaw:Show()
end
function mod:preGiantEye()
	prewarnGiantEye:Show()
end
function mod:preGlare()
	prewarnDarkGlare:Show()
end
function mod:preFear()
	if phase == 1 then
		prewarnLookAway:Show()
	end
end
function mod:preManipulator()
	prewarnManipulator:Show()
end
function mod:preDevastator()
	prewarnDevastator:Show()
end
function mod:preMalignant()
	prewarnMalignant:Show()
end

----------Alert Functions----------
function mod:alertShadow()
	warnEyeTentacleShadow:Show()
	lasttent = 1
end
function mod:alertFire()
	warnEyeTentacleFire:Show()
	lasttent = 2 
end
function mod:alertNature()
	warnEyeTentacleNature:Show()
	lasttent = 3 
end
function mod:alertStomach()
	warnStomach:Show()
end
function mod:alertGiantClaw()
	warnGiantClawTentacle:Show()
end
function mod:alertGiantEye()
	warnGiantEyeTentacle:Show()
end
function mod:alertGlare()
	warnDarkGlare:Show()
	soundGlare:Play()
end
function mod:alertFear()
	if phase == 1 then
		warnEldritch:Show()
	end
end
function mod:alertManipulator()
	warnManipulator:Show()
end
function mod:alertDevastator()
	warnDevastator:Show()
end
function mod:alertMalignant()
	warnMalignant:Show()
end

----------Real Functions----------
function mod:OnCombatStart(delay)
	phase = 1 
	etent = 1
	lasttent = 3
	miniadd = 1
	eldfixglare = 1
	self:ScheduleMethod(0-delay, "eldFearInitial")
	self:ScheduleMethod(0-delay, "darkGlareInitial")
	self:ScheduleMethod(0-delay, "eyeTentacle")
--	self:ScheduleMethod(0-delay, "miniAddInitial")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(13)
	end
	self:ScheduleMethod(0, "getBestKill")
end

--function mod:miniAddInitial()
--	local timer14 = 10
--	timerDevastator:Start(timer14)
--	miniadd = 2
--	self:ScheduleMethod(timer14-5, "warnDevastator")
--	self:ScheduleMethod(timer14, "alertDevastator")
--	self:ScheduleMethod(timer14, "miniAdd")
--end

--function mod:miniAdd()
--	local timer15 = 15
--end
	
function mod:eyeTentacle()
	local timer1 = 45
	if etent == 1 then 
		timerEyeTentacleShadow:Start(timer1)
		self:ScheduleMethod(timer1-5, "preShadow")
		self:ScheduleMethod(timer1, "alertShadow")
		etent = 2
	elseif etent == 2 then
		timerEyeTentacleFire:Start(timer1)
		self:ScheduleMethod(timer1-5, "preFire")
		self:ScheduleMethod(timer1, "alertFire")
		etent = 3
	elseif etent == 3 then
		timerEyeTentacleNature:Start(timer1)
		self:ScheduleMethod(timer1-5, "preNature")
		self:ScheduleMethod(timer1, "alertNature")
		etent = 1
	end
	self:ScheduleMethod(timer1, "eyeTentacle")
end

function mod:darkGlareInitial()
	local timer11 = 50
	timerDarkGlareCD:Start(timer11)
	self:ScheduleMethod(timer11-5, "preGlare")
	self:ScheduleMethod(timer11, "alertGlare")
end

function mod:darkGlare()
	local timer10 = 87.5
	timerDarkGlare:Start()
	timerDarkGlareCD:Start(timer10)
	self:ScheduleMethod(timer10-5, "preGlare")
	self:ScheduleMethod(timer10, "alertGlare")
end

function mod:eldFearInitial()
	if phase == 1 then
		local timer13 = 30
		timerEldritchCD:Start(timer13)
		self:ScheduleMethod(timer13-5, "preFear")
		self:ScheduleMethod(timer13, "alertFear")
	end
end

function mod:eldFear()
	if phase == 1 then
		local timer12 = 30
		if eldfixglare == 1 then 
			timerEldritch:Start()
		elseif eldfixglare == 2 then
			self:ScheduleMethod(timer12-5, "eldFearGlareFix")
		end
		timerEldritchCD:Start(timer12)
		self:ScheduleMethod(timer12-5, "preFear")
		self:ScheduleMethod(timer12, "alertFear")
	end
end

function mod:eldFearGlareFix()
	eldfixglare = 1
end

function mod:enterStomach()
	local timer2 = 20
	timerStomach:Start(timer2)
	self:ScheduleMethod(timer2-5, "preStomach")
	self:ScheduleMethod(timer2, "alertStomach")
	self:ScheduleMethod(timer2, "enterStomach")
end

function mod:stomachWeaknessFix()
	local timer4 = 15
	timerStomach:Start(timer4)
	self:ScheduleMethod(timer4-5, "preStomach")
	self:ScheduleMethod(timer4, "alertStomach")
	self:ScheduleMethod(timer4, "enterStomach")
end

function mod:clawTentacleInitial()
	local timer3 = 14
	timerGiantClawTentacle:Start(timer3)
	self:ScheduleMethod(timer3-5, "preGiantClaw")
	self:ScheduleMethod(timer3, "alertGiantClaw")
	self:ScheduleMethod(timer3, "clawTentacle")
end

function mod:clawTentacleWeaknessFix()
	local timer5 = 10
	timerGiantClawTentacle:Start(timer5)
	self:ScheduleMethod(timer5-5, "preGiantClaw")
	self:ScheduleMethod(timer5, "alertGiantClaw")
	self:ScheduleMethod(timer5, "clawTentacle")
end

function mod:clawTentacle()
	local timer6 = 60
	timerGiantClawTentacle:Start(timer6)
	self:ScheduleMethod(timer6-5, "preGiantClaw")
	self:ScheduleMethod(timer6, "alertGiantClaw")
	self:ScheduleMethod(timer6, "clawTentacle")
end

function mod:geyeTentacleInitial()
	local timer7 = 44
	timerGiantEyeTentacle:Start(timer7)
	self:ScheduleMethod(timer7-5, "preGiantEye")
	self:ScheduleMethod(timer7, "alertGiantEye")
	self:ScheduleMethod(timer7, "geyeTentacle")
end

function mod:geyeTentacleWeaknessFix()
	local timer8 = 40
	timerGiantEyeTentacle:Start(timer8)
	self:ScheduleMethod(timer8-5, "preGiantEye")
	self:ScheduleMethod(timer8, "alertGiantEye")
	self:ScheduleMethod(timer8, "geyeTentacle")
end

function mod:geyeTentacle()
	local timer9 = 60
	timerGiantEyeTentacle:Start(timer9)
	self:ScheduleMethod(timer9-5, "preGiantEye")
	self:ScheduleMethod(timer9, "alertGiantEye")
	self:ScheduleMethod(timer9, "geyeTentacle")
end

function mod:fixweaknessTimers()
	self:ScheduleMethod(0, "stomachWeaknessFix")
	self:ScheduleMethod(0, "clawTentacleWeaknessFix")
	self:ScheduleMethod(0, "geyeTentacleWeaknessFix")
	if lasttent == 1 then
		etent = 2
	elseif lasttent == 2 then
		etent = 3
	elseif lasttent == 3 then
		etent = 1
	end
	self:ScheduleMethod(0, "eyeTentacle")
end
function mod:phaseTwo()
	warnPhase2:Show()
	if lasttent == 1 then
		etent = 2
	elseif lasttent == 2 then
		etent = 3
	elseif lasttent == 3 then
		etent = 1
	end
		
	self:ScheduleMethod(6, "eyeTentacle")
	self:ScheduleMethod(1, "enterStomach")
	self:ScheduleMethod(0, "clawTentacleInitial")
	self:ScheduleMethod(0, "geyeTentacleInitial")
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15589 and phase == 1 then
		phase = 2
		timerEldritch:Stop()
		timerEldritchCD:Stop()
		timerDarkGlare:Stop()
		timerDarkGlareCD:Stop()
		timerEyeTentacleFire:Stop()
		timerEyeTentacleNature:Stop()
		timerEyeTentacleShadow:Stop()
		self:UnscheduleMethod("eyeTentacle")
		self:UnscheduleMethod("preShadow")
		self:UnscheduleMethod("preFire")
		self:UnscheduleMethod("preNature")
		self:UnscheduleMethod("alertShadow")
		self:UnscheduleMethod("alertFire")
		self:UnscheduleMethod("alertNature")
		self:UnscheduleMethod("eldFear")
		self:UnscheduleMethod("eldFearInitial")
		self:UnscheduleMethod("preFear")
		self:UnscheduleMethod("alertFear")
		self:UnscheduleMethod("darkGlare")
		self:UnscheduleMethod("darkGlareInitial")
		self:UnscheduleMethod("preGlare")
		self:UnscheduleMethod("alertGlare")
		
		self:ScheduleMethod(0, "phaseTwo")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L.Eldritch) then
		self:ScheduleMethod(0, "eldFear")
	end
	if msg:find(L.Glare) then
		eldfixglare = 2
		timerEldritchCD:Stop()
		self:UnscheduleMethod("eldFearInitial")
		self:UnscheduleMethod("eldFear")
		self:UnscheduleMethod("preFear")
		self:UnscheduleMethod("alertFear")
		self:ScheduleMethod(0, "darkGlare")
		self:ScheduleMethod(37.5, "eldFear")
	end
	if msg:find(L.weakened) then
		timerWeakened:Start()
		warnWeakened:Show()
		timerGiantClawTentacle:Stop()
		timerGiantEyeTentacle:Stop()
		timerStomach:Stop()
		timerEyeTentacleFire:Stop()
		timerEyeTentacleNature:Stop()
		timerEyeTentacleShadow:Stop()
		self:UnscheduleMethod("enterStomach")
		self:UnscheduleMethod("stomachWeaknessFix")
		self:UnscheduleMethod("preStomach")
		self:UnscheduleMethod("alertStomach")
		self:UnscheduleMethod("clawTentacleInitial")
		self:UnscheduleMethod("clawTentacleWeaknessFix")
		self:UnscheduleMethod("clawTentacle")
		self:UnscheduleMethod("preGiantClaw")
		self:UnscheduleMethod("alertGiantClaw")
		self:UnscheduleMethod("geyeTentacle")
		self:UnscheduleMethod("geyeTentacleInitial")
		self:UnscheduleMethod("geyeTentacleWeaknessFix")
		self:UnscheduleMethod("preGiantEye")
		self:UnscheduleMethod("alertGiantEye")
		self:UnscheduleMethod("eyeTentacle")
		self:UnscheduleMethod("preShadow")
		self:UnscheduleMethod("alertShadow")
		self:UnscheduleMethod("preFire")
		self:UnscheduleMethod("alertFire")
		self:UnscheduleMethod("preNature")
		self:UnscheduleMethod("alertNature")
		self:ScheduleMethod(30, "fixweaknessTimers")
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------