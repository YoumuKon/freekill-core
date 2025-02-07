local sk = fk.CreateSkill{
  name = "qicai",
  frequency = Skill.Compulsory,
}

sk:addEffect("targetmod", nil, {
  bypass_distances = function(self, player, skill, card)
    return player:hasSkill(sk.name) and card and card.type == Card.TypeTrick
  end,
})

return sk
