
--- DyingData 描述和濒死事件有关的数据
---@class DyingDataSpec
---@field public who PlayerId @ 濒死角色
---@field public damage? DamageData @ 造成此次濒死的伤害数据
---@field public ignoreDeath? boolean @ 是否不进行死亡结算

--- 描述和濒死事件有关的数据
---@class DyingData: DyingDataSpec, TriggerData
DyingData = TriggerData:subclass("DyingData")

---@class DyingEvent: TriggerEvent
---@field data DyingData
local DyingEvent = TriggerEvent:subclass("DyingEvent")

---@class fk.EnterDying: DyingEvent
fk.EnterDying = DyingEvent:subclass("fk.EnterDying")
---@class fk.Dying: DyingEvent
fk.Dying = DyingEvent:subclass("fk.Dying")
---@class fk.AfterDying: DyingEvent
fk.AfterDying = DyingEvent:subclass("fk.AfterDying")
---@class fk.AskForPeaches: DyingEvent
fk.AskForPeaches = DyingEvent:subclass("fk.AskForPeaches")
---@class fk.AskForPeachesDone: DyingEvent
fk.AskForPeachesDone = DyingEvent:subclass("fk.AskForPeachesDone")

--- DeathData 描述和死亡事件有关的数据
---@class DeathDataSpec
---@field public who PlayerId @ 死亡角色
---@field public damage? DamageData @ 造成此次死亡的伤害数据

--- 描述和死亡事件有关的数据
---@class DeathData: DeathDataSpec, TriggerData
DeathData = TriggerData:subclass("DeathData")

---@class DeathEvent: TriggerEvent
---@field data DeathData
local DeathEvent = TriggerEvent:subclass("DeathEvent")

---@class fk.Death: DeathEvent
fk.Death = DeathEvent:subclass("fk.Death")
---@class fk.BeforeGameOverJudge: DeathEvent
fk.BeforeGameOverJudge = DeathEvent:subclass("fk.BeforeGameOverJudge")
---@class fk.GameOverJudge: DeathEvent
fk.GameOverJudge = DeathEvent:subclass("fk.GameOverJudge")
---@class fk.Deathed: DeathEvent
fk.Deathed = DeathEvent:subclass("fk.Deathed")
---@class fk.BuryVictim: DeathEvent
fk.BuryVictim = DeathEvent:subclass("fk.BuryVictim")

--- ReviveData 描述和复活事件有关的数据
---@class ReviveDataSpec
---@field public who ServerPlayer @ 复活角色
---@field public reason string @ 复活角色的原因
---@field public send_log? boolean @ 是否发送战报

--- 描述和复活事件有关的数据
---@class ReviveData: ReviveDataSpec, TriggerData
ReviveData = TriggerData:subclass("ReviveData")

---@class ReviveEvent: TriggerEvent
---@field data ReviveData
local ReviveEvent = TriggerEvent:subclass("ReviveEvent")

---@class fk.AfterPlayerRevived: ReviveEvent
fk.AfterPlayerRevived = ReviveEvent:subclass("fk.AfterPlayerRevived")

-- 注释

---@alias DyingTrigFunc fun(self: TriggerSkill, event: DyingEvent,
---  target: ServerPlayer, player: ServerPlayer, data: DyingData): any

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: DyingEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<DyingTrigFunc>): SkillSkeleton

---@alias DeathTrigFunc fun(self: TriggerSkill, event: DeathEvent,
---  target: ServerPlayer, player: ServerPlayer, data: DeathData): any

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: DeathEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<DeathDataSpec>): SkillSkeleton

---@alias ReviveTrigFunc fun(self: TriggerSkill, event: ReviveEvent,
---  target: ServerPlayer, player: ServerPlayer, data: ReviveData): any

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: ReviveEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<ReviveDataSpec>): SkillSkeleton
