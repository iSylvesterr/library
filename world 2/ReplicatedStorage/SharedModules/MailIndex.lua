-- Decompiled with Potassium's decompiler.

local MemoryStoreService = game:GetService("MemoryStoreService");
local RunService = game:GetService("RunService");
local u1 = nil;
local success, result = pcall(function() -- Line: 21
    -- upvalues: MemoryStoreService (copy)
    return MemoryStoreService:GetHashMap("MailIndex_v1");
end);

if success then
    u1 = result;
else
    warn((`[MailIndex] GetHashMap failed; mail index disabled for this server: {result}`));
end;

local function keyFor(p2) -- Line: 32
    return tostring(p2);
end;

local function clampNonNeg(p3) -- Line: 36
    return p3 < 0 and 0 or p3;
end;

local function update(u4, u5) -- Line: 40
    -- upvalues: u1 (ref), RunService (copy)
    if not u1 then
        return false;
    end;

    if RunService:IsStudio() then
        return true;
    end;

    local u6 = os.time();
    local success2, result2 = pcall(function() -- Line: 49
        -- upvalues: u1 (ref), u4 (copy), u5 (copy), u6 (copy)
        u1:UpdateAsync(tostring(u4), function(p7) -- Line: 50
            -- upvalues: u5 (ref), u6 (ref)
            local v8 = p7 or {
                C = 0,
                T = 0,
                V = 0
            };
            local v9 = (v8.C or 0) + u5;
            v8.C = v9 < 0 and 0 or v9;

            if u5 > 0 then
                v8.T = u6;
            end;

            v8.V = (v8.V or 0) + 1;

            return v8;
        end, 1209600);
    end);

    if success2 then
        return true;
    end;

    warn((`[MailIndex] UpdateAsync failed for user {u4} (delta {u5}): {result2}`));

    return false;
end;

return table.freeze({
    Increment = function(p10, p11) -- Line: 70, Name: Increment
        -- upvalues: update (copy)
        if typeof(p10) ~= "number" or p10 <= 0 then
            return false;
        end;

        if typeof(p11) == "number" and p11 > 0 then
            return update(p10, (math.floor(p11)));
        end;

        return false;
    end,

    Decrement = function(p12, p13) -- Line: 76, Name: Decrement
        -- upvalues: update (copy)
        if typeof(p12) ~= "number" or p12 <= 0 then
            return false;
        end;

        if typeof(p13) == "number" and p13 > 0 then
            return update(p12, -math.floor(p13));
        end;

        return false;
    end,

    Get = function(u14) -- Line: 82, Name: Get
        -- upvalues: u1 (ref), RunService (copy)
        if not u1 then
            return nil;
        end;

        if typeof(u14) ~= "number" or u14 <= 0 then
            return nil;
        end;

        if RunService:IsStudio() then
            return nil;
        end;

        local u15 = nil;
        local success2, result2 = pcall(function() -- Line: 88
            -- upvalues: u15 (ref), u1 (ref), u14 (copy)
            u15 = u1:GetAsync((tostring(u14)));
        end);

        if success2 then
            return u15;
        end;

        warn((`[MailIndex] GetAsync failed for user {u14}: {result2}`));

        return nil;
    end
});