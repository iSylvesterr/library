-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Other = Assets:WaitForChild("Other");
local Debris = workspace:WaitForChild("Debris");
local u1 = {
    Bullet = require(script.Components.Bullet),
    Melee = require(script.Components.Melee)
};
local u2 = {};

local function constructAsset(p3, p4, p5, p6) -- Line: 49
    -- upvalues: Other (copy), u1 (copy), Debris (copy)
    local v7 = Other:FindFirstChild(p3);
    local v8 = `{p3} is not apart of Assets.Miscellaneous`;
    assert(v7, v8);
    local v9 = u1[p4];
    local v10 = `{p4} is not apart of library "MarkerInfo"`;
    assert(u1, v10);
    local v11 = v7:Clone();
    local v12 = v9.Properties.SizeRange();
    local v13 = v9.Properties.SizeRange();
    v11.Size = Vector3.new(v12, v13, 0.001);
    v11.CollisionGroup = "Debris";
    v11.CanCollide = false;
    v11.CanQuery = false;
    v11.CanTouch = false;
    v11.Anchored = true;
    v11.CFrame = CFrame.new(p5, p5 + p6) * CFrame.Angles(0, 0, v9.Properties.Rotation() * 3.141592653589793 / 180);
    v11.Parent = Debris;
    v11.Anchored = false;

    for _, descendant in ipairs(v11:GetDescendants()) do
        local v14 = math.random(1, #v9.Images);

        if descendant:IsA("Decal") then
            descendant.Transparency = v9.Properties.Transparency();
            descendant.Texture = v9.Images[v14];
            descendant.Color3 = v9.Properties.Color3;
        end;
    end;

    return v11;
end;

return function(u15, p16, p17, p18) -- Line: 85
    -- upvalues: u2 (copy), Janitor (copy), constructAsset (copy)
    if u15.ClassName == "Terrain" then
        return;
    end;

    local v19 = #u2 >= 20 and table.remove(u2, 1);

    if v19 then
        v19:Destroy();
    end;

    local u20 = Janitor.new();
    table.insert(u2, u20);
    local v21 = constructAsset("HitMarker", p16, p17, p18);
    u20:Add(v21);
    local WeldConstraint = Instance.new("WeldConstraint", v21);
    WeldConstraint.Part0 = v21;
    WeldConstraint.Part1 = u15;

    if u15 and u15:IsDescendantOf(workspace) then
        u20:Add(u15.Destroying:Once(function() -- Line: 113
            -- upvalues: u20 (copy)
            u20:Cleanup();
        end));
        u20:Add(u15:GetPropertyChangedSignal("Transparency"):Connect(function() -- Line: 117
            -- upvalues: u15 (copy), u20 (copy)
            if u15.Transparency == 1 then
                u20:Cleanup();
            end;
        end));
    end;

    u20:Add(task.delay(15, function() -- Line: 124
        -- upvalues: u20 (copy), u2 (ref)
        u20:Destroy();

        for i, v in u2 do
            if v == u20 then
                table.remove(u2, i);

                return;
            end;
        end;
    end));
end;