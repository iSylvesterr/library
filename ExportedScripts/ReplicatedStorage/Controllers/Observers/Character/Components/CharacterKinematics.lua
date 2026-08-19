-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local u2 = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};

local function getJoints(p9) -- Line: 61
    local RightShoulder = p9:FindFirstChild("RightShoulder", true);
    local LeftShoulder = p9:FindFirstChild("LeftShoulder", true);
    local RootJoint = p9:FindFirstChild("RootJoint", true);

    return RightShoulder, LeftShoulder, p9:FindFirstChild("Waist", true), p9:FindFirstChild("Neck", true), RootJoint;
end;

local function lerpAngle(p10, p11, p12) -- Line: 73
    local v13 = p11 - p10;

    while v13 > 3.141592653589793 do
        v13 = v13 - 6.283185307179586;
    end;

    while v13 < -3.141592653589793 do
        v13 = v13 + 6.283185307179586;
    end;

    return p10 + v13 * p12;
end;

local function buildJointCache(p14, p15) -- Line: 84
    -- upvalues: getJoints (copy), u7 (copy)
    local v16, v17, v18, v19, v20 = getJoints(p15);

    if not (v16 and (v17 and v18)) then
        u7[p14] = nil;

        return nil;
    end;

    local v21 = {
        LastAppliedRotation = nil,
        LastAppliedVerticalLook = nil,
        Character = p15,
        RightShoulder = v16,
        LeftShoulder = v17,
        Waist = v18,
        Neck = v19,
        RootJoint = v20,
        BaseC0 = {
            v16.C0,
            v17.C0,
            v18.C0,
            v19 and v19.C0 or nil,
            v20 and v20.C0 or nil
        }
    };
    u7[p14] = v21;

    return v21;
end;

local function getJointCache(p22) -- Line: 115
    -- upvalues: u7 (copy), buildJointCache (copy)
    local Character = p22.Character;

    if not Character then
        u7[p22] = nil;

        return nil;
    end;

    local v23 = u7[p22];

    if v23 and (v23.Character == Character and (v23.RightShoulder.Parent and (v23.LeftShoulder.Parent and (v23.Waist.Parent and (not v23.Neck or v23.Neck.Parent))))) then
        return v23;
    end;

    return buildJointCache(p22, Character);
end;

function v1.updateKinematics(p24, p25, p26) -- Line: 139
    -- upvalues: getJointCache (copy), TweenService (copy), u2 (copy)
    local v27 = getJointCache(p24);

    if not v27 or v27.Character ~= p25 then
        return;
    end;

    local BaseC0 = v27.BaseC0;
    TweenService:Create(v27.RightShoulder, u2, {
        C0 = BaseC0[1] * CFrame.Angles(1.0471975511965976 * p26.LookVector.Y * 0.5, 0, 0)
    }):Play();
    TweenService:Create(v27.LeftShoulder, u2, {
        C0 = BaseC0[2] * CFrame.Angles(1.0471975511965976 * p26.LookVector.Y * 0.5, 0, 0)
    }):Play();
    TweenService:Create(v27.Waist, u2, {
        C0 = BaseC0[3] * CFrame.Angles(1.0471975511965976 * p26.LookVector.Y * 0.6, 0, 0)
    }):Play();

    if v27.Neck and BaseC0[4] then
        TweenService:Create(v27.Neck, u2, {
            C0 = BaseC0[4] * CFrame.Angles(1.0471975511965976 * p26.LookVector.Y, 0, 0)
        }):Play();
    end;
end;

function v1.setTargetRotation(p28, p29) -- Line: 169
    -- upvalues: u3 (copy), u4 (copy), getJointCache (copy)
    u3[p28] = p29;

    if u4[p28] == nil then
        u4[p28] = p29;
    end;

    getJointCache(p28);
end;

function v1.setVerticalLook(p30, p31) -- Line: 182
    -- upvalues: u5 (copy), u6 (copy)
    u5[p30] = p31;

    if u6[p30] == nil then
        u6[p30] = p31;
    end;
end;

