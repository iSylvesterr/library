-- Decompiled with Potassium's decompiler.

local function defaultGuard(p1) -- Line: 20
    return true;
end;

return function(u2, u3, u4, u5) -- Line: 61, Name: observeAttribute
    -- upvalues: defaultGuard (copy)
    local u6 = nil;
    local u7 = nil;
    local u8 = 0;

    if u5 == nil then
        u5 = defaultGuard;
    end;

    local function OnAttributeChanged() -- Line: 74
        -- upvalues: u6 (ref), u8 (ref), u2 (copy), u3 (copy), u5 (copy), u4 (copy), u7 (ref)
        if u6 ~= nil then
            task.spawn(u6);
            u6 = nil;
        end;

        u8 = u8 + 1;
        local u9 = u8;
        local u10 = u2:GetAttribute(u3);

        if u10 ~= nil and u5(u10) then
            task.spawn(function() -- Line: 86
                -- upvalues: u4 (ref), u10 (copy), u9 (copy), u8 (ref), u7 (ref), u6 (ref)
                local v11 = u4(u10);

                if u9 == u8 and u7.Connected then
                    u6 = v11;

                    return;
                end;

                task.spawn(v11);
            end);
        end;
    end;

    u7 = u2:GetAttributeChangedSignal(u3):Connect(OnAttributeChanged);
    task.defer(function() -- Line: 101
        -- upvalues: u7 (ref), OnAttributeChanged (copy)
        if not u7.Connected then
            return;
        end;

        OnAttributeChanged();
    end);

    return function() -- Line: 110
        -- upvalues: u7 (ref), u6 (ref)
        u7:Disconnect();

        if u6 ~= nil then
            task.spawn(u6);
            u6 = nil;
        end;
    end;
end;