-- Decompiled with Potassium's decompiler.

local GetPromiseLibrary = require(script.GetPromiseLibrary);
local RbxScriptConnection = require(script.RbxScriptConnection);
local Symbol = require(script.Symbol);
local u1, u2 = GetPromiseLibrary();
local u3 = Symbol("IndicesReference");
local u4 = Symbol("LinkToInstanceIndex");
local u5 = {
    ClassName = "Janitor",
    CurrentlyCleaning = true,
    [u3] = nil
};
u5.__index = u5;
local u6 = {
    ["function"] = true,
    thread = true,
    RBXScriptConnection = "Disconnect"
};

function u5.new() -- Line: 53
    -- upvalues: u3 (copy), u5 (copy)
    return setmetatable({
        CurrentlyCleaning = false,
        [u3] = nil
    }, u5);
end;

function u5.Is(p7) -- Line: 66
    -- upvalues: u5 (copy)
    local v8;

    if type(p7) == "table" then
        v8 = getmetatable(p7) == u5;
    else
        v8 = false;
    end;

    return v8;
end;

function u5.Add(p9, p10, p11, p12) -- Line: 150
    -- upvalues: u3 (copy), u6 (copy)
    if p12 then
        p9:Remove(p12);
        local v13 = p9[u3];

        if not v13 then
            v13 = {};
            p9[u3] = v13;
        end;

        v13[p12] = p10;
    end;

    local v14 = typeof(p10);
    local v15 = p11 or (u6[v14] or "Destroy");

    if v14 == "function" or v14 == "thread" then
        if v15 ~= true then
            warn(string.format("Object is a %s and as such expected `true?` for the method name and instead got %s. Traceback: %s", v14, tostring(v15), debug.traceback(nil, 2)));
        end;
    elseif not p10[v15] then
        warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p10), tostring(v15), debug.traceback(nil, 2)));
    end;

    p9[p10] = v15;

    return p10;
end;

function u5.AddPromise(p16, u17) -- Line: 206
    -- upvalues: u1 (copy), u2 (copy)
    if not u1 then
        return u17;
    end;

    if not u2.is(u17) then
        error(string.format("Invalid argument #1 to \'Janitor:AddPromise\' (Promise expected, got %s (%s)) Traceback: %s", typeof(u17), tostring(u17), debug.traceback(nil, 2)));
    end;

    if u17:getStatus() ~= u2.Status.Started then
        return u17;
    end;

    local v18 = newproxy(false);
    local v22 = p16:Add(u2.new(function(p19, p20, p21) -- Line: 214
        -- upvalues: u17 (copy)
        if p21(function() -- Line: 215
            -- upvalues: u17 (ref)
            u17:cancel();
        end) then
            return;
        end;

        p19(u17);
    end), "cancel", v18);
    v22:finallyCall(p16.Remove, p16, v18);

    return v22;
end;

function u5.Remove(p23, p24) -- Line: 259
    -- upvalues: u3 (copy)
    local v25 = p23[u3];
    local v26 = v25 and v25[p24];

    if v26 then
        local v27 = p23[v26];

        if v27 then
            if v27 == true then
                if type(v26) == "function" then
                    v26();
                else
                    task.cancel(v26);
                end;
            else
                local v28 = v26[v27];

                if v28 then
                    v28(v26);
                end;
            end;

            p23[v26] = nil;
        end;

        v25[p24] = nil;
    end;

    return p23;
end;

function u5.RemoveList(p29, ...) -- Line: 333
    -- upvalues: u3 (copy)
    local v30 = p29[u3];

    if v30 then
        local v31 = select("#", ...);

        if v31 == 1 then
            return p29:Remove(...);
        end;

        for i = 1, v31 do
            local v32 = v30[select(i, ...)];

            if v32 then
                local v33 = p29[v32];

                if v33 then
                    if v33 == true then
                        if type(v32) == "function" then
                            v32();
                        else
                            task.cancel(v32);
                        end;
                    else
                        local v34 = v32[v33];

                        if v34 then
                            v34(v32);
                        end;
                    end;

                    p29[v32] = nil;
                end;

                v30[i] = nil;
            end;
        end;
    end;

    return p29;
end;

