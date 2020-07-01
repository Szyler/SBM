local mod	= DBM:NewMod("Thaddius", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(15928)
mod:RegisterCombat("yell", L.Yell)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_CAST_START",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_AURA",
	"PLAYER_ALIVE"
)
-----POLARITY SHIFT-----
local timerShiftCast		= mod:NewCastTimer(3, 28089)
local timerNextShift		= mod:NewNextTimer(30, 28089)
local warnShiftCasting		= mod:NewCastAnnounce(28089, 3)
-----THROW-----
local warnThrow				= mod:NewSpellAnnounce(28338, 2)
local warnThrowSoon			= mod:NewSoonAnnounce(28338, 1)
local timerThrow			= mod:NewNextTimer(20.6, 28338)
-----Static Overload-----
local warnStaticPrimer		= mod:NewSpecialWarning("WarnStaticPrimer")
local timerStaticPrimer		= mod:NewTargetTimer(3, 1003130)
local warnStaticOverload	= mod:NewSpecialWarning("WarningStaticOverload")
local timerStaticOverload	= mod:NewTargetTimer(5, 1003130)
-----MISC-----
local warnChargeChanged		= mod:NewSpecialWarning("WarningChargeChanged")
local warnChargeNotChanged	= mod:NewSpecialWarning("WarningChargeNotChanged", false)
local enrageTimer			= mod:NewBerserkTimer(365)
mod:AddBoolOption("ArrowsEnabled", false, "Arrows")
mod:AddBoolOption("ArrowsRightLeft", false, "Arrows")
mod:AddBoolOption("ArrowsInverse", false, "Arrows")
mod:AddBoolOption("ArrowsGoToSide", false, "Arrows")
mod:AddBoolOption("HealthFrame", true)
mod:SetBossHealthInfo(
	15930, L.Boss1,
	15929, L.Boss2
)
local currentCharge
local phase2
local down = 0

mod:AddBoolOption("SetIconOnStaticOverloadTarget", true)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	enrageTimer:Start(-delay)
	phase2 = false
	currentCharge = nil
	down = 0
	-- self:ScheduleMethod(20.6 - delay, "TankThrow")
	-- timerThrow:Start(-delay)
	-- warnThrowSoon:Schedule(17.6 - delay)
end

local lastShift = 0
function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28089) then
		phase2 = true
		timerNextShift:Start()
		timerShiftCast:Start()
		warnShiftCasting:Show()
		lastShift = GetTime()
	end
end

function mod:UNIT_AURA(elapsed)
	if not phase2 then return end
	local charge
	local i = 1
	while UnitDebuff("player", i) do
		local _, _, icon, count = UnitDebuff("player", i)
		if icon == "Interface\\Icons\\Spell_ChargeNegative" then
			if count > 1 then return end
			charge = L.Charge1
		elseif icon == "Interface\\Icons\\Spell_ChargePositive" then
			if count > 1 then return end
			charge = L.Charge2
		end
		i = i + 1
	end
	if charge then
		lastShift = 0
		if charge == currentCharge then
			warnChargeNotChanged:Show()
			if self.Options.ArrowsEnabled and self.Options.ArrowsRightLeft then
				if self.Options.ArrowsInverse then
					self:ShowLeftArrow()
				else
					self:ShowRightArrow()
				end
			end
		else
			warnChargeChanged:Show(charge)
			if self.Options.ArrowsEnabled and self.Options.ArrowsGoToSide then
				if charge == L.Charge1 or (charge == L.Charge2 and self.Options.ArrowsInverse) then
					self:ShowLeftArrow()
				elseif charge == L.Charge2 or (charge == L.Charge1 and self.Options.ArrowsInverse)  then
					self:ShowRightArrow()
				end
			elseif self.Options.ArrowsEnabled then
				if self.Options.ArrowsRightLeft and self.Options.ArrowsInverse then
					self:ShowRightArrow()
				elseif self.Options.ArrowsRightLeft then
					self:ShowLeftArrow()
				elseif currentCharge then
					self:ShowUpArrow()
				end
			end
		end
		currentCharge = charge
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1003130) then
		warnStaticPrimer:Show(args.destName)
		timerStaticOverload:Schedule(3)
		timerStaticPrimer:Start(args.destName)
		if self.Options.SetIconOnStaticOverloadTarget then
			self:SetIcon(args.destName, 8, 8)
		end
	end
