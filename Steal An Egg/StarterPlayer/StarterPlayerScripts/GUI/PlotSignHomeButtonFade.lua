-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
local u2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

function u1.new(p3) -- Line: 33
    -- upvalues: u1 (copy), Trove (copy)
    local Home = p3:FindFirstChild("Home");
    assert(Home ~= nil, "YourBase.Home must exist");
    local v4 = Home:IsA("ImageButton");
    assert(v4, "YourBase.Home must be an ImageButton");
    local v5 = setmetatable({}, u1);
    v5._activeTween = nil;
    v5._home = Home;
    v5._revision = 0;
    v5._trove = Trove.new();
    v5._visible = nil;
    v5._yourBase = p3;

    return v5;
end;

function u1.SetVisible(u6, u7) -- Line: 53
    -- upvalues: TweenService (copy), u2 (copy)
    if u6._visible == u7 then
        return;
    end;

    u6._visible = u7;
    u6._revision = u6._revision + 1;
    local _revision = u6._revision;
    u6._trove:Clean();

    if u7 then
        u6._yourBase.Enabled = true;
    end;

    local u8 = TweenService:Create(u6._home, u2, {
        ImageTransparency = u7 and 0 or 1
    });
    u6._activeTween = u8;
    u6._trove:Add(function() -- Line: 71
        -- upvalues: u6 (copy), u8 (copy)
        if u6._activeTween == u8 then
            u8:Cancel();
            u6._activeTween = nil;
        end;
    end);
    u6._trove:Add(u8.Completed:Connect(function(p9) -- Line: 77
        -- upvalues: u6 (copy), _revision (copy), u8 (copy), u7 (copy)
        if u6._revision ~= _revision or u6._activeTween ~= u8 then
            return;
        end;

        u6._activeTween = nil;

        if p9 == Enum.PlaybackState.Completed and not u7 then
            u6._yourBase.Enabled = false;
        end;
    end));
    u8:Play();
end;

function u1.Destroy(p10) -- Line: 90
    p10._revision = p10._revision + 1;
    p10._trove:Destroy();
end;

return u1;