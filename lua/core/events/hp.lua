
--- HpChangedData 描述和一次体力变化有关的数据
---@class HpChangedDataSpec
---@field public num integer @ 体力变化量，可能是正数或者负数
---@field public shield_lost? integer
---@field public reason string @ 体力变化原因
---@field public skillName string @ 引起体力变化的技能名
---@field public damageEvent? DamageStruct @ 引起这次体力变化的伤害数据
---@field public preventDying? boolean @ 是否阻止本次体力变更流程引发濒死流程

---@class HpChangedData: HpChangedDataSpec, Object
HpChangedData = class("HpChangedData")

--- HpLostData 描述跟失去体力有关的数据
---@class HpLostDataSpec
---@field public num integer @ 失去体力的数值
---@field public skillName string @ 导致这次失去的技能名

--- MaxHpChangedData 描述跟体力上限变化有关的数据
---@class MaxHpChangedDataSpec
---@field public num integer @ 体力上限变化量，可能是正数或者负数

--- DamageType 伤害的属性
---@alias DamageType integer

fk.NormalDamage = 1
fk.ThunderDamage = 2
fk.FireDamage = 3
fk.IceDamage = 4

--- DamageStruct 描述和伤害事件有关的数据。
---@class DamageStructSpec
---@field public from? ServerPlayer @ 伤害来源
---@field public to ServerPlayer @ 伤害目标
---@field public damage integer @ 伤害值
---@field public card? Card @ 造成伤害的牌
---@field public chain? boolean @ 伤害是否是铁索传导的伤害
---@field public damageType? DamageType @ 伤害的属性
---@field public skillName? string @ 造成本次伤害的技能名
---@field public beginnerOfTheDamage? boolean @ 是否是本次铁索传导的起点
---@field public by_user? boolean @ 是否由卡牌直接生效造成的伤害
---@field public chain_table? ServerPlayer[] @ 铁索连环表

---@class DamageStruct: DamageStructSpec, Object
DamageStruct = class("DamageStruct")

--- RecoverStruct 描述和回复体力有关的数据。
---@class RecoverStructSpec
---@field public who ServerPlayer @ 回复体力的角色
---@field public num integer @ 回复值
---@field public recoverBy? ServerPlayer @ 此次回复的回复来源
---@field public skillName? string @ 因何种技能而回复
---@field public card? Card @ 造成此次回复的卡牌

---@class HpChangedEvent: TriggerEvent
---@field data HpChangedData
local HpChangedEvent = TriggerEvent:subclass("HpChangedEvent")

---@class fk.BeforeHpChanged: HpChangedEvent
fk.BeforeHpChanged = HpChangedEvent:subclass("fk.BeforeHpChanged")
---@class fk.HpChanged: HpChangedEvent
fk.HpChanged = HpChangedEvent:subclass("fk.HpChanged")

---@class DamageEvent: TriggerEvent
---@field data DamageStruct
local DamageEvent = TriggerEvent:subclass("DamageEvent")

---@class fk.PreDamage: DamageEvent
fk.PreDamage = DamageEvent:subclass("fk.PreDamage")
---@class fk.DamageCaused: DamageEvent
fk.DamageCaused = DamageEvent:subclass("fk.DamageCaused")
---@class fk.DamageInflicted: DamageEvent
fk.DamageInflicted = DamageEvent:subclass("fk.DamageInflicted")
---@class fk.Damage: DamageEvent
fk.Damage = DamageEvent:subclass("fk.Damage")
---@class fk.Damaged: DamageEvent
fk.Damaged = DamageEvent:subclass("fk.Damaged")
---@class fk.DamageFinished: DamageEvent
fk.DamageFinished = DamageEvent:subclass("fk.DamageFinished")

---@class HpLostEvent: TriggerEvent
---@field public data HpLostData
local HpLostEvent = TriggerEvent:subclass("HpLostEvent")

---@class fk.PreHpLost: HpLostEvent
fk.PreHpLost = HpLostEvent:subclass("fk.PreHpLost")
---@class fk.HpLost: HpLostEvent
fk.HpLost = HpLostEvent:subclass("fk.HpLost")

---@class RecoverEvent: TriggerEvent
---@field public data RecoverStruct
local RecoverEvent = TriggerEvent:subclass("RecoverEvent")

---@class fk.PreHpRecover: RecoverEvent
fk.PreHpRecover = RecoverEvent:subclass("fk.PreHpRecover")
---@class fk.HpRecover: RecoverEvent
fk.HpRecover = RecoverEvent:subclass("fk.HpRecover")

---@class MaxHpChangedEvent: TriggerEvent
---@field public data MaxHpChangedData
local MaxHpChangedEvent = TriggerEvent:subclass("MaxHpChangedEvent")

---@class fk.BeforeMaxHpChanged: MaxHpChangedEvent
fk.BeforeMaxHpChanged = MaxHpChangedEvent:subclass("fk.BeforeMaxHpChanged")
---@class fk.MaxHpChanged: MaxHpChangedEvent
fk.MaxHpChanged = MaxHpChangedEvent:subclass("fk.MaxHpChanged")

-- 注释环节

--[[
先三个大any得了
---@class DamageSkelAttr: TrigSkelAttribute

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: HpChangedEvent,
---  attr: TrigSkelAttribute?, data: HpChangedSkelSpec): SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: DamageEvent,
---  attr: DamageSkelAttr?, data: DamageSkelSpec): SkillSkeleton
--]]
