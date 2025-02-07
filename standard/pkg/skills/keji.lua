local skill = fk.CreateSkill{
  name = "keji",
}

skill:addEffect(fk.EventPhaseChanging, nil, {
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(skill.name) and data.to == Player.Discard then
      local play_ids = {}
      player.room.logic:getEventsOfScope(GameEvent.Phase, 1, function (e)
        if e.data[2] == Player.Play and e.end_id then
          table.insert(play_ids, {e.id, e.end_id})
        end
        return false
      end, Player.HistoryTurn)
      if #play_ids == 0 then return true end
      local function PlayCheck (e)
        local in_play = false
        for _, ids in ipairs(play_ids) do
          if e.id > ids[1] and e.id < ids[2] then
            in_play = true
            break
          end
        end
        return in_play and e.data.from == player and e.data.card.trueName == "slash"
      end
      return #player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, PlayCheck, Player.HistoryTurn) == 0
      and #player.room.logic:getEventsOfScope(GameEvent.RespondCard, 1, PlayCheck, Player.HistoryTurn) == 0
    end
  end,
  on_use = function(self, event, target, player, data)
    player:skip(Player.Discard)
  end,
})

skill:addTest(function()
  local room = FkTest.room ---@type Room
  local me = room.players[1]
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, skill.name)
  end)

  FkTest.setNextReplies(me, { "1" })
  FkTest.runInRoom(function()
    me:drawCards(10)
    local data = { ---@type TurnDataSpec
      who = me,
      reason = "game_rule",
      phase_table = { Player.Discard }
    }
    GameEvent.Turn:create(TurnData:new(data)):exec()
  end)

  lu.assertEquals(#me:getCardIds("h"), 10)
end)

return skill
