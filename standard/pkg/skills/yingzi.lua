local skill = fk.CreateSkill {
  name = "yingzi",
}

skill:addEffect(fk.DrawNCards, nil, {
  on_use = function(self, event, target, player, data)
    data.n = data.n + 1
  end,
})

return skill
