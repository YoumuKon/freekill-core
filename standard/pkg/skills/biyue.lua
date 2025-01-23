local skill_name = "biyue"

local skill = fk.CreateSkill{
  name = skill_name,
  anim_type = "drawcard",
}

skill:addEffect(fk.EventPhaseStart, nil, {
  can_trigger = function(self, event, target, player, data)
    return player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, self.name)
  end,
})

return skill
