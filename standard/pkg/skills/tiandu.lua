return fk.CreateSkill({
  name = "tiandu",
  anim_type = "drawcard",
}):addEffect(fk.FinishJudge, nil, {
  can_trigger = function(self, event, target, player, data)
    return data.card and player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player.id, data.card, true, fk.ReasonJustMove)
  end,
})
