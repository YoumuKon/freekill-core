local yiji = fk.CreateSkill {
  name = "yiji",
}

yiji:addEffect(fk.Damaged, {
  on_trigger = function(self, event, target, player, data)
    self.cancel_cost = false
    for _ = 1, data.damage do
      if self.cancel_cost or not player:hasSkill(self) then break end
      self:doCost(event, target, player, data)
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, { skill_name = yiji.name }) then
      return true
    end
    self.cancel_cost = true
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local ids = room:getNCards(2)
    while not player.dead do
      local tos, cards = room:askToChooseCardsAndPlayers(player, {
        min_num = 1,
        max_num = 1,
        min_card_num = 1,
        max_card_num = #ids,
        targets = room.alive_players,
        pattern = tostring(Exppattern{ id = ids }),
        skill_name = yiji.name,
        prompt = "#yiji-give",
        cancelable = true,
        expand_pile = ids,
      })
      if #tos > 0 and #cards > 0 then
        for _, id in ipairs(cards) do
          table.removeOne(ids, id)
        end
        room:moveCardTo(cards, Card.PlayerHand, tos[1], fk.ReasonGive, yiji.name, nil, false, player)
        if #ids == 0 then break end
      else
        room:moveCardTo(ids, Card.PlayerHand, player, fk.ReasonGive, yiji.name, nil, false, player)
        return
      end
    end
  end,
})

return yiji
