-- KToolsAutoloot/ui/custom.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI  = LibStub("AceGUI-3.0")
local L       = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local QUALITY_COLORS = {
    [0] = "|cff9d9d9d",
    [1] = "|cffffffff",
    [2] = "|cff1eff00",
    [3] = "|cff0070dd",
    [4] = "|cffa335ee",
    [5] = "|cffff8000",
}

local filterByEnabled = false

local function extractId(text)
    return tonumber(text) or tonumber(string.match(text or "", "item:(%d+)"))
end

local function redrawList(scrollFrame)
    scrollFrame:ReleaseChildren()
    local cl = AutoLoot.db.profile.customList

    local hdr = AceGUI:Create("SimpleGroup")
    hdr:SetLayout("Flow")
    hdr:SetFullWidth(true)
    scrollFrame:AddChild(hdr)

    local hCollect = AceGUI:Create("Label")
    hCollect:SetText(L["CL_HDR_COLLECT"])
    hCollect:SetWidth(35)
    hdr:AddChild(hCollect)

    local hDia = AceGUI:Create("Label")
    hDia:SetText("")
    hDia:SetWidth(22)
    hdr:AddChild(hDia)

    local hId = AceGUI:Create("Label")
    hId:SetText(L["CL_HDR_ID"])
    hId:SetWidth(70)
    hdr:AddChild(hId)

    local hItem = AceGUI:Create("Label")
    hItem:SetText(L["CL_HDR_ITEM"])
    hItem:SetRelativeWidth(0.5)
    hdr:AddChild(hItem)

    local hIlvl = AceGUI:Create("Label")
    hIlvl:SetText(L["CL_HDR_ILVL"])
    hIlvl:SetWidth(55)
    hdr:AddChild(hIlvl)

    local hDel = AceGUI:Create("Label")
    hDel:SetText(L["CL_HDR_DEL"])
    hDel:SetWidth(35)
    hdr:AddChild(hDel)

    local ids = {}
    for id in pairs(cl) do tinsert(ids, id) end
    table.sort(ids)

    for _, id in ipairs(ids) do
        local entry = cl[id]
        if not filterByEnabled or entry.enabled then
            local name, _, quality = GetItemInfo(id)
            name = name or ("id:" .. id)
            local color = QUALITY_COLORS[quality] or "|cff888888"

            local row = AceGUI:Create("SimpleGroup")
            row:SetLayout("Flow")
            row:SetFullWidth(true)
            scrollFrame:AddChild(row)

            local chk = AceGUI:Create("CheckBox")
            chk:SetLabel("")
            chk:SetWidth(35)
            chk:SetValue(entry.enabled)
            chk:SetCallback("OnValueChanged", function(_, _, val)
                cl[id].enabled = val
            end)
            row:AddChild(chk)

            local dia = AceGUI:Create("Label")
            dia:SetText(color .. L["CL_ICON_QUALITY"] .. "|r")
            dia:SetWidth(22)
            row:AddChild(dia)

            local idLbl = AceGUI:Create("Label")
            idLbl:SetText(tostring(id))
            idLbl:SetWidth(70)
            row:AddChild(idLbl)

            local nameLbl = AceGUI:Create("Label")
            nameLbl:SetText(name)
            nameLbl:SetRelativeWidth(0.5)
            row:AddChild(nameLbl)

            local ilvlBox = AceGUI:Create("EditBox")
            ilvlBox:SetLabel("")
            ilvlBox:DisableButton(true)
            ilvlBox:SetText(entry.ilvl > 0 and tostring(entry.ilvl) or "")
            ilvlBox:SetWidth(55)
            ilvlBox:SetCallback("OnEnterPressed", function(_, _, val)
                cl[id].ilvl = tonumber(val) or 0
                ilvlBox:SetText(cl[id].ilvl > 0 and tostring(cl[id].ilvl) or "")
            end)
            row:AddChild(ilvlBox)

            local delBtn = AceGUI:Create("Button")
            delBtn:SetText(L["CL_BTN_DEL"])
            delBtn:SetWidth(35)
            delBtn:SetCallback("OnClick", function()
                cl[id] = nil
                redrawList(scrollFrame)
            end)
            row:AddChild(delBtn)
        end
    end
end

