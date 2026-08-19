-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local ActionPromptCmds = require(ReplicatedStorage.Library.Client.ActionPromptCmds);
local ConsoleCmds = require(ReplicatedStorage.Library.Client.ConsoleCmds);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Signal);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = table.freeze({ "Message", "BuyMultiple", "StealDnaMessage", "PetList", "GrowingEggList" });
local u2 = table.freeze({
    Message = true,
    BuyMultiple = true,
    StealDnaMessage = true
});
local u3 = table.freeze({
    BackpackGui = true,
    Treadmill = true,
    TreadmillScreenButtonSwapLeft = true,
    TreadmillScreenButtonSwapRight = true,
    TreadmillScreenComments = true,
    TreadmillUI = true
});
local ButtonL3 = Enum.KeyCode.ButtonL3;
local ButtonB = Enum.KeyCode.ButtonB;
local u4 = table.freeze({
    BackpackGui = true,
    TopbarCentered = true,
    TopbarCenteredClipped = true,
    TopbarStandard = true,
    TopbarStandardClipped = true
});
local u5 = Log.new();
local v6 = GUI.PlayerGui();
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = nil;
local u12 = false;
local u13 = false;

local function isVisible(p14) -- Line: 65
    -- upvalues: ConsoleCmds (copy)
    return ConsoleCmds.ElementIsVisibleOnScreen(p14);
end;

local function priorityScreen() -- Line: 69
    -- upvalues: u1 (copy), GUI (copy), TabController (copy), u13 (ref)
    for _, v in u1 do
        local v15 = GUI.Get(v);
        local v16 = v15:IsA("ScreenGui");
        local v17 = `{v} must be a ScreenGui`;
        assert(v16, v17);

        if v15.Enabled then
            return v15;
        end;
    end;

    local v18 = TabController.Get();

    if v18 ~= nil then
        local v19 = GUI.Get(v18);
        local v20 = v19:IsA("ScreenGui");
        local v21 = `Tab {v18} must be a ScreenGui`;
        assert(v20, v21);

        if v19.Enabled then
            return v19;
        end;
    end;

    if u13 then
        local v22 = GUI.SideButtons();
        local v23 = v22:IsA("ScreenGui");
        assert(v23, "Elements must be a ScreenGui");

        if v22.Enabled then
            return v22;
        end;
    end;

    return nil;
end;

local function setHudNavigation(p24, p25) -- Line: 98
    -- upvalues: u13 (ref), ConsoleCmds (copy), u5 (copy), ButtonL3 (copy)
    if u13 == p24 then
        return;
    end;

    u13 = p24;
    ConsoleCmds.SetMarkerActionsEnabled(not p24);
    u5:AtDebug():Log((`HUD navigation {p24 and "ON" or "OFF"} ({p25}); toggle key is {ButtonL3.Name}`));
end;

local function restoreSelectableButtons() -- Line: 107
    -- upvalues: u8 (copy), u7 (copy)
    for i in u8 do
        if i.Parent ~= nil then
            i.Selectable = u7[i];
        end;

        u8[i] = nil;
    end;
end;

local function precedes(p26, p27) -- Line: 116
    local v28 = p26:GetAttribute("InitialSelection") == true;

    if v28 ~= (p27:GetAttribute("InitialSelection") == true) then
        return v28;
    end;

    if p26.Name == "Close" or p27.Name == "Close" then
        return p27.Name == "Close";
    end;

    if p26.LayoutOrder ~= p27.LayoutOrder then
        return p26.LayoutOrder < p27.LayoutOrder;
    end;

    if p26.AbsolutePosition.Y == p27.AbsolutePosition.Y then
        return p26.AbsolutePosition.X < p27.AbsolutePosition.X;
    end;

    return p26.AbsolutePosition.Y < p27.AbsolutePosition.Y;
end;

local function projectSelectableButtons(p29) -- Line: 134
    -- upvalues: ConsoleCmds (copy), u7 (copy), u8 (copy), precedes (copy)
    local v30 = nil;

    for _, descendant in p29:GetDescendants() do
        if descendant:IsA("GuiButton") and (descendant.Active and (ConsoleCmds.ElementIsVisibleOnScreen(descendant) and descendant:GetAttribute("ConsoleNavigationDisabled") ~= true)) then
            if u7[descendant] == nil then
                u7[descendant] = descendant.Selectable;
            end;

            descendant.Selectable = true;
            u8[descendant] = true;

            if v30 == nil or precedes(descendant, v30) then
                v30 = descendant;
            end;
        end;
    end;

    return v30;
end;

