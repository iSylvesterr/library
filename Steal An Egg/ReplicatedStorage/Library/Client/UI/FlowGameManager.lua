-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local FlowGame = require(script.FlowGame);
require(script.FlowGame.Settings);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
u1.__index = u1;

local function resetGrid(p2) -- Line: 50
    for _, child in ipairs(p2.Container.GridHolder.Grid:GetChildren()) do
        if not child:IsA("UIGridLayout") then
            child:Destroy();
        end;
    end;
end;

local function resetProgress(p3) -- Line: 59
    p3.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
end;

local function getPuzzleUI(p4) -- Line: 63
    -- upvalues: LocalPlayer (copy)
    local puzzleUI = p4.puzzleUI;

    if puzzleUI and puzzleUI.Parent == LocalPlayer.PlayerGui then
        return puzzleUI;
    end;

    local PuzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
    PuzzleUI.Enabled = false;
    PuzzleUI.Container.Visible = false;
    p4.puzzleUI = PuzzleUI;

    return PuzzleUI;
end;

local function ensurePuzzleUITabOpen(p5) -- Line: 77
    -- upvalues: LocalPlayer (copy), TabController (copy)
    local puzzleUI = p5.puzzleUI;

    if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
        puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
        puzzleUI.Enabled = false;
        puzzleUI.Container.Visible = false;
        p5.puzzleUI = puzzleUI;
    end;

    if TabController.IsOpen("PuzzleUI") then
        puzzleUI.Enabled = true;

        return puzzleUI;
    end;

    TabController.OpenTab("PuzzleUI");

    return puzzleUI;
end;

local function resetPuzzleUI(p6) -- Line: 88
    -- upvalues: LocalPlayer (copy), resetGrid (copy)
    local puzzleUI = p6.puzzleUI;

    if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
        puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
        puzzleUI.Enabled = false;
        puzzleUI.Container.Visible = false;
        p6.puzzleUI = puzzleUI;
    end;

    resetGrid(puzzleUI);
    puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
    puzzleUI.Container.Visible = false;
    puzzleUI.Container.Size = UDim2.fromScale(0, 0);
    puzzleUI.Container.Tutorial.Visible = false;
end;

local function clearActiveGame(p7, p8) -- Line: 97
    local activeGame = p7.activeGame;

    if not activeGame then
        return;
    end;

    if p8 and activeGame.id ~= p8 then
        return;
    end;

    p7.activeGame = nil;
end;

function u1.new() -- Line: 111
    -- upvalues: u1 (copy), TabController (copy), LocalPlayer (copy), resetGrid (copy)
    local u9 = setmetatable({}, u1);
    u9.activeGame = nil;
    u9.completedBindable = Instance.new("BindableEvent");
    u9.Completed = u9.completedBindable.Event;
    u9.puzzleUI = nil;
    u9.manualCloseGameId = nil;
    TabController.AddCloseListener(function(p10) -- Line: 119
        -- upvalues: u9 (copy), LocalPlayer (ref), resetGrid (ref)
        if p10 ~= "PuzzleUI" then
            return;
        end;

        local activeGame = u9.activeGame;

        if not activeGame then
            local v11 = u9;
            local puzzleUI = v11.puzzleUI;

            if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
                puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
                puzzleUI.Enabled = false;
                puzzleUI.Container.Visible = false;
                v11.puzzleUI = puzzleUI;
            end;

            resetGrid(puzzleUI);
            puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
            puzzleUI.Container.Visible = false;
            puzzleUI.Container.Size = UDim2.fromScale(0, 0);
            puzzleUI.Container.Tutorial.Visible = false;

            return;
        end;

        local id = activeGame.id;
        u9.manualCloseGameId = id;
        activeGame:EndGame(false);
        local v12 = u9;
        local activeGame2 = v12.activeGame;

        if activeGame2 and (not id or activeGame2.id == id) then
            v12.activeGame = nil;
        end;

        local v13 = u9;
        local puzzleUI = v13.puzzleUI;

        if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
            puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
            puzzleUI.Enabled = false;
            puzzleUI.Container.Visible = false;
            v13.puzzleUI = puzzleUI;
        end;

        resetGrid(puzzleUI);
        puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
        puzzleUI.Container.Visible = false;
        puzzleUI.Container.Size = UDim2.fromScale(0, 0);
        puzzleUI.Container.Tutorial.Visible = false;
    end);

    return u9;
end;

