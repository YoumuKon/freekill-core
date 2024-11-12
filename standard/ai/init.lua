if UsingNewCore then
  require "standard.ai.aux_skills"
else
  require "packages.standard.ai.aux_skills"
end

SmartAI:setSkillAI("ganglie", {
  think = function(self, ai)
    -- 处理askForUseActiveSkill(弃牌)
    -- 权衡一下弃牌与扣血的收益
    local cancel_val = ai:getBenefitOfEvents(function(logic)
      logic:damage{
        from = ai.room.logic:getCurrentEvent().data[2],
        to = ai.player,
        damage = 1,
        skillName = self.skill.name,
      }
    end)
    -- TODO: 把cancel_val告诉discard_skill让他思考弃牌，或者干脆封装一个用来选择弃什么牌的函数
    -- local ok_val = 模拟弃两张最垃圾牌的收益
    --   比如说，等于discard_skill_ai:think()的收益什么的
    -- if ok_val > cancel_val then
    --   return ai:doOKButton()
    -- else
    --   return ""
    -- end
  end,

  think_skill_invoke = function(self, ai, skill_name, prompt)
    ---@type DamageStruct
    local dmg = ai.room.logic:getCurrentEvent().data[1]
    local from = dmg.from
    if not from then return false end
    local dmg_val = ai:getBenefitOfEvents(function(logic)
      logic:damage{
        from = ai.player,
        to = from,
        damage = 1,
        skillName = self.skill.name,
      }
    end)
    local discard_val = ai:getBenefitOfEvents(function(logic)
      local cards = from:getCardIds("h")
      if #cards < 2 then
        logic.benefit = -1
        return
      end
      logic:throwCard(table.random(cards, 2), self.skill.name, from, from)
    end)
    if dmg_val > 0 or discard_val > 0 then
      return true
    end
    return false
  end,
})

SmartAI:setSkillAI("tuxi", {
  think = function(self, ai)
    local player = ai.player
    -- 选出界面上所有可选的目标
    local players = ai:getEnabledTargets()
    -- 对所有目标计算他们被拿走一张手牌后对自己的收益
    local benefits = table.map(players, function(p)
      return { p, ai:getBenefitOfEvents(function(logic)
        local c = p:getCardIds("h")[1]
        logic:obtainCard(player.id, c, false, fk.ReasonPrey)
      end)}
    end)
    -- 选择收益最高且大于0的两位 判断偷两位的收益加上放弃摸牌的负收益是否可以补偿
    local total_benefit = -ai:getBenefitOfEvents(function(logic)
      logic:drawCards(player, 2, self.skill.name)
    end)
    local targets = {}
    table.sort(benefits, function(a, b) return a[2] > b[2] end)
    for i, benefit in ipairs(benefits) do
      local p, val = table.unpack(benefit)
      if val < 0 then break end
      table.insert(targets, p)
      total_benefit = total_benefit + val
      if i == 2 then break end
    end
    if #targets == 0 or total_benefit <= 0 then return "" end
    return { targets = targets }
  end,
})

SmartAI:setSkillAI("zhiheng", {
  think = function(self, ai)
    local cards = ai:getEnabledCards()
    return { cards = cards }
  end,
})

SmartAI:setSkillAI("yingzi", {
  think_skill_invoke = Util.TrueFunc,
})

SmartAI:setSkillAI("xiaoji", {
  think_skill_invoke = function(self, ai, skill_name, prompt)
    return ai:getBenefitOfEvents(function(logic)
      logic:drawCards(ai.player, 2, self.skill.name)
    end) > 0
  end,
})
