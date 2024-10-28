SmartAI:registerActiveSkill {
  name = "__just_use",
  will_use = Util.TrueFunc,
  choose_targets = function(skill, ai, card)
    return ai:doOKButton()
  end,
}

SmartAI:registerActiveSkill {
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

SmartAI:registerActiveSkill(fk.ai_skills["__use_to_enemy"], "slash_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__use_to_enemy"], "dismantlement_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__use_to_enemy"], "snatch_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__use_to_enemy"], "duel_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__use_to_enemy"], "indulgence_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "jink_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "peach_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "ex_nihilo_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "savage_assault_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "archery_attack_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "god_salvation_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "amazing_grace_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "lightning_skill")
SmartAI:registerActiveSkill(fk.ai_skills["__just_use"], "default_equip_skill")
