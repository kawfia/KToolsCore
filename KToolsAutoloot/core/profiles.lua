-- KToolsAutoloot/core/profiles.lua
local ADDON = ...
local AutoLoot      = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local AceGUI        = LibStub("AceGUI-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")
local LibDeflate    = LibStub("LibDeflate")
local L             = LibStub("AceLocale-3.0"):GetLocale(ADDON)

function AutoLoot:ExportProfile()
    local serialized = AceSerializer:Serialize(self.db.profile)
    local compressed = LibDeflate:CompressDeflate(serialized)
    return LibDeflate:EncodeForPrint(compressed)
end

function AutoLoot:ImportProfile(str)
    local decoded = LibDeflate:DecodeForPrint(str)
    if not decoded then return false end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return false end
    local ok, data = AceSerializer:Deserialize(decompressed)
    if not ok or type(data) ~= "table" then return false end
    for k, v in pairs(data) do
        self.db.profile[k] = v
    end
    return true
end

function AutoLoot:ValidateImportString(str)
    local decoded = LibDeflate:DecodeForPrint(str)
    if not decoded then return false end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return false end
    local ok, data = AceSerializer:Deserialize(decompressed)
    return ok and type(data) == "table"
end

function AutoLoot:RefreshModuleUI()
    KTools:ShowMainFrameWithModule(ADDON)
end

function AutoLoot:OpenExportDialog()
    local exportString = ""

    local frame = AceGUI:Create("Frame")
    frame:SetTitle(L["EXPORT_TITLE"])
    frame:SetLayout("flow")
    frame:SetWidth(800)
    frame:SetHeight(500)
    frame:SetCallback("OnClose", function(widget)
        exportString = ""
        AceGUI:Release(widget)
    end)

    local box = AceGUI:Create("MultiLineEditBox")
    box:SetLabel("")
    box:SetNumLines(22)
    box:SetWidth(780)
    box:DisableButton(true)
    frame:AddChild(box)

    local statusLabel = AceGUI:Create("Label")
    statusLabel:SetWidth(780)
    statusLabel:SetText(" ")
    frame:AddChild(statusLabel)

    local exportBtn = AceGUI:Create("Button")
    exportBtn:SetText(L["EXPORT_NOW"])
    exportBtn:SetAutoWidth(true)
    exportBtn:SetCallback("OnClick", function()
        exportString = AutoLoot:ExportProfile()
        box:SetText(exportString)
        box.editBox:HighlightText()
        box:SetFocus()
        statusLabel:SetText(L["EXPORT_STATUS"])
    end)
    frame:AddChild(exportBtn)

    box.editBox:HookScript("OnChar", function(self)
        if exportString ~= "" then
            self:SetText(exportString)
            self:HighlightText()
        end
    end)
end

function AutoLoot:OpenImportDialog()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(L["IMPORT_TITLE"])
    frame:SetLayout("flow")
    frame:SetWidth(800)
    frame:SetHeight(500)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local box = AceGUI:Create("MultiLineEditBox")
    box:SetLabel("")
    box:SetNumLines(22)
    box:SetWidth(780)
    box:DisableButton(true)
    frame:AddChild(box)

    local statusLabel = AceGUI:Create("Label")
    statusLabel:SetWidth(780)
    statusLabel:SetText(" ")
    frame:AddChild(statusLabel)

    local importBtn = AceGUI:Create("Button")
    importBtn:SetText(L["IMPORT_NOW"])
    importBtn:SetAutoWidth(true)
    importBtn:SetCallback("OnClick", function()
        local ok = AutoLoot:ImportProfile(box:GetText())
        if ok then
            statusLabel:SetText(L["IMPORT_SUCCESS"])
            AutoLoot:RefreshModuleUI()
        else
            statusLabel:SetText(L["IMPORT_ERROR"])
        end
    end)
    frame:AddChild(importBtn)

    local decodeBtn = AceGUI:Create("Button")
    decodeBtn:SetText(L["DECODE_BTN"])
    decodeBtn:SetAutoWidth(true)
    decodeBtn:SetCallback("OnClick", function()
        if AutoLoot:ValidateImportString(box:GetText()) then
            statusLabel:SetText(L["DECODE_OK"])
        else
            statusLabel:SetText(L["IMPORT_ERROR"])
        end
    end)
    frame:AddChild(decodeBtn)

    box:SetFocus()
end