function u1.startGame(u14, p15, p16) -- Line: 140
    -- upvalues: LocalPlayer (copy), resetGrid (copy), TabController (copy), FlowGame (copy)
    if u14.activeGame then
        u14.activeGame:EndGame(false);
        u14.activeGame = nil;
    end;

    local puzzleUI = u14.puzzleUI;

    if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
        puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
        puzzleUI.Enabled = false;
        puzzleUI.Container.Visible = false;
        u14.puzzleUI = puzzleUI;
    end;

    resetGrid(puzzleUI);
    puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
    puzzleUI.Container.Visible = false;
    puzzleUI.Container.Size = UDim2.fromScale(0, 0);
    puzzleUI.Container.Tutorial.Visible = false;
    local puzzleUI2 = u14.puzzleUI;

    if not puzzleUI2 or puzzleUI2.Parent ~= LocalPlayer.PlayerGui then
        puzzleUI2 = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
        puzzleUI2.Enabled = false;
        puzzleUI2.Container.Visible = false;
        u14.puzzleUI = puzzleUI2;
    end;

    if TabController.IsOpen("PuzzleUI") then
        puzzleUI2.Enabled = true;
    else
        TabController.OpenTab("PuzzleUI");
    end;

    if LocalPlayer:GetAttribute("CompletedGenPuzzle") then
        puzzleUI2.Container.Tutorial.Visible = false;
        puzzleUI2.Container.Position = UDim2.fromScale(0.5, 0.5);
    else
        puzzleUI2.Container.Tutorial.Visible = true;
        puzzleUI2.Container.Position = UDim2.fromScale(0.5, 0.55);
    end;

    local u17 = FlowGame.new(puzzleUI2, p15, p16);
    u17.completedEvent = Instance.new("BindableEvent");
    local completedEvent = u17.completedEvent;
    assert(completedEvent, "Expected completed event after FlowGame start");
    completedEvent.Event:Once(function(p18) -- Line: 163
        -- upvalues: u14 (copy), u17 (copy)
        local v19 = p18 == "leaveGenerator" and u14.manualCloseGameId == u17.id and "manualClose" or p18;

        if u14.manualCloseGameId == u17.id then
            u14.manualCloseGameId = nil;
        end;

        local v20 = u14;
        local id = u17.id;
        local activeGame = v20.activeGame;

        if activeGame and (not id or activeGame.id == id) then
            v20.activeGame = nil;
        end;

        u14.completedBindable:Fire(v19);
    end);
    u14.activeGame = u17;
end;

function u1.endGame(p21, p22) -- Line: 180
    -- upvalues: TabController (copy), LocalPlayer (copy), resetGrid (copy)
    local activeGame = p21.activeGame;

    if not activeGame then
        TabController.CloseTab();
        local puzzleUI = p21.puzzleUI;

        if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
            puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
            puzzleUI.Enabled = false;
            puzzleUI.Container.Visible = false;
            p21.puzzleUI = puzzleUI;
        end;

        resetGrid(puzzleUI);
        puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
        puzzleUI.Container.Visible = false;
        puzzleUI.Container.Size = UDim2.fromScale(0, 0);
        puzzleUI.Container.Tutorial.Visible = false;

        return;
    end;

    if p22 and activeGame.id ~= p22 then
        return;
    end;

    activeGame:EndGame(false);
    p21.activeGame = nil;
    TabController.CloseTab();
    local puzzleUI = p21.puzzleUI;

    if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
        puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
        puzzleUI.Enabled = false;
        puzzleUI.Container.Visible = false;
        p21.puzzleUI = puzzleUI;
    end;

    resetGrid(puzzleUI);
    puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, 0);
    puzzleUI.Container.Visible = false;
    puzzleUI.Container.Size = UDim2.fromScale(0, 0);
    puzzleUI.Container.Tutorial.Visible = false;
end;

function u1.SetProgress(p23, p24, p25) -- Line: 198
    -- upvalues: LocalPlayer (copy)
    local puzzleUI = p23.puzzleUI;

    if not puzzleUI or puzzleUI.Parent ~= LocalPlayer.PlayerGui then
        puzzleUI = LocalPlayer.PlayerGui:WaitForChild("PuzzleUI");
        puzzleUI.Enabled = false;
        puzzleUI.Container.Visible = false;
        p23.puzzleUI = puzzleUI;
    end;

    local v26 = p24 / math.max(p25, 1);
    local v27 = math.clamp(v26, 0, 1);
    puzzleUI.Container.Progress.CanvasGroup.Frame.Size = UDim2.fromScale(1, v27);
end;

return u1.new();