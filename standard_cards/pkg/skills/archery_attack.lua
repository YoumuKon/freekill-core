local skill = fk.CreateSkill {
  name = "archery_attack_skill",
}

skill:addEffect("cardskill", {
  prompt = "#archery_attack_skill",
  can_use = Util.AoeCanUse,
  on_use = function (self, room, cardUseEvent)
    return Util.AoeCardOnUse(self, cardUseEvent.from, cardUseEvent, false)
  end,
  mod_target_filter = function(self, player, to_select, selected, card, distance_limited)
    return to_select ~= player
  end,
  on_effect = function(self, room, effect)
    local loopTimes = effect:getResponseTimes()
    local respond
    for i = 1, loopTimes do
      local params = { ---@type AskToUseCardParams
        skill_name = 'jink',
        pattern = 'jink',
        cancelable = true,
        event_data = effect
      }
      respond = room:askToResponse(effect.to, params)
      if respond then
        room:responseCard(respond)
      else
        room:damage({
          from = effect.from,
          to = effect.to,
          card = effect.card,
          damage = 1,
          damageType = fk.NormalDamage,
          skillName = skill.name,
        })
      end
      if effect.to.dead then break end
    end
  end,
})

skill:addTest(function(room, me)
  FkTest.runInRoom(function()
    room:useCard {
      from = me,
      tos = {},
      card = Fk:cloneCard("archery_attack"),
    }
  end)
  lu.assertEquals(me.hp, 4)
  lu.assertEquals(room.players[2].hp, 3)
  lu.assertEquals(room.players[3].hp, 3)
end)

return skill
