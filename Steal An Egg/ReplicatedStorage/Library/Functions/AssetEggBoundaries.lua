-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Boundary = ReplicatedStorage.Assets.Extra.Boundary;

return {
    createBoundary = function(p1) -- Line: 17, Name: createBoundary
        -- upvalues: Asserts (copy), Boundary (copy), Constants (copy)
        Asserts.Model(p1);
        local Boundary2 = p1:FindFirstChild("Boundary");

        if Boundary2 then
            return Boundary2;
        end;

        local v2 = Boundary:Clone();
        v2.Size = Vector3.new(0.15, Constants.MIN_PLACE_GRID_SIZE, Constants.MIN_PLACE_GRID_SIZE);
        v2.CFrame = p1:GetPivot() * CFrame.fromEulerAnglesXYZ(0, 0, 1.5707963267948966);
        v2.Name = "Boundary";
        v2.Anchored = true;
        v2.CanCollide = false;
        v2.Color = Color3.fromRGB(248, 248, 248);
        v2.Transparency = 0.9;
        v2:SetAttribute("MutationFXDontRender", true);
        v2:SetAttribute("EggBoundary", true);
        v2.Parent = p1;

        return v2;
    end,

    createServerBoundary = function(p3) -- Line: 39, Name: createServerBoundary
        -- upvalues: Asserts (copy), Constants (copy)
        Asserts.Model(p3);
        local ServerBoundary = p3:FindFirstChild("ServerBoundary");

        if ServerBoundary then
            return ServerBoundary;
        end;

        local Part = Instance.new("Part");
        Part.Name = "ServerBoundary";
        Part.Size = Vector3.new(0.15, Constants.SERVER_MIN_GRID_SIZE, Constants.SERVER_MIN_GRID_SIZE);
        Part.CFrame = p3:GetPivot() * CFrame.fromEulerAnglesXYZ(0, 0, 1.5707963267948966);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Transparency = 1;
        Part:SetAttribute("MutationFXDontRender", true);
        Part:SetAttribute("EggBoundary", true);
        Part.Parent = p3;

        return Part;
    end
};