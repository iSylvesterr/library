-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local TranslationHelper = UtilsSystem.TranslationHelper;
local SpecialEnemySchedule = UtilsSystem.SpecialEnemySchedule;
local TimeTransfer = UtilsSystem.TimeTransfer;
local u1 = { "大厅", "功能", "变异怪刷新倒计时", "倒计时面板", "SurfaceGui", "Frame" };
local u2 = { EnumMgr.Rare.Xyd5, EnumMgr.Rare.Xyd6, EnumMgr.Rare.Xyd7 };
local u3 = {};
local u4 = false;
local u5 = nil;
local u6 = 0;
local u7 = 0;

local function _getRarityNameKey(p8) -- Line: 63
    -- upvalues: u2 (copy), EnumMgr (copy)
    return EnumMgr.Rare[u2[p8] or EnumMgr.Rare.Xyd5] or "传说";
end;

local function _getSpawnIntervalMinutes(p9) -- Line: 74
    -- upvalues: SystemGameConfig (copy), SpecialEnemySchedule (copy)
    local v10 = SystemGameConfig.GetValue({ "Dungeon", "变异怪刷新时间", p9 });

    return SpecialEnemySchedule.getIntervalMinutes(v10);
end;

local function _findCountdownFrame() -- Line: 84
    -- upvalues: Workspace (copy), u1 (copy)
    local v11 = Workspace:FindFirstChild("场景");

    if not v11 then
        return nil;
    end;

    for _, v in u1 do
        v11 = v11:FindFirstChild(v);

        if not v11 then
            return nil;
        end;
    end;

    if v11:IsA("Frame") then
        return v11;
    end;

    return nil;
end;

local function _bindCountdownLabels() -- Line: 110
    -- upvalues: _findCountdownFrame (copy), u3 (copy)
    local v12 = _findCountdownFrame();

    if not v12 then
        return false;
    end;

    local v13 = false;

    for i = 1, 3 do
        local v14 = v12:FindFirstChild((tostring(i)));

        if v14 then
            local v15 = v14:FindFirstChild("描述", true);
            local v16 = v14:FindFirstChild("倒计时", true);

            if v15 and (v15:IsA("TextLabel") and (v16 and v16:IsA("TextLabel"))) then
                u3[i] = {
                    desc = v15,
                    countdown = v16
                };
                v13 = true;
            end;
        end;
    end;

    return v13;
end;

local function _refreshCountdownLabels() -- Line: 142
    -- upvalues: u4 (ref), _bindCountdownLabels (copy), CfgFind (copy), u3 (copy), SystemGameConfig (copy), SpecialEnemySchedule (copy), u2 (copy), EnumMgr (copy), TimeTransfer (copy), TranslationHelper (copy)
    u4 = u4 or _bindCountdownLabels();

    if not u4 then
        return;
    end;

    local v17 = os.time();
    local v18 = CfgFind.GetCfgByName("specialenemyConf");

    if type(v18) ~= "table" then
        return;
    end;

    for i, _ in pairs(v18) do
        local v19 = tonumber(i);

        if v19 then
            local v20 = u3[v19];

            if v20 then
                local v21 = SystemGameConfig.GetValue({ "Dungeon", "变异怪刷新时间", v19 });
                local v22 = SpecialEnemySchedule.getIntervalMinutes(v21);
                local v23 = EnumMgr.Rare[u2[v19] or EnumMgr.Rare.Xyd5] or "传说";
                local v24 = TimeTransfer.FormatTimeMMSS(SpecialEnemySchedule.getRemainingSec(v17, v22));
                TranslationHelper.SetText(v20.desc, "变异怪生成时间", {
                    { v23 }
                });
                TranslationHelper.SetText_UnTrans(v20.countdown, v24);
            end;
        end;
    end;
end;

local function _onHeartbeat(p25) -- Line: 181
    -- upvalues: u4 (ref), u7 (ref), _bindCountdownLabels (copy), _refreshCountdownLabels (copy), u6 (ref)
    if not u4 then
        u7 = u7 + p25;

        if u7 < 1 then
            return;
        end;

        u7 = 0;
        u4 = _bindCountdownLabels();

        if not u4 then
            return;
        end;

        _refreshCountdownLabels();
    end;

    u6 = u6 + p25;

    if u6 < 0.1 then
        return;
    end;

    u6 = 0;
    _refreshCountdownLabels();
end;

local function _bindHeartbeat() -- Line: 208
    -- upvalues: u5 (ref), RunService (copy), _onHeartbeat (copy)
    if u5 then
        return;
    end;

    u5 = RunService.Heartbeat:Connect(_onHeartbeat);
end;

if not u5 then
    u5 = RunService.Heartbeat:Connect(_onHeartbeat);
end;