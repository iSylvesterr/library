-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local v1 = {};
local u2 = nil;
local u3 = false;

local function _ensureRegistered() -- Line: 30
    -- upvalues: u3 (ref), NetWork (copy), NetMsg (copy), u2 (ref)
    if u3 then
        return;
    end;

    u3 = true;
    NetWork.RegisterBindableEvent(NetMsg.UPDATE_CHARACTER_SPEED, function(p4, p5, p6) -- Line: 35
        -- upvalues: u2 (ref)
        if u2 then
            u2(p4, p5, p6);
        end;
    end);
end;

function v1.setHandler(p7) -- Line: 51
    -- upvalues: u3 (ref), NetWork (copy), NetMsg (copy), u2 (ref)
    if not u3 then
        u3 = true;
        NetWork.RegisterBindableEvent(NetMsg.UPDATE_CHARACTER_SPEED, function(p8, p9, p10) -- Line: 35
            -- upvalues: u2 (ref)
            if u2 then
                u2(p8, p9, p10);
            end;
        end);
    end;

    u2 = p7;
end;

function v1.clearHandler(p11) -- Line: 61
    -- upvalues: u2 (ref)
    if u2 == p11 then
        u2 = nil;
    end;
end;

return v1;