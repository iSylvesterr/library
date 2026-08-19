-- Decompiled with Potassium's decompiler.

local u1 = {};

local function onCall(p2, ...) -- Line: 3
    p2:track(...);
end;

function u1.new() -- Line: 7
    -- upvalues: u1 (copy), onCall (copy)
    return setmetatable({
        objects = {}
    }, {
        __index = u1,
        __call = onCall
    });
end;

function u1.track(p3, ...) -- Line: 15
    for _, v in ipairs({ ... }) do
        table.insert(p3.objects, v);
    end;
end;

function u1.destroy(p4) -- Line: 21
    local objects = p4.objects;
    p4.objects = {};

    for _, v in ipairs(objects) do
        local success, result = pcall(function() -- Line: 25
            -- upvalues: v (copy)
            if typeof(v) == "Instance" then
                if v:IsA("AnimationTrack") then
                    v:Stop();
                end;

                v:Destroy();

                return;
            end;

            if typeof(v) == "RBXScriptConnection" then
                v:Disconnect();

                return;
            end;

            if type(v) == "function" then
                v();
            end;
        end);

        if not success then
            warn(string.format("[Tracker] Destruction failed for type \'%s\': %s", typeof(v), (tostring(result))));
        end;
    end;

    return true;
end;

return function() -- Line: 44
    -- upvalues: u1 (copy)
    return u1.new();
end;