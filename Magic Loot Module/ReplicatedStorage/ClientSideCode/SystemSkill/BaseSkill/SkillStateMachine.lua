-- Decompiled with Potassium's decompiler.

local SkillEventConst = require(script.Parent.SkillEventConst);

return {
    findTransition = function(p1, p2, p3, p4, p5) -- Line: 26, Name: findTransition
        if not p1 then
            return nil;
        end;

        local v6 = {};

        for _, v in ipairs(p1) do
            if v.From == p2 and (v.Event == p3 and (not v.Condition or p4 and v.Condition(p4, p5))) then
                table.insert(v6, v);
            end;
        end;

        if #v6 == 0 then
            return nil;
        end;

        if #v6 == 1 then
            return v6[1];
        end;

        table.sort(v6, function(p7, p8) -- Line: 39
            return (p7.Priority or 0) > (p8.Priority or 0);
        end);

        return v6[1];
    end,

    shouldStateTimeout = function(p9, p10, p11) -- Line: 52, Name: shouldStateTimeout
        if not (p9 and p9.Duration) then
            return false;
        end;

        local Duration = p9.Duration;

        if Duration < 0 then
            return false;
        end;

        return Duration <= p11 - p10;
    end,

    validateStateGraph = function(p12, u13) -- Line: 66, Name: validateStateGraph
        -- upvalues: SkillEventConst (copy)
        local function addErr(p14) -- Line: 67
            -- upvalues: u13 (copy)
            table.insert(u13, p14);
        end;

        if not (p12.States and p12.InitialState) then
            return;
        end;

        local States = p12.States;
        local v15 = p12.Transitions or {};

        for i, v in pairs(States) do
            if type(v.OnEnterClient) == "string" and (v.OnEnterClient ~= "" and not p12[v.OnEnterClient]) then
                local v16 = ("状态 \'%s\' OnEnterClient \'%s\' 函数不存在"):format(i, v.OnEnterClient);
                table.insert(u13, v16);
            end;

            if type(v.OnEnterServer) == "string" and (v.OnEnterServer ~= "" and not p12[v.OnEnterServer]) then
                local v17 = ("状态 \'%s\' OnEnterServer \'%s\' 函数不存在"):format(i, v.OnEnterServer);
                table.insert(u13, v17);
            end;

            if type(v.OnExitClient) == "string" and (v.OnExitClient ~= "" and not p12[v.OnExitClient]) then
                local v18 = ("状态 \'%s\' OnExitClient \'%s\' 函数不存在"):format(i, v.OnExitClient);
                table.insert(u13, v18);
            end;

            if type(v.OnExitServer) == "string" and (v.OnExitServer ~= "" and not p12[v.OnExitServer]) then
                local v19 = ("状态 \'%s\' OnExitServer \'%s\' 函数不存在"):format(i, v.OnExitServer);
                table.insert(u13, v19);
            end;
        end;

        local function isTerminal(p20) -- Line: 94
            -- upvalues: States (copy)
            local v21 = States[p20];

            if v21 then
                v21 = v21.IsTerminal == true;
            end;

            return v21;
        end;

        local v22 = {};
        local v23 = {};

        for _, v in ipairs(v15) do
            v22[v.From] = true;
            v23[v.From] = v23[v.From] or {};
            table.insert(v23[v.From], v.To);
        end;

        local v24 = {};
        local v25 = { p12.InitialState };
        v24[p12.InitialState] = true;
        local v26 = 1;

        while v26 <= #v25 do
            local v27 = v25[v26];
            v26 = v26 + 1;

            for _, v in ipairs(v23[v27] or {}) do
                if not v24[v] then
                    v24[v] = true;
                    table.insert(v25, v);
                end;
            end;
        end;

        for i, v in pairs(States) do
            local v28 = States[i];

            if v28 then
                v28 = v28.IsTerminal == true;
            end;

            if v28 then
                if v22[i] then
                    local v29 = ("终态 \'%s\' 存在出边，会导致终态复活，框架语义不允许（IsTerminal 状态不应有转出）"):format(i);
                    table.insert(u13, v29);
                end;
            else
                if v then
                    local v = v.Duration;
                end;

                local v30;

                if type(v) == "number" then
                    v30 = v >= 0;
                else
                    v30 = false;
                end;

                if not (v30 or v22[i]) then
                    local v31 = ("状态 \'%s\' 为死状态：无 Duration 超时且无出边，无法离开"):format(i);
                    table.insert(u13, v31);
                end;

                if not v24[i] then
                    local v32 = ("状态 \'%s\' 永远不可达：从 InitialState 无法到达"):format(i);
                    table.insert(u13, v32);
                end;
            end;
        end;

        local StateOrder = p12.StateOrder;

        if StateOrder and type(StateOrder) == "table" then
            for _, v in ipairs(v15) do
                local v33 = StateOrder[v.From];
                local v34 = StateOrder[v.To];

                if v33 ~= nil and (v34 ~= nil and (type(v33) == "number" and (type(v34) == "number" and v34 <= v33))) then
                    local v35 = ("StateOrder 顺序倒挂：Transition %s -> %s，order[%s]=%s >= order[%s]=%s"):format(v.From, v.To, v.From, tostring(v33), v.To, (tostring(v34)));
                    table.insert(u13, v35);
                end;
            end;
        end;

        local v36 = {};

        for _, v in ipairs(v15) do
            local v37 = v.From .. "|" .. (v.Event or "");
            v36[v37] = v36[v37] or {};
            table.insert(v36[v37], {
                To = v.To,
                Priority = v.Priority or 0
            });
        end;

        for i, v in pairs(v36) do
            if #v > 1 then
                local v38 = {};

                for _, v2 in ipairs(v) do
                    v38[v2.Priority] = (v38[v2.Priority] or 0) + 1;
                end;

                for i2, v2 in pairs(v38) do
                    if v2 > 1 then
                        local v39 = ("From+Event \'%s\' 存在 %d 条同优先级 %s 规则，行为歧义"):format(i, v2, (tostring(i2)));
                        table.insert(u13, v39);
                        break;
                    end;
                end;
            end;
        end;

        local v40 = {};

        for _, v in ipairs(v15) do
            if v.Event == SkillEventConst.StateTimeout then
                v40[v.From] = true;
            end;
        end;

        for i, v in pairs(States) do
            local v41 = States[i];

            if v41 then
                v41 = v41.IsTerminal == true;
            end;

            if not v41 then
                if v then
                    local v = v.Duration;
                end;

                if type(v) == "number" and (v >= 0 and not v40[i]) then
                    local v42 = ("状态 \'%s\' Duration=%s 但无 StateTimeout 出边，Duration 无实际意义（半失效配置）"):format(i, (tostring(v)));
                    table.insert(u13, v42);
                end;
            end;
        end;
    end
};