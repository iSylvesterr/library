-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local CollectionService = game:GetService("CollectionService");
local Client = Library:WaitForChild("Client");
local u2 = require(ReplicatedStorage.Library.Modules.SpatialTable).new(150);
local Functions = require(Library.Functions);
local Player = require(Library.Player);
local Save = require(Client.Save);
local TabController = require(Client.TabController);
local Interact = require(Client.Interact);
local Pads = require(Client.WorldFX.Pads);
local Event = require(ReplicatedStorage.Library.Modules.Event);
local LocalPlayer = Players.LocalPlayer;
local u3 = false;
local CurrentCamera = workspace.CurrentCamera;
local u4 = {
    SpinnyWheel = true
};
u1.InstanceMachineCreated = Event.new();
u1.InstanceMachineDestroyed = Event.new();
u1.MachineLoaded = Event.new();
u1.MachineRemoved = Event.new();
u1.Approached = Event.new();
u1.Left = Event.new();
local u5 = {};
local u6 = {};
local u7 = {};

function u1.All() -- Line: 59
    -- upvalues: u5 (copy)
    return u5;
end;

function u1.AllModels() -- Line: 63
    -- upvalues: u1 (copy)
    local v8 = {};

    for i in pairs(u1.All()) do
        for _, v in pairs(u1.GetModels(i)) do
            table.insert(v8, v);
        end;
    end;

    return v8;
end;

