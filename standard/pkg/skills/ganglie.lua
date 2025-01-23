local skill_name = "ganglie"

local skill = fk.CreateSkill({
  name = skill_name,
  anim_type = "masochism",
})

skill:addEffect(fk.Damaged, nil, {
  on_use = function(self, event, target, player, data)
    local room = player.room
    local from = data.from
    if from and not from.dead then room:doIndicate(player.id, {from.id}) end
    local judge = {
      who = player,
      reason = self.name,
      pattern = ".|.|^heart",
    }
    room:judge(judge)
    if judge.card.suit ~= Card.Heart and from and not from.dead then
      local discards = room:askForDiscard(from, 2, 2, false, self.name, true)
      if #discards == 0 then
        room:damage{
          from = player,
          to = from,
          damage = 1,
          skillName = self.name,
        }
      end
    end
  end,
})

return skill
