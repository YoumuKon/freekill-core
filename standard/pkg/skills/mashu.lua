local skill = fk.CreateSkill{
  name = "mashu",
  frequency = Skill.Compulsory,
}

skill:addEffect("distance", nil, {
  correct_func = function(self, from, to)
    if from:hasSkill(skill.name) then
      return -1
    end
  end,
})

return skill
