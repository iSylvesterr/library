-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = Random.new();
local u3 = RaycastParams.new();
u3.FilterType = Enum.RaycastFilterType.Exclude;
local u4 = {};

local function createCraterPart() -- Line: 75
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = true;
    Part.Material = Enum.Material.Slate;
    Part.Size = Vector3.new(1.6, 2.2, 2);
    Part.TopSurface = Enum.SurfaceType.Smooth;
    Part.BottomSurface = Enum.SurfaceType.Smooth;

    return Part;
end;

local function resolveGround(p5, p6, p7) -- Line: 89
    -- upvalues: u3 (copy), Workspace (copy)
    u3.FilterDescendantsInstances = p6 or {};
    local v8 = Color3.fromRGB(108, 59, 19);
    local Slate = Enum.Material.Slate;
    local v9 = Workspace:Raycast(p5 + Vector3.new(0, 5, 0), Vector3.new(0, -100, 0), u3);

    if v9 ~= nil then
        local v10, v11 = v9.Instance.Color:ToHSV();
        v8 = Color3.fromHSV(v10, v11, 0.8);
        p5 = v9.Position;
        Slate = v9.Instance.Material;
    end;

    return p5, p7 or v8, Slate;
end;

local function fadePart(u12, u13, p14) -- Line: 114
    -- upvalues: u2 (copy), TweenService (copy), Debris (copy)
    task.delay(p14 * u2:NextNumber(0.75, 1.25), function() -- Line: 115
        -- upvalues: TweenService (ref), u12 (copy), u13 (copy), Debris (ref)
        TweenService:Create(u12, TweenInfo.new(0.3333333333333333), {
            Transparency = 1,
            CFrame = u13
        }):Play();
        Debris:AddItem(u12, 0.4);
    end);
end;

function u4.Play(p15, p16, p17, u18, p19, p20, p21) -- Line: 128
    -- upvalues: Asserts (copy), resolveGround (copy), u2 (copy), Workspace (copy), TweenService (copy), Debris (copy)
    Asserts.Vector3(p15);
    Asserts.number(p16);
    Asserts.optional.boolean(p17);
    Asserts.optional.number(u18);
    Asserts.optional.number(p19);
    Asserts.optional.table(p20);
    local v22, v23 = resolveGround(p15, p20, p21);

    for i = 1, 10 do
        local v24 = u2:NextNumber(-2, 2);
        local v25 = u2:NextNumber(0, 0.75);
        local v26 = Vector3.new(v24, v25, u2:NextNumber(0, 1));
        local v27 = i / 10 * 6.283185307179586;
        local v28 = math.cos(v27) * p16;
        local v29 = math.sin(v27) * p16;
        local v30 = Vector3.new(v28, 0, v29);
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = true;
        Part.Material = Enum.Material.Slate;
        Part.Size = Vector3.new(1.6, 2.2, 2);
        Part.TopSurface = Enum.SurfaceType.Smooth;
        Part.BottomSurface = Enum.SurfaceType.Smooth;
        local v31 = (Part.Size + v26) * (p19 or 1);
        Part.Size = v31;
        Part.Color = v23;
        local v32 = CFrame.new(v22 + v30, v22);
        local Angles = CFrame.Angles;
        local v33 = u2:NextInteger(-25, 25);
        local v34 = v32 * Angles(-0.3490658503988659, math.rad(v33), 0);
        local u35 = v34 * CFrame.new(0, -v31.Y, 0);
        Part.CFrame = u35;
        Part.Parent = Workspace:WaitForChild("__DEBRIS");

        if p17 then
            Part.CFrame = v34 * CFrame.new(0, v31.Y / 2, 0);
            Part.CanCollide = true;
            Part.Anchored = false;
            local v36 = math.cos(v27) * 8;
            local v37 = math.sin(v27) * 8;
            Part.AssemblyLinearVelocity = Vector3.new(v36, 35, v37);
            task.delay(u18 or 1.5, function() -- Line: 169
                -- upvalues: Part (copy), TweenService (ref), u35 (copy)
                Part.Anchored = true;
                local v38 = TweenService:Create(Part, TweenInfo.new(0.3333333333333333), {
                    Transparency = 1,
                    CFrame = CFrame.new(Part.Position.X, u35.Y, Part.Position.Z) * Part.CFrame.Rotation
                });
                v38.Completed:Once(function() -- Line: 175
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
                v38:Play();
            end);
        else
            local v39 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                CFrame = v34
            });
            v39.Completed:Once(function() -- Line: 188
                -- upvalues: Part (copy), u35 (copy), u18 (copy), u2 (ref), TweenService (ref), Debris (ref)
                local u40 = Part;
                local u41 = u35;
                task.delay((u18 or 1) * u2:NextNumber(0.75, 1.25), function() -- Line: 115
                    -- upvalues: TweenService (ref), u40 (copy), u41 (copy), Debris (ref)
                    TweenService:Create(u40, TweenInfo.new(0.3333333333333333), {
                        Transparency = 1,
                        CFrame = u41
                    }):Play();
                    Debris:AddItem(u40, 0.4);
                end);
            end);
            v39:Play();
        end;
    end;
