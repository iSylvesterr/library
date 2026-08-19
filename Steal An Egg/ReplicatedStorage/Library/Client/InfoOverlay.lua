-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
Library:WaitForChild("Types");
local Client = Library:WaitForChild("Client");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local TextService = game:GetService("TextService");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local Variables = require(Library.Variables);
local Tween = require(Library.Functions.Tween);
local Player = require(Library.Player);
require(Library.Signal);
local Audio = require(Library.Audio);
local ScreenResolution = require(Client.ScreenResolution);
local InfoOverlay = Assets.UI.FRAMEWORK.InfoOverlay;
local Blocks = InfoOverlay:WaitForChild("Blocks");
local u2 = GuiService:GetGuiInset();
local u3 = nil;
local u4 = {};
local u5 = nil;

function u1.IsActive() -- Line: 25
    -- upvalues: u3 (ref)
    return u3 ~= nil;
end;

function u1.Remove() -- Line: 29
    -- upvalues: u3 (ref)
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;
end;

function u1.Add(u6, ...) -- Line: 36
    -- upvalues: u3 (ref), u1 (copy), InfoOverlay (copy), TextService (copy), ScreenResolution (copy), Blocks (copy), u4 (copy), u5 (ref), Player (copy), Audio (copy), Tween (copy), RunService (copy), u2 (copy), Variables (copy), GuiService (copy)
    local u7 = { ... };

    if u3 then
        u1.Remove();
    end;

    local u8 = InfoOverlay:FindFirstChild("Base"):Clone();
    local u9 = 0;
    local u10 = {};

    local function updateSize() -- Line: 46
        -- upvalues: u9 (ref), u7 (copy), u10 (copy), TextService (ref), u8 (copy), ScreenResolution (ref)
        u9 = 0;

        for i, _ in ipairs(u7) do
            local v11 = u10[i];
            local settings = v11:FindFirstChild("settings");
            local v12 = v11:FindFirstChildOfClass("UIListLayout");
            local v13 = v11:FindFirstChildOfClass("UIGridLayout");
            local v14 = v11:FindFirstChildOfClass("UIPadding");
            local zero = Vector2.zero;

            if v12 then
                zero = v12:GetAttribute("OriginalAbsoluteContentSize") or v12.AbsoluteContentSize;
            end;

            if settings then
                local v15 = settings:GetAttribute("boundsX");
                local X = v15.X;
                local Y = v15.Y;
                local v16 = 0;
                local v17 = 0;
                local v18 = 0;

                if v12 then
                    v18 = zero.Y;
                elseif not v13 then
                    for _, child in ipairs(v11:GetChildren()) do
                        if child:IsA("GuiObject") and child.Visible then
                            local v19 = child:GetAttribute("OriginalSize");

                            if not v19 then
                                v19 = child.Size;
                                child:SetAttribute("OriginalSize", v19);
                            end;

                            local v20 = child:GetAttribute("OriginalAbsoluteSize") or child.AbsoluteSize;

                            if child.ClassName == "TextLabel" or child.ClassName == "TextButton" then
                                if v19.X.Scale ~= 0 or child.AutomaticSize == Enum.AutomaticSize.X then
                                    local v21 = Vector2.new(Y * v19.X.Scale, 1000);
                                    local v22 = TextService:GetTextSize(child:GetAttribute("BaseText") or child.ContentText, child.TextSize, child.Font == Enum.Font.Unknown and Enum.Font.Arial or child.Font, v21) + Vector2.new(10, 1);
                                    v16 = math.max(v22.X, v16);
                                    v17 = v17 + math.max(v22.Y, v20.Y);
                                    local v23 = child:FindFirstChildOfClass("UIStroke");

                                    if v23 then
                                        v16 = v16 + v23.Thickness * 2;
                                        v17 = v17 + v23.Thickness * 2;
                                    end;

                                    child.Size = UDim2.new(0, v22.X, 0, v22.Y);
                                end;
                            elseif v19.X.Scale ~= 0 then
                                v18 = v18 + v20.Y;
                            end;
                        end;
                    end;
                end;

                if v12 and v12.FillDirection == Enum.FillDirection.Horizontal then
                    v16 = math.max(zero.X + 10, v16);
                end;

                if v14 then
                    if not v13 then
                        v17 = v17 + (v14.PaddingTop.Offset + v14.PaddingBottom.Offset);
                    end;

                    v16 = v16 + (v14.PaddingLeft.Offset + v14.PaddingRight.Offset);
                end;

                local v24 = math.clamp(v16, X, Y);
                u9 = math.max(v24, u9);

                if v13 then
                    v18 = (v13:GetAttribute("OriginalAbsoluteContentSize") or v13.AbsoluteContentSize).Y;
                end;

                v11.Size = UDim2.new(1, 0, 0, v17 + v18);
            end;
        end;

        local v25 = u8.Frame.Blocks:FindFirstChildOfClass("UIPadding");
        local v26 = u8.Frame.Blocks:FindFirstChildOfClass("UIListLayout");
        v26:ApplyLayout();
        u8.Size = UDim2.new(0, u9 + v25.PaddingLeft.Offset + v25.PaddingRight.Offset, 0, v26.AbsoluteContentSize.Y + v25.PaddingTop.Offset + v25.PaddingBottom.Offset);

        if #u7 == 1 then
            u8.Frame.UICorner.CornerRadius = UDim.new(0.15, 0);
        end;

        local UIScale = u8.UIScale;
        local v27 = ScreenResolution.GetScale();
        UIScale.Scale = 1 - (1 - math.min(v27, 1)) / 1.5;
    end;

    local u28 = false;
    local u29 = false;
    local u30 = "Down";

    for i, v in ipairs(u7) do
        local u31 = v[1];
        local u32 = Blocks:FindFirstChild(u31):Clone();
        table.insert(u10, u32);
        local settings = u32:FindFirstChild("settings");

        if settings and settings:FindFirstChild("code") then
            task.spawn(function() -- Line: 168
                -- upvalues: u4 (ref), u31 (copy), settings (copy), u32 (copy), u28 (ref), u29 (ref), v (copy)
                local v33 = u4[u31] or require(settings:FindFirstChild("code"));
                u32:GetAttributeChangedSignal("Updated"):Connect(function() -- Line: 170
                    -- upvalues: u32 (ref), u28 (ref), u29 (ref)
                    if u32:GetAttribute("Updated") == true then
                        u32:SetAttribute("Updated", false);

                        if u28 then
                            u29 = true;
                        end;
                    end;
                end);
                v33(u32, unpack(v));
            end);
        end;

        u32.LayoutOrder = i * 100;
        u32.Parent = u8.Frame.Blocks;
    end;

    updateSize();

    if not u5 then
        u5 = Instance.new("ScreenGui");
        u5.DisplayOrder = 10000;
        u5.ZIndexBehavior = Enum.ZIndexBehavior.Global;
        u5.ResetOnSpawn = false;
        u5.Name = "InfoOverlay";
        u5.Parent = Player.PlayerGui();
        u5.ClipToDeviceSafeArea = false;
    end;

    u8.Parent = u5;
    Audio.Play("rbxassetid://89944486811970", script, 1, 0.2);
    u3 = u8;
    local v34 = false;

    for _, v in ipairs(u7) do
        if v[1] == "Rarity" then
            v34 = v[2] == "Exclusive" and true or v34;
            break;
        end;
    end;

    if v34 then
        local v35 = InfoOverlay.ExclusiveShine:Clone();
        v35.Parent = u8.Frame;
        local v36 = u8.Frame:FindFirstChildOfClass("UIStroke");
        local u37 = InfoOverlay.ExclusiveShineOutline:Clone();
        u37.Parent = v36;
        v36.Color = Color3.fromRGB(255, 255, 255);
        v35.Offset = Vector2.new(0, -1.25);
        Tween(v35, {
            Offset = Vector2.new(0, 2)
        }, { 0.75, "Sine", "Out" });
        task.spawn(function() -- Line: 228
            -- upvalues: u8 (copy), u37 (copy), RunService (ref)
            local v38 = tick();
            task.wait();

            while u8 and u8.Parent do
                u37.Rotation = 100 + (tick() - v38) * 100;
                RunService.RenderStepped:Wait();
            end;
        end);
    end;

    coroutine.wrap(function() -- Line: 238
        -- upvalues: Player (ref), u8 (copy), u29 (ref), updateSize (copy), u2 (ref), Variables (ref), u6 (copy), u30 (ref), RunService (ref)
        local v39 = Player.Mouse();
        local CurrentCamera = game.Workspace.CurrentCamera;

        while u8 and u8.Parent do
            if u29 then
                u29 = false;
                updateSize();
            end;

            local X = v39.X;
            local Y = v39.Y;
            local Y2 = u8.AbsoluteSize.Y;
            local v40 = CurrentCamera.ViewportSize.Y - u2.Y;

            if Variables.Console then
                X = u6.AbsolutePosition.X + u6.AbsoluteSize.X * 0.5;
                Y = u6.AbsolutePosition.Y + u6.AbsoluteSize.Y * 0.5;
            end;

            if Y + Y2 + 10 < v40 then
                u30 = "Down";
            elseif Y - Y2 - 10 > 0 then
                u30 = "Up";
            end;

            local v41 = CurrentCamera.ViewportSize.X - u2.X - u8.AbsoluteSize.X;

            if u30 == "Down" then
                Y2 = -Y2 or Y2;
            end;

            local v42 = v40 + Y2;
            u8.AnchorPoint = Vector2.new(0, u30 == "Down" and 0 or 1);
            u8.Position = UDim2.new(0, math.clamp(X + 10, 0, v41 < 0 and 0 or v41), 0, (math.clamp(Y + (u30 == "Down" and 10 or -10), 0, v42 < 0 and 0 or v42)));
            RunService.RenderStepped:Wait();
        end;
    end)();
    coroutine.wrap(function() -- Line: 277
        -- upvalues: Player (ref), u6 (copy), u8 (copy), Variables (ref), GuiService (ref), u1 (ref), RunService (ref), u3 (ref)
        local v43 = Player.Mouse();

        if not u6:GetAttribute("SurfaceElement") then
            while u8 and u8.Parent do
                local X = v43.X;
                local Y = v43.Y;
                local X2 = u6.AbsolutePosition.X;
                local Y2 = u6.AbsolutePosition.Y;
                local X3 = u6.AbsoluteSize.X;
                local Y3 = u6.AbsoluteSize.Y;

                if Variables.Console then
                    if GuiService.SelectedObject ~= u6 then
                        u1.Remove();
                    end;
                elseif X > X2 + X3 or (X2 > X or (Y2 + Y3 <= Y or Y < Y2)) then
                    u1.Remove();
                end;

                RunService.RenderStepped:Wait();
            end;

            return;
        end;

        local u44 = nil;
        u44 = u6.MouseLeave:Connect(function() -- Line: 303
            -- upvalues: u8 (ref), u3 (ref), u1 (ref), u44 (ref)
            if u8 ~= u3 then
                return;
            end;

            u1.Remove();

            if u44 then
                u44:Disconnect();
                u44 = nil;
            end;
        end);
        u6.Destroying:Connect(function() -- Line: 313
            -- upvalues: u8 (ref), u3 (ref), u1 (ref), u44 (ref)
            if u8 ~= u3 then
                return;
            end;

            u1.Remove();

            if u44 then
                u44:Disconnect();
                u44 = nil;
            end;
        end);
    end)();
