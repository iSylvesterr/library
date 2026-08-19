-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Player = require(ReplicatedStorage.Library.Player);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Enum.RenderPriority.Camera.Value + 3;
local u2 = Log.new();
local LocalPlayer = Players.LocalPlayer;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = nil;
local u9 = false;
local u18 = {
    _restorePart = function(p10, p11) -- Line: 54, Name: _restorePart
        local v12 = p10[p11];

        if v12 == nil then
            return;
        end;

        p10[p11] = nil;

        if p11.Parent ~= nil then
            p11.Transparency = v12;
        end;
    end,

    _applyPart = function(p13, p14, p15) -- Line: 66, Name: _applyPart
        local v16 = p13[p14];

        if p14.Transparency >= 1 then
            return;
        end;

        if v16 == nil then
            v16 = p14.Transparency;

            if p15 <= v16 then
                return;
            end;

            p13[p14] = v16;
        end;

        p14.Transparency = math.max(v16, p15);
    end,

    _restoreModel = function(p17) -- Line: 88, Name: _restoreModel
        p17.RestoreAt = nil;
        local FadeSnapshot = p17.FadeSnapshot;

        if FadeSnapshot == nil then
            return;
        end;

        for i, v in pairs(FadeSnapshot) do
            if i.Parent ~= nil then
                i.Transparency = v;
            end;
        end;

        table.clear(FadeSnapshot);
        p17.FadeSnapshot = nil;
    end
};

function u18._reconcileModel(p19, p20, p21) -- Line: 104
    -- upvalues: u18 (copy)
    if p20 then
        p19.RestoreAt = nil;
        u18._fadeModel(p19);

        return;
    end;

    if p19.FadeSnapshot == nil then
        p19.RestoreAt = nil;

        return;
    end;

    local RestoreAt = p19.RestoreAt;

    if RestoreAt == nil then
        p19.RestoreAt = p21 + 1;

        return;
    end;

    if RestoreAt <= p21 then
        u18._restoreModel(p19);
    end;
end;

function u18._fadeModel(p22) -- Line: 127
    -- upvalues: u18 (copy)
    local FadeSnapshot = p22.FadeSnapshot;

    if FadeSnapshot ~= nil then
        for i in pairs(p22.Parts) do
            u18._applyPart(FadeSnapshot, i, p22.TargetTransparency);
        end;

        return;
    end;

    local v23 = {};
    p22.FadeSnapshot = v23;

    for i in pairs(p22.Parts) do
        u18._applyPart(v23, i, p22.TargetTransparency);
    end;
end;

function u18._restoreAll() -- Line: 143
    -- upvalues: u3 (copy), u18 (copy), u5 (copy)
    for _, v in pairs(u3) do
        u18._restoreModel(v);
    end;

    table.clear(u5);
end;

function u18._trackPart(p24, p25, p26) -- Line: 150
    -- upvalues: u4 (copy), u18 (copy)
    if not p26:IsA("BasePart") then
        return;
    end;

    local v27 = u4[p26] == nil;
    local v28 = `Tracked camera-occlusion part {p26:GetFullName()} is already tracked`;
    assert(v27, v28);
    p25.Parts[p26] = true;
    u4[p26] = p24;
    local FadeSnapshot = p25.FadeSnapshot;

    if FadeSnapshot ~= nil then
        u18._applyPart(FadeSnapshot, p26, p25.TargetTransparency);
    end;
end;

function u18._untrackPart(p29, p30) -- Line: 168
    -- upvalues: u18 (copy), u4 (copy)
    if not p30:IsA("BasePart") or p29.Parts[p30] ~= true then
        return;
    end;

    local FadeSnapshot = p29.FadeSnapshot;

    if FadeSnapshot ~= nil then
        u18._restorePart(FadeSnapshot, p30);
    end;

    p29.Parts[p30] = nil;
    u4[p30] = nil;
end;

function u18._isBottomNearPlayer(p31, p32) -- Line: 181
    local v33 = p31.Model:GetScale() / p31.InitialModelScale;
    local VisibleBoundsOffset = p31.VisibleBoundsOffset;
    local v34 = CFrame.new(VisibleBoundsOffset.Position * v33) * VisibleBoundsOffset.Rotation;
    local v35 = p31.PrimaryPart.CFrame * v34;
    local v36 = v35:PointToObjectSpace(p32.Position);
    local v37 = p31.VisibleBoundsSize * v33 * 0.5;
    local v38 = math.clamp(v36.X, -v37.X, v37.X);
    local v39 = -v37.Y;
    local v40 = math.clamp(v36.Z, -v37.Z, v37.Z);
    local v41 = v35:PointToWorldSpace((Vector3.new(v38, v39, v40))) - p32.Position;

    return v41.X * v41.X + v41.Z * v41.Z <= 625;
end;

