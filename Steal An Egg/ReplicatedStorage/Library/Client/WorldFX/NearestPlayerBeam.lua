-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Asserts = require(script.Parent.Parent.Parent.Asserts);
local TutorialBeam = require(script.Parent.TutorialBeam);
local Trove = require(script.Parent.Parent.Parent.Modules.Packages.Trove);
local LocalPlayer = Players.LocalPlayer;
local v1 = {};

local function getRootPart(p2) -- Line: 44
    local Character = p2.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

local function resolveNearestTarget(p3) -- Line: 58
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v4;

    if Character then
        v4 = Character:FindFirstChild("HumanoidRootPart");

        if not (v4 and v4:IsA("BasePart")) then
            v4 = nil;
        end;
    else
        v4 = nil;
    end;

    if not v4 then
        return nil;
    end;

    local v5 = nil;
    local v6 = nil;

    for _, v in ipairs(p3._getCandidates()) do
        if v ~= LocalPlayer then
            local Character2 = v.Character;
            local v7;

            if Character2 then
                v7 = Character2:FindFirstChild("HumanoidRootPart");

                if not (v7 and v7:IsA("BasePart")) then
                    v7 = nil;
                end;
            else
                v7 = nil;
            end;

            if v7 then
                local Magnitude = (v7.Position - v4.Position).Magnitude;

                if v5 == nil or Magnitude < v5 then
                    v6 = v7;
                    v5 = Magnitude;
                end;
            end;
        end;
    end;

    return v6;
end;

local function updateBeam(p8) -- Line: 82
    -- upvalues: resolveNearestTarget (copy), TutorialBeam (copy)
    local v9 = resolveNearestTarget(p8);
    local v10 = v9 ~= p8._currentTarget;

    if v10 then
        p8._currentTarget = v9;
        local _onTargetChanged = p8._onTargetChanged;

        if _onTargetChanged then
            _onTargetChanged(v9);
        end;
    end;

    if not v9 then
        local _beamState = p8._beamState;

        if _beamState then
            TutorialBeam.Destroy(_beamState);
            p8._beamState = nil;
        end;

        return;
    end;

    local _beamState = p8._beamState;

    if _beamState then
        if v10 then
            TutorialBeam.UpdateTarget(_beamState, v9);
        end;

        return;
    end;

    p8._beamState = TutorialBeam.Create(v9, p8._beamOptions);
end;

function v1.Create(p11) -- Line: 114
    -- upvalues: Asserts (copy), Trove (copy), RunService (copy), updateBeam (copy)
    Asserts.table(p11);
    local v12 = type(p11.GetCandidates) == "function";
    assert(v12, "NearestPlayerBeam requires a GetCandidates function");
    local v13 = p11.UpdateInterval or 0.16666666666666666;
    assert(v13 > 0, "NearestPlayerBeam update interval must be positive");
    local v14 = Trove.new();
    local u15 = {
        _beamState = nil,
        _currentTarget = nil,
        _trove = v14,
        _beamOptions = p11.Beam,
        _getCandidates = p11.GetCandidates,
        _updateInterval = v13,
        _elapsed = v13,
        _onTargetChanged = p11.OnTargetChanged
    };
    v14:Connect(RunService.Heartbeat, function(p16) -- Line: 133
        -- upvalues: u15 (copy), updateBeam (ref)
        local v17 = u15;
        v17._elapsed = v17._elapsed + p16;

        if u15._elapsed < u15._updateInterval then
            return;
        end;

        u15._elapsed = 0;
        updateBeam(u15);
    end);
    updateBeam(u15);

    return u15;
end;

function v1.Destroy(p18) -- Line: 147
    -- upvalues: Asserts (copy), TutorialBeam (copy)
    Asserts.table(p18);
    local _beamState = p18._beamState;

    if _beamState then
        TutorialBeam.Destroy(_beamState);
        p18._beamState = nil;
    end;

    p18._currentTarget = nil;
    local _onTargetChanged = p18._onTargetChanged;

    if _onTargetChanged then
        _onTargetChanged(nil);
    end;

    p18._trove:Destroy();
end;

return v1;