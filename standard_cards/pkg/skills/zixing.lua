local skill = fk.CreateSkill {
  name = "#zixing_skill",
  tags = { Skill.Compulsory },
}

skill:addEffect("distance", {
  attached_equip = "zixing",
  correct_func = function(self, from, to)
    if from:hasSkill(skill.name) then
      return -1
    end
  end,
})

return skill
