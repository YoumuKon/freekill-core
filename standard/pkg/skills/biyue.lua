return fk.CreateSkill({
  name = "biyue",
  anim_type = "drawcard",
}):addEffect(fk.EventPhaseStart, nil, {
  can_trigger = function(self, event, target, player, data)
    return player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, self.name)
  end,
})
