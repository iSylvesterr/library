-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local logWarn = require(Parent.Logging.logWarn);
local Observer = require(Parent.State.Observer);
local xtypeof = require(Parent.Utility.xtypeof);

return {
    type = "SpecialKey",
    kind = "Children",
    stage = "descendants",

    apply = function(p1, u2, u3, p4) -- Line: 24, Name: apply
        -- upvalues: xtypeof (copy), Observer (copy), logWarn (copy)
        local u5 = {};
        local u6 = {};
        local u7 = {};
        local u8 = {};
        local u9 = false;
        local u10 = nil;

        local function updateChildren() -- Line: 38
            -- upvalues: u9 (ref), u6 (ref), u5 (ref), u8 (ref), u7 (ref), xtypeof (ref), u3 (copy), Observer (ref), u10 (ref), logWarn (ref), u2 (ref)
            if not u9 then
                return;
            end;

            u9 = false;
            local v11 = u6;
            u6 = u5;
            u5 = v11;
            local v12 = u8;
            u8 = u7;
            u7 = v12;
            table.clear(u5);
            table.clear(u7);

            local function processChild(p13, p14) -- Line: 49
                -- upvalues: xtypeof (ref), u5 (ref), u6 (ref), u3 (ref), processChild (copy), u8 (ref), Observer (ref), u10 (ref), u7 (ref), logWarn (ref)
                local v15 = xtypeof(p13);

                if v15 == "Instance" then
                    u5[p13] = true;

                    if u6[p13] == nil then
                        p13.Parent = u3;

                        return;
                    end;

                    u6[p13] = nil;

                    return;
                end;

                if v15 ~= "State" then
                    if v15 == "table" then
                        for i, v in pairs(p13) do
                            local v16 = typeof(i);
                            local v17 = nil;

                            if v16 == "string" then
                                v17 = i;
                            elseif v16 == "number" and p14 ~= nil then
                                v17 = p14 .. "_" .. i;
                            end;

                            processChild(v, v17);
                        end;

                        return;
                    end;

                    logWarn("unrecognisedChildType", v15);

                    return;
                end;

                local v18 = p13:get(false);

                if v18 ~= nil then
                    processChild(v18, p14);
                end;

                local v19 = u8[p13];

                if v19 == nil then
                    v19 = Observer(p13):onChange(u10);
                else
                    u8[p13] = nil;
                end;

                u7[p13] = v19;
            end;

            if u2 ~= nil then
                processChild(u2);
            end;

            for i in pairs(u6) do
                i.Parent = nil;
            end;

            for _, v in pairs(u8) do
                v();
            end;
        end;

        u10 = function() -- Line: 130
            -- upvalues: u9 (ref), updateChildren (copy)
            if not u9 then
                u9 = true;
                task.defer(updateChildren);
            end;
        end;

        table.insert(p4, function() -- Line: 137
            -- upvalues: u2 (ref), u9 (ref), updateChildren (copy)
            u2 = nil;
            u9 = true;
            updateChildren();
        end);
        u9 = true;
        updateChildren();
    end
};