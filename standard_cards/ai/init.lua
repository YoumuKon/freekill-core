SmartAI:setCardSkillAI("slash_skill", {
  estimated_benefit = 100,

  on_effect = function(self, logic, effect)
    self.skill:onEffect(logic, effect)
  end,
})

-- jink

SmartAI:setCardSkillAI("peach_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,
  on_effect = function(self, logic, effect)
    self.skill:onEffect(logic, effect)
  end,
})

SmartAI:setCardSkillAI("dismantlement_skill", {
  on_effect = function(self, logic, effect)
    local from = logic:getPlayerById(effect.from)
    local to = logic:getPlayerById(effect.to)
    if from.dead or to.dead or to:isAllNude() then return end
    -- local cid = logic:askForCardChosen(from, to, "hej", self.name)
    local cid = to:getCardIds("j")[1] or to:getCardIds("e")[1] or to:getCardIds("h")[1]
    logic:throwCard({cid}, self.skill.name, to, from)
  end,
})

SmartAI:setCardSkillAI("snatch_skill", {
  on_effect = function(self, logic, effect)
    local from = logic:getPlayerById(effect.from)
    local to = logic:getPlayerById(effect.to)
    if from.dead or to.dead or to:isAllNude() then return end
    -- local cid = logic:askForCardChosen(from, to, "hej", self.name)
    local cid = to:getCardIds("j")[1] or to:getCardIds("e")[1] or to:getCardIds("h")[1]
    logic:obtainCard(from, cid, false, fk.ReasonPrey)
  end,
})

-- duel
-- collateral_skill

SmartAI:setCardSkillAI("ex_nihilo_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,
  on_effect = function(self, logic, effect)
    local target = logic:getPlayerById(effect.to)
    logic:drawCards(target, 2, "ex_nihilo")
  end,
})

-- nullification

SmartAI:setCardSkillAI("savage_assault_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,
  on_effect = function(self, logic, effect)
    Fk.skills["slash_skill"]:onEffect(logic, effect)
  end,
})

SmartAI:setCardSkillAI("archery_attack_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,
  on_effect = function(self, logic, effect)
    Fk.skills["slash_skill"]:onEffect(logic, effect)
  end,
})

SmartAI:setCardSkillAI("god_salvation_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,
  on_effect = function(self, logic, effect)
    self.skill:onEffect(logic, effect)
  end,
})

-- amazing_grace_skill
-- lightning_skill

SmartAI:setCardSkillAI("indulgence_skill", {})

SmartAI:setCardSkillAI("default_equip_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,

  think = function(self, ai)
    local estimate_val = self:getEstimatedBenefit(ai)
    local cards = ai:getEnabledCards()
    cards = table.filter(cards, function(cid) return Fk:getCardById(cid).skill.name == "default_equip_skill" end)
    cards = table.random(cards, math.min(#cards, 5)) --[[@as integer[] ]]
    -- local cid = table.random(cards)

    local best_ret, best_val = nil, -100000
    for _, cid in ipairs(cards) do
      ai:selectCard(cid, true)
      local ret, val = self:chooseTargets(ai)
      val = val or -100000
      if not best_ret or (best_val < val) then
        best_ret, best_val = ret, val
      end
      if best_val >= estimate_val then break end
      ai:unSelectAll()
    end

    if best_ret then
      if best_val < 0 then
        return ""
      end

      best_ret = { card = ai:getSelectedCard().id, targets = best_ret }
    end

    return best_ret, best_val
  end,
})

SmartAI:setTriggerSkillAI("#nioh_shield_skill", {
  correct_func = function(self, logic, event, target, player, data)
    return self.skill:triggerable(event, target, player, data)
  end,
})

--[=====[
local just_use = {
  name = "__just_use",
  will_use = Util.TrueFunc,
  choose_targets = function(skill, ai, card)
    return ai:doOKButton()
  end,
}

local use_to_friend = {
  name = "__use_to_friend",
  will_use = Util.TrueFunc,
  choose_targets = function(skill, ai, card)
    local targets = ai:getEnabledTargets()
    for _, p in ipairs(targets) do
      if ai:isFriend(p) then
        ai:selectTarget(p, true)
        break
      end
    end
    return ai:doOKButton()
  end,
}

local use_to_enemy = {
  name = "__use_to_enemy",
  will_use = Util.TrueFunc,
  choose_targets = function(skill, ai, card)
    local targets = ai:getEnabledTargets()
    for _, p in ipairs(targets) do
      if ai:isEnemy(p) then
        ai:selectTarget(p, true)
        break
      end
    end
    return ai:doOKButton()
  end,
}

SmartAI:setSkillAI("__just_use", just_use)
SmartAI:setSkillAI("__use_to_enemy", use_to_enemy)
SmartAI:setSkillAI("__use_to_friend", use_to_friend)
SmartAI:setSkillAI("slash_skill", use_to_enemy)
SmartAI:setSkillAI("dismantlement_skill", use_to_enemy)
SmartAI:setSkillAI("snatch_skill", use_to_enemy)
SmartAI:setSkillAI("duel_skill", use_to_enemy)
SmartAI:setSkillAI("indulgence_skill", use_to_enemy)
SmartAI:setSkillAI("jink_skill", just_use)
SmartAI:setSkillAI("peach_skill", just_use)
SmartAI:setSkillAI("ex_nihilo_skill", just_use)
SmartAI:setSkillAI("savage_assault_skill", just_use)
SmartAI:setSkillAI("archery_attack_skill", just_use)
SmartAI:setSkillAI("god_salvation_skill", just_use)
SmartAI:setSkillAI("amazing_grace_skill", just_use)
SmartAI:setSkillAI("lightning_skill", just_use)
SmartAI:setSkillAI("default_equip_skill", just_use)
--]=====]
