local mod	= DBM:NewMod("Sartura", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15516)
mod:RegisterCombat("combat")

-----MISC TIMERS-----
local berserkTimer				= mod:NewBerserkTimer(360)
local kickAnnounce				= mod:NewSpellAnnounce(1766, 4)
local meleeOut					= mod:NewAnnounce("MELEE OUT - MELEE OUT", 4)
-----PREWARNINGS-----
local prewarnSTranslocation		= mod:NewAnnounce("Song of Translocation Soon", 3)
local prewarnDTranslocation		= mod:NewAnnounce("Dance of Translocation Soon", 3)
local prewarnSColossus			= mod:NewAnnounce("Song of The Colossus Soon", 3)
local prewarnDHaste				= mod:NewAnnounce("Dance of Haste Soon", 3)
local prewarnSOppression		= mod:NewAnnounce("Song of Oppression Soon", 3)
local prewarnDHunt				= mod:NewAnnounce("Dance of The Hunt Soon", 3)
local prewarnSDeath				= mod:NewAnnounce("Song of Death Soon", 3)
-----ALERTS-----
local warnSTranslocation		= mod:NewSpellAnnounce(1002345, 2)
local warnDTranslocation		= mod:NewSpellAnnounce(1002323, 2)
local warnSColossus				= mod:NewSpellAnnounce(1002346, 2)
local warnDHaste				= mod:NewSpellAnnounce(1002324, 2)
local warnSOppression			= mod:NewSpellAnnounce(1002347, 2)
local warnDHunt					= mod:NewSpellAnnounce(1002325, 2)
local warnSDeath				= mod:NewSpellAnnounce(1002348, 2)
-----TIMERS-----
local timerStacks				= mod:NewTimer(60, "Time Remaining: Stacks")
local timerSongRemaining		= mod:NewTimer(17, "Time Remaining: Song")
local timerDanceRemaining		= mod:NewTimer(17, "Time Remaining: Dance")
local timerSTranslocation		= mod:NewCDTimer(30, 1002345)
local timerDTranslocation		= mod:NewCDTimer(30, 1002323)
local timerSColossus			= mod:NewCDTimer(30, 1002346)
local timerDHaste				= mod:NewCDTimer(30, 1002324)
local timerSOppression			= mod:NewCDTimer(30, 1002347)
local timerDHunt				= mod:NewCDTimer(30, 1002325)
local timerSDeath				= mod:NewCDTimer(30, 1002348)
-----SOUND-----
local soundMelee				= mod:NewSound(1002347)
-----PREWARNING FUNCTIONS-----
function mod:preSTranslocation()
	prewarnSTranslocation:Show()
end
function mod:preDTranslocation()
	prewarnDTranslocation:Show()
end
function mod:preSColossus()
	prewarnSColossus:Show()
end
function mod:preDHaste()
	prewarnDHaste:Show()
end
function mod:preSOppression()
	prewarnSOppression:Show()
end
function mod:preDHunt()
	prewarnDHunt:Show()
end
function mod:preSDeath()
	prewarnSDeath:Show()
end

-----ALERT FUNCTIONS-----
function mod:alertSTranslocation()
	warnSTranslocation:Show()
end
function mod:alertDTranslocation()
	warnDTranslocation:Show()
end
function mod:alertSColossus()
	warnSColossus:Show()
end
function mod:alertDHaste()
	warnDHaste:Show()
end
function mod:alertSOppression()
	warnSOppression:Show()
end
function mod:alertDHunt()
	warnDHunt:Show()
end
function mod:alertSDeath()
	warnSDeath:Show()
end

-----MISC FUNCTIONS-----
function mod:alarmSound()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.mp3")
end
function mod:kickThisCunt()
	self:ScheduleMethod(0, "alarmSound")
	kickAnnounce:Show()
end
function mod:runBitch()
	soundMelee:Play()
	meleeOut:Show()
end

-----ACTUAL FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "iSarturaCast")
	self:ScheduleMethod(0, "getBestKill")
end

function mod:iSarturaCast()
	local timer1 = 10
	timerSTranslocation:Start(timer1)
	self:ScheduleMethod(timer1-5, "preSTranslocation")
	self:ScheduleMethod(timer1, "alertSTranslocation")
	self:ScheduleMethod(timer1, "kickThisCunt")
	self:ScheduleMethod(timer1, "iiSarturaCast")
end

