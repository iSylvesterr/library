-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Tween = require(game.ReplicatedStorage.Library.Functions.Tween);
local DeepCopyUnsafe = require(game.ReplicatedStorage.Library.Functions.DeepCopyUnsafe);
local Easing = require(game.ReplicatedStorage.Library.Functions.Easing);
local GUI = require(game.ReplicatedStorage.Library.Client.GUI);
local Variables = require(game.ReplicatedStorage.Library.Variables);
local Signal = require(game.ReplicatedStorage.Library.Signal);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = {
    Loading = true,
    InProgress = true,
    RoundEnd = true
};
local u2 = {
    Locations = {
        Top = 1,
        Bottom = 2,
        Right = 3,
        Left = 4,
        Message = 5
    }
};
local u3 = {
    top = {},
    bottom = {},
    message = {}
};
local u4 = {
    Time = 3,
    Force = false,
    DelayInRound = false,
    PreventDuplicateText = false
};
local v5 = GUI.Notifications();
local Top = v5:WaitForChild("Top");
local u6 = nil;
local LocalPlayer = Players.LocalPlayer;
local u7 = false;
local MurderMystery = Constants.NETWORK_MAP.MurderMystery;

local function refreshLocalPlayerRoundParticipation(p8) -- Line: 61
    -- upvalues: LocalPlayer (copy), u7 (ref)
    local v9 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";

    if p8 ~= nil then
        u7 = p8;

        return;
    end;

    local v10 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v9 ~= "Waiting";
    u7 = v10;
end;

local function shouldDelayNotificationInRound(p11) -- Line: 72
    -- upvalues: LocalPlayer (copy), u7 (ref), u1 (copy)
    if not p11.config.DelayInRound then
        return false;
    end;

    local v12 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";

    return u7 and u1[v12] == true;
end;

local u13 = {
    [u2.Locations.Bottom] = {
        maxVisible = 3,
        queue = u3.bottom,
        active = {},
        parentGui = v5:WaitForChild("Bottom")
    },
    [u2.Locations.Message] = {
        maxVisible = 3,
        queue = u3.message,
        active = {},
        parentGui = v5:WaitForChild("MessageTop")
    }
};

local function getQueueForLocation(p14) -- Line: 104
    -- upvalues: u2 (copy), u3 (copy)
    return p14.location == u2.Locations.Top and u3.top or p14.location == u2.Locations.Bottom and u3.bottom or (p14.location == u2.Locations.Message and u3.message or nil);
end;

local function matchesDuplicateKey(p15, p16) -- Line: 111
    return p15.config.DuplicateKey == p16;
end;

local function hasDuplicateNotification(p17) -- Line: 115
    -- upvalues: u6 (ref), u3 (copy), u13 (copy)
    if p17 == nil then
        return false;
    end;

    if u6 ~= nil and u6.config.DuplicateKey == p17 then
        return true;
    end;

    for _, v in pairs(u3) do
        for _, v2 in ipairs(v) do
            if v2.config.DuplicateKey == p17 then
                return true;
            end;
        end;
    end;

    for _, v in pairs(u13) do
        for _, v2 in ipairs(v.active) do
            if v2.config.DuplicateKey == p17 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function addToQueue(p18) -- Line: 143
    -- upvalues: Variables (copy), hasDuplicateNotification (copy), u2 (copy), u3 (copy)
    if Variables.Locks.DisableNotifications:IsLocked() and not p18.config.Force then
        return;
    end;

    if hasDuplicateNotification(p18.config.DuplicateKey) then
        return;
    end;

    local v19 = assert(p18.location == u2.Locations.Top and u3.top or p18.location == u2.Locations.Bottom and u3.bottom or (p18.location == u2.Locations.Message and u3.message or nil));

    if u3.top == v19 and #v19 >= 6 then
        return;
    end;

    if (u3.bottom == v19 or u3.message == v19) and #v19 >= 20 then
        return;
    end;

    table.insert(v19, p18);
end;

local function popNextRenderableNotification(p20) -- Line: 168
    -- upvalues: LocalPlayer (copy), u7 (ref), u1 (copy)
    for i, v in ipairs(p20) do
        local v21;

        if v.config.DelayInRound then
            local v22 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";
            v21 = u7 and u1[v22] == true;
        else
            v21 = false;
        end;

        if not v21 then
            return table.remove(p20, i);
        end;
    end;

    return nil;
end;

