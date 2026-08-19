-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local u1 = game:GetService("RunService"):IsServer() and "server" or "client";
local v2 = {};
local u3 = {
    __index = v2
};

function v2.write(p4, p5) -- Line: 16
    -- upvalues: u1 (copy), HttpService (copy)
    assert(u1 == "server", "cannot write to replicatdvalue on client");
    p4._luauData = p5;
    p4._value.Value = HttpService:JSONEncode(p5);
end;

function v2.read(p6) -- Line: 25
    return p6._luauData;
end;

return function(p7) -- Line: 29
    -- upvalues: u3 (copy), u1 (copy), HttpService (copy)
    local u8 = setmetatable({}, u3);
    u8._luauData = {};
    u8._value = p7;

    if u1 == "client" then
        u8._luauData = table.freeze(HttpService:JSONDecode(p7.Value));
        p7.Changed:Connect(function(p9) -- Line: 40
            -- upvalues: u8 (copy), HttpService (ref)
            if not p9 then
                return;
            end;

            u8._luauData = table.freeze(HttpService:JSONDecode(p9));
        end);
    end;

    return u8;
end;