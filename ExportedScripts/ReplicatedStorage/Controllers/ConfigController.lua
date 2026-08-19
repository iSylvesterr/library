-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = game:GetService("RunService"):IsServer();
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = nil;

local function getSnapshot() -- Line: 16
    -- upvalues: u1 (copy), u3 (ref)
    if not u1 then
        return nil;
    end;

    if u3 then
        return u3;
    end;

    local success, result = pcall(function() -- Line: 20
        return game:GetService("ConfigService"):GetConfigAsync();
    end);

    if not (success and result) then
        return nil;
    end;

    u3 = result;
    result.UpdateAvailable:Connect(function() -- Line: 26
        -- upvalues: result (copy)
        pcall(result.Refresh, result);
    end);

    return u3;
end;

function u2.Get(p4) -- Line: 32
    -- upvalues: u1 (copy), getSnapshot (copy), LocalPlayer (copy)
    if not u1 then
        return LocalPlayer:GetAttribute(p4);
    end;

    local v5 = getSnapshot();

    if not v5 then
        return nil;
    end;

    local success, result = pcall(v5.GetValue, v5, p4);

    if success then
        return result;
    end;

    return nil;
end;

function u2.GetNumber(p6, p7) -- Line: 42
    -- upvalues: u2 (copy)
    local v8 = u2.Get(p6);

    return tonumber(v8) or p7;
end;

function u2.GetRewardMultiplier(p9) -- Line: 47
    -- upvalues: u2 (copy)
    return math.max(0, u2.GetNumber(p9, 1));
end;

function u2.OnChanged(u10, u11) -- Line: 51
    -- upvalues: u1 (copy), getSnapshot (copy), LocalPlayer (copy)
    if not u1 then
        return LocalPlayer:GetAttributeChangedSignal(u10):Connect(function() -- Line: 62
            -- upvalues: u11 (copy), LocalPlayer (ref), u10 (copy)
            u11(LocalPlayer:GetAttribute(u10));
        end);
    end;

    local u12 = getSnapshot();

    if not u12 then
        return nil;
    end;

    local success, result = pcall(u12.GetValueChangedSignal, u12, u10);

    if success and result then
        return result:Connect(function() -- Line: 57
            -- upvalues: u12 (copy), u10 (copy), u11 (copy)
            local success2, result2 = pcall(u12.GetValue, u12, u10);

            if not success2 then
                result2 = nil;
            end;

            u11(result2);
        end);
    end;

    return nil;
end;

return u2;