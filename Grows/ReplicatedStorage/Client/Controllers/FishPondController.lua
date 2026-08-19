-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local v1 = require(ReplicatedStorage.Packages.Knit).CreateController({
    Name = "FishPondController"
});
local u2 = Random.new();
local u3 = {};

local function yawOf(p4) -- Line: 29
    return math.atan2(-p4.X, -p4.Z);
end;

local function randomTarget(p5) -- Line: 34
    -- upvalues: u2 (copy)
    local v6 = p5.Size.X / 2 - 1.6;
    local v7 = p5.Size.Z / 2 - 1.6;

    if v6 <= 0 or v7 <= 0 then
        return nil;
    end;

    return (p5.CFrame * CFrame.new(u2:NextNumber(-v6, v6), 0, u2:NextNumber(-v7, v7))).Position;
end;

local function registerPond(u8) -- Line: 41
    -- upvalues: u3 (copy), u2 (copy)
    if u3[u8] then
        return;
    end;

    u3[u8] = true;
    task.spawn(function() -- Line: 45
        -- upvalues: u8 (copy), u3 (ref), u2 (ref)
        local v9 = os.clock() + 10;
        local v10;

        while true do
            v10 = u8:FindFirstChild("Water", true);

            if v10 and u8:FindFirstChild("Fish") then
                break;
            end;

            task.wait(0.2);

            if v9 < os.clock() or u8.Parent == nil then
                break;
            end;
        end;

        if not v10 or (not v10:IsA("BasePart") or u8.Parent == nil) then
            u3[u8] = nil;

            return;
        end;

        task.wait(0.2);
        local v11 = {};

        for _, child in u8:GetChildren() do
            if child.Name == "Fish" and (child:IsA("Model") and child.PrimaryPart) then
                for _, descendant in child:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false;
                        descendant.CanTouch = false;
                    end;
                end;

                local v12 = child:GetPivot();
                local v13 = {
                    target = nil,
                    model = child,
                    pos = v12.Position
                };
                local LookVector = v12.LookVector;
                v13.yaw = math.atan2(-LookVector.X, -LookVector.Z) + 3.141592653589793;
                v13.waitUntil = os.clock() + u2:NextNumber(0, 5);
                table.insert(v11, v13);
            end;
        end;

        if #v11 == 0 then
            u3[u8] = nil;

            return;
        end;

        u3[u8] = {
            water = v10,
            fish = v11
        };
    end);
    u8.AncestryChanged:Connect(function(p14, p15) -- Line: 88
        -- upvalues: u3 (ref), u8 (copy)
        if p15 == nil then
            u3[u8] = nil;
        end;
    end);
end;

local function tryRegister(p16) -- Line: 93
    -- upvalues: registerPond (copy)
    if p16:IsA("Model") and p16:GetAttribute("FurnitureId") == "Fish Pond" then
        registerPond(p16);
    end;
end;

local function stepFish(p17, p18, p19, p20) -- Line: 99
    -- upvalues: randomTarget (copy), u2 (copy)
    if p17.waitUntil and p19 < p17.waitUntil then
        return;
    end;

    p17.waitUntil = nil;

    if not p17.target then
        local v21 = randomTarget(p18);

        if not v21 then
            return;
        end;

        p17.target = Vector3.new(v21.X, p17.pos.Y, v21.Z);
    end;

    local v22 = p17.target - p17.pos;
    local v23 = Vector3.new(v22.X, 0, v22.Z);
    local Magnitude = v23.Magnitude;
    local v24 = p20 * 1.25;

    if Magnitude > 0.01 then
        local Unit = v23.Unit;
        local v25 = (math.atan2(-Unit.X, -Unit.Z) - p17.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
        local v26 = math.clamp(v25, p20 * -3, p20 * 3);
        p17.yaw = p17.yaw + v26;
        v24 = math.abs(v25) > 0.6 and 0 or v24;
    end;

    if Magnitude <= v24 then
        p17.pos = p17.target;
        p17.target = nil;
        p17.waitUntil = p19 + u2:NextNumber(2, 5);
    elseif v24 > 0 then
        p17.pos = p17.pos + v23.Unit * v24;
    end;

    p17.model:PivotTo(CFrame.new(p17.pos) * CFrame.Angles(0, p17.yaw + 3.141592653589793, 0));
end;

function v1.KnitStart(p27) -- Line: 134
    -- upvalues: registerPond (copy), RunService (copy), u3 (copy), stepFish (copy)
    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("Model") and descendant:GetAttribute("FurnitureId") == "Fish Pond" then
            registerPond(descendant);
        end;
    end;

    workspace.DescendantAdded:Connect(function(p28) -- Line: 138
        -- upvalues: registerPond (ref)
        if p28:IsA("Model") and (p28.Name:sub(1, 10) == "PlotDecor_" and (p28:IsA("Model") and p28:GetAttribute("FurnitureId") == "Fish Pond")) then
            registerPond(p28);
        end;
    end);
    RunService.Heartbeat:Connect(function(p29) -- Line: 145
        -- upvalues: u3 (ref), stepFish (ref)
        local v30 = os.clock();

        for i, v in u3 do
            if v ~= true then
                if i.Parent then
                    for _, v2 in v.fish do
                        stepFish(v2, v.water, v30, p29);
                    end;
                else
                    u3[i] = nil;
                end;
            end;
        end;
    end);
end;

return v1;