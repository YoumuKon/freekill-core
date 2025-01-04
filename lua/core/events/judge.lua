---@class JudgeEvent: TriggerEvent
---@field data JudgeData
local JudgeEvent = TriggerEvent:subclass("JudgeEvent")

---@class fk.StartJudge: JudgeEvent
fk.StartJudge = JudgeEvent:subclass("fk.StartJudge")
---@class fk.AskForRetrial: JudgeEvent
fk.AskForRetrial = JudgeEvent:subclass("fk.AskForRetrial")
---@class fk.FinishRetrial: JudgeEvent
fk.FinishRetrial = JudgeEvent:subclass("fk.FinishRetrial")
---@class fk.FinishJudge: JudgeEvent
fk.FinishJudge = JudgeEvent:subclass("fk.FinishJudge")

