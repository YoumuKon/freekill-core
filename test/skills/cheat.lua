local cheat = fk.CreateSkill{
  name = "cheat",
}

Fk:loadTranslationTable{
  [":cheat"] = "出牌阶段，你可获得想要的牌。",
  ["#cheat"] = "cheat：你可以获得一张想要的牌",
  ["$cheat"] = "喝啊！",
}

cheat:addEffect("active", {
  prompt = "#cheat",
  can_use = Util.TrueFunc,
  card_filter = Util.FalseFunc,
  target_num = 0,
  on_use = function(self, room, effect)
    local from = effect.from
    local cardType = { 'basic', 'trick', 'equip' }
    local cardTypeName = room:askToChoice(from, {choices = cardType, skill_name = "cheat"})
    local card_types = {Card.TypeBasic, Card.TypeTrick, Card.TypeEquip}
    cardType = card_types[table.indexOf(cardType, cardTypeName)]

    local allCardIds = Fk:getAllCardIds()
    local allCardMapper = {}
    local allCardNames = {}
    for _, id in ipairs(allCardIds) do
      local card = Fk:getCardById(id)
      if card.type == cardType then
        if allCardMapper[card.name] == nil then
          table.insert(allCardNames, card.name)
        end

        allCardMapper[card.name] = allCardMapper[card.name] or {}
        table.insert(allCardMapper[card.name], id)
      end
    end

    if #allCardNames == 0 then
      return
    end

    local cardName = room:askToChoice(from, {choices = allCardNames, skill_name = "cheat"})
    local toGain -- = room:printCard(cardName, Card.Heart, 1)
    if #allCardMapper[cardName] > 0 then
      toGain = allCardMapper[cardName][math.random(1, #allCardMapper[cardName])]
    end

    -- from:addToPile(self.name, toGain, true, self.name)
    -- room:setCardMark(Fk:getCardById(toGain), "@@test_cheat-phase", 1)
    -- room:setCardMark(Fk:getCardById(toGain), "@@test_cheat-inhand", 1)
    room:obtainCard(effect.from, toGain, true, fk.ReasonPrey)
  end
})

return cheat