local function isEligibleSelection(p31, p32) -- Line: 156
    -- upvalues: ConsoleCmds (copy)
    local v33;

    if p32 == nil then
        v33 = false;
    else
        v33 = p32:IsDescendantOf(p31) and p32:IsA("GuiButton") and (p32.Selectable and p32.Active) and ConsoleCmds.ElementIsVisibleOnScreen(p32);
    end;

    return v33;
end;

local function isExternalNavigationSelection(p34) -- Line: 165
    -- upvalues: u4 (copy)
    if p34 == nil then
        return false;
    end;

    local v35 = p34:FindFirstAncestorWhichIsA("LayerCollector");
    local v36;

    if v35 == nil then
        v36 = false;
    else
        v36 = u4[v35.Name] == true;
    end;

    return v36;
end;

local function reconcile() -- Line: 173
    -- upvalues: u12 (ref), u8 (copy), u7 (copy), Variables (copy), ActionPromptCmds (copy), u13 (ref), ConsoleCmds (copy), u5 (copy), ButtonL3 (copy), u11 (ref), GuiService (copy), priorityScreen (copy), u4 (copy), u2 (copy), projectSelectableButtons (copy), u9 (copy)
    if u12 then
        return;
    end;

    u12 = true;

    for i in u8 do
        if i.Parent ~= nil then
            i.Selectable = u7[i];
        end;

        u8[i] = nil;
    end;

    if not Variables.Console then
        ActionPromptCmds.Hide("HudNavigation");

        if u13 ~= false then
            u13 = false;
            ConsoleCmds.SetMarkerActionsEnabled(true);
            u5:AtDebug():Log((`HUD navigation OFF (left console platform); toggle key is {ButtonL3.Name}`));
        end;

        u11 = nil;
        ConsoleCmds.SetActiveInterface(nil);
        GuiService.SelectedObject = nil;
        GuiService.GuiNavigationEnabled = false;
        u12 = false;

        return;
    end;

    local v37 = priorityScreen();

    if v37 ~= nil and v37.Name ~= "Elements" then
        local v38 = `{v37.Name} took focus`;

        if u13 ~= false then
            u13 = false;
            ConsoleCmds.SetMarkerActionsEnabled(true);
            u5:AtDebug():Log((`HUD navigation OFF ({v38}); toggle key is {ButtonL3.Name}`));
        end;
    end;

    if v37 == nil or v37.Name == "Elements" then
        ActionPromptCmds.Show("HudNavigation", ButtonL3, u13 and "Close Menus" or "Menus");
    else
        ActionPromptCmds.Hide("HudNavigation");
    end;

    u11 = v37;
    ConsoleCmds.SetActiveInterface(v37);

    if v37 == nil then
        local SelectedObject = GuiService.SelectedObject;
        local v39;

        if SelectedObject == nil then
            v39 = false;
        else
            local v40 = SelectedObject:FindFirstAncestorWhichIsA("LayerCollector");

            if v40 == nil then
                v39 = false;
            else
                v39 = u4[v40.Name] == true;
            end;
        end;

        if v39 then
            GuiService.GuiNavigationEnabled = true;
        else
            GuiService.SelectedObject = nil;
            GuiService.GuiNavigationEnabled = false;
        end;

        u12 = false;

        return;
    end;

    if u2[v37.Name] then
        GuiService.SelectedObject = nil;
        GuiService.GuiNavigationEnabled = false;
        u12 = false;

        return;
    end;

    local v41 = projectSelectableButtons(v37);
    local SelectedObject = GuiService.SelectedObject;
    local v42;

    if SelectedObject == nil then
        v42 = false;
    else
        v42 = SelectedObject:IsDescendantOf(v37) and SelectedObject:IsA("GuiButton") and (SelectedObject.Selectable and SelectedObject.Active) and ConsoleCmds.ElementIsVisibleOnScreen(SelectedObject);
    end;

    if v42 then
        v41 = SelectedObject;
    else
        local v43 = u9[v37];
        local v44;

        if v43 == nil then
            v44 = false;
        else
            v44 = v43:IsDescendantOf(v37) and v43:IsA("GuiButton") and (v43.Selectable and v43.Active) and ConsoleCmds.ElementIsVisibleOnScreen(v43);
        end;

        if v44 then
            v41 = v43;
        end;
    end;

    GuiService.SelectedObject = v41;
    GuiService.GuiNavigationEnabled = v41 ~= nil;
    u12 = false;
end;

local function requestReconcile() -- Line: 231
    -- upvalues: reconcile (copy)
    task.defer(reconcile);
end;

