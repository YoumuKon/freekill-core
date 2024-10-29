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
