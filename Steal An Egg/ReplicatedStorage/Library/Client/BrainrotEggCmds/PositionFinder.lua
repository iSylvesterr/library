-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Variables = require(ReplicatedStorage.Library.Shared.Variables);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Player = require(ReplicatedStorage.Library.Player);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local u1 = {
    ActiveEggs = {}
};

function u1.ComputePositions(p2, p3, p4) -- Line: 11
    -- upvalues: Variables (copy), Player (copy), Asserts (copy), u1 (copy), PlotCmds (copy)
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

    local v12 = {};
    local __OBJECTS = workspace:FindFirstChild("__OBJECTS");
    local v13 = __OBJECTS and __OBJECTS:FindFirstChild("Build");

    if v13 then
        table.insert(v12, v13);
    end;

    local v14 = PlotCmds.GetPlotsFolder();

    if v14 then
        table.insert(v12, v14);
    end;

    if #v12 == 0 then
        return nil;
    end;

    local u15 = RaycastParams.new();
    u15.FilterDescendantsInstances = v12;
    u15.FilterType = Enum.RaycastFilterType.Include;
    u15.IgnoreWater = false;
    u15.RespectCanCollide = false;

    local function canSee(p16, p17) -- Line: 80
        -- upvalues: ExclusiveEggSpacingRadius (copy), Position (copy), u10 (copy), u15 (copy)
        local CurrentCamera = workspace.CurrentCamera;
        local v18 = p16 + Vector3.new(0, ExclusiveEggSpacingRadius, 0);

        for _, v in ipairs({
            { CurrentCamera.Focus.Position, v18 },
            { Position, v18 },
            { u10 + Vector3.new(0, 0.25, 0), v18 },
            { CurrentCamera.Focus.Position, p16 },
            { Position, p16 },
            { u10 + Vector3.new(0, 0.25, 0), p16 }
        }) do
            local v19 = v[1];
            local v20 = workspace:Raycast(v19, v[2] - v19, u15);

            if v20 then
                assert(v20, "Raycast result is nil");

                if v20.Instance ~= p17 then
                    return false;
                end;
            end;
        end;

        return true;
    end;

    local function tryFind() -- Line: 106
        -- upvalues: u9 (copy), ExclusiveEggRadiusRange (copy), ExclusiveEggRadiusStep (copy), u6 (copy), ExclusiveEggSpacingRadius (copy), Position (copy), ExclusiveEggHeightOffset (copy), ExclusiveEggMaxHeight (copy), u15 (copy), u11 (copy), canSee (copy)
        local _, v21 = u9:ToOrientation();
        local v22 = v21 + 1.5707963267948966;
        local v23 = { -1, 1 };

        for i = ExclusiveEggRadiusRange.X, ExclusiveEggRadiusRange.Y, ExclusiveEggRadiusStep do
            for i2 = 0, 180, u6 do
                for _, v in ipairs(v23) do
                    local v24 = ExclusiveEggSpacingRadius + i;
                    local v25 = math.rad(i2 * v) - v22;
                    local v26 = v24 * math.cos(v25);
                    local v27 = v24 * math.sin(v25);
                    local v28 = Position + Vector3.new(v26, 0, v27) + Vector3.new(0, ExclusiveEggHeightOffset, 0);
                    local v29 = Vector3.new(0, -(ExclusiveEggMaxHeight + ExclusiveEggHeightOffset), 0);
                    local v30 = workspace:Raycast(v28, v29, u15) or nil;

                    if v30 then
                        assert(v30, "Ground result is nil");
                        local Position2 = v30.Position;
                        local v31 = false;

                        for _, v2 in ipairs(u11) do
                            if (Position2 - v2).Magnitude <= 2 * ExclusiveEggSpacingRadius then
                                v31 = true;
                                break;
                            end;
                        end;

                        if not v31 and canSee(Position2, v30.Instance) then
                            return Position2;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v32 = {};

    for _ = 1, v5 do
        local v33 = tryFind();

        if not v33 then
            return nil;
        end;

        assert(v33, "Found position is nil");
        table.insert(v32, v33);
        table.insert(u11, v33);
    end;

    return v32;
end;

return u1;