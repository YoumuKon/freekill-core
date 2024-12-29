---@class MoveCardsEvent: TriggerEvent
---@field data MoveCardsData
local MoveCardsEvent = TriggerEvent:subclass("MoveCardsEvent")

---@class fk.BeforeCardsMove: MoveCardsEvent
fk.BeforeCardsMove = MoveCardsEvent:subclass("fk.BeforeCardsMove")
---@class fk.AfterCardsMove: MoveCardsEvent
fk.AfterCardsMove = MoveCardsEvent:subclass("fk.AfterCardsMove")
---@class fk.BeforeDrawCard: MoveCardsEvent
fk.BeforeDrawCard = MoveCardsEvent:subclass("fk.BeforeDrawCard")

