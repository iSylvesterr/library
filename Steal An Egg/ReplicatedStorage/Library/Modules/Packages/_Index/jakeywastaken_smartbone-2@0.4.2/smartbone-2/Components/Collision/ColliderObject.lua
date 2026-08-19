-- Decompiled with Potassium's decompiler.

local Collider = require(script.Parent:WaitForChild("Collider"));
local SB_VERBOSE_LOG = require(script.Parent.Parent.Parent:WaitForChild("Dependencies"):WaitForChild("Utilities")).SB_VERBOSE_LOG;
local u1 = {};
u1.__index = u1;

function u1.new(p2, u3) -- Line: 57
    -- upvalues: u1 (copy)
    local u4 = setmetatable({
        m_Awake = true,
        m_LastSleepCycle = 0,
        Destroyed = false,
        m_Object = u3,
        Colliders = {}
    }, u1);
    u4:m_LoadColliderTable(p2);
    u4.DestroyConnection = u3:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 68
        -- upvalues: u3 (copy), u4 (copy)
        if u3.Parent == nil then
            u4.Destroyed = true;
        end;
    end);

    return u4;
end;

function u1.m_LoadCollider(p5, p6) -- Line: 80
    -- upvalues: Collider (copy)
    local v7 = Vector3.new(p6.ScaleX, p6.ScaleY, p6.ScaleZ);
    local v8 = Vector3.new(p6.OffsetX, p6.OffsetY, p6.OffsetZ);
    local v9 = Vector3.new(p6.RotationX, p6.RotationY, p6.RotationZ);
    local v10 = Collider.new();
    v10.Scale = v7;
    v10.Offset = v8;
    v10.Rotation = v9;
    v10.Type = p6.Type;
    v10:SetObject(p5.m_Object);
    table.insert(p5.Colliders, v10);
end;

function u1.m_LoadColliderTable(p11, p12) -- Line: 98
    for _, v in p12 do
        p11:m_LoadCollider(v);
    end;
end;

function u1.GetObject(p13) -- Line: 108
    return p13.m_Object;
end;

function u1.GetCollisions(p14, p15, p16) -- Line: 116
    if not p14.m_Object then
        return {};
    end;

    if #p14.Colliders == 0 then
        return {};
    end;

    if os.clock() - p14.m_LastSleepCycle >= 0.2 then
        p14.m_LastSleepCycle = os.clock();

        if p14.m_Object:IsDescendantOf(workspace) then
            p14.m_Awake = true;
        else
            p14.m_Awake = false;
        end;
    end;

    if not p14.m_Awake then
        return {};
    end;

    local v17 = {};

    for _, v in p14.Colliders do
        local v18, v19, v20 = v:GetClosestPoint(p15, p16);

        if v18 then
            table.insert(v17, {
                ClosestPoint = v19,
                Normal = v20
            });
        end;
    end;

    return v17;
end;

function u1.Step(p21) -- Line: 175
    for _, v in p21.Colliders do
        v:Step();
    end;
end;

function u1.DrawDebug(p22, p23, p24, p25, p26) -- Line: 190
    for _, v in p22.Colliders do
        v:DrawDebug(p22, p23, p24, p25, p26);
        v.InNarrowphase = false;
    end;
end;

function u1.Destroy(p27) -- Line: 198
    -- upvalues: SB_VERBOSE_LOG (copy)
    task.synchronize();
    SB_VERBOSE_LOG((`Collider object destroying, object: {p27.m_Object}`));
    p27.DestroyConnection:Disconnect();

    if #p27.Colliders ~= 0 then
        for _, v in p27.Colliders do
            v:Destroy();
        end;
    end;

    setmetatable(p27, nil);
    task.desynchronize();
end;

return u1;