-- Decompiled with Potassium's decompiler.

local u1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local DataStoreService = game:GetService("DataStoreService");
game:GetService("ReplicatedStorage");
local CfgFind = UtilsSystem.CfgFind;
local u2 = DataStoreService:GetDataStore("CDKPools");
local u3 = {};
local u4 = CfgFind.GetCfgByName("codeConf");

if u4 then
    for _, v in pairs(u4) do
        if v.codeType == 3 then
            u3[v.code] = {
                rewardId = v.rewardId,
                rewardNum = v.rewardNum,
                startTime = v.startTime or 0,
                endTime = v.endTime or 0
            };
        end;
    end;
end;

local function GenerateSingleCDK() -- Line: 66
    local v5 = {};

    for _ = 1, 3 do
        local v6 = "";

        for _ = 1, 4 do
            local v7 = math.random(1, 32);
            v6 = v6 .. string.sub("ABCDEFGHJKLMNPQRSTUVWXYZ23456789", v7, v7);
        end;

        table.insert(v5, v6);
    end;

    return table.concat(v5, "-");
end;

local function IsCDKUnique(u8, p9) -- Line: 85
    -- upvalues: u2 (copy)
    local success, result = pcall(function() -- Line: 86
        -- upvalues: u2 (ref), u8 (copy)
        return u2:GetAsync(u8) or {};
    end);

    if not success then
        return false;
    end;

    return not (result.cdks and result.cdks[p9]);
end;

function u1.GenerateSingleCDK() -- Line: 104
    -- upvalues: GenerateSingleCDK (copy)
    return GenerateSingleCDK();
end;

function u1.IsCDKUnique(u10, p11) -- Line: 114
    -- upvalues: u2 (copy)
    local success, result = pcall(function() -- Line: 86
        -- upvalues: u2 (ref), u10 (copy)
        return u2:GetAsync(u10) or {};
    end);

    if not success then
        return false;
    end;

    return not (result.cdks and result.cdks[p11]);
end;

function u1.GenerateAndPrintCDK(u12, p13) -- Line: 124
    -- upvalues: u3 (copy), GenerateSingleCDK (copy), u2 (copy)
    if not u3[u12] then
        warn("无效的CDK池ID: " .. tostring(u12));
        warn("可用CDK池ID列表:");

        for i, _ in pairs(u3) do
            warn("- " .. i);
        end;

        return false;
    end;

    local v14 = {};
    local v15 = 0;
    local v16 = {};

    while #v14 < p13 and v15 < p13 * 3 do
        v15 = v15 + 1;
        local v17 = GenerateSingleCDK();

        if not v16[v17] then
            local success, result = pcall(function() -- Line: 86
                -- upvalues: u2 (ref), u12 (copy)
                return u2:GetAsync(u12) or {};
            end);
            local v18;

            if success then
                v18 = not (result.cdks and result.cdks[v17]);
            else
                v18 = false;
            end;

            if v18 then
                v16[v17] = true;
                table.insert(v14, v17);
            end;
        end;
    end;

    local v19 = "return {\n";

    for _, v in ipairs(v14) do
        v19 = v19 .. string.format("    \"%s\",\n", v);
    end;

    print("\n====== 生成的CDK列表 (" .. u12 .. ") ======");
    print(v19 .. "}");
    local success, result = pcall(function() -- Line: 164
        -- upvalues: u2 (ref), u12 (copy)
        return u2:GetAsync(u12) or {
            cdks = {}
        };
    end);

    if not success then
        warn("获取CDK池数据失败");

        return false;
    end;

    for _, v in ipairs(v14) do
        result.cdks[v] = {
            redeemed = false,
            generated = os.time()
        };
    end;

    if pcall(function() -- Line: 178
        -- upvalues: u2 (ref), u12 (copy), result (copy)
        u2:SetAsync(u12, result);
    end) then
        print(string.format("\n成功生成并保存 %d/%d 个CDK到DataStore", #v14, p13));

        return true, v14;
    end;

    warn("保存CDK到DataStore失败");

    return false;
end;

function u1.GenerateAllPoolsCDK(p20) -- Line: 200
    -- upvalues: u4 (copy), u1 (copy)
    local v21 = {};
    local v22 = p20 or 100;

    for _, v in pairs(u4) do
        if v.codeType == 3 then
            table.insert(v21, v.code);
        end;
    end;

    if #v21 == 0 then
        warn("没有找到任何CDK池配置");

        return false;
    end;

    local v23 = {};

    for _, v in ipairs(v21) do
        print("\n正在为池 [" .. v .. "] 生成 " .. v22 .. " 个CDK...");
        local v24, v25 = u1.GenerateAndPrintCDK(v, v22);
        v23[v] = {
            success = v24,
            count = v24 and #v25 or 0
        };
    end;

    print("\n====== CDK生成结果汇总 ======");

    for i, v in pairs(v23) do
        print(string.format("%-15s: %s (生成%d个)", i, v.success and "成功" or "失败", v.count));
    end;

    return true;
end;

function u1.Redeem(p26, p27) -- Line: 251
    -- upvalues: u3 (copy), u2 (copy)
    if not (p26 and p27) then
        return false, "参数错误";
    end;

    local v28 = {};

    for i, _ in pairs(u3) do
        table.insert(v28, i);
    end;

    for _, v in ipairs(v28) do
        local v29 = u3[v];
        local v30 = os.time();

        if (v29.startTime == 0 or v29.startTime <= v30) and (v29.endTime == 0 or v30 <= v29.endTime) then
            local success, result = pcall(function() -- Line: 272
                -- upvalues: u2 (ref), v (copy)
                return u2:GetAsync(v);
            end);

            if success and (result and (result.cdks and result.cdks[p27])) then
                if result.cdks[p27].redeemed then
                    return false, "该CDK已被使用";
                end;

                result.cdks[p27].redeemed = true;
                result.cdks[p27].redeemedBy = p26.UserId;
                result.cdks[p27].redeemTime = os.time();

                if pcall(function() -- Line: 287
                    -- upvalues: u2 (ref), v (copy), result (copy)
                    u2:SetAsync(v, result);
                end) then
                    return true, v29.rewardId, v29.rewardNum;
                end;

                return false, "保存兑换记录失败";
            end;
        end;
    end;

    return false, "无效的CDK或兑换码";
end;

return u1;