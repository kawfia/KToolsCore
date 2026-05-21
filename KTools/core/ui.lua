-- KTools/core/ui.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local LibWindow = LibStub("LibWindow-1.1")

local modules = {}
local modulesByName = {}
local mainFrame
local tabGroup

function KTools:RegisterModule(name, module)
    local entry = { name = name, label = L[name] or name, module = module }
    tinsert(modules, entry)
    modulesByName[name] = entry
    if mainFrame and mainFrame.frame:IsShown() then
        self:RefreshTabs()
    end
end

function KTools:SafeCall(module, method, ...)
    if type(module[method]) == "function" then
        local ok, err = pcall(module[method], module, ...)
        if not ok then
            geterrorhandler()(err)
        end
    end
end

local function OnTabSelected(widget, _, group)
    widget:ReleaseChildren()
    local entry = modulesByName[group]
    if entry then
        KTools:SafeCall(entry.module, "Draw", widget)
    end
end

function KTools:RefreshTabs()
    if not tabGroup then return end
    local tabs = {}
    for _, entry in ipairs(modules) do
        tinsert(tabs, { text = entry.label, value = entry.name })
    end
    tabGroup:SetTabs(tabs)
    if #tabs > 0 then
        tabGroup:SelectTab(modules[1].name)
    end
end

function KTools:ShowMainFrame()
    if mainFrame then
        mainFrame.frame:Show()
        return
    end

    local win = self.db.profile.window

    mainFrame = AceGUI:Create("Frame")
    mainFrame:SetTitle(ADDON)
    mainFrame:SetLayout("Fill")
    mainFrame:SetWidth(win.width)
    mainFrame:SetHeight(win.height)
    mainFrame:SetCallback("OnClose", function(widget)
        LibWindow.SavePosition(widget.frame)
        AceGUI:Release(widget)
        mainFrame = nil
        tabGroup = nil
    end)

    LibWindow.RegisterConfig(mainFrame.frame, win)
    LibWindow.RestorePosition(mainFrame.frame)

    tabGroup = AceGUI:Create("TabGroup")
    tabGroup:SetLayout("Flow")
    tabGroup:SetCallback("OnGroupSelected", OnTabSelected)
    mainFrame:AddChild(tabGroup)

    self:RefreshTabs()
end

function KTools:HideMainFrame()
    if mainFrame then
        LibWindow.SavePosition(mainFrame.frame)
        mainFrame.frame:Hide()
    end
end

function KTools:ToggleMainFrame()
    if mainFrame and mainFrame.frame:IsShown() then
        self:HideMainFrame()
    else
        self:ShowMainFrame()
    end
end