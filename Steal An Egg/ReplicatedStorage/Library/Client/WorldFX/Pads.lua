-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = require(ReplicatedStorage.Library.Functions);
local Player = require(ReplicatedStorage.Library.Player);
local FFlags = require(ReplicatedStorage.Library.Client.FFlags);
local Variables = require(ReplicatedStorage.Library.Variables);
local SpatialTable = require(ReplicatedStorage.Library.Modules.SpatialTable);
local v1 = {};
local u2 = nil;
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = SpatialTable.new(25);

local function updateRaycastFilter() -- Line: 41
    -- upvalues: u3 (copy), u2 (ref)
    local v7 = {};

    for _, v in pairs(u3) do
        table.insert(v7, v.pad);
    end;

    u2 = RaycastParams.new();
    assert(u2, "luau");
    u2.FilterType = Enum.RaycastFilterType.Include;
    u2.FilterDescendantsInstances = v7;
end;

function v1.new(p8) -- Line: 52
    -- upvalues: Functions (copy), u5 (ref), u3 (copy), u4 (copy), u6 (copy), updateRaycastFilter (copy)
    local u9 = {
        destroyed = false,
        uid = Functions.GenerateUID(),
        pad = p8,
        padPosition = p8:GetPivot().Position,
        enterListeners = {},
        leaveListeners = {},
        distanceChecker = Functions.LazyDistanceChecker(p8)
    };
    local v10 = u9.pad.Parent and u9.pad.Parent:FindFirstChild("Arrow");

    if v10 then
        u9.arrow = v10;
        u9.arrowPivot = v10:GetPivot();
    end;

    function u9.AddEnterListener(u11, p12) -- Line: 71
        -- upvalues: Functions (ref)
        local u13 = Functions.GenerateUID();
        u11.enterListeners[u13] = p12;

        return function() -- Line: 74
            -- upvalues: u11 (copy), u13 (copy)
            u11.enterListeners[u13] = nil;
        end;
    end;

    function u9.AddLeaveListener(u14, p15) -- Line: 79
        -- upvalues: Functions (ref)
        local u16 = Functions.GenerateUID();
        u14.leaveListeners[u16] = p15;

        return function() -- Line: 82
            -- upvalues: u14 (copy), u16 (copy)
            u14.leaveListeners[u16] = nil;
        end;
    end;

    function u9.IsStandingOn(p17) -- Line: 87
        -- upvalues: u5 (ref)
        return u5 == p17;
    end;

    function u9.FireEnterListeners(p18) -- Line: 91
        for _, v in pairs(p18.enterListeners) do
            task.spawn(v);
        end;
    end;

    function u9.Destroy(p19) -- Line: 97
        -- upvalues: u3 (ref), u4 (ref), u6 (ref), updateRaycastFilter (ref)
        if p19.destroyed then
            return;
        end;

        p19.destroyed = true;

        for i in pairs(p19.enterListeners) do
            p19.enterListeners[i] = nil;
        end;

        for i in pairs(p19.leaveListeners) do
            p19.leaveListeners[i] = nil;
        end;

        u3[p19.uid] = nil;
        u4[p19.pad] = nil;
        u6:Remove(p19.padPosition, p19);
        updateRaycastFilter();
    end;

    u3[u9.uid] = u9;
    u4[u9.pad] = u9;
    updateRaycastFilter();
    u9.pad.Destroying:Connect(function() -- Line: 119
        -- upvalues: u9 (copy)
        u9:Destroy();
    end);
    u6:Insert(u9.padPosition, u9);

    return u9;
end;

task.spawn(function() -- Line: 142
    -- upvalues: updateRaycastFilter (copy), Player (copy), u6 (copy), u2 (ref), u3 (copy), u5 (ref)
    updateRaycastFilter();

    while true do
        local v20;

        while true do
            if not task.wait(0.1) then
                return;
            end;

            v20 = Player.Optional.PrimaryPart();

            if v20 then
                break;
            end;

            if u5 then
                for _, v in pairs(u5.leaveListeners) do
                    task.spawn(v);
                end;

                u5 = nil;
            end;
        end;

        assert(v20, "PrimaryPart should not be nil");

        if u6:Query(v20.Position) then
            local v21 = workspace:Raycast(v20.Position, Vector3.new(0, -10, 0), u2);

            if v21 and v21.Instance then
                local Instance = v21.Instance;
                local v22 = nil;

                for _, v in pairs(u3) do
                    if Instance == v.pad or Instance:IsDescendantOf(v.pad) then
                        v22 = v;
                        break;
                    end;
                end;

                if v22 then
                    assert(v22, "A pad was expected to be found via raycast");

                    if not u5 or v22 ~= u5 then
                        for _, v in pairs(v22.enterListeners) do
                            task.spawn(v);
                        end;
                    end;

                    u5 = v22;
                elseif u5 then
                    for _, v in pairs(u5.leaveListeners) do
                        task.spawn(v);
                    end;

                    u5 = nil;
                end;
            elseif u5 then
                for _, v in pairs(u5.leaveListeners) do
                    task.spawn(v);
                end;

                u5 = nil;
            end;
        elseif u5 then
            for _, v in pairs(u5.leaveListeners) do
                task.spawn(v);
            end;

            u5 = nil;
        end;
    end;
end);
task.spawn(function() -- Line: 126, Name: animateArrows
    -- upvalues: RunService (copy), FFlags (copy), Variables (copy), u3 (copy)
    local u23 = tick();
    RunService.RenderStepped:Connect(function(p24) -- Line: 128
        -- upvalues: FFlags (ref), Variables (ref), u23 (copy), u3 (ref)
        if not (FFlags.Get(FFlags.Keys.DisableWorldFrontend) or Variables.PotatoMode) then
            local new = CFrame.new;
            local v25 = (tick() - u23) * 3;
            local v26 = new(0, math.sin(v25) * 0.45, 0);

            for _, v in pairs(u3) do
                if v.arrow and (v.arrowPivot and v.distanceChecker()) then
                    v.arrow:PivotTo(v.arrowPivot * v26);
                end;
            end;
        end;
    end);
end);

return v1;