-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local u2 = Color3.fromRGB(104, 189, 51);
local u3 = {};
local u4 = nil;

local function stopSpinLoop() -- Line: 50
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function step() -- Line: 57
    -- upvalues: u3 (ref), u4 (ref)
    local v5 = os.clock();
    local v6 = false;

    for i, v in u3 do
        if i:IsDescendantOf(workspace) then
            local SpinStart = v.SpinStart;

            if SpinStart then
                local v7 = math.min((v5 - SpinStart) / 0.6, 1);

                if v7 >= 1 then
                    i.CFrame = v.BaseCFrame;
                    v.SpinStart = nil;
                else
                    local Position = v.BaseCFrame.Position;
                    i.CFrame = CFrame.new(Position) * CFrame.Angles(0, (1 - (1 - v7) ^ 3) * 6.283185307179586, 0) * CFrame.new(-Position) * v.BaseCFrame;
                    v6 = true;
                end;
            end;
        else
            u3[i] = nil;
        end;
    end;

    if not v6 and u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function activate(p8) -- Line: 92
    -- upvalues: u3 (ref), u2 (copy), u4 (ref), RunService (copy), step (copy)
    local v9 = u3[p8];

    if not v9 then
        v9 = {
            SpinStart = nil,
            BaseCFrame = p8.CFrame,
            BaseColor = p8.Color
        };
        u3[p8] = v9;
    end;

    p8.Color = u2;

    if not v9.SpinStart then
        v9.SpinStart = os.clock();
    end;

    if not u4 then
        u4 = RunService.RenderStepped:Connect(step);
    end;
end;

local function restoreAll() -- Line: 118
    -- upvalues: u4 (ref), u3 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    for i, v in u3 do
        if i:IsDescendantOf(workspace) then
            i.Color = v.BaseColor;
            i.CFrame = v.BaseCFrame;
        end;
    end;

    u3 = {};
end;

function v1.Init(p10) -- Line: 130
end;

function v1.Start(p11) -- Line: 132
    -- upvalues: Networking (copy), activate (copy), LocalPlayer (copy), restoreAll (copy)
    Networking.Beanstalk.CheckpointReached.OnClientEvent:Connect(function(p12) -- Line: 133
        -- upvalues: activate (ref)
        if p12 and p12:IsA("BasePart") then
            activate(p12);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("InBeanstalkClimb"):Connect(function() -- Line: 139
        -- upvalues: LocalPlayer (ref), restoreAll (ref)
        if LocalPlayer:GetAttribute("InBeanstalkClimb") ~= true then
            restoreAll();
        end;
    end);
end;

return v1;