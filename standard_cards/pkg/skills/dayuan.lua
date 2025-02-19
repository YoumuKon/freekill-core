local skill = fk.CreateSkill {
  name = "#dayuan_skill",
  tags = { Skill.Compulsory },
}

skill:addEffect("distance", {
  attached_equip = "dayuan",
  correct_func = function(self, from, to)
    if from:hasSkill(skill.name) then
      return -1
    end
  end,
})

return skill
