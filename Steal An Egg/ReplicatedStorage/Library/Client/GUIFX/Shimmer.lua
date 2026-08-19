-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Functions = require(Library.Functions);

return function(u1, p2, p3, u4) -- Line: 6
    -- upvalues: Assets (copy), Functions (copy)
    local u5 = p2 or 1.75;
    local u6 = p3 or 1;
    local u7 = u1:FindFirstAncestorOfClass("ScreenGui") or (u1:FindFirstAncestorOfClass("BillboardGui") or u1:FindFirstAncestorOfClass("SurfaceGui"));

    if not u7 then
        return function() -- Line: 13
        end;
    end;

    assert(u7);
    local u8 = Assets.UI.FRAMEWORK.GUIFX.Shimmer:Clone();
    local UIGradient = u8:FindFirstChild("UIGradient");
    u8.Parent = u1;

    local function playShimmer() -- Line: 19
        -- upvalues: UIGradient (copy), Functions (ref), u6 (copy)
        UIGradient.Offset = Vector2.new(-1, 0);
        Functions.Tween(UIGradient, {
            Offset = Vector2.new(1, 0)
        }, { u6, "Quad", "InOut" });
    end;

    local u9 = false;
    task.spawn(function() -- Line: 26
        -- upvalues: u4 (copy), playShimmer (copy), u9 (ref), u1 (copy), u7 (copy), u5 (copy)
        if u4 then
            playShimmer();

            return;
        end;

        while not u9 and (u1 and u1.Parent) do
            if u7.Enabled then
                playShimmer();
            end;

            task.wait(u5);
        end;
    end);

    return function() -- Line: 38
        -- upvalues: u8 (copy), u9 (ref)
        if u8 then
            u8:Destroy();
        end;

        u9 = true;
    end;
end;