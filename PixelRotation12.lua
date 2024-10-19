


local f = CreateFrame("Frame", nil, UIParent)
--f:SetPoint("CENTER")
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0) -- 设置到左上角
f:SetSize(64, 64)

f.tex = f:CreateTexture()
f.tex:SetAllPoints()
--f.tex:SetColorTexture(0, 0, 0, 1)

local textBox = CreateFrame("Frame", nil, UIParent)
textBox:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, 0) -- 放置在图标右侧
textBox:SetSize(256, 64)
local text = textBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("LEFT", textBox, "LEFT", 0, 0)
text:SetFont("Fonts\\FRIZQT__.TTF", 32, nil)
--text:SetText("这是一个文本框")
f:RegisterEvent("UNIT_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_ENTER_COMBAT")

f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_STARTED_MOVING")
f:RegisterEvent("PLAYER_STOPPED_MOVING")
f:RegisterEvent("PLAYER_TOTEM_UPDATE")
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("UNIT_SPELLCAST_START")
f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:RegisterEvent("UNIT_SPELLCAST_FAILED")
f:RegisterEvent("UNIT_SPELLCAST_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
f:RegisterEvent("UNIT_POWER_UPDATE")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
f:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
f:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterUnitEvent("TRAIT_CONFIG_UPDATED")
f:RegisterUnitEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("LOADING_SCREEN_ENABLED")
f:RegisterEvent("LOADING_SCREEN_DISABLED")
--local last_title = 0

function SetFrameColorByTitle(title)

    if last_title == title then
      return
    end
    last_title = title

  if (title == "空白") then
    f.tex:SetColorTexture(1, 1, 1, 1)
    text:SetText("空白")
    return
  end

  if (title == "正义盾击") then
    f.tex:SetColorTexture(0, 0, 0.5, 1)
    text:SetText("正义盾击")
    return
  end

  if (title == "祝福之锤") then
    f.tex:SetColorTexture(0, 0, 1, 1)
    text:SetText("祝福之锤")
    return
  end

  if (title == "复仇者之盾") then
    f.tex:SetColorTexture(0, 0.5, 0, 1)
    text:SetText("复仇者之盾")
    return
  end

  if (title == "奉献") then
    f.tex:SetColorTexture(0, 0.5, 0.5, 1)
    text:SetText("奉献")
    return
  end

  if (title == "愤怒之锤") then
    f.tex:SetColorTexture(0, 0.5, 1, 1)
    text:SetText("愤怒之锤")
    return
  end
  if (title == "荣耀圣令") then
    f.tex:SetColorTexture(0, 1, 0, 1)
    text:SetText("荣耀圣令")
    return
  end
  if (title == "审判") then
    f.tex:SetColorTexture(0, 1, 0.5, 1)
    text:SetText("审判")
    return
  end
end

--
-- /script SetFrameColorByTitle("停手")

local function GetPlayerAuraCount(spellID)
  local data = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
  local count 
  if data then
      count = data.applications
  else
    -- 如果是nil，那就是无buff，返回0。
     return 0
  end
  -- 如果是0层，他们可能没有层数设置。
  if data.applications == 0 then
    count = 1
  end
  
  -- 如果坚持不到下一个gcd结束，则是0
  local spellCooldownInfo = C_Spell.GetSpellCooldown(61304)
  if spellCooldownInfo then
    if  (data.expirationTime > 0) and (data.expirationTime < spellCooldownInfo.startTime + spellCooldownInfo.duration) then
        count = 0
    end
  end
      
  return count
  
end --GetPlayerAuraCount


local function are3EnemiesInRange()
    local inRange, unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and C_Spell.IsSpellInRange(32321, unitID) then
            inRange = inRange + 1
            if inRange >= 3 then return true end
        end
    end
end

local function are5EnemiesInRange()
    local inRange, unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and C_Spell.IsSpellInRange(853, unitID) then
            inRange = inRange + 1
            if inRange >= 5 then return true end
        end
    end
end

local function AnyEnemiesInRange()
    local unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and C_Spell.IsSpellInRange(853, unitID) then
            return true
        end
    end
end


-- 80%减伤清单
function get80DamageReduction()
  local damage_spell_list = {
    320655,   --通灵 凋骨
    424888,   -- 宝库 老1
    428711,   -- 宝库 老3
    434722,   -- 千丝 老1
    441298,   -- 千丝 老2
    461842,   -- 千丝 老3
    447261,   -- 拖把 老1
    449444,   -- 拖把 老2
    450100,   -- 拖把 老4
    453212,   -- 破晨 老1
    427001,   -- 破晨 老2
    438471,   -- 回响 老1
    8690           -- 炉石
  }
  local _, _, _, _, _, _, _, _, target_spellId = UnitCastingInfo("target")

  if target_spellId == nil then
    return false
  end

  for _, v in ipairs(damage_spell_list) do
    if v == target_spellId then
      return true
    end
  end
  return false

end

--详细说明
--lastExecutionTime：记录上次函数执行的时间，初始化为0。
--cooldown：设置函数的调用冷却时间为0.2秒。
--GetTime()：获取当前游戏时间，从游戏启动到现在的秒数。
--ProtectedFunction()：
--获取当前时间currentTime。
--检查当前时间与上次执行时间lastExecutionTime的差异。如果差异小于冷却时间0.2秒，则直接返回，不执行函数。
--如果差异大于或等于冷却时间，更新上次执行时间lastExecutionTime为当前时间currentTime。
--执行函数的实际内容。

local lastExecutionTime = 0
local cooldown = 0.1


function DoPixelRotation()
   ----获取当前时间
   -- local currentTime = GetTime()
   --
   -- -- 检查当前时间与上次执行时间的差异
   -- if currentTime - lastExecutionTime < cooldown then
   --     -- 如果差异小于0.2秒，直接返回，不执行函数
   --     return
   -- end
   --
   -- -- 更新上次执行时间
   -- lastExecutionTime = currentTime


  -- 如果不在战斗，则stop
  if not UnitAffectingCombat("player") then
    return SetFrameColorByTitle("空白")
  end

  -- 神圣能量
  local holy_power = UnitPower("player", Enum.PowerType.HolyPower)

  -- 近战有敌人

  local any_enemies_in_range = AnyEnemiesInRange()


  -- 正义盾击buff 132403
  local aura_132403 = C_UnitAuras.GetPlayerAuraBySpellID(132403)

  -- 审判 275779
  local chargeInfo_275779 = C_Spell.GetSpellCharges(275779)

  -- 祝福之锤 204019
  local chargeInfo_204019 = C_Spell.GetSpellCharges(204019)

  -- 复仇者之盾 31935
  local spellCooldownInfo_31935 = C_Spell.GetSpellCooldown(31935)

  -- 奉献
  local aura_188370 = C_UnitAuras.GetPlayerAuraBySpellID(188370)
  local spellCooldownInfo_26573 = C_Spell.GetSpellCooldown(26573)

  --愤怒之锤 24275
  local usable_24275,_ =  C_Spell.IsSpellUsable(24275)
  local spellCooldownInfo_24275 = C_Spell.GetSpellCooldown(24275)

  -- 闪耀之光 327510
  local aura_327510 = C_UnitAuras.GetPlayerAuraBySpellID(327510)

  ------------------------------------------------------------------
  ---------            基础覆盖                                     ----
  ------------------------------------------------------------------


  -- 如果近战范围有敌人
  -- 如果神圣能量>3
  -- 如果没有盾击覆盖，则打盾击
  --print(holy_power)
  if any_enemies_in_range then
    if holy_power >= 3 then
      if not aura_132403 then
        return SetFrameColorByTitle("正义盾击")
      end
    end
  end

  -- 如果没有奉献buff 188370
  -- 如果奉献在冷却 26573
  -- 则释放奉献
  if not aura_188370 then
    if spellCooldownInfo_26573.duration == 0 then
      return SetFrameColorByTitle("奉献")
    end
  end

  ------------------------------------------------------------------
  ---------            减伤   和打断                              ----
  ------------------------------------------------------------------

  -- 血量低于80%，存在闪耀之光buff 327510，则释放荣耀圣令


  if ( UnitHealth("player")/UnitHealthMax("player")) < 0.8 then

    if aura_327510 then
      return SetFrameColorByTitle("荣耀圣令")
    end
  end


  ------------------------------------------------------------------
  ---------            拉怪区域                                  ----
  ------------------------------------------------------------------

  -- 如果神圣能量小于5
  -- 如果愤怒支持可用24275
  -- 如果距离内
  -- 则释放愤怒之锤
  if holy_power < 5 then
    if usable_24275 then
      if spellCooldownInfo_24275.duration == 0 then
        if C_Spell.IsSpellInRange(24275, "target") then
          return SetFrameColorByTitle("愤怒之锤")
        end
      end
    end
  end

  -- 如果神圣能量小于5
  -- 且：审判在CD
  -- 且：在施法范围
  -- 则打审判275779。
  if holy_power < 5 then
    if C_Spell.IsSpellInRange(275779, "target") then
      if chargeInfo_275779.currentCharges >= 1 then
        return SetFrameColorByTitle("审判")
      end
    end
  end


  -- 如果神圣能量小于5
  -- 且：祝福之锤在CD
  -- 则打祝福之锤 204019。
  if holy_power < 5 then
    if chargeInfo_204019.currentCharges >= 1 then
      return SetFrameColorByTitle("祝福之锤")
    end
  end

  -- 如果复仇之之盾冷却好
  -- 在施法范围内
  -- 释放复仇者之盾31935
  if (spellCooldownInfo_31935.duration == 0)  then
    if C_Spell.IsSpellInRange(31935, "target") then
      return SetFrameColorByTitle("复仇者之盾")
    end
  end



  return SetFrameColorByTitle("空白")
end -- DoPixelRotation


f:SetScript("OnEvent", function() DoPixelRotation() end)
