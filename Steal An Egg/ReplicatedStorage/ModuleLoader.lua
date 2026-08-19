-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local KeyToString = require(ReplicatedStorage.Library.Functions.KeyToString);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);

return function(p1, u2, p3) -- Line: 21
    -- upvalues: Asserts (copy), Constants (copy), KeyToString (copy), MakeTableStrict (copy)
    Asserts.Instance(p1);
    Asserts.table(u2);
    Asserts.optional.table(p3);
    local u4 = p3 or {};
    local v5 = u4.rootName or "script";
    local u6 = u4.typeCast and (("::%s"):format(u4.typeCast) or "") or "";
    local u7 = u4.warn or warn;
    local u8 = {};
    local u9 = {};

    local function injectMetadata(p10, p11, p12) -- Line: 35
        -- upvalues: u4 (copy)
        if u4.shouldInject and type(p12) == "table" then
            if p12._id == nil then
                p12._id = p11;
            end;

            if p12._script == nil then
                p12._script = p10;
            end;
        end;
    end;

    local function loadModule(p13, p14) -- Line: 46
        -- upvalues: loadModule (copy), u4 (copy), u7 (copy), u8 (copy), Constants (ref), u2 (copy), u9 (copy), KeyToString (ref), u6 (copy)
        if p13:GetAttribute("NOLOAD") then
            return;
        end;

        if p13:IsA("Folder") then
            for _, child in ipairs(p13:GetChildren()) do
                loadModule(child, ("%s:WaitForChild(\"%s\")"):format(p14, p13.Name));
            end;

            return;
        end;

        if p13:IsA("ModuleScript") then
            local v15 = p13.Name:gsub("^(.-)%s*|%s*", "");
            local v16;

            if u4.keyParser then
                v16 = u4.keyParser(v15);

                if not v16 then
                    u7(("Invalid key: %s"):format(v15));

                    return;
                end;
            else
                v16 = v15;
            end;

            if u8[v16] then
                u7(("Duplicate entry: %s"):format(v16));
            else
                u8[v16] = true;
                local v17 = os.clock();
                local v18 = require(p13);
                local v19 = (os.clock() - v17) * 1000;
                local v20 = math.ceil(v19);

                if u4.verifier then
                    u4.verifier(v18, v16);
                end;

                if v20 >= 25 and Constants.IS_STUDIO then
                    u7("[SlowModule]", p13.Name, ("%dms"):format(v20));
                end;

                if u4.shouldInject and type(v18) == "table" then
                    if v18._id == nil then
                        v18._id = v16;
                    end;

                    if v18._script == nil then
                        v18._script = p13;
                    end;
                end;

                if not u2[v16] then
                    if not u4.noPrint then
                        local v21 = KeyToString(v16);
                        table.insert(u9, ("[%s] = require(%s:WaitForChild(\"%s\"))%s"):format(v21, p14, p13.Name, u6));
                    end;

                    u2[v16] = v18;

                    return;
                end;

                if u2[v16] ~= v18 then
                    u7(("Mismatched entry: %s"):format(v16));
                end;
            end;
        end;
    end;

    for _, child in ipairs(p1:GetChildren()) do
        if u4.loadAsync then
            task.spawn(loadModule, child, v5);
        else
            loadModule(child, v5);
        end;
    end;

    if #u9 > 0 and not u4.noPrint then
        table.sort(u9);
        u7(("Unadded entries: \n\n%s\n"):format(table.concat(u9, ",\n") .. ",\n"));
    end;

    for i in pairs(u2) do
        if not u8[i] then
            u7(("Unknown entry: %s"):format(i));
        end;
    end;

    if u4.addStrictMetatable then
        MakeTableStrict(u2, v5);
    end;

    return u2;
end;