-- KToolsAutoloot/ui/main.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local currentView = "quick"

function AutoLoot:Draw(container)
    container:SetLayout("List")
    currentView = "quick"

    local header = AceGUI:Create("SimpleGroup")
    header:SetLayout("Flow")
    header:SetFullWidth(true)
    container:AddChild(header)

    local content = AceGUI:Create("SimpleGroup")
    content:SetLayout("Flow")
    content:SetFullWidth(true)
    container:AddChild(content)

    local enabledChk = AceGUI:Create("CheckBox")
    enabledChk:SetLabel(L["ENABLED"])
    enabledChk:SetValue(AutoLoot.db.profile.enabled)
    enabledChk:SetWidth(130)
    enabledChk:SetCallback("OnValueChanged", function(_, _, val)
        AutoLoot.db.profile.enabled = val
    end)
    header:AddChild(enabledChk)

    local profileDrop = AceGUI:Create("Dropdown")
    profileDrop:SetLabel(L["PROFILE"])
    profileDrop:SetWidth(120)
    profileDrop:SetList({})
    header:AddChild(profileDrop)

    local createBtn = AceGUI:Create("Button")
    createBtn:SetText(L["PROFILE_CREATE"])
    createBtn:SetWidth(80)
    header:AddChild(createBtn)

    local deleteDrop = AceGUI:Create("Dropdown")
    deleteDrop:SetLabel(L["PROFILE_DELETE"])
    deleteDrop:SetWidth(120)
    deleteDrop:SetList({})
    header:AddChild(deleteDrop)

    local importBtn = AceGUI:Create("Button")
    importBtn:SetText(L["IMPORT"])
    importBtn:SetWidth(80)
    header:AddChild(importBtn)

    local exportBtn = AceGUI:Create("Button")
    exportBtn:SetText(L["EXPORT"])
    exportBtn:SetWidth(80)
    header:AddChild(exportBtn)

    local switchBtn = AceGUI:Create("Button")
    switchBtn:SetText(L["VIEW_CUSTOM"])
    switchBtn:SetWidth(160)
    switchBtn:SetCallback("OnClick", function()
        content:ReleaseChildren()
        if currentView == "quick" then
            currentView = "custom"
            switchBtn:SetText(L["VIEW_QUICK"])
            AutoLoot:DrawCustomList(content)
        else
            currentView = "quick"
            switchBtn:SetText(L["VIEW_CUSTOM"])
            AutoLoot:DrawQuickSettings(content)
        end
    end)
    header:AddChild(switchBtn)

    AutoLoot:DrawQuickSettings(content)
end