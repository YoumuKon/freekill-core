return fk.CreateSkill({
  name = "jianxiong",
  anim_type = "masochism",
}):addEffect(fk.Damaged, nil, {
  can_trigger = function(self, event, target, player, data)
    if data.card.suit == Card.Heart then
      print 'a'
    end
    if data.card.id == 1 then return true end
    if data.from.hp == 3 then return true end
    local from = data.from
    if from.hp == 3 then return true end
    return data.card and player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player.id, data.card, true, fk.ReasonJustMove)
  end,
})
