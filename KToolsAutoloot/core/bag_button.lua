-- KToolsAutoloot/ui/bag_button.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

local bagBtn

local function UpdateBagButtonState()
    if not bagBtn then return end
    local enabled = AutoLoot.db and AutoLoot.db.profile.options.autoOpen
    bagBtn:SetAlpha(enabled and 1.0 or 0.4)
end

local function OnBagButtonClick()
    if not AutoLoot.db then return end
    local db = AutoLoot.db.profile
    db.options.autoOpen = not db.options.autoOpen
    UpdateBagButtonState()
    if db.options.autoOpen then
        AutoLoot:ScanAndOpenContainer()
    end
end

function AutoLoot:SetupBagButton()
    bagBtn = CreateFrame("Button", "KToolsAutoLootBagBtn", ContainerFrame1)
    bagBtn:SetSize(16, 16)
    bagBtn:SetPoint("RIGHT", ContainerFrame1CloseButton, "LEFT", -4, 0)

    bagBtn:SetNormalTexture("Interface\\ICONS\\INV_Misc_Bag_07")
    bagBtn:GetNormalTexture():SetTexCoord(0.08, 0.92, 0.08, 0.92)

    bagBtn:SetPushedTexture("Interface\\ICONS\\INV_Misc_Bag_07")
    bagBtn:GetPushedTexture():SetTexCoord(0.08, 0.92, 0.08, 0.92)

    bagBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    bagBtn:GetHighlightTexture():SetBlendMode("ADD")

    bagBtn:SetScript("OnClick", OnBagButtonClick)
    bagBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["OPT_AUTO_OPEN"])
        GameTooltip:AddLine(L["BTN_BAG_AUTOOPEN_DESC"], 1, 1, 1, true)
        GameTooltip:Show()
    end)
    bagBtn:SetScript("OnLeave", GameTooltip_Hide)

    ContainerFrame1:HookScript("OnShow", UpdateBagButtonState)
    UpdateBagButtonState()
end