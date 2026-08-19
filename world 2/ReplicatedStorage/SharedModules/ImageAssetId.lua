-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ImageDenylist = require(ReplicatedStorage.SharedModules.ImageDenylist);
local u5 = {
    Parse = function(p1) -- Line: 41, Name: Parse
        if type(p1) ~= "string" then
            return nil;
        end;

        local v2 = string.gsub(p1, "^%s*(.-)%s*$", "%1");

        if v2 == "" then
            return nil;
        end;

        local v3 = string.match(v2, "^(%d+)$") or string.match(v2, "rbxassetid://(%d+)") or (string.match(v2, "rbxthumb://.-id=(%d+)") or string.match(v2, "[?&]id=(%d+)") or (string.match(v2, "id=(%d+)") or string.match(v2, "/(%d+)")));

        if not v3 then
            return nil;
        end;

        local v4 = tonumber(v3);

        if type(v4) == "number" and (v4 == v4 and (v4 > 0 and v4 <= 9007199254740992)) then
            return v4;
        end;

        return nil;
    end
};

function u5.ResolveForDisplay(p6) -- Line: 76
    -- upvalues: u5 (copy), ImageDenylist (copy)
    local v7 = u5.Parse(p6);

    return not v7 and "" or (ImageDenylist.IsDenylisted(v7) and "" or `rbxthumb://type=Asset&id={v7}&w={420}&h={420}`);
end;

return table.freeze(u5);