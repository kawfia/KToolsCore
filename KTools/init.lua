-- KTools/init.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):NewAddon(ADDON, "AceConsole-3.0", "AceEvent-3.0")
_G[ADDON] = KTools

local defaults = {
    profile = {
        window = {
        width  = 800,
        height = 600,
            point  = "CENTER",
            x      = 0,
            y      = 0,
            scale  = 1,
        },
        minimap = {
            hide = false,
        },
    },
}

function KTools:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KToolsDB", defaults, true)
end

function KTools:OnEnable()
    self:RegisterChatCommand("ktools", "ToggleMainFrame")
    self:RegisterChatCommand("ktl", "ToggleMainFrame")
    self:SetupMinimap()
end