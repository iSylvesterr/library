-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = workspace:WaitForChild("Debris");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local WedgePart = Instance.new("WedgePart", script);
WedgePart.BottomSurface = Enum.SurfaceType.Smooth;
WedgePart.TopSurface = Enum.SurfaceType.Smooth;
WedgePart.Anchored = true;

local function draw3dTriangle(p1, p2, p3, p4) -- Line: 30
    -- upvalues: WedgePart (copy)
    debug.profilebegin("VFX.BreakGlass.DrawTriangle");
    local v5 = p2 - p1;
    local v6 = p3 - p1;
    local v7 = p3 - p2;
    local v8 = v5:Dot(v5);
    local v9 = v6:Dot(v6);
    local v10 = v7:Dot(v7);

    if v9 < v8 and v10 < v8 then
        local v11 = p3;
        p3 = p1;
        p1 = p2;
        p2 = v11;
    elseif v10 < v9 then
        if v8 >= v9 then
            local v12 = p2;
            p2 = p1;
            p1 = v12;
        end;
    else
        local v13 = p2;
        p2 = p1;
        p1 = v13;
    end;

    local v14 = p1 - p2;
    local v15 = p3 - p2;
    local v16 = p3 - p1;
    local Unit = v15:Cross(v14).Unit;
    local Unit2 = v16:Cross(Unit).Unit;
    local Unit3 = v16.Unit;
    local v17 = v14:Dot(Unit2);
    local v18 = math.abs(v17);
    local v19 = WedgePart:Clone();
    local v20 = v14:Dot(Unit3);
    local v21 = math.abs(v20);
    v19.Size = Vector3.new(0, v18, v21);
    v19.CFrame = CFrame.fromMatrix((p2 + p1) / 2, Unit, Unit2, Unit3);
    v19.Parent = p4;
    local v22 = WedgePart:Clone();
    local v23 = v15:Dot(Unit3);
    local v24 = math.abs(v23);
    v22.Size = Vector3.new(0, v18, v24);
    v22.CFrame = CFrame.fromMatrix((p2 + p3) / 2, -Unit, Unit2, -Unit3);
    v22.Parent = p4;
    debug.profileend();

    return v19, v22;
end;

