-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = { "SoundId", "Volume", "RollOff", "Playing" };
local u3 = {};

local function isBoomboxEmitter(p4) -- Line: 31
    if not p4:IsA("BasePart") then
        return false;
    end;

    if string.sub(p4.Name, 1, 8) ~= "Boombox_" then
        return false;
    end;

    local Parent = p4.Parent;
    local v5;

    if Parent == nil then
        v5 = false;
    else
        v5 = Parent.Name == "BoomboxEmitters";
    end;

    return v5;
end;

local function applyAttributes(p6, p7) -- Line: 38
    local v8 = p6:GetAttribute("SoundId");
    local v9 = p6:GetAttribute("Volume");
    local v10 = p6:GetAttribute("RollOff");
    local v11 = p6:GetAttribute("Playing");

    if type(v10) == "number" then
        p7.RollOffMaxDistance = v10;
    end;

    if type(v9) == "number" then
        p7.Volume = v9;
    end;

    if type(v8) == "string" and p7.SoundId ~= v8 then
        p7.SoundId = v8;
        p7.TimePosition = 0;
    end;

    local v12;

    if v11 == true and type(v8) == "string" then
        v12 = v8 ~= "";
    else
        v12 = false;
    end;

    p7.Playing = v12;
end;

local function unregister(p13) -- Line: 57
    -- upvalues: u3 (copy)
    local v14 = u3[p13];

    if not v14 then
        return;
    end;

    for _, v in v14.Connections do
        v:Disconnect();
    end;

    v14.Sound:Destroy();
    u3[p13] = nil;
end;

local function register(u15) -- Line: 67
    -- upvalues: u3 (copy), u2 (copy), applyAttributes (copy)
    if u3[u15] then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "BoomboxSound";
    Sound.Looped = true;
    Sound.Parent = u15;
    local v16 = {};

    for _, v in u2 do
        local v17 = u15:GetAttributeChangedSignal(v);
        table.insert(v16, v17:Connect(function() -- Line: 77
            -- upvalues: applyAttributes (ref), u15 (copy), Sound (copy)
            applyAttributes(u15, Sound);
        end));
    end;

    table.insert(v16, u15.AncestryChanged:Connect(function() -- Line: 81
        -- upvalues: u15 (copy), u3 (ref)
        if not u15:IsDescendantOf(workspace) then
            local v18 = u15;
            local v19 = u3[v18];

            if not v19 then
                return;
            end;

            for _, v in v19.Connections do
                v:Disconnect();
            end;

            v19.Sound:Destroy();
            u3[v18] = nil;
        end;
    end));
    u3[u15] = {
        Sound = Sound,
        Connections = v16
    };
    applyAttributes(u15, Sound);
end;

local function onDescendantAdded(p20) -- Line: 91
    -- upvalues: register (copy)
    local v21;

    if p20:IsA("BasePart") and string.sub(p20.Name, 1, 8) == "Boombox_" then
        local Parent = p20.Parent;

        if Parent == nil then
            v21 = false;
        else
            v21 = Parent.Name == "BoomboxEmitters";
        end;
    else
        v21 = false;
    end;

    if v21 then
        register(p20);
    end;
end;

function v1.Init(p22) -- Line: 97
end;

function v1.Start(p23) -- Line: 100
    -- upvalues: register (copy), onDescendantAdded (copy)
    for _, descendant in workspace:GetDescendants() do
        local v24;

        if descendant:IsA("BasePart") and string.sub(descendant.Name, 1, 8) == "Boombox_" then
            local Parent = descendant.Parent;

            if Parent == nil then
                v24 = false;
            else
                v24 = Parent.Name == "BoomboxEmitters";
            end;
        else
            v24 = false;
        end;

        if v24 then
            register(descendant);
        end;
    end;

    workspace.DescendantAdded:Connect(onDescendantAdded);
end;

return v1;