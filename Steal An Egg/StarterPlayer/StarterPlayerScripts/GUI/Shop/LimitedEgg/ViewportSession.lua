-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local AssetViewport = require(ReplicatedStorage.Library.Client.AssetViewport);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local GradientSwap = require(ReplicatedStorage.Library.Functions.GradientSwap);
require(ReplicatedStorage.Directory.LimitedEgg.Types.Interface);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types.Interface);
local Directory = Assets.Directory;
local u1 = Log.new();
local v2 = {};

local function getViewportExtent(p3) -- Line: 57
    local AbsoluteSize = p3.Frame.AbsoluteSize;
    local v4 = math.max(AbsoluteSize.X * AbsoluteSize.Y, 1);

    return math.sqrt(v4);
end;

local function getViewportScale(p5, p6) -- Line: 62
    return math.min((p5 / p6 - 1) * 0.3, 0.08000000000000007) + 1;
end;

local function getTargetYaw(p7) -- Line: 67
    return 0.2617993877991494 - 0.6666666666666666 * math.atan(p7 * 1.5);
end;

local function getCameraFraming(p8, p9, p10) -- Line: 74
    local v11 = p8.Position - p9;

    return Vector2.new(v11.X, v11.Z).Magnitude / p10, v11.Y / p10;
end;

local function addViewportState(p12, p13, p14, p15, p16, p17) -- Line: 79
    -- upvalues: AssetViewport (copy)
    p13.Chance.Text = string.format("%.0f%%", p15);
    local v18 = AssetViewport.Create(p13.Frame);
    v18.Name = "LimitedEggAssetViewport";
    p12:Add(v18);
    local _, v19, v20 = AssetViewport.AttachOnViewport(p14, v18, true);
    local v21 = `Limited egg asset model "{p14}" is not replicated`;
    assert(v19 ~= nil, v21);
    local v22 = `Limited egg asset model "{p14}" did not attach`;
    assert(v20 ~= nil, v22);
    local v23 = v18:Clone();
    v23.Name = "LimitedEggAssetViewportShadow";
    v23.Position = UDim2.fromScale(0.45, 0.54);
    v23.ImageColor3 = Color3.new(0, 0, 0);
    v23.ImageTransparency = 0.5;
    v23.ZIndex = v18.ZIndex - 1;
    v23.Parent = p13.Frame;
    p12:Add(v23);
    local v24 = v23:FindFirstChildWhichIsA("WorldModel");
    assert(v24 ~= nil, "Limited egg shadow viewport requires its cloned WorldModel");
    local v25 = v24:FindFirstChildWhichIsA("Model");
    assert(v25 ~= nil, "Limited egg shadow viewport requires its cloned asset model");
    local v26 = AssetViewport.PlayIdleAnimation(p14, v25);
    local v27 = `Limited egg shadow asset "{p14}" requires an Idle animation and Animator`;
    assert(v26 ~= nil, v27);
    p12:Add(v26);
    local v28 = v23:FindFirstChildWhichIsA("Camera");
    assert(v28 ~= nil, "Limited egg shadow viewport requires its cloned camera");
    v23.CurrentCamera = v28;
    local Rotation = v20:GetPivot().Rotation;
    local Rotation2 = v25:GetPivot().Rotation;
    local v29, v30 = v20:GetBoundingBox();
    local v31, v32 = v25:GetBoundingBox();
    local v33 = v29.Position - Rotation.UpVector * v30.Y * p17;
    local v34 = v31.Position - Rotation2.UpVector * v32.Y * p17;
    local v35 = v19.CFrame.Position - v33;
    local v36 = Vector2.new(v35.X, v35.Z).Magnitude / p16;
    local v37 = v35.Y / p16;
    local v38 = v28.CFrame.Position - v34;
    local v39 = Vector2.new(v38.X, v38.Z).Magnitude / p16;
    local v40 = v38.Y / p16;
    local v41 = 0.2617993877991494;
    AssetViewport.SetLocalCameraOrbit(v19, Rotation, v33, v36, v37, v41, 0);
    AssetViewport.SetLocalCameraOrbit(v28, Rotation2, v34, v39, v40, v41, 0);

    return {
        Pitch = 0,
        Camera = v19,
        ShadowCamera = v28,
        ModelRotation = Rotation,
        ShadowModelRotation = Rotation2,
        Focus = v33,
        ShadowFocus = v34,
        HorizontalDistance = v36,
        ShadowHorizontalDistance = v39,
        BaseHeight = v37,
        ShadowBaseHeight = v40,
        Yaw = v41
    };
