-- Decompiled with Potassium's decompiler.

require(script.Types);
local u1 = {
    Effects = {},
    ActiveEffects = {}
};

function u1.Activate(p2, p3) -- Line: 8
    -- upvalues: u1 (copy)
    local v4 = u1.Effects[p3];

    if not v4 then
        return false;
    end;

    if type(v4.Activate) == "function" then
        v4:Activate();
    end;

    return true;
end;

function u1.Run(p5, p6, p7) -- Line: 19
    -- upvalues: u1 (copy)
    local v8 = u1.Effects[p7];

    if not v8 then
        return false;
    end;

    if not u1.ActiveEffects[p7] then
        u1.ActiveEffects[p7] = {};
    end;

    local v9 = table.clone(u1.ActiveEffects[p7]);
    u1.ActiveEffects[p7][p6] = true;

    if next(v9) then
        return false;
    end;

    if type(v8.OnStart) == "function" then
        v8:OnStart();
    end;

    return true;
end;

function u1.Stop(p10, p11, p12) -- Line: 38
    -- upvalues: u1 (copy)
    local v13 = u1.Effects[p12];

    if not v13 then
        return false;
    end;

    if not u1.ActiveEffects[p12] then
        return false;
    end;

    if not next(u1.ActiveEffects[p12]) then
        return false;
    end;

    u1.ActiveEffects[p12][p11] = nil;

    if next(u1.ActiveEffects[p12]) then
        return false;
    end;

    u1.ActiveEffects[p12] = nil;

    if type(v13.OnStop) == "function" then
        v13:OnStop();
    end;

    return true;
end;

function u1.Load() -- Line: 60
    -- upvalues: u1 (copy)
    for _, child in script.Effects:GetChildren() do
        if child:IsA("ModuleScript") then
            local v14, v15 = coroutine.resume(coroutine.create(require), child);

            if v14 and type(v15) == "table" then
                if type(v15.OnLoad) == "function" then
                    local v16, v17 = coroutine.resume(coroutine.create(v15.OnLoad), v15);

                    if v16 then
                        u1.Effects[child.Name] = v15;
                    else
                        warn(("Effect %s failed to call Load function:\n%s"):format(child:GetFullName(), v17 == nil and "yielded (possibly)" or v17));
                    end;
                else
                    u1.Effects[child.Name] = v15;
                end;
            else
                warn(("Effect %s failed to load:\n%s"):format(child:GetFullName(), v15 == nil and "yielded (possibly)" or v15));
            end;
        end;
    end;
end;

function u1.Start() -- Line: 90
end;

return u1;