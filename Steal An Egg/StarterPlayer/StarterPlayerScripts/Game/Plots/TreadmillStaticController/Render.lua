-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
local TreadmillStaticCover = require(ReplicatedStorage.Library.Client.UI.TreadmillStaticCover);
local TreadmillStaticRateSign = require(ReplicatedStorage.Library.Client.UI.TreadmillStaticRateSign);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
require(ReplicatedStorage.Library.Client.TreadmillVideoController.Types.Interface);
require(script.Parent.Types.Interface);
local Treadmills2 = ReplicatedStorage.Assets.Models.Treadmills;
local u7 = {
    SetGroundedScale = function(p1, p2) -- Line: 30, Name: SetGroundedScale
        -- upvalues: Asserts (copy), TreadmillUtil (copy)
        Asserts.table(p1);
        Asserts.number(p2);
        p1.Model:ScaleTo(p2);
        local Root = p1.Model.Root;
        local v3 = Root:IsA("BasePart");
        local v4 = `Treadmill "{p1.TreadmillId}" Root must be a BasePart`;
        assert(v3, v4);
        local v5 = p1.Model:GetPivot():ToObjectSpace(Root.CFrame);
        local v6 = TreadmillUtil.ResolveGroundedToolRootCFrameAtLocation(p1.Bottom, p1.Model);
        p1.Model:PivotTo(v6 * v5:Inverse());
    end
};

function u7.Build(p8, p9, p10, p11, p12, p13) -- Line: 41
    -- upvalues: Asserts (copy), Workspace (copy), Treadmills (copy), Treadmills2 (copy), TreadmillStaticRateSign (copy), TreadmillUtil (copy), TreadmillStaticCover (copy), u7 (copy)
    Asserts.number(p8);
    Asserts.number(p9);
    Asserts.table(p10);
    Asserts.number(p11);
    Asserts.boolean(p12);
    Asserts.Folder(p13);
    local Plots = Workspace.Plots;
    local v14 = Plots:IsA("Folder");
    assert(v14, "Treadmill rendering requires the plots folder");
    local v15 = Plots[tostring(p8)];
    local v16 = v15:IsA("Model");
    local v17 = `Plot "{p8}" must be a Model`;
    assert(v16, v17);
    local TreadmillBottom = v15.TreadmillBottom;
    local v18 = TreadmillBottom:IsA("BasePart");
    local v19 = `Plot "{p8}" TreadmillBottom must be a BasePart`;
    assert(v18, v19);
    local v20 = Treadmills.GetByUpgradeLevel(p10.TreadmillUpgradeLevel);
    local v21 = `Invalid treadmill upgrade level {p10.TreadmillUpgradeLevel}`;
    assert(v20 ~= nil, v21);
    local v22 = Treadmills2[v20._id];
    local v23 = v22:IsA("Tool");
    local v24 = `Treadmill render template "{v20._id}" must be a Tool`;
    assert(v23, v24);
    local v25 = v22:Clone();
    v25.Name = `TreadmillRender_{p8}`;
    v25.Parent = p13;

    for _, descendant in ipairs(v25:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = true;
            descendant.CanTouch = false;
        elseif descendant:IsA("BaseScript") then
            descendant:Destroy();
        end;
    end;

    local v26 = TreadmillStaticRateSign.Apply(v25, v20.Rarity.Color, v20.SpeedMultiplier);
    local v27 = TreadmillUtil.FindVideoFeedScreenPart(v25);
    local v28;

    if p12 and v27 ~= nil then
        v28 = TreadmillStaticCover.Create(`StaticTreadmillCover_{p8}`, v27);
        TreadmillStaticCover.ApplyFeed(v28, p10.TreadmillMediaFeedState);
    else
        v28 = nil;
    end;

    local v29 = {
        Bottom = TreadmillBottom,
        Cover = v28,
        Model = v25,
        OwnerUserId = p9,
        RateSign = v26,
        Slot = p8,
        TreadmillId = v20._id
    };
    u7.SetGroundedScale(v29, v25:GetScale() * p11);

    return v29;
end;

return u7;