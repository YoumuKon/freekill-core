local skill = fk.CreateSkill{
  name = "qianxun",
  frequency = Skill.Compulsory,
}

skill:addEffect("prohibit", nil, {
  is_prohibited = function(self, from, to, card)
    if to:hasSkill(skill.name) and card then
      return table.contains(card.trueName, {"indulgence", "snatch"})
    end
  end,
})

return skill