local function observe(u45) -- Line: 235
    -- upvalues: u10 (copy), u3 (copy), ConsoleCmds (copy), requestReconcile (copy), u9 (copy), u7 (copy), u8 (copy), reconcile (copy)
    if u10[u45] then
        return;
    end;

    u10[u45] = true;
    local v46;

    if u45:IsA("ScreenGui") then
        v46 = u45;
    else
        v46 = u45:FindFirstAncestorOfClass("ScreenGui");
    end;

    if v46 == nil or not u3[v46.Name] then
        ConsoleCmds.ObserveInstance(u45);
    end;

    if u45:IsA("ScreenGui") then
        u45:GetPropertyChangedSignal("Enabled"):Connect(requestReconcile);
    elseif u45:IsA("GuiObject") then
        u45:GetPropertyChangedSignal("Visible"):Connect(requestReconcile);

        if u45:IsA("GuiButton") then
            u45:GetPropertyChangedSignal("Active"):Connect(requestReconcile);
        end;
    end;

    u45.Destroying:Once(function() -- Line: 252
        -- upvalues: u10 (ref), u45 (copy), u9 (ref), u7 (ref), u8 (ref), reconcile (ref)
        u10[u45] = nil;

        if u45:IsA("ScreenGui") then
            u9[u45] = nil;
        elseif u45:IsA("GuiButton") then
            u7[u45] = nil;
            u8[u45] = nil;
        end;

        if u45:IsA("GuiObject") then
            for i, v in u9 do
                if v == u45 then
                    u9[i] = nil;
                end;
            end;
        end;

        task.defer(reconcile);
    end);
end;

for _, descendant in v6:GetDescendants() do
    observe(descendant);
end;

for _, child in v6:GetChildren() do
    observe(child);
end;

v6.DescendantAdded:Connect(function(p47) -- Line: 282
    -- upvalues: observe (copy), reconcile (copy)
    observe(p47);
    task.defer(reconcile);
end);
v6.DescendantRemoving:Connect(requestReconcile);
GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 287
    -- upvalues: u11 (ref), GuiService (copy), ConsoleCmds (copy), u9 (copy), Variables (copy), u4 (copy)
    local v48 = u11;
    local SelectedObject = GuiService.SelectedObject;

    if v48 ~= nil then
        local v49;

        if SelectedObject == nil then
            v49 = false;
        else
            v49 = SelectedObject:IsDescendantOf(v48) and SelectedObject:IsA("GuiButton") and (SelectedObject.Selectable and SelectedObject.Active) and ConsoleCmds.ElementIsVisibleOnScreen(SelectedObject);
        end;

        if v49 then
            u9[v48] = SelectedObject;

            return;
        end;
    end;

    if Variables.Console and v48 == nil then
        local v50;

        if SelectedObject == nil then
            v50 = false;
        else
            local v51 = SelectedObject:FindFirstAncestorWhichIsA("LayerCollector");

            if v51 == nil then
                v50 = false;
            else
                v50 = u4[v51.Name] == true;
            end;
        end;

        GuiService.GuiNavigationEnabled = v50;
    end;
end);
Signal.Fired("Changed Platform"):Connect(requestReconcile);
TabController.Opened:Connect(requestReconcile);
TabController.Closed:Connect(requestReconcile);
UserInputService.InputBegan:Connect(function(p52, p53) -- Line: 300
    -- upvalues: Variables (copy), ButtonL3 (copy), u13 (ref), ConsoleCmds (copy), u5 (copy), reconcile (copy), ButtonB (copy)
    if not Variables.Console or p53 then
        return;
    end;

    if p52.KeyCode ~= ButtonL3 then
        if p52.KeyCode == ButtonB and u13 then
            local v54 = `pressed {p52.KeyCode.Name}`;

            if u13 ~= false then
                u13 = false;
                ConsoleCmds.SetMarkerActionsEnabled(true);
                u5:AtDebug():Log((`HUD navigation OFF ({v54}); toggle key is {ButtonL3.Name}`));
            end;

            task.defer(reconcile);
        end;

        return;
    end;

    local v55 = not u13;
    local v56 = `pressed {p52.KeyCode.Name}`;

    if u13 ~= v55 then
        u13 = v55;
        ConsoleCmds.SetMarkerActionsEnabled(not v55);
        u5:AtDebug():Log((`HUD navigation {v55 and "ON" or "OFF"} ({v56}); toggle key is {ButtonL3.Name}`));
    end;

    task.defer(reconcile);
end);
GuiService.AutoSelectGuiEnabled = false;
ConsoleCmds.UpdateInterface(Variables.Platform);
reconcile();
u5:AtInfo():Log("Console navigation initialized");