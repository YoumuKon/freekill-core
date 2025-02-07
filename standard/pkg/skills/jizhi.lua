local skill = fk.CreateSkill{
  name = "jizhi",
}

skill:addEffect(fk.CardUsing, nil, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill.name) and
      data.card:isCommonTrick() and not data.card:isVirtual()
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, skill.name)
  end,
})

return skill
