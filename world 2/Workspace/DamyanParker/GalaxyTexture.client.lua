-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EffectLoadManager = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("EffectLoadManager"));
local u1 = {};

local function addTexture(p2) -- Line: 29
    -- upvalues: u1 (copy)
    if not p2:IsA("Texture") then
        return;
    end;

    local Parent = p2.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    u1[p2] = {
        driftU = 0,
        driftV = 0,
        part = Parent
    };
end;

local function removeTexture(p3) -- Line: 36
    -- upvalues: u1 (copy)
    if p3:IsA("Texture") then
        u1[p3] = nil;
    end;
end;

for _, v in CollectionService:GetTagged("GalaxyTexture") do
    addTexture(v);
end;

CollectionService:GetInstanceAddedSignal("GalaxyTexture"):Connect(addTexture);
CollectionService:GetInstanceRemovedSignal("GalaxyTexture"):Connect(removeTexture);

local function faceUV(p4, p5) -- Line: 50
    if p5 == Enum.NormalId.Top or p5 == Enum.NormalId.Bottom then
        return p4.X, p4.Z;
    end;

    if p5 == Enum.NormalId.Right or p5 == Enum.NormalId.Left then
        return p4.Z, p4.Y;
    end;

    return p4.X, p4.Y;
end;

local u6 = 0;
RunService.RenderStepped:Connect(function(p7) -- Line: 63
    -- upvalues: u6 (ref), Workspace (copy), u1 (copy), EffectLoadManager (copy)
    u6 = u6 + p7;

    if u6 < 0.05 then
        return;
    end;

    local v8 = u6;
    u6 = 0;
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local Position = CurrentCamera.CFrame.Position;

    for i, v in u1 do
        local part = v.part;

        if EffectLoadManager.DistanceIntervalMultiplier(part) then
            local v9 = Position - part.Position;

            if v9.Magnitude >= 0.0001 then
                local v10 = part.CFrame:VectorToObjectSpace(v9.Unit);
                local Face = i.Face;
                local v11, v12;

                if Face == Enum.NormalId.Top or Face == Enum.NormalId.Bottom then
                    v11 = v10.X;
                    v12 = v10.Z;
                elseif Face == Enum.NormalId.Right or Face == Enum.NormalId.Left then
                    v11 = v10.Z;
                    v12 = v10.Y;
                else
                    v11 = v10.X;
                    v12 = v10.Y;
                end;

                v.driftU = v.driftU + v8 * 0.05;
                v.driftV = v.driftV + v8 * 0.25;
                i.OffsetStudsU = v11 * 2 + v.driftU;
                i.OffsetStudsV = v12 * 2 + v.driftV;
            end;
        end;
    end;
end);