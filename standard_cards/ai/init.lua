fk.ai_card_keep_value["slash"] = 10

-- jink
fk.ai_card_keep_value["jink"] = 40

fk.ai_card_keep_value["peach"] = 60

fk.ai_card_keep_value["dismantlement"] = 45

fk.ai_card_keep_value["snatch"] = 45

-- duel
fk.ai_card_keep_value["duel"] = 30

-- collateral_skill
fk.ai_card_keep_value["collateral"] = 10

fk.ai_card_keep_value["ex_nihilo"] = 50

-- nullification
fk.ai_card_keep_value["nullification"] = 55

fk.ai_card_keep_value["savage_assault"] = 20

fk.ai_card_keep_value["archery_attack"] = 20

fk.ai_card_keep_value["god_salvation"] = 20

-- amazing_grace_skill
fk.ai_card_keep_value["amazing_grace"] = 20

-- lightning_skill
fk.ai_card_keep_value["lightning"] = -10

fk.ai_card_keep_value["indulgence"] = 50

fk.ai_card_keep_value["crossbow"] = 30

fk.ai_card_keep_value["qinggang_sword"] = 20

fk.ai_card_keep_value["ice_sword"] = 20

fk.ai_card_keep_value["double_swords"] = 20

fk.ai_card_keep_value["blade"] = 25

fk.ai_card_keep_value["spear"] = 25

fk.ai_card_keep_value["axe"] = 45

fk.ai_card_keep_value["halberd"] = 10

fk.ai_card_keep_value["kylin_bow"] = 5

fk.ai_card_keep_value["eight_diagram"] = 25

fk.ai_card_keep_value["nioh_shield"] = 20

fk.ai_card_keep_value["dilu"] = 20

fk.ai_card_keep_value["jueying"] = 20

fk.ai_card_keep_value["zhuahuangfeidian"] = 20

fk.ai_card_keep_value["chitu"] = 20

fk.ai_card_keep_value["dayuan"] = 20

fk.ai_card_keep_value["zixing"] = 20

SmartAI:setTriggerSkillAI("#nioh_shield_skill", {
  correct_func = function(self, logic, event, target, player, data)
    return self.skill:triggerable(event, target, player, data)
  end,
})

SmartAI:setSkillAI("spear_skill", {
  choose_targets = function(self, ai)
    local logic = AIGameLogic:new(ai)
    local val_func = function(targets)
      logic.benefit = 0
      logic:useCard{
        from = ai.player,
        tos = targets,
        card = self.skill:viewAs(ai.player, ai:getSelectedCards()),
      }
      verbose(1, "目前状况下，对[%s]的预测收益为%d", table.concat(table.map(targets, function(p)return tostring(p)end), "+"), logic.benefit)
      return logic.benefit
    end
    local best_targets, best_val = nil, -100000
    for targets in self:searchTargetSelections(ai) do
      local val = val_func(targets)
      if (not best_targets) or (best_val < val) then
        best_targets, best_val = targets, val
      end
    end
    return best_targets or {}, best_val
  end,
  think = function(self, ai)
    local skill_name = self.skill.name
    local estimate_val = self:getEstimatedBenefit(ai)
    -- local cards = ai:getEnabledCards()
    -- cards = table.random(cards, math.min(#cards, 5)) --[[@as integer[] ]]
    -- local cid = table.random(cards)

    local best_cards, best_ret, best_val = nil, "", -100000
    for cards in self:searchCardSelections(ai) do
      local ret, val = self:chooseTargets(ai)
      verbose(1, "就目前选择的这张牌，考虑[%s]，收益为%d", table.concat(table.map(ret, function(p)return tostring(p)end), "+"), val)
      val = val or -100000
      if best_val < val then
        best_cards, best_ret, best_val = cards, ret, val
      end
      -- if best_val >= estimate_val then break end
    end

    if best_ret and best_ret ~= "" then
      if best_val < 0 then
        return "", best_val
      end

      best_ret = { cards = best_cards, targets = best_ret }
    end

    return best_ret, best_val
  end,
}, "__card_skill")
