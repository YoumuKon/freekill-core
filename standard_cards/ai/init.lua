SmartAI:setCardSkillAI("default_card_skill", {
  on_use = function(self, logic, effect)
    self.skill:onUse(logic, effect)
  end,
  on_effect = function(self, logic, effect)
    self.skill:onEffect(logic, effect)
  end,
})

SmartAI:setCardSkillAI("slash_skill", {
  estimated_benefit = 100,
}, "default_card_skill")

-- jink

SmartAI:setCardSkillAI("peach_skill", nil, "default_card_skill")

SmartAI:setCardSkillAI("dismantlement_skill", {
  on_effect = function(self, logic, effect)
    local from = logic:getPlayerById(effect.from)
    local to = logic:getPlayerById(effect.to)
    if from.dead or to.dead or to:isAllNude() then return end
    local _, val = self:thinkForCardChosen(from.ai, to, "hej")
    logic.benefit = logic.benefit + val
  end,

  think_card_chosen = function(self, ai, target, _, __)
    local cards = target:getCardIds("hej")
    local cid, val = -1, -100000
    for _, id in ipairs(cards) do
      local v = ai:getBenefitOfEvents(function(logic)
        logic:throwCard({id}, self.skill.name, target, ai.player)
      end)
      if v > val then
        cid, val = id, v
      end
    end
    return cid, val
  end,
})

SmartAI:setCardSkillAI("snatch_skill", {
  think_card_chosen = function(self, ai, target, _, __)
    local cards = target:getCardIds("hej")
    local cid, val = -1, -100000
    for _, id in ipairs(cards) do
      local v = ai:getBenefitOfEvents(function(logic)
        logic:obtainCard(ai.player, id, false, fk.ReasonPrey)
      end)
      if v > val then
        cid, val = id, v
      end
    end
    return cid, val
  end,
}, "dismantlement_skill")

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

SmartAI:setCardSkillAI("god_salvation_skill", nil, "default_card_skill")

-- amazing_grace_skill
-- lightning_skill

SmartAI:setCardSkillAI("indulgence_skill")

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

    local best_ret, best_val = "", -100000
    for _, cid in ipairs(cards) do
      ai:selectCard(cid, true)
      local ret, val = self:chooseTargets(ai)
      val = val or -100000
      if best_val < val then
        best_ret, best_val = ret, val
      end
      if best_val >= estimate_val then break end
      ai:unSelectAll()
    end

    if best_ret and best_ret ~= "" then
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
