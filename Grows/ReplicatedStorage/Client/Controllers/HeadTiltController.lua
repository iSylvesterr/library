-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local v1 = Knit.CreateController({
    Name = "HeadTiltController"
});
local LocalPlayer = Players.LocalPlayer;

local function getNeck(p2) -- Line: 18
    if p2 then
        p2 = p2:FindFirstChild("Torso");
    end;

    if p2 then
        p2 = p2:FindFirstChild("Neck");
    end;

    if not (p2 and (p2:IsA("Motor6D") and p2)) then
        p2 = nil;
    end;

    return p2;
end;

local function applyTilt(p3, p4) -- Line: 24
    if p3 then
        p3 = p3:FindFirstChild("Torso");
    end;

    if p3 then
        p3 = p3:FindFirstChild("Neck");
    end;

    if not (p3 and (p3:IsA("Motor6D") and p3)) then
        p3 = nil;
    end;

    if not p3 then
        return;
    end;

    local v5 = CFrame.new(p3.C0.Position) * p3.C1.Rotation * CFrame.Angles(-p4, 0, 0);
    p3.C0 = p3.C0:Lerp(v5, 0.25);
end;

function v1.KnitStart(p6) -- Line: 33
    -- upvalues: Knit (copy), Players (copy), RunService (copy), LocalPlayer (copy), applyTilt (copy)
    local u7 = Knit.GetService("HeadTiltService");
    local u8 = {};
    u7.TiltChanged:Connect(function(p9, p10) -- Line: 38
        -- upvalues: u8 (copy)
        u8[p9] = p10;
    end);
    Players.PlayerRemoving:Connect(function(p11) -- Line: 42
        -- upvalues: u8 (copy)
        u8[p11.UserId] = nil;
    end);
    local u12 = 0;
    local u13 = 0;
    RunService.Heartbeat:Connect(function(p14) -- Line: 48
        -- upvalues: LocalPlayer (ref), applyTilt (ref), u12 (ref), u13 (ref), u7 (copy), Players (ref), u8 (copy)
        local Character = LocalPlayer.Character;
        local CurrentCamera = workspace.CurrentCamera;

        if Character and CurrentCamera then
            local v15 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
            local v16 = math.asin(v15);
            local v17 = math.clamp(v16, 0, 1.0471975511965976);
            applyTilt(Character, v17);
            u12 = u12 + p14;

            if u12 >= 0.1 then
                u12 = 0;

                if math.abs(v17 - u13) > 0.03490658503988659 then
                    u13 = v17;
                    u7.UpdateTilt:Fire(v17);
                end;
            end;
        end;

        for _, v in Players:GetPlayers() do
            if v ~= LocalPlayer then
                local v18 = u8[v.UserId];

                if v18 then
                    applyTilt(v.Character, v18);
                end;
            end;
        end;
    end);
end;

return v1;