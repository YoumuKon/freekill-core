local guicai = fk.CreateSkill {
  name = "guicai",
}

guicai:addEffect(fk.AskForRetrial, {
  guicai = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(guicai.name) and not player:isKongcheng()
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local pattern = tostring(Exppattern{ id = table.filter(player:getCardIds("h"),
    function(id) return not player:prohibitDiscard(Fk:getCardById(id)) end) })
    local cards = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      skill_name = guicai.name,
      pattern = pattern,
      prompt = "#guicai-ask::"..target.id,
      cancelable = true,
    })
    if #cards > 0 then
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:ChangeJudge{
      card = Fk:getCardById(event:getCostData(self).cards[1]),
      player = player,
      data = data,
      skillName = guicai.name,
      response = true,
    }
  end,
})

return guicai
