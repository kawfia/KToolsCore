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
    header:SetLayout("List")
    header:SetFullWidth(true)
    container:AddChild(header)

    local content = AceGUI:Create("SimpleGroup")
    content:SetLayout("List")
    content:SetFullWidth(true)
    container:AddChild(content)

    local topRow = AceGUI:Create("SimpleGroup")
    topRow:SetLayout("Flow")
    topRow:SetFullWidth(true)
    header:AddChild(topRow)

    local enabledChk = AceGUI:Create("CheckBox")
    enabledChk:SetLabel(L["ENABLED"])
    enabledChk:SetValue(AutoLoot.db.profile.enabled)
    enabledChk:SetRelativeWidth(0.65)
    enabledChk:SetCallback("OnValueChanged", function(_, _, val)
        AutoLoot.db.profile.enabled = val
    end)
    topRow:AddChild(enabledChk)

    local switchBtn = AceGUI:Create("Button")
    switchBtn:SetText(L["VIEW_CUSTOM"])
    switchBtn:SetRelativeWidth(0.35)
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
    topRow:AddChild(switchBtn)

    local bottomRow = AceGUI:Create("SimpleGroup")
    bottomRow:SetLayout("Flow")
    bottomRow:SetFullWidth(true)
    header:AddChild(bottomRow)

    local profileDrop = AceGUI:Create("Dropdown")
    profileDrop:SetLabel(L["PROFILE"])
    profileDrop:SetWidth(120)
    profileDrop:SetList({})
    bottomRow:AddChild(profileDrop)

    local createBtn = AceGUI:Create("Button")
    createBtn:SetText(L["PROFILE_CREATE"])
    createBtn:SetWidth(80)
    bottomRow:AddChild(createBtn)

    local deleteDrop = AceGUI:Create("Dropdown")
    deleteDrop:SetLabel(L["PROFILE_DELETE"])
    deleteDrop:SetWidth(120)
    deleteDrop:SetList({})
    bottomRow:AddChild(deleteDrop)

    local spacer = AceGUI:Create("Label")
    spacer:SetText(" ")
    spacer:SetRelativeWidth(0.35)
    bottomRow:AddChild(spacer)

    local importBtn = AceGUI:Create("Button")
    importBtn:SetText(L["IMPORT"])
    importBtn:SetWidth(90)
    bottomRow:AddChild(importBtn)

    local exportBtn = AceGUI:Create("Button")
    exportBtn:SetText(L["EXPORT"])
    exportBtn:SetWidth(90)
    bottomRow:AddChild(exportBtn)

    AutoLoot:DrawQuickSettings(content)
end