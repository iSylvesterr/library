-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GameRules = require(ReplicatedStorage.Modules.GameRules);
local LocalPlayer = Players.LocalPlayer;
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");
local v1 = {};
local u2 = GameRules.BOOMBOX_RANGE * 2 - 4;
local u3 = nil;
local u4 = nil;

local function buildDisc() -- Line: 33
    -- upvalues: u2 (copy), Visuals (copy)
    local Part = Instance.new("Part");
    Part.Name = "BoomboxRangeDisc";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.CastShadow = false;
    Part.Size = Vector3.new(0.2, u2, u2);
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(212, 0, 255);
    Part.Transparency = 0.95;
    Part.Parent = Visuals;
    script:WaitForChild("Attachment"):Clone().Parent = Part;

    return Part;
end;

local function stop() -- Line: 57
    -- upvalues: u4 (ref), u3 (ref), Visuals (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    u3 = nil;

    for _, descendant in Visuals:GetDescendants() do
        if descendant.Name == "BoomboxRangeDisc" then
            descendant:Destroy();
        end;
    end;
end;

local function start() -- Line: 76
    -- upvalues: stop (copy), u3 (ref), buildDisc (copy), u4 (ref), RunService (copy), LocalPlayer (copy)
    stop();
    u3 = buildDisc();
    u4 = RunService.RenderStepped:Connect(function() -- Line: 84
        -- upvalues: LocalPlayer (ref), u3 (ref)
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not (Character and u3) then
            if u3 then
                u3.Transparency = 1;
            end;

            return;
        end;

        u3.Transparency = 0.95;
        u3.CFrame = CFrame.new(Character.Position - Vector3.new(0, Character.Size.Y / 2 + 1.5, 0)) * CFrame.Angles(0, 0, 1.5707963267948966);
    end);
end;

function v1.Play(p5) -- Line: 99
    -- upvalues: stop (copy), u3 (ref), buildDisc (copy), u4 (ref), RunService (copy), LocalPlayer (copy)
    if not (p5 and p5.Active) then
        stop();

        return;
    end;

    stop();
    u3 = buildDisc();
    u4 = RunService.RenderStepped:Connect(function() -- Line: 84
        -- upvalues: LocalPlayer (ref), u3 (ref)
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not (Character and u3) then
            if u3 then
                u3.Transparency = 1;
            end;

            return;
        end;

        u3.Transparency = 0.95;
        u3.CFrame = CFrame.new(Character.Position - Vector3.new(0, Character.Size.Y / 2 + 1.5, 0)) * CFrame.Angles(0, 0, 1.5707963267948966);
    end);
end;

return v1;