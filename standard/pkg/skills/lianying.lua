return fk.CreateSkill({
  name = "lianying",
  anim_type = "drawcard",
}):addEffect(fk.AfterCardsMove, nil, {
  can_trigger = function(self, event, target, player, data)
    if not player:isKongcheng() then return end
    for _, move in ipairs(data) do
      if move.from == player.id then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerHand then
            return true
          end
        end
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, self.name)
  end,
})
