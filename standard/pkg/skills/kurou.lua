local skill = fk.CreateSkill {
  name = "kurou",
}

skill:addEffect("active", nil, {
  anim_type = "drawcard",
  prompt = "#kurou-active",
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local from = effect.from
    room:loseHp(from, 1, skill.name)
    if from:isAlive() then
      from:drawCards(2, skill.name)
    end
  end
})

return skill