end;

function u4.PlayDirectionalFling(p42, p43, p44) -- Line: 196
    -- upvalues: Asserts (copy), Constants (copy), u1 (copy), resolveGround (copy), Workspace (copy), u2 (copy), TweenService (copy)
    Asserts.Vector3(p42);
    Asserts.Vector3(p43);
    Asserts.optional.table(p44);
    local v45 = Vector3.new(p43.X, 0, p43.Z);

    if v45.Magnitude <= 0.001 then
        local v46 = `Crater PlayDirectionalFling requires a non vertical direction. Received direction: {p43}`;

        if Constants.IS_STUDIO then
            error(v46);

            return;
        end;

        u1:AtWarning():Log(v46);

        return;
    end;

    local v47;

    if p44 == nil then
        v47 = nil;
    else
        v47 = p44.ColorOverride;
    end;

    local v48 = (p44 == nil or p44.FadeDelay == nil) and 0.7 or p44.FadeDelay;
    local v49 = (p44 == nil or p44.GroundOffset == nil) and 0 or p44.GroundOffset;
    local v50;

    if p44 == nil then
        v50 = nil;
    else
        v50 = p44.IgnoredInstances;
    end;

    local v51 = (p44 == nil or p44.LateralSpread == nil) and 1.75 or p44.LateralSpread;
    local v52 = (p44 == nil or p44.PartCount == nil) and 5 or p44.PartCount;
    local v53 = (p44 == nil or p44.Scale == nil) and 0.65 or p44.Scale;
    local v54 = (p44 == nil or p44.SpawnOffset == nil) and 1.4 or p44.SpawnOffset;
    local v55 = (p44 == nil or p44.ThrowVelocity == nil) and 18 or p44.ThrowVelocity;
    local v56 = (p44 == nil or p44.ThrowUpVelocity == nil) and 24 or p44.ThrowUpVelocity;
    local Unit = v45.Unit;
    local v57 = -Unit;
    local v58 = Vector3.new(-Unit.Z, 0, Unit.X);
    local u59, v60, v61 = resolveGround(p42 + v57 * v54 + Vector3.new(0, v49, 0), v50, v47);
    local __DEBRIS = Workspace:WaitForChild("__DEBRIS");

    for i = 1, v52 do
        local v62 = v57 * u2:NextNumber(0, 0.65);
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = true;
        Part.Material = Enum.Material.Slate;
        Part.Size = Vector3.new(1.6, 2.2, 2);
        Part.TopSurface = Enum.SurfaceType.Smooth;
        Part.BottomSurface = Enum.SurfaceType.Smooth;
        local v63 = u2:NextNumber(1.05, 1.85);
        local v64 = u2:NextNumber(0.7, 1.3);
        local u65 = Vector3.new(v63, v64, u2:NextNumber(0.9, 1.5)) * v53;
        Part.Size = u65;
        Part.Color = v60;
        Part.Material = v61;
        Part.CanCollide = true;
        Part.Anchored = false;
        local v66 = u59 + v58 * ((v52 == 1 and 0 or (i - 1) / (v52 - 1) - 0.5) * v51 * 2) + v62;
        local v67 = CFrame.lookAt(v66, v66 + v57, Vector3.new(0, 1, 0));
        local Angles = CFrame.Angles;
        local v68 = u2:NextNumber(-0.45, -0.15);
        local v69 = u2:NextInteger(-35, 35);
        local v70 = math.rad(v69);
        local v71 = u2:NextInteger(-35, 35);
        Part.CFrame = v67 * Angles(v68, v70, (math.rad(v71)));
        Part.Parent = __DEBRIS;
        local v72 = u2:NextNumber(-10, 10);
        local v73 = u2:NextNumber(-8, 8);
        Part.AssemblyAngularVelocity = Vector3.new(v72, v73, u2:NextNumber(-10, 10));
        local v74 = v57 * u2:NextNumber(v55 * 0.85, v55 * 1.15);
        local v75 = u2:NextNumber(v56 * 0.85, v56 * 1.15);
        Part.AssemblyLinearVelocity = v74 + Vector3.new(0, v75, 0) + v58 * u2:NextNumber(-1.25, 1.25);
        task.delay(v48 * u2:NextNumber(0.9, 1.15), function() -- Line: 273
            -- upvalues: Part (copy), TweenService (ref), u59 (copy), u65 (copy)
            if Part.Parent == nil then
                return;
            end;

            Part.Anchored = true;
            local v76 = TweenService:Create(Part, TweenInfo.new(0.3333333333333333), {
                Transparency = 1,
                CFrame = CFrame.new(Part.Position.X, u59.Y - u65.Y, Part.Position.Z) * Part.CFrame.Rotation
            });
            v76.Completed:Once(function() -- Line: 284
                -- upvalues: Part (ref)
                Part:Destroy();
            end);
            v76:Play();
        end);
    end;
