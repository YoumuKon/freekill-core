-- 牢函数

---@class LegacyTriggerSkillSpec: UsableSkillSpec
---@field public global? boolean
---@field public events? (TriggerEvent|integer|string) | (TriggerEvent|integer|string)[]
---@field public refresh_events? (TriggerEvent|integer|string) | (TriggerEvent|integer|string)[]
---@field public priority? number | table<(TriggerEvent|integer|string), number>
---@field public on_trigger? TrigFunc
---@field public can_trigger? TrigFunc
---@field public on_cost? TrigFunc
---@field public on_use? TrigFunc
---@field public on_refresh? TrigFunc
---@field public can_refresh? TrigFunc
---@field public can_wake? TrigFunc

---@deprecated
---@param spec LegacyTriggerSkillSpec
---@return LegacyTriggerSkill
function fk.CreateTriggerSkill(spec)
  assert(type(spec.name) == "string")
  --assert(type(spec.on_trigger) == "function")
  if spec.frequency then assert(type(spec.frequency) == "number") end

  local frequency = spec.frequency or Skill.NotFrequent
  local skill = LegacyTriggerSkill:new(spec.name, frequency)
  fk.readUsableSpecToSkill(skill, spec)

  if type(spec.events) == "number" then
    table.insert(skill.events, spec.events)
  elseif type(spec.events) == "table" then
    table.insertTable(skill.events, spec.events)
  end

  if type(spec.refresh_events) == "number" then
    table.insert(skill.refresh_events, spec.refresh_events)
  elseif type(spec.refresh_events) == "table" then
    table.insertTable(skill.refresh_events, spec.refresh_events)
  end

  if type(spec.global) == "boolean" then skill.global = spec.global end

  if spec.on_trigger then skill.trigger = spec.on_trigger end

  if spec.can_trigger then
    if spec.frequency == Skill.Wake then
      skill.triggerable = function(self, event, target, player, data)
        return spec.can_trigger(self, event, target, player, data) and
          skill:enableToWake(event, target, player, data)
      end
    else
      skill.triggerable = spec.can_trigger
    end
  end

  if skill.frequency == Skill.Wake and spec.can_wake then
    skill.canWake = spec.can_wake
  end

  if spec.on_cost then skill.cost = spec.on_cost end
  if spec.on_use then skill.use = spec.on_use end

  if spec.can_refresh then
    skill.canRefresh = spec.can_refresh
  end

  if spec.on_refresh then
    skill.refresh = spec.on_refresh
  end

  if spec.attached_equip then
    if not spec.priority then
      spec.priority = 0.1
    end
  elseif not spec.priority then
    spec.priority = 1
  end

  if type(spec.priority) == "number" then
    for _, event in ipairs(skill.events) do
      skill.priority_table[event] = spec.priority
    end
  elseif type(spec.priority) == "table" then
    for event, priority in pairs(spec.priority) do
      skill.priority_table[event] = priority
    end
  end
  return skill
end

---@class LegacyActiveSkillSpec: UsableSkillSpec
---@field public can_use? fun(self: ActiveSkill, player: Player, card?: Card, extra_data: any): any @ 判断主动技能否发动
---@field public card_filter? fun(self: ActiveSkill, to_select: integer, selected: integer[], player: Player): any @ 判断卡牌能否选择
---@field public target_filter? fun(self: ActiveSkill, to_select: integer, selected: integer[], selected_cards: integer[], card?: Card, extra_data: any, player: Player?): any @ 判定目标能否选择
---@field public feasible? fun(self: ActiveSkill, selected: integer[], selected_cards: integer[], player: Player, card: Card): any @ 判断卡牌和目标是否符合技能限制
---@field public on_use? fun(self: ActiveSkill, room: Room, cardUseEvent: CardUseStruct | SkillEffectEvent): any
---@field public on_action? fun(self: ActiveSkill, room: Room, cardUseEvent: CardUseStruct | SkillEffectEvent, finished: boolean): any
---@field public about_to_effect? fun(self: ActiveSkill, room: Room, cardEffectEvent: CardEffectEvent | SkillEffectEvent): any
---@field public on_effect? fun(self: ActiveSkill, room: Room, cardEffectEvent: CardEffectEvent | SkillEffectEvent): any
---@field public on_nullified? fun(self: ActiveSkill, room: Room, cardEffectEvent: CardEffectEvent | SkillEffectEvent): any
---@field public mod_target_filter? fun(self: ActiveSkill, to_select: integer, selected: integer[], player: Player, card?: Card, distance_limited: boolean, extra_data: any): any
---@field public prompt? string|fun(self: ActiveSkill, selected_cards: integer[], selected_targets: integer[]): string @ 提示信息
---@field public interaction? any
---@field public target_tip? fun(self: ActiveSkill, to_select: integer, selected: integer[], selected_cards: integer[], card?: Card, selectable: boolean, extra_data: any): string|TargetTipDataSpec?
---@field public handly_pile? boolean @ 是否能够选择“如手牌使用或打出”的牌
---@field public fix_targets? fun(self: ActiveSkill, player: Player, card?: Card, extra_data: any): integer[]? @ 设置固定目标

