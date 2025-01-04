---@class fk.DrawInitialCards: TriggerEvent
fk.DrawInitialCards = TriggerEvent:subclass("fk.DrawInitialCards")
---@class fk.AfterDrawInitialCards: TriggerEvent
fk.AfterDrawInitialCards = TriggerEvent:subclass("fk.AfterDrawInitialCards")

---@class fk.EventTurnChanging: TriggerEvent
fk.EventTurnChanging = TriggerEvent:subclass("fk.EventTurnChanging")

---@class fk.GameStart: TriggerEvent
fk.GameStart = TriggerEvent:subclass("fk.GameStart")

---@class RoundEvent: TriggerEvent
---@field data RoundData
local RoundEvent = TriggerEvent:subclass("RoundEvent")

---@class fk.RoundStart: RoundEvent
fk.RoundStart = RoundEvent:subclass("fk.RoundStart")
---@class fk.RoundEnd: RoundEvent
fk.RoundEnd = RoundEvent:subclass("fk.RoundEnd")
---@class fk.AfterRoundEnd: RoundEvent
fk.AfterRoundEnd = RoundEvent:subclass("fk.AfterRoundEnd")

---@class TurnEvent: TriggerEvent
---@field data TurnData
local TurnEvent = TriggerEvent:subclass("TurnEvent")

---@class fk.PreTurnStart: TurnEvent
fk.PreTurnStart = TurnEvent:subclass("fk.PreTurnStart")
---@class fk.BeforeTurnStart: TurnEvent
fk.BeforeTurnStart = TurnEvent:subclass("fk.BeforeTurnStart")
---@class fk.TurnStart: TurnEvent
fk.TurnStart = TurnEvent:subclass("fk.TurnStart")
---@class fk.TurnEnd: TurnEvent
fk.TurnEnd = TurnEvent:subclass("fk.TurnEnd")
---@class fk.AfterTurnEnd: TurnEvent
fk.AfterTurnEnd = TurnEvent:subclass("fk.AfterTurnEnd")

---@class PhaseEvent: TriggerEvent
---@field data PhaseData
local PhaseEvent = TriggerEvent:subclass("PhaseEvent")

---@class fk.EventPhaseStart: PhaseEvent
fk.EventPhaseStart = PhaseEvent:subclass("fk.EventPhaseStart")
---@class fk.EventPhaseProceeding: PhaseEvent
fk.EventPhaseProceeding = PhaseEvent:subclass("fk.EventPhaseProceeding")
---@class fk.EventPhaseEnd: PhaseEvent
fk.EventPhaseEnd = PhaseEvent:subclass("fk.EventPhaseEnd")
---@class fk.AfterPhaseEnd: PhaseEvent
fk.AfterPhaseEnd = PhaseEvent:subclass("fk.AfterPhaseEnd")
---@class fk.EventPhaseChanging: PhaseEvent
fk.EventPhaseChanging = PhaseEvent:subclass("fk.EventPhaseChanging")
---@class fk.EventPhaseSkipping: PhaseEvent
fk.EventPhaseSkipping = PhaseEvent:subclass("fk.EventPhaseSkipping")
---@class fk.EventPhaseSkipped: PhaseEvent
fk.EventPhaseSkipped = PhaseEvent:subclass("fk.EventPhaseSkipped")

---@class fk.DrawNCards: TriggerEvent
fk.DrawNCards = TriggerEvent:subclass("fk.DrawNCards")
---@class fk.AfterDrawNCards: TriggerEvent
fk.AfterDrawNCards = TriggerEvent:subclass("fk.AfterDrawNCards")

---@class fk.StartPlayCard: TriggerEvent
fk.StartPlayCard = TriggerEvent:subclass("fk.StartPlayCard")
