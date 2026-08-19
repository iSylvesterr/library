-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = false;
local v3 = {};

local function disconnectConnections() -- Line: 30
    -- upvalues: u1 (copy)
    for _, v in u1 do
        v:Disconnect();
    end;

    table.clear(u1);
end;

local function getShakeJoints(p4) -- Line: 38
    local UpperTorso = p4:WaitForChild("UpperTorso");
    local LowerTorso = p4:WaitForChild("LowerTorso");

    return {
        Neck = p4:WaitForChild("Head"):WaitForChild("Neck"),
        LeftShoulder = UpperTorso:WaitForChild("LeftShoulder"),
        RightShoulder = UpperTorso:WaitForChild("RightShoulder"),
        LeftHip = LowerTorso:WaitForChild("LeftHip"),
        RightHip = LowerTorso:WaitForChild("RightHip")
    };
end;

local function getJointDefaults(p5) -- Line: 52
    return {
        Neck = p5.Neck.C0,
        LeftShoulder = p5.LeftShoulder.C0,
        RightShoulder = p5.RightShoulder.C0,
        LeftHip = p5.LeftHip.C0,
        RightHip = p5.RightHip.C0
    };
end;

local function resetJoints(p6, p7) -- Line: 62
    p6.Neck.C0 = p7.Neck;
    p6.LeftShoulder.C0 = p7.LeftShoulder;
    p6.RightShoulder.C0 = p7.RightShoulder;
    p6.LeftHip.C0 = p7.LeftHip;
    p6.RightHip.C0 = p7.RightHip;
end;

local function shakeBody(p8) -- Line: 70
    -- upvalues: LocalPlayer (copy), Workspace (copy), getShakeJoints (copy), u2 (ref)
    local v9 = p8 or LocalPlayer.Character;

    if not v9 then
        return;
    end;

    repeat
        task.wait();
    until v9:IsDescendantOf(Workspace);

    if v9:GetAttribute("Shaking") then
        return;
    end;

    v9:SetAttribute("Shaking", true);
    local v10 = getShakeJoints(v9);
    local v11 = {
        Neck = v10.Neck.C0,
        LeftShoulder = v10.LeftShoulder.C0,
        RightShoulder = v10.RightShoulder.C0,
        LeftHip = v10.LeftHip.C0,
        RightHip = v10.RightHip.C0
    };
    local v12 = 0;

    while v9:IsDescendantOf(Workspace) and u2 do
        task.wait();
        v12 = v12 + 1;
        local v13 = math.sin(v12);
        local v14 = math.rad(v13);
        local v15 = math.rad(-v13);
        v10.LeftShoulder.C0 = v11.LeftShoulder * CFrame.Angles(0, v14, 0);
        v10.RightShoulder.C0 = v11.RightShoulder * CFrame.Angles(0, -v14, 0);
        v10.RightHip.C0 = v11.RightHip * CFrame.Angles(0, v15, 0);
        v10.LeftHip.C0 = v11.LeftHip * CFrame.Angles(0, -v15, 0);
        v10.Neck.C0 = v11.Neck * CFrame.Angles(0, 0, (math.rad(v13)));
    end;

    v10.Neck.C0 = v11.Neck;
    v10.LeftShoulder.C0 = v11.LeftShoulder;
    v10.RightShoulder.C0 = v11.RightShoulder;
    v10.LeftHip.C0 = v11.LeftHip;
    v10.RightHip.C0 = v11.RightHip;
    v9:SetAttribute("Shaking", false);
end;

function v3.EnableShaking() -- Line: 110
    -- upvalues: u1 (copy), u2 (ref), LocalPlayer (copy), shakeBody (copy)
    for _, v in u1 do
        v:Disconnect();
    end;

    table.clear(u1);
    u2 = true;

    if LocalPlayer.Character then
        task.spawn(shakeBody, LocalPlayer.Character);
    end;

    table.insert(u1, LocalPlayer.CharacterAdded:Connect(shakeBody));
end;

function v3.DisableShaking() -- Line: 122
    -- upvalues: u2 (ref), u1 (copy)
    u2 = false;

    for _, v in u1 do
        v:Disconnect();
    end;

    table.clear(u1);
end;

return v3;