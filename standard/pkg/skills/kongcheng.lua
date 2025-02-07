local skill = fk.CreateSkill{
  name = "kongcheng",
  frequency = Skill.Compulsory,
}

skill:addEffect("prohibit", nil, {
  is_prohibited = function(self, from, to, card)
    if to:hasSkill(skill.name) and to:isKongcheng() and card then
      return table.contains(card.trueName, {"slash", "duel"})
    end
  end,
})
skill:addEffect(fk.AfterCardsMove, nil, {
  can_refresh = function(self, event, target, player, data)
    if not (player:hasSkill(skill.name) and player:isKongcheng()) then return end
    for _, move in ipairs(data) do
      if move.from == player.id then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerHand then
            return true
          end
        end
      end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    player:broadcastSkillInvoke("kongcheng")
    player.room:notifySkillInvoked(player, "kongcheng", "defensive")
  end,
})

return skill
