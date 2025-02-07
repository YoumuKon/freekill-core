local skill = fk.CreateSkill{
  name = "biyue",
}

skill:addEffect(fk.EventPhaseStart, nil, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill.name) and player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, skill.name)
  end,
})

return skill
