local liuli = fk.CreateSkill{
  name = "liuli",
}

liuli:addEffect(fk.TargetConfirming, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(liuli.name) and data.card.trueName == "slash" and
      table.find(player.room.alive_players, function (p)
        return player:inMyAttackRange(p) and p ~= data.from and not data.from:isProhibited(p, data.card)
      end) and
      not player:isNude()
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local cards = table.filter(player:getCardIds("he"), function(id)
      return not player:prohibitDiscard(Fk:getCardById(id))
    end)
    local targets = table.filter(room.alive_players, function (p)
      return player:inMyAttackRange(p) and p ~= data.from and not data.from:isProhibited(p, data.card)
    end)
    local tos, id = room:askToChooseCardsAndPlayers(player, {
      min_num = 1,
      max_num = 1,
      min_card_num = 1,
      max_card_num = 1,
      targets = targets,
      pattern = tostring(Exppattern{ id = cards }),
      skill_name = liuli.name,
      prompt = "#liuli-target",
      cancelable = true,
    })
    if #tos > 0 and id then
      event:setCostData(self, {tos = tos, cards = {id}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:throwCard(event:getCostData(self).cards, liuli.name, player, player)
    data:cancelTarget(player)
    data:addTarget(to)
  end,
})

return liuli
