-- KTools/core/options.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local options = {
    type = "group",
    name = ADDON,
    args = {
        minimap = {
            type  = "toggle",
            name  = L["OPT_MINIMAP"],
            order = 1,
            get = function()
                return not KTools.db.profile.minimap.hide
            end,
            set = function(_, val)
                KTools.db.profile.minimap.hide = not val
                KTools:SetMinimapVisible(val)
            end,
        },
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON)


function KTools:GetOptionsName()
    return ADDON
end