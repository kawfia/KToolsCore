-- KToolsAutoloot/init.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):NewAddon(ADDON, "AceConsole-3.0", "AceEvent-3.0")
_G[ADDON] = AutoLoot

local defaults = {
    profile = {
        enabled = false,
    },
}

function AutoLoot:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KToolsAutolootDB", defaults, true)
    KTools:RegisterModule(ADDON, self)
end

function AutoLoot:OnEnable()
    self:RegisterChatCommand("ktloot", "ShowModule")
end

function AutoLoot:ShowModule()
    KTools:ShowMainFrame()
end

function AutoLoot:Draw(container)
end