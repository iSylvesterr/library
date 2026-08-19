-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Maid = require(Packages:WaitForChild("Maid"));
local Signal = require(Packages:WaitForChild("Signal"));
Effects:WaitForChild("ShineV1Shine");
local u1 = {};

return function(p2) -- Line: 27
    -- upvalues: Signal (copy), u1 (copy), Maid (copy), TweenService (copy), RunService (copy)
    local u3 = Signal.new();

    function p2.AddPulseV2(p4, u5, p6, u7, p8) -- Line: 47
        -- upvalues: u1 (ref), Maid (ref), TweenService (ref), RunService (ref), u3 (copy)
        if u1[u5] then
            return;
        end;

        local u9 = p8 or {};
        u1[u5] = {};
        u1[u5].maid = Maid.new();
        local Size = u5.Size;
        local u10 = UDim2.new(Size.X.Scale * p6, Size.X.Offset * p6, Size.Y.Scale * p6, Size.Y.Offset * p6);
        local v11 = u9.growthRatio or 1.5;
        local u12 = UDim2.new(u10.X.Scale * v11, u10.X.Offset * v11, u10.Y.Scale * v11, u10.Y.Offset * v11);

        local function genWave(p13) -- Line: 72
            -- upvalues: u10 (copy), Size (copy), u5 (copy), u9 (ref), TweenService (ref), u12 (copy), u1 (ref)
            local Frame = Instance.new("Frame");
            local v14;

            if p13 then
                v14 = u10;
            else
                v14 = Size;
            end;

            Frame.Size = v14;
            Frame.Position = u5.Position;
            Frame.AnchorPoint = u5.AnchorPoint;
            Frame.BackgroundTransparency = 1;
            Frame.ZIndex = u9.zIndex or u5.ZIndex;
            local UIStroke = Instance.new("UIStroke");
            UIStroke.Thickness = u9.thickness or 1;
            UIStroke.Color = u9.color or Color3.new(1, 1, 1);
            UIStroke.Parent = Frame;
            local UICorner = Instance.new("UICorner");
            UICorner.CornerRadius = u9.curveAmt or UDim.new(1, 0);
            UICorner.Parent = Frame;
            Instance.new("UIAspectRatioConstraint").Parent = Frame;
            Frame.Parent = u5.Parent;
            local v15 = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = u12
            });
            local v16 = TweenService:Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Transparency = 1
            });
            v15:Play();
            v16:Play();
            local u17 = nil;
            u17 = v15.Completed:Connect(function() -- Line: 109
                -- upvalues: u17 (ref), Frame (copy)
                if u17 then
                    u17:Disconnect();
                end;

                if Frame then
                    Frame:Destroy();
                end;
            end);
            u1[u5].maid:GiveTask(function() -- Line: 118
                -- upvalues: u17 (ref), Frame (copy)
                if u17 then
                    u17:Disconnect();
                end;

                if Frame then
                    Frame:Destroy();
                end;
            end);
        end;

        local u18 = nil;

        local function pulse(p19) -- Line: 130
            -- upvalues: u18 (ref), u5 (copy), u10 (copy), TweenService (ref), Size (copy), genWave (copy)
            if u18 then
                u18:Cancel();
            end;

            u5.Size = u10;
            u18 = TweenService:Create(u5, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Size = Size
            });
            u18:Play();

            if not p19 then
                genWave(true);
            end;
        end;

        if u7 ~= nil then
            local u20 = u7;
            u1[u5].maid:GiveTask(RunService.RenderStepped:Connect(function(p21) -- Line: 149
                -- upvalues: u5 (copy), Size (copy), u20 (ref), u7 (copy), pulse (copy)
                u5.Size = Size;
                u20 = u20 - p21;

                if u20 > 0 then
                    return;
                end;

                u20 = u7;
                pulse();
            end));
        end;

        local u25 = u3:Connect(function(p22, p23, p24) -- Line: 161
            -- upvalues: u5 (copy), genWave (copy), pulse (copy)
            if p22 ~= u5 then
                return;
            end;

            if p23 then
                genWave(false);

                return;
            end;

            if p24 then
                pulse(true);

                return;
            end;

            pulse();
        end);
        u1[u5].maid:GiveTask(function() -- Line: 173
            -- upvalues: u25 (copy)
            if u25 then
                u25:Disconnect();
            end;
        end);
        u1[u5].maid:GiveTask(function() -- Line: 179
            -- upvalues: u18 (ref), u5 (copy), Size (copy)
            if u18 then
                u18:Cancel();
            end;

            u5.Size = Size;
        end);
    end;

    function p2.ForcePulseWave(p26, p27) -- Line: 187
        -- upvalues: u1 (ref), u3 (copy)
        if not u1[p27] then
            return;
        end;

        u3:Fire(p27, true);
    end;

    function p2.ForcePulse(p28, p29) -- Line: 194
        -- upvalues: u1 (ref), u3 (copy)
        if not u1[p29] then
            return;
        end;

        u3:Fire(p29, false, true);
    end;

    function p2.RemovePulseV2(p30, p31) -- Line: 202
        -- upvalues: u1 (ref)
        if u1[p31] then
            u1[p31].maid:Destroy();
            u1[p31] = nil;
        end;
    end;
end;