local function handleTopNotifications() -- Line: 178
    -- upvalues: u3 (copy), RunService (copy), u6 (ref), popNextRenderableNotification (copy), Variables (copy), Top (copy), Tween (copy)
    local top = u3.top;
    local u23 = nil;
    RunService.RenderStepped:Connect(function() -- Line: 182
        -- upvalues: top (copy), u6 (ref), popNextRenderableNotification (ref), u23 (ref), Variables (ref), Top (ref), Tween (ref)
        if #top == 0 or u6 ~= nil then
            return;
        end;

        local v24 = popNextRenderableNotification(top);

        if not v24 then
            return;
        end;

        if u23 then
            local v25 = u23 - workspace:GetServerTimeNow();

            if math.abs(v25) < 0.5 then
                table.insert(top, 1, v24);

                return;
            end;
        end;

        u23 = workspace:GetServerTimeNow();
        Variables.HideProgressUI = true;
        u6 = v24;
        u6.created = tick();
        local u26 = UDim2.new(0.5, 0, 0, -Top.AbsoluteSize.Y - 40);
        Top.Position = u26;
        u6.frame.Parent = Top;
        Top.Visible = true;
        Tween(Top, {
            Position = UDim2.fromScale(0.5, 0)
        }, { 0.65, "Sine", "Out" });

        for _, v in ipairs(u6.started) do
            task.spawn(v, u6.frame);
        end;

        task.delay(u6.config.Time, function() -- Line: 221
            -- upvalues: u6 (ref), Tween (ref), Top (ref), u26 (copy), top (ref), Variables (ref)
            local u27 = u6;
            Tween(Top, {
                Position = u26
            }, { 0.35, "Quad", "Out" }).Completed:Connect(function() -- Line: 229
                -- upvalues: u6 (ref), Top (ref), u27 (copy), top (ref), Variables (ref)
                u6 = nil;
                Top.Visible = false;

                if u27 then
                    for _, v in ipairs(u27.completed) do
                        task.spawn(v, u27.frame);
                    end;

                    u27.frame:Destroy();
                end;

                Variables.HideProgressUI = #top > 0;
            end);
        end);
    end);
end;

local function fadeOutNotification(p28, p29) -- Line: 251
    -- upvalues: Easing (copy), RunService (copy)
    local v30 = assert(p28:FindFirstChildOfClass("UIGradient"));
    v30.Rotation = 45;
    local v31 = tick();
    local v32;

    if p29 then
        v32 = 0.1;
    else
        v32 = 0.35;
    end;

    while p28 and p28.Parent do
        local v33 = (tick() - v31) / v32;
        local v34 = math.clamp(v33, 0, 1);
        v30.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Easing(v34, "Sine", "InOut")), NumberSequenceKeypoint.new(1 - v34 * 0.99, Easing(v34, "Sine", "Out")), NumberSequenceKeypoint.new(1, Easing(v34, "Sine", "Out")) });
        RunService.RenderStepped:Wait();

        if v34 >= 1 then
            break;
        end;
    end;
end;

local function startInlineHandler(p35) -- Line: 272
    -- upvalues: RunService (copy), fadeOutNotification (copy), popNextRenderableNotification (copy), Tween (copy)
    local queue = p35.queue;
    local maxVisible = p35.maxVisible;
    local u36 = 0;
    local u37 = nil;
    local active = p35.active;
    local parentGui = p35.parentGui;
    RunService.RenderStepped:Connect(function() -- Line: 280
        -- upvalues: active (copy), fadeOutNotification (ref), maxVisible (copy), u37 (ref), popNextRenderableNotification (ref), queue (copy), u36 (ref), parentGui (copy), Tween (ref)
        local v38 = tick();

        for i = #active, 1, -1 do
            if v38 - active[i].created > active[i].config.Time and not active[i].tweening then
                active[i].tweening = true;
                local u39 = active[i];
                task.spawn(function() -- Line: 307
                    -- upvalues: fadeOutNotification (ref), u39 (copy), active (ref)
                    fadeOutNotification(u39.frame);

                    for _, v in ipairs(u39.completed) do
                        task.spawn(v, u39.frame);
                    end;

                    u39.frame:Destroy();

                    for i2, v in ipairs(active) do
                        if u39 == v then
                            table.remove(active, i2);
                        end;
                    end;
                end);
            end;
        end;

        while #active < maxVisible do
            if u37 then
                local v40 = u37 - workspace:GetServerTimeNow();

                if math.abs(v40) < 0.1 then
                    break;
                end;
            end;

            local v41 = popNextRenderableNotification(queue);

            if not v41 then
                break;
            end;

            u37 = workspace:GetServerTimeNow();
            u36 = u36 + 1;
            v41.created = tick();
            table.insert(active, v41);
            local v42 = v41.frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale");
            v42.Parent = v41.frame;
            v42.Scale = 1.35;
            Instance.new("UIGradient").Parent = v41.frame;
            v41.frame.AnchorPoint = Vector2.new(0.5, 0.5);
            v41.frame.LayoutOrder = u36;
            v41.frame.Parent = parentGui;
            Tween(v42, {
                Scale = 1
            }, { 0.35, "Back", "Out" });

            for _, v in ipairs(v41.started) do
                task.spawn(v, v41.frame);
            end;
        end;
    end);
end;

local u43 = t.interface({
    Time = t.optional(t.number),
    Force = t.optional(t.boolean),
    DelayInRound = t.optional(t.boolean),
    PreventDuplicateText = t.optional(t.boolean),
    DuplicateKey = t.optional(t.string)
});

