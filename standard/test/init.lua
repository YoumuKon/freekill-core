TestStandard = { setup = InitRoom, tearDown = ClearRoom }

function TestStandard:testJianxiong()
  local room = LRoom
  local me, comp2 = room.players[1], room.players[2] ---@type ServerPlayer
  RunInRoom(function() room:handleAddLoseSkills(me, "jianxiong") end)

  local slash = Fk:getCardById(1)
  SetNextReplies(me, { "__cancel", "1" })
  RunInRoom(function()
    room:useCard{
      from = comp2.id,
      tos = { { me.id } },
      card = slash,
    }
  end)
  -- p(me:toJsonObject())
  lu.assertEquals(me:getCardIds("h")[1], 1)
end

function TestStandard:testGangLie()
  local room = LRoom
  local me, comp2 = room.players[1], room.players[2] ---@type ServerPlayer
  RunInRoom(function() room:handleAddLoseSkills(me, "ganglie") end)

  local slash = Fk:getCardById(1)
  SetNextReplies(me, { "__cancel", "1" })
  RunInRoom(function()
    room:drawCards(comp2, 2)
    room:moveCardTo(2, Card.DrawPile)
    room:useCard{
      from = comp2.id,
      tos = { { me.id } },
      card = slash,
    }
  end)
  p(me:toJsonObject())
  p(comp2:toJsonObject()) -- TODO: 问题来了：我该如何让AI觉得我必须绝不取消呢？
end