local function armFlinch(p32, p33) -- Line: 193
    -- upvalues: u8 (copy)
    local v34 = u8[p32];

    if not (v34 and v34.Neck.Parent) then
        local UpperTorso = p32:FindFirstChild("UpperTorso");
        local v35;

        if UpperTorso then
            v35 = UpperTorso:FindFirstChild("Head");
        else
            v35 = nil;
        end;

        if not (v35 and v35:IsA("Motor6D")) then
            warn((`[CharacterKinematics] No UpperTorso Head Motor6D found on {p32:GetFullName()}; hit flinch skipped`));

            return nil;
        end;

        local Waist = p32:FindFirstChild("Waist", true);
        v34 = {
            HeadPitch = 0,
            BodyPitch = 0,
            Neck = v35,
            BaseC1 = v35.C1,
            Waist = Waist
        };

        if Waist then
            Waist = Waist.C1;
        end;

        v34.WaistBaseC1 = Waist;
        u8[p32] = v34;
    end;

    local Part1 = v34.Neck.Part1;
    local v36 = not (p33 and Part1) and Vector3.new(0, 0, 1) or Part1.CFrame:VectorToObjectSpace(p33);
    local v37 = Vector3.new(v36.X, 0, v36.Z);
    v34.Axis = v37.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or (Vector3.new(0, 1, 0)):Cross(v37.Unit);
    local v38;

    if Part1 then
        v38 = CFrame.new(0, -Part1.Size.Y / 2, 0);
    else
        v38 = CFrame.identity;
    end;

    v34.Pivot = v38;

    return v34;
end;

function v1.flickHead(p39, p40) -- Line: 221
    -- upvalues: armFlinch (copy)
    local v41 = armFlinch(p39, p40);

    if v41 then
        v41.HeadPitch = math.min(1.5707963267948966, v41.HeadPitch + 1.2217304763960306);
    end;
end;

function v1.flinchBody(p42, p43) -- Line: 228
    -- upvalues: armFlinch (copy)
    local v44 = armFlinch(p42, p43);

    if v44 then
        v44.BodyPitch = math.min(0.4363323129985824, v44.BodyPitch + 0.24434609527920614);
    end;
end;

local function clearFlickState(p45) -- Line: 238
    -- upvalues: u8 (copy)
    local v46;

    if p45 then
        v46 = u8[p45];
    else
        v46 = nil;
    end;

    if not (p45 and v46) then
        return;
    end;

    if v46.Neck.Parent then
        v46.Neck.C1 = v46.BaseC1;

        if v46.Waist then
            v46.Waist.C1 = v46.WaistBaseC1;
        end;
    end;

    u8[p45] = nil;
end;

function v1.cleanup(p47) -- Line: 254
    -- upvalues: u7 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy), u8 (copy), Workspace (copy), TweenService (copy), u2 (copy)
    local v48 = u7[p47];
    u7[p47] = nil;
    u3[p47] = nil;
    u4[p47] = nil;
    u5[p47] = nil;
    u6[p47] = nil;

    if v48 then
        local Character = v48.Character;
        local v49;

        if Character then
            v49 = u8[Character];
        else
            v49 = nil;
        end;

        if Character and v49 then
            if v49.Neck.Parent then
                v49.Neck.C1 = v49.BaseC1;

                if v49.Waist then
                    v49.Waist.C1 = v49.WaistBaseC1;
                end;
            end;

            u8[Character] = nil;
        end;
    end;

    if v48 and (v48.Character and v48.Character:IsDescendantOf(Workspace)) then
        if not v48.RightShoulder.Parent or (not v48.LeftShoulder.Parent or (not v48.Waist.Parent or v48.Neck and not v48.Neck.Parent)) then
            return;
        end;

        TweenService:Create(v48.RightShoulder, u2, {
            C0 = v48.BaseC0[1]
        }):Play();
        TweenService:Create(v48.LeftShoulder, u2, {
            C0 = v48.BaseC0[2]
        }):Play();
        TweenService:Create(v48.Waist, u2, {
            C0 = v48.BaseC0[3]
        }):Play();

        if v48.Neck and v48.BaseC0[4] then
            TweenService:Create(v48.Neck, u2, {
                C0 = v48.BaseC0[4]
            }):Play();
        end;

        if v48.RootJoint and v48.BaseC0[5] then
            v48.RootJoint.C0 = v48.BaseC0[5];
        end;
    end;
end;

