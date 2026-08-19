-- Decompiled with Potassium's decompiler.

local Trove = require(script.Parent.Parent.Trove);
local Signal = require(script.Parent.Parent.Signal);
local UserInputService = game:GetService("UserInputService");
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 55
    -- upvalues: u1 (copy), Trove (copy), Signal (copy)
    local v2 = setmetatable({}, u1);
    v2._trove = Trove.new();
    v2.KeyDown = v2._trove:Construct(Signal);
    v2.KeyUp = v2._trove:Construct(Signal);
    v2:_setup();

    return v2;
end;

function u1.IsKeyDown(p3, p4) -- Line: 72
    -- upvalues: UserInputService (copy)
    return UserInputService:IsKeyDown(p4);
end;

function u1.AreKeysDown(p5, p6, p7) -- Line: 84
    local v8 = p5:IsKeyDown(p6) and p5:IsKeyDown(p7);

    return v8;
end;

function u1.AreEitherKeysDown(p9, p10, p11) -- Line: 99
    return p9:IsKeyDown(p10) or p9:IsKeyDown(p11);
end;

function u1._setup(u12) -- Line: 103
    -- upvalues: UserInputService (copy)
    u12._trove:Connect(UserInputService.InputBegan, function(p13, p14) -- Line: 104
        -- upvalues: u12 (copy)
        if p14 then
            return;
        end;

        if p13.UserInputType == Enum.UserInputType.Keyboard then
            u12.KeyDown:Fire(p13.KeyCode);
        end;
    end);
    u12._trove:Connect(UserInputService.InputEnded, function(p15, p16) -- Line: 113
        -- upvalues: u12 (copy)
        if p16 then
            return;
        end;

        if p15.UserInputType == Enum.UserInputType.Keyboard then
            u12.KeyUp:Fire(p15.KeyCode);
        end;
    end);
end;

function u1.Destroy(p17) -- Line: 126
    p17._trove:Destroy();
end;

return u1;