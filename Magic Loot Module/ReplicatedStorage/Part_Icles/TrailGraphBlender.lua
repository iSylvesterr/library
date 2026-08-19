-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);

return {
    CollectStates = function(p1) -- Line: 17, Name: CollectStates
        local v2 = {};
        local v3 = {};
        local v4 = {};

        if not p1 then
            return v2, v3, v4;
        end;

        for _, child in pairs(p1:GetChildren()) do
            if child:IsA("Configuration") then
                local v5 = child:GetAttribute("Time");

                if v5 == nil then
                    local v6 = tonumber(string.match(child.Name, "%d+"));
                    v5 = v6 and v6 - 1 or 0;
                end;

                local v7 = child:GetAttribute("Width");

                if v7 and typeof(v7) == "NumberSequence" then
                    table.insert(v2, {
                        Time = v5,
                        Graph = v7
                    });
                end;

                local v8 = child:GetAttribute("Transparency");

                if v8 and typeof(v8) == "NumberSequence" then
                    table.insert(v3, {
                        Time = v5,
                        Graph = v8
                    });
                end;

                local v9 = child:GetAttribute("Color");

                if v9 and typeof(v9) == "ColorSequence" then
                    table.insert(v4, {
                        Time = v5,
                        Graph = v9
                    });
                end;
            end;
        end;

        for _, v in ipairs({ v2, v3, v4 }) do
            table.sort(v, function(p10, p11) -- Line: 44
                return p10.Time < p11.Time;
            end);

            if #v > 1 and v[#v].Time > 1 then
                local Time = v[#v].Time;

                if Time > 0 then
                    for _, v5 in ipairs(v) do
                        v5.Time = v5.Time / Time;
                    end;
                end;
            end;
        end;

        return v2, v3, v4;
    end,

    PrecomputeMergedTimes = Graph.PrecomputeMergedTimes,
    PrecomputeMergedColorTimes = Graph.PrecomputeMergedColorTimes,
    LerpGraphFast = Graph.LerpGraphFast,
    LerpColorGraphFast = Graph.LerpColorGraphFast
};