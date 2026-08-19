-- Decompiled with Potassium's decompiler.

local u1 = Vector2.new(2262, 862);
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
Players.LocalPlayer:WaitForChild("PlayerGui", 100);
local CurrentCamera = workspace.CurrentCamera;

local function getBox(p2) -- Line: 61
    return math.min(p2.X, p2.Y);
end;

local function getScreenRatio() -- Line: 69
    -- upvalues: CurrentCamera (copy), u1 (copy)
    local ViewportSize = CurrentCamera.ViewportSize;
    local v3 = u1;

    return math.min(ViewportSize.X, ViewportSize.Y) / math.min(v3.X, v3.Y);
end;

local function tagRecursive(p4, u5, u6) -- Line: 80
    -- upvalues: tagRecursive (copy)
    if p4:IsA(u5) then
        p4:AddTag(u6);
    end;

    for _, child in p4:GetChildren() do
        tagRecursive(child, u5, u6);
    end;

    p4.ChildAdded:Connect(function(p7) -- Line: 87
        -- upvalues: tagRecursive (ref), u5 (copy), u6 (copy)
        tagRecursive(p7, u5, u6);
    end);
end;

local function getInstancePosition(p8) -- Line: 97
    if p8:IsA("Part") then
        return p8.Position;
    end;

    return not p8:IsA("Model") and Vector3.new(0, 0, 0) or p8:GetPivot().Position;
end;

local function initTaggedUIStroke(p9) -- Line: 113
    -- upvalues: CurrentCamera (copy), u1 (copy)
    if p9:IsA("UIStroke") then
        if not p9:GetAttribute("OriginalThickness") then
            p9:SetAttribute("OriginalThickness", p9.Thickness);
        end;

        if p9:HasTag("ScreenStroke") then
            local ViewportSize = CurrentCamera.ViewportSize;
            local v10 = u1;
            p9.Thickness = p9.Thickness * (math.min(ViewportSize.X, ViewportSize.Y) / math.min(v10.X, v10.Y));
        end;

        return;
    end;

    p9:RemoveTag("ScreenStroke");
    p9:RemoveTag("UIStroke");
end;

for _, v in CollectionService:GetTagged("UIStroke") do
    initTaggedUIStroke(v);
end;

CollectionService:GetInstanceAddedSignal("UIStroke"):Connect(initTaggedUIStroke);

for _, v in CollectionService:GetTagged("ScreenStroke") do
    v:AddTag("UIStroke");
end;

CollectionService:GetInstanceAddedSignal("ScreenStroke"):Connect(function(p11) -- Line: 147
    p11:AddTag("UIStroke");
end);

for _, v in CollectionService:GetTagged("ScreenGui") do
    if v:IsA("ScreenGui") then
        tagRecursive(v, "UIStroke", "ScreenStroke");
    else
        v:RemoveTag("ScreenGui");
    end;
end;

CollectionService:GetInstanceAddedSignal("ScreenGui"):Connect(function(p12) -- Line: 162
    -- upvalues: tagRecursive (copy)
    if not p12:IsA("ScreenGui") then
        return;
    end;

    tagRecursive(p12, "UIStroke", "ScreenStroke");
end);
CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 171, Name: updateScreenGuiStrokes
    -- upvalues: CollectionService (copy), CurrentCamera (copy), u1 (copy)
    for _, v in CollectionService:GetTagged("ScreenStroke") do
        local v13 = v:GetAttribute("OriginalThickness");

        if v13 then
            local ViewportSize = CurrentCamera.ViewportSize;
            local v14 = u1;
            v.Thickness = v13 * (math.min(ViewportSize.X, ViewportSize.Y) / math.min(v14.X, v14.Y));
        end;
    end;
end);
local u15 = {};

local function recurseGetUIStrokes(p16, u17) -- Line: 194
    -- upvalues: u15 (copy), recurseGetUIStrokes (copy)
    if p16:IsA("UIStroke") then
        p16:AddTag("UIStroke");
        table.insert(u15[u17], p16);
    end;

    for _, child in p16:GetChildren() do
        recurseGetUIStrokes(child, u17);
    end;

    p16.ChildAdded:Connect(function(p18) -- Line: 202
        -- upvalues: recurseGetUIStrokes (ref), u17 (copy)
        recurseGetUIStrokes(p18, u17);
    end);
end;

local function initBillboard(u19) -- Line: 208
    -- upvalues: u15 (copy), recurseGetUIStrokes (copy)
    if not u19:IsA("BillboardGui") then
        u19:RemoveTag("Billboard");

        return;
    end;

    u15[u19] = {};
    u19.Destroying:Once(function() -- Line: 218
        -- upvalues: u15 (ref), u19 (copy)
        u15[u19] = nil;
    end);
    recurseGetUIStrokes(u19, u19);
end;

for _, v in CollectionService:GetTagged("Billboard") do
    initBillboard(v);
end;

CollectionService:GetInstanceAddedSignal("Billboard"):Connect(initBillboard);
local u20 = tick();
RunService.Heartbeat:Connect(function() -- Line: 238
    -- upvalues: u20 (ref), u15 (copy), CurrentCamera (copy), u1 (copy)
    if tick() - u20 < 1 then
        return;
    end;

    u20 = tick();

    for i, v in u15 do
        local Adornee = i.Adornee;
        local v21 = nil;

        if Adornee then
            if Adornee:IsA("Part") then
                v21 = Adornee.Position;
            else
                v21 = not Adornee:IsA("Model") and Vector3.new(0, 0, 0) or Adornee:GetPivot().Position;
            end;
        elseif i.Parent then
            local Parent = i.Parent;

            if Parent:IsA("Part") then
                v21 = Parent.Position;
            else
                v21 = not Parent:IsA("Model") and Vector3.new(0, 0, 0) or Parent:GetPivot().Position;
            end;
        end;

        if v21 then
            local Magnitude = (CurrentCamera.CFrame.Position - v21).Magnitude;

            if i.MaxDistance >= Magnitude then
                local v22 = (i:GetAttribute("Distance") or 10) / Magnitude;

                for _, v2 in v do
                    if not v2:IsDescendantOf(i) then
                        table.remove(v, table.find(v, v2));
                    end;

                    local v23 = v2:GetAttribute("OriginalThickness");

                    if v23 then
                        local ViewportSize = CurrentCamera.ViewportSize;
                        local v24 = u1;
                        v2.Thickness = v23 * v22 * (math.min(ViewportSize.X, ViewportSize.Y) / math.min(v24.X, v24.Y));
                    end;
                end;
            end;
        end;
    end;
end);

return {
    TagScreenGui = function(p25, p26) -- Line: 316, Name: TagScreenGui
        -- upvalues: CollectionService (copy)
        if p26:IsA("ScreenGui") then
            CollectionService:AddTag(p26, "ScreenGui");
        end;
    end,

    TagBillboardGui = function(p27, p28) -- Line: 326, Name: TagBillboardGui
        -- upvalues: CollectionService (copy)
        if p28:IsA("BillboardGui") then
            CollectionService:AddTag(p28, "Billboard");
        end;
    end
};