---@class PindianEvent: TriggerEvent
---@field data PindianData
local PindianEvent = TriggerEvent:subclass("PindianEvent")


---@class fk.StartPindian: PindianEvent
fk.StartPindian = PindianEvent:subclass("fk.StartPindian")
---@class fk.PindianCardsDisplayed: PindianEvent
fk.PindianCardsDisplayed = PindianEvent:subclass("fk.PindianCardsDisplayed")
---@class fk.PindianResultConfirmed: PindianEvent
fk.PindianResultConfirmed = PindianEvent:subclass("fk.PindianResultConfirmed")
---@class fk.PindianFinished: PindianEvent
fk.PindianFinished = PindianEvent:subclass("fk.PindianFinished")

