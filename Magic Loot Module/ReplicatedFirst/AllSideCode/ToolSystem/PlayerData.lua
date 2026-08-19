-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Copy = UtilsSystem.Copy;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local u1 = {};
local u2 = RunService:IsClient();
local u3 = RunService:IsServer();
local u4 = nil;
local u5 = {};

local function _getSystemSave() -- Line: 80
    -- upvalues: UtilsSystem (copy)
    return UtilsSystem.SystemSave;
end;

local function _getNested(p6, p7) -- Line: 90
    if type(p6) ~= "table" then
        return nil;
    end;

    if type(p7) == "string" then
        return p6[p7];
    end;

    if type(p7) ~= "table" or #p7 <= 0 then
        return nil;
    end;

    for i = 1, #p7 do
        if p6 == nil or type(p6) ~= "table" then
            return nil;
        end;

        p6 = p6[p7[i]];
    end;

    return p6;
end;

local function _setNested(p8, p9, p10) -- Line: 117
    if type(p9) == "string" then
        p8[p9] = p10;

        return;
    end;

    if type(p9) == "table" and #p9 > 0 then
        for i = 1, #p9 - 1 do
            local v11 = p9[i];

            if p8[v11] == nil or type(p8[v11]) ~= "table" then
                p8[v11] = {};
            end;

            p8 = p8[v11];
        end;

        p8[p9[#p9]] = p10;
    end;
end;

function u1.RegisterNetWork() -- Line: 143
    -- upvalues: u2 (copy), NetWork (copy), NetMsg (copy), u4 (ref), Copy (copy), _setNested (copy), u5 (copy), u3 (copy), u1 (copy)
    if u2 then
        NetWork.RegisterClientRemoteEvent(NetMsg.PLAYER_DATA_SYNC, function(p12, p13) -- Line: 145
            -- upvalues: u4 (ref), Copy (ref), _setNested (ref), u5 (ref)
            if p12 == nil then
                if p13 == nil then
                    return;
                end;

                local v14;

                if type(p13) == "table" then
                    v14 = Copy.deepCopy(p13) or p13;
                else
                    v14 = p13;
                end;

                u4 = v14;
            else
                if u4 == nil or type(u4) ~= "table" then
                    u4 = {};
                end;

                _setNested(u4, p12, p13);
            end;

            for _, v in u5 do
                task.defer(v, p12, p13);
            end;
        end);

        return;
    end;

    if u3 then
        NetWork.RegisterServerRemoteEvent(NetMsg.PLAYER_DATA_REQUEST, function(p15) -- Line: 163
            -- upvalues: u1 (ref)
            if not p15 or (not p15:IsA("Player") or p15.Parent == nil) then
                return;
            end;

            local v16 = u1.GetPlrData(p15);

            if v16 then
                u1.Update(p15, nil, v16);
            end;
        end);
    end;
end;

function u1.ListenClientSync(p17) -- Line: 185
    -- upvalues: u2 (copy), u5 (copy)
    if not u2 then
        return;
    end;

    table.insert(u5, p17);
end;

function u1.GetPlrData(p18) -- Line: 201
    -- upvalues: u2 (copy), u4 (ref), Copy (copy), UtilsSystem (copy)
    if not u2 then
        return UtilsSystem.SystemSave.GetStat(p18);
    end;

    if u4 == nil then
        return nil;
    end;

    if type(u4) == "table" then
        return Copy.deepCopy(u4);
    end;

    return u4;
end;

function u1.GetPlrDataByKey(p19, p20) -- Line: 220
    -- upvalues: u1 (copy), _getNested (copy)
    return _getNested(u1.GetPlrData(p19), p20);
end;

function u1.ChangePlrData(p21, p22, p23) -- Line: 232
    -- upvalues: u3 (copy), UtilsSystem (copy)
    if u3 then
        return UtilsSystem.SystemSave.ChangeStat(p21, p22, p23);
    end;

    return false, "SERVER_ONLY";
end;

function u1.Update(p24, p25, p26) -- Line: 246
    -- upvalues: u3 (copy), NetWork (copy), NetMsg (copy)
    if not u3 then
        return;
    end;

    NetWork.FireClient(p24, NetMsg.PLAYER_DATA_SYNC, p25, p26);
end;

u1.RegisterNetWork();

return u1;