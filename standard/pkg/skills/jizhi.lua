return fk.CreateSkill({
  name = "jizhi",
  anim_type = "drawcard",
}):addEffect(fk.CardUsing, nil, {
  can_trigger = function(self, event, target, player, data)
    return data.card:isCommonTrick() and (not data.card:isVirtual() or #data.card.subcards == 0)
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, self.name)
  end,
})
