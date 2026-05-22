-- KToolsAutoloot/core/engine.lua
local ADDON = ...
local AutoLoot = LibStub("AceAddon-3.0"):GetAddon(ADDON)

local LOOT_SLOT_ITEM     = 1
local LOOT_SLOT_CURRENCY = 2
local LOOT_SLOT_MONEY    = 3

local CLASS_REAGENT    = 5
local CLASS_TRADEGOOD  = 7
local CLASS_RECIPE     = 9
local CLASS_QUEST      = 12
local CLASS_MISC       = 15
local CLASS_BATTLE_PET = 17

local SUBCLASS_MISC_PET   = 2
local SUBCLASS_MISC_MOUNT = 5

local BIND_NONE   = 0
local BIND_PICKUP = 1
local BIND_EQUIP  = 2
local BIND_QUEST  = 4

local skinningSpellName
local lootOpen         = false
local lootingContainer = false

local scanTooltip = CreateFrame("GameTooltip", "KToolsAutoLootScanTooltip", UIParent, "GameTooltipTemplate")
scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function IsArtifactPower(link)
    if not ARTIFACT_POWER then return false end
    scanTooltip:ClearLines()
    scanTooltip:SetHyperlink(link)
    for i = 2, scanTooltip:NumLines() do
        local line = _G["KToolsAutoLootScanTooltipTextLeft" .. i]
        local text = line and line:GetText()
        if text and string.find(text, ARTIFACT_POWER, 1, true) then
            return true
        end
    end
    return false
end

local function ShouldLoot(i, db)
    local slotType = GetLootSlotType(i)
    local cats     = db.categories

    if slotType == LOOT_SLOT_MONEY then
        return cats.gold
    end
    if slotType == LOOT_SLOT_CURRENCY then
        return cats.currency
    end
    if slotType ~= LOOT_SLOT_ITEM then
        return false
    end

    local link = GetLootSlotLink(i)
    if not link then return false end

    local _, _, quality, ilvl, _, _, _, _, _, _, _, classID, subclassID, bindType = GetItemInfo(link)
    if not classID then return false end

    if cats.reagents and (classID == CLASS_TRADEGOOD or classID == CLASS_REAGENT) then
        return true
    end
    if cats.recipes and classID == CLASS_RECIPE then
        return true
    end
    if cats.mounts and classID == CLASS_MISC and subclassID == SUBCLASS_MISC_MOUNT then
        return true
    end
    if cats.pets and (classID == CLASS_BATTLE_PET or (classID == CLASS_MISC and subclassID == SUBCLASS_MISC_PET)) then
        return true
    end
    if cats.quest and (classID == CLASS_QUEST or bindType == BIND_QUEST) then
        return true
    end
    if cats.artifact and IsArtifactPower(link) then
        return true
    end

    if quality and db.quality[quality] then
        local qf = db.quality[quality]
        if qf.enabled then
            local ilvlOk = (qf.ilvl or 0) == 0 or (ilvl and ilvl >= qf.ilvl)
            local bindOk = (qf.boe and (bindType == BIND_NONE or bindType == BIND_EQUIP))
                        or (qf.bop and bindType == BIND_PICKUP)
            if ilvlOk and bindOk then
                return true
            end
        end
    end

    local itemID = tonumber(link:match("item:(%d+)"))
    if itemID then
        local entry = db.customList[itemID]
        if entry and entry.enabled then
            local entryIlvl = entry.ilvl or 0
            local ilvlOk = entryIlvl == 0 or (ilvl and ilvl >= entryIlvl)
            if ilvlOk then
                return true
            end
        end
    end

    return false
end

function AutoLoot:ScanAndOpenContainer()
    if lootOpen or InCombatLockdown() then return end
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local _, _, locked, _, _, lootable = GetContainerItemInfo(bag, slot)
            if lootable and not locked then
                lootingContainer = true
                UseContainerItem(bag, slot)
                return
            end
        end
    end
end

function AutoLoot:OnLootOpened()
    lootOpen = true
    local db = self.db.profile
    local n  = GetNumLootItems()

    if n == 0 then
        if db.options.emptyLoot then
            CloseLoot()
        end
        self:UnregisterEvent("LOOT_OPENED")
        return
    end

    for i = n, 1, -1 do
        if lootingContainer or ShouldLoot(i, db) then
            LootSlot(i)
        end
    end

    self:UnregisterEvent("LOOT_OPENED")
end

function AutoLoot:OnLootClosed()
    lootOpen         = false
    lootingContainer = false
    if self.db.profile.options.autoOpen then
        self:ScanAndOpenContainer()
    end
end

function AutoLoot:OnLootReady()
    if not self.db.profile.enabled then return end
    self:RegisterEvent("LOOT_OPENED", "OnLootOpened")
end

function AutoLoot:OnConfirmLootSlot(_, slotIndex)
    if self.db.profile.options.bop then
        ConfirmLootSlot(slotIndex)
    end
end

function AutoLoot:OnUnitSpellcastStart(_, unit)
    if unit ~= "player" then return end
    if not self.db.profile.options.skinning then return end
    if not skinningSpellName then
        skinningSpellName = GetSpellInfo(8613)
    end
    local castName = UnitCastingInfo("player")
    if castName and castName == skinningSpellName then
        CloseLoot()
    end
end

function AutoLoot:EnableEngine()
    self:RegisterEvent("LOOT_READY",          "OnLootReady")
    self:RegisterEvent("LOOT_CLOSED",         "OnLootClosed")
    self:RegisterEvent("CONFIRM_LOOT_SLOT",   "OnConfirmLootSlot")
    self:RegisterEvent("UNIT_SPELLCAST_START", "OnUnitSpellcastStart")
end

function AutoLoot:DisableEngine()
    self:UnregisterEvent("LOOT_READY")
    self:UnregisterEvent("LOOT_OPENED")
    self:UnregisterEvent("LOOT_CLOSED")
    self:UnregisterEvent("CONFIRM_LOOT_SLOT")
    self:UnregisterEvent("UNIT_SPELLCAST_START")
end