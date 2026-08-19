-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local SocialService = game:GetService("SocialService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Icon = require(game.ReplicatedStorage.ClientSideCode.Tool.TopbarPlus.Icon);
local InsMgr = UtilsSystem.InsMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = InsMgr.GetIns("事件通知", "Folder", LocalPlayer);

local function _tableToUtcTime(p5) -- Line: 77
    return DateTime.fromUniversalTime(p5.Year, p5.Month, p5.Day, p5.Hour, p5.Minute, p5.Second, p5.Millisecond).UnixTimestamp;
end;

local function _filterUpcomingEvents(p6) -- Line: 104
    local v7 = {};
    local v8 = nil;

    for _, v in ipairs(p6) do
        if not v.HasStarted then
            v7[v.Title] = v;

            if not v8 then
                v8 = v.Title;
            end;
        end;
    end;

    return v7, v8;
end;

local function _initializeEventRsvpStatus(p9) -- Line: 125
    -- upvalues: InsMgr (copy), u4 (copy)
    local v10 = false;

    for i, v in pairs(p9) do
        local v11 = InsMgr.GetIns(i, "NumberValue", u4);

        if v.UserRsvpStatus == Enum.RsvpStatus.Going then
            v11.Value = 1;
        else
            v11.Value = 0;
            v10 = true;
        end;
    end;

    return v10;
end;

local function _createEventIcon(u12) -- Line: 146
    -- upvalues: Icon (copy), NetWork (copy), NetMsg (copy), u3 (ref)
    local u13 = Icon.new():setName("Event"):setLabel("EVENT!"):setRight():setOrder(6):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    u13:bindEvent("selected", function() -- Line: 155
        -- upvalues: NetWork (ref), NetMsg (ref), u12 (copy), u13 (copy)
        NetWork.FireBindable(NetMsg.EVENT_NOTIFY, u12);
        u13:deselect();
    end);
    u3 = u13;
end;

local function _handleEventRsvp(p14) -- Line: 168
    -- upvalues: u2 (ref), u1 (ref), Workspace (copy), u4 (copy), SocialService (copy), u3 (ref)
    if u2 then
        return;
    end;

    local v15 = u1[p14];

    if not (v15 and v15.Id) then
        return;
    end;

    local StartTime = v15.StartTime;

    if DateTime.fromUniversalTime(StartTime.Year, StartTime.Month, StartTime.Day, StartTime.Hour, StartTime.Minute, StartTime.Second, StartTime.Millisecond).UnixTimestamp < Workspace:GetServerTimeNow() then
        return;
    end;

    local v16 = u4:FindFirstChild(p14);

    if not (v16 and v16:IsA("NumberValue")) then
        return;
    end;

    u2 = p14;
    local v17 = SocialService:PromptRsvpToEventAsync(v15.Id);
    u2 = nil;

    if v17 == Enum.RsvpStatus.Going then
        v16.Value = 1;

        if u3 then
            u3:destroy();
            u3 = nil;
        end;
    else
        v16.Value = 0;
    end;
end;

local function _scheduleEventNotification(u18, p19) -- Line: 210
    -- upvalues: u4 (copy), NetWork (copy), NetMsg (copy)
    task.delay(p19, function() -- Line: 211
        -- upvalues: u4 (ref), u18 (copy), NetWork (ref), NetMsg (ref)
        local v20 = u4:FindFirstChild(u18);

        if v20 and (v20:IsA("NumberValue") and v20.Value == 0) then
            NetWork.FireBindable(NetMsg.EVENT_NOTIFY, u18);
        end;
    end);
end;

local success, result = pcall(function() -- Line: 225
    -- upvalues: SocialService (copy)
    return SocialService:GetUpcomingExperienceEventsAsync();
end);

if not success then
    warn("获取体验事件失败:", result);

    return;
end;

local v21, u22 = _filterUpcomingEvents(result);
u1 = v21;
_initializeEventRsvpStatus(u1);

if u22 then
    local v23 = u1[u22];

    if v23 and v23.Id ~= nil then
        local v24 = tostring(v23.Id);

        if v24 ~= "" then
            u4:SetAttribute("NextEventId", v24);
        end;
    end;
end;

NetWork.RegisterBindableEvent(NetMsg.EVENT_NOTIFY, _handleEventRsvp);

if u22 then
    local v25 = LocalPlayer:FindFirstChild("IsNewPlayer") or LocalPlayer:WaitForChild("IsNewPlayer", (1 / 0));

    if v25 and v25:IsA("BoolValue") then
        task.delay(v25.Value and 300 or 10, function() -- Line: 211
            -- upvalues: u4 (copy), u22 (copy), NetWork (copy), NetMsg (copy)
            local v26 = u4:FindFirstChild(u22);

            if v26 and (v26:IsA("NumberValue") and v26.Value == 0) then
                NetWork.FireBindable(NetMsg.EVENT_NOTIFY, u22);
            end;
        end);
    end;
end;