function mod:iiSarturaCast()
	local timer2 = 25
	timerDTranslocation:Start(timer2)
	self:ScheduleMethod(timer2-5, "preDTranslocation")
	self:ScheduleMethod(timer2, "alertDTranslocation")
	self:ScheduleMethod(timer2, "kickThisCunt")
	self:ScheduleMethod(timer2, "iiiSarturaCast")
end

function mod:iiiSarturaCast()
	local timer3 = 25
	timerSColossus:Start(timer3)
	self:ScheduleMethod(timer3-5, "preSColossus")
	self:ScheduleMethod(timer3, "alertSColossus")
	self:ScheduleMethod(timer3, "kickThisCunt")
	self:ScheduleMethod(timer3, "ivSarturaCast")
end

function mod:ivSarturaCast()
	local timer4 = 25
	timerDHaste:Start(timer4)
	timerStacks:Start()
	self:ScheduleMethod(timer4-5, "preDHaste")
	self:ScheduleMethod(timer4, "alertDHaste")
	self:ScheduleMethod(timer4, "vSarturaCast")
end

function mod:vSarturaCast()
	local timer5 = 25
	timerDanceRemaining:Start()
	timerSOppression:Start(timer5)
	self:ScheduleMethod(timer5-5, "preSOppression")
	self:ScheduleMethod(timer5, "alertSOppression")
	self:ScheduleMethod(timer5-2, "runBitch")
	self:ScheduleMethod(timer5, "viSarturaCast")
end

function mod:viSarturaCast()
	local timer6 = 25
	timerSongRemaining:Start()	
	timerDHunt:Start(timer6)
	self:ScheduleMethod(timer6-5, "preDHunt")
	self:ScheduleMethod(timer6, "alertDHunt")
	self:ScheduleMethod(timer6, "viiSarturaCast")
end

function mod:viiSarturaCast()
	local timer7 = 25
	timerDanceRemaining:Start()
	timerSDeath:Start(timer7)
	self:ScheduleMethod(timer7-5, "preSDeath")
	self:ScheduleMethod(timer7, "alertSDeath")
	self:ScheduleMethod(timer7, "kickThisCunt")
	self:ScheduleMethod(timer7, "viiiSarturaCast")
end

function mod:viiiSarturaCast()
	local timer8 = 50
	timerSTranslocation:Start(timer8)
	self:ScheduleMethod(timer8-5, "preSTranslocation")
	self:ScheduleMethod(timer8, "alertSTranslocation")
	self:ScheduleMethod(timer8, "kickThisCunt")
	self:ScheduleMethod(timer8, "ixSarturaCast")
end

function mod:ixSarturaCast()
	local timer9 = 25
	timerDTranslocation:Start(timer9)
	self:ScheduleMethod(timer9-5, "preDTranslocation")
	self:ScheduleMethod(timer9, "alertDTranslocation")
	self:ScheduleMethod(timer9, "kickThisCunt")
	self:ScheduleMethod(timer9, "xSarturaCast")
end

function mod:xSarturaCast()
	local timer10 = 25 
	timerSColossus:Start(timer10)
	timerStacks:Start()
	self:ScheduleMethod(timer10-5, "preSColossus")
	self:ScheduleMethod(timer10, "alertSColossus")
	self:ScheduleMethod(timer10-2, "runBitch")
	self:ScheduleMethod(timer10, "xiSarturaCast")
end

function mod:xiSarturaCast()
	local timer11 = 25
	timerSongRemaining:Start()
	timerDHaste:Start(timer11)
	self:ScheduleMethod(timer11-5, "preDHaste")
	self:ScheduleMethod(timer11, "alertDHaste")
	self:ScheduleMethod(timer11, "xiiSarturaCast")
end

function mod:xiiSarturaCast()
	local timer12 = 25
	timerDanceRemaining:Start()
	timerSOppression:Start(timer12)
	self:ScheduleMethod(timer12-5, "preSOppression")
	self:ScheduleMethod(timer12, "alertSOppression")
	self:ScheduleMethod(timer12, "kickThisCunt")
	self:ScheduleMethod(timer12, "xiiiSarturaCast")
end

function mod:xiiiSarturaCast()
	local timer13 = 25
	timerDHunt:Start(timer13)
	self:ScheduleMethod(timer13-5, "preDHunt")
	self:ScheduleMethod(timer13, "alertDHunt")
	self:ScheduleMethod(timer13, "kickThisCunt")
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------