return fk.CreateSkill({
  name = "yingzi",
  anim_type = "drawcard",
}):addEffect(fk.DrawNCards, nil, {
  on_use = function(self, event, target, player, data)
    data.n = data.n + 1
  end,
})
