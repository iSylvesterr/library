-- Decompiled with Potassium's decompiler.

local NotificationInstance = require(script.NotificationInstance);
local Network = require(game.ReplicatedStorage.Library.Client.Network);
local Types = require(game.ReplicatedStorage.Library.Items.Types);
local v1 = {
    Message = require(script.Message),
    Item = require(script.Item)
};
local u2 = setmetatable(v1, {
    __index = NotificationInstance
});

for _, v in pairs(u2) do
    if not v.Top then
        function v.Top() -- Line: 20
            error("Unimplemented");
        end;
    end;

    if not v.Bottom then
        function v.Bottom() -- Line: 25
            error("Unimplemented");
        end;
    end;
end;

local function processNotificationData(p3) -- Line: 30
    -- upvalues: Types (copy)
    if not (p3 and (p3.Data and p3.Path)) then
        return p3;
    end;

    local function processData(p4, p5) -- Line: 35
        -- upvalues: Types (ref), processData (copy)
        local v6 = {};

        for i, v in pairs(p4) do
            if type(v) == "table" and (p5 and p5[i] == true) then
                v6[i] = Types.From(v.class, v.data);
            elseif type(v) == "table" then
                local v7;

                if p5 then
                    v7 = p5[i];
                else
                    v7 = p5;
                end;

                v6[i] = processData(v, v7);
            else
                v6[i] = v;
            end;
        end;

        return v6;
    end;

    return processData(p3.Data, p3.Path);
end;

Network.Fired(Network.NET_MAP.Notifications.SHOW):Connect(function(p8, p9, p10, p11) -- Line: 53
    -- upvalues: u2 (copy), Types (copy)
    local v12 = u2[p8];
    local v13 = "NotificationModule does not contain notification type: " .. tostring(p8);
    assert(v12, v13);

    if p9 ~= "Top" then
        if p9 == "Bottom" then
            local Bottom = u2[p8].Bottom;

            if p10 and (p10.Data and p10.Path) then
                local function u18(p14, p15) -- Line: 35
                    -- upvalues: Types (ref), u18 (copy)
                    local v16 = {};

                    for i, v in pairs(p14) do
                        if type(v) == "table" and (p15 and p15[i] == true) then
                            v16[i] = Types.From(v.class, v.data);
                        elseif type(v) == "table" then
                            local v17;

                            if p15 then
                                v17 = p15[i];
                            else
                                v17 = p15;
                            end;

                            v16[i] = u18(v, v17);
                        else
                            v16[i] = v;
                        end;
                    end;

                    return v16;
                end;

                p10 = u18(p10.Data, p10.Path);
            end;

            Bottom(p10, p11);
        end;

        return;
    end;

    local Top = u2[p8].Top;

    if p10 and (p10.Data and p10.Path) then
        local function u23(p19, p20) -- Line: 35
            -- upvalues: Types (ref), u23 (copy)
            local v21 = {};

            for i, v in pairs(p19) do
                if type(v) == "table" and (p20 and p20[i] == true) then
                    v21[i] = Types.From(v.class, v.data);
                elseif type(v) == "table" then
                    local v22;

                    if p20 then
                        v22 = p20[i];
                    else
                        v22 = p20;
                    end;

                    v21[i] = u23(v, v22);
                else
                    v21[i] = v;
                end;
            end;

            return v21;
        end;

        p10 = u23(p10.Data, p10.Path);
    end;

    Top(p10, p11);
end);

function u2.IsTopShowing() -- Line: 68
    -- upvalues: NotificationInstance (copy)
    return NotificationInstance.HasCurrentTopNotification();
end;

return u2;