local skill = fk.CreateSkill {
  name = "#dilu_skill",
  tags = {Skill.Compulsory},
}

skill:addEffect("distance", {
  attached_equip = "dilu",
  correct_func = function(self, from, to)
    if to:hasSkill(skill.name) then
      return 1
    end
  end,
})

return skill