function u18._step() -- Line: 200
    -- upvalues: u9 (ref), u18 (copy), Workspace (copy), Player (copy), LocalPlayer (copy), u6 (copy), u7 (copy), u5 (copy), u4 (copy), u3 (copy)
    if not u9 then
        u18._restoreAll();

        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    local v42 = Player.Optional.Character(LocalPlayer);
    local v43 = Player.Optional.Head(LocalPlayer);
    local v44 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if CurrentCamera == nil or (v42 == nil or (v43 == nil or v44 == nil)) then
        u18._restoreAll();

        return;
    end;

    u6[1] = v43.Position;
    u7[1] = v42;
    table.clear(u5);

    for _, v in ipairs(CurrentCamera:GetPartsObscuringTarget(u6, u7)) do
        local v45 = u4[v];

        if v45 ~= nil and u5[v45] ~= true then
            u5[v45] = true;
        end;
    end;

    local v46 = Workspace:GetServerTimeNow();

    for i, v in pairs(u3) do
        if not v.Suppressed then
            local v47 = u5[i] == true and true or u18._isBottomNearPlayer(v, v44);
            u18._reconcileModel(v, v47, v46);
        end;
    end;
end;

function u18.TrackModel(u48, p49) -- Line: 240
    -- upvalues: Asserts (copy), u3 (copy), Trove (copy), BBFromModelVisibleOnly (copy), u18 (copy)
    Asserts.Model(u48);
    Asserts.number(p49);
    local v50;

    if p49 >= 0 then
        v50 = p49 <= 1;
    else
        v50 = false;
    end;

    assert(v50, "Target transparency must be within [0, 1]");
    local v51 = u3[u48] == nil;
    local v52 = `Tracked camera-occlusion model {u48.Name} is already tracked`;
    assert(v51, v52);
    local v53 = Trove.new();
    local PrimaryPart = u48.PrimaryPart;
    local v54 = `Tracked camera-occlusion model {u48.Name} must have a PrimaryPart`;
    local v55 = assert(PrimaryPart, v54);
    local v56 = u48:GetScale();
    local v57 = `Tracked camera-occlusion model {u48.Name} must have positive scale`;
    assert(v56 > 0, v57);
    local v58, v59 = BBFromModelVisibleOnly(u48);
    local u60 = {
        FadeSnapshot = nil,
        RestoreAt = nil,
        Suppressed = false,
        Trove = v53,
        Model = u48,
        Parts = {},
        TargetTransparency = p49,
        InitialModelScale = v56,
        PrimaryPart = v55,
        VisibleBoundsOffset = v55.CFrame:ToObjectSpace(v58),
        VisibleBoundsSize = v59
    };
    u3[u48] = u60;

    for _, descendant in ipairs(u48:GetDescendants()) do
        u18._trackPart(u48, u60, descendant);
    end;

    v53:Connect(u48.DescendantAdded, function(p61) -- Line: 269
        -- upvalues: u18 (ref), u48 (copy), u60 (copy)
        u18._trackPart(u48, u60, p61);
    end);
    v53:Connect(u48.DescendantRemoving, function(p62) -- Line: 272
        -- upvalues: u18 (ref), u60 (copy)
        u18._untrackPart(u60, p62);
    end);
end;

function u18.UntrackModel(p63) -- Line: 277
    -- upvalues: Asserts (copy), u3 (copy), u18 (copy), u4 (copy), u5 (copy)
    Asserts.Model(p63);
    local v64 = u3[p63];
    local v65 = `Tracked camera-occlusion model {p63.Name} is not tracked`;
    local v66 = assert(v64, v65);
    u18._restoreModel(v66);

    for i in pairs(v66.Parts) do
        u4[i] = nil;
    end;

    v66.Trove:Destroy();
    table.clear(v66.Parts);
    u3[p63] = nil;
    u5[p63] = nil;
end;

function u18.SetModelSuppressed(p67, p68) -- Line: 291
    -- upvalues: Asserts (copy), u3 (copy), u18 (copy), u5 (copy)
    Asserts.Model(p67);
    Asserts.boolean(p68);
    local v69 = u3[p67];
    local v70 = `Tracked camera-occlusion model {p67.Name} is not tracked`;
    local v71 = assert(v69, v70);

    if v71.Suppressed == p68 then
        return;
    end;

    v71.Suppressed = p68;

    if p68 then
        u18._restoreModel(v71);
        u5[p67] = nil;
    end;
end;

function u18.SetSessionActive(p72) -- Line: 306
    -- upvalues: Asserts (copy), u9 (ref), u8 (ref), u18 (copy), u2 (copy), RenderStepped (copy), u1 (copy)
    Asserts.boolean(p72);

    if p72 then
        if u9 then
            return;
        end;

        assert(u8 == nil, "Inactive model camera occlusion scheduler must not exist");
        u9 = true;
        u8 = RenderStepped(u18._step, nil, nil, nil, u1);
        u2:AtDebug():Log("Started model camera occlusion");

        return;
    end;

    local v73 = u9;
    u9 = false;
    local v74 = u8;
    u8 = nil;

    if v74 ~= nil then
        v74:Destroy();
    end;

    u18._restoreAll();

    if v73 then
        u2:AtDebug():Log("Stopped model camera occlusion");
    end;
end;

return u18;