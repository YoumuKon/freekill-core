local skill_name = "fankui"

local skill = fk.CreateSkill({
  name = skill_name,
  anim_type = "masochism",
})

skill:addEffect(fk.Damaged, nil, {
  can_trigger = function(self, event, target, player, data)
    if data.from and not data.from.dead then
      if data.from == player then
        return #player.player_cards[Player.Equip] > 0
      else
        return not data.from:isNude()
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local from = data.from
    local flag =  from == player and "e" or "he"
    local card = room:askForCardChosen(player, from, flag, self.name)
    room:obtainCard(player.id, card, false, fk.ReasonPrey)
  end
})

return skill
