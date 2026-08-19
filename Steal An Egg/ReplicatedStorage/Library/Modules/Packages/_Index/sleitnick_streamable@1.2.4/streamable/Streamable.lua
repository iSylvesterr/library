-- Decompiled with Potassium's decompiler.

local Trove = require(script.Parent.Parent.Trove);
local Signal = require(script.Parent.Parent.Signal);
local u1 = {};
u1.__index = u1;

function u1.new(p2, u3) -- Line: 96
    -- upvalues: u1 (copy), Trove (copy), Signal (copy)
    local u4 = {};
    setmetatable(u4, u1);
    u4._trove = Trove.new();
    u4._shown = u4._trove:Construct(Signal);
    u4._shownTrove = Trove.new();
    u4._trove:Add(u4._shownTrove);
    u4.Instance = p2:FindFirstChild(u3);

    local function OnInstanceSet() -- Line: 107
        -- upvalues: u4 (copy)
        local Instance = u4.Instance;

        if typeof(Instance) == "Instance" then
            u4._shown:Fire(Instance, u4._shownTrove);
            u4._shownTrove:Connect(Instance:GetPropertyChangedSignal("Parent"), function() -- Line: 111
                -- upvalues: Instance (copy), u4 (ref)
                if not Instance.Parent then
                    u4._shownTrove:Clean();
                end;
            end);
            u4._shownTrove:Add(function() -- Line: 116
                -- upvalues: u4 (ref), Instance (copy)
                if u4.Instance == Instance then
                    u4.Instance = nil;
                end;
            end);
        end;
    end;

    u4._trove:Connect(p2.ChildAdded, function(p5) -- Line: 124, Name: OnChildAdded
        -- upvalues: u3 (copy), u4 (copy), OnInstanceSet (copy)
        if p5.Name == u3 and not u4.Instance then
            u4.Instance = p5;
            OnInstanceSet();
        end;
    end);

    if u4.Instance then
        OnInstanceSet();
    end;

    return u4;
end;

function u1.primary(u6) -- Line: 146
    -- upvalues: u1 (copy), Trove (copy), Signal (copy)
    local u7 = {};
    setmetatable(u7, u1);
    u7._trove = Trove.new();
    u7._shown = u7._trove:Construct(Signal);
    u7._shownTrove = Trove.new();
    u7._trove:Add(u7._shownTrove);
    u7.Instance = u6.PrimaryPart;
    u7._trove:Connect(u6:GetPropertyChangedSignal("PrimaryPart"), function() -- Line: 157, Name: OnPrimaryPartChanged
        -- upvalues: u6 (copy), u7 (copy)
        local PrimaryPart = u6.PrimaryPart;
        u7._shownTrove:Clean();
        u7.Instance = PrimaryPart;

        if PrimaryPart then
            u7._shown:Fire(PrimaryPart, u7._shownTrove);
        end;
    end);

    if u7.Instance then
        local PrimaryPart = u6.PrimaryPart;
        u7._shownTrove:Clean();
        u7.Instance = PrimaryPart;

        if PrimaryPart then
            u7._shown:Fire(PrimaryPart, u7._shownTrove);
        end;
    end;

    return u7;
end;

function u1.Observe(p8, p9) -- Line: 184
    if p8.Instance then
        task.spawn(p9, p8.Instance, p8._shownTrove);
    end;

    return p8._shown:Connect(p9);
end;

function u1.Destroy(p10) -- Line: 196
    p10._trove:Destroy();
end;

return u1;