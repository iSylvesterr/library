-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {};
local u2 = false;

local function create(p3, p4) -- Line: 5
    -- upvalues: u1 (copy)
    local v5 = p4:lower();

    if v5 ~= "mouse1down" and (v5 ~= "mouse1up" and (v5 ~= "mouse1click" and (v5 ~= "mouse2down" and (v5 ~= "mouse2up" and v5 ~= "mouse2click")))) then
        error("Functions.Clicked - \"" .. v5 .. "\" is an invalid event type. Check spelling!");
    end;

    local v6 = u1[p3];

    if not v6 then
        v6 = {};
        u1[p3] = v6;
    end;

    local v7 = v6[v5];

    if v7 then
        return v7;
    end;

    local BindableEvent = Instance.new("BindableEvent");
    v6[v5] = BindableEvent;

    return BindableEvent;
end;

local function fire(p8) -- Line: 31
    -- upvalues: Players (copy), u1 (copy)
    local v9 = p8:lower();
    local Target = Players.LocalPlayer:GetMouse().Target;
    local v10 = Target.ClassName == "Folder" and true or Target.ClassName == "Model";

    if Target and Target.Parent then
        for i, v in pairs(u1) do
            if (v10 and (i.ClassName == "Folder" or i.ClassName == "Model") and Target:IsDescendantOf(i) or Target == i) and v[v9] then
                v[v9]:Fire();

                return;
            end;
        end;
    end;
end;

local function init() -- Line: 53
    -- upvalues: u2 (ref), Players (copy), fire (copy)
    u2 = true;
    local u11 = Players.LocalPlayer:GetMouse();
    u11.Button1Down:Connect(function() -- Line: 56
        -- upvalues: fire (ref), u11 (copy)
        fire("mouse1down");
        u11.Button1Up:Wait();
        fire("mouse1click");
    end);
    u11.Button1Up:Connect(function() -- Line: 61
        -- upvalues: fire (ref)
        fire("mouse1up");
    end);
    u11.Button2Down:Connect(function() -- Line: 64
        -- upvalues: fire (ref), u11 (copy)
        fire("mouse2down");
        u11.Button2Up:Wait();
        fire("mouse2click");
    end);
    u11.Button2Up:Connect(function() -- Line: 69
        -- upvalues: fire (ref)
        fire("mouse2up");
    end);
end;

return function(p12, p13) -- Line: 74
    -- upvalues: u2 (ref), init (copy), create (copy)
    if not u2 then
        init();
    end;

    return create(p12, p13 or "mouse1click");
end;