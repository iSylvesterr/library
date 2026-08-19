-- Decompiled with Potassium's decompiler.

local ReflectionService = game:GetService("ReflectionService");
local v1 = {};
local u2 = {};
local u3 = {
    Parent = true,
    ClassName = true,
    Name = true,
    ExtentsCFrame = true,
    ExtentsSize = true,
    ResizeIncrement = true,
    ResizeableFaces = true,
    CurrentPhysicalProperties = true,
    Sandboxed = true,
    Capabilities = true,
    PrivateServerId = true,
    PrivateServerOwnerId = true,
    SerializedDefaultAttributes = true
};
local u4 = {
    Debug = true
};
local success, result = pcall(function() -- Line: 44
    return tostring(SecurityCapabilities.fromCurrent()):split(" | ");
end);
local u5 = not success and {} or result;

local function canRead(p6) -- Line: 50
    -- upvalues: u5 (ref)
    if not p6 then
        return true;
    end;

    local v7 = tostring(p6):split(" | ");

    if v7[1] == nil or v7[1] == "" then
        return true;
    end;

    for _, v in v7 do
        if not table.find(u5, v) then
            return false;
        end;
    end;

    return true;
end;

function v1.getReadProperties(u8) -- Line: 66
    -- upvalues: u2 (copy), ReflectionService (copy), u3 (copy), u4 (copy), canRead (copy)
    local v9 = u2[u8];

    if v9 then
        return v9;
    end;

    local v10 = {};
    local success2, result2 = pcall(function() -- Line: 73
        -- upvalues: ReflectionService (ref), u8 (copy)
        return ReflectionService:GetPropertiesOfClass(u8);
    end);

    if success2 and result2 then
        for _, v in result2 do
            local Name = v.Name;

            if not u3[Name] then
                local Display = v.Display;

                if not Display or (not Display.DeprecationMessage or Display.DeprecationMessage == "") and not (Display.Category and u4[Display.Category]) then
                    local Type = v.Type;

                    if not Type or Type.ScriptType ~= "Instance" then
                        local Permits = v.Permits;

                        if Permits then
                            Permits = Permits.Read;
                        end;

                        if canRead(Permits) then
                            table.insert(v10, Name);
                        end;
                    end;
                end;
            end;
        end;
    end;

    u2[u8] = v10;

    return v10;
end;

return v1;