-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CreateParticleHost = require(script.Parent.CreateParticleHost);
local AddDebris = require(script.Parent.AddDebris);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);

function EmitParticles(u1, u2, ...)
    -- upvalues: CreateParticleHost (copy), Asserts (copy), Constants (copy), AddDebris (copy)
    local u3 = {};
    local u4 = 0;
    local u5 = nil;

    if typeof(u1) == "Instance" then
        if u1:IsA("Model") then
            u1 = u1.PrimaryPart;
            assert(u1, "target Model missing PrimaryPart!");
        end;
    else
        u5, u1 = CreateParticleHost(u1);
    end;

    local function processEmitter(p6) -- Line: 45
        -- upvalues: u2 (copy), Asserts (ref), Constants (ref), u1 (ref), u3 (copy), u4 (ref), u5 (ref), AddDebris (ref)
        local TimeScale = p6.TimeScale;

        if TimeScale < 0 then
            return;
        end;

        local u7 = p6:Clone();
        u7.Enabled = false;

        if u2 then
            u2(u7);
        end;

        local v8 = u7:GetAttribute("EmitCount") or u7.Rate;
        Asserts.number(v8);
        local v9 = v8 - math.floor(v8);
        local u10 = math.floor(v8);

        if v9 > 0 and math.random() < v9 then
            u10 = u10 + 1;
        end;

        if Constants.IS_MOBILE and u10 > 1 then
            u10 = math.max(u10 * 0.1, 1);
        end;

        if u10 < 1 then
            u7:Destroy();

            return;
        end;

        local v11 = u7:GetAttribute("EmitDelay") or 0;
        Asserts.number(v11);

        if v11 == (1 / 0) then
            u7:Destroy();

            return;
        end;

        local v12 = math.max(v11, 0);
        u7.Parent = u1;
        table.insert(u3, u7);
        local u13 = u7.Lifetime.Max / TimeScale;
        u4 = math.max(u4, v12 + u13);

        if v12 > 0 then
            task.delay(v12, function() -- Line: 96
                -- upvalues: u7 (ref), u10 (ref), u5 (ref), AddDebris (ref), u13 (copy)
                u7:Emit(u10);

                if not u5 then
                    AddDebris(u7, u13);
                end;
            end);
        else
            u7:Emit(u10);

            if not u5 then
                AddDebris(u7, u13);
            end;
        end;
    end;

    local v14 = table.pack(...);

    for i = 1, v14.n do
        local v15 = v14[i];

        if type(v15) == "table" then
            for _, v in ipairs(v15) do
                processEmitter(v);
            end;
        else
            processEmitter(v15);
        end;
    end;

    if u5 then
        AddDebris(u5, u4);
    end;

    return u3, u4;
end;

return EmitParticles;