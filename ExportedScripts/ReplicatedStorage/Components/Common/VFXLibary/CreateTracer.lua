-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local Tracers = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tracers");
local Debris2 = workspace:WaitForChild("Debris");

local function constructAsset(p1) -- Line: 26
    -- upvalues: Tracers (copy)
    local v2 = Tracers:FindFirstChild(p1);
    local v3 = `{p1} is not apart of Assets.Miscellaneous`;
    assert(v2, v3);
    debug.profilebegin("VFX.Tracer.CloneAsset");
    local v4 = v2:Clone();
    v4.CollisionGroup = "Debris";
    v4.CanCollide = false;
    v4.CanQuery = false;
    v4.CanTouch = false;
    v4.Anchored = true;
    debug.profileend();

    return v4;
end;

return function(p5, p6, p7) -- Line: 47
    -- upvalues: Tracers (copy), Debris2 (copy), TweenService (copy), Debris (copy)
    debug.profilebegin("VFX.Tracer");

    if not p6 then
        debug.profileend();

        return;
    end;

    local Default = Tracers:FindFirstChild("Default");
    assert(Default, "Default is not apart of Assets.Miscellaneous");
    debug.profilebegin("VFX.Tracer.CloneAsset");
    local v8 = Default:Clone();
    v8.CollisionGroup = "Debris";
    v8.CanCollide = false;
    v8.CanQuery = false;
    v8.CanTouch = false;
    v8.Anchored = true;
    debug.profileend();
    debug.profilebegin("VFX.Tracer.Parent");
    v8.CFrame = CFrame.new(p6 + p7 * 5);
    v8.Parent = Debris2;
    debug.profileend();
    debug.profilebegin("VFX.Tracer.CreateTweens");
    local u9 = TweenService:Create(v8, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(p6 + p7 * 1000)
    });
    task.defer(function() -- Line: 72
        -- upvalues: u9 (copy)
        u9:Play();
    end);
    local v10 = TweenInfo.new(0.05, Enum.EasingStyle.Linear);
    v8.BottomAttachment.Position = Vector3.new(0, 0, 0);
    v8.RightAttachment.Position = Vector3.new(0, 0, 0);
    v8.LeftAttachment.Position = Vector3.new(0, 0, 0);
    v8.TopAttachment.Position = Vector3.new(0, 0, 0);
    TweenService:Create(v8.TopAttachment, v10, {
        Position = Vector3.new(0, 0.1, 0)
    }):Play();
    TweenService:Create(v8.BottomAttachment, v10, {
        Position = Vector3.new(0, -0.1, 0)
    }):Play();
    TweenService:Create(v8.LeftAttachment, v10, {
        Position = Vector3.new(-0.1, 0, 0)
    }):Play();
    TweenService:Create(v8.RightAttachment, v10, {
        Position = Vector3.new(0.1, 0, 0)
    }):Play();
    debug.profileend();
    Debris:AddItem(v8, 2);
    debug.profileend();
end;