function u2.new(p44, p45, p46, p47, p48) -- Line: 393
    -- upvalues: DeepCopyUnsafe (copy), u4 (copy), u43 (copy), u2 (copy), addToQueue (copy)
    local v49 = DeepCopyUnsafe(u4);
    local v50;

    if typeof(p47) == "function" then
        p48 = p47;
        v50 = {};
    else
        v50 = p47 or {};
    end;

    assert(u43(v50));

    for i, v in pairs(v50) do
        v49[i] = v;
    end;

    local v51 = setmetatable({
        created = nil,
        location = p44,
        frame = p45,
        config = v49,
        started = { p46 or function() -- Line: 422
            end },
        completed = { p48 or function() -- Line: 423
            end }
    }, {
        __index = u2
    });
    addToQueue(v51);

    return v51;
end;

function u2.HasCurrentTopNotification() -- Line: 433
    -- upvalues: u6 (ref)
    return u6 ~= nil;
end;

function u2.GetBottomRenders() -- Line: 437
    -- upvalues: u13 (copy), u2 (copy)
    return u13[u2.Locations.Bottom].active;
end;

task.spawn(handleTopNotifications);

for _, v in pairs(u13) do
    local queue = v.queue;
    local maxVisible = v.maxVisible;
    local u52 = 0;
    local u53 = nil;
    local active = v.active;
    local parentGui = v.parentGui;
    RunService.RenderStepped:Connect(function() -- Line: 280
        -- upvalues: active (copy), fadeOutNotification (copy), maxVisible (copy), u53 (ref), popNextRenderableNotification (copy), queue (copy), u52 (ref), parentGui (copy), Tween (copy)
        local v54 = tick();

        for i = #active, 1, -1 do
            if v54 - active[i].created > active[i].config.Time and not active[i].tweening then
                active[i].tweening = true;
                local u55 = active[i];
                task.spawn(function() -- Line: 307
                    -- upvalues: fadeOutNotification (ref), u55 (copy), active (ref)
                    fadeOutNotification(u55.frame);

                    for _, v2 in ipairs(u55.completed) do
                        task.spawn(v2, u55.frame);
                    end;

                    u55.frame:Destroy();

                    for i2, v2 in ipairs(active) do
                        if u55 == v2 then
                            table.remove(active, i2);
                        end;
                    end;
                end);
            end;
        end;

        while #active < maxVisible do
            if u53 then
                local v56 = u53 - workspace:GetServerTimeNow();

                if math.abs(v56) < 0.1 then
                    break;
                end;
            end;

            local v57 = popNextRenderableNotification(queue);

            if not v57 then
                break;
            end;

            u53 = workspace:GetServerTimeNow();
            u52 = u52 + 1;
            v57.created = tick();
            table.insert(active, v57);
            local v58 = v57.frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale");
            v58.Parent = v57.frame;
            v58.Scale = 1.35;
            Instance.new("UIGradient").Parent = v57.frame;
            v57.frame.AnchorPoint = Vector2.new(0.5, 0.5);
            v57.frame.LayoutOrder = u52;
            v57.frame.Parent = parentGui;
            Tween(v58, {
                Scale = 1
            }, { 0.35, "Back", "Out" });

            for _, v2 in ipairs(v57.started) do
                task.spawn(v2, v57.frame);
            end;
        end;
    end);
end;

local v59 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";
local v60 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v59 ~= "Waiting";
u7 = v60;
LocalPlayer:GetAttributeChangedSignal("MurderMysteryRoundState"):Connect(function() -- Line: 447
    -- upvalues: LocalPlayer (copy), u7 (ref)
    if (LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting") == "Waiting" then
        local _ = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";
        u7 = false;

        return;
    end;

    local v61 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";
    local v62 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v61 ~= "Waiting";
    u7 = v62;
end);
LocalPlayer:GetAttributeChangedSignal("MurderMysteryRole"):Connect(function() -- Line: 456
    -- upvalues: LocalPlayer (copy), u7 (ref)
    local v63 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";
    local v64 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v63 ~= "Waiting";
    u7 = v64;
end);
Network.Fired(MurderMystery.ROUND_STATE_CHANGED):Connect(function(p65) -- Line: 459
    -- upvalues: LocalPlayer (copy), u7 (ref)
    if typeof(p65) ~= "table" then
        return;
    end;

    local isParticipant = p65.isParticipant;

    if typeof(isParticipant) ~= "boolean" then
        local v66 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";
        local v67 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v66 ~= "Waiting";
        u7 = v67;

        return;
    end;

    local v68 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting";

    if isParticipant ~= nil then
        u7 = isParticipant;

        return;
    end;

    local v69 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v68 ~= "Waiting";
    u7 = v69;
end);

Signal.Invoked("Notifications: Has Queue").OnInvoke = function() -- Line: 473
    -- upvalues: u6 (ref), u3 (copy)
    return u6 ~= nil and true or #u3.top > 0;
end;

return u2;