return function(p25, p26, p27) -- Line: 78
    -- upvalues: DataController (copy), LocalPlayer (copy), Janitor (copy), Sound (copy), draw3dTriangle (copy), Debris (copy), TweenService (copy)
    debug.profilebegin("VFX.BreakGlass");

    if not p25 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.BreakGlass.GetSetting");
    local v28 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Glass Shatter") ~= false;
    debug.profileend();
    local u29 = Janitor.new();

    if not v28 then
        debug.profilebegin("VFX.BreakGlass.NoShatter.Sound");
        Sound.new("Bullet"):PlaySoundAtPosition({
            Class = "Bullet",
            Name = "Glass Shattered",
            Position = p26
        });
        debug.profileend();
        debug.profilebegin("VFX.BreakGlass.NoShatter.CleanupSource");
        p25.CollisionGroup = "Debris";
        p25.Transparency = 1;
        p25.CanCollide = false;
        p25.CastShadow = false;
        p25.CanQuery = false;
        p25.CanTouch = false;
        p25.Anchored = true;
        u29:Add(p25);
        local Parent = p25.Parent;

        if Parent and (Parent:IsA("Model") and Parent:HasTag("BreakableGlass")) then
            u29:Add(Parent);

            for _, descendant in ipairs(Parent:GetDescendants()) do
                if descendant:IsA("Decal") then
                    descendant:Destroy();
                end;
            end;
        end;

        debug.profileend();
        task.delay(0.1, function() -- Line: 133
            -- upvalues: u29 (copy)
            debug.profilebegin("VFX.BreakGlass.NoShatter.DelayedCleanup");
            u29:Destroy();
            debug.profileend();
        end);
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.BreakGlass.BuildCornerPoints");
    local v30 = {};

    if p25.Size.Z > p25.Size.X then
        local v31 = p25.CFrame * CFrame.new(0, p25.Size.Y * 0.5, p25.Size.Z * 0.5);
        table.insert(v30, v31);
        local v32 = p25.CFrame * CFrame.new(0, p25.Size.Y * 0.5, 0);
        table.insert(v30, v32);
        local v33 = p25.CFrame * CFrame.new(0, p25.Size.Y * 0.5, -p25.Size.Z * 0.5);
        table.insert(v30, v33);
        local v34 = p25.CFrame * CFrame.new(0, 0, -p25.Size.Z * 0.5);
        table.insert(v30, v34);
        local v35 = p25.CFrame * CFrame.new(0, -p25.Size.Y * 0.5, -p25.Size.Z * 0.5);
        table.insert(v30, v35);
        local v36 = p25.CFrame * CFrame.new(0, -p25.Size.Y * 0.5, 0);
        table.insert(v30, v36);
        local v37 = p25.CFrame * CFrame.new(0, -p25.Size.Y * 0.5, p25.Size.Z * 0.5);
        table.insert(v30, v37);
        local v38 = p25.CFrame * CFrame.new(0, 0, p25.Size.Z * 0.5);
        table.insert(v30, v38);
    else
        local v39 = p25.CFrame * CFrame.new(p25.Size.X * 0.5, p25.Size.Y * 0.5, 0);
        table.insert(v30, v39);
        local v40 = p25.CFrame * CFrame.new(0, p25.Size.Y * 0.5, 0);
        table.insert(v30, v40);
        local v41 = p25.CFrame * CFrame.new(-p25.Size.X * 0.5, p25.Size.Y * 0.5, 0);
        table.insert(v30, v41);
        local v42 = p25.CFrame * CFrame.new(-p25.Size.X * 0.5, 0, 0);
        table.insert(v30, v42);
        local v43 = p25.CFrame * CFrame.new(-p25.Size.X * 0.5, -p25.Size.Y * 0.5, 0);
        table.insert(v30, v43);
        local v44 = p25.CFrame * CFrame.new(0, -p25.Size.Y * 0.5, 0);
        table.insert(v30, v44);
        local v45 = p25.CFrame * CFrame.new(p25.Size.X * 0.5, -p25.Size.Y * 0.5, 0);
        table.insert(v30, v45);
        local v46 = p25.CFrame * CFrame.new(p25.Size.X * 0.5, 0, 0);
        table.insert(v30, v46);
    end;

    debug.profileend();
    debug.profilebegin("VFX.BreakGlass.CreateFragments");

    for i, v in ipairs(v30) do
        local u47, u48 = draw3dTriangle(v.Position, (v30[i + 1] or v30[1]).Position, p26, Debris);

        for _, v2 in ipairs({ u47, u48 }) do
            v2.Transparency = math.min(p25.Transparency, 0.6);
            v2.AssemblyLinearVelocity = p27 * 15;
            v2.CollisionGroup = "Debris";
            v2.Color = p25.Color;
            v2.Anchored = false;
        end;

        u29:Add(u47);
        u29:Add(u48);
        task.delay(4.75, function() -- Line: 192
            -- upvalues: u29 (copy), TweenService (ref), u47 (copy), u48 (copy)
            debug.profilebegin("VFX.BreakGlass.FragmentFadeTween");
            u29:Add(TweenService:Create(u47, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                Transparency = 1
            })):Play();
            u29:Add(TweenService:Create(u48, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                Transparency = 1
            })):Play();
            debug.profileend();
        end);
    end;

    debug.profileend();
    debug.profilebegin("VFX.BreakGlass.CleanupSource");
    p25.CollisionGroup = "Debris";
    p25.Transparency = 1;
    p25.CanCollide = false;
    p25.CastShadow = false;
    p25.CanQuery = false;
    p25.CanTouch = false;
    p25.Anchored = true;
    Sound.new("Bullet"):playOneTime({
        Name = "Glass Shattered",
        Parent = p25
    });
    u29:Add(p25);
    local Parent = p25.Parent;

    if Parent and (Parent:IsA("Model") and Parent:HasTag("BreakableGlass")) then
        u29:Add(Parent);

        for _, descendant in ipairs(Parent:GetDescendants()) do
            if descendant:IsA("Decal") then
                descendant:Destroy();
            end;
        end;
    end;

    debug.profileend();
    task.delay(5, function() -- Line: 244
        -- upvalues: u29 (copy)
        debug.profilebegin("VFX.BreakGlass.DelayedCleanup");
        u29:Destroy();
        debug.profileend();
    end);
    debug.profileend();
end;