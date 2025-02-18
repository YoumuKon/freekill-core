local skill = fk.CreateSkill {
  name = "#hualiu_skill",
  tags = {Skill.Compulsory},
}

skill:addEffect("distance", {
  attached_equip = "hualiu",
  correct_func = function(self, from, to)
    if to:hasSkill(skill.name) then
      return 1
    end
  end,
})

return skill
