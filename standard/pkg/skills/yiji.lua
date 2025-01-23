local main_skel = fk.CreateSkill({
  name = "yiji",
  anim_type = "masochism",
})

main_skel:addEffect(fk.Damaged, nil, {
  on_trigger = function(self, event, target, player, data)
    self.cancel_cost = false
    for _ = 1, data.damage do
      if self.cancel_cost or not player:hasSkill(self) then break end
      self:doCost(event, target, player, data)
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askForSkillInvoke(player, self.name, data) then
      return true
    end
    self.cancel_cost = true
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local ids = room:getNCards(2)
    while true do
      room:setPlayerMark(player, "yiji_cards", ids)
      local _, ret = room:askForUseActiveSkill(player, "yiji_active", "#yiji-give", true, nil, true)
      room:setPlayerMark(player, "yiji_cards", 0)
      if ret then
        for _, id in ipairs(ret.cards) do
          table.removeOne(ids, id)
        end
        room:moveCardTo(ret.cards, Card.PlayerHand, room:getPlayerById(ret.targets[1]), fk.ReasonGive,
        self.name, nil, false, player.id, nil, player.id)
        if #ids == 0 then break end
        if player.dead then
          room:moveCards({
            ids = ids,
            toArea = Card.DiscardPile,
            moveReason = fk.ReasonJustMove,
            skillName = self.name,
          })
          break
        end
      else
        room:moveCardTo(ids, Player.Hand, player, fk.ReasonGive, self.name, nil, false, player.id)
        break
      end
    end
  end,
})

local aux_skel = fk.CreateSkill {
  name = 'yiji_active',
}
aux_skel:addEffect('active', nil, {
  expand_pile = function(self)
    return type(Self:getMark("yiji_cards")) == "table" and Self:getMark("yiji_cards") or {}
  end,
  min_card_num = 1,
  target_num = 1,
  card_filter = function(self, to_select, selected, targets)
    local ids = Self:getMark("yiji_cards")
      return type(ids) == "table" and table.contains(ids, to_select)
  end,
  target_filter = function(self, to_select, selected, selected_cards)
    return #selected == 0 and to_select ~= Self.id
  end,
})

return main_skel, aux_skel
