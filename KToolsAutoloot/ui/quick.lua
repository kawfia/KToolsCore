-- KToolsAutoloot/ui/quick.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local CATEGORIES = {
    { key = "gold",     label = "CATEGORY_GOLD" },
    { key = "reagents", label = "CATEGORY_REAGENTS" },
    { key = "recipes",  label = "CATEGORY_RECIPES" },
    { key = "mounts",   label = "CATEGORY_MOUNTS" },
    { key = "pets",     label = "CATEGORY_PETS" },
    { key = "quest",    label = "CATEGORY_QUEST" },
    { key = "currency", label = "CATEGORY_CURRENCY" },
    { key = "artifact", label = "CATEGORY_ARTIFACT" },
}

local QUALITIES = {
    { q = 0, color = "|cff9d9d9d", name = "QUALITY_POOR" },
    { q = 1, color = "|cffffffff", name = "QUALITY_COMMON" },
    { q = 2, color = "|cff1eff00", name = "QUALITY_UNCOMMON" },
    { q = 3, color = "|cff0070dd", name = "QUALITY_RARE" },
    { q = 4, color = "|cffa335ee", name = "QUALITY_EPIC" },
    { q = 5, color = "|cffff8000", name = "QUALITY_LEGENDARY" },
}

local BINDS = {
    { key = "nob", label = "BIND_NOB" },
    { key = "boe", label = "BIND_BOE" },
    { key = "bop", label = "BIND_BOP" },
}

function AutoLoot:DrawQuickSettings(container)
    local catGroup = AceGUI:Create("InlineGroup")
    catGroup:SetTitle(L["CATEGORIES"])
    catGroup:SetLayout("Flow")
    catGroup:SetFullWidth(true)
    container:AddChild(catGroup)

    local cats = AutoLoot.db.profile.categories
    for _, cat in ipairs(CATEGORIES) do
        local key = cat.key
        local chk = AceGUI:Create("CheckBox")
        chk:SetLabel(L[cat.label])
        chk:SetValue(cats[key])
        chk:SetWidth(160)
        chk:SetCallback("OnValueChanged", function(_, _, val)
            cats[key] = val
        end)
        catGroup:AddChild(chk)
    end

    local qualGroup = AceGUI:Create("InlineGroup")
    qualGroup:SetTitle(L["QUALITY_FILTER"])
    qualGroup:SetLayout("List")
    qualGroup:SetFullWidth(true)
    container:AddChild(qualGroup)

    local qdb = AutoLoot.db.profile.quality
    for _, info in ipairs(QUALITIES) do
        local q = info.q

        local row = AceGUI:Create("SimpleGroup")
        row:SetLayout("Flow")
        row:SetFullWidth(true)
        qualGroup:AddChild(row)

        local rowChk = AceGUI:Create("CheckBox")
        rowChk:SetLabel(info.color .. L[info.name] .. "|r")
        rowChk:SetValue(qdb[q].enabled)
        rowChk:SetWidth(130)
        rowChk:SetCallback("OnValueChanged", function(_, _, val)
            qdb[q].enabled = val
        end)
        row:AddChild(rowChk)

        local ilvlBox = AceGUI:Create("EditBox")
        ilvlBox:SetLabel("ilvl >=")
        ilvlBox:SetText(tostring(qdb[q].ilvl))
        ilvlBox:SetWidth(80)
        ilvlBox:SetCallback("OnEnterPressed", function(_, _, val)
            qdb[q].ilvl = tonumber(val) or 0
            ilvlBox:SetText(tostring(qdb[q].ilvl))
        end)
        row:AddChild(ilvlBox)

        for _, bind in ipairs(BINDS) do
            local bkey = bind.key
            local bindChk = AceGUI:Create("CheckBox")
            bindChk:SetLabel(L[bind.label])
            bindChk:SetValue(qdb[q][bkey])
            bindChk:SetWidth(80)
            bindChk:SetCallback("OnValueChanged", function(_, _, val)
                qdb[q][bkey] = val
            end)
            row:AddChild(bindChk)
        end
    end
end