end;

local function stepCameras(p42, p43, p44) -- Line: 153
    -- upvalues: UserInputService (copy), AssetViewport (copy)
    local v45 = UserInputService:GetMouseLocation();
    local AbsoluteSize = p42.AbsoluteSize;
    local v46 = p42.AbsolutePosition + AbsoluteSize * 0.5;
    local v47 = (v45.X - v46.X) / math.max(AbsoluteSize.X * 0.5, 1);
    local v48 = (v45.Y - v46.Y) / math.max(AbsoluteSize.Y * 0.5, 1);
    local v49 = 0.2617993877991494 - 0.6666666666666666 * math.atan(v47 * 1.5);
    local v50 = math.clamp(v48 * 0.5235987755982988, -0.4363323129985824, 0.4363323129985824);
    local v51 = 1 - math.exp(p44 * -9);

    for _, v in ipairs(p43) do
        v.Yaw = v.Yaw + (v49 - v.Yaw) * v51;
        v.Pitch = v.Pitch + (v50 - v.Pitch) * v51;
        AssetViewport.SetLocalCameraOrbit(v.Camera, v.ModelRotation, v.Focus, v.HorizontalDistance, v.BaseHeight, v.Yaw, v.Pitch);
        AssetViewport.SetLocalCameraOrbit(v.ShadowCamera, v.ShadowModelRotation, v.ShadowFocus, v.ShadowHorizontalDistance, v.ShadowBaseHeight, v.Yaw, v.Pitch);
    end;
end;

function v2.Start(p52, u53, p54, p55) -- Line: 192
    -- upvalues: Asserts (copy), Directory (copy), GradientSwap (copy), addViewportState (copy), RenderStepped (copy), stepCameras (copy), u1 (copy)
    Asserts.table(p52);
    Asserts.GuiObject(u53);
    assert(#p55 == 6, "Limited egg viewport session requires six entries");
    assert(#p54 == #p55, "Limited egg viewport session requires one authored slot per entry");
    local v56 = 0;

    for _, v in ipairs(p55) do
        assert(v.Weight > 0, "Limited egg drop weights must be positive");
        v56 = v56 + v.Weight;
    end;

    assert(v56 > 0, "Limited egg drop table total weight must be positive");
    local v57 = (1 / 0);

    for _, v in ipairs(p54) do
        local AbsoluteSize = v.Frame.AbsoluteSize;
        local v58 = math.max(AbsoluteSize.X * AbsoluteSize.Y, 1);
        local v59 = math.sqrt(v58);
        v57 = math.min(v57, v59);
    end;

    local u60 = {};

    for i, v in ipairs(p55) do
        local v61 = p54[i];
        local v62 = Directory[v.AssetId];
        local Shadow = v61.Frame:WaitForChild("Shadow");
        local v63 = Shadow:IsA("ImageLabel");
        local v64 = `Limited egg slot {v61.Frame.Name}.Shadow must be an ImageLabel`;
        assert(v63, v64);
        local Gradient = Shadow:WaitForChild("Gradient");
        local v65 = Gradient:IsA("UIGradient");
        local v66 = `Limited egg slot {v61.Frame.Name}.Shadow.Gradient must be a UIGradient`;
        assert(v65, v66);
        local u67 = Gradient:Clone();
        GradientSwap(Shadow, v62.Rarity.Gradient);
        p52:Add(function() -- Line: 228
            -- upvalues: GradientSwap (ref), Shadow (copy), u67 (copy)
            GradientSwap(Shadow, u67);
            u67:Destroy();
        end);
        local AbsoluteSize = v61.Frame.AbsoluteSize;
        local v68 = math.max(AbsoluteSize.X * AbsoluteSize.Y, 1);
        local v69 = (math.sqrt(v68) / v57 - 1) * 0.3;
        local v70 = (math.min(v69, 0.08000000000000007) + 1) * v62.LimitedEggViewportScale;
        local v71 = addViewportState(p52, v61, v.AssetId, v.Weight / v56 * 100, v70, v62.LimitedEggViewportVerticalOffset);
        table.insert(u60, v71);
    end;

    local u73 = RenderStepped(function(p72) -- Line: 246
        -- upvalues: stepCameras (ref), u53 (copy), u60 (copy)
        stepCameras(u53, u60, p72);

        return false;
    end);
    p52:Add(function() -- Line: 250
        -- upvalues: u73 (copy)
        u73:Destroy();
    end);
    u1:AtTrace():Log("Limited egg viewport session opened");
end;

return v2;