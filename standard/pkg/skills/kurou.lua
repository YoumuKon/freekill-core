local skill_name = "kurou"

local skill = fk.CreateSkill {
  name = skill_name,
  anim_type = "drawcard",
}

skill:addEffect('active', nil, {
  prompt = "#kurou-active",
  anim_type = "drawcard",
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local from = room:getPlayerById(effect.from)
    room:loseHp(from, 1, self.name)
    if from:isAlive() then
      from:drawCards(2, self.name)
    end
  end
})

return skill
