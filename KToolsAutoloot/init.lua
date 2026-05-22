-- KToolsAutoloot/init.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):NewAddon(ADDON, "AceConsole-3.0", "AceEvent-3.0")
_G[ADDON] = AutoLoot

local defaults = {
    profile = {
        enabled = true,
        categories = {
            gold     = true,
            reagents = true,
            recipes  = false,
            mounts   = true,
            pets     = false,
            quest    = true,
            currency = true,
            artifact = true,
        },
        quality = {
            [0] = { enabled = false, boe = true, bop = true, ilvl = 0 },
            [1] = { enabled = false, boe = true, bop = true, ilvl = 0 },
            [2] = { enabled = false, boe = true, bop = true, ilvl = 0 },
            [3] = { enabled = false, boe = true, bop = true, ilvl = 0 },
            [4] = { enabled = false, boe = true, bop = true, ilvl = 0 },
            [5] = { enabled = false, boe = true, bop = true, ilvl = 0 },
        },
        customList = {},
        options = {
            bop       = false,
            skinning  = false,
            emptyLoot = false,
        },
    },
}

function AutoLoot:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KToolsAutolootDB", defaults, true)
    local label = GetAddOnMetadata(ADDON, "X-ModuleName") or ADDON
    KTools:RegisterModule(ADDON, self, { minWidth = 750, minHeight = 515, label = label })
end

function AutoLoot:OnEnable()
    self:RegisterChatCommand("ktloot", "ShowModule")
end

function AutoLoot:ShowModule()
    KTools:ShowMainFrameWithModule(ADDON)
end

function AutoLoot:Draw(container)
end