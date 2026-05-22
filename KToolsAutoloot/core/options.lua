-- KToolsAutoloot/core/options.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local label = GetAddOnMetadata(ADDON, "X-ModuleName") or ADDON

local options = {
    type = "group",
    name = label,
    args = {
        bop = {
            type  = "toggle",
            name  = L["OPT_BOP"],
            order = 1,
            get = function()
                return AutoLoot.db.profile.options.bop
            end,
            set = function(_, val)
                AutoLoot.db.profile.options.bop = val
            end,
        },
        skinning = {
            type  = "toggle",
            name  = L["OPT_SKINNING"],
            order = 2,
            get = function()
                return AutoLoot.db.profile.options.skinning
            end,
            set = function(_, val)
                AutoLoot.db.profile.options.skinning = val
            end,
        },
        emptyLoot = {
            type  = "toggle",
            name  = L["OPT_EMPTY_LOOT"],
            order = 3,
            get = function()
                return AutoLoot.db.profile.options.emptyLoot
            end,
            set = function(_, val)
                AutoLoot.db.profile.options.emptyLoot = val
            end,
        },
        autoOpen = {
            type  = "toggle",
            name  = L["OPT_AUTO_OPEN"],
            order = 4,
            get = function()
                return AutoLoot.db.profile.options.autoOpen
            end,
            set = function(_, val)
                AutoLoot.db.profile.options.autoOpen = val
            end,
        },
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON, label, KTools:GetOptionsName())