-- Decompiled with Potassium's decompiler.

local TweenService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;

return {
    playAndDestroy = function(u1) -- Line: 12, Name: playAndDestroy
        u1.Completed:Once(function() -- Line: 13
            -- upvalues: u1 (copy)
            return u1:Destroy();
        end);
        u1:Play();

        return u1;
    end,

    tweenAndDestroy = function(p2, p3, p4) -- Line: 25, Name: tweenAndDestroy
        -- upvalues: TweenService (copy)
        local u5 = TweenService:Create(p2, p3, p4);
        u5.Completed:Once(function() -- Line: 13
            -- upvalues: u5 (copy)
            return u5:Destroy();
        end);
        u5:Play();

        return u5;
    end
};