end


-- function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
-- 	if msg == L.Emote or msg == L.Emote2 then
-- 		down = down + 1
-- 		if down >= 2 then
-- 			-- self:UnscheduleMethod("TankThrow")
-- 			timerThrow:Cancel()
-- 			warnThrowSoon:Cancel()
-- 			DBM.BossHealth:Hide()
-- 			enrageTimer:Start()
-- 		end
-- 	end
-- end

-- function mod:TankThrow() --- Not currently working on Ascension
-- 	if not self:IsInCombat() or phase2 then
-- 		DBM.BossHealth:Hide()
-- 		return
-- 	end
-- 	timerThrow:Start()
-- 	warnThrowSoon:Schedule(17.6)
-- 	self:ScheduleMethod(20.6, "TankThrow")
-- end

local function arrowOnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 3.5 and self.elapsed < 4.5 then
		self:SetAlpha(4.5 - self.elapsed)
	elseif self.elapsed >= 4.5 then
		self:Hide()
	end
end

local function arrowOnShow(self)
	self.elapsed = 0
	self:SetAlpha(1)
end

local arrowLeft = CreateFrame("Frame", nil, UIParent)
arrowLeft:Hide()
local arrowLeftTexture = arrowLeft:CreateTexture(nil, "BACKGROUND")
arrowLeftTexture:SetTexture("Interface\\AddOns\\DBM-Naxx\\ConstructQuarter\\Textures\\arrow")
arrowLeftTexture:SetPoint("CENTER", arrowLeft, "CENTER")
arrowLeft:SetHeight(1)
arrowLeft:SetWidth(1)
arrowLeft:SetPoint("CENTER", UIParent, "CENTER", -150, -30)
arrowLeft:SetScript("OnShow", arrowOnShow)
arrowLeft:SetScript("OnUpdate", arrowOnUpdate)

local arrowRight = CreateFrame("Frame", nil, UIParent)
arrowRight:Hide()
local arrowRightTexture = arrowRight:CreateTexture(nil, "BACKGROUND")
arrowRightTexture:SetTexture("Interface\\AddOns\\DBM-Naxx\\ConstructQuarter\\Textures\\arrow")
arrowRightTexture:SetPoint("CENTER", arrowRight, "CENTER")
arrowRightTexture:SetTexCoord(1, 0, 0, 1)
arrowRight:SetHeight(1)
arrowRight:SetWidth(1)
arrowRight:SetPoint("CENTER", UIParent, "CENTER", 150, -30)
arrowRight:SetScript("OnShow", arrowOnShow)
arrowRight:SetScript("OnUpdate", arrowOnUpdate)

local arrowUp = CreateFrame("Frame", nil, UIParent)
arrowUp:Hide()
local arrowUpTexture = arrowUp:CreateTexture(nil, "BACKGROUND")
arrowUpTexture:SetTexture("Interface\\AddOns\\DBM-Naxx\\ConstructQuarter\\Textures\\arrow")
arrowUpTexture:SetRotation(math.pi * 3 / 2)
arrowUpTexture:SetPoint("CENTER", arrowUp, "CENTER")
arrowUp:SetHeight(1)
arrowUp:SetWidth(1)
arrowUp:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
arrowUp:SetScript("OnShow", arrowOnShow)
arrowUp:SetScript("OnUpdate", arrowOnUpdate)

function mod:ShowRightArrow()
	arrowRight:Show()
end

function mod:ShowLeftArrow()
	arrowLeft:Show()
end

function mod:ShowUpArrow()
	arrowUp:Show()
end

-----SBM GLOBAL FUNCTIONS-----
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
-----SBM GLOBAL FUNCTIONS-----