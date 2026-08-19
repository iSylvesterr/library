-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 7
};
local Debris = game:GetService("Debris");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Temporary = workspace:WaitForChild("Temporary");
local Stud_Part = ReplicatedStorage.Assets:WaitForChild("Stud_Part");

local function randomInRange(p2, p3) -- Line: 29
    return p2 + math.random() * (p3 - p2);
end;

local function randomUnitVector() -- Line: 33
    local v4 = math.random() * 3.141592653589793 * 2;
    local v5 = 2 * math.random() - 1;
    local v6 = math.acos(v5);
    local v7 = math.sin(v6) * math.cos(v4);
    local v8 = math.sin(v6) * math.sin(v4);
    local v9 = math.cos(v6);

    return Vector3.new(v7, v8, v9);
end;

function v1.Smash(p10, p11) -- Line: 58
    -- upvalues: Stud_Part (copy), Temporary (copy), randomUnitVector (copy), TweenService (copy), Debris (copy)
    local Position = p11.Position;

    if not Position then
        return;
    end;

    local v12 = p11.Amount or 12;
    local v13 = p11.Spread or 3;
    local v14 = p11.Color or Color3.fromRGB(139, 90, 43);
    local Colors = p11.Colors;
    local u15 = p11.Lifetime or 1.2;
    local v16 = p11.Force or 1;

    for _ = 1, v12 do
        local v17;

        if Colors and #Colors > 0 then
            v17 = Colors[math.random(1, #Colors)];
        else
            v17 = v14;
        end;

        local v18 = -v13;
        local v19 = (v18 + math.random() * (v13 - v18)) * 0.5;
        local v20 = -v13;
        local v21 = (v20 + math.random() * (v13 - v20)) * 0.3;
        local v22 = -v13;
        local v23 = (v22 + math.random() * (v13 - v22)) * 0.5;
        local v24 = Position + Vector3.new(v19, v21, v23);
        local Size = p11.Size;
        local u25 = Stud_Part:Clone();
        u25.CollisionGroup = "Egg";
        u25.Size = Vector3.new(Size, Size, Size);
        u25.Name = "SmashBlock";
        u25.Color = v17;
        u25.CFrame = CFrame.new(v24) * CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2);
        u25.Anchored = false;
        u25.CanCollide = true;
        u25.CollisionGroup = "NoPlayers";
        u25.CanQuery = false;
        u25.CanTouch = false;
        u25.Parent = Temporary;
        local v26 = v24 - Position;
        local v27;

        if v26.Magnitude < 0.1 then
            v27 = randomUnitVector();
        else
            v27 = v26.Unit;
        end;

        local Unit = (v27 + randomUnitVector() * 0.4).Unit;
        local v28 = (15 + math.random() * 25) * v16;
        local v29 = (15 + math.random() * 15) * v16;
        u25.AssemblyLinearVelocity = Unit * v28 + Vector3.new(0, v29, 0);
        u25.AssemblyAngularVelocity = randomUnitVector() * 25;
        local Size2 = u25.Size;
        task.delay(0.4, function() -- Line: 126
            -- upvalues: u25 (copy), u15 (copy), TweenService (ref), Size2 (copy)
            if not (u25 and u25.Parent) then
                return;
            end;

            local v30 = u15 - 0.4;

            if v30 <= 0 then
                u25:Destroy();

                return;
            end;

            local v31 = TweenService:Create(u25, TweenInfo.new(v30, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1,
                Size = Size2 * 0.3
            });
            v31:Play();
            v31.Completed:Once(function() -- Line: 141
                -- upvalues: u25 (ref)
                if u25 and u25.Parent then
                    u25:Destroy();
                end;
            end);
        end);
        Debris:AddItem(u25, u15 + 1);
    end;
end;

function v1.Init(p32) -- Line: 157
end;

function v1.Start(p33) -- Line: 160
end;

return v1;