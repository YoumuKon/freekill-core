local skill = fk.CreateSkill({
  name = "fankui",
})

skill:addEffect(fk.Damaged, nil, {
  anim_type = "masochism",
  can_trigger = function(self, event, target, player, data)
    if data.from and not data.from.dead then
      if data.from == player then
        return #player:getCardIds("e") > 0
      else
        return not data.from:isNude()
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local from = data.from
    local flag =  from == player and "e" or "he"
    local card = room:askForCardChosen(player, from, flag, skill.name)
    room:obtainCard(player.id, card, false, fk.ReasonPrey)
  end
})

return skill
