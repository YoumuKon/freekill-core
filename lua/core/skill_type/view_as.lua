-- SPDX-License-Identifier: GPL-3.0-or-later

---@class ViewAsSkill : UsableSkill
---@field public pattern string @ cards that can be viewAs'ed by this skill
---@field public interaction any
---@field public handly_pile boolean? @ 能否选择“如手牌般使用或打出”的牌
local ViewAsSkill = UsableSkill:subclass("ViewAsSkill")

function ViewAsSkill:initialize(name, frequency)
  UsableSkill.initialize(self, name, frequency)
  self.pattern = ""
end

---@param to_select integer @ id of a card not selected
---@param selected integer[] @ ids of selected cards
---@param player Player @ the user
---@return boolean
function ViewAsSkill:cardFilter(to_select, selected, player)
  return false
end

---@param cards integer[] @ ids of cards
---@param player Player @ the user
---@return Card?
function ViewAsSkill:viewAs(cards, player)
  return nil
end

-- For extra judgement, like mark or HP

---@param player Player
function ViewAsSkill:enabledAtPlay(player)
  return self:isEffectable(player)
end

---@param player Player
function ViewAsSkill:enabledAtResponse(player, cardResponsing)
  return self:isEffectable(player)
end

---@param player Player
---@param cardUseStruct CardUseStruct
function ViewAsSkill:beforeUse(player, cardUseStruct) end

---@param player Player
---@param cardUseStruct CardUseStruct
function ViewAsSkill:afterUse(player, cardUseStruct) end

---@param selected_cards integer[] @ ids of selected cards
---@param selected_targets integer[] @ ids of selected players
function ViewAsSkill:prompt(selected_cards, selected_targets) return "" end

return ViewAsSkill
