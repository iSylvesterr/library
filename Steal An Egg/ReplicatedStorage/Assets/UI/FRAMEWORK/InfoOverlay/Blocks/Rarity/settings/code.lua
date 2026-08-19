-- Decompiled with Potassium's decompiler.

local Rarities = require(game.ReplicatedStorage.Directory.Rarity).Rarities;
local RunService = game:GetService("RunService");

function UpdateRarityUI(u1, p2, p3)
    -- upvalues: Rarities (copy), RunService (copy)
    local v4 = Rarities[p3];
    assert(v4);
    local DisplayName = v4.DisplayName;
    local v5 = p3 == "Exclusive";

    if v5 then
        DisplayName = DisplayName .. "  ★";
    end;

    u1.title.Text = DisplayName;
    local v6 = u1.title:FindFirstChildOfClass("UIGradient");
    local v7 = u1.title:FindFirstChildOfClass("UIStroke");
    local v8;

    if v7 then
        v8 = v7:FindFirstChildOfClass("UIGradient");
    else
        v8 = v7;
    end;

    if v6 then
        v6:Destroy();
    end;

    if v8 then
        v8:Destroy();
    end;

    local u9 = v4.Gradient:Clone();
    local u10 = v4.Gradient:Clone();
    u9.Parent = u1.title;
    u10.Parent = v7;

    if v5 then
        task.spawn(function() -- Line: 31
            -- upvalues: u1 (copy), u9 (copy), u10 (copy), RunService (ref)
            local v11 = tick();
            task.wait();

            while u1 and u1.Parent do
                local v12 = tick() - v11;
                u9.Rotation = 100 + v12 * 100;
                u10.Rotation = 100 - v12 * 100;
                RunService.RenderStepped:Wait();
            end;
        end);
    end;
end;

return UpdateRarityUI;