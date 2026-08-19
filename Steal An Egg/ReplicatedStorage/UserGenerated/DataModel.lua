-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Encode = require(script.Encode);
local Reflection = require(script.Reflection);
local fastIndex = Encode.fastIndex;
local u1 = { "Workspace", "Players", "Lighting", "MaterialService", "ReplicatedFirst", "ReplicatedStorage", "SoundService", "StarterGui", "StarterPack", "StarterPlayer", "Teams", "TextChatService" };
local u2 = { "ServerScriptService", "ServerStorage" };

local function encodeId(p3) -- Line: 77
    local v4 = {};

    repeat
        v4[#v4 + 1] = string.char(p3 % 256);
        p3 = p3 // 256;
    until p3 == 0;

    return table.concat(v4);
end;

return {
    capture = function(p5, p6) -- Line: 88, Name: capture
        -- upvalues: encodeId (copy), u1 (copy), RunService (copy), u2 (copy), Encode (copy), fastIndex (copy), Reflection (copy)
        local v7 = p5 or {};
        local v8 = v7.properties == true;
        local v9 = v7.yielding ~= false;
        local v10 = ((not p6 or p6 <= 0) and 0.016666666666666666 or p6) * 0.33;
        local v11 = os.clock() + 30;
        local u12 = {};
        local u13 = {};

        local function classIdx(p14) -- Line: 99
            -- upvalues: u13 (copy), u12 (copy)
            local v15 = u13[p14];

            if v15 then
                return v15;
            end;

            local v16 = #u12;
            u12[v16 + 1] = p14;
            u13[p14] = v16;

            return v16;
        end;

        local u17 = {};
        local u18 = {};

        local function propIdx(p19) -- Line: 112
            -- upvalues: u18 (copy), u17 (copy)
            local v20 = u18[p19];

            if v20 then
                return v20;
            end;

            local v21 = #u17;
            u17[v21 + 1] = p19;
            u18[p19] = v21;

            return v21;
        end;

        local u22 = {};
        local u23 = 0;
        local u24 = {};

        local function assign(p25) -- Line: 129
            -- upvalues: u22 (copy), u23 (ref), encodeId (ref), u24 (copy)
            local v26 = u22[p25];

            if v26 then
                return v26;
            end;

            u23 = u23 + 1;
            local v27 = encodeId(u23);
            u22[p25] = v27;
            u24[#u24 + 1] = p25;

            return v27;
        end;

        local v28 = game;

        if not u22[v28] then
            u23 = u23 + 1;
            u22[v28] = encodeId(u23);
            u24[#u24 + 1] = v28;
        end;

        local v29 = table.clone(u1);

        if RunService:IsServer() then
            for _, v in u2 do
                table.insert(v29, v);
            end;
        end;

        for _, v in v29 do
            local success, result = pcall(function() -- Line: 150
                -- upvalues: v (copy)
                return game:GetService(v);
            end);

            if success and result then
                if not u22[result] then
                    u23 = u23 + 1;
                    u22[result] = encodeId(u23);
                    u24[#u24 + 1] = result;
                end;

                local success2, result2 = pcall(function() -- Line: 157
                    -- upvalues: result (copy)
                    return result:GetDescendants();
                end);

                if success2 and result2 then
                    for _, v2 in result2 do
                        if not u22[v2] then
                            u23 = u23 + 1;
                            u22[v2] = encodeId(u23);
                            u24[#u24 + 1] = v2;
                        end;
                    end;
                end;
            end;
        end;

        local v30 = Encode.newWriter(262144);
        v30:u8(68);
        v30:u8(1);
        v30:u8(v8 and 1 or 0);
        local v31 = os.clock();
        local v32 = 0;
        local v33 = false;

        for _, v in u24 do
            local v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46;

            if v == game then
                v34 = "";
                v35, v36 = pcall(fastIndex, v, "ClassName");

                if v35 and type(v36) == "string" then
                    v37, v38 = pcall(fastIndex, v, "Name");

                    if v37 then
                        if type(v38) ~= "string" then
                            v38 = v36;
                        end;
                    else
                        v38 = v36;
                    end;

                    v30:strU8(u22[v]);
                    v30:strU8(v34);
                    v39 = u13[v36];

                    if not v39 then
                        v39 = #u12;
                        u12[v39 + 1] = v36;
                        u13[v36] = v39;
                    end;

                    v30:u16(v39);
                    v30:strU16(v38);

                    if v8 then
                        v40 = Reflection.getReadProperties(v36);
                        v41 = v30.len;
                        v30:u16(0);
                        v42 = 0;

                        for _, v2 in v40 do
                            v43, v44 = pcall(fastIndex, v, v2);

                            if v43 then
                                v45 = u18[v2];

                                if not v45 then
                                    v45 = #u17;
                                    u17[v45 + 1] = v2;
                                    u18[v2] = v45;
                                end;

                                v30:u16(v45);
                                Encode.writeValue(v30, v44);
                                v42 = v42 + 1;
                            end;
                        end;

                        v30:patchU16(v41, v42);
                    end;

                    v32 = v32 + 1;

                    if v30.len >= 50331648 then
                        v33 = true;
                        break;
                    end;

                    if v9 and v32 >= 20 then
                        v46 = os.clock();

                        if v11 <= v46 then
                            return {
                                TimedOut = true
                            };
                        end;

                        if v10 <= v46 - v31 then
                            task.wait();
                            v31 = os.clock();
                            v32 = 0;
                        end;
                    end;
                end;
            end;

            local success, result = pcall(fastIndex, v, "Parent");

            if success and result ~= nil then
                v34 = u22[result] or "";

                if v34 ~= "" then
                    v35, v36 = pcall(fastIndex, v, "ClassName");

                    if v35 and type(v36) == "string" then
                        v37, v38 = pcall(fastIndex, v, "Name");

                        if v37 then
                            if type(v38) ~= "string" then
                                v38 = v36;
                            end;
                        else
                            v38 = v36;
                        end;

                        v30:strU8(u22[v]);
                        v30:strU8(v34);
                        v39 = u13[v36];

                        if not v39 then
                            v39 = #u12;
                            u12[v39 + 1] = v36;
                            u13[v36] = v39;
                        end;

                        v30:u16(v39);
                        v30:strU16(v38);

                        if v8 then
                            v40 = Reflection.getReadProperties(v36);
                            v41 = v30.len;
                            v30:u16(0);
                            v42 = 0;

                            for _, v2 in v40 do
                                v43, v44 = pcall(fastIndex, v, v2);

                                if v43 then
                                    v45 = u18[v2];

                                    if not v45 then
                                        v45 = #u17;
                                        u17[v45 + 1] = v2;
                                        u18[v2] = v45;
                                    end;

                                    v30:u16(v45);
                                    Encode.writeValue(v30, v44);
                                    v42 = v42 + 1;
                                end;
                            end;

                            v30:patchU16(v41, v42);
                        end;

                        v32 = v32 + 1;

                        if v30.len >= 50331648 then
                            v33 = true;
                            break;
                        end;

                        if v9 and v32 >= 20 then
                            v46 = os.clock();

                            if v11 <= v46 then
                                return {
                                    TimedOut = true
                                };
                            end;

                            if v10 <= v46 - v31 then
                                task.wait();
                                v31 = os.clock();
                                v32 = 0;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        return {
            Buffer = v30:finish(),
            Classes = u12,
            Props = u17,
            Truncated = v33
        };
    end
};