local skill_name = "yingzi"

local skill = fk.CreateSkill {
  name = skill_name,
}

skill:addEffect(fk.DrawNCards, nil, {
  on_use = function(self, event, target, player, data)
    data.n = data.n + 1
  end,
})

skill:addTest(function()
  local room = FkTest.room ---@type Room
  local me = room.players[1]
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, skill_name)
  end)

  FkTest.setNextReplies(me, { "1" })
  FkTest.runInRoom(function()
    local data = { ---@type TurnDataSpec
      who = me,
      reason = "game_rule",
      phase_table = { Player.Draw }
    }
    GameEvent.Turn:create(TurnData:new(data)):exec()
  end)

  lu.assertEquals(#me:getCardIds("h"), 3)
end)

return skill
