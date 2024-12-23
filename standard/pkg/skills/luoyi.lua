return fk.CreateSkill({
  name = "luoyi",
  anim_type = "offensive",
}):addEffect(fk.DrawNCards, nil, {
  can_trigger = function(self, event, target, player, data)
    return data.n > 0
  end,
  on_use = function(self, event, target, player, data)
    data.n = data.n - 1
  end,
})
  :addEffect(fk.DamageCaused, nil, {
  can_trigger = function(self, event, target, player, data)
  return player:usedSkillTimes("luoyi", Player.HistoryTurn) > 0 and
    data.card and (data.card.trueName == "slash" or data.card.name == "duel") and data.by_user
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke("luoyi")
    room:notifySkillInvoked(player, "luoyi")
    data.damage = data.damage + 1
  end,
})
