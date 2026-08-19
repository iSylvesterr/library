-- Decompiled with Potassium's decompiler.

local u1 = {};
local easingFunctions = require(script.Parent.easingFunctions);
local Effects = script.Parent.Effects;
local _, _, v2 = require(Effects.vignette)();
v2.ImageTransparency = 1;
local u3 = {
    Letterbox = require(Effects.letterbox)(),
    Vignette = v2,
    ["Screen Cover"] = require(Effects.screen_cover)(),
    Subtitles = require(Effects.subtitle)()
};

function u1.getObjectFromPath(p4, p5) -- Line: 27
    -- upvalues: u3 (copy)
    if p4.ItemType and p4.ItemType == "Camera" then
        return workspace.CurrentCamera;
    end;

    if p4.InstanceNames[3] == "MoonAnimatorEffects" and u3[p4.InstanceNames[4]] then
        return u3[p4.InstanceNames[4]];
    end;

    local v6 = p4.InstanceNames and p4.InstanceNames[2];
    local v7;

    if p5 == nil then
        v7 = false;
    else
        v7 = v6 == "Workspace";
    end;

    if not v7 then
        p5 = game;
    end;

    local v8 = v7 and 2 or 1;

    for i, v in p4.InstanceNames do
        if i > v8 then
            local v9 = true;

            for _, child in p5:GetChildren() do
                if child.Name == v and child:IsA(p4.InstanceTypes[i]) then
                    p5 = child;
                    v9 = nil;
                    break;
                end;
            end;

            if v9 then
                return;
            end;
        end;
    end;

    return p5;
end;

local function findFirstDescendantWhichIsAOfName(p10, p11, p12) -- Line: 79
    for _, descendant in p12:GetDescendants() do
        if descendant:IsA(p10) and descendant.Name == p11 then
            return descendant;
        end;
    end;
end;

function u1.getMotor(p13, p14) -- Line: 93
    -- upvalues: findFirstDescendantWhichIsAOfName (copy)
    local v15 = string.split(p14, ".");
    local v16 = findFirstDescendantWhichIsAOfName("BasePart", v15[#v15], p13);

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("Motor6D") and descendant.Part1.Name == v16.Name then
            return descendant;
        end;
    end;
end;

function u1.getEase(p17) -- Line: 112
    -- upvalues: easingFunctions (copy)
    local v18 = p17 or {};
    v18[1] = v18[1] or "Linear";
    v18[2] = v18[2] or "";

    return easingFunctions[v18[1] .. v18[2]];
end;

function u1.getFrames(p19, p20) -- Line: 126
    local v21 = {};

    for i in p20 do
        if tonumber(i) then
            table.insert(v21, i);
        end;
    end;

    table.sort(v21);
    local v22 = nil;
    local v23 = nil;

    for i, v in v21 do
        if p19 < v then
            v22 = i - 1;
            v23 = i;
            break;
        end;
    end;

    local v24 = v21[v22];
    local v25 = v21[v23];

    return v21, p20[v24], v24 or 0, p20[v25], v25;
end;

function u1.getKeyFrames(p26) -- Line: 156
    -- upvalues: u1 (copy)
    local v27 = {
        Rig = {},
        Properties = {}
    };

    for i, v in p26.objs do
        for i2, v3 in v do
            if i2 == "Rig" then
                for _, v4 in v3 do
                    for i3, v5 in v4 do
                        local v28 = u1.getMotor(p26.instances[i], i3);
                        v27.Rig[v28] = v5;
                    end;
                end;
            else
                v27.Properties[p26.instances[i]] = { i2, v3 };
            end;
        end;
    end;

    return v27;
end;

return u1;