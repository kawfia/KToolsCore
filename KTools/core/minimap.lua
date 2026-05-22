-- KTools/core/minimap.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)
local LDB = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

local menuFrame = CreateFrame("Frame", ADDON .. "MinimapMenu", UIParent, "UIDropDownMenuTemplate")

local ldbObject = LDB:NewDataObject(ADDON, {
    type = "launcher",
    icon = "Interface\\AddOns\\" .. ADDON .. "\\media\\minimapButton_dx5",
    OnClick = function(self, button)
        if button == "LeftButton" then
            KTools:ToggleMainFrame()
        elseif button == "RightButton" then
            local mods = KTools:GetModules()
            local menuList = {}
            for _, entry in ipairs(mods) do
                local name = entry.name
                local label = entry.label
                tinsert(menuList, {
                    text        = label,
                    func        = function()
                        KTools:ShowMainFrameWithModule(name)
                    end,
                    notCheckable = true,
                })
            end
            EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU")
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine(ADDON)
        tooltip:AddLine(L["MINIMAP_HINT"], 1, 1, 1)
    end,
})

function KTools:SetupMinimap()
    LibDBIcon:Register(ADDON, ldbObject, self.db.profile.minimap)
end

function KTools:SetMinimapVisible(visible)
    if visible then
        LibDBIcon:Show(ADDON)
    else
        LibDBIcon:Hide(ADDON)
    end
end