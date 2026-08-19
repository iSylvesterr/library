-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local u1 = {};
local u2 = Color3.new(0.168627, 1, 0.305882);
local u3 = Color3.new(1, 0.231373, 0.203922);

return function(p4) -- Line: 11
    -- upvalues: u1 (copy), TweenService (copy), u2 (copy), u3 (copy), Maid (copy)
    function p4.SetToggleButton(p5, p6, p7) -- Line: 13
        -- upvalues: u1 (ref), TweenService (ref), u2 (ref), u3 (ref)
        if not u1[p6] then
            return;
        end;

        if u1[p6].currentState == p7 then
            return;
        end;

        u1[p6].currentState = p7;

        if u1[p6].moveTween then
            u1[p6].moveTween:Cancel();
        end;

        if u1[p6].colorTween then
            u1[p6].colorTween:Cancel();
        end;

        if p7 == true then
            u1[p6].moveTween = TweenService:Create(p6.ToggleCircle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.75, 0, 0.5, 0)
            });
            u1[p6].colorTween = TweenService:Create(p6, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = u2
            });
            u1[p6].moveTween:Play();
            u1[p6].colorTween:Play();

            return;
        end;

        u1[p6].moveTween = TweenService:Create(p6.ToggleCircle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.25, 0, 0.5, 0)
        });
        u1[p6].colorTween = TweenService:Create(p6, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u3
        });
        u1[p6].moveTween:Play();
        u1[p6].colorTween:Play();
    end;

    function p4.AddToggleButton(p8, u9) -- Line: 58
        -- upvalues: u1 (ref), Maid (ref)
        u1[u9] = {};
        u1[u9].maid = Maid.new();
        u1[u9].moveTween = nil;
        u1[u9].colorTween = nil;
        u1[u9].currentState = true;
        u1[u9].maid:GiveTask(u9.MouseButton1Down:Connect(function() -- Line: 67
            -- upvalues: u1 (ref), u9 (copy)
            u1[u9].switchSignal:Fire();
        end));

        return u1[u9];
    end;

    function p4.GetToggleState(p10, p11) -- Line: 77
        -- upvalues: u1 (ref)
        if u1[p11] then
            return u1[p11].currentState;
        end;

        return nil;
    end;

    function p4.RemoveToggleButton(p12, p13) -- Line: 83
        -- upvalues: u1 (ref)
        if u1[p13] then
            u1[p13].maid:Destroy();
            u1[p13] = nil;
        end;
    end;
end;