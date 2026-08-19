-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5, p6) -- Line: 38
    -- upvalues: u1 (copy)
    local v7 = setmetatable({}, u1);
    v7._min = p2;
    v7._max = p3;
    v7._kp = p4;
    v7._ki = p5;
    v7._kd = p6;
    v7._lastError = 0;
    v7._integralSum = 0;

    return v7;
end;

function u1.Reset(p8) -- Line: 53
    p8._lastError = 0;
    p8._integralSum = 0;
end;

function u1.Calculate(p9, p10, p11, p12) -- Line: 78
    local v13 = p10 - p11;
    local v14 = p9._kp * v13;
    p9._integralSum = p9._integralSum + v13 * p12;
    local v15 = math.clamp(v14 + p9._ki * p9._integralSum + p9._kd * ((v13 - p9._lastError) / p12), p9._min, p9._max);
    p9._lastError = v13;

    return v15;
end;

function u1.Debug(u16, p17, p18) -- Line: 116
    -- upvalues: u1 (copy)
    if not game:GetService("RunService"):IsStudio() then
        return;
    end;

    if u16._debug then
        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p17;
    Folder:AddTag("PIDDebug");

    local function Bind(u19, u20) -- Line: 129
        -- upvalues: Folder (copy), u16 (copy)
        Folder:SetAttribute(u19, u16[u20]);
        Folder:GetAttributeChangedSignal(u19):Connect(function() -- Line: 131
            -- upvalues: u16 (ref), u20 (copy), Folder (ref), u19 (copy)
            u16[u20] = Folder:GetAttribute(u19);
            u16:Reset();
        end);
    end;

    Folder:SetAttribute("MinMax", NumberRange.new(u16._min, u16._max));
    Folder:GetAttributeChangedSignal("MinMax"):Connect(function() -- Line: 138
        -- upvalues: Folder (copy), u16 (copy)
        local v21 = Folder:GetAttribute("MinMax");
        u16._min = v21.Min;
        u16._max = v21.Max;
        u16:Reset();
    end);
    Folder:SetAttribute("kP", u16._kp);
    local u22 = "_kp";
    local u23 = "kP";
    Folder:GetAttributeChangedSignal("kP"):Connect(function() -- Line: 131
        -- upvalues: u16 (copy), u22 (copy), Folder (copy), u23 (copy)
        u16[u22] = Folder:GetAttribute(u23);
        u16:Reset();
    end);
    Folder:SetAttribute("kI", u16._ki);
    local u24 = "_ki";
    local u25 = "kI";
    Folder:GetAttributeChangedSignal("kI"):Connect(function() -- Line: 131
        -- upvalues: u16 (copy), u24 (copy), Folder (copy), u25 (copy)
        u16[u24] = Folder:GetAttribute(u25);
        u16:Reset();
    end);
    Folder:SetAttribute("kD", u16._kd);
    local u26 = "_kd";
    local u27 = "kD";
    Folder:GetAttributeChangedSignal("kD"):Connect(function() -- Line: 131
        -- upvalues: u16 (copy), u26 (copy), Folder (copy), u27 (copy)
        u16[u26] = Folder:GetAttribute(u27);
        u16:Reset();
    end);
    Folder:SetAttribute("Output", u16._min);
    local u28 = 0;

    function u16.Calculate(p29, p30, p31, ...) -- Line: 152
        -- upvalues: u28 (ref), u1 (ref), Folder (copy)
        u28 = u1.Calculate(p29, p30, p31, ...);
        Folder:SetAttribute("Output", u28);

        return u28;
    end;

    local u32 = nil;
    Folder:SetAttribute("ShowDebugger", false);
    Folder:GetAttributeChangedSignal("ShowDebugger"):Connect(function() -- Line: 160
        -- upvalues: u32 (ref), Folder (copy)
        if u32 then
            task.cancel(u32);
        end;

        if Folder:GetAttribute("ShowDebugger") then
            u32 = task.delay(0.1, function() -- Line: 168
                -- upvalues: u32 (ref), Folder (ref)
                u32 = nil;

                if Folder:GetAttribute("ShowDebugger") then
                    Folder:SetAttribute("ShowDebugger", false);
                    warn("Install the PID Debug plugin: https://create.roblox.com/store/asset/16279661108/PID-Debug");
                end;
            end);
        end;
    end);
    Folder.Parent = p18 or workspace;
    u16._debug = Folder;
end;

function u1.Destroy(p33) -- Line: 185
    if p33._debug then
        p33._debug:Destroy();
        p33._debug = nil;
    end;
end;

return {
    new = u1.new
};