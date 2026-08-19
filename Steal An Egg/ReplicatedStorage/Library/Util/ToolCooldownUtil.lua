-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u10 = {
    InitializeTool = function(p1) -- Line: 18, Name: InitializeTool
        -- upvalues: Asserts (copy)
        Asserts.Tool(p1);
        local v2 = p1:GetAttribute("CooldownEndTime");

        if typeof(v2) ~= "number" then
            p1:SetAttribute("CooldownEndTime", 0);
        end;

        local v3 = p1:GetAttribute("CooldownDuration");

        if typeof(v3) ~= "number" then
            p1:SetAttribute("CooldownDuration", 0);
        end;

        local v4 = p1:GetAttribute("CooldownActive");

        if typeof(v4) ~= "boolean" then
            p1:SetAttribute("CooldownActive", false);
        end;
    end,

    StartCooldown = function(u5, p6) -- Line: 37, Name: StartCooldown
        -- upvalues: Asserts (copy)
        Asserts.Tool(u5);
        Asserts.finite(p6);
        Asserts.cond(p6 >= 0);
        local u7 = workspace:GetServerTimeNow() + p6;
        u5:SetAttribute("CooldownDuration", p6);
        u5:SetAttribute("CooldownEndTime", u7);
        u5:SetAttribute("CooldownActive", true);
        task.delay(p6, function() -- Line: 49
            -- upvalues: u5 (copy), u7 (copy)
            if u5 and (u5.Parent and u5:GetAttribute("CooldownEndTime") == u7) then
                u5:SetAttribute("CooldownActive", false);
                u5:SetAttribute("CooldownDuration", 0);
                u5:SetAttribute("CooldownEndTime", 0);
            end;
        end);
    end,

    IsOnCooldown = function(p8) -- Line: 58, Name: IsOnCooldown
        -- upvalues: Asserts (copy)
        Asserts.Tool(p8);

        if not p8:GetAttribute("CooldownActive") then
            return false;
        end;

        local v9 = p8:GetAttribute("CooldownEndTime");

        if v9 and type(v9) == "number" then
            return workspace:GetServerTimeNow() < v9;
        end;

        return false;
    end
};

function u10.GetRemainingCooldown(p11) -- Line: 74
    -- upvalues: Asserts (copy), u10 (copy)
    Asserts.Tool(p11);

    if not u10.IsOnCooldown(p11) then
        return 0;
    end;

    local v12 = p11:GetAttribute("CooldownEndTime");

    if not v12 or type(v12) ~= "number" then
        return 0;
    end;

    local v13 = v12 - workspace:GetServerTimeNow();

    return math.max(0, v13);
end;

function u10.ClearCooldown(p14) -- Line: 89
    -- upvalues: Asserts (copy)
    Asserts.Tool(p14);
    p14:SetAttribute("CooldownActive", false);
    p14:SetAttribute("CooldownDuration", 0);
    p14:SetAttribute("CooldownEndTime", 0);
end;

return u10;