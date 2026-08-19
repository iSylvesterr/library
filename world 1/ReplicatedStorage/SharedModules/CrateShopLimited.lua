-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CrateShopFlags = require(ReplicatedStorage.SharedModules.Flags.CrateShopFlags);
local u1 = {
    ["Fourth Of July Crate"] = {
        Position = UDim2.new(0.623, 0, 0.745, 0),
        Size = UDim2.new(0.171, 0, 0.402, 0)
    }
};

local function GetOverrideFolder() -- Line: 37
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:FindFirstChild("CrateShopLimitedOverrides");
end;

local function GetEndTime(p2) -- Line: 41
    -- upvalues: ReplicatedStorage (copy), CrateShopFlags (copy)
    local CrateShopLimitedOverrides = ReplicatedStorage:FindFirstChild("CrateShopLimitedOverrides");

    if CrateShopLimitedOverrides then
        local v3 = CrateShopLimitedOverrides:FindFirstChild(p2);

        if v3 and (v3:IsA("NumberValue") and v3.Value > 0) then
            return v3.Value;
        end;
    end;

    local v4 = CrateShopFlags.LimitedEndTimes:Get()[p2];

    if type(v4) == "number" and v4 > 0 then
        return v4;
    end;

    return nil;
end;

return table.freeze({
    GetEndTime = GetEndTime,

    IsExpired = function(p5) -- Line: 57, Name: IsExpired
        -- upvalues: GetEndTime (copy)
        local v6 = GetEndTime(p5);

        if v6 then
            return v6 <= workspace:GetServerTimeNow();
        end;

        return false;
    end,

    SetOverride = function(p7, p8) -- Line: 67, Name: SetOverride
        -- upvalues: ReplicatedStorage (copy)
        local CrateShopLimitedOverrides = ReplicatedStorage:FindFirstChild("CrateShopLimitedOverrides");

        if not CrateShopLimitedOverrides then
            CrateShopLimitedOverrides = Instance.new("Folder");
            CrateShopLimitedOverrides.Name = "CrateShopLimitedOverrides";
            CrateShopLimitedOverrides.Parent = ReplicatedStorage;
        end;

        local v9 = CrateShopLimitedOverrides:FindFirstChild(p7);

        if v9 and v9:IsA("NumberValue") then
            v9.Value = p8;

            return;
        end;

        if v9 then
            v9:Destroy();
        end;

        local NumberValue = Instance.new("NumberValue");
        NumberValue.Name = p7;
        NumberValue.Value = p8;
        NumberValue.Parent = CrateShopLimitedOverrides;
    end,

    GetFramePosition = function(p10) -- Line: 27, Name: GetFramePosition
        -- upvalues: u1 (copy)
        local v11 = u1[p10];

        if v11 then
            v11 = v11.Position;
        end;

        return v11;
    end,

    GetFrameSize = function(p12) -- Line: 32, Name: GetFrameSize
        -- upvalues: u1 (copy)
        local v13 = u1[p12];

        if v13 then
            v13 = v13.Size;
        end;

        return v13;
    end
});