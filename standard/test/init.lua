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
    -- if comp2:getCardIds("h")[1] then room:throwCard(comp2:getCardIds("h"), nil, comp2, comp2) end
    -- room:drawCards(comp2, 2)
  end)

  -- p(comp2:getCardIds("h"))

  local slash = Fk:getCardById(1)
  -- local cardstr = {
  --   skill = "discard_skill",
  --   subcards = comp2:getCardIds("h")
  -- }
  -- local reply = json.encode{
  --   card = cardstr,
  -- }
  SetNextReplies(me, { "__cancel", "1", "__cancel", "1" })
  SetNextReplies(comp2, { "__cancel" })
  -- local origin_hp = comp2.hp
  -- RunInRoom(function()
  --   room:moveCardTo(2, Card.DrawPile)
  --   room:useCard{
  --     from = comp2.id,
  --     tos = { { me.id } },
  --     card = slash,
  --   }
  -- end)
  -- lu.assertEquals(comp2.hp, origin_hp - 1)
  -- lu.assertEquals(#comp2:getCardIds("h"), 2)
  -- origin_hp = comp2.hp
  -- RunInRoom(function()
  --   room:moveCardTo(2, Card.DrawPile)
  --   room:useCard{
  --     from = comp2.id,
  --     tos = { { me.id } },
  --     card = slash,
  --   }
  -- end)
  -- lu.assertEquals(comp2.hp, origin_hp)
  -- lu.assertEquals(#comp2:getCardIds("h"), 0)
end
