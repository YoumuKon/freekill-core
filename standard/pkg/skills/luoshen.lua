return fk.CreateSkill({
  name = "luoshen",
  anim_type = "drawcard",
}):addEffect(fk.EventPhaseStart, nil, {
  can_trigger = function(self, event, target, player, data)
    return player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    while true do
      local judge = {
        who = player,
        reason = self.name,
        pattern = ".|.|spade,club",
      }
      room:judge(judge)
      if judge.card.color ~= Card.Black or player.dead or not room:askForSkillInvoke(player, self.name) then
        break
      end
    end
  end,
})
  :addEffect(fk.FinishJudge, nil, {
  can_trigger = function(self, event, target, player, data)
    return not player.dead and data.reason == "luoshen" and data.card.color == Card.Black and
    player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player.id, data.card)
  end,
})