end;

function u1.Hook(u45, u46) -- Line: 328
    -- upvalues: Variables (copy), u1 (copy)
    local u47 = u45.MouseEnter:Connect(function() -- Line: 329
        -- upvalues: Variables (ref), u1 (ref), u45 (copy), u46 (copy)
        if not Variables.DisableInfoOverlay then
            u1.Add(u45, unpack(u46));
        end;
    end);
    local u48 = u45.SelectionGained:Connect(function() -- Line: 334
        -- upvalues: Variables (ref), u1 (ref), u45 (copy), u46 (copy)
        if not Variables.DisableInfoOverlay then
            u1.Add(u45, unpack(u46));
        end;
    end);

    return function() -- Line: 339
        -- upvalues: u47 (copy), u48 (copy)
        u47:Disconnect();
        u48:Disconnect();
    end;
end;

function u1.DynamicHook(u49, u50) -- Line: 345
    -- upvalues: Variables (copy), u1 (copy)
    local u51 = u49.MouseEnter:Connect(function() -- Line: 346
        -- upvalues: Variables (ref), u1 (ref), u49 (copy), u50 (copy)
        if not Variables.DisableInfoOverlay then
            u1.Add(u49, unpack(u50()));
        end;
    end);
    local u52 = u49.SelectionGained:Connect(function() -- Line: 351
        -- upvalues: Variables (ref), u1 (ref), u49 (copy), u50 (copy)
        if not Variables.DisableInfoOverlay then
            u1.Add(u49, unpack(u50()));
        end;
    end);

    return function() -- Line: 356
        -- upvalues: u51 (copy), u52 (copy)
        u51:Disconnect();
        u52:Disconnect();
    end;
end;

return u1;