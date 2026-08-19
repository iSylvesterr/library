-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TextService = game:GetService("TextService");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Variables = require(Library.Variables);
local PlayerGui = Players.LocalPlayer.PlayerGui;

return function(u1, u2) -- Line: 14, Name: Tooltip
    -- upvalues: Variables (copy), PlayerGui (copy), TextService (copy), Players (copy), RunService (copy)
    if Variables.Mobile then
        return function() -- Line: 16
        end;
    end;

    local u3 = {};
    local u4 = nil;
    local u5 = nil;
    local TooltipsFolder = PlayerGui:FindFirstChild("TooltipsFolder");

    if TooltipsFolder == nil then
        TooltipsFolder = Instance.new("ScreenGui");
        TooltipsFolder.Name = "TooltipsFolder";
        TooltipsFolder.DisplayOrder = 999;
        TooltipsFolder.Parent = PlayerGui;
    end;

    local function showTooltip() -- Line: 32
        -- upvalues: TooltipsFolder (ref), u4 (ref), u2 (copy), TextService (ref), u5 (ref), u1 (copy), Variables (ref), Players (ref), RunService (ref)
        TooltipsFolder:ClearAllChildren();
        u4 = Instance.new("TextLabel");
        u4.BorderSizePixel = 0;
        u4.BackgroundColor3 = Color3.new(0.35, 0.35, 0.35);
        u4.TextColor3 = Color3.new(1, 1, 1);
        u4.TextSize = 18;
        u4.Font = Enum.Font.FredokaOne;
        u4.Text = u2;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(1, 0);
        UICorner.Parent = u4;
        local v6 = TextService:GetTextSize(u4.Text, u4.TextSize, u4.Font, Vector2.new(1000, 1000));
        u4.Size = UDim2.fromOffset(v6.X + 14, v6.Y + 8);
        u4.Parent = TooltipsFolder;

        if not TooltipsFolder.Enabled then
            TooltipsFolder.Enabled = true;
        end;

        while not u5 and (u4 and (u4.Parent and (u1 and not Variables.Mobile))) do
            local v7 = Players.LocalPlayer:GetMouse();
            local X = v7.X;
            local Y = v7.Y;
            local X2 = u1.AbsolutePosition.X;
            local Y2 = u1.AbsolutePosition.Y;

            if Variables.Console then
                X = u1.AbsolutePosition.X + u1.AbsoluteSize.X * 0.5;
                Y = u1.AbsolutePosition.Y + u1.AbsoluteSize.Y * 0.5;
            end;

            if X2 - 10 < X and (X < X2 + u1.AbsoluteSize.X + 10 and (Y2 - 10 < Y and Y < Y2 + u1.AbsoluteSize.Y + 10)) then
                if Variables.Console then
                    u4.Position = UDim2.fromOffset(X + 17, Y);
                else
                    u4.Position = UDim2.fromOffset(v7.X + 17, v7.Y);
                end;
            else
                u5 = true;
            end;

            RunService.RenderStepped:Wait();
        end;

        if u4 then
            u4:Destroy();
        end;
    end;

    local function destroyTooltip() -- Line: 87
        -- upvalues: u4 (ref)
        if u4 then
            u4:Destroy();
        end;
    end;

    u3[#u3 + 1] = u1.MouseEnter:Connect(function() -- Line: 93
        -- upvalues: u4 (ref), showTooltip (copy)
        if u4 then
            u4:Destroy();
        end;

        showTooltip();
    end);
    u3[#u3 + 1] = u1.MouseLeave:Connect(function() -- Line: 98
        -- upvalues: u4 (ref)
        if u4 then
            u4:Destroy();
        end;
    end);
    u3[#u3 + 1] = u1.SelectionGained:Connect(function() -- Line: 102
        -- upvalues: u4 (ref), showTooltip (copy)
        if u4 then
            u4:Destroy();
        end;

        showTooltip();
    end);
    u3[#u3 + 1] = u1.SelectionLost:Connect(function() -- Line: 107
        -- upvalues: u4 (ref)
        if u4 then
            u4:Destroy();
        end;
    end);

    return function() -- Line: 111
        -- upvalues: u3 (ref), u5 (ref)
        for _, v in ipairs(u3) do
            v:Disconnect();
        end;

        u3 = {};
        u5 = true;
    end;
end;