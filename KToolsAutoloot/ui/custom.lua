-- KToolsAutoloot/ui/custom.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

function AutoLoot:DrawCustomList(container)
    local label = AceGUI:Create("Label")
    label:SetText(L["COMING_SOON"])
    label:SetFullWidth(true)
    container:AddChild(label)
end