-- Decompiled with Potassium's decompiler.

local function FullNameToPath(p1) -- Line: 3
    return p1:GetFullName():gsub("%.", "/");
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u17 = {
    Find = function(p2, p3, p4) -- Line: 35, Name: Find
        local v5 = p2;

        for _, v in p3:split("/") do
            if v == "" then
                error(`Invalid path: {p3}`, 2);
            end;

            p2 = p2:FindFirstChild(v);

            if p2 == nil then
                error(`Failed to find {p3} in {v5:GetFullName():gsub("%.", "/")}`, 2);
            end;
        end;

        if p4 and not p2:IsA(p4) then
            error(`Got class {p2.ClassName}; expected to be of type {p4}`, 2);
        end;

        return p2;
    end,

    Exists = function(p6, p7, p8) -- Line: 75, Name: Exists
        for _, v in p7:split("/") do
            if v == "" then
                error(`Invalid path: {p7}`, 2);
            end;

            p6 = p6:FindFirstChild(v);

            if p6 == nil then
                return false;
            end;
        end;

        return (not p8 or p6:IsA(p8)) and true or false;
    end,

    Get = function(p9, p10, p11) -- Line: 110, Name: Get
        for _, v in ipairs(p10:split("/")) do
            if v == "" then
                error(`Invalid path: {p10}`, 2);
            end;

            p9 = p9:FindFirstChild(v);

            if not p9 then
                return nil;
            end;
        end;

        if p11 and not p9:IsA(p11) then
            return nil;
        end;

        return p9;
    end,

    Await = function(p12, p13, p14, p15) -- Line: 149, Name: Await
        local v16 = p12;

        for _, v in p13:split("/") do
            if v == "" then
                error(`Invalid path: {p13}`, 2);
            end;

            p12 = p12:WaitForChild(v, p14);

            if p12 == nil then
                error(`Failed to await {p13} in {v16:GetFullName():gsub("%.", "/")} (timeout reached)`, 2);
            end;
        end;

        if p15 and not p12:IsA(p15) then
            error(`Got class {p12.ClassName}; expected to be of type {p15}`, 2);
        end;

        return p12;
    end
};

function u17.AwaitWithDefaultTimeout(p18, p19, p20, p21) -- Line: 178
    -- upvalues: u17 (copy), Constants (copy)
    return u17.Await(p18, p19, p20 or Constants.STUDIO_YIELD_TIMEOUT, p21);
end;

return u17;