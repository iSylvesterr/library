-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
local Symbol = require(Modules.Symbol);
local Trove = require(Modules.Trove);
local UpdateSignals = require(Modules.UpdateSignals);
local EventSequence = Symbol.new("EventSequence");

function v1.__call(p2, u3) -- Line: 28
    -- upvalues: Trove (copy), UpdateSignals (copy)
    local u4 = {};
    local u5 = nil;
    local u6 = false;
    local u7 = 0;
    local u8 = {};

    for i, v in u3 do
        if typeof(i) ~= "number" then
            error("Attmped to pass dictionary for sequence keyframes");
        end;

        if typeof(v[1]) ~= "number" then
            error("EventSequenceKeypoint needs a time");
        end;

        if typeof(v[2]) ~= "function" then
            error("EventSequenceKeypoint needs callback");
        end;
    end;

    u4.Looped = false;
    u4.LoopDelayTime = 0;

    function u4.Play() -- Line: 52
        -- upvalues: u5 (ref), u4 (copy), u6 (ref), Trove (ref), UpdateSignals (ref), u7 (ref), u3 (copy), u8 (ref)
        if u5 then
            u4.Stop();
        end;

        u6 = false;
        u5 = Trove.new();
        u5:Add(UpdateSignals.OnFrameUpdate:Connect(function(p9) -- Line: 60
            -- upvalues: u6 (ref), u7 (ref), u3 (ref), u8 (ref), u4 (ref), u5 (ref)
            if u6 then
                return;
            end;

            u7 = u7 + p9;

            for i, v in u3 do
                if not u8[i] and u7 >= v[1] then
                    u8[i] = true;
                    task.spawn(v[2]);
                end;
            end;

            if #u3 == #u8 then
                if u4.Looped then
                    u7 = -u4.LoopDelayTime;
                    table.clear(u8);

                    return;
                end;

                u5:Destroy();
            end;
        end));
        u5:Add(function() -- Line: 88
            -- upvalues: u7 (ref), u5 (ref), u6 (ref), u8 (ref)
            u7 = 0;
            u5 = nil;
            u6 = false;
            u8 = {};
        end);
    end;

    function u4.Stop() -- Line: 96
        -- upvalues: u5 (ref)
        if not u5 then
            return;
        end;

        u5:Destroy();
    end;

    function u4.Pause() -- Line: 104
        -- upvalues: u5 (ref), u6 (ref)
        if not u5 then
            return;
        end;

        u6 = true;
    end;

    function u4.Resume() -- Line: 112
        -- upvalues: u5 (ref), u6 (ref)
        if not u5 then
            return;
        end;

        u6 = false;
    end;

    return u4;
end;

function v1.__index(p10, p11) -- Line: 123
    -- upvalues: EventSequence (copy)
    if p11 == "__SEAM_OBJECT" then
        return EventSequence;
    end;

    return p11 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);