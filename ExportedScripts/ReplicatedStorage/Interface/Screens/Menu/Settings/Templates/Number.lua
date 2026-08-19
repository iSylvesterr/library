-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);

return function(u1, p2, p3, p4, u5, p6, u7, u8) -- Line: 18
    -- upvalues: Janitor (copy)
    u5.Name = u1;
    u5.Left.Label.Text = p2.DisplayName or u1;
    u5.LayoutOrder = p4;
    local u9 = p6;
    local u10 = Janitor.new();
    u10:Add(u5, "Destroy");

    local function FormatNumber(p11) -- Line: 39
        local v12 = math.floor(p11);

        return tostring(v12);
    end;

    local function UpdateValue(p13) -- Line: 44
        -- upvalues: u9 (ref), u5 (copy)
        u9 = math.floor(p13);
        local Title = u5.Right.Dropdown.Container.Left.Title;
        local v14 = math.floor(u9);
        Title.Text = tostring(v14);
    end;

    u9 = math.floor(u9);
    local Title = u5.Right.Dropdown.Container.Left.Title;
    local v15 = math.floor(u9);
    Title.Text = tostring(v15);
    local Title2 = u5.Right.Dropdown.Container.Left.Title;
    local Dropdown = u5.Right.Dropdown;
    u10:Add(Dropdown.MouseButton1Click:Connect(function() -- Line: 54
        -- upvalues: Title2 (copy)
        Title2:CaptureFocus();
    end), "Disconnect");
    u10:Add(Dropdown.Activated:Connect(function() -- Line: 57
        -- upvalues: Title2 (copy)
        Title2:CaptureFocus();
    end), "Disconnect");
    u10:Add(u5.Right.Dropdown.Container.Left.Title.FocusLost:Connect(function() -- Line: 62
        -- upvalues: u5 (copy), u9 (ref), u7 (copy), u8 (copy), u1 (copy)
        local v16 = tonumber(u5.Right.Dropdown.Container.Left.Title.Text);

        if not v16 then
            local Title3 = u5.Right.Dropdown.Container.Left.Title;
            local v17 = math.floor(u9);
            Title3.Text = tostring(v17);

            return;
        end;

        u9 = math.floor(v16);
        local Title3 = u5.Right.Dropdown.Container.Left.Title;
        local v18 = math.floor(u9);
        Title3.Text = tostring(v18);
        u7(u8, u1, u9);
    end), "Disconnect");
    u5.Parent = p3;

    return function() -- Line: 78
        -- upvalues: u10 (copy)
        u10:Cleanup();
    end;
end;