
--- RespondCardData 打出牌的数据
---@class RespondCardDataSpec
---@field public from ServerPlayer @ 使用/打出者
---@field public card Card @ 卡牌本牌
---@field public responseToEvent? CardEffectData @ 响应事件目标
---@field public skipDrop? boolean @ 是否不进入弃牌堆
---@field public customFrom? ServerPlayer @ 新响应者

--- 打出牌的数据
---@class RespondCardData: RespondCardDataSpec, TriggerData
RespondCardData = TriggerData:subclass("RespondCardData")

---@class RespondCardEvent: TriggerEvent
---@field data RespondCardData
local RespondCardEvent = TriggerEvent:subclass("RespondCardEvent")

---@class fk.PreCardRespond: RespondCardEvent
fk.PreCardRespond = RespondCardEvent:subclass("fk.PreCardRespond")
---@class fk.CardResponding: RespondCardEvent
fk.CardResponding = RespondCardEvent:subclass("fk.CardResponding")
---@class fk.CardRespondFinished: RespondCardEvent
fk.CardRespondFinished = RespondCardEvent:subclass("fk.CardRespondFinished")

--- UseCardData 使用牌的数据
---@class UseCardDataSpec
---@field public from ServerPlayer @ 使用/打出者
---@field public card Card @ 卡牌本牌
---@field public tos ServerPlayer[] 目标列表
---@field public subTos? ServerPlayer[][] 子目标列表，借刀最爱的一集
---@field public toCard? Card @ 卡牌目标
---@field public toPutSlot? string @ 使用的装备牌所置入的装备栏
---@field public responseToEvent? CardEffectData @ 响应事件目标
---@field public nullifiedTargets? ServerPlayer[] @ 对这些角色无效
---@field public extraUse? boolean @ 是否不计入次数
---@field public disresponsiveList? ServerPlayer[] @ 这些角色不可响应此牌
---@field public unoffsetableList? ServerPlayer[] @ 这些角色不可抵消此牌
---@field public additionalDamage? integer @ 额外伤害值（如酒之于杀）
---@field public additionalRecover? integer @ 额外回复值
---@field public extra_data? any @ 额外数据（如目标过滤等）
---@field public cardsResponded? Card[] @ 响应此牌的牌
---@field public prohibitedCardNames? string[] @ 这些牌名的牌不可响应此牌
---@field public damageDealt? table<ServerPlayer, number> @ 此牌造成的伤害
---@field public additionalEffect? integer @ 额外结算次数
---@field public noIndicate? boolean @ 隐藏指示线

--- 使用牌的数据
---@class UseCardData: UseCardDataSpec, TriggerData
UseCardData = TriggerData:subclass("UseCardData")

---@class UseCardEvent: TriggerEvent
---@field data UseCardData
local UseCardEvent = TriggerEvent:subclass("UseCardEvent")

---@class fk.PreCardUse: UseCardEvent
fk.PreCardUse = UseCardEvent:subclass("fk.PreCardUse")
---@class fk.AfterCardUseDeclared: UseCardEvent
fk.AfterCardUseDeclared = UseCardEvent:subclass("fk.AfterCardUseDeclared")
---@class fk.AfterCardTargetDeclared: UseCardEvent
fk.AfterCardTargetDeclared = UseCardEvent:subclass("fk.AfterCardTargetDeclared")
---@class fk.CardUsing: UseCardEvent
fk.CardUsing = UseCardEvent:subclass("fk.CardUsing")
---@class fk.BeforeCardUseEffect: UseCardEvent
fk.BeforeCardUseEffect = UseCardEvent:subclass("fk.BeforeCardUseEffect")
---@class fk.CardUseFinished: UseCardEvent
fk.CardUseFinished = UseCardEvent:subclass("fk.CardUseFinished")

--- AimStruct 处理使用牌目标的数据
---@class AimDataSpec
---@field public from integer @ 使用者
---@field public card Card @ 卡牌本牌
---@field public tos AimGroup @ 总角色目标
---@field public to integer @ 当前角色目标
---@field public subTargets? integer[] @ 子目标（借刀！）
---@field public targetGroup? TargetGroup @ 目标组
---@field public nullifiedTargets? integer[] @ 对这些角色无效
---@field public firstTarget boolean @ 是否是第一个目标
---@field public additionalDamage? integer @ 额外伤害值（如酒之于杀）
---@field public additionalRecover? integer @ 额外回复值
---@field public disresponsive? boolean @ 是否不可响应
---@field public unoffsetable? boolean @ 是否不可抵消
---@field public fixedResponseTimes? table<string, integer>|integer @ 额外响应请求
---@field public fixedAddTimesResponsors? integer[] @ 额外响应请求次数
---@field public additionalEffect? integer @额外结算次数
---@field public extraData? UseExtraData | any @ 额外数据

