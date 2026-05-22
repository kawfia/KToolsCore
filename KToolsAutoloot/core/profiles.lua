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

function AutoLoot:RefreshModuleUI()
    KTools:ShowMainFrameWithModule(ADDON)
end

function AutoLoot:OpenExportDialog()
    local str = self:ExportProfile()

    local frame = AceGUI:Create("Frame")
    frame:SetTitle(L["EXPORT_TITLE"])
    frame:SetLayout("List")
    frame:SetWidth(600)
    frame:SetHeight(380)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local box = AceGUI:Create("MultiLineEditBox")
    box:SetLabel(L["EXPORT_BOX_LABEL"])
    box:SetNumLines(16)
    box:SetFullWidth(true)
    box:DisableButton(true)
    box:SetText(str)
    frame:AddChild(box)

    box:HighlightText()
    box:SetFocus()
end

function AutoLoot:OpenImportDialog()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(L["IMPORT_TITLE"])
    frame:SetLayout("List")
    frame:SetWidth(600)
    frame:SetHeight(450)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local statusLabel = AceGUI:Create("Label")
    statusLabel:SetFullWidth(true)
    statusLabel:SetText(" ")
    frame:AddChild(statusLabel)

    local box = AceGUI:Create("MultiLineEditBox")
    box:SetLabel(L["IMPORT_BOX_LABEL"])
    box:SetNumLines(14)
    box:SetFullWidth(true)
    box:DisableButton(true)
    frame:AddChild(box)

    local btn = AceGUI:Create("Button")
    btn:SetText(L["IMPORT_NOW"])
    btn:SetFullWidth(true)
    btn:SetCallback("OnClick", function()
        local ok = AutoLoot:ImportProfile(box:GetText())
        if ok then
            statusLabel:SetText(L["IMPORT_SUCCESS"])
            AutoLoot:RefreshModuleUI()
        else
            statusLabel:SetText(L["IMPORT_ERROR"])
        end
    end)
    frame:AddChild(btn)

    box:SetFocus()
end
