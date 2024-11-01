--- 阉割版GameEvent: 专用于AI进行简单的收益推理。
---
--- 事件首先需要定义自己对于某某玩家的基础收益值，例如伤害事件对目标造成-200的
--- 收益。事件还要定义自己包含的触发时机列表，根据时机列表考虑相关技能对本次
--- 事件的收益修正，最终获得真正的收益值。
---
--- 事件用于即将选卡/选目标时，或者触发技AI思考自己对某事件影响时构造并计算收益，
--- 因此很容易发生事件嵌套现象。为防止AI思考过久，必须对事件嵌套层数加以限制，
--- 比如限制最多思考到两层嵌套；毕竟没算力只能让AI蠢点了
---@class AIGameEvent: Object
---@field public ai SmartAI
---@field public player ServerPlayer
---@field public data any
local AIGameEvent = class("AIGameEvent")

---@param ai SmartAI
function AIGameEvent:initialize(ai, ...)
  self.ai = ai
  self.player = ai.player
  self.data = { ... }
end

-- 真正的收益计算函数：子类重写这个
function AIGameEvent:exec()
  return 0
end

local _depth = 0

-- 用做API的收益计算函数，不要重写
function AIGameEvent:getBenefit()
  local ret
  _depth = _depth + 1
  if _depth <= 8 then
    ret = self:exec()
  else
    ret = 0
  end
  _depth = _depth - 1
  return ret
end

-- hp.lua

local ChangeHp = AIGameEvent:subclass("AIGameEvent.ChangeHp")
fk.ai_events.ChangeHp = ChangeHp
function ChangeHp:exec()
  local ret = 0
  local val, exit
  local ai = self.ai
  local player, num, reason, skillName, damageStruct = table.unpack(self.data)
  ---@type HpChangedData
  local data = {
    num = num,
    reason = reason,
    skillName = skillName,
    damageEvent = damageStruct,
  }

  val, exit = ai:getTriggerBenefit(fk.BeforeHpChanged, player, data)
  ret = ret + val
  if exit then return ret, exit end

  val = 200 * data.num
  if ai:isEnemy(player) then val = -val end
  ret = ret + val

  val = ai:getTriggerBenefit(fk.BeforeHpChanged, player, data)
  ret = ret + val

  return ret
end

local Damage = AIGameEvent:subclass("AIGameEvent.Damage")
fk.ai_events.Damage = Damage
function Damage:exec()
  local ret = 0
  local val, exit
  local ai = self.ai
  local damageStruct = table.unpack(self.data)
  if (not damageStruct.chain) and (not damageStruct.chain_table) and Fk:canChain(damageStruct.damageType) then
    damageStruct.chain_table = table.filter(ai.room:getOtherPlayers(damageStruct.to), function(p)
      return p.chained
    end)
  end

  local stages = {}
  if not damageStruct.isVirtualDMG then
    stages = {
      { fk.PreDamage, "from"},
      { fk.DamageCaused, "from" },
      { fk.DamageInflicted, "to" },
    }
  end

  for _, struct in ipairs(stages) do
    local event, player = table.unpack(struct)
    val, exit = ai:getTriggerBenefit(event, damageStruct[player], damageStruct)
    if damageStruct.damage < 1 then exit = true end
    ret = ret + val
    if exit then return ret, exit end
  end

  val, exit = ChangeHp:new(ai, damageStruct.to, -damageStruct.damage,
    "damage", damageStruct.skillName, damageStruct):getBenefit()
  ret = ret + val
  if exit then return ret, exit end

  ret = ret + ai:getTriggerBenefit(fk.Damage, damageStruct.from, damageStruct)
  ret = ret + ai:getTriggerBenefit(fk.Damaged, damageStruct.to, damageStruct)
  ret = ret + ai:getTriggerBenefit(fk.DamageFinished, damageStruct.to, damageStruct)

  if damageStruct.chain_table and #damageStruct.chain_table > 0 then
    for _, p in ipairs(damageStruct.chain_table) do
      local dmg = {
        from = damageStruct.from,
        to = p,
        damage = damageStruct.damage,
        damageType = damageStruct.damageType,
        card = damageStruct.card,
        skillName = damageStruct.skillName,
        chain = true,
      }

      ret = ret + Damage:new(dmg):getBenefit()
    end
  end

  return ret
end

-- TODO: losehp, recover, changeMaxHp

-- skill.lua

local SkillEffect = AIGameEvent:subclass("AIGameEvent.SkillEffect")
fk.ai_events.SkillEffect = SkillEffect
function SkillEffect:exec()
  local ret = 0
  local ai = self.ai
  local player, skill, skill_data = table.unpack(self.data)
  local main_skill = skill.main_skill and skill.main_skill or skill

  ret = ret + ai:getTriggerBenefit(fk.SkillEffect, player, main_skill)

  local skill_ai = fk.ai_skills[skill.name]
  ret = ret + (skill_ai:getEffectBenefit() or 0)

  ret = ret + ai:getTriggerBenefit(fk.AfterSkillEffect, player, main_skill)

  return ret
end

-- movecard.lua


-- usecard.lua

local UseCard = AIGameEvent:subclass("AIGameEvent.UseCard")
fk.ai_events.UseCard = UseCard
function UseCard:exec()
  local ret = 0
  local val, exit
  local ai = self.ai
  local room = ai.room
  local cardUseEvent = table.unpack(self.data)

  val, exit = ai:getTriggerBenefit(fk.PreCardUse, room:getPlayerById(cardUseEvent.from), cardUseEvent)
  ret = ret + val
  if exit then return ret, exit end

  return ret
end

return AIGameEvent
