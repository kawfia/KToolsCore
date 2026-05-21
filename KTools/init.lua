-- KTools/init.lua
local ADDON_NAME, KToolsNS = ...

KTools = LibStub("AceAddon-3.0"):NewAddon("KTools", "AceEvent-3.0", "AceConsole-3.0")

KToolsNS.defaults = {
    profile = {},
}

function KTools:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KToolsDB", KToolsNS.defaults, true)
end

function KTools:OnEnable()
end

local modules = {}

function KTools:RegisterModule(name, module)
    modules[name] = module
end

function KTools:CallModule(name, method, ...)
    local m = modules[name]
    if not m or not m[method] then return end
    local ok, err = pcall(m[method], m, ...)
    if not ok then
        self:Print("[KTools] Error in " .. name .. ": " .. tostring(err))
    end
end
