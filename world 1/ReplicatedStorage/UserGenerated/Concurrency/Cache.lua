-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable);
local DeepFreeze = require(game.ReplicatedStorage.UserGenerated.Collections.DeepFreeze);
local Lock = require(game.ReplicatedStorage.UserGenerated.Concurrency.Lock);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);

local function ValueAge(p1, p2) -- Line: 38
    local RetrievedAt = p1.RetrievedAt;

    if RetrievedAt then
        return p2 - RetrievedAt;
    end;

    return nil;
end;

local function AttemptAge(p3, p4) -- Line: 46
    local AttemptedAt = p3.AttemptedAt;

    return not AttemptedAt and (1 / 0) or p4 - AttemptedAt;
end;

local v18 = {
    RemoveUsedAt = function(p5, p6) -- Line: 89, Name: RemoveUsedAt
    end,

    InsertUsedAt = function(p7, p8) -- Line: 93, Name: InsertUsedAt
    end,

    SetUsedAt = function(p9, p10, p11) -- Line: 97, Name: SetUsedAt
        p9:RemoveUsedAt(p10);
        p10.UsedAt = p11;
        p9:InsertUsedAt(p10);
    end,

    Get = function(p12, p13) -- Line: 109, Name: Get
        local v14 = p12.AssertKey(p13);
        local v15 = p12.Cache[v14];

        if not v15 then
            return nil;
        end;

        local v16 = os.clock();
        local RetrievedAt = v15.RetrievedAt;
        local v17;

        if RetrievedAt then
            v17 = v16 - RetrievedAt;
        else
            v17 = nil;
        end;

        if not v17 or p12.MaxAge <= v17 and not p12.ReturnStale then
            return nil;
        end;

        p12:SetUsedAt(v15, v16);

        return v15.Value;
    end
};

function AsyncCallback(p19, p20, p21, p22)
    -- upvalues: DeepFreeze (copy)
    local RetrievedAt = p20.RetrievedAt;
    local v23;

    if RetrievedAt then
        v23 = p22 - RetrievedAt;
    else
        v23 = nil;
    end;

    if v23 and v23 < p19.MaxAge then
        return p20.Value;
    end;

    local AttemptedAt = p20.AttemptedAt;

    if (not AttemptedAt and (1 / 0) or p22 - AttemptedAt) < p19.FailureRetryDelay then
        if p19.ReturnStale then
            return p20.Value;
        end;

        return nil;
    end;

    p20.AttemptedAt = p22;
    local success, result = pcall(p19.Callback, p21);
    local v24 = os.clock();
    p20.AttemptedAt = v24;
    p19:SetUsedAt(p20, v24);

    if not success then
        if p19.ReturnStale then
            return p20.Value;
        end;

        return nil;
    end;

    if p19.Freeze then
        result = DeepFreeze(result);
    end;

    p20.Value = result;
    p20.RetrievedAt = v24;
    p19.Updated:Fire(p21);

    return result;
end;

function v18.GetAsync(p25, p26) -- Line: 156
    -- upvalues: Lock (copy)
    local v27 = os.clock();
    local v28 = p25.AssertKey(p26);
    local v29 = p25.Cache[v28];

    if v29 then
        p25:SetUsedAt(v29, v27);
    else
        v29 = {
            Lock = Lock.new(),
            UsedAt = v27
        };
        p25.Cache[v28] = v29;
        p25:InsertUsedAt(v29);
    end;

    return v29.Lock:Call(AsyncCallback, p25, v29, p26, v27);
end;

function v18.Delete(p30, p31) -- Line: 174
    local v32 = p30.AssertKey(p31);

    if p30.Cache[v32] then
        p30.Cache[v32] = nil;
        p30.Deleted:Fire(p31);
    end;
end;

local u33 = table.freeze({
    __index = table.freeze(v18)
});
local u34 = Asserts.Table({
    Callback = Asserts.Function,
    AssertKey = Asserts.Function,
    MaxAge = Asserts.Optional(Asserts.NonNegative),
    FailureRetryDelay = Asserts.Optional(Asserts.NonNegative),
    ReturnStale = Asserts.Optional(Asserts.Boolean),
    Freeze = Asserts.Optional(Asserts.Boolean)
});

return table.freeze({
    new = function(p35) -- Line: 210, Name: new
        -- upvalues: u34 (copy), Bindable (copy), u33 (copy)
        u34(p35);
        local v36 = {
            Updated = Bindable.new(),
            Deleted = Bindable.new(),
            Callback = p35.Callback,
            AssertKey = p35.AssertKey,
            MaxAge = p35.MaxAge or (1 / 0),
            FailureRetryDelay = p35.FailureRetryDelay or 300,
            ReturnStale = p35.ReturnStale == nil and true or p35.ReturnStale,
            Freeze = p35.Freeze == nil and true or p35.Freeze,
            Cache = {}
        };
        local v37 = setmetatable(v36, u33);
        table.freeze(v37);

        return v37;
    end
});