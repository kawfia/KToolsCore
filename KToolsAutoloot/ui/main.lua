-- KToolsAutoloot/ui/main.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local currentView = "quick"

local function buildProfileMap(db)
    local t, list = {}, {}
    db:GetProfiles(list)
    for _, name in ipairs(list) do t[name] = name end
    return t
end

local function buildDeleteMap(db)
    local t, list = {}, {}
    db:GetProfiles(list)
    local current = db:GetCurrentProfile()
    for _, name in ipairs(list) do
        if name ~= current then t[name] = name end
    end
    return t
end

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

    -- Row 1: enabled checkbox + view switch
    local topRow = AceGUI:Create("SimpleGroup")
    topRow:SetLayout("Flow")
    topRow:SetFullWidth(true)
    header:AddChild(topRow)

    local enabledChk = AceGUI:Create("CheckBox")
    enabledChk:SetLabel(L["ENABLED"])
    enabledChk:SetValue(AutoLoot.db.profile.enabled)
    enabledChk:SetWidth(160)
    enabledChk:SetCallback("OnValueChanged", function(_, _, val)
        AutoLoot.db.profile.enabled = val
    end)
    topRow:AddChild(enabledChk)

    local topSpacer = AceGUI:Create("Label")
    topSpacer:SetText("")
    topSpacer:SetRelativeWidth(0.3)
    topRow:AddChild(topSpacer)

    local switchBtn = AceGUI:Create("Button")
    switchBtn:SetText(L["VIEW_CUSTOM"])
    switchBtn:SetWidth(200)
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

    -- Row 2: profiles | import/export
    local bottomRow = AceGUI:Create("SimpleGroup")
    bottomRow:SetLayout("Flow")
    bottomRow:SetFullWidth(true)
    header:AddChild(bottomRow)

    local profileGroup = AceGUI:Create("SimpleGroup")
    profileGroup:SetLayout("Flow")
    profileGroup:SetRelativeWidth(0.65)
    bottomRow:AddChild(profileGroup)

    local profileDrop = AceGUI:Create("Dropdown")
    profileDrop:SetLabel(L["PROFILE"])
    profileDrop:SetWidth(140)
    profileDrop:SetList(buildProfileMap(AutoLoot.db))
    profileDrop:SetValue(AutoLoot.db:GetCurrentProfile())
    profileDrop:SetCallback("OnValueChanged", function(_, _, name)
        AutoLoot.db:SetProfile(name)
        AutoLoot:RefreshModuleUI()
    end)
    profileGroup:AddChild(profileDrop)

    local createBtn = AceGUI:Create("Button")
    createBtn:SetText(L["PROFILE_CREATE"])
    createBtn:SetWidth(80)
    createBtn:SetCallback("OnClick", function()
        StaticPopupDialogs["KTOOLSAUTOLOOT_CREATE_PROFILE"] = {
            text        = L["PROFILE_CREATE_PROMPT"],
            button1     = ACCEPT,
            button2     = CANCEL,
            hasEditBox  = 1,
            maxLetters  = 50,
            OnAccept    = function(dialog)
                local name = dialog.editBox:GetText()
                if name and name ~= "" then
                    AutoLoot.db:SetProfile(name)
                    AutoLoot:RefreshModuleUI()
                end
            end,
            timeout = 0, whileDead = 1, hideOnEscape = 1,
        }
        StaticPopup_Show("KTOOLSAUTOLOOT_CREATE_PROFILE")
    end)
    profileGroup:AddChild(createBtn)

    local deleteDrop = AceGUI:Create("Dropdown")
    deleteDrop:SetLabel(L["PROFILE_DELETE"])
    deleteDrop:SetWidth(140)
    deleteDrop:SetList(buildDeleteMap(AutoLoot.db))
    deleteDrop:SetCallback("OnValueChanged", function(_, _, name)
        AutoLoot.db:DeleteProfile(name)
        AutoLoot:RefreshModuleUI()
    end)
    profileGroup:AddChild(deleteDrop)

    local actionGroup = AceGUI:Create("SimpleGroup")
    actionGroup:SetLayout("Flow")
    actionGroup:SetRelativeWidth(0.35)
    bottomRow:AddChild(actionGroup)

    local importBtn = AceGUI:Create("Button")
    importBtn:SetText(L["IMPORT"])
    importBtn:SetWidth(90)
    importBtn:SetCallback("OnClick", function()
        AutoLoot:OpenImportDialog()
    end)
    actionGroup:AddChild(importBtn)

    local exportBtn = AceGUI:Create("Button")
    exportBtn:SetText(L["EXPORT"])
    exportBtn:SetWidth(90)
    exportBtn:SetCallback("OnClick", function()
        AutoLoot:OpenExportDialog()
    end)
    actionGroup:AddChild(exportBtn)

    AutoLoot:DrawQuickSettings(content)
end