function AutoLoot:DrawCustomList(container)
    container:SetLayout("List")
    filterByEnabled = false

    local cl = AutoLoot.db.profile.customList

    -- Секция добавления (InlineGroup — паттерн как в quick.lua)
    local addGroup = AceGUI:Create("InlineGroup")
    addGroup:SetTitle(L["CL_ADD_TITLE"])
    addGroup:SetLayout("List")
    addGroup:SetFullWidth(true)
    container:AddChild(addGroup)

    local addHdr = AceGUI:Create("SimpleGroup")
    addHdr:SetLayout("Flow")
    addHdr:SetFullWidth(true)
    addGroup:AddChild(addHdr)

    local aHFilter = AceGUI:Create("Label")
    aHFilter:SetText("")
    aHFilter:SetWidth(35)
    addHdr:AddChild(aHFilter)

    local aHId = AceGUI:Create("Label")
    aHId:SetText(L["CL_HDR_ID"])
    aHId:SetWidth(70)
    addHdr:AddChild(aHId)

    local aHItem = AceGUI:Create("Label")
    aHItem:SetText(L["CL_HDR_ITEM"])
    aHItem:SetRelativeWidth(0.55)
    addHdr:AddChild(aHItem)

    local aHIlvl = AceGUI:Create("Label")
    aHIlvl:SetText(L["CL_HDR_ILVL"])
    aHIlvl:SetWidth(55)
    addHdr:AddChild(aHIlvl)

    local aHBtn = AceGUI:Create("Label")
    aHBtn:SetText("")
    aHBtn:SetWidth(80)
    addHdr:AddChild(aHBtn)

    local addRow = AceGUI:Create("SimpleGroup")
    addRow:SetLayout("Flow")
    addRow:SetFullWidth(true)
    addGroup:AddChild(addRow)

    local filterChk = AceGUI:Create("CheckBox")
    filterChk:SetLabel("")
    filterChk:SetWidth(35)
    filterChk:SetValue(false)
    addRow:AddChild(filterChk)

    local idInput = AceGUI:Create("EditBox")
    idInput:SetLabel("")
    idInput:DisableButton(true)
    idInput:SetWidth(70)
    addRow:AddChild(idInput)

    local nameInput = AceGUI:Create("EditBox")
    nameInput:SetLabel("")
    nameInput:DisableButton(true)
    nameInput:SetRelativeWidth(0.55)
    addRow:AddChild(nameInput)

    local ilvlInput = AceGUI:Create("EditBox")
    ilvlInput:SetLabel("")
    ilvlInput:DisableButton(true)
    ilvlInput:SetWidth(55)
    addRow:AddChild(ilvlInput)

    local addBtn = AceGUI:Create("Button")
    addBtn:SetText(L["CL_BTN_ADD"])
    addBtn:SetWidth(80)
    addRow:AddChild(addBtn)

    local scrollFrame = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("List")
    scrollFrame:SetFullWidth(true)
    scrollFrame:SetHeight(280)
    container:AddChild(scrollFrame)

    local function doAdd()
        local ilvl = tonumber(ilvlInput:GetText()) or 0

        local idNum = extractId(idInput:GetText())
        if idNum then
            if not cl[idNum] then
                cl[idNum] = { enabled = true, ilvl = ilvl }
            end
            idInput:SetText("")
            nameInput:SetText("")
            ilvlInput:SetText("")
            redrawList(scrollFrame)
            return
        end

        local nameText = nameInput:GetText()
        if nameText and nameText ~= "" then
            local linkedId = extractId(nameText)
            if linkedId then
                if not cl[linkedId] then
                    cl[linkedId] = { enabled = true, ilvl = ilvl }
                end
                idInput:SetText("")
                nameInput:SetText("")
                ilvlInput:SetText("")
                redrawList(scrollFrame)
                return
            end

            local _, link = GetItemInfo(nameText)
            if link then
                local foundId = extractId(link)
                if foundId and not cl[foundId] then
                    cl[foundId] = { enabled = true, ilvl = ilvl }
                    idInput:SetText("")
                    nameInput:SetText("")
                    ilvlInput:SetText("")
                    redrawList(scrollFrame)
                    return
                end
            end
            print(L["CL_ITEM_NOT_FOUND"] .. nameText)
        end
    end

    filterChk:SetCallback("OnValueChanged", function(_, _, val)
        filterByEnabled = val
        redrawList(scrollFrame)
    end)

    idInput:SetCallback("OnEnterPressed", function(_, _, val)
        local id = extractId(val)
        if id then
            idInput:SetText(tostring(id))
            local name = GetItemInfo(id)
            if name then nameInput:SetText(name) end
        end
        doAdd()
    end)

    addBtn:SetCallback("OnClick", doAdd)

    redrawList(scrollFrame)
end