---@param spec LegacyActiveSkillSpec
---@return ActiveSkill
---@deprecated
function fk.CreateActiveSkill(spec)
  assert(type(spec.name) == "string")
  local skill = ActiveSkill:new(spec.name, spec.frequency or Skill.NotFrequent)
  fk.readUsableSpecToSkill(skill, spec)

  if spec.can_use then
    skill.canUse = function(curSkill, player, card, extra_data)
      return spec.can_use(curSkill, player, card, extra_data) and curSkill:isEffectable(player)
    end
  end
  if spec.card_filter then skill.cardFilter = spec.card_filter end
  if spec.target_filter then
    skill.targetFilter = function(self, to_select, selected, selected_cards, card, extra_data, player)
      if type(to_select) == "number" then dbg() end
      local ret = spec.target_filter(self, to_select.id, table.map(selected, Util.IdMapper), selected_cards, card, extra_data, player)
      return ret
    end
  end
  if spec.mod_target_filter then
    skill.modTargetFilter = function(self, to_select, selected, player, card, distance_limited, extra_data)
      return spec.mod_target_filter(self, to_select.id, table.map(selected, Util.IdMapper), player, card, distance_limited, extra_data)
    end
  end
  if spec.feasible then
    skill.feasible = function(self, selected, selected_cards, player, card)
      return spec.feasible(self, table.map(selected, Util.IdMapper), selected_cards, player, card)
    end
  end
  if spec.on_use then skill.onUse = function(self, room, effect)
    local new_effect = effect
    local converted = false
    if effect.toLegacy then
      converted = true
      new_effect = effect:toLegacy()
    elseif type(effect.from) == "table" or (((effect.tos or {})[1]).class or {}).name == "ServerPlayer" then
      converted = true
      new_effect = SkillEffectData:_toLegacySkillData(effect)
    end
    spec.on_use(self, room, new_effect)
    if converted then
      if effect.loadLegacy then
        effect:loadLegacy(new_effect)
      else
        table.assign(effect, SkillEffectData:_loadLegacySkillData(new_effect))
      end
    end
  end end
  if spec.on_action then skill.onAction = function(self, room, effect, finished)
    local new_effect = effect
    local converted = false
    if effect.toLegacy then
      converted = true
      new_effect = effect:toLegacy()
    end
    spec.on_action(self, room, new_effect, finished)
    if converted then
      if effect.loadLegacy then
        effect:loadLegacy(new_effect)
      end
    end
  end end
  if spec.about_to_effect then skill.aboutToEffect = function(self, room, effect)
    local new_effect = effect
    local converted = false
    if effect.toLegacy then
      converted = true
      new_effect = effect:toLegacy()
    end
    spec.about_to_effect(self, room, new_effect)
    if converted then
      if effect.loadLegacy then
        effect:loadLegacy(new_effect)
      end
    end
  end end
  if spec.on_effect then skill.onEffect = function(self, room, effect)
    local new_effect = effect
    local converted = false
    if effect.toLegacy then
      converted = true
      new_effect = effect:toLegacy()
    end
    spec.on_effect(self, room, new_effect)
    if converted then
      if effect.loadLegacy then
        effect:loadLegacy(new_effect)
      end
    end
  end end
  if spec.on_nullified then skill.onNullified = function(self, room, effect)
    local new_effect = effect
    local converted = false
    if effect.toLegacy then
      converted = true
      new_effect = effect:toLegacy()
    end
    spec.on_nullified(self, room, new_effect)
    if converted then
      if effect.loadLegacy then
        effect:loadLegacy(new_effect)
      end
    end
  end end
  if spec.prompt then
    skill.prompt = function(self, selected_cards, selected_targets)
      if type(spec.prompt) == "string" then return spec.prompt end
      return spec.prompt(self, selected_cards, table.map(selected_targets, Util.IdMapper))
    end
  end
  if spec.target_tip then
    skill.targetTip = function(self, to_select, selected, selected_cards, card, selectable, extra_data)
      return spec.target_tip(self, to_select.id, table.map(selected, Util.IdMapper), selected_cards, card, selectable, extra_data)
    end
  end
  if spec.handly_pile then skill.handly_pile = spec.handly_pile end
  if spec.fix_targets then
    skill.fixTargets = function(self, player, card, extra_data)
      local ret = spec.fix_targets(self, player, card, extra_data)
      if not ret then return nil end
      return table.map(ret, Util.Id2PlayerMapper)
    end
  end

  if spec.interaction then
    skill.interaction = setmetatable({}, {
      __call = function()
        if type(spec.interaction) == "function" then
          return spec.interaction(skill)
        else
          return spec.interaction
        end
      end,
    })
  end
  return skill
