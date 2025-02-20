-- SPDX-License-Identifier: GPL-3.0-or-later

--- Skill用来描述一个技能。
---
---@class Skill : Object
---@field public name string @ 技能名
---@field public trueName string @ 技能真名
---@field public package Package @ 技能所属的包
---@field public frequency? Frequency @ 技能标签，如compulsory（锁定技）、limited（限定技）。（deprecated，请改为向skeleton添加tag）
---@field public visible boolean @ 技能是否会显示在游戏中
---@field public mute boolean @ 决定是否关闭技能配音
---@field public no_indicate boolean @ 决定是否关闭技能指示线
---@field public global boolean @ 决定是否是全局技能
---@field public anim_type string|AnimationType @ 技能类型定义
---@field public related_skills Skill[] @ 和本技能相关的其他技能，有时候一个技能实际上是通过好几个技能拼接而实现的。
---@field public attached_equip string @ 属于什么装备的技能？
---@field public relate_to_place string| "m" | "d" @ 主将技("m")/副将技("d")
---@field public times integer @ 技能剩余次数，负数不显示，正数显示
---@field public attached_skill_name string @ 给其他角色添加技能的名称
---@field public main_skill Skill
---@field public cardSkill boolean @ 是否为卡牌效果对应的技能（仅用于ActiveSkill）
local Skill = class("Skill")

---@alias Frequency string

Skill.NotFrequent = "NotFrequent"
Skill.Lord = "Lord"
Skill.Compulsory = "Compulsory"
Skill.Limited = "Limited"
Skill.Wake = "Wake"
Skill.Switch = "Switch"
Skill.Quest = "Quest"
Skill.Permanent = "Permanent"

--- 构造函数，不可随意调用。
---@param name string @ 技能名
function Skill:initialize(name, frequency)
  -- TODO: visible, lord, etc
  self.name = name
  -- skill's package is assigned when calling General:addSkill
  -- if you need skills that not belongs to any general (like 'jixi')
  -- then you should use general function addRelatedSkill to assign them
  self.package = { extensionName = "standard" }
  self.visible = true
  self.mute = false
  self.no_indicate = false
  self.anim_type = ""
  self.related_skills = {}
  self._extra_data = {}

  self.attached_skill_name = nil

  --TODO: 以下是应当移到skeleton的参数
  self.attachedKingdom = {}
  self.cardSkill = false
  local name_splited = self.name:split("__")
  self.trueName = name_splited[#name_splited]
  if string.sub(name, 1, 1) == "#" then
    self.visible = false
  end
  self.attached_equip = nil
  self.relate_to_place = "m"

  self.frequency = self.frequency or Skill.NotFrequent
end

function Skill:__index(k)
  if k == "cost_data" then
    return Fk:currentRoom().skill_costs[self.name]
  else
    return self._extra_data[k]
  end
end

function Skill:__newindex(k, v)
  if k == "cost_data" then
    Fk:currentRoom().skill_costs[self.name] = v
  else
    rawset(self, k, v)
  end
end

function Skill:__tostring()
  return "<Skill " .. self.name .. ">"
end

--- 为一个技能增加相关技能。
---@param skill Skill @ 技能
function Skill:addRelatedSkill(skill)
  table.insert(self.related_skills, skill)
  Fk.related_skills[self.name] = Fk.related_skills[self.name] or {}
  table.insert(Fk.related_skills[self.name], skill)
end

--- 确认本技能是否为装备技能。
---@param player Player
---@return boolean
function Skill:isEquipmentSkill(player)
  if player then
    local filterSkills = Fk:currentRoom().status_skills[FilterSkill] or Util.DummyTable
    for _, filter in ipairs(filterSkills) do
      local result = filter:equipSkillFilter(self, player)
      if result then
        return true
      end
    end
  end

  return self:getSkeleton() ~= nil and type(self:getSkeleton().attached_equip) == "string"
end

--- 判断技能是不是对于某玩家而言失效了。
---
--- 它影响的是hasSkill，但也可以单独拿出来判断。
---@param player Player @ 玩家
---@return boolean
function Skill:isEffectable(player)
  if self.cardSkill or self:hasTag(Skill.Permanent) then
    return true
  end

  local nullifySkills = Fk:currentRoom().status_skills[InvaliditySkill] or Util.DummyTable
  for _, nullifySkill in ipairs(nullifySkills) do
    if self.name ~= nullifySkill.name and nullifySkill:getInvalidity(player, self) then
      return false
    end
  end

  for mark, value in pairs(player.mark) do -- 耦合 MarkEnum.InvalidSkills ！
    if mark == MarkEnum.InvalidSkills then
      if table.contains(value, self.name) then
        return false
      end
    elseif mark:startsWith(MarkEnum.InvalidSkills .. "-") and table.contains(value, self.name) then
      for _, suffix in ipairs(MarkEnum.TempMarkSuffix) do
        if mark:find(suffix, 1, true) then
          return false
        end
      end
    end
  end

  return true
end

--[[
--- 为技能增加所属势力，需要在隶属特定势力时才能使用此技能。
--- 案例：手杀文鸯
function Skill:addAttachedKingdom(kingdom)
  table.insertIfNeed(self.attachedKingdom, kingdom)
end
--]]

--判断技能是否为角色技能
---@param player Player
---@return boolean
function Skill:isPlayerSkill(player)
  local skel = self:getSkeleton()
  if skel == nil then return false end
  return not (self:isEquipmentSkill(player) or self.name:endsWith("&"))
end

---@return integer
function Skill:getTimes(player)
  local ret = self.times
  if not ret then
    return -1
  elseif type(ret) == "function" then
    ret = ret(self, player)
  end
  return ret
end

---@param player Player
---@param lang? string
---@return string?
function Skill:getDynamicDescription(player, lang)
  if self:hasTag(Skill.Switch) then
    local skill_name = self:getSkeleton().name
    local switchState = player:getSwitchSkillState(skill_name)
    local descKey = ":" .. skill_name .. (switchState == fk.SwitchYang and "_yang" or "_yin")
    local translation = Fk:translate(descKey, lang)
    if translation ~= descKey then
      return translation
    end
  end

  return nil
end

--- 找到效果的技能骨架。可能为nil
---@return SkillSkeleton?
function Skill:getSkeleton()
  for _, skel in pairs(Fk.skill_skels) do
    if table.contains(skel.effects, self) then
      return skel
    end
  end
  --[[if Fk.skill_skels[self.name] then
    return Fk.skill_skels[self.name]
  else
    for _, skel in pairs(Fk.skill_skels) do
      if table.contains(skel.effect_names, self.name) then
        return skel
      end
    end
  end--]]
  return nil
end

--- 判断技能是否有某标签
---@param frequency Frequency  待判断的标签
---@param compulsory_expand boolean?  是否“拓展”锁定技标签的含义，包括觉醒技。默认是
---@return boolean
function Skill:hasTag(frequency, compulsory_expand)
  local skel = self:getSkeleton()
  if skel == nil then return false end
  if (compulsory_expand == nil or compulsory_expand) and frequency == Skill.Compulsory then
    if table.contains({Skill.Compulsory, Skill.Wake}, self.frequency) then  --兼容牢代码
      return true
    end
    return table.contains(skel.tags, Skill.Compulsory) or table.contains(skel.tags, Skill.Wake)
  end
  if self.frequency == frequency then  --兼容牢代码
    return true
  end
  return table.contains(skel.tags, frequency)
end

return Skill