RunServiceController.BindToRenderStep("Observers.CharacterKinematics.Update", function(p50) -- Line: 304
    -- upvalues: u8 (copy), u3 (copy), getJointCache (copy), u4 (copy), u5 (copy), u6 (copy)
    local v51 = math.min(1, p50 * 15);
    local v52 = math.exp(p50 * -12);

    for i, v in pairs(u8) do
        local Neck = v.Neck;

        if Neck.Parent then
            if v.HeadPitch > 0 or v.BodyPitch > 0 then
                v.HeadPitch = v.HeadPitch * v52;
                v.BodyPitch = v.BodyPitch * v52;

                if v.HeadPitch + v.BodyPitch <= 0.008726646259971648 then
                    Neck.C1 = v.BaseC1;

                    if v.Waist then
                        v.Waist.C1 = v.WaistBaseC1;
                    end;

                    v.HeadPitch = 0;
                    v.BodyPitch = 0;
                else
                    local v53 = v.HeadPitch * 0.3 + v.BodyPitch;
                    Neck.C1 = v.Pivot * CFrame.fromAxisAngle(v.Axis, -(v.HeadPitch + v.BodyPitch * 0.5)) * v.Pivot:Inverse() * v.BaseC1;

                    if v.Waist then
                        v.Waist.C1 = v.WaistBaseC1 * CFrame.fromAxisAngle(v.Axis, -v53);
                    end;
                end;
            end;
        else
            u8[i] = nil;
        end;
    end;

    for i, v in pairs(u3) do
        local v54 = getJointCache(i);

        if v54 then
            local v55;

            if u4[i] == nil then
                v55 = v;
            else
                v55 = u4[i];
            end;

            local v56 = v - v55;

            while v56 > 3.141592653589793 do
                v56 = v56 - 6.283185307179586;
            end;

            while v56 < -3.141592653589793 do
                v56 = v56 + 6.283185307179586;
            end;

            local v57 = v55 + v56 * v51;
            u4[i] = v57;
            local BaseC0 = v54.BaseC0;
            local v58 = BaseC0[5];

            if v54.RootJoint and (v58 and (not v54.LastAppliedRotation or math.abs(v57 - v54.LastAppliedRotation) >= 0.0001)) then
                v54.RootJoint.C0 = CFrame.new(v58.Position) * CFrame.Angles(0, v57, 0);
                v54.LastAppliedRotation = v57;
            end;

            local v59 = u5[i];

            if v59 ~= nil then
                local v60;

                if u6[i] == nil then
                    v60 = v59;
                else
                    v60 = u6[i];
                end;

                local v61 = v60 + (v59 - v60) * v51;
                u6[i] = v61;

                if not v54.LastAppliedVerticalLook or math.abs(v61 - v54.LastAppliedVerticalLook) >= 0.0001 then
                    v54.RightShoulder.C0 = BaseC0[1] * CFrame.Angles(v61 * 1.0471975511965976 * 0.5, 0, 0);
                    v54.LeftShoulder.C0 = BaseC0[2] * CFrame.Angles(v61 * 1.0471975511965976 * 0.5, 0, 0);
                    v54.Waist.C0 = BaseC0[3] * CFrame.Angles(v61 * 1.0471975511965976 * 0.6, 0, 0);

                    if v54.Neck and BaseC0[4] then
                        v54.Neck.C0 = BaseC0[4] * CFrame.Angles(v61 * 1.0471975511965976, 0, 0);
                    end;

                    v54.LastAppliedVerticalLook = v61;
                end;
            end;
        end;
    end;
end);
Players.PlayerRemoving:Connect(function(p62) -- Line: 390
    -- upvalues: u7 (copy), u8 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy)
    local v63 = u7[p62];

    if v63 then
        local Character = v63.Character;
        local v64;

        if Character then
            v64 = u8[Character];
        else
            v64 = nil;
        end;

        if Character and v64 then
            if v64.Neck.Parent then
                v64.Neck.C1 = v64.BaseC1;

                if v64.Waist then
                    v64.Waist.C1 = v64.WaistBaseC1;
                end;
            end;

            u8[Character] = nil;
        end;
    end;

    local Character = p62.Character;
    local v65;

    if Character then
        v65 = u8[Character];
    else
        v65 = nil;
    end;

    if Character and v65 then
        if v65.Neck.Parent then
            v65.Neck.C1 = v65.BaseC1;

            if v65.Waist then
                v65.Waist.C1 = v65.WaistBaseC1;
            end;
        end;

        u8[Character] = nil;
    end;

    u7[p62] = nil;
    u3[p62] = nil;
    u4[p62] = nil;
    u5[p62] = nil;
    u6[p62] = nil;
end);

return v1;