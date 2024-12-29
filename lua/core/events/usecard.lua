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
---@class fk.TargetSpecifying: UseCardEvent
fk.TargetSpecifying = UseCardEvent:subclass("fk.TargetSpecifying")
---@class fk.TargetConfirming: UseCardEvent
fk.TargetConfirming = UseCardEvent:subclass("fk.TargetConfirming")
---@class fk.TargetSpecified: UseCardEvent
fk.TargetSpecified = UseCardEvent:subclass("fk.TargetSpecified")
---@class fk.TargetConfirmed: UseCardEvent
fk.TargetConfirmed = UseCardEvent:subclass("fk.TargetConfirmed")
---@class fk.CardUseFinished: UseCardEvent
fk.CardUseFinished = UseCardEvent:subclass("fk.CardUseFinished")

---@class RespondCardEvent: TriggerEvent
---@field data RespondCardData
local RespondCardEvent = TriggerEvent:subclass("RespondCardEvent")

---@class fk.PreCardRespond: RespondCardEvent
fk.PreCardRespond = RespondCardEvent:subclass("fk.PreCardRespond")
---@class fk.CardResponding: RespondCardEvent
fk.CardResponding = RespondCardEvent:subclass("fk.CardResponding")
---@class fk.CardRespondFinished: RespondCardEvent
fk.CardRespondFinished = RespondCardEvent:subclass("fk.CardRespondFinished")

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
