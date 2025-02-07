local skill = fk.CreateSkill {
  name = "tiandu",
}

skill:addEffect(fk.FinishJudge, nil, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill.name) and
      data.card and player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player.id, data.card, true, fk.ReasonJustMove, skill.name)
  end,
})

return skill
