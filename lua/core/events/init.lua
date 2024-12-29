---@class TriggerData: Object
TriggerData = class("TriggerData")
function TriggerData:initialize(spec)
  table.assign(self, spec)
end

require "core.events.misc"
require "core.events.hp"
require "core.events.death"
require "core.events.movecard"
require "core.events.usecard"
require "core.events.skill"
require "core.events.judge"
require "core.events.gameflow"
require "core.events.pindian"
