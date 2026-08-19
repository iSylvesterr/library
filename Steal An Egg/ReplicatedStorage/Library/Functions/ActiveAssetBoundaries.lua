-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Boundary = ReplicatedStorage.Assets.Extra.Boundary;

return {
    createBoundary = function(p1) -- Line: 17, Name: createBoundary
        -- upvalues: Asserts (copy), Constants (copy), Boundary (copy)
        Asserts.Model(p1);
        local Boundary2 = p1:FindFirstChild("Boundary");

        if Boundary2 then
            return Boundary2;
        end;

        local _, v2 = p1:GetBoundingBox();
        local MIN_PLACE_GRID_SIZE = Constants.MIN_PLACE_GRID_SIZE;
        local v3 = v2.Z * 1.3;
        local v4 = math.round(v2.X * 1.3 / MIN_PLACE_GRID_SIZE);
        local v5 = math.clamp(v4, 1, 2);
        local v6 = math.round(v3 / MIN_PLACE_GRID_SIZE);
        local v7 = math.clamp(v6, 1, 2);
        local v8 = Boundary:Clone();
        v8.Size = Vector3.new(0.15, v5 * MIN_PLACE_GRID_SIZE, v7 * MIN_PLACE_GRID_SIZE);
        v8.CFrame = p1:GetPivot() * CFrame.fromEulerAnglesXYZ(0, 0, 1.5707963267948966);
        v8.Name = "Boundary";
        v8.Anchored = true;
        v8.CanCollide = false;
        v8.Color = Color3.fromRGB(248, 248, 248);
        v8.Transparency = 0.9;
        v8:SetAttribute("MutationFXDontRender", true);
        v8.Parent = p1;

        return v8;
    end,

    createServerBoundary = function(p9) -- Line: 45, Name: createServerBoundary
        -- upvalues: Constants (copy)
        local ServerBoundary = p9:FindFirstChild("ServerBoundary");

        if ServerBoundary then
            return ServerBoundary;
        end;

        local _, v10 = p9:GetBoundingBox();
        local MIN_PLACE_GRID_SIZE = Constants.MIN_PLACE_GRID_SIZE;
        local v11 = v10.Z * 1.3;
        local v12 = math.round(v10.X * 1.3 / MIN_PLACE_GRID_SIZE);
        local v13 = math.clamp(v12, 1, 2);
        local v14 = math.round(v11 / MIN_PLACE_GRID_SIZE);
        local v15 = math.clamp(v14, 1, 2);
        local Part = Instance.new("Part");
        Part.Name = "ServerBoundary";
        Part.Size = Vector3.new(0.15, v13 * MIN_PLACE_GRID_SIZE * Constants.SERVER_REDUCTION_FACTOR, v15 * MIN_PLACE_GRID_SIZE * Constants.SERVER_REDUCTION_FACTOR);
        Part.CFrame = p9:GetPivot() * CFrame.fromEulerAnglesXYZ(0, 0, 1.5707963267948966);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Transparency = 1;
        Part:SetAttribute("MutationFXDontRender", true);
        Part.Parent = p9;

        return Part;
    end
};