function u1.GetDisplayName(p9) -- Line: 73
    -- upvalues: u1 (copy)
    local v10 = u1.GetAll(p9);
    assert(#v10 > 0, "No machines found for " .. p9);

    return v10[1].DisplayName;
end;

function u1.GetAll(p11) -- Line: 79
    -- upvalues: u3 (ref), u5 (copy)
    while not u3 do
        task.wait();
    end;

    local v12 = u5[p11] or {};

    return v12;
end;

function u1.GetModels(p13) -- Line: 90
    -- upvalues: u1 (copy)
    local v14 = {};

    for _, v in pairs(u1.GetAll(p13)) do
        table.insert(v14, v.Model);
    end;

    return v14;
end;

function u1.GetUI(p15) -- Line: 99
    -- upvalues: u1 (copy)
    local v16 = u1.GetAll(p15);
    local v17;

    if #v16 > 0 then
        v17 = v16[1].UI or nil;
    else
        v17 = nil;
    end;

    assert(v17, "No UI found for machine: " .. p15);

    return v16[1].UI;
end;

function u1.AddApproachListenerForModel(p18, p19, u20) -- Line: 111
    -- upvalues: u1 (copy)
    for _, v in pairs(u1.GetAll(p18)) do
        if v.Pad and v.Model == p19 then
            local Pad = v.Pad;
            assert(Pad, "Pad object is nil for machine: " .. p18);
            Pad:AddEnterListener(function() -- Line: 120
                -- upvalues: u20 (copy), v (copy)
                u20(v.Model);
            end);
        end;
    end;
end;

function u1.AddApproachListener(p21, p22) -- Line: 127
    -- upvalues: u7 (copy)
    if not u7[p21] then
        u7[p21] = {};
    end;

    table.insert(u7[p21], p22);
end;

function u1.AddLeaveListener(p23, p24) -- Line: 134
    -- upvalues: u7 (copy)
    if not u7[p23] then
        u7[p23] = {};
    end;

    table.insert(u7[p23], p24);
end;

function u1.AddInteractListener(p25, u26) -- Line: 141
    -- upvalues: u1 (copy)
    for _, v in pairs(u1.GetAll(p25)) do
        if v.InteractPart then
            assert(v.InteractPart, "InteractPart is nil for machine: " .. p25);
            table.insert(v.InteractListeners, function() -- Line: 147
                -- upvalues: u26 (copy), v (copy)
                u26(v.Model);
            end);
        end;
    end;
end;

function u1.CanUse(p27) -- Line: 154
    -- upvalues: Save (copy), u1 (copy), Player (copy)
    if not Save.Get() then
        return false, "Something went wrong!";
    end;

    if not u1.Owns(p27) then
        return false, "Something went wrong!";
    end;

    local v28 = Player.Optional.PrimaryPart(Player.Get());

    if not v28 then
        return false, "Something went wrong!";
    end;

    for _, v in pairs(u1.GetAll(p27)) do
        local v29 = v.InteractPart and v.InteractPart.Position or v.Pad.pad:GetPivot().Position;

        if (v28.Position - v29).Magnitude <= 80 then
            return true;
        end;
    end;

    return false, "Something went wrong!";
end;

function u1.IsStandingOn(p30) -- Line: 188
    -- upvalues: u1 (copy)
    for _, v in pairs(u1.GetAll(p30)) do
        if v.Pad then
            local Pad = v.Pad;
            assert(Pad, "Pad object is nil for machine: " .. p30);

            if Pad:IsStandingOn() then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.Owns(p31) -- Line: 201
    return true;
end;

function u1.PreventOpen(p32) -- Line: 205
    -- upvalues: u6 (copy)
    u6[p32] = true;
end;

function u1.AllowOpen(p33) -- Line: 209
    -- upvalues: u6 (copy)
    u6[p33] = nil;
end;

function u1.IsAllowedToOpen(p34) -- Line: 213
    -- upvalues: u6 (copy)
    return u6[p34] == nil;
end;

function u1.GetClosestMachine(p35, p36, p37) -- Line: 217
    -- upvalues: Player (copy), u5 (copy), Functions (copy)
    local v38 = p36 or Player.Get();
    local v39 = nil;

    for _, v in pairs(u5) do
        for _, v2 in ipairs(v) do
            if v2.MachineName == p35 then
                local v40 = Functions.Distance(v38, v2.Model:GetPivot().Position);

                if v39 then
                    if (p37 == nil or v40 <= p37) and v40 < (1 / 0) then
                        v39 = v2;
                        p37 = (1 / 0);
                    end;
                elseif p37 == nil or v40 <= p37 then
                    if v40 then
                        p37 = v40;
                        v39 = v2;
                    else
                        v39 = v2;
                    end;
                end;
            end;
        end;
    end;

    return v39;
end;

local function AddMachine(u41) -- Line: 247
    -- upvalues: Pads (copy), LocalPlayer (copy), u5 (copy), u7 (copy), u1 (copy), u6 (copy), u4 (copy), TabController (copy), Interact (copy), u2 (copy)
    local Pad = u41:FindFirstChild("Pad");
    local v42;

    if u41:FindFirstChild("Interact") then
        v42 = u41:FindFirstChild("Interact");
    else
        v42 = Instance.new("Part");
        v42.Anchored = true;
        v42.CanCollide = true;

        if u41.PrimaryPart then
            v42.Position = u41.PrimaryPart.Position;
        else
            v42.Position = u41:GetPivot().Position;
        end;
    end;

    local v43 = nil;

    if Pad then
        if Pad then
            v43 = Pads.new(Pad);
        end;
    else
        v43 = nil;
    end;

    local v44 = LocalPlayer.PlayerGui:WaitForChild("_MACHINES"):FindFirstChild(u41.Name);
    local u45 = {
        Highlight = nil,
        Model = u41,
        MachineName = u41.Name,
        DisplayName = u41:GetAttribute("DisplayName") or u41.Name,
        Pad = v43,
        Position = u41:GetPivot().Position,
        PrimaryPart = u41.PrimaryPart,
        InteractPart = v42,
        UI = v44,
        ApproachListeners = {},
        LeaveListeners = {},
        InteractListeners = {},
        DontAddMachineHighlight = u41:GetAttribute("DontAddMachineHighlight") or false
    };

    if not u5[u41.Name] then
        u5[u41.Name] = {};
    end;

    table.insert(u5[u41.Name], u45);

    if u45.Pad then
        u45.Pad:AddEnterListener(function() -- Line: 298
            -- upvalues: u7 (ref), u41 (copy), u1 (ref), u45 (copy)
            local v46 = u7[u41.Name];

            if v46 then
                for _, v in ipairs(v46) do
                    task.spawn(v, u41);
                end;
            end;

            u1.Approached:FireAsync(u45);
        end);
        u45.Pad:AddLeaveListener(function() -- Line: 307
            -- upvalues: u7 (ref), u41 (copy), u1 (ref), u45 (copy)
            local v47 = u7[u41.Name];

            if v47 then
                for _, v in ipairs(v47) do
                    task.spawn(v, u41);
                end;
            end;

            u1.Left:FireAsync(u45);
        end);
    end;

    if u45.Pad and u45.UI then
        u45.Pad:AddEnterListener(function() -- Line: 319
            -- upvalues: u6 (ref), u45 (copy), u4 (ref), TabController (ref)
            if u6[u45.MachineName] then
                return;
            end;

            if u4[u45.MachineName] then
                return;
            end;

            if TabController.Get() ~= nil then
                return;
            end;

            if TabController.IsOpen(u45.UI.Name) then
                return;
            end;

            TabController.OpenTab(u45.UI.Name);
        end);
        local u48 = false;
        TabController.AddCloseListener(function(p49) -- Line: 334
            -- upvalues: u48 (ref), u45 (copy), TabController (ref)
            if not u48 and (p49 == u45.UI.Name or (p49 == "Message" or u45.UI.Name == "SuperMachine")) then
                u48 = true;
                task.delay(1, function() -- Line: 342
                    -- upvalues: TabController (ref), u45 (ref), u48 (ref)
                    task.wait(0.15);

                    if not TabController.IsOpen() and u45.Pad:IsStandingOn() then
                        TabController.OpenTab(u45.UI.Name);
                        u45.Pad:FireEnterListeners();
                    end;

                    u48 = false;
                end);
            end;
        end);
    end;

    if v44 then
        local Close = v44:FindFirstChild("Close", true);

        if Close and not Close:GetAttribute("MachineInitialized") then
            Close:SetAttribute("MachineInitialized", true);
            Close.Activated:Connect(function() -- Line: 359
                -- upvalues: TabController (ref), u41 (copy)
                if TabController.IsOpen(u41.Name) then
                    TabController.CloseTab();
                end;
            end);
        end;
    end;

    if v42 then
        Interact.Add(v42):Connect(function() -- Line: 368
            -- upvalues: u45 (copy)
            for _, v in ipairs(u45.InteractListeners) do
                task.spawn(v);
            end;
        end);
    end;

    u1.InstanceMachineCreated:FireAsync(u45);
    u2:Insert(u45.Position, u45);
    u1.MachineLoaded:FireAsync(u45);
end;

CollectionService:GetInstanceAddedSignal("Machine"):Connect(AddMachine);
CollectionService:GetInstanceRemovedSignal("Machine"):Connect(function(p50) -- Line: 380, Name: GetModel
    -- upvalues: u5 (copy), u1 (copy), u2 (copy)
    if not u5[p50.Name] then
        warn(`Machine: {p50.Name} not found in MachinesByName, bad model:`, p50);

        return;
    end;

    local v51 = u5[p50.Name];

    for i = #v51, 1, -1 do
        local v52 = v51[i];

        if v52.Model == p50 then
            table.remove(v51, i);
            u1.MachineRemoved:FireAsync(v52);
            u2:Remove(v52.Position, v52);
        end;
    end;
end);
task.spawn(function() -- Line: 399
    -- upvalues: CollectionService (copy), AddMachine (copy), u3 (ref)
    for _, v in ipairs(CollectionService:GetTagged("Machine")) do
        AddMachine(v);
    end;

    u3 = true;
end);
RunService.RenderStepped:Connect(function() -- Line: 406
    -- upvalues: Player (copy), CurrentCamera (copy), u2 (copy), TabController (copy)
    local v53 = Player.Optional.Position();

    if v53 then
        local Position = CurrentCamera.CFrame.Position;
        local v54 = u2:Collect(v53);
        local v55 = TabController.Get() ~= nil;

        for _, v in ipairs(v54) do
            if not v.DontAddMachineHighlight then
                local v56 = not v55;

                if v.Highlight and not v56 then
                    v.Highlight:Destroy();
                    v.Highlight = nil;
                end;

                if v56 then
                    local Magnitude = (v.Position - Position).Magnitude;

                    if Magnitude < 150 then
                        if not v.Highlight then
                            local Highlight = Instance.new("Highlight");
                            Highlight.FillTransparency = 1;
                            Highlight.OutlineColor = Color3.new();
                            Highlight.OutlineTransparency = 1;
                            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
                            Highlight.Parent = v.Model;
                            v.Highlight = Highlight;
                        end;

                        assert(v.Highlight, "luau");
                        v.Highlight.OutlineTransparency = 0.8;
                    else
                        local v57 = math.min(Magnitude - 150, 35) / 35 * 0.2 + 0.8;

                        if v57 >= 1 and v.Highlight then
                            v.Highlight:Destroy();
                            v.Highlight = nil;
                        elseif v57 < 1 then
                            if not v.Highlight then
                                local Highlight = Instance.new("Highlight");
                                Highlight.FillTransparency = 1;
                                Highlight.OutlineColor = Color3.new();
                                Highlight.OutlineTransparency = 1;
                                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
                                Highlight.Parent = v.Model;
                                v.Highlight = Highlight;
                            end;

                            assert(v.Highlight, "luau");
                            v.Highlight.OutlineTransparency = v57;
                        end;
                    end;
                end;
            end;
        end;
    end;
end);

return u1;