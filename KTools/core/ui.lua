-- KTools/core/ui.lua
local ADDON = ...
local KTools = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)
local AceGUI = LibStub("AceGUI-3.0")
local LibWindow = LibStub("LibWindow-1.1")

local MIN_W, MIN_H = 700, 500

local modules = {}
local modulesByName = {}
local mainFrame
local treeGroup
local ESC_NAME = ADDON .. "MainFrame"

tinsert(UISpecialFrames, ESC_NAME)

function KTools:RegisterModule(name, module, opts)
    local entry = {
        name      = name,
        label     = (opts and opts.label) or L[name] or name,
        module    = module,
        minWidth  = opts and opts.minWidth  or MIN_W,
        minHeight = opts and opts.minHeight or MIN_H,
    }
    tinsert(modules, entry)
    modulesByName[name] = entry
    if mainFrame and mainFrame.frame:IsShown() then
        self:RefreshTree()
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

function KTools:GetModules()
    return modules
end

local function OnGroupSelected(widget, _, group)
    widget:ReleaseChildren()
    local entry = modulesByName[group]
    if entry and mainFrame then
        local minW = entry.minWidth
        local minH = entry.minHeight
        mainFrame.frame:SetMinResize(minW, minH)
        local curW = mainFrame.frame:GetWidth()
        local curH = mainFrame.frame:GetHeight()
        if curW < minW or curH < minH then
            mainFrame:SetWidth(math.max(curW, minW))
            mainFrame:SetHeight(math.max(curH, minH))
        end
        KTools:SafeCall(entry.module, "Draw", widget)
    end
end

function KTools:RefreshTree()
    if not treeGroup then return end
    local tree = {}
    for _, entry in ipairs(modules) do
        tinsert(tree, { value = entry.name, text = entry.label })
    end
    treeGroup:SetTree(tree)
end

function KTools:ShowMainFrame()
    if mainFrame then
        mainFrame.frame:Show()
        return
    end

    local win = self.db.profile.window
    win.width  = math.max(win.width  or MIN_W, MIN_W)
    win.height = math.max(win.height or MIN_H, MIN_H)

    local version = GetAddOnMetadata(ADDON, "Version") or "?"
    local author  = GetAddOnMetadata(ADDON, "Author")  or "?"

    mainFrame = AceGUI:Create("Frame")
    mainFrame:SetTitle(ADDON)
    mainFrame:SetLayout("Fill")
    mainFrame:SetStatusText("v " .. version .. " | by " .. author)
    mainFrame:SetWidth(win.width)
    mainFrame:SetHeight(win.height)
    mainFrame.frame:SetMinResize(MIN_W, MIN_H)

    mainFrame:SetCallback("OnClose", function(widget)
        win.width  = widget.frame:GetWidth()
        win.height = widget.frame:GetHeight()
        LibWindow.SavePosition(widget.frame)
        _G[ESC_NAME] = nil
        AceGUI:Release(widget)
        mainFrame = nil
        treeGroup = nil
    end)

    _G[ESC_NAME] = mainFrame.frame
    LibWindow.RegisterConfig(mainFrame.frame, win)
    LibWindow.RestorePosition(mainFrame.frame)

    treeGroup = AceGUI:Create("TreeGroup")
    treeGroup:SetLayout("Fill")
    treeGroup:SetCallback("OnGroupSelected", OnGroupSelected)
    mainFrame:AddChild(treeGroup)

    self:RefreshTree()
end

function KTools:ShowMainFrameWithModule(name)
    self:ShowMainFrame()
    if treeGroup and modulesByName[name] then
        treeGroup:SelectByValue(name)
    end
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