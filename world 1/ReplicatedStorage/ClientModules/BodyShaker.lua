-- Decompiled with Potassium's decompiler.

local v1 = {};
local _ = game.Players.LocalPlayer;
local u2 = {};

local function ShakeBody(p3) -- Line: 8
    -- upvalues: u2 (copy)
    repeat
        task.wait();
    until p3:IsDescendantOf(workspace);

    if p3:GetAttribute("Shaking") then
        return;
    end;

    p3:SetAttribute("Shaking", true);
    local Torso = p3:WaitForChild("Torso");
    local Neck = Torso:WaitForChild("Neck");
    local v4 = Torso:WaitForChild("Left Shoulder");
    local v5 = Torso:WaitForChild("Right Shoulder");
    local v6 = Torso:WaitForChild("Left Hip");
    local v7 = Torso:WaitForChild("Right Hip");
    local C0 = v4.C0;
    local C02 = v5.C0;
    local C03 = v6.C0;
    local C04 = v7.C0;
    local C05 = Neck.C0;
    local v8 = 0;

    while p3:IsDescendantOf(workspace) and u2[p3] do
        task.wait(0);
        v8 = v8 + 1;
        local Angles = CFrame.Angles;
        local v9 = math.sin(v8) * 4;
        v4.C0 = C0 * Angles(0, math.rad(v9), 0);
        local Angles2 = CFrame.Angles;
        local v10 = math.sin(v8) * -4;
        v5.C0 = C02 * Angles2(0, math.rad(v10), 0);
        local Angles3 = CFrame.Angles;
        local v11 = math.sin(v8) * -4;
        v7.C0 = C04 * Angles3(0, math.rad(v11), 0);
        local Angles4 = CFrame.Angles;
        local v12 = math.sin(v8) * 4;
        v6.C0 = C03 * Angles4(0, math.rad(v12), 0);
        local Angles5 = CFrame.Angles;
        local v13 = math.sin(v8) * 4;
        Neck.C0 = C05 * Angles5(0, 0, (math.rad(v13)));
    end;

    v4.C0 = C0;
    v5.C0 = C02;
    v6.C0 = C03;
    v7.C0 = C04;
    Neck.C0 = C05;
    p3:SetAttribute("Shaking", false);
end;

function v1.EnableShaking(u14) -- Line: 62
    -- upvalues: ShakeBody (copy), u2 (copy)
    if u14 then
        task.spawn(function() -- Line: 64
            -- upvalues: ShakeBody (ref), u14 (copy)
            ShakeBody(u14);
        end);
    end;

    u2[u14] = true;
end;

function v1.DisableShaking(p15) -- Line: 72
    -- upvalues: u2 (copy)
    u2[p15] = false;
end;

return v1;