end

---@class LegacyViewAsSkillSpec: UsableSkillSpec
---@field public card_filter? fun(self: ViewAsSkill, to_select: integer, selected: integer[], player: Player): any @ 判断卡牌能否选择
---@field public view_as fun(self: ViewAsSkill, cards: integer[], player: Player): Card? @ 判断转化为什么牌
---@field public pattern? string
---@field public enabled_at_play? fun(self: ViewAsSkill, player: Player): any
---@field public enabled_at_response? fun(self: ViewAsSkill, player: Player, response: boolean): any
---@field public before_use? fun(self: ViewAsSkill, player: ServerPlayer, use: CardUseStruct): string?
---@field public after_use? fun(self: ViewAsSkill, player: ServerPlayer, use: CardUseStruct): string? @ 使用此牌后执行的内容，注意打出不会执行
---@field public prompt? string|fun(self: ViewAsSkill, selected_cards: integer[], selected: integer[]): string
---@field public interaction? any
---@field public handly_pile? boolean @ 是否能够选择“如手牌使用或打出”的牌

---@param spec LegacyViewAsSkillSpec
---@return ViewAsSkill
---@deprecated
function fk.CreateViewAsSkill(spec)
  assert(type(spec.name) == "string")
  assert(type(spec.view_as) == "function")

  local skill = ViewAsSkill:new(spec.name, spec.frequency or Skill.NotFrequent)
  fk.readUsableSpecToSkill(skill, spec)

  skill.viewAs = spec.view_as
  if spec.card_filter then
    skill.cardFilter = spec.card_filter
  end
  if type(spec.pattern) == "string" then
    skill.pattern = spec.pattern
  end
  if type(spec.enabled_at_play) == "function" then
    skill.enabledAtPlay = function(curSkill, player)
      return spec.enabled_at_play(curSkill, player) and curSkill:isEffectable(player)
    end
  end
  if type(spec.enabled_at_response) == "function" then
    skill.enabledAtResponse = function(curSkill, player, cardResponsing)
      return spec.enabled_at_response(curSkill, player, cardResponsing) and curSkill:isEffectable(player)
    end
  end
  if spec.prompt then
    if type(spec.prompt) == "string" then
      skill.prompt = function() return spec.prompt end
    else
      skill.prompt = function(self, selected_cards, selected_targets)
        return spec.prompt(self, selected_cards, table.map(selected_targets, Util.IdMapper))
      end
    end
  end

  if spec.interaction then
    skill.interaction = setmetatable({}, {
      __call = function()
        if type(spec.interaction) == "function" then
          return spec.interaction(skill)
        else
          return spec.interaction
        end
      end,
    })
  end

  if spec.before_use and type(spec.before_use) == "function" then
    skill.beforeUse = spec.before_use
  end

  if spec.after_use and type(spec.after_use) == "function" then
    skill.afterUse = spec.after_use
  end
  skill.handly_pile = spec.handly_pile

  return skill
end

---@param spec DistanceSpec
---@return DistanceSkill
---@deprecated
function fk.CreateDistanceSkill(spec)
  assert(type(spec.name) == "string")
  assert(type(spec.correct_func) == "function" or type(spec.fixed_func) == "function")

  local skill = DistanceSkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  skill.getCorrect = spec.correct_func
  skill.getFixed = spec.fixed_func

  return skill
end

---@param spec ProhibitSpec
---@return ProhibitSkill
---@deprecated
function fk.CreateProhibitSkill(spec)
  assert(type(spec.name) == "string")

  local skill = ProhibitSkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  skill.isProhibited = spec.is_prohibited or skill.isProhibited
  skill.prohibitUse = spec.prohibit_use or skill.prohibitUse
  skill.prohibitResponse = spec.prohibit_response or skill.prohibitResponse
  skill.prohibitDiscard = spec.prohibit_discard or skill.prohibitDiscard
  skill.prohibitPindian = spec.prohibit_pindian or skill.prohibitPindian

  return skill
