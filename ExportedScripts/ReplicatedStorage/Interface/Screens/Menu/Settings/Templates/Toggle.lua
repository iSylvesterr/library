-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
Color3.fromRGB(255, 255, 255);

return function(u1, p2, p3, p4, u5, p6, u7, u8) -- Line: 21
    -- upvalues: Janitor (copy)
    u5.Name = u1;
    u5.Left.Label.Text = p2.DisplayName or u1;
    u5.LayoutOrder = p4;
    u5.Right.Toggle.Selectable = false;
    local u9 = p6;
    local u10 = Janitor.new();
    u10:Add(u5, "Destroy");

    local function UpdateToggleVisual(p11) -- Line: 43
        -- upvalues: u5 (copy)
        u5.Right.Toggle.Icon.Visible = p11;
    end;

    u5.Right.Toggle.Icon.Visible = u9;
    u10:Add(u5.Right.Toggle.MouseButton1Click:Connect(function() -- Line: 51
        -- upvalues: u9 (ref), u5 (copy), u7 (copy), u8 (copy), u1 (copy)
        u9 = not u9;
        u5.Right.Toggle.Icon.Visible = u9;
        u7(u8, u1, u9);
    end), "Disconnect");
    u5.Parent = p3;

    return function() -- Line: 61
        -- upvalues: u10 (copy)
        u10:Cleanup();
    end;
end;