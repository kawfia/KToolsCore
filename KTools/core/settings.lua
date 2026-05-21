-- KTools/core/settings.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):GetAddon(ADDON)

KTools.defaults = {
    profile = {
        window = {
            width  = 600,
            height = 450,
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