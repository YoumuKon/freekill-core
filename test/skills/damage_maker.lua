local damage_maker = fk.CreateSkill{
  name = "damage_maker",
}

Fk:loadTranslationTable{
  ["damage_maker"] = "制伤",
  [":damage_maker"] = "出牌阶段，你可以进行一次伤害制造器。",
  ["#damage_maker"] = "制伤：选择一名小白鼠，可选另一名角色做伤害来源（默认谋徐盛）",
  ["#revive-ask"] = "复活一名角色！",
  ["$damage_maker"] = "区区数百魏军，看我一击灭之！",

  ["heal_hp"] = "回复体力",
  ["lose_max_hp"] = "减体力上限",
  ["heal_max_hp"] = "加体力上限",
  ["revive"] = "复活",
}

damage_maker:addEffect("active", {
  anim_type = "offensive",
  prompt = "#damage_maker",
  can_use = Util.TrueFunc,
  card_filter = Util.FalseFunc,
  card_num = 0,
  target_filter = function(self, player, to_select, selected)
    if self.interaction.data == "revive" then return false end
    return #selected < 2
  end,
  min_target_num = function(self)
    return self.interaction.data == "revive" and 0 or 1
  end,
  max_target_num = function(self)
    return self.interaction.data == "revive" and 0 or 2
  end,
  interaction = function() return UI.ComboBox {
    choices = {"normal_damage", "thunder_damage", "fire_damage", "ice_damage", "lose_hp", "heal_hp", "lose_max_hp", "heal_max_hp", "revive"}
  } end,
  on_use = function(self, room, effect)
    local from = effect.from
    local victim = effect.tos[1]
    local target = #effect.tos > 1 and effect.tos[2]
    local choice = self.interaction.data
    local number
    if choice ~= "revive" then
      local choices = {}
      for i = 1, 99 do
        table.insert(choices, tostring(i))
      end
      number = tonumber(room:askToChoice(from, {choices = choices, skill_name = damage_maker.name})) ---@type integer
    end
    if target then from = target end
    if choice == "heal_hp" then
      room:recover{
        who = victim,
        num = number,
        recoverBy = from,
        skillName = damage_maker.name
      }
    elseif choice == "heal_max_hp" then
      room:changeMaxHp(victim, number)
    elseif choice == "lose_max_hp" then
      room:changeMaxHp(victim, -number)
    elseif choice == "lose_hp" then
      room:loseHp(victim, number, damage_maker.name)
    elseif choice == "revive" then
      local targets = table.map(table.filter(room.players, function(p) return p.dead end), function(p) return "seat#" .. tostring(p.seat) end)
      if #targets > 0 then
        targets = room:askToChoice(from, {choices = targets, skill_name = damage_maker.name, prompt = "#revive-ask"})
        if targets then
          target = tonumber(string.sub(targets, 6))
          for _, p in ipairs(room.players) do
            if p.seat == target then
              room:revivePlayer(p, true)
              break
            end
          end
        end
      end
    else
      local choices = {"normal_damage", "thunder_damage", "fire_damage", "ice_damage"}
      room:damage({
        from = from,
        to = victim,
        damage = number,
        damageType = table.indexOf(choices, choice),
        skillName = damage_maker.name
      })
    end
  end,
})

return damage_maker
