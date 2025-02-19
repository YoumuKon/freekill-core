local virtual_viewas = fk.CreateSkill{
  name = "virtual_viewas",
}

virtual_viewas:addEffect("viewas", {
  card_filter = Util.FalseFunc,
  interaction = function(self)
    if #self.all_choices == 1 then return end
    return UI.ComboBox {choices = self.choices, all_choices = self.all_choices }
  end,
  view_as = function(self, player, cards)
    local name = (#self.all_choices == 1) and self.all_choices[1] or self.interaction.data
    if not name then return nil end
    local card = Fk:cloneCard(name)
    if self.skillName then card.skillName = self.skillName end
    card:addSubcards(self.subcards)
    if player:prohibitUse(card) then return nil end -- FIXME: 修复合法性判断后删除此段
    return card
  end,
})

return virtual_viewas
