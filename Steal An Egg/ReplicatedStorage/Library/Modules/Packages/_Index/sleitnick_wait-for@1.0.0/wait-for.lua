-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Promise = require(script.Parent.Parent.Parent.Promise);
local u1 = {
    Error = {
        Unparented = "Unparented",
        ParentChanged = "ParentChanged"
    }
};

local function PromiseWatchAncestry(p2, p3) -- Line: 40
    -- upvalues: Promise (copy), u1 (copy)
    return Promise.race({ p3, Promise.fromEvent(p2.AncestryChanged, function(p4, p5) -- Line: 43
            return p5 == nil;
        end):andThen(function() -- Line: 45
            -- upvalues: Promise (ref), u1 (ref)
            return Promise.reject(u1.Error.Unparented);
        end) });
end;

function u1.Child(p6, u7, p8) -- Line: 61
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local v9 = p6:FindFirstChild(u7);

    if v9 then
        return Promise.resolve(v9);
    end;

    return PromiseWatchAncestry(p6, Promise.fromEvent(p6.ChildAdded, function(p10) -- Line: 68
        -- upvalues: u7 (copy)
        return p10.Name == u7;
    end):timeout(p8 or 120));
end;

function u1.ChildWhichIsA(p11, u12, p13) -- Line: 94
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local v14 = p11:FindFirstChildWhichIsA(u12);

    if v14 then
        return Promise.resolve(v14);
    end;

    return PromiseWatchAncestry(p11, Promise.fromEvent(p11.ChildAdded, function(p15) -- Line: 101
        -- upvalues: u12 (copy)
        return p15:IsA(u12);
    end):timeout(p13 or 120));
end;

function u1.Children(u16, p17, p18) -- Line: 125
    -- upvalues: u1 (copy), Promise (copy)
    local v19 = table.create(#p17);

    for i, v in ipairs(p17) do
        v19[i] = u1.Child(u16, v, p18);
    end;

    return Promise.all(v19):andThen(function(p20) -- Line: 130
        -- upvalues: u16 (copy), Promise (ref), u1 (ref)
        for _, v in ipairs(p20) do
            if v.Parent ~= u16 then
                return Promise.reject(u1.Error.ParentChanged);
            end;
        end;

        return p20;
    end);
end;

function u1.Descendant(p21, u22, p23) -- Line: 153
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local v24 = p21:FindFirstChild(u22, true);

    if v24 then
        return Promise.resolve(v24);
    end;

    return PromiseWatchAncestry(p21, Promise.fromEvent(p21.DescendantAdded, function(p25) -- Line: 160
        -- upvalues: u22 (copy)
        return p25.Name == u22;
    end):timeout(p23 or 120));
end;

function u1.Descendants(u26, p27, p28) -- Line: 184
    -- upvalues: u1 (copy), Promise (copy)
    local v29 = table.create(#p27);

    for i, v in ipairs(p27) do
        v29[i] = u1.Descendant(u26, v, p28);
    end;

    return Promise.all(v29):andThen(function(p30) -- Line: 189
        -- upvalues: u26 (copy), Promise (ref), u1 (ref)
        for _, v in ipairs(p30) do
            if not v:IsDescendantOf(u26) then
                return Promise.reject(u1.Error.ParentChanged);
            end;
        end;

        return p30;
    end);
end;

function u1.PrimaryPart(u31, p32) -- Line: 210
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local PrimaryPart = u31.PrimaryPart;

    if PrimaryPart then
        return Promise.resolve(PrimaryPart);
    end;

    return PromiseWatchAncestry(u31, Promise.fromEvent(u31:GetPropertyChangedSignal("PrimaryPart"), function() -- Line: 217
        -- upvalues: PrimaryPart (ref), u31 (copy)
        PrimaryPart = u31.PrimaryPart;

        return PrimaryPart ~= nil;
    end):andThen(function() -- Line: 221
        -- upvalues: PrimaryPart (ref)
        return PrimaryPart;
    end):timeout(p32 or 120));
end;

function u1.ObjectValue(p33, p34) -- Line: 238
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local Value = p33.Value;

    if Value then
        return Promise.resolve(Value);
    end;

    return PromiseWatchAncestry(p33, Promise.fromEvent(p33.Changed, function(p35) -- Line: 245
        -- upvalues: Value (ref)
        Value = p35;

        return Value ~= nil;
    end):andThen(function() -- Line: 249
        -- upvalues: Value (ref)
        return Value;
    end):timeout(p34 or 120));
end;

function u1.Custom(u36, p37) -- Line: 268
    -- upvalues: Promise (copy), RunService (copy)
    local v38 = u36();

    if v38 == nil then
        return Promise.new(function(u39, p40, p41) -- Line: 273
            -- upvalues: u36 (copy), RunService (ref)
            local u42 = nil;

            local function OnDone() -- Line: 275
                -- upvalues: u42 (ref)
                u42:Disconnect();
            end;

            u42 = RunService.Heartbeat:Connect(function() -- Line: 278, Name: Update
                -- upvalues: u36 (ref), u42 (ref), u39 (copy)
                local v43 = u36();

                if v43 ~= nil then
                    u42:Disconnect();
                    u39(v43);
                end;
            end);
            p41(OnDone);
        end):timeout(p37 or 120);
    end;

    return Promise.resolve(v38);
end;

return u1;