--- 使用牌的数据
---@class AimData: AimDataSpec, TriggerData
AimData = TriggerData:subclass("AimData")

---@param use UseCardData
function AimData.static:createFromUseData(use)
  local ret = AimData:new {}
end

---@class AimEvent: TriggerEvent
---@field data AimData
local AimEvent = TriggerEvent:subclass("AimData")

---@class fk.TargetSpecifying: AimEvent
fk.TargetSpecifying = AimEvent:subclass("fk.TargetSpecifying")
---@class fk.TargetConfirming: AimEvent
fk.TargetConfirming = AimEvent:subclass("fk.TargetConfirming")
---@class fk.TargetSpecified: AimEvent
fk.TargetSpecified = AimEvent:subclass("fk.TargetSpecified")
---@class fk.TargetConfirmed: AimEvent
fk.TargetConfirmed = AimEvent:subclass("fk.TargetConfirmed")

--- CardEffectData 卡牌效果的数据
---@class CardEffectDataSpec: RespondCardDataSpec
---@field public to ServerPlayer @ 角色目标
---@field public subTargets? ServerPlayer[] @ 子目标（借刀！）
---@field public tos TargetGroup @ 目标组
---@field public toCard? Card @ 卡牌目标
---@field public responseToEvent? CardEffectData @ 响应事件目标
---@field public nullifiedTargets? ServerPlayer[] @ 对这些角色无效
---@field public extraUse? boolean @ 是否不计入次数
---@field public disresponsiveList? ServerPlayer[] @ 这些角色不可响应此牌
---@field public unoffsetableList? ServerPlayer[] @ 这些角色不可抵消此牌
---@field public additionalDamage? integer @ 额外伤害值（如酒之于杀）
---@field public additionalRecover? integer @ 额外回复值
---@field public extra_data? any @ 额外数据（如目标过滤等）
---@field public cardsResponded? Card[] @ 响应此牌的牌
---@field public disresponsive? boolean @ 是否不可响应
---@field public unoffsetable? boolean @ 是否不可抵消
---@field public isCancellOut? boolean @ 是否被抵消
---@field public fixedResponseTimes? table<string, integer>|integer @ 额外响应请求
---@field public fixedAddTimesResponsors? integer[] @ 额外响应请求次数
---@field public prohibitedCardNames? string[] @ 这些牌名的牌不可响应此牌

--- 卡牌效果的数据
---@class CardEffectData: CardEffectDataSpec, TriggerData
CardEffectData = TriggerData:subclass("CardEffectData")

---@class CardEffectEvent: TriggerEvent
---@field data CardEffectData
local CardEffectEvent = TriggerEvent:subclass("CardEffectEvent")

---@class fk.PreCardEffect: CardEffectEvent
fk.PreCardEffect = CardEffectEvent:subclass("fk.PreCardEffect")
---@class fk.BeforeCardEffect: CardEffectEvent
fk.BeforeCardEffect = CardEffectEvent:subclass("fk.BeforeCardEffect")
---@class fk.CardEffecting: CardEffectEvent
fk.CardEffecting = CardEffectEvent:subclass("fk.CardEffecting")
---@class fk.CardEffectFinished: CardEffectEvent
fk.CardEffectFinished = CardEffectEvent:subclass("fk.CardEffectFinished")
---@class fk.CardEffectCancelledOut: CardEffectEvent
fk.CardEffectCancelledOut = CardEffectEvent:subclass("fk.CardEffectCancelledOut")

-- 注释

---@alias RespondCardFunc fun(self: TriggerSkill, event: RespondCardEvent,
---  target: ServerPlayer, player: ServerPlayer, data: RespondCardData): any

---@alias UseCardFunc fun(self: TriggerSkill, event: UseCardEvent,
---  target: ServerPlayer, player: ServerPlayer, data: UseCardData): any

---@alias AimFunc fun(self: TriggerSkill, event: AimEvent,
---  target: ServerPlayer, player: ServerPlayer, data: AimData): any

---@alias CardEffectFunc fun(self: TriggerSkill, event: CardEffectEvent,
---  target: ServerPlayer, player: ServerPlayer, data: CardEffectData): any

---@class SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: RespondCardEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<RespondCardFunc>): SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: UseCardEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<UseCardFunc>): SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: AimEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<AimFunc>): SkillSkeleton
---@field public addEffect fun(self: SkillSkeleton, key: CardEffectEvent,
---  attr: TrigSkelAttribute?, data: TrigSkelSpec<CardEffectFunc>): SkillSkeleton
