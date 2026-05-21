-- KTools/init.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):NewAddon(ADDON, "AceConsole-3.0", "AceEvent-3.0")
_G[ADDON] = KTools

function KTools:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KToolsDB", self.defaults, true)
end

function KTools:OnEnable()
    self:RegisterChatCommand("ktools", "ToggleMainFrame")
    self:RegisterChatCommand("ktl", "ToggleMainFrame")
end