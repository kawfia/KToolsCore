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

local function redrawList(listGroup)
    listGroup:ReleaseChildren()
    local cl = AutoLoot.db.profile.customList

    local hdr = AceGUI:Create("SimpleGroup")
    hdr:SetLayout("Flow")
    hdr:SetFullWidth(true)
    listGroup:AddChild(hdr)

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
            listGroup:AddChild(row)

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
                redrawList(listGroup)
            end)
            row:AddChild(delBtn)
        end
    end
end

function AutoLoot:DrawCustomList(container)
    container:SetLayout("List")
    filterByEnabled = false

    local cl = AutoLoot.db.profile.customList

    local bar = AceGUI:Create("SimpleGroup")
    bar:SetLayout("Flow")
    bar:SetFullWidth(true)
    container:AddChild(bar)

    local filterChk = AceGUI:Create("CheckBox")
    filterChk:SetLabel("")
    filterChk:SetWidth(35)
    filterChk:SetValue(false)
    bar:AddChild(filterChk)

    local idInput = AceGUI:Create("EditBox")
    idInput:SetLabel("")
    idInput:SetWidth(70)
    bar:AddChild(idInput)

    local nameInput = AceGUI:Create("EditBox")
    nameInput:SetLabel("")
    nameInput:SetRelativeWidth(0.5)
    bar:AddChild(nameInput)

    local ilvlInput = AceGUI:Create("EditBox")
    ilvlInput:SetLabel("")
    ilvlInput:SetWidth(55)
    bar:AddChild(ilvlInput)

    local addChk = AceGUI:Create("CheckBox")
    addChk:SetLabel("")
    addChk:SetWidth(35)
    addChk:SetValue(false)
    bar:AddChild(addChk)

    local listGroup = AceGUI:Create("SimpleGroup")
    listGroup:SetLayout("List")
    listGroup:SetFullWidth(true)
    container:AddChild(listGroup)

    filterChk:SetCallback("OnValueChanged", function(_, _, val)
        filterByEnabled = val
        redrawList(listGroup)
    end)

    -- ID field: принимает число или item-ссылку, автозаполняет Название
    idInput:SetCallback("OnEnterPressed", function(_, _, val)
        local id = extractId(val)
        if id then
            idInput:SetText(tostring(id))
            local name = GetItemInfo(id)
            if name then nameInput:SetText(name) end
        end
    end)

    addChk:SetCallback("OnValueChanged", function(_, _, val)
        if not val then return end
        addChk:SetValue(false)

        local ilvl = tonumber(ilvlInput:GetText()) or 0

        -- 1. ID field: число или ссылка
        local idNum = extractId(idInput:GetText())
        if idNum then
            if not cl[idNum] then
                cl[idNum] = { enabled = true, ilvl = ilvl }
            end
            idInput:SetText("")
            nameInput:SetText("")
            ilvlInput:SetText("")
            redrawList(listGroup)
            return
        end

        -- 2. Название field: ссылка → извлечь ID
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
                redrawList(listGroup)
                return
            end

            -- 3. GetItemInfo(name) — только кэшированные предметы
            local _, link = GetItemInfo(nameText)
            if link then
                local foundId = extractId(link)
                if foundId and not cl[foundId] then
                    cl[foundId] = { enabled = true, ilvl = ilvl }
                    idInput:SetText("")
                    nameInput:SetText("")
                    ilvlInput:SetText("")
                    redrawList(listGroup)
                    return
                end
            end
            print(L["CL_ITEM_NOT_FOUND"] .. nameText)
        end
    end)

    redrawList(listGroup)
end