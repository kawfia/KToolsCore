-- KToolsAutoloot/ui/quick.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local CATEGORIES_LEFT = {
    { key = "reagents", label = "CATEGORY_REAGENTS" },
    { key = "recipes",  label = "CATEGORY_RECIPES" },
    { key = "mounts",   label = "CATEGORY_MOUNTS" },
    { key = "pets",     label = "CATEGORY_PETS" },
}

local CATEGORIES_RIGHT = {
    { key = "gold",     label = "CATEGORY_GOLD" },
    { key = "currency", label = "CATEGORY_CURRENCY" },
    { key = "artifact", label = "CATEGORY_ARTIFACT" },
    { key = "quest",    label = "CATEGORY_QUEST" },
}

local QUALITIES = {
    { q = 0, color = "|cff9d9d9d", name = "QUALITY_POOR" },
    { q = 1, color = "|cffffffff", name = "QUALITY_COMMON" },
    { q = 2, color = "|cff1eff00", name = "QUALITY_UNCOMMON" },
    { q = 3, color = "|cff0070dd", name = "QUALITY_RARE" },
    { q = 4, color = "|cffa335ee", name = "QUALITY_EPIC" },
    { q = 5, color = "|cffff8000", name = "QUALITY_LEGENDARY" },
}

local function addCategoryColumn(parent, cats, list)
    local col = AceGUI:Create("SimpleGroup")
    col:SetLayout("List")
    col:SetRelativeWidth(0.5)
    parent:AddChild(col)
    for _, cat in ipairs(list) do
        local key = cat.key
        local chk = AceGUI:Create("CheckBox")
        chk:SetLabel(L[cat.label])
        chk:SetValue(cats[key])
        chk:SetFullWidth(true)
        chk:SetCallback("OnValueChanged", function(_, _, val)
            cats[key] = val
        end)
        col:AddChild(chk)
    end
end

function AutoLoot:DrawQuickSettings(container)
    local catGroup = AceGUI:Create("InlineGroup")
    catGroup:SetTitle(L["CATEGORIES"])
    catGroup:SetLayout("Flow")
    catGroup:SetFullWidth(true)
    container:AddChild(catGroup)

    local cats = AutoLoot.db.profile.categories
    addCategoryColumn(catGroup, cats, CATEGORIES_LEFT)
    addCategoryColumn(catGroup, cats, CATEGORIES_RIGHT)

    local qualGroup = AceGUI:Create("InlineGroup")
    qualGroup:SetTitle(L["QUALITY_FILTER"])
    qualGroup:SetLayout("List")
    qualGroup:SetFullWidth(true)
    container:AddChild(qualGroup)

    local headerRow = AceGUI:Create("SimpleGroup")
    headerRow:SetLayout("Flow")
    headerRow:SetFullWidth(true)
    qualGroup:AddChild(headerRow)

    local hEnabled = AceGUI:Create("Label")
    hEnabled:SetText(L["QF_HDR_ENABLED"])
    hEnabled:SetWidth(195)
    headerRow:AddChild(hEnabled)

    local hIlvl = AceGUI:Create("Label")
    hIlvl:SetText(L["QF_HDR_ILVL"])
    hIlvl:SetWidth(90)
    headerRow:AddChild(hIlvl)

    local hBoe = AceGUI:Create("Label")
    hBoe:SetText(L["QF_HDR_BOE"])
    hBoe:SetWidth(75)
    headerRow:AddChild(hBoe)

    local hBop = AceGUI:Create("Label")
    hBop:SetText(L["QF_HDR_BOP"])
    hBop:SetWidth(75)
    headerRow:AddChild(hBop)

    local qdb = AutoLoot.db.profile.quality
    for _, info in ipairs(QUALITIES) do
        local q = info.q

        local row = AceGUI:Create("SimpleGroup")
        row:SetLayout("Flow")
        row:SetFullWidth(true)
        qualGroup:AddChild(row)

        local enabledChk = AceGUI:Create("CheckBox")
        enabledChk:SetLabel("")
        enabledChk:SetWidth(30)
        enabledChk:SetValue(qdb[q].enabled)
        enabledChk:SetCallback("OnValueChanged", function(_, _, val)
            qdb[q].enabled = val
        end)
        row:AddChild(enabledChk)

        local qualLbl = AceGUI:Create("Label")
        qualLbl:SetText(info.color .. L[info.name] .. "|r")
        qualLbl:SetWidth(165)
        row:AddChild(qualLbl)

        local ilvlBox = AceGUI:Create("EditBox")
        ilvlBox:SetLabel("")
        ilvlBox:SetText(tostring(qdb[q].ilvl))
        ilvlBox:SetWidth(90)
        ilvlBox:SetCallback("OnEnterPressed", function(_, _, val)
            qdb[q].ilvl = tonumber(val) or 0
            ilvlBox:SetText(tostring(qdb[q].ilvl))
        end)
        row:AddChild(ilvlBox)

        local boeChk = AceGUI:Create("CheckBox")
        boeChk:SetLabel("")
        boeChk:SetWidth(75)
        boeChk:SetValue(qdb[q].boe)
        boeChk:SetCallback("OnValueChanged", function(_, _, val)
            qdb[q].boe = val
        end)
        row:AddChild(boeChk)

        local bopChk = AceGUI:Create("CheckBox")
        bopChk:SetLabel("")
        bopChk:SetWidth(75)
        bopChk:SetValue(qdb[q].bop)
        bopChk:SetCallback("OnValueChanged", function(_, _, val)
            qdb[q].bop = val
        end)
        row:AddChild(bopChk)
    end
end