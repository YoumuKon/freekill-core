return fk.CreateSkill({
  name = "guanxing",
  anim_type = "control",
}):addEffect(fk.EventPhaseStart, nil, {
  can_trigger = function(self, event, target, player, data)
    return player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:askForGuanxing(player, room:getNCards(math.min(5, #room.alive_players)))
  end,
})