function u5.Get(p35, p36) -- Line: 397
    -- upvalues: u3 (copy)
    local v37 = p35[u3];

    if v37 then
        return v37[p36];
    end;

    return nil;
end;

local function GetFenv(u38) -- Line: 402
    -- upvalues: u3 (copy)
    return function() -- Line: 403
        -- upvalues: u38 (copy), u3 (ref)
        for i, v in next, u38 do
            if i ~= u3 then
                return i, v;
            end;
        end;
    end;
end;

function u5.Cleanup(u39) -- Line: 429
    -- upvalues: u3 (copy)
    if not u39.CurrentlyCleaning then
        u39.CurrentlyCleaning = nil;

        local function v40() -- Line: 403
            -- upvalues: u39 (copy), u3 (ref)
            for i, v in next, u39 do
                if i ~= u3 then
                    return i, v;
                end;
            end;
        end;

        local v41, v42 = v40();

        while v41 and v42 do
            if v42 == true then
                if type(v41) == "function" then
                    v41();
                else
                    task.cancel(v41);
                end;
            else
                local v43 = v41[v42];

                if v43 then
                    v43(v41);
                end;
            end;

            u39[v41] = nil;
            v41, v42 = v40();
        end;

        local v44 = u39[u3];

        if v44 then
            table.clear(v44);
            u39[u3] = {};
        end;

        u39.CurrentlyCleaning = false;
    end;
end;

function u5.Destroy(p45) -- Line: 471
    p45:Cleanup();
    table.clear(p45);
    setmetatable(p45, nil);
end;

u5.__call = u5.Cleanup;

function u5.LinkToInstance(u46, p47, p48) -- Line: 520
    -- upvalues: u4 (copy)
    local v49 = p48 and newproxy(false) or u4;

    return u46:Add(p47.Destroying:Connect(function() -- Line: 523
        -- upvalues: u46 (copy)
        u46:Cleanup();
    end), "Disconnect", v49);
end;

function u5.LegacyLinkToInstance(u50, p51, p52) -- Line: 573
    -- upvalues: u4 (copy), RbxScriptConnection (copy)
    local u53 = nil;
    local v54 = p52 and newproxy(false) or u4;
    local u55 = p51.Parent == nil;
    local u56 = setmetatable({}, RbxScriptConnection);
    u53 = p51.AncestryChanged:Connect(function(p57, p58) -- Line: 579, Name: ChangedFunction
        -- upvalues: u56 (copy), u55 (ref), u53 (ref), u50 (copy)
        u55 = u56.Connected and p58 == nil;

        if u55 then
            task.defer(function() -- Line: 585
                -- upvalues: u56 (ref), u53 (ref), u50 (ref), u55 (ref)
                if not u56.Connected then
                    return;
                end;

                if not u53.Connected then
                    u50:Cleanup();

                    return;
                end;

                while u55 and (u53.Connected and u56.Connected) do
                    task.wait();
                end;

                if u56.Connected and u55 then
                    u50:Cleanup();
                end;
            end);
        end;
    end);
    u56.Connection = u53;

    if u55 then
        local Parent = p51.Parent;

        if u56.Connected then
            if Parent == nil then
                u55 = true;
            else
                u55 = false;
            end;

            if u55 then
                task.defer(function() -- Line: 585
                    -- upvalues: u56 (copy), u53 (ref), u50 (copy), u55 (ref)
                    if not u56.Connected then
                        return;
                    end;

                    if not u53.Connected then
                        u50:Cleanup();

                        return;
                    end;

                    while u55 and (u53.Connected and u56.Connected) do
                        task.wait();
                    end;

                    if u56.Connected and u55 then
                        u50:Cleanup();
                    end;
                end);
            end;
        end;
    end;

    return u50:Add(u56, "Disconnect", v54);
end;

function u5.LinkToInstances(p59, ...) -- Line: 621
    -- upvalues: u5 (copy)
    local v60 = u5.new();

    for _, v in ipairs({ ... }) do
        v60:Add(p59:LinkToInstance(v, true), "Disconnect");
    end;

    return v60;
end;

function u5.__tostring(p61) -- Line: 630
    return "Janitor";
end;

table.freeze(u5);

return u5;