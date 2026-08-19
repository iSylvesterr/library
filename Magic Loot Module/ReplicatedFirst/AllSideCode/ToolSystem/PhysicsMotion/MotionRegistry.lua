-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};

local function _genAttrName(p3) -- Line: 22
    return "PhysicsMotionGen_" .. p3;
end;

local function _bumpGen(p4, p5) -- Line: 33
    local v6 = "PhysicsMotionGen_" .. p5;
    local v7 = (tonumber(p4:GetAttribute(v6)) or 0) + 1;
    p4:SetAttribute(v6, v7);

    return v7;
end;

function u1.getGen(p8, p9) -- Line: 47
    return tonumber(p8:GetAttribute("PhysicsMotionGen_" .. p9)) or 0;
end;

function u1.begin(p10, p11, p12) -- Line: 59
    -- upvalues: u2 (copy)
    local v13 = u2[p10];

    if not v13 then
        v13 = {};
        u2[p10] = v13;
    end;

    local v14 = v13[p11];

    if v14 and (p12 and v14.cancel) then
        v14.cancel();
    end;

    local v15 = "PhysicsMotionGen_" .. p11;
    local v16 = (tonumber(p10:GetAttribute(v15)) or 0) + 1;
    p10:SetAttribute(v15, v16);
    v13[p11] = {
        gen = v16,

        cancel = function() -- Line: 74, Name: cancel
        end
    };

    return v16;
end;

function u1.setCancel(p17, p18, p19) -- Line: 86
    -- upvalues: u2 (copy)
    local v20 = u2[p17];

    if v20 and v20[p18] then
        v20[p18].cancel = p19;
    end;
end;

function u1.register(p21, p22, p23, p24) -- Line: 102
    -- upvalues: u1 (copy)
    local v25 = u1.begin(p21, p22, p23);
    u1.setCancel(p21, p22, p24);

    return v25;
end;

function u1.cancel(p26, p27) -- Line: 114
    -- upvalues: u2 (copy)
    local v28 = u2[p26];

    if not v28 then
        return;
    end;

    if not p27 then
        for i, v in pairs(v28) do
            if v and v.cancel then
                v.cancel();
            end;

            v28[i] = nil;
        end;

        u2[p26] = nil;

        return;
    end;

    local v29 = v28[p27];

    if v29 and v29.cancel then
        v29.cancel();
    end;

    v28[p27] = nil;
end;

function u1.isActive(p30, p31) -- Line: 143
    -- upvalues: u2 (copy)
    local v32 = u2[p30];
    local v33;

    if v32 == nil then
        v33 = false;
    else
        v33 = v32[p31] ~= nil;
    end;

    return v33;
end;

function u1.isGenCurrent(p34, p35, p36) -- Line: 156
    -- upvalues: u1 (copy)
    return u1.getGen(p34, p35) == p36;
end;

function u1.release(p37, p38, p39) -- Line: 167
    -- upvalues: u1 (copy), u2 (copy)
    if not u1.isGenCurrent(p37, p38, p39) then
        return;
    end;

    local v40 = u2[p37];

    if v40 then
        v40[p38] = nil;

        if next(v40) == nil then
            u2[p37] = nil;
        end;
    end;
end;

return u1;