end

---@param spec AttackRangeSpec
---@return AttackRangeSkill
---@deprecated
function fk.CreateAttackRangeSkill(spec)
  assert(type(spec.name) == "string")
  assert(type(spec.correct_func) == "function" or type(spec.fixed_func) == "function" or
    type(spec.within_func) == "function" or type(spec.without_func) == "function")

  local skill = AttackRangeSkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  if spec.correct_func then
    skill.getCorrect = spec.correct_func
  end
  if spec.fixed_func then
    skill.getFixed = spec.fixed_func
  end
  if spec.within_func then
    skill.withinAttackRange = spec.within_func
  end
  if spec.without_func then
    skill.withoutAttackRange = spec.without_func
  end

  return skill
end

---@param spec MaxCardsSpec
---@return MaxCardsSkill
---@deprecated
function fk.CreateMaxCardsSkill(spec)
  assert(type(spec.name) == "string")
  assert(type(spec.correct_func) == "function" or type(spec.fixed_func) == "function" or type(spec.exclude_from) == "function")

  local skill = MaxCardsSkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  if spec.correct_func then
    skill.getCorrect = spec.correct_func
  end
  if spec.fixed_func then
    skill.getFixed = spec.fixed_func
  end
  skill.excludeFrom = spec.exclude_from or skill.excludeFrom

  return skill
end

---@class LegacyTargetModSpec: StatusSkillSpec
---@field public bypass_times? fun(self: TargetModSkill, player: Player, skill: ActiveSkill, scope: integer, card?: Card, to?: Player): any
---@field public residue_func? fun(self: TargetModSkill, player: Player, skill: ActiveSkill, scope: integer, card?: Card, to?: Player): number?
---@field public bypass_distances? fun(self: TargetModSkill, player: Player, skill: ActiveSkill, card?: Card, to?: Player): any
---@field public distance_limit_func? fun(self: TargetModSkill, player: Player, skill: ActiveSkill, card?: Card, to?: Player): number?
---@field public extra_target_func? fun(self: TargetModSkill, player: Player, skill: ActiveSkill, card?: Card): number?
---@field public target_tip_func? fun(self: TargetModSkill, player: Player, to_select: integer, selected: integer[], selected_cards: integer[], card?: Card, selectable: boolean, extra_data: any): string|TargetTipDataSpec?


---@param spec LegacyTargetModSpec
---@return TargetModSkill
---@deprecated
function fk.CreateTargetModSkill(spec)
  assert(type(spec.name) == "string")

  local skill = TargetModSkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  if spec.bypass_times then
    skill.bypassTimesCheck = spec.bypass_times
  end
  if spec.residue_func then
    skill.getResidueNum = spec.residue_func
  end
  if spec.bypass_distances then
    skill.bypassDistancesCheck = spec.bypass_distances
  end
  if spec.distance_limit_func then
    skill.getDistanceLimit = spec.distance_limit_func
  end
  if spec.extra_target_func then
    skill.getExtraTargetNum = spec.extra_target_func
  end
  if spec.target_tip_func then
    skill.getTargetTip = function(self, player, to_select, selected, selected_cards, card, selectable, extra_data)
      return spec.target_tip_func(self, player, to_select.id, table.map(selected, Util.IdMapper), selected_cards, card, selectable, extra_data)
    end
  end

  return skill
end

---@param spec FilterSpec
---@return FilterSkill
---@deprecated
function fk.CreateFilterSkill(spec)
  assert(type(spec.name) == "string")

  local skill = FilterSkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  skill.cardFilter = spec.card_filter
  skill.viewAs = spec.view_as
  skill.equipSkillFilter = spec.equip_skill_filter

  return skill
end

---@param spec InvaliditySpec
---@return InvaliditySkill
---@deprecated
function fk.CreateInvaliditySkill(spec)
  assert(type(spec.name) == "string")

  local skill = InvaliditySkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)

  if spec.invalidity_func then
    skill.getInvalidity = spec.invalidity_func
  end
  if spec.invalidity_attackrange then
    skill.getInvalidityAttackRange = spec.invalidity_attackrange
  end

  return skill
end

---@param spec VisibilitySpec
---@return VisibilitySkill
---@deprecated
function fk.CreateVisibilitySkill(spec)
  assert(type(spec.name) == "string")

  local skill = VisibilitySkill:new(spec.name)
  fk.readStatusSpecToSkill(skill, spec)
  if spec.card_visible then skill.cardVisible = spec.card_visible end
  if spec.role_visible then skill.roleVisible = spec.role_visible end

  return skill
end
