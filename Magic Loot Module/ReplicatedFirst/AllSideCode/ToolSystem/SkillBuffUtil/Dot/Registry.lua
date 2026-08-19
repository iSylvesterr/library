-- Decompiled with Potassium's decompiler.

local Presentation = require(script.Parent.Presentation);
local u1 = {};
local u19 = {
    genKey = function(p2) -- Line: 46, Name: genKey
        return "SkillDotGen_" .. p2;
    end,

    getEntries = function() -- Line: 51, Name: getEntries
        -- upvalues: u1 (copy)
        return u1;
    end,

    bumpGen = function(p3, p4) -- Line: 56, Name: bumpGen
        local v5 = p3:GetAttribute(p4);
        local v6 = (type(v5) == "number" and v5 and v5 or 0) + 1;
        p3:SetAttribute(p4, v6);

        return v6;
    end,

    removeEntries = function(p7, p8, p9) -- Line: 64, Name: removeEntries
        -- upvalues: u1 (copy)
        for i = #u1, 1, -1 do
            local v10 = u1[i];

            if v10.defender == p7 and v10.genKey == p8 then
                if p9 == nil then
                    table.remove(u1, i);
                elseif p9 == true and v10.isEnvHazard == true then
                    table.remove(u1, i);
                elseif p9 == false and v10.isEnvHazard ~= true then
                    table.remove(u1, i);
                end;
            end;
        end;
    end,

    findEntry = function(p11, p12, p13) -- Line: 80, Name: findEntry
        -- upvalues: u1 (copy)
        for i = 1, #u1 do
            local v14 = u1[i];

            if v14.defender == p11 and v14.genKey == p12 then
                if p13 == nil then
                    return v14;
                end;

                if p13 == true and v14.isEnvHazard == true then
                    return v14;
                end;

                if p13 == false and v14.isEnvHazard ~= true then
                    return v14;
                end;
            end;
        end;

        return nil;
    end,

    getUniqueEnvEntry = function(p15, p16) -- Line: 99, Name: getUniqueEnvEntry
        -- upvalues: u1 (copy)
        local v17 = nil;

        for i = #u1, 1, -1 do
            local v18 = u1[i];

            if v18.defender == p15 and (v18.genKey == p16 and v18.isEnvHazard == true) then
                if v17 then
                    table.remove(u1, i);
                else
                    v17 = v18;
                end;
            end;
        end;

        return v17;
    end
};

function u19.invalidate(p20, p21, p22) -- Line: 115
    -- upvalues: u19 (copy)
    if not u19.findEntry(p20, p21, p22) then
        return;
    end;

    u19.bumpGen(p20, p21);
    u19.removeEntries(p20, p21, p22);
end;

function u19.insert(p23, p24) -- Line: 124
    -- upvalues: u1 (copy), Presentation (copy)
    table.insert(u1, {
        defender = p23.defender,
        casterUserId = p23.casterUserId,
        eleTp = p23.eleTp,
        coeff = p23.coeff,
        genKey = p23.genKey,
        myGen = p24,
        endAt = p23.endAt,
        interval = p23.interval,
        nextTickAt = p23.nextTickAt,
        isEnvHazard = p23.isEnvHazard,
        envVfxName = p23.envVfxName,
        playDotHit = p23.playDotHit
    });

    if p23.isEnvHazard ~= true then
        Presentation.fireDotVfxFromTypeRow(p23.typeRow, p23.defender, p23.casterUserId, p23.vfxDurationSec);
    end;
end;

function u19.renew(p25, p26, p27, p28, p29, p30, p31) -- Line: 145
    -- upvalues: Presentation (copy)
    p25.endAt = p26;

    if not p31 and p25.isEnvHazard ~= true then
        Presentation.fireDotVfxFromTypeRow(p27, p28, p29, p30);
    end;
end;

function u19.removeAtIndex(p32) -- Line: 161
    -- upvalues: u1 (copy)
    table.remove(u1, p32);
end;

return u19;