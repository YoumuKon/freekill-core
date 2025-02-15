local qicai = fk.CreateSkill{
  name = "qicai",
  frequency = Skill.Compulsory,
}

qicai:addEffect("targetmod", {
  bypass_distances = function(self, player, skill, card)
    return player:hasSkill(qicai.name) and card and card.type == Card.TypeTrick
  end,
})

qicai:addTest(function(room, me)
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, "qicai")
    -- 让顺手牵羊可以用一下
    for _, other in ipairs(room:getOtherPlayers(me, false)) do
      other:drawCards(1)
    end
  end)

  local snatch = Fk:cloneCard("snatch")
  lu.assertIsTrue(table.every(room:getOtherPlayers(me, false), function (other)
    return me:canUseTo(snatch, other)
  end))
end)

return qicai
