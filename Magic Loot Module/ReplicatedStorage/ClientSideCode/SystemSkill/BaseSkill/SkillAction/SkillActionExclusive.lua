-- Decompiled with Potassium's decompiler.

local u1 = {};
setmetatable(u1, {
    __mode = "k"
});

local function actionKey(p2) -- Line: 11
    local actionInfo = p2.actionInfo;

    if actionInfo and actionInfo.action then
        return tostring(actionInfo.action);
    end;

    return nil;
end;

return {
    isExclusive = function(p3) -- Line: 19, Name: isExclusive
        local v4;

        if p3.actionInfo == nil then
            v4 = false;
        else
            v4 = p3.actionInfo.allowParallelTracks == false;
        end;

        return v4;
    end,

    beforeStart = function(p5) -- Line: 26, Name: beforeStart
        -- upvalues: u1 (copy)
        local v6;

        if p5.actionInfo == nil then
            v6 = false;
        else
            v6 = p5.actionInfo.allowParallelTracks == false;
        end;

        if not v6 then
            return;
        end;

        local v7 = p5.baseSkill and p5.baseSkill.character;
        local actionInfo = p5.actionInfo;
        local v8;

        if actionInfo and actionInfo.action then
            v8 = tostring(actionInfo.action);
        else
            v8 = nil;
        end;

        if not (v7 and v8) then
            return;
        end;

        local v9 = u1[v7];

        if v9 then
            v9 = v9[v8];
        end;

        if v9 and v9 ~= p5 then
            v9:Over(0);
        end;

        local v10 = u1[v7] or {};
        u1[v7] = v10;
        v10[v8] = p5;
    end,

    releaseIfOwner = function(p11) -- Line: 50, Name: releaseIfOwner
        -- upvalues: u1 (copy)
        local v12;

        if p11.actionInfo == nil then
            v12 = false;
        else
            v12 = p11.actionInfo.allowParallelTracks == false;
        end;

        if not v12 then
            return;
        end;

        local v13 = p11.baseSkill and p11.baseSkill.character;
        local actionInfo = p11.actionInfo;
        local v14;

        if actionInfo and actionInfo.action then
            v14 = tostring(actionInfo.action);
        else
            v14 = nil;
        end;

        if not (v13 and v14) then
            return;
        end;

        local v15 = u1[v13];

        if not v15 or v15[v14] ~= p11 then
            return;
        end;

        v15[v14] = nil;

        if next(v15) == nil then
            u1[v13] = nil;
        end;
    end
};