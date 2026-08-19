-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local u1 = Color3.fromRGB(255, 255, 255);
local u2 = Color3.fromRGB(255, 201, 14);

local function AnimateButton(p3, p4) -- Line: 22
    -- upvalues: u2 (copy), u1 (copy)
    local v5;

    if p4 then
        v5 = u2;
    else
        v5 = u1;
    end;

    p3.TextColor3 = v5;
end;

return function(u6, u7, p8, p9, u10, p11, u12, u13, u14, u15, u16) -- Line: 29
    -- upvalues: Janitor (copy), u1 (copy)
    local u17 = Janitor.new();
    local u18 = p11;
    u10:SetAttribute("IsDropdown", true);
    u10.LayoutOrder = p9;
    u10.Left.Label.Text = u7.DisplayName or u6;
    u10.Name = u6;
    local DropdownContent = u10.Right.Dropdown.DropdownContent;
    local Scroll = DropdownContent.Scroll;
    u10.Right.Dropdown.Container.Left.Title.Text = u18;
    DropdownContent.Active = false;
    DropdownContent.Visible = false;
    Scroll.Visible = false;

    local function ClearOptions() -- Line: 64
        -- upvalues: u17 (copy), Scroll (copy)
        u17:Cleanup();

        for _, child in ipairs(Scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy();
            end;
        end;
    end;

    local u19 = Janitor.new();
    u19:Add(u10, "Destroy");
    u19:Add(ClearOptions);
    u19:Add(u10.Right.Dropdown.MouseButton1Click:Connect(function() -- Line: 79
        -- upvalues: u15 (copy), Scroll (copy), u10 (copy), ClearOptions (copy), u7 (copy), u14 (copy), u1 (ref), u17 (copy), u18 (ref), DropdownContent (copy), u16 (copy), u12 (copy), u13 (copy), u6 (copy)
        local v20 = u15();
        local v21 = not Scroll.Visible;

        if v20 and v20 ~= Scroll then
            v20.Visible = false;
            local Parent = v20.Parent;

            if Parent then
                Parent.Visible = false;
            end;

            for _, child in ipairs(v20:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy();
                end;
            end;
        end;

        for _, child in ipairs(u10.Parent:GetChildren()) do
            if child:GetAttribute("IsDropdown") then
                child.ZIndex = v21 and child.Name == u10.Name and 11 or 1;
            end;
        end;

        ClearOptions();

        if not (v21 and u7.Enums) then
            Scroll.Visible = false;
            DropdownContent.Visible = false;
            u16(nil);

            return;
        end;

        for i, v in ipairs(u7.Enums) do
            local u22 = u14:WaitForChild("OptionTemplate"):Clone();
            u22.Size = UDim2.fromScale(1, 1 / #u7.Enums);
            u22.Name = `Option_{v}`;
            u22.Frame.TextButton.Text = v;
            u22.LayoutOrder = i;
            u22.Visible = true;
            u22.Parent = Scroll;
            local u23 = u10.Right.Dropdown.Container.Left.Title.Text == v;
            u22.Frame.BackgroundTransparency = u23 and 0.3 or 1;
            u22.TextColor3 = u1;
            u17:Add(u22.MouseEnter:Connect(function() -- Line: 130
                -- upvalues: u22 (copy), u23 (copy)
                u22.Frame.BackgroundTransparency = u23 and 0.3 or 0.65;
            end), "Disconnect", (`Option_{v}_1`));
            u17:Add(u22.MouseLeave:Connect(function() -- Line: 135
                -- upvalues: u22 (copy), u23 (copy)
                u22.Frame.BackgroundTransparency = u23 and 0.3 or 1;
            end), "Disconnect", (`Option_{v}_2`));
            u17:Add(u22.MouseButton1Click:Connect(function() -- Line: 140
                -- upvalues: u18 (ref), v (copy), u10 (ref), Scroll (ref), DropdownContent (ref), u16 (ref), u12 (ref), u13 (ref), u6 (ref), ClearOptions (ref)
                u18 = v;
                u10.Right.Dropdown.Container.Left.Title.Text = v;
                Scroll.Visible = false;
                DropdownContent.Visible = false;
                u16(nil);
                u12(u13, u6, u18);
                ClearOptions();
            end), "Disconnect", (`Option_{v}_3`));
            u17:Add(u22, "Destroy");
        end;

        local v24 = #u7.Enums;
        Scroll.Size = UDim2.new(1, 0, 0, v24 * 30 + (v24 - 1) * 5);
        DropdownContent.Visible = true;
        Scroll.Visible = true;
        u16(Scroll);
    end), "Disconnect");
    u10.Parent = p8;

    return function() -- Line: 176
        -- upvalues: u17 (copy), u19 (copy)
        u17:Cleanup();
        u19:Cleanup();
    end;
end;