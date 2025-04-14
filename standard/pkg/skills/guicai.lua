local guicai = fk.CreateSkill {
  name = "guicai",
}

guicai:addEffect(fk.AskForRetrial, {
  guicai = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(guicai.name) and #player:getHandlyIds() > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local ids = table.filter(player:getHandlyIds(), function (id)
      return not player:prohibitResponse(Fk:getCardById(id))
    end)
    local cards = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      skill_name = guicai.name,
      pattern = tostring(Exppattern{ id = ids}),
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
