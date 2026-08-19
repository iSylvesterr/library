-- Decompiled with Potassium's decompiler.

local v1 = {};
local Parent = script.Parent.Parent;
local Modules = Parent.Parent.Modules;
local States = Parent.States;
local Trove = require(Modules.Trove);
require(Modules.Types);
local Symbol = require(Modules.Symbol);
local CreateDeepTraceback = require(Modules.CreateDeepTraceback);
require(States.Computed);
require(States.Rendered);
require(States.Value);
require(States.Animation.Spring);
require(States.Animation.Tween);
require(States.ForPairs);
local Scope = Symbol.new("Scope");
local u2 = setmetatable({}, v1);

function v1.__call(p3, p4) -- Line: 47
    -- upvalues: Symbol (copy), CreateDeepTraceback (copy), u2 (copy), Trove (copy)
    local v5 = {};
    local v6 = {};
    local Scope2 = Symbol.new("Scope");
    local u7 = table.clone(p4 or {});

    function v6.__index(u8, u9) -- Line: 60
        -- upvalues: CreateDeepTraceback (ref), Scope2 (copy), u7 (ref)
        if u9 then
            if u9 == "__SEAM_OBJECT" then
                return Scope2;
            end;

            local u10 = u7[u9];

            if u10 == nil then
                warn((`Attempt to index a scope with {u9} when it does not exist in scope\n{CreateDeepTraceback()}`));

                return nil;
            end;

            if typeof(u10) ~= "function" and (typeof(u10) ~= "table" or not u10.__SEAM_CAN_BE_SCOPED) then
                if u10.__SEAM_OBJECT or u10.__SEAM_INDEX then
                    error(tostring(u10.__SEAM_OBJECT or u10.__SEAM_INDEX) .. " is not a valid scopable Seam object");
                else
                    error("Object is not a valid scopable Seam object");
                end;
            end;

            return function(p11, ...) -- Line: 90
                -- upvalues: u8 (copy), u9 (copy), CreateDeepTraceback (ref), u10 (copy)
                if not u8.Trove then
                    warn((`Attempted to use something in scope ({u9}) but scope is already destroyed: {CreateDeepTraceback()}`));

                    return;
                end;

                local v12;

                if typeof(u10) == "function" then
                    v12 = { u10(u8, ...) };
                elseif u10.__SEAM_OBJECT and tostring(u10.__SEAM_OBJECT) == "New" then
                    local v13 = { ... };
                    table.insert(v13, u8);
                    v12 = { u10(unpack(v13)) };
                else
                    v12 = { u10(...) };
                end;

                if #v12 ~= 0 then
                    for _, v in v12 do
                        u8.Trove:Add(v);
                    end;

                    return unpack(v12);
                end;
            end;
        end;

        warn((`Attempt to index a scope with nil\n{CreateDeepTraceback()}`));
    end;

    function v5.InnerScope(p14, p15) -- Line: 130
        -- upvalues: u2 (ref)
        local v16 = p15 == nil and {} or p15;

        for i, v in p14.ScopedObjects do
            v16[i] = v;
        end;

        local v17 = u2(v16);
        p14.Trove:Add(v17);

        return v17;
    end;

    function v5.AddObject(p18, p19) -- Line: 147
        p18.Trove:Add(p19);
    end;

    function v5.RemoveObject(p20, p21) -- Line: 151
        p21:Destroy();
        p20.Trove[p21] = nil;
    end;

    function v5.Destroy(p22) -- Line: 156
        p22.Trove:Destroy();
        p22.Trove = nil;
    end;

    local v23 = setmetatable(v5, v6);
    v23.ScopedObjects = u7;
    v23.Trove = Trove.new();

    return v23;
end;

function v1.__index(p24, p25) -- Line: 168
    -- upvalues: Scope (copy)
    if p25 == "__SEAM_OBJECT" then
        return Scope;
    end;

    return p25 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return u2;