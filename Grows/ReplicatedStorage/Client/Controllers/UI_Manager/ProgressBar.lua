-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
game:GetService("UserInputService");
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local u1 = {};

return function(p2) -- Line: 8
    -- upvalues: u1 (copy), TweenService (copy), Maid (copy)
    function p2.SetBar(p3, p4, p5, p6, p7, p8) -- Line: 11
        -- upvalues: u1 (ref), TweenService (ref)
        if not u1[p4] then
            return;
        end;

        if u1[p4].currentRatio == p5 then
            return;
        end;

        local v9 = p7 or Enum.EasingStyle.Quad;
        local v10 = p8 or Enum.EasingDirection.InOut;
        local v11 = math.clamp(p5, 0, 1);

        if u1[p4].currentTween then
            u1[p4].currentTween:Cancel();
        end;

        u1[p4].currentRatio = v11;
        u1[p4].currentTween = TweenService:Create(u1[p4].numVal, TweenInfo.new(p6, v9, v10), {
            Value = u1[p4].currentRatio
        });
        u1[p4].currentTween:Play();
    end;

    function p2.AddProgressBar(p12, u13, u14) -- Line: 32
        -- upvalues: u1 (ref), Maid (ref)
        u1[u13] = {};
        u1[u13].maid = Maid.new();
        u1[u13].currentRatio = 0;
        u1[u13].currentTween = nil;
        u1[u13].numVal = Instance.new("NumberValue");
        u1[u13].numVal.Parent = u13;
        u1[u13].maid:GiveTask(u1[u13].numVal.Changed:Connect(function(p15) -- Line: 40
            -- upvalues: u13 (copy), u14 (copy)
            u13.Fill.Size = UDim2.new(p15, 0, 1, 0);

            if u14 then
                local Value = u14.Keypoints[1].Value;

                for _, v in u14.Keypoints do
                    if v.Time <= p15 then
                        Value = v.Value;
                    end;
                end;

                u13.Fill.BackgroundColor3 = Value;
            end;
        end));
        u1[u13].numVal.Value = 1;
        u1[u13].numVal.Value = 0;
        u1[u13].maid:GiveTask(function() -- Line: 56
            -- upvalues: u1 (ref), u13 (copy)
            if u1[u13].numVal then
                u1[u13].numVal:Destroy();
            end;
        end);

        return u1[u13];
    end;

    function p2.RemoveProgressBar(p16, p17) -- Line: 67
        -- upvalues: u1 (ref)
        if u1[p17] then
            u1[p17].maid:Destroy();
            u1[p17] = nil;
        end;
    end;

    return p2;
end;