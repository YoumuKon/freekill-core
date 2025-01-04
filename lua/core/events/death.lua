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

---@class fk.AfterPlayerRevived: TriggerEvent
fk.AfterPlayerRevived = TriggerEvent:subclass("fk.AfterPlayerRevived")
