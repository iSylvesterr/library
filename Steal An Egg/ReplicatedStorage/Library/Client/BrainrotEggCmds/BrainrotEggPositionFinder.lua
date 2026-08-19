-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Variables = require(ReplicatedStorage.Library.Shared.Variables);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Player = require(ReplicatedStorage.Library.Player);
local u1 = {
    ActiveEggs = {}
};

function u1.ComputePositions(p2, p3, p4) -- Line: 10
    -- upvalues: Variables (copy), Player (copy), Asserts (copy), u1 (copy)
    local ExclusiveEggSpacingRadius = Variables.ExclusiveEggSpacingRadius;
    local ExclusiveEggRadiusRange = Variables.ExclusiveEggRadiusRange;
    local ExclusiveEggRadiusStep = Variables.ExclusiveEggRadiusStep;
    local ExclusiveEggMaxHeight = Variables.ExclusiveEggMaxHeight;
    local ExclusiveEggHeightOffset = Variables.ExclusiveEggHeightOffset;
    local v5 = p2 or 1;
    local u6 = 360 / (v5 * 6);
    local v7 = Player.Optional.PrimaryPart();

    if not v7 then
        return nil;
    end;

    local v8 = Player.Optional.Humanoid();

    if not v8 then
        return nil;
    end;

    Asserts.optional.Vector3(p4);
    local u9 = p4 and CFrame.new(p4) or v7.CFrame;
    local Position = u9.Position;
    local u10 = Position - u9.UpVector * Vector3.new(0, v8.HipHeight + v7.Size.Y / 2, 0);
    local u11 = {};

    for i in pairs(u1.ActiveEggs) do
        if not i.completed then
            table.insert(u11, i.position);
        end;
    end;

    if p3 then
        for _, v in ipairs(p3) do
            Asserts.Vector3(v);
            table.insert(u11, v);
        end;
    end;

    local v12 = { workspace:WaitForChild("Plots"), workspace:FindFirstChild("Map") };
    local u13 = RaycastParams.new();
    u13.FilterDescendantsInstances = v12;
    u13.FilterType = Enum.RaycastFilterType.Include;
    u13.IgnoreWater = false;
    u13.RespectCanCollide = false;

    local function canSee(p14, p15) -- Line: 63
        -- upvalues: ExclusiveEggSpacingRadius (copy), Position (copy), u10 (copy), u13 (copy)
        local CurrentCamera = workspace.CurrentCamera;
        local v16 = p14 + Vector3.new(0, ExclusiveEggSpacingRadius, 0);

        for _, v in ipairs({
            { CurrentCamera.Focus.Position, v16 },
            { Position, v16 },
            { u10 + Vector3.new(0, 0.25, 0), v16 },
            { CurrentCamera.Focus.Position, p14 },
            { Position, p14 },
            { u10 + Vector3.new(0, 0.25, 0), p14 }
        }) do
            local v17 = v[1];
            local v18 = workspace:Raycast(v17, v[2] - v17, u13);

            if v18 then
                assert(v18, "Raycast result is nil");

                if v18.Instance ~= p15 then
                    return false;
                end;
            end;
        end;

        return true;
    end;

    local function tryFind() -- Line: 89
        -- upvalues: u9 (copy), ExclusiveEggRadiusRange (copy), ExclusiveEggRadiusStep (copy), u6 (copy), ExclusiveEggSpacingRadius (copy), Position (copy), ExclusiveEggHeightOffset (copy), ExclusiveEggMaxHeight (copy), u13 (copy), u11 (copy), canSee (copy)
        local _, v19 = u9:ToOrientation();
        local v20 = v19 + 1.5707963267948966;
        local v21 = { -1, 1 };

        for i = ExclusiveEggRadiusRange.X, ExclusiveEggRadiusRange.Y, ExclusiveEggRadiusStep do
            for i2 = 0, 180, u6 do
                for _, v in ipairs(v21) do
                    local v22 = ExclusiveEggSpacingRadius + i;
                    local v23 = math.rad(i2 * v) - v20;
                    local v24 = v22 * math.cos(v23);
                    local v25 = v22 * math.sin(v23);
                    local v26 = Position + Vector3.new(v24, 0, v25) + Vector3.new(0, ExclusiveEggHeightOffset, 0);
                    local v27 = Vector3.new(0, -(ExclusiveEggMaxHeight + ExclusiveEggHeightOffset), 0);
                    local v28 = workspace:Raycast(v26, v27, u13) or nil;

                    if v28 then
                        assert(v28, "Ground result is nil");
                        local Position2 = v28.Position;
                        local v29 = false;

                        for _, v2 in ipairs(u11) do
                            if (Position2 - v2).Magnitude <= 2 * ExclusiveEggSpacingRadius then
                                v29 = true;
                                break;
                            end;
                        end;

                        if not v29 and canSee(Position2, v28.Instance) then
                            return Position2;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v30 = {};

    for _ = 1, v5 do
        local v31 = tryFind();

        if not v31 then
            return nil;
        end;

        assert(v31, "Found position is nil");
        table.insert(v30, v31);
        table.insert(u11, v31);
    end;

    return v30;
end;

return u1;