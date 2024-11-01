--- 关于某个技能如何在AI中处理。
---
--- 相关方法分为三类，分别是如何搜索、如何计算收益、如何进行收益推理
---
--- 所谓搜索，就是如何确定下一步该选择哪张卡牌/哪名角色等。
--- 默认情况下，AI选择收益最高的选项作为下一步，如果遇到了死胡同就返回考虑下一种。
--- 所谓死胡同就是什么都不能点击，也不能点确定的状态，必须取消某些的选择。
---
--- 所谓的收益计算就是估算这个选项在这个技能的语境下，他大概会带来多少收益。
--- 限于算力，我们不能编写太复杂的收益计算。默认情况下，收益可以通过推理完成，
--- 而推理的步骤需要Modder向AI给出提示。
---
--- 所谓的给出提示就是上面的“如何进行收益推理”。拓展可以针对点击某张卡牌或者
--- 点击某个角色，告诉AI这么点击了可能会发生某种事件。AI根据事件以及游戏内包含的
--- 其他技能进行计算，得出收益值。若不想让它这样计算，也可以在上一步直接指定
--- 固定的收益值。
---
--- 所谓的“可能发生某种事件”大致类似GameEvent，但是内部功能大幅简化了（因为
--- 只是用于简单的推理）。详见同文件夹下event.lua内容。
---@class SkillAI: Object
---@field public skill Skill
---@field public ai SmartAI
---@field public player ServerPlayer
local SkillAI = class("SkillAI")

---@param skill string
---@param ai SmartAI
function SkillAI:initialize(skill, ai)
  self.skill = Fk.skills[skill]
  self.ai = ai
  self.player = ai.player
end

-- 推理辅助类方法 用于预判

--- 对点击某牌可能发生的事件简单预判
---@param cid integer
---@return AIGameEvent|AIGameEvent[]|nil
---@diagnostic disable-next-line
function SkillAI:predictCardEvent(cid)
end

--- 对点击某角色可能发生的事件简单预判
---@param target ServerPlayer
---@return AIGameEvent|AIGameEvent[]|nil
---@diagnostic disable-next-line
function SkillAI:predictTargetEvent(target)
end

--- 对点击确定键可能发生的事件简单预判
---
--- 一般来说不用预判因为通过点牌和点角色已经算过好几轮了，
--- 除非是完全只有确定取消可点击的特殊场景
---@return AIGameEvent|AIGameEvent[]|nil
function SkillAI:predictOkEvent()
end

--- 对点击取消键可能发生的事件简单预判
---@return AIGameEvent|AIGameEvent[]|nil
function SkillAI:predictCancelEvent()
end

-- 收益类方法 一般预判已经够用

--- 获取一系列events对自身的收益数值

---@param events AIGameEvent|AIGameEvent[]|nil
function SkillAI:getEventsBenefit(events)
  if not events then return 0 end
  if events[1] then
    local ret = 0
    for _, e in ipairs(events) do
      ret = ret + e:getBenefit()
    end
    return ret
  else
    return events:getBenefit()
  end
end

function SkillAI:getCardBenefit(cid)
  local events = self:predictCardEvent(cid)
  return self:getEventsBenefit(events)
end

function SkillAI:getTargetBenefit(target)
  local events = self:predictTargetEvent(target)
  local ret = self:getEventsBenefit(events)
  printf("%s: 我是%s, 选择%s的收益值为%d", self.skill.name, tostring(self.player), tostring(target), ret)
  return ret
end

function SkillAI:getOkBenefit()
  local events = self:predictOkEvent()
  return self:getEventsBenefit(events)
end

function SkillAI:getCancelBenefit()
  local events = self:predictCancelEvent()
  return self:getEventsBenefit(events)
end

function SkillAI:getEffectBenefit()
  return 0
end

-- 搜索类方法：怎么走下一步？

function SkillAI:chooseCards()
  local ai = self.ai
  local cards = ai:getEnabledCards()
  local fn = function(cid) return self:getCardBenefit(cid) end
  for _, cid in fk.sorted_pairs(cards, fn) do
    ai:selectCard(cid, true)
    break
  end
end

function SkillAI:chooseTargets()
  local ai = self.ai
  local targets = ai:getEnabledTargets()
  local fn = function(target) return self:getTargetBenefit(target) end
  for _, p in fk.sorted_pairs(targets, fn) do
    if ai:okButtonEnabled() then
      return ai:doOKButton()
    end
    ai:selectTarget(p, true)
  end
end

-- 交给SmartAI的接口

function SkillAI:think()
  self:chooseCards()
  local ret = self:chooseTargets()
  return ret
end

--- 最后效仿一下fk_ex故事
---@class SkillAISpec
---@field choose_interaction? fun(self: SkillAI): boolean?
---@field choose_cards? fun(self: SkillAI): boolean?
---@field choose_targets? fun(self: SkillAI): any
---@field skill_invoke? boolean|fun(self: SkillAI): any
---@field ask_choice? fun(skill: ActiveSkill, ai: SmartAI, choices: string[], min?: integer, max?: integer): any
---@field base_benefit? integer|fun(self: SkillAI): integer
---@field interaction_benefit? fun(self: SkillAI, value: any): integer
---@field card_benefit? fun(self: SkillAI, cid: integer): integer
---@field target_benefit? fun(self: SkillAI, target: ServerPlayer): integer
---@field ok_benefit? fun(self: SkillAI): integer
---@field cancel_benefit? fun(self: SkillAI): integer
---@field card_predict? fun(self: SkillAI, cid: integer): AIGameEvent|AIGameEvent[]|nil
---@field target_predict? fun(self: SkillAI, target: ServerPlayer): AIGameEvent|AIGameEvent[]|nil
---@field ok_predict? fun(self: SkillAI): AIGameEvent|AIGameEvent[]|nil
---@field cancel_predict? fun(self: SkillAI): AIGameEvent|AIGameEvent[]|nil

return SkillAI
