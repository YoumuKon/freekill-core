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
    local card = room:askToResponse(player, {
      skill_name = guicai.name,
      pattern = ".|.|.|hand",
      prompt = "#guicai-ask::"..target.id,
      cancelable = true,
    })
    if card then
      event:setCostData(self, {extra_data = card})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:retrial(event:getCostData(self).extra_data, player, data, guicai.name)
  end,
})

return guicai
