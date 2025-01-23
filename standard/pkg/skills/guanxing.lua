local skill_name = "guanxing"

local skill = fk.CreateSkill({
  name = skill_name,
  anim_type = "control",
})

skill:addEffect(fk.EventPhaseStart, nil, {
  can_trigger = function(self, event, target, player, data)
    return player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:askForGuanxing(player, room:getNCards(math.min(5, #room.alive_players)))
  end,
})

return skill
