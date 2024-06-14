-- SPDX-License-Identifier: GPL-3.0-or-later

---@class TargetModSkill : StatusSkill
local TargetModSkill = StatusSkill:subclass("TargetModSkill")

---判断是否跳过次数限制考察
---@param player? Player @ 使用者
---@param card_skill? ActiveSkill @ 卡牌技能
---@param scope? integer @ 考察范围
---@param card? Card @ 卡
---@param to? Player @ 目标
---@return bool
function TargetModSkill:bypassTimesCheck(player, card_skill, scope, card, to)
  return false
end

---为原有次数限制增加对应数量的修正值
---@param player? Player @ 使用者
---@param card_skill? ActiveSkill @ 卡牌技能
---@param scope? integer @ 考察范围
---@param card? Card @ 卡
---@param to? Player @ 目标
---@return number? @ 修正值
function TargetModSkill:getResidueNum(player, card_skill, scope, card, to)
  return 0
end

---判断是否跳过距离限制考察
---@param player? Player @ 使用者
---@param card_skill? ActiveSkill @ 卡牌技能
---@param card? Card @ 卡
---@param to? Player @ 目标
---@return bool
function TargetModSkill:bypassDistancesCheck(player, card_skill, card, to)
  return false
end

---为原有距离限制增加对应数量的修正值
---@param player? Player @ 使用者
---@param card_skill? ActiveSkill @ 卡牌技能
---@param card? Card @ 卡
---@param to? Player @ 目标
---@return number? @ 修正值
function TargetModSkill:getDistanceLimit(player, card_skill, card, to)
  return 0
end

---增加可选择的目标数
---@param player? Player @ 使用者
---@param card_skill? ActiveSkill @ 卡牌技能
---@param card? Card @ 卡
---@return number? @ 修正值
function TargetModSkill:getExtraTargetNum(player, card_skill, card)
  return 0
end

---强制预先选择对应目标
---@param player? Player @ 使用者
---@param card_skill? ActiveSkill @ 卡牌技能
---@param card? Card @ 卡
---@return integer[]? @ 预选目标
function TargetModSkill:getPreselected(player, card_skill, card)
  return {}
end

return TargetModSkill
