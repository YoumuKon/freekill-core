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
  local room = LRoom ---@type Room
  local me, comp2 = room.players[1], room.players[2] ---@type ServerPlayer
  RunInRoom(function()
    room:handleAddLoseSkills(me, "ganglie")
  end)

  -- 第一段：测试我发动刚烈，AI点取消
  local slash = Fk:getCardById(1)
  SetNextReplies(me, { "__cancel", "1" })
  SetNextReplies(comp2, { "__cancel" })
  local origin_hp = comp2.hp
  RunInRoom(function()
    room:obtainCard(comp2, { 3, 4 })

    room:moveCardTo(2, Card.DrawPile) -- 控顶
    room:useCard{
      from = comp2.id,
      tos = { { me.id } },
      card = slash,
    }
  end)
  lu.assertEquals(comp2.hp, origin_hp - 1)
  lu.assertEquals(#comp2:getCardIds("h"), 2)

  -- 第二段：测试我发动刚烈，AI丢二
  origin_hp = comp2.hp
  SetNextReplies(me, { "__cancel", "1" })
  SetNextReplies(comp2, { json.encode {
    targets = {},
    card = { skill = "discard_skill", subcards = { 3, 4 } }
  } })
  RunInRoom(function()
    room:moveCardTo(2, Card.DrawPile) -- 再控顶
    room:useCard{
      from = comp2.id,
      tos = { { me.id } },
      card = slash,
    }
  end)
  lu.assertEquals(comp2.hp, origin_hp)
  lu.assertEquals(#comp2:getCardIds("h"), 0)
end