end;

function u4.PlayLine(p77, p78, p79) -- Line: 292
    -- upvalues: Asserts (copy), Constants (copy), u1 (copy), resolveGround (copy), u4 (copy), u2 (copy), Workspace (copy), TweenService (copy), Debris (copy)
    Asserts.Vector3(p77);
    Asserts.Vector3(p78);
    local v80 = Vector3.new(p78.X, 0, p78.Z);

    if v80.Magnitude <= 0.001 then
        local v81 = `Crater PlayLine requires a non vertical direction. Received direction: {p78}`;

        if Constants.IS_STUDIO then
            error(v81);

            return;
        end;

        u1:AtWarning():Log(v81);

        return;
    end;

    local v82 = (p79 == nil or p79.Gap == nil) and 3.25 or p79.Gap;
    local v83 = (p79 == nil or p79.HalfWidth == nil) and 3 or p79.HalfWidth;
    local v84 = (p79 == nil or p79.Scale == nil) and 0.75 or p79.Scale;
    local v85 = (p79 == nil or p79.Spacing == nil) and 3 or p79.Spacing;
    local u86 = (p79 == nil or p79.FadeDelay == nil) and 0.65 or p79.FadeDelay;
    local v87;

    if p79 == nil then
        v87 = nil;
    else
        v87 = p79.FlingOptions;
    end;

    local v88;

    if p79 == nil then
        v88 = nil;
    else
        v88 = p79.IgnoredInstances;
    end;

    local v89;

    if p79 == nil then
        v89 = nil;
    else
        v89 = p79.ColorOverride;
    end;

    local Unit = v80.Unit;
    local v90 = Vector3.new(-Unit.Z, 0, Unit.X);
    local v91, v92 = resolveGround(p77, v88, v89);

    if v87 ~= nil then
        local v93 = table.clone(v87);
        local v94;

        if v93.ColorOverride == nil then
            v94 = v92;
        else
            v94 = v93.ColorOverride;
        end;

        v93.ColorOverride = v94;

        if v93.IgnoredInstances ~= nil then
            v88 = v93.IgnoredInstances;
        end;

        v93.IgnoredInstances = v88;
        u4.PlayDirectionalFling(v91, Unit, v93);
    end;

    for _, v in ipairs({ -1, 1 }) do
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = true;
        Part.Material = Enum.Material.Slate;
        Part.Size = Vector3.new(1.6, 2.2, 2);
        Part.TopSurface = Enum.SurfaceType.Smooth;
        Part.BottomSurface = Enum.SurfaceType.Smooth;
        local v95 = u2:NextNumber(-0.25, 0.55);
        local v96 = u2:NextNumber(-0.25, 0.35);
        local v97 = Vector3.new(v95, v96, u2:NextNumber(-0.3, 0.5));
        local v98 = (Vector3.new(v85 * 0.9, 1.7, v83) + v97) * v84;
        Part.Size = v98;
        Part.Color = v92;
        local v99 = v91 + v90 * v * (v82 * 0.5 + v83 * 0.5);
        local v100 = CFrame.lookAt(v99, v99 + Unit, Vector3.new(0, 1, 0)) * CFrame.Angles(-0.3490658503988659, 0, (math.rad(12 * -v)));
        local u101 = v100 * CFrame.new(0, -v98.Y, 0);
        Part.CFrame = u101;
        Part.Parent = Workspace:WaitForChild("__DEBRIS");
        local v102 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            CFrame = v100
        });
        v102.Completed:Once(function() -- Line: 360
            -- upvalues: Part (copy), u101 (copy), u86 (copy), u2 (ref), TweenService (ref), Debris (ref)
            local u103 = Part;
            local u104 = u101;
            task.delay(u86 * u2:NextNumber(0.75, 1.25), function() -- Line: 115
                -- upvalues: TweenService (ref), u103 (copy), u104 (copy), Debris (ref)
                TweenService:Create(u103, TweenInfo.new(0.3333333333333333), {
                    Transparency = 1,
                    CFrame = u104
                }):Play();
                Debris:AddItem(u103, 0.4);
            end);
        end);
        v102:Play();
    end;
end;

return setmetatable(u4, {
    __call = function(p105, ...) -- Line: 368, Name: __call
        -- upvalues: u4 (copy)
        return u4.Play(...);
    end
});