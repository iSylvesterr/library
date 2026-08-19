-- Decompiled with Potassium's decompiler.

local v1 = {};
local u19 = {
    Disable = function(p2) -- Line: 35, Name: Disable
        local engine = p2.engine;
        local token = p2.token;
        token.Alive = false;

        for _, v in ipairs(token.Loops) do
            pcall(task.cancel, v);
        end;

        token.Loops = {};
        local ActiveEmits = engine.ActiveEmits;

        for i = #ActiveEmits, 1, -1 do
            local v3 = ActiveEmits[i];

            if v3 and v3._playToken == token then
                if v3.VisualPart and v3.VisualPart.Parent then
                    engine:_releaseOrDestroy(v3, v3.VisualPart);
                end;

                if v3._scaleMapKeys and engine._parentScaleMap then
                    for _, v in ipairs(v3._scaleMapKeys) do
                        engine._parentScaleMap[v] = nil;
                    end;
                end;

                local v4 = #ActiveEmits;

                if i < v4 then
                    ActiveEmits[i] = ActiveEmits[v4];
                end;

                ActiveEmits[v4] = nil;
            end;
        end;

        for _, v in ipairs(token.Clones) do
            if v and v.Parent then
                pcall(function() -- Line: 61
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
            end;
        end;

        token.Clones = {};
    end,

    SoftDisable = function(p5) -- Line: 68, Name: SoftDisable
        local token = p5.token;
        token.Alive = false;

        for _, v in ipairs(token.Loops) do
            pcall(task.cancel, v);
        end;

        token.Loops = {};
    end,

    SetTimescale = function(p6, p7, p8, p9) -- Line: 79, Name: SetTimescale
        if typeof(p7) ~= "number" then
            return;
        end;

        local engine = p6.engine;
        local token = p6.token;
        local v10;

        if p9 == true then
            v10 = (1 / 0);
        elseif typeof(p8) == "number" and p8 > 0 then
            v10 = os.clock() + p8;
        else
            token.TsOverride = nil;
            token.TsUntil = nil;
            v10 = nil;
        end;

        if v10 == nil or not p7 then
            p7 = nil;
        end;

        token.TsOverride = p7;
        token.TsUntil = v10;
        local ActiveEmits = engine.ActiveEmits;

        for i = 1, #ActiveEmits do
            local v11 = ActiveEmits[i];

            if v11 and v11._playToken == token then
                v11._tsOverride = token.TsOverride;
                v11._tsOverrideUntil = v10;
            end;
        end;
    end,

    GetParticles = function(p12) -- Line: 106, Name: GetParticles
        local ActiveEmits = p12.engine.ActiveEmits;
        local v13 = {};

        for i = 1, #ActiveEmits do
            local v14 = ActiveEmits[i];

            if v14 and (v14._playToken == p12.token and v14.VisualPart) then
                v13[#v13 + 1] = v14.VisualPart;
            end;
        end;

        return v13;
    end,

    GetPDatas = function(p15) -- Line: 122, Name: GetPDatas
        local ActiveEmits = p15.engine.ActiveEmits;
        local v16 = {};

        for i = 1, #ActiveEmits do
            local v17 = ActiveEmits[i];

            if v17 and v17._playToken == p15.token then
                v16[#v16 + 1] = v17;
            end;
        end;

        return v16;
    end,

    IsAlive = function(p18) -- Line: 135, Name: IsAlive
        local ActiveEmits = p18.engine.ActiveEmits;

        for i = 1, #ActiveEmits do
            if ActiveEmits[i] and ActiveEmits[i]._playToken == p18.token then
                return true;
            end;
        end;

        for _, v in ipairs(p18.token.Loops) do
            if coroutine.status(v) ~= "dead" then
                return true;
            end;
        end;

        return false;
    end
};
local u22 = {
    __index = function(p20, p21) -- Line: 148
        -- upvalues: u19 (copy)
        if p21 == "Active" then
            return u19.IsAlive(p20);
        end;

        return u19[p21];
    end
};

function v1.new(p23, p24) -- Line: 153
    -- upvalues: u22 (copy)
    return setmetatable({
        engine = p23,
        token = p24,
        Duration = p24.Duration
    }, u22);
end;

return v1;