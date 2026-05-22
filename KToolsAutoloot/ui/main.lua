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

    -- Row 1: enabled + view switch
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

    -- Row 2: [Новый EditBox] [Активный Dropdown] [Удалить Dropdown] [spacer] [Импорт] [Экспорт]
    local profileRow = AceGUI:Create("SimpleGroup")
    profileRow:SetLayout("Flow")
    profileRow:SetFullWidth(true)
    header:AddChild(profileRow)

    -- Новый: EditBox с placeholder
    local newBox = AceGUI:Create("EditBox")
    newBox:SetLabel(L["PROFILE_NEW"])
    newBox:SetWidth(160)
    newBox:SetText(L["PROFILE_NEW_PLACEHOLDER"])
    newBox.editbox:SetTextColor(0.5, 0.5, 0.5)

    local isPlaceholder = true
    newBox.editbox:HookScript("OnEditFocusGained", function(self)
        if isPlaceholder then
            self:SetText("")
            self:SetTextColor(1, 1, 1)
            isPlaceholder = false
        end
    end)
    newBox.editbox:HookScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then
            self:SetText(L["PROFILE_NEW_PLACEHOLDER"])
            self:SetTextColor(0.5, 0.5, 0.5)
            isPlaceholder = true
        end
    end)
    newBox:SetCallback("OnEnterPressed", function(_, _, text)
        if not isPlaceholder and text ~= "" then
            AutoLoot.db:SetProfile(text)
            AutoLoot:RefreshModuleUI()
        end
        newBox:ClearFocus()
    end)
    profileRow:AddChild(newBox)

    -- Активный: Dropdown переключения профиля
    local activeDrop = AceGUI:Create("Dropdown")
    activeDrop:SetLabel(L["PROFILE_ACTIVE"])
    activeDrop:SetWidth(140)
    activeDrop:SetList(buildProfileMap(AutoLoot.db))
    activeDrop:SetValue(AutoLoot.db:GetCurrentProfile())
    activeDrop:SetCallback("OnValueChanged", function(_, _, name)
        AutoLoot.db:SetProfile(name)
        AutoLoot:RefreshModuleUI()
    end)
    profileRow:AddChild(activeDrop)

    -- Удалить: Dropdown с подтверждением
    local deleteDrop = AceGUI:Create("Dropdown")
    deleteDrop:SetLabel(L["PROFILE_DELETE"])
    deleteDrop:SetWidth(140)
    deleteDrop:SetList(buildDeleteMap(AutoLoot.db))
    deleteDrop:SetCallback("OnValueChanged", function(_, _, name)
        StaticPopupDialogs["KTOOLSAUTOLOOT_DELETE_PROFILE"] = {
            text    = string.format(L["PROFILE_DELETE_CONFIRM"], name),
            button1 = ACCEPT,
            button2 = CANCEL,
            OnAccept = function()
                AutoLoot.db:DeleteProfile(name)
                AutoLoot:RefreshModuleUI()
            end,
            timeout = 0, whileDead = 1, hideOnEscape = 1,
        }
        StaticPopup_Show("KTOOLSAUTOLOOT_DELETE_PROFILE")
    end)
    profileRow:AddChild(deleteDrop)

    local rowSpacer = AceGUI:Create("Label")
    rowSpacer:SetText("")
    rowSpacer:SetRelativeWidth(0.05)
    profileRow:AddChild(rowSpacer)

    -- Кнопки импорт/экспорт без метки — выровнены по высоте с дропдаунами через Label-заглушку
    local importGroup = AceGUI:Create("SimpleGroup")
    importGroup:SetLayout("List")
    importGroup:SetWidth(90)
    profileRow:AddChild(importGroup)

    local importLbl = AceGUI:Create("Label")
    importLbl:SetText(" ")
    importLbl:SetFullWidth(true)
    importGroup:AddChild(importLbl)

    local importBtn = AceGUI:Create("Button")
    importBtn:SetText(L["IMPORT"])
    importBtn:SetFullWidth(true)
    importBtn:SetCallback("OnClick", function()
        AutoLoot:OpenImportDialog()
    end)
    importGroup:AddChild(importBtn)

    local exportGroup = AceGUI:Create("SimpleGroup")
    exportGroup:SetLayout("List")
    exportGroup:SetWidth(90)
    profileRow:AddChild(exportGroup)

    local exportLbl = AceGUI:Create("Label")
    exportLbl:SetText(" ")
    exportLbl:SetFullWidth(true)
    exportGroup:AddChild(exportLbl)

    local exportBtn = AceGUI:Create("Button")
    exportBtn:SetText(L["EXPORT"])
    exportBtn:SetFullWidth(true)
    exportBtn:SetCallback("OnClick", function()
        AutoLoot:OpenExportDialog()
    end)
    exportGroup:AddChild(exportBtn)

    AutoLoot:DrawQuickSettings(content)
end