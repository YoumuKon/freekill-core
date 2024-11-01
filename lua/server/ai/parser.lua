--- 用于从on_use/on_effect等函数自动生成AI推理用的模拟流程

---@class AIParser
local AIParser = {}

---@type table<string, string[]> 文件名-lines
local loaded_files = {}

local function getLines(filename)
  if loaded_files[filename] then return loaded_files[filename] end
  local t = {}
  for line in io.lines(filename) do
    table.insert(t, line)
  end
  loaded_files[filename] = t
  return t
end



return AIParser
