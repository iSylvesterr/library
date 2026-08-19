-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Spr = require(ReplicatedStorage.Library.Modules.Spr);
local u1 = Players.LocalPlayer.PlayerGui:WaitForChild("Click Effect");
local Tile = u1:WaitForChild("Tile");
Tile.Parent = nil;
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 13
    -- upvalues: u2 (copy)
    return setmetatable({
        Tiles = {}
    }, u2);
end;

function u2.Destroy(p3) -- Line: 17
    -- upvalues: Spr (copy)
    for _, v in ipairs(p3.Tiles) do
        local v4 = v:FindFirstChildWhichIsA("UIScale");

        if v4 then
            Spr.stop(v4);
        end;

        Spr.stop(v);
        v:Destroy();
    end;

    table.clear(p3.Tiles);
end;

function u2.Activate(u5, p6) -- Line: 29
    -- upvalues: Tile (copy), u1 (copy), Spr (copy)
    local u7 = Tile:Clone();
    u7.BackgroundTransparency = 0;
    u7.UIScale.Scale = 0;
    u7.Position = UDim2.fromOffset(p6.X, p6.Y);
    u7.Visible = true;
    u7.Parent = u1;
    Spr.target(u7.UIScale, 100, 600, {
        Scale = 0.75 + math.random() * 0.5
    });
    Spr.target(u7, 100, 600, {
        BackgroundTransparency = 1
    });
    table.insert(u5.Tiles, u7);
    task.delay(2, function() -- Line: 43
        -- upvalues: u5 (copy), u7 (ref), Spr (ref)
        local v8 = table.find(u5.Tiles, u7);

        if v8 then
            table.remove(u5.Tiles, v8);
        end;

        Spr.stop(u7.UIScale);
        Spr.stop(u7);
        u7:Destroy();
        u7 = nil;
    end);
end;

return u2;