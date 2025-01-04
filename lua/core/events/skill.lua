---@class SkillEffectEvent: TriggerEvent
---@field data SkillEffectData
local SkillEffectEvent = TriggerEvent:subclass("SkillEffectEvent")

---@class fk.SkillEffect: SkillEffectEvent
fk.SkillEffect = SkillEffectEvent:subclass("fk.SkillEffect")
---@class fk.AfterSkillEffect: SkillEffectEvent
fk.AfterSkillEffect = SkillEffectEvent:subclass("fk.AfterSkillEffect")
---@class fk.EventLoseSkill: SkillEffectEvent
fk.EventLoseSkill = SkillEffectEvent:subclass("fk.EventLoseSkill")
---@class fk.EventAcquireSkill: SkillEffectEvent
fk.EventAcquireSkill = SkillEffectEvent:subclass("fk.EventAcquireSkill")

