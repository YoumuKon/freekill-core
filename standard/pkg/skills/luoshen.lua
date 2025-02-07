local skill = fk.CreateSkill{
  name = "luoshen",
}

skill:addEffect(fk.EventPhaseStart, nil, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill.name) and player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    while true do
      local judge = {
        who = player,
        reason = skill.name,
        pattern = ".|.|spade,club",
      }
      room:judge(judge)
      if judge.card.color ~= Card.Black or player.dead or not room:askForSkillInvoke(player, skill.name) then
        break
      end
    end
  end,
})
skill:addEffect(fk.FinishJudge, nil, {
  can_trigger = function(self, event, target, player, data)
    return target == player and not player.dead and data.reason == skill.name and data.card.color == Card.Black and
      player.room:getCardArea(data.card) == Card.Processing
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player.id, data.card, false, skill.name)
  end,
})

return skill
