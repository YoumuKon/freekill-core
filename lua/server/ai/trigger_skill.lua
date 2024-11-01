
--- 关于某个触发技在AI中如何影响基于事件的收益推理。
---
--- 类似于真正的触发技，这种技能AI也需要指定触发时机，以及在某个时机之下
--- 如何进行收益计算。收益计算中亦可返回true，表明事件被这个技能终止，
--- 也就是不再进行后续其他技能的计算。
---
--- 触发技本身又会不断触发新的事件，比如刚烈反伤、反馈拿牌等。对于衍生事件
--- 亦可进一步进行推理，但是AI会限制自己的搜索深度，所以推理结果不一定准确。
---@class TriggerSkillAI
---@field public skill Skill
---@field public ai SmartAI
local TriggerSkillAI = class("TriggerSkillAI")

function TriggerSkillAI:getCorrect(event, target, player, data)
  return 0
end

return TriggerSkillAI
