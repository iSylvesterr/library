-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local LocalPlayer = UtilsSystem.LocalPlayer;
local RunService = UtilsSystem.RunService;

if not UtilsSystem.DeviceType.IsMobile() then
    if RunService:IsStudio() then
        warn("[BillboardMobileStroke] 当前非手机端判定，脚本跳过。Studio 请开 Device Emulator 选手机后再测。");
    end;

    return;
end;

local function _isMobileScaleTarget(p1) -- Line: 51
    local Name = p1.Name;

    return (Name == "EnemyHp" or string.sub(Name, 1, 8) == "EnemyHp_") and true or Name == "Drop";
end;

local function _scaleTargetBillboard(p2) -- Line: 64
    local Name = p2.Name;

    if Name ~= "EnemyHp" and string.sub(Name, 1, 8) ~= "EnemyHp_" and Name ~= "Drop" or p2:GetAttribute("MobileBillboardSizeReduced") == true then
        return;
    end;

    p2:SetAttribute("MobileBillboardSizeReduced", true);
    local Size = p2.Size;
    p2.Size = UDim2.new(Size.X.Scale * 0.5, Size.X.Offset * 0.5, Size.Y.Scale * 0.5, Size.Y.Offset * 0.5);
end;

local function _reduceStrokeThickness(p3) -- Line: 85
    local v4 = p3:FindFirstAncestorOfClass("BillboardGui");
    local v5;

    if v4 then
        local Name = v4.Name;
        v5 = (Name == "EnemyHp" or string.sub(Name, 1, 8) == "EnemyHp_" or Name == "Drop") and 1 or 2;
    else
        v5 = 2;
    end;

    local v6 = p3:GetAttribute("MobileStrokeAppliedMax");

    if typeof(v6) == "number" and v6 <= v5 then
        return;
    end;

    p3:SetAttribute("MobileStrokeAppliedMax", v5);

    if v5 < p3.Thickness then
        p3.Thickness = v5;
    end;
end;

local function _processBillboard(p7) -- Line: 108
    -- upvalues: _scaleTargetBillboard (copy), _reduceStrokeThickness (copy)
    _scaleTargetBillboard(p7);

    if p7:GetAttribute("MobileStrokeWatching") == true then
        return;
    end;

    p7:SetAttribute("MobileStrokeWatching", true);

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("UIStroke") then
            _reduceStrokeThickness(descendant);
        end;
    end;

    p7.DescendantAdded:Connect(function(p8) -- Line: 122
        -- upvalues: _reduceStrokeThickness (ref)
        if p8:IsA("UIStroke") then
            _reduceStrokeThickness(p8);
        end;
    end);
end;

local function _onDescendant(p9) -- Line: 135
    -- upvalues: _processBillboard (copy), _reduceStrokeThickness (copy)
    if p9:IsA("BillboardGui") then
        _processBillboard(p9);

        return;
    end;

    if p9:IsA("UIStroke") and p9:FindFirstAncestorOfClass("BillboardGui") then
        _reduceStrokeThickness(p9);
    end;
end;

local function _watchRoot(p10) -- Line: 153
    -- upvalues: _processBillboard (copy), _reduceStrokeThickness (copy), _onDescendant (copy)
    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("BillboardGui") then
            _processBillboard(descendant);
        elseif descendant:IsA("UIStroke") and descendant:FindFirstAncestorOfClass("BillboardGui") then
            _reduceStrokeThickness(descendant);
        end;
    end;

    p10.DescendantAdded:Connect(_onDescendant);
end;

local v11 = workspace;

for _, descendant in v11:GetDescendants() do
    if descendant:IsA("BillboardGui") then
        _processBillboard(descendant);
    elseif descendant:IsA("UIStroke") and descendant:FindFirstAncestorOfClass("BillboardGui") then
        _reduceStrokeThickness(descendant);
    end;
end;

v11.DescendantAdded:Connect(_onDescendant);
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));

for _, descendant in PlayerGui:GetDescendants() do
    if descendant:IsA("BillboardGui") then
        _processBillboard(descendant);
    elseif descendant:IsA("UIStroke") and descendant:FindFirstAncestorOfClass("BillboardGui") then
        _reduceStrokeThickness(descendant);
    end;
end;

PlayerGui.DescendantAdded:Connect(_onDescendant);