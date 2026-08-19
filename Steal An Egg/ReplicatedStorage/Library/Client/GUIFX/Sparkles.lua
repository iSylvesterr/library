-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Variables = require(Library.Variables);
local Functions = require(Library.Functions);
local u1 = Random.new();

return function(u2, p3, u4, p5, p6) -- Line: 8
    -- upvalues: Variables (copy), Assets (copy), u1 (copy), Functions (copy)
    if Variables.PotatoMode then
        return function() -- Line: 10
        end;
    end;

    local u7 = p3 or 1;
    local u8 = p6 or 1;
    local u9 = u2:FindFirstAncestorOfClass("ScreenGui") or (u2:FindFirstAncestorOfClass("BillboardGui") or u2:FindFirstAncestorOfClass("SurfaceGui"));

    if not u9 then
        return function() -- Line: 18
        end;
    end;

    assert(u9);

    local function createSparkle() -- Line: 21
        -- upvalues: Assets (ref), u1 (ref), u2 (copy), u7 (copy), Functions (ref), u8 (copy)
        local u10 = Assets.UI.FRAMEWORK.GUIFX.Sparkle:Clone();
        u10.Position = UDim2.new(u1:NextNumber(), 0, u1:NextNumber(), 0);
        u10.Size = UDim2.new(0, 0, 0, 0);
        u10.ZIndex = 99;
        u10.Parent = u2;
        local v11 = u1:NextNumber(0.15 * u7, 0.2 * u7);
        Functions.Tween(u10, {
            Size = UDim2.new(v11, 0, v11, 0)
        }, { u1:NextNumber(0.75, 1) * 1 / u8, "Quad", "Out" }).Completed:Connect(function() -- Line: 31
            -- upvalues: Functions (ref), u10 (copy), u1 (ref), u8 (ref)
            Functions.Tween(u10, {
                Size = UDim2.new(0, 0, 0, 0)
            }, { u1:NextNumber(1.75, 2.5) * 1 / u8, "Sine", "InOut" }).Completed:Wait();
            u10:Destroy();
        end);
    end;

    local v12 = p5 or 0;
    local v13 = typeof(v12) == "number";
    assert(v13);
    local u14 = false;

    for _ = 1, 1 + v12 do
        task.spawn(function() -- Line: 43
            -- upvalues: u14 (ref), u2 (copy), u9 (copy), createSparkle (copy), u4 (copy), u1 (ref)
            while not u14 and (u2 and u2.Parent) do
                if u9.Enabled then
                    createSparkle();
                end;

                if u4 then
                    local _ = u4[1];
                end;

                if u4 then
                    local _ = u4[2];
                end;

                wait(u1:NextNumber(1, 2.5));
            end;
        end);
    end;

    return function() -- Line: 54
        -- upvalues: u14 (ref)
        u14 = true;
    end;
end;