
--- SkillData 技能作用目标的数据
---@class SkillUseDataSpec
---@field public from ServerPlayer @ 使用者
---@field public tos ServerPlayer[] @ 角色目标
---@field public cards integer[] @ 选择卡牌
---@field public cost_data any @ 技能的消耗信息

--- 技能使用的数据
---@class SkillUseData: SkillUseDataSpec, TriggerData
SkillUseData = TriggerData:subclass("SkillUseData")

function SkillUseData:toLegacy()
  return {
    from = self.from.id,
    tos = table.map(self.tos, Util.IdMapper),
    cards = self.cards
  }
end

function SkillUseData:loadLegacy(spec)
  self.card = spec.cards
  self.from = Fk:currentRoom():getPlayerById(spec.from)
  self.tos = table.map(spec.tos, Util.Id2PlayerMapper)
end

---@class SkillEffectDataSpec
---@field public skill_cb fun():any @ 实际技能函数
---@field public who ServerPlayer @ 技能发动者
---@field public skill Skill @ 发动的技能
---@field public skill_data SkillUseData @ 技能数据

--- 技能效果的数据
---@class SkillEffectData: SkillEffectDataSpec, TriggerData
SkillEffectData = TriggerData:subclass("SkillEffectData")

---@class SkillEffectEvent: TriggerEvent
---@field data SkillEffectData
local SkillEffectEvent = TriggerEvent:subclass("SkillEffectEvent")

---@class fk.SkillEffect: SkillEffectEvent
fk.SkillEffect = SkillEffectEvent:subclass("fk.SkillEffect")
---@class fk.AfterSkillEffect: SkillEffectEvent
fk.AfterSkillEffect = SkillEffectEvent:subclass("fk.AfterSkillEffect")

--- SkillModifyData 技能作用目标的数据
---@class SkillModifyDataSpec
---@field public skill_cb fun():any @ 实际技能函数
---@field public who ServerPlayer @ 技能发动者
---@field public skill Skill @ 发动的技能
---@field public skill_data SkillDataSpec @ 技能数据

--- 技能效果的数据
---@class SkillModifyData: SkillModifyDataSpec, TriggerData
SkillModifyData = TriggerData:subclass("SkillModifyData")

---@class SkillModifyEvent: TriggerEvent
---@field data SkillModifyData
local SkillModifyEvent = TriggerEvent:subclass("SkillModifyEvent")

---@class fk.EventLoseSkill: SkillModifyEvent
fk.EventLoseSkill = TriggerEvent:subclass("fk.EventLoseSkill")
---@class fk.EventAcquireSkill: SkillModifyEvent
fk.EventAcquireSkill = TriggerEvent:subclass("fk.EventAcquireSkill")

-- 注释

---@alias SkillEffectTrigFunc fun(self: TriggerSkill, event: SkillEffectEvent,
---  target: ServerPlayer, player: ServerPlayer, data: SkillEffectData): any

---@alias SkillModifyTrigFunc fun(self: TriggerSkill, event: SkillModifyEvent,
---  target: ServerPlayer, player: ServerPlayer, data: SkillModifyData): any

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: SkillEffectEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<SkillEffectTrigFunc>): SkillSkeleton

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: SkillModifyEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<SkillModifyTrigFunc>): SkillSkeleton
