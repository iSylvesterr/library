-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
require(script.Parent.Types);
local PlacedEggRenderer = require(ReplicatedStorage.Library.Client.Eggs.PlacedEggRenderer);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "AssetMovementBatch";
local v3 = workspace.__DEBRIS:IsA("Folder");
assert(v3, "Workspace.__DEBRIS must be a Folder");
local __OBJECTS = workspace.__OBJECTS;
local v4 = __OBJECTS:IsA("Folder");
assert(v4, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v5 = Areas:IsA("Folder");
assert(v5, "Workspace.__OBJECTS.Areas must be a Folder");
local Ground = Areas.Ground;
local v6 = Ground:IsA("BasePart");
assert(v6, "Workspace.__OBJECTS.Areas.Ground must be a BasePart");

function u2.new() -- Line: 58
    -- upvalues: u2 (copy), Trove (copy), u1 (copy)
    local v7 = setmetatable({}, u2);
    v7._trove = Trove.new();
    v7._entries = {};
    v7._orderedModels = {};
    v7._partsBuffer = {};
    v7._cframeBuffer = {};
    v7._foreignEntryCount = 0;
    v7._foreignPresentationSuppressed = false;
    v7._foreignPresentationForcedSuppressed = false;
    v7:_init();
    u1:AtDebug():Log("Created asset movement batch");

    return v7;
end;

function u2._createGroundingRaycastParams(p8) -- Line: 80
    -- upvalues: PlacedEggRenderer (copy), Ground (copy)
    local v9 = RaycastParams.new();
    v9.FilterType = Enum.RaycastFilterType.Include;
    v9.FilterDescendantsInstances = { PlacedEggRenderer.GetRenderFolder(), Ground, p8 };
    v9.IgnoreWater = true;

    return v9;
end;

function u2._groundCFrame(p10, p11, p12) -- Line: 92
    local Position = p11.Position;
    local v13 = workspace:Raycast(Position + Vector3.new(0, 64, 0), Vector3.new(0, -2000, 0), p12);

    if v13 == nil then
        return nil;
    end;

    local v14 = Vector3.new(Position.X, v13.Position.Y - p10, Position.Z);

    return CFrame.new(v14) * p11.Rotation;
end;

function u2._groundTargetCFrame(p15) -- Line: 109
    -- upvalues: u2 (copy)
    local v16 = u2._groundCFrame(p15.BottomLocalY, p15.TargetCFrame, p15.GroundingRaycastParams);

    if v16 ~= nil then
        return v16;
    end;

    local TargetCFrame = p15.TargetCFrame;
    local Position = TargetCFrame.Position;

    return CFrame.new(Position.X, p15.SimulationCFrame.Position.Y, Position.Z) * TargetCFrame.Rotation;
end;

function u2._movementAlpha(p17) -- Line: 122
    return math.clamp(p17 * 8, 0, 1);
end;

function u2._airborneMovementAlpha(p18) -- Line: 126
    return math.clamp(p18 * 14, 0, 0.45);
end;

function u2._isPresentationEnabled(p19, p20) -- Line: 130
    return p19.IsLocalOwner or not p20;
end;

function u2._advanceSuppressedSimulation(p21) -- Line: 137
    local TargetCFrame = p21.TargetCFrame;
    local Position = TargetCFrame.Position;
    p21.SimulationCFrame = CFrame.new(Position.X, p21.SimulationCFrame.Position.Y, Position.Z) * TargetCFrame.Rotation;
end;

function u2._forgetEntry(p22, p23) -- Line: 144
    local v24 = p22._entries[p23];

    if v24 ~= nil then
        if not v24.IsLocalOwner then
            assert(p22._foreignEntryCount > 0, "Foreign movement entry count cannot underflow");
            p22._foreignEntryCount = p22._foreignEntryCount - 1;
        end;

        p22._entries[p23] = nil;
    end;
end;

function u2._removeMissingModels(p25) -- Line: 155
    for i = #p25._orderedModels, 1, -1 do
        local v26 = p25._orderedModels[i];

        if p25._entries[v26] == nil or v26.Parent == nil then
            p25:_forgetEntry(v26);
            table.remove(p25._orderedModels, i);
        end;
    end;
end;

function u2._flush(p27, p28, p29) -- Line: 167
    -- upvalues: u2 (copy)
    table.clear(p27._partsBuffer);
    table.clear(p27._cframeBuffer);

    for _, v in ipairs(p27._orderedModels) do
        local v30 = p27._entries[v];

        if v30 ~= nil and (v.Parent ~= nil and u2._isPresentationEnabled(v30, p29)) then
            local v31 = u2._groundTargetCFrame(v30);
            v30.SimulationCFrame = v31;

            if not v30.GroundingEnabled then
                v31 = v30.TargetCFrame;
            end;

            local v32;

            if v30.GroundingEnabled then
                v32 = u2._movementAlpha(p28);
            else
                v32 = u2._airborneMovementAlpha(p28);
            end;

            if v30.CatchUpRemaining > 0 then
                v32 = math.clamp(p28 / v30.CatchUpRemaining, 0, 1);
                v30.CatchUpRemaining = math.max(v30.CatchUpRemaining - p28, 0);
            end;

            local v33;

            if v30.PresentationFrozen then
                v33 = v30.CurrentCFrame;
            else
                v33 = v30.CurrentCFrame:Lerp(v31, v32);
            end;

            local v34 = v33 * v30.PresentationOffset;
            local v35 = v:GetPivot();
            v30.CurrentCFrame = v33;

            for _, v2 in ipairs(v30.VisibleParts) do
                if v2.Parent ~= nil then
                    table.insert(p27._partsBuffer, v2);
                    local _cframeBuffer = p27._cframeBuffer;
                    local v36 = v34 * v35:ToObjectSpace(v2.CFrame);
                    table.insert(_cframeBuffer, v36);
                end;
            end;
        end;
    end;

    if #p27._partsBuffer > 0 then
        workspace:BulkMoveTo(p27._partsBuffer, p27._cframeBuffer, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end;

function u2._step(p37, p38) -- Line: 213
    -- upvalues: u2 (copy)
    p37:_removeMissingModels();
    local v39 = p37._foreignPresentationForcedSuppressed or p37._foreignEntryCount >= 30;
    local v40 = p37._foreignPresentationSuppressed and not v39;
    p37._foreignPresentationSuppressed = v39;

    for _, v in ipairs(p37._orderedModels) do
        local v41 = p37._entries[v];

        if v41 ~= nil and v.Parent ~= nil then
            v41.Step(p38, not v41.IsLocalOwner and v39);

            if not v41.IsLocalOwner then
                if v39 then
                    u2._advanceSuppressedSimulation(v41);
                elseif v40 then
                    v41.CatchUpRemaining = math.max(v41.CatchUpRemaining, 0.25);
                end;
            end;
        end;
    end;

    p37:_flush(p38, v39);
end;

function u2.Add(p42, p43, p44, p45, p46, p47, p48, p49) -- Line: 241
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Model(p43);
    Asserts.array.custom(p44, Asserts.BasePart);
    Asserts.CFrame(p45);
    Asserts.number(p46);
    Asserts.BasePart(p47);
    Asserts.boolean(p48);
    local v50 = p42._entries[p43] == nil;
    local v51 = `Asset model {p43.Name} is already registered in the movement batch`;
    assert(v50, v51);
    local v52 = u2._createGroundingRaycastParams(p47);
    local v53 = u2._groundCFrame(p46, p45, v52) or p45;
    p42._entries[p43] = {
        GroundingEnabled = true,
        PresentationFrozen = false,
        CatchUpRemaining = 0,
        Model = p43,
        VisibleParts = p44,
        AssetArea = p47,
        GroundingRaycastParams = v52,
        IsLocalOwner = p48,
        BottomLocalY = p46,
        TargetCFrame = p45,
        CurrentCFrame = p45,
        SimulationCFrame = v53,
        Step = p49,
        PresentationOffset = CFrame.identity
    };

    if not p48 then
        p42._foreignEntryCount = p42._foreignEntryCount + 1;
    end;

    table.insert(p42._orderedModels, p43);
end;

function u2.GetSimulationCFrame(p54, p55) -- Line: 285
    -- upvalues: Asserts (copy)
    Asserts.Model(p55);
    local v56 = p54._entries[p55];
    local v57 = `Asset model {p55.Name} is not registered in the movement batch`;
    assert(v56 ~= nil, v57);

    return v56.SimulationCFrame;
end;

function u2.ResolveGroundedCFrame(p58, p59) -- Line: 294
    -- upvalues: Asserts (copy), BBFromModelVisibleOnly (copy), PlacedEggRenderer (copy), Ground (copy), PlotCmds (copy), u2 (copy)
    Asserts.Model(p58);
    Asserts.CFrame(p59);
    local v60, v61 = BBFromModelVisibleOnly(p58);
    local v62 = p58:GetPivot():PointToObjectSpace(v60.Position).Y - v61.Y * 0.5;
    local v63 = { PlacedEggRenderer.GetRenderFolder(), Ground };
    local v64 = PlotCmds.GetPlotData();

    if v64 and v64.PetArea then
        table.insert(v63, v64.PetArea);
    end;

    local v65 = RaycastParams.new();
    v65.FilterType = Enum.RaycastFilterType.Include;
    v65.FilterDescendantsInstances = v63;
    v65.IgnoreWater = true;

    return u2._groundCFrame(v62, p59, v65) or p59;
end;

function u2.SetAssetArea(p66, p67, p68) -- Line: 317
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Model(p67);
    Asserts.BasePart(p68);
    local v69 = p66._entries[p67];
    local v70 = `Asset model {p67.Name} is not registered in the movement batch`;
    assert(v69 ~= nil, v70);

    if v69.AssetArea == p68 then
        return;
    end;

    v69.AssetArea = p68;
    v69.GroundingRaycastParams = u2._createGroundingRaycastParams(p68);
end;

function u2.SetTarget(p71, p72, p73) -- Line: 331
    -- upvalues: Asserts (copy)
    Asserts.Model(p72);
    Asserts.CFrame(p73);
    local v74 = p71._entries[p72];
    local v75 = `Asset model {p72.Name} is not registered in the movement batch`;
    assert(v74 ~= nil, v75);
    v74.TargetCFrame = p73;
end;

function u2.SetGroundingEnabled(p76, p77, p78) -- Line: 341
    -- upvalues: Asserts (copy)
    Asserts.Model(p77);
    Asserts.boolean(p78);
    local v79 = p76._entries[p77];
    local v80 = `Asset model {p77.Name} is not registered in the movement batch`;
    assert(v79 ~= nil, v80);
    v79.GroundingEnabled = p78;
end;

function u2.SetPresentationFrozen(p81, p82, p83, p84) -- Line: 351
    -- upvalues: Asserts (copy)
    Asserts.Model(p82);
    Asserts.boolean(p83);
    Asserts.optional.number(p84);
    local v85 = p81._entries[p82];
    local v86 = `Asset model {p82.Name} is not registered in the movement batch`;
    assert(v85 ~= nil, v86);
    v85.PresentationFrozen = p83;
    v85.CatchUpRemaining = p83 and 0 or math.max(p84 or 0, 0);
end;

function u2.SetPresentationOffset(p87, p88, p89) -- Line: 367
    -- upvalues: Asserts (copy)
    Asserts.Model(p88);
    Asserts.CFrame(p89);
    local v90 = p87._entries[p88];
    local v91 = `Asset model {p88.Name} is not registered in the movement batch`;
    assert(v90 ~= nil, v91);
    v90.PresentationOffset = p89;
end;

function u2.SetForeignPresentationSuppressed(p92, p93) -- Line: 376
    -- upvalues: Asserts (copy)
    Asserts.boolean(p93);
    p92._foreignPresentationForcedSuppressed = p93;
end;

function u2.Remove(p94, p95) -- Line: 381
    -- upvalues: Asserts (copy)
    Asserts.Model(p95);
    p94:_forgetEntry(p95);

    for i = #p94._orderedModels, 1, -1 do
        if p94._orderedModels[i] == p95 then
            table.remove(p94._orderedModels, i);

            return;
        end;
    end;
end;

function u2.Destroy(p96) -- Line: 393
    p96._trove:Destroy();
    table.clear(p96._entries);
    table.clear(p96._orderedModels);
    table.clear(p96._partsBuffer);
    table.clear(p96._cframeBuffer);
    p96._foreignEntryCount = 0;
    p96._foreignPresentationSuppressed = false;
    p96._foreignPresentationForcedSuppressed = false;
end;

function u2._init(u97) -- Line: 408
    -- upvalues: RunService (copy)
    u97._trove:Add(RunService.PreRender:Connect(function(p98) -- Line: 409
        -- upvalues: u97 (copy)
        u97:_step(p98);
    end));
end;

return u2;