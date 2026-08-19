-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local CurrentCamera = workspace.CurrentCamera;

return function(u1) -- Line: 10
    -- upvalues: Asserts (copy), CurrentCamera (copy)
    Asserts.UIScale(u1);

    local function updateScale() -- Line: 13
        -- upvalues: CurrentCamera (ref), u1 (copy)
        local ViewportSize = CurrentCamera.ViewportSize;
        local v2 = (math.min(ViewportSize.X, ViewportSize.Y) - 320) / 960 * 0.6 + 0.4;
        u1.Scale = math.clamp(v2, 0.4, 1) * 1;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;
    local v3 = (math.min(ViewportSize.X, ViewportSize.Y) - 320) / 960 * 0.6 + 0.4;
    u1.Scale = math.clamp(v3, 0.4, 1) * 1;
    local u4 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale);

    return function() -- Line: 25
        -- upvalues: u4 (ref)
        if not u4 then
            return;
        end;

        u4:Disconnect();
        u4 = nil;
    end;
end;