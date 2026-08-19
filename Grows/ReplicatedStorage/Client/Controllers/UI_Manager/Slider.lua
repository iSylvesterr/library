-- Decompiled with Potassium's decompiler.

game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local CustomEnum = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("CustomEnum"));
local Signal = require(ReplicatedStorage.Packages.Signal);
local u1 = {};
Color3.new(0.168627, 1, 0.305882);
Color3.new(1, 0.231373, 0.203922);

return function(u2) -- Line: 19
    -- upvalues: u1 (copy), CustomEnum (copy), Maid (copy), Signal (copy), UserInputService (copy)
    function u2.SetSlider(p3, p4, p5) -- Line: 21
        -- upvalues: u1 (ref), CustomEnum (ref)
        if not u1[p4] then
            return;
        end;

        local v6 = math.clamp(p5, 0, 1);

        if u1[p4].currentRatio == v6 then
            return;
        end;

        u1[p4].currentRatio = v6;

        if u1[p4].sliderType == CustomEnum.SLIDER_TYPE.NORMAL then
            p4.SlideBounds.Slide.Position = UDim2.new(v6, 0, 0.5, 0);
        elseif u1[p4].sliderType == CustomEnum.SLIDER_TYPE.GRADIENT then
            p4.SlideBounds.UIGradient.Offset = Vector2.new(v6 - 0.5, 0);
        end;

        local v7 = u1[p4].minVal + v6 * (u1[p4].maxVal - u1[p4].minVal) + u1[p4].minVal;
        u1[p4].currentDisplay = v7;

        if u1[p4].numberDisplay then
            if u1[p4].isPercent then
                u1[p4].numberDisplay.Text = math.ceil(v7) .. "%";
            else
                u1[p4].numberDisplay.Text = math.ceil(v7);
            end;
        end;

        if u1[p4].returnPercent then
            u1[p4].medUpdate:Fire(v6);

            return;
        end;

        u1[p4].medUpdate:Fire((math.ceil(v7)));
    end;

    function u2.AddSlider(p8, u9, p10, p11, p12, p13) -- Line: 52
        -- upvalues: u1 (ref), Maid (ref), Signal (ref), CustomEnum (ref), u2 (copy), UserInputService (ref)
        local v14 = p13 or {};
        u1[u9] = {};
        u1[u9].maid = Maid.new();
        u1[u9].currentRatio = 0.5;
        u1[u9].currentDisplay = 0.5;
        u1[u9].finalUpdate = Signal.new();
        u1[u9].medUpdate = Signal.new();
        u1[u9].numberDisplay = p10;
        u1[u9].minVal = p11;
        u1[u9].maxVal = p12;
        u1[u9].sliderType = v14.sliderType or CustomEnum.SLIDER_TYPE.NORMAL;
        u1[u9].isPercent = v14.percent;
        u1[u9].returnPercent = v14.returnPercent;

        local function posToPercent(p15) -- Line: 69
            -- upvalues: u9 (copy)
            return math.clamp((p15 - u9.SlideBounds.AbsolutePosition.X) / u9.SlideBounds.AbsoluteSize.X, 0, 1);
        end;

        local u16 = nil;
        u1[u9].maid:GiveTask(u9.InputBegan:Connect(function(p17) -- Line: 79
            -- upvalues: u9 (copy), u2 (ref), u16 (ref), UserInputService (ref)
            if p17.UserInputType == Enum.UserInputType.Touch or p17.UserInputType == Enum.UserInputType.MouseButton1 then
                if p17.UserInputState ~= Enum.UserInputState.Begin then
                    return;
                end;

                u2:SetSlider(u9, (math.clamp((p17.Position.X - u9.SlideBounds.AbsolutePosition.X) / u9.SlideBounds.AbsoluteSize.X, 0, 1)));
                u16 = UserInputService.InputChanged:Connect(function(p18) -- Line: 88
                    -- upvalues: u9 (ref), u2 (ref)
                    if p18.UserInputType == Enum.UserInputType.Touch or p18.UserInputType == Enum.UserInputType.MouseMovement then
                        u2:SetSlider(u9, (math.clamp((p18.Position.X - u9.SlideBounds.AbsolutePosition.X) / u9.SlideBounds.AbsoluteSize.X, 0, 1)));
                    end;
                end);
            end;
        end));
        u1[u9].maid:GiveTask(UserInputService.InputEnded:Connect(function(p19) -- Line: 99
            -- upvalues: u16 (ref), u1 (ref), u9 (copy)
            if not u16 then
                return;
            end;

            if p19.UserInputType == Enum.UserInputType.Touch or p19.UserInputType == Enum.UserInputType.MouseButton1 then
                u16:Disconnect();
                u16 = nil;

                if u1[u9].returnPercent then
                    u1[u9].finalUpdate:Fire(u1[u9].currentRatio);

                    return;
                end;

                u1[u9].finalUpdate:Fire((math.ceil(u1[u9].currentDisplay)));
            end;
        end));

        return u1[u9];
    end;

    function u2.GetSliderRatio(p20, p21) -- Line: 117
        -- upvalues: u1 (ref)
        if u1[p21] then
            return u1[p21].currentRatio;
        end;

        return nil;
    end;

    function u2.RemoveSlider(p22, p23) -- Line: 123
        -- upvalues: u1 (ref)
        if u1[p23] then
            u1[p23].maid:Destroy();
            u1[p23] = nil;
        end;
    end;
end;