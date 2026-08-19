-- Decompiled with Potassium's decompiler.

local u1 = {};

local function disconnectBinding(p2) -- Line: 43
    if p2.Connection then
        p2.Connection:Disconnect();
        p2.Connection = nil;
    end;

    if p2.BackpackChangedConn then
        p2.BackpackChangedConn:Disconnect();
        p2.BackpackChangedConn = nil;
    end;
end;

local function attach(p3, p4, p5) -- Line: 54
    if p5.Connection then
        p5.Connection:Disconnect();
        p5.Connection = nil;
    end;

    local v6 = p3:FindFirstChildOfClass("Backpack");

    if not v6 then
        return;
    end;

    p5.Connection = v6.ChildAdded:Connect(p4);
end;

local function bindBackpackChange(u7, u8, u9) -- Line: 66
    u9.BackpackChangedConn = u7.ChildAdded:Connect(function(p10) -- Line: 69
        -- upvalues: u7 (copy), u8 (copy), u9 (copy)
        if p10:IsA("Backpack") then
            local v11 = u9;

            if v11.Connection then
                v11.Connection:Disconnect();
                v11.Connection = nil;
            end;

            local v12 = u7:FindFirstChildOfClass("Backpack");

            if not v12 then
                return;
            end;

            v11.Connection = v12.ChildAdded:Connect(u8);
        end;
    end);
end;

game:GetService("Players").PlayerRemoving:Connect(function(p13) -- Line: 110
    -- upvalues: u1 (copy)
    local v14 = u1[p13];

    if not v14 then
        return;
    end;

    for _, v in v14 do
        if v.Connection then
            v.Connection:Disconnect();
            v.Connection = nil;
        end;

        if v.BackpackChangedConn then
            v.BackpackChangedConn:Disconnect();
            v.BackpackChangedConn = nil;
        end;
    end;

    u1[p13] = nil;
end);

return {
    bind = function(u15, u16) -- Line: 78, Name: bind
        -- upvalues: u1 (copy)
        if not (u15 and u16) then
            return;
        end;

        local v17 = u1[u15];

        if not v17 then
            v17 = {};
            u1[u15] = v17;
        end;

        if v17[u16] then
            return;
        end;

        local u18 = {
            Connection = nil,
            BackpackChangedConn = nil
        };
        v17[u16] = u18;

        if u18.Connection then
            u18.Connection:Disconnect();
            u18.Connection = nil;
        end;

        local v19 = u15:FindFirstChildOfClass("Backpack");

        if v19 then
            u18.Connection = v19.ChildAdded:Connect(u16);
        end;

        u18.BackpackChangedConn = u15.ChildAdded:Connect(function(p20) -- Line: 69
            -- upvalues: u15 (copy), u16 (copy), u18 (copy)
            if p20:IsA("Backpack") then
                local v21 = u18;

                if v21.Connection then
                    v21.Connection:Disconnect();
                    v21.Connection = nil;
                end;

                local v22 = u15:FindFirstChildOfClass("Backpack");

                if not v22 then
                    return;
                end;

                v21.Connection = v22.ChildAdded:Connect(u16);
            end;
        end);
    end,

    unbind = function(p23, p24) -- Line: 98, Name: unbind
        -- upvalues: u1 (copy)
        local v25 = u1[p23];

        if not v25 then
            return;
        end;

        local v26 = v25[p24];

        if not v26 then
            return;
        end;

        if v26.Connection then
            v26.Connection:Disconnect();
            v26.Connection = nil;
        end;

        if v26.BackpackChangedConn then
            v26.BackpackChangedConn:Disconnect();
            v26.BackpackChangedConn = nil;
        end;

        v25[p24] = nil;

        if next(v25) == nil then
            u1[p23] = nil;
        end;
    end
};