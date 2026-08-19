-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EasyVisuals = require(ReplicatedStorage.Library.Client.GUIFX.EasyVisuals);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Player = require(ReplicatedStorage.Library.Player);
local u1 = {};

local function start(u2) -- Line: 25
    -- upvalues: u1 (copy), Player (copy), EasyVisuals (copy), Asserts (copy)
    if u1[u2] ~= nil or not (u2:IsA("UIGradient") and (u2:IsDescendantOf(workspace) or u2:IsDescendantOf(Player.PlayerGui()))) then
        return;
    end;

    local Parent = u2.Parent;

    if not (Parent and Parent:IsA("GuiObject")) then
        return;
    end;

    local v3 = u2:GetAttribute("__gradient_style");
    local v4;

    if typeof(v3) == "string" and v3 ~= "" then
        v4 = v3 ~= "Wrapper";
    else
        v4 = false;
    end;

    local v5;

    if v4 then
        v5 = nil;
    else
        v5 = u2.Color;
    end;

    local v6 = u2:GetAttribute("__custom_rotation");
    local v7 = EasyVisuals.new(Parent, v4 and v3 and v3 or "Wrapper", 0.35, nil, nil, v5);

    if v6 then
        Asserts.number(v6);

        for _, v in v7.EffectObjects do
            if v.__class == "Gradient" then
                v:SetRotation(v6, 1);
            end;
        end;
    end;

    local v8 = {};
    table.insert(v8, Parent.AncestryChanged:Connect(function() -- Line: 61
        -- upvalues: Parent (copy), u1 (ref), u2 (copy)
        local v9 = not Parent:IsDescendantOf(game) and u1[u2];

        if v9 then
            v9.effect:Destroy();

            for _, v in v9.conns do
                v:Disconnect();
            end;

            u1[u2] = nil;
        end;
    end));
    u1[u2] = {
        node = u2,
        target = Parent,
        effect = v7,
        conns = v8
    };
end;

local function stop(p10) -- Line: 84
    -- upvalues: u1 (copy)
    local v11 = u1[p10];

    if not v11 then
        return;
    end;

    v11.effect:Destroy();

    for _, v in v11.conns do
        v:Disconnect();
    end;

    u1[p10] = nil;
end;

for _, v in CollectionService:GetTagged("Rainbow_Gradient") do
    start(v);
end;

CollectionService:GetInstanceAddedSignal("Rainbow_Gradient"):Connect(start);
CollectionService:GetInstanceRemovedSignal("Rainbow_Gradient"):Connect(stop);