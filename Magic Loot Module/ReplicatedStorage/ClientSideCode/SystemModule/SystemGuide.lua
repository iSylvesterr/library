-- Decompiled with Potassium's decompiler.

local u1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local SystemRecord = UtilsSystem.SystemRecord;
local GetData = UtilsSystem.GetData;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local RunService = UtilsSystem.RunService;
local u2;

if RunService:IsServer() then
    u2 = InsMgr.GetIns(script.Name .. "RemoteEvent", "RemoteEvent", game.ReplicatedStorage.Msg.RemoteEvent);
    u2.OnServerEvent:Connect(function(p3, p4, p5, p6) -- Line: 36
        -- upvalues: u1 (copy)
        u1.CompleteGuide(p3, p4, p5, p6);
    end);
else
    u2 = game.ReplicatedStorage.Msg.RemoteEvent:WaitForChild(script.Name .. "RemoteEvent", (1 / 0));
end;

local function SetGuideName(p7, p8, p9) -- Line: 45
    -- upvalues: InsMgr (copy)
    local v10 = InsMgr.GetIns("GuideName", "StringValue", p7);

    if p8 == "" or p8 == nil then
        v10.Value = "";

        return;
    end;

    v10.Value = p8 .. "|" .. p9;
end;

function u1.Update(p11) -- Line: 64
    -- upvalues: RunService (copy), u1 (copy), NetWork (copy), NetMsg (copy)
    if RunService:IsServer() then
        if p11 then
            u1.Init(p11);
        end;

        return;
    end;

    NetWork.FireServer(NetMsg.GUIDE_REFRESH);
end;

function u1.RegisterNetWork() -- Line: 78
    -- upvalues: RunService (copy), NetWork (copy), NetMsg (copy), u1 (copy)
    if not RunService:IsServer() then
        return;
    end;

    NetWork.RegisterServerRemoteEvent(NetMsg.GUIDE_REFRESH, function(p12) -- Line: 82
        -- upvalues: u1 (ref)
        u1.Init(p12);
    end);
end;

function u1.CompleteGuide(p13, p14, p15, p16) -- Line: 89
    -- upvalues: RunService (copy), SystemRecord (copy), InsMgr (copy), GetData (copy), u1 (copy), u2 (ref)
    if RunService:IsServer() then
        if p16 == true then
            SystemRecord.RecordCover(p13, "Guide_" .. p14, p15);
        end;

        local v17 = InsMgr.GetIns("GuideName", "StringValue", p13);

        if v17.Value ~= "" then
            local v18, v19 = GetData.parseGuideName(v17.Value);

            if v18 == p14 and tostring(v19) == tostring(p15) then
                if p16 == true then
                    local v20 = InsMgr.GetIns("GuideName", "StringValue", p13);

                    if p14 == "" or p14 == nil then
                        v20.Value = "";
                    else
                        v20.Value = p14 .. "|" .. p15;
                    end;
                elseif (SystemRecord.GetDataByID(p13, "Guide_" .. p14) or 0) < p15 then
                    SystemRecord.RecordCover(p13, "Guide_" .. p14, p15);
                end;

                u1.Init(p13);

                return;
            end;
        end;

        if p16 == true then
            u1.Init(p13);
        end;
    else
        local v21 = InsMgr.GetIns("GuideName", "StringValue", p13);

        if v21.Value ~= "" then
            local v22, v23 = GetData.parseGuideName(v21.Value);

            if v22 == p14 and tostring(v23) == tostring(p15) then
                v21.Value = "";
            end;
        end;

        u2:FireServer(p14, p15, p16);
    end;
end;

local v24 = SystemGameConfig.GetValue("引导");
local u25 = {};

for i, v in pairs(v24 and v24.Cfg or {}) do
    if type(v) == "table" then
        local v26 = {
            key = i,
            order = tonumber(v.Order) or (1 / 0),
            stages = v
        };
        table.insert(u25, v26);
    end;
end;

table.sort(u25, function(p27, p28) -- Line: 170
    if p27.order == p28.order then
        return p27.key < p28.key;
    end;

    return p27.order < p28.order;
end);

function u1.Init(p29, p30) -- Line: 177
    -- upvalues: InsMgr (copy), u25 (copy), SystemRecord (copy)
    InsMgr.GetIns("GuideName", "StringValue", p29);

    for _, v in ipairs(u25) do
        local key = v.key;
        local stages = v.stages;
        local v31 = 0;

        for i, v2 in pairs(stages) do
            local v32 = tonumber(i);

            if v32 and (type(v2) == "table" and v31 < v32) then
                v31 = v32;
            end;
        end;

        if v31 > 0 then
            local v33 = SystemRecord.GetDataByID(p29, "Guide_" .. key) or 0;

            if v33 < v31 then
                if stages.Check == nil or stages.Check(p29) == true then
                    local v34 = v33 + 1;

                    if p30 and stages.ReStart == true then
                        SystemRecord.RecordCover(p29, "Guide_" .. key, 0);
                        v34 = 1;
                    end;

                    local v35 = InsMgr.GetIns("GuideName", "StringValue", p29);

                    if key == "" or key == nil then
                        v35.Value = "";

                        return;
                    end;

                    v35.Value = key .. "|" .. v34;

                    return;
                end;

                if stages.SkipWhenCheckFails ~= true then
                    InsMgr.GetIns("GuideName", "StringValue", p29).Value = "";

                    return;
                end;
            end;
        end;
    end;

    InsMgr.GetIns("GuideName", "StringValue", p29).Value = "";
end;

function u1.RestartGuide(u36, u37, u38) -- Line: 234
    -- upvalues: GetData (copy), u1 (copy)
    task.spawn(function() -- Line: 236
        -- upvalues: u36 (copy), GetData (ref), u37 (copy), u1 (ref), u38 (copy)
        local GuideName = u36:FindFirstChild("GuideName");

        if GuideName and GuideName.Value ~= "" then
            local v39, _ = GetData.parseGuideName(GuideName.Value);

            if v39 == u37 then
                u1.CompleteGuide(u36, v39, u38, true);
            end;
        end;
    end);
end;

if RunService:IsServer() then
    u1.RegisterNetWork();
end;

return u1;