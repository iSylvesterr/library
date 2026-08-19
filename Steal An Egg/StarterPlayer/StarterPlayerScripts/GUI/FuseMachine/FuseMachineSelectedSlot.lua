-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.AssetItem);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
local AssetViewport = require(ReplicatedStorage.Library.Client.AssetViewport);
local Directory = require(ReplicatedStorage.Directory.Assets).Directory;
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
require(ReplicatedStorage.Library.Types.FuseMachine);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "FuseMachineSelectedSlot";

function u1.new(p2, p3, p4, u5, p6, u7) -- Line: 40
    -- upvalues: u1 (copy), Trove (copy), AssetItemSerialization (copy), AssetViewport (copy), Directory (copy), ButtonFX (copy)
    local v8 = setmetatable({}, u1);
    v8._frame = p2:Clone();
    v8._trove = Trove.new();
    v8._uid = u5;
    v8._frame.Name = `Selected.{p4}`;
    v8._frame.LayoutOrder = p4;
    v8._frame.Visible = true;
    v8._frame.Parent = p3;
    v8._trove:Add(v8._frame);
    local ViewportFrame = v8._frame.ViewportFrame;
    local v9 = ViewportFrame:IsA("ViewportFrame");
    assert(v9, "Fuse selected slot ViewportFrame must be a ViewportFrame");
    local v10 = AssetItemSerialization.Deserialize(p6);
    local v11 = AssetViewport.AttachItemDataOnViewport(v10, ViewportFrame, u1._getPresentationScale(v10.Scale), true);
    v8._trove:Add(v11);
    local v12 = Directory[p6.Category];
    local v13 = `Missing asset config {p6.Category}`;
    assert(v12 ~= nil, v13);
    local BrainrotName = v8._frame.BrainrotName;
    local v14 = BrainrotName:IsA("TextLabel");
    assert(v14, "Fuse selected slot BrainrotName must be a TextLabel");
    BrainrotName.Text = v12.DisplayName;
    v8:_applyMutation(p6);
    v8:_applyRarity(p6);
    local Return = v8._frame.Return;
    local v15 = Return:IsA("ImageButton");
    assert(v15, "Fuse selected slot Return must be an ImageButton");
    v8._trove:Add(Return.Activated:Connect(function() -- Line: 80
        -- upvalues: u7 (copy), u5 (copy)
        u7(u5);
    end));
    ButtonFX(Return);

    return v8;
end;

function u1._getPresentationScale(p16) -- Line: 91
    return math.clamp((p16 - 0.9) / 14.1, 0, 1) * 0.5 + 0.7;
end;

function u1._applyMutation(p17, p18) -- Line: 96
    -- upvalues: Mutations (copy)
    local Mutation = p17._frame.Mutation;
    local v19 = Mutation:IsA("TextLabel");
    assert(v19, "Fuse selected slot Mutation must be a TextLabel");
    local v20 = p18.BaseMutation or p18.Mutations[1];

    if v20 == nil or v20 == "None" then
        Mutation.Text = "";

        return;
    end;

    local v21 = Mutations.GetMutation(v20);
    Mutation.Text = Mutations.GetDisplayName(v20);

    if v21 then
        Mutation.TextColor3 = v21.Color;
    end;
end;

function u1._applyRarity(p22, p23) -- Line: 115
    -- upvalues: Directory (copy)
    local Rarity = p22._frame.Rarity;
    local v24 = Rarity:IsA("TextLabel");
    assert(v24, "Fuse selected slot Rarity must be a TextLabel");
    local v25 = Directory[p23.Category];
    local v26 = `Missing asset config {p23.Category}`;
    assert(v25 ~= nil, v26);

    for _, child in ipairs(Rarity:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;

    Rarity.Text = v25.Rarity.DisplayName;
    Rarity.TextColor3 = v25.Rarity.Color;

    if v25.Rarity.Gradient then
        v25.Rarity.Gradient:Clone().Parent = Rarity;
    end;
end;

function u1.GetUid(p27) -- Line: 139
    return p27._uid;
end;

function u1.Destroy(p28) -- Line: 143
    p28._trove:Destroy();
end;

return u1;