-- Decompiled with Potassium's decompiler.

local u1 = {
    Type = "Camera",
    Internal = {},
    Instances = {},
    Interface = {},
    Prototype = {}
};

function u1.Prototype.OnActivated(p2) -- Line: 26
end;

function u1.Prototype.OnDeactivated(p3) -- Line: 42
end;

function u1.Prototype.OnRenderStepped(p4) -- Line: 58
end;

function u1.Prototype.InvokeLifecycleMethod(p5, p6, ...) -- Line: 77
    if p5[p6] then
        return p5[p6](p5, ...);
    end;
end;

function u1.Prototype.ToString(p7) -- Line: 95
    -- upvalues: u1 (copy)
    return `{u1.Type}<"{p7.Name}">`;
end;

function u1.Interface.wrap(p8, p9) -- Line: 116
    -- upvalues: u1 (copy)
    local v10 = type(p8) == "string";
    local v11 = `Expected parameter #1 'name' to be a string, got {type(p8)}`;
    assert(v10, v11);
    local v12 = type(p9) == "userdata";
    local v13 = `Expected parameter #2 'cameraInstance' to be a userdata, got {type(p9)}`;
    assert(v12, v13);
    local v14 = p9:IsA("Camera");
    local v15 = `Expected parameter #2 'cameraInstance' to be a camera instance, got {p9.ClassName}`;
    assert(v14, v15);
    local v17 = setmetatable({
        Name = p8,
        Instance = p9
    }, {
        __index = u1.Prototype,
        __type = u1.Type,

        __tostring = function(p16) -- Line: 134, Name: __tostring
            return p16:ToString();
        end
    });
    v17.Instance.Name = `Camera<"{v17.Name}">`;

    if workspace.CurrentCamera == v17.Instance then
        v17:InvokeLifecycleMethod("OnActivated", v17.Instance);
    end;

    local v18 = not u1.Instances[p8];
    local v19 = `Expected {p8} to be unique, are you sure this isn't a duplicate Camera?`;
    assert(v18, v19);
    u1.Instances[p8] = v17;

    return u1.Instances[p8];
end;

function u1.Interface.new(p20) -- Line: 164
    -- upvalues: u1 (copy)
    return u1.Interface.wrap(p20, Instance.new("Camera"));
end;

function u1.Interface.is(p21) -- Line: 187
    -- upvalues: u1 (copy)
    if not p21 or type(p21) ~= "table" then
        return false;
    end;

    local v22 = getmetatable(p21);

    if v22 then
        v22 = v22.__type == u1.Type;
    end;

    return v22;
end;

function u1.Interface.get(p23) -- Line: 210
    -- upvalues: u1 (copy)
    return u1.Instances[p23];
end;

return u1.Interface;