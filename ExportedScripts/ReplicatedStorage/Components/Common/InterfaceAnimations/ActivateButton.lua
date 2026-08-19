-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local u1 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Router = require(ReplicatedStorage.Database.Security.Router);

local function MultiplyUdim2(p2, p3) -- Line: 14
    return UDim2.new(p2.X.Scale * p3, p2.X.Offset, p2.Y.Scale * p3, p2.Y.Offset);
end;

return function(u4) -- Line: 21
    -- upvalues: Router (copy), TweenService (copy), u1 (copy)
    local Size = u4.Size;
    u4.MouseEnter:Connect(function() -- Line: 24
        -- upvalues: Router (ref), TweenService (ref), u4 (copy), u1 (ref), Size (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        local v5 = {};
        local v6 = Size;
        v5.Size = UDim2.new(v6.X.Scale * 0.95, v6.X.Offset, v6.Y.Scale * 0.95, v6.Y.Offset);
        TweenService:Create(u4, u1, v5):Play();
    end);
    u4.MouseLeave:Connect(function() -- Line: 31
        -- upvalues: TweenService (ref), u4 (copy), u1 (ref), Size (copy)
        local v7 = {};
        local v8 = Size;
        v7.Size = UDim2.new(v8.X.Scale * 1, v8.X.Offset, v8.Y.Scale * 1, v8.Y.Offset);
        TweenService:Create(u4, u1, v7):Play();
    end);
    u4.MouseButton1Down:Connect(function() -- Line: 37
        -- upvalues: Router (ref), TweenService (ref), u4 (copy), u1 (ref), Size (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local v9 = {};
        local v10 = Size;
        v9.Size = UDim2.new(v10.X.Scale * 0.9, v10.X.Offset, v10.Y.Scale * 0.9, v10.Y.Offset);
        TweenService:Create(u4, u1, v9):Play();
    end);
    u4.MouseButton1Up:Connect(function() -- Line: 44
        -- upvalues: TweenService (ref), u4 (copy), u1 (ref), Size (copy)
        local v11 = {};
        local v12 = Size;
        v11.Size = UDim2.new(v12.X.Scale * 0.95, v12.X.Offset, v12.Y.Scale * 0.95, v12.Y.Offset);
        TweenService:Create(u4, u1, v11):Play();
    end);
end;