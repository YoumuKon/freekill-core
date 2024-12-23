return fk.CreateSkill({
  name = "tieqi",
  anim_type = "offensive",
}):addEffect(fk.TargetSpecified, nil, {
  can_trigger = function(self, event, target, player, data)
    return data.card.trueName == "slash"
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local judge = {
      who = player,
      reason = self.name,
      pattern = ".|.|heart,diamond",
    }
    room:judge(judge)
    if judge.card.color == Card.Red then
      data.disresponsive = true
    end
  end,
})
