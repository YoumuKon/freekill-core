return fk.CreateSkill({
  name = "guicai",
  anim_type = "control",
}):addEffect(fk.AskForRetrial, { playerNotTarget = true }, {
  can_trigger = function(self, event, target, player, data)
    return not player:isKongcheng()
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local prompt = "#guicai-ask::" .. target.id
    local card = room:askForCard(player, 1, 1, false, self.name, true, ".|.|.|hand", prompt)
    if #card > 0 then
      self.cost_data = card[1]
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:retrial(Fk:getCardById(self.cost_data), player, data, self.name)
  end,
})
