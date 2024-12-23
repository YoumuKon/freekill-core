return fk.CreateSkill({
  name = "jiuyuan$",
  anim_type = "support",
}):addEffect(fk.PreHpRecover, nil, {
  can_trigger = function(self, event, target, player, data)
    return data.card and data.card.trueName == "peach" and
      data.recoverBy and data.recoverBy.kingdom == "wu" and data.recoverBy ~= player
  end,
  on_use = function(self, event, target, player, data)
    data.num = data.num